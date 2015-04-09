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



}
