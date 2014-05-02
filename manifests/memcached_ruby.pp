# = Class: newrelic_plugins::memcached_ruby
#
# This class installs/configures/manages New Relic's Memcached (Ruby) Plugin.
# Only supported on Debian-derived and Red Hat-derived OSes.
#
# == Parameters:
#
# $license_key::     License Key for your New Relic account
#
# $install_path::    Install Path for New Relic Memcached (Ruby) Plugin.
#                    Any downloaded files will be placed here.
#                    The plugin will be installed within this
#                    directory at `newrelic_memcached_ruby_plugin`.
#
# $user::            User to run as
#
# $version::         New Relic Memcached (Ruby) Plugin Version.
#                    Currently defaults to the latest version.
#
# == Requires:
#
#   puppetlabs/stdlib
#
# == Sample Usage:
#
#   class { 'newrelic_plugins::memcached_ruby':
#     license_key    => 'NEW_RELIC_LICENSE_KEY',
#     install_path   => '/path/to/plugin',
#     user           => 'newrelic',
#     agents         => [
#     {
#       name          => 'MemachedRuby-Host1',
#       endpoint      => 'host1.memcached.com',
#       port          => 11211
#     },
#     {
#       name          => 'MemachedRuby-Host2',
#       endpoint      => 'host2.memcached.com'
#     }
#   }
#
class newrelic_plugins::memcached_ruby (
    $license_key,
    $install_path,
    $user,
    $version = $newrelic_plugins::params::memcached_ruby_version,
    $agents,
) inherits params {

  include stdlib

  # verify ruby is installed
  newrelic_plugins::resource::verify_ruby { 'Memcached (Ruby) Plugin': }

  # verify attributes
  validate_absolute_path($install_path)
  validate_string($version)
  validate_string($user)

  # verify license_key
  newrelic_plugins::resource::verify_license_key { 'Memcached (Ruby) Plugin: Verify New Relic License Key':
    license_key => $license_key
  }

  $plugin_path = "${install_path}/newrelic_memcached_ruby_plugin"

  # install plugin
  newrelic_plugins::resource::install_plugin { 'newrelic_memcached_ruby_plugin':
    install_path => $install_path,
    plugin_path  => $plugin_path,
    download_url => "${newrelic_plugins::params::memcached_ruby_download_baseurl}/${version}.tar.gz",
    version      => $version,
    user         => $user
  }

  # newrelic_plugin.yml template
  file { "${plugin_path}/config/newrelic_plugin.yml":
    ensure  => file,
    content => template('newrelic_plugins/memcached_ruby/newrelic_plugin.yml.erb'),
    owner   => $user
  }

  # install bundler gem and run 'bundle install'
  newrelic_plugins::resource::bundle_install { 'Memcached (Ruby) Plugin: bundle install':
    plugin_path => $plugin_path,
    user        => $user
  }

  # install init.d script and start service
  newrelic_plugins::resource::plugin_service { 'newrelic-memcached-ruby-plugin':
    daemon         => './newrelic_memcached_agent',
    daemon_dir     => $plugin_path,
    plugin_name    => 'Memcached (Ruby)',
    plugin_version => $version,
    user           => $user,
    run_command    => 'bundle exec',
    service_name   => 'newrelic-memcached-ruby-plugin'
  }

  # ordering
  Newrelic_plugins::Resource::Verify_ruby['Memcached (Ruby) Plugin']
  ->
  Newrelic_plugins::Resource::Verify_license_key['Memcached (Ruby) Plugin: Verify New Relic License Key']
  ->
  Newrelic_plugins::Resource::Install_plugin['newrelic_memcached_ruby_plugin']
  ->
  File["${plugin_path}/config/newrelic_plugin.yml"]
  ->
  Newrelic_plugins::Resource::Bundle_install['Memcached (Ruby) Plugin: bundle install']
  ->
  Newrelic_plugins::Resource::Plugin_service['newrelic-memcached-ruby-plugin']
}

