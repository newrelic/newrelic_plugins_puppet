class newrelic_plugins::haproxy (
  
  $license_key,

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

  exec {'newrelic_haproxy_agent_config':
    command => '/usr/local/bin/newrelic_haproxy_agent install',
    require => Package['bundler','newrelic_plugin','newrelic_haproxy_agent'],
    create  => '/etc/newrelic/newrelic_haproxy_agent.yml',
  }

  service { 'newrelic_haproxy_agent':
    ensure    => running,
    start     => '/usr/local/bin/newrelic_haproxy_agent run',
    subscribe => Exec['newrelic_haproxy_agent_config'],
  }

}
