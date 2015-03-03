# = Class: newrelic_plugins::redis
#
# This class installs/configures/manages kenjij Redis plugin for New Relic.
#
# Project URL: https://github.com/kenjij/newrelic_redis_plugin
#
# Only supported on Debian-derived and Red Hat-derived OSes.
#
# == Parameters:
#
# $license_key::          License Key for your New Relic account
#
# $install_path::         Install Path for redis plugin.
#                         Any downloaded files will be placed here.
#                         The plugin will be installed within this
#                         directory at `newrelic_redis_plugin`.
#
# $user::                 User to run as
#
# $version::              New Relic Redis Plugin Version.
#                         Currently defaults to the latest version.
#
# $redis_instance_name::  Name of the redis instance (optional)
#
# $redis_url::            Path to the redis instance (tcp/port)
#
# $redis_database::       Database to use (e.g. db0)
#
# == Requires:
#
#   puppetlabs/stdlib
#
# == Sample Usage:
#   class { 'newrelic_plugins::redis':
#     license_key    => 'NEW_RELIC_LICENSE_KEY',
#     install_path   => '/path/to/plugin',
#     user           => 'redis',
#     redis_url      => 'redis://127.0.0.1:6379',
#     redis_database => 'db0' 
#   }
#
class newrelic_plugins::redis (
    $license_key,
    $install_path,
    $user,
    $version = $newrelic_plugins::params::redis_version,
    $redis_instance_name = undef,
    $redis_url,
    $redis_database
) inherits params {

  include stdlib

  # verify ruby is installed
  newrelic_plugins::resource::verify_ruby { 'Redis Plugin': }

  # verify attributes
  validate_absolute_path($install_path)
  validate_string($user)
  validate_string($version)
  validate_string($redis_url)
  validate_string($redis_database)
  
  # verify license_key
  newrelic_plugins::resource::verify_license_key { 'Redis Plugin: Verify New Relic License Key':
    license_key => $license_key
  }

  # install dante gem as a requirement
  package { 'dante' :
    ensure   => '0.2.0',
    provider => gem
  }
  
  # install bundler gem as a requirement
  package { 'bundler' :
    ensure   => present,
    provider => gem
  }

  $plugin_path = "${install_path}/newrelic_redis_plugin"

  # create install directory
  exec { 'create install directory':
    command => "mkdir -p ${plugin_path}",
    path    => $::path,
    unless  => "test -d ${plugin_path}",
    user    => $user
  }

  # install plugin
  newrelic_plugins::resource::install_plugin { 'newrelic_redis_plugin':
    install_path => $install_path,
    plugin_path  => $plugin_path,
    user         => $user,
    download_url => "${newrelic_plugins::params::redis_download_baseurl}/v${version}.tar.gz",
    version      => $version
  }
  
  file { "${plugin_path}/config":
    ensure  => directory,
    mode    => '0644',
    owner   => $user
  }

  # newrelic_plugin.yml template
  file { "${plugin_path}/config/newrelic_plugin.yml":
    ensure  => file,
    content => template('newrelic_plugins/redis/newrelic_plugin.yml.erb'),
    owner   => $user
  }

  # install init.d script and start service
  newrelic_plugins::resource::plugin_service { 'newrelic-redis-plugin':
    daemon_dir     => $plugin_path,
    plugin_name    => 'redis',
    plugin_version => $version,
    user           => $user,
    run_command    => 'newrelic_redis_agent -d',
    service_name   => 'newrelic-redis-plugin'
  }

  # ordering
  Newrelic_plugins::Resource::Verify_ruby['Redis Plugin']
  ->
  Newrelic_plugins::Resource::Verify_license_key['Redis Plugin: Verify New Relic License Key']
  ->
  Package['bundler']
  ->
  Package['dante']
  ->
  Exec['create install directory']
  ->
  Newrelic_plugins::Resource::Install_plugin['newrelic_redis_plugin']
  ->
  File["${plugin_path}/config"]
  ->
  File["${plugin_path}/config/newrelic_plugin.yml"]
  ->
  Newrelic_plugins::Resource::Plugin_service['newrelic-redis-plugin']
}

