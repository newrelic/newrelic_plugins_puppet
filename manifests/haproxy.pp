# Install the newrelic haproxy agent
# Example:
# 

class newrelic_plugins::haproxy (
  
  $license_key,
  $base_install   = false,
  $haproxy_agents = {},

){

  package { 'make':
    ensure => present,
  }

  package { 'newrelic_haproxy_agent':
    ensure    => present,
    provider  => 'gem',
    require   => Package['make','bundler'],
  }

  package { 'newrelic_plugin':
    ensure    => present,
    provider  => 'gem',
    require   => Package['make','bundler'],
  }

  package { 'bundler':
    ensure    => present,
    provider  => 'gem',
    require   => Package['make'],
  }

  file { 'newrelic_haproxy_agent_init':
    ensure  => file,
    path    => '/etc/init.d/newrelic_haproxy_plugin',
    mode    => '0755',
    owner   => 'root',
    group   => 'root',
    content => template('newrelic_plugins/haproxy/newrelic_haproxy_plugin.erb'),
  }

  if $base_install {
    # If base install then install the standard yml, no config
    exec {'base_install':
      command => '/usr/local/bin/newrelic_haproxy_agent run',
      creates => '/etc/newrelic/newrelic_haproxy_agent.yml',
      require => Package['newrelic_haproxy_agent','newrelic_plugin'],
    }
  }

  else {  
    # Configure the yaml file - requires that haproxy_agents hash is not empty
    file { '/etc/newrelic/newrelic_haproxy_agent.yml':
      ensure    => file,
      mode      => '0644',
      content   => template('newrelic_plugins/haproxy/newrelic_haproxy_agent.yml.erb'),
      require => Package['newrelic_haproxy_agent','newrelic_plugin'],
    }
  }

  service { 'newrelic_haproxy_plugin':
    ensure    => running,
    enable    => true,
    subscribe => File['newrelic_haproxy_agent_init','/etc/newrelic/newrelic_haproxy_agent.yml'], 
  }
}
