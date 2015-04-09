# Install the newrelic haproxy agent
# Example:
# 

class newrelic_plugins::haproxy (
  
  $license_key,
  $base_install   = false,
  $haproxy_agent  = {},

){

  package { 'make':
    ensure => present,
  }

  package { 'newrelic_haproxy_agent':
    ensure    => present,
    provider  => 'gem',
    require   => Package['make'],
  }

  package { 'newrelic_plugin':
    ensure    => present,
    provider  => 'gem',
    require   => Package['make'],
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

  exec {'newrelic_haproxy_agent_config':
    command  => '/usr/local/bin/newrelic_haproxy_agent install',
    require  => Package['bundler','newrelic_plugin','newrelic_haproxy_agent'],
    creates  => '/etc/newrelic/newrelic_haproxy_agent.yml',
  }

  # Configure the yaml file
  file { '/etc/newrelic/newrelic/newrelic_haproxy_agent.yml':
    ensure    => file,
    mode      => '0644',
    content   => template('newrelic_plugins/haproxy/newrelic_haproxy_agent.yml.erb'),
  }

  service { 'newrelic_haproxy_plugin':
    ensure    => running,
    enable    => true,
    subscribe => File['newrelic_haproxy_agent_init','/etc/newrelic/newrelic/newrelic_haproxy_agent.yml'], 
  }

}
