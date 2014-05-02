# = Class: newrelic_plugins::rackspace_load_balancers
#
# This class installs/configures/manages New Relic's Rackspace Load Balancers Plugin.
# Only supported on Debian-derived and Red Hat-derived OSes.
#
# == Parameters:
#
# $license_key::     License Key for your New Relic account
#
# $install_path::    Install Path for New Relic Rackspace Load Balancers Plugin.
#                    Any downloaded files will be placed here. The plugin
#                    will be installed within this directory at
#                    `newrelic_rackspace_load_balancers_plugin`.
#
# $user::            User to run as
#
# $version::         New Relic Rackspace Load Balancers Plugin Version.
#                    Currently defaults to the latest version.
#
# $username::        Username for Rackspace Load Balancers
#
# $api_key::         API Key for Rackspace Load Balancers
#
# $region::          Region for Rackspace Load Balancers. Valid regions are:
#                    'ord', 'dfw', and 'lon'.
#
#
# == Requires:
#
#   puppetlabs/stdlib
#
# == Sample Usage:
#
#   class { 'newrelic_plugins::rackspace_load_balancers':
#     license_key    => 'NEW_RELIC_LICENSE_KEY',
#     install_path   => '/path/to/plugin',
#     user           => 'newrelic',
#     username       => 'RACKSPACE_USERNAME',
#     api_key        => 'RACKSPACE_API_KEY',
#     region         => 'dfw'
#   }
#
class newrelic_plugins::rackspace_load_balancers (
    $license_key,
    $install_path,
    $user,
    $username,
    $api_key,
    $region,
    $version = $newrelic_plugins::params::rackspace_load_balancers_version,
) inherits params {

  include stdlib

  # verify ruby is installed
  newrelic_plugins::resource::verify_ruby { 'Rackspace Load Balancers Plugin': }

  # verify attributes
  validate_absolute_path($install_path)
  validate_string($user)
  validate_string($version)
  validate_string($username)
  validate_string($api_key)
  validate_string($region)

  # verify license_key
  newrelic_plugins::resource::verify_license_key { 'Rackspace Load Balancers Plugin: Verify New Relic License Key':
    license_key => $license_key
  }

  # nokogiri packages
  package { $newrelic_plugins::params::nokogiri_packages:
    ensure => present,
    before => Newrelic_plugins::Resource::Install_plugin['newrelic_rackspace_load_balancers_plugin'] # for puppet 2.x support
  }

  $plugin_path = "${install_path}/newrelic_rackspace_load_balancers_plugin"

  # install plugin
  newrelic_plugins::resource::install_plugin { 'newrelic_rackspace_load_balancers_plugin':
    install_path => $install_path,
    plugin_path  => $plugin_path,
    user         => $user,
    download_url => "${newrelic_plugins::params::rackspace_load_balancers_download_baseurl}/${version}.tar.gz",
    version      => $version
  }

  # newrelic_plugin.yml template
  file { "${plugin_path}/config/newrelic_plugin.yml":
    ensure  => file,
    content => template('newrelic_plugins/rackspace_load_balancers/newrelic_plugin.yml.erb'),
    owner   => $user
  }

  # install bundler gem and run 'bundle install'
  newrelic_plugins::resource::bundle_install { 'Rackspace Load Balancers Plugin: bundle install':
    plugin_path => $plugin_path,
    user        => $user
  }

  # install init.d script and start service
  newrelic_plugins::resource::plugin_service { 'newrelic-rackspace-load-balancers-plugin':
    daemon         => './bin/newrelic_rs',
    daemon_dir     => $plugin_path,
    plugin_name    => 'Rackspace Load Balancers',
    plugin_version => $version,
    user           => $user,
    run_command    => 'bundle exec',
    service_name   => 'newrelic-rackspace-load-balancers-plugin'
  }

  # ordering
  Newrelic_plugins::Resource::Verify_ruby['Rackspace Load Balancers Plugin']
  ->
  Newrelic_plugins::Resource::Verify_license_key['Rackspace Load Balancers Plugin: Verify New Relic License Key']
  ->
  Newrelic_plugins::Resource::Install_plugin['newrelic_rackspace_load_balancers_plugin']
  ->
  File["${plugin_path}/config/newrelic_plugin.yml"]
  ->
  Newrelic_plugins::Resource::Bundle_install['Rackspace Load Balancers Plugin: bundle install']
  ->
  Newrelic_plugins::Resource::Plugin_service['newrelic-rackspace-load-balancers-plugin']
}

