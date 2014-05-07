# = Class: newrelic_plugins::aws_cloudwatch
#
# This class installs/configures/manages New Relic's AWS Cloudwatch Plugin.
# Only supported on Debian-derived and Red Hat-derived OSes.
#
# == Parameters:
#
# $license_key::     License Key for your New Relic account
#
# $install_path::    Install Path for New Relic AWS Cloudwatch Plugin.
#                    Any downloaded files will be placed here. The plugin
#                    will be installed within this directory at
#                    `newrelic_aws_cloudwatch_plugin`.
#
# $user::            User to run as
#
# $version::         New Relic AWS Cloudwatch Plugin Version.
#                    Currently defaults to the latest version.
#
# $aws_access_key::  AWS Access Key for New Relic AWS Cloudwatch Plugin
#
# $aws_secret_key::  AWS Secret Key for New Relic AWS Cloudwatch Plugin
#
# $agents::          Array of AWS Agents. Valid agents are:
#                    'ec2', 'ebs', 'elb', 'rds', 'sqs', 'sns', 'ec'
#
# $regions::         Optional array of AWS regions. Example regions are:
#                    'us-east-1', 'us-west-1', etc. If $regions is not
#                    provided, the plugin will default to all available
#                    regions.
#
# == Requires:
#
#   puppetlabs/stdlib
#
# == Sample Usage:
#
#   class { 'newrelic_plugins::aws_cloudwatch':
#     license_key    => 'NEW_RELIC_LICENSE_KEY',
#     install_path   => '/path/to/plugin',
#     user           => 'newrelic',
#     aws_access_key => 'AWS_ACCESS_KEY',
#     aws_secret_key => 'AWS_SECRET_KEY',
#     agents         => [ 'ec2', 'ebs', 'elb' ]
#   }
#
class newrelic_plugins::aws_cloudwatch (
    $license_key,
    $install_path,
    $user,
    $aws_access_key,
    $aws_secret_key,
    $agents,
    $version = $newrelic_plugins::params::aws_cloudwatch_version,
    $regions = [],
) inherits params {

  include stdlib

  # verify ruby is installed
  newrelic_plugins::resource::verify_ruby { 'AWS Cloudwatch Plugin': }

  # verify attributes
  validate_absolute_path($install_path)
  validate_string($user)
  validate_string($version)
  validate_string($aws_access_key)
  validate_string($aws_secret_key)
  validate_array($agents)
  validate_array($regions)

  # verify license_key
  newrelic_plugins::resource::verify_license_key { 'AWS Cloudwatch Plugin: Verify New Relic License Key':
    license_key => $license_key
  }

  # nokogiri packages
  package { $newrelic_plugins::params::nokogiri_packages:
    ensure => present,
    before => Newrelic_plugins::Resource::Install_plugin['newrelic_aws_cloudwatch_plugin'] # for puppet 2.x support
  }

  $plugin_path = "${install_path}/newrelic_aws_cloudwatch_plugin"

  # install plugin
  newrelic_plugins::resource::install_plugin { 'newrelic_aws_cloudwatch_plugin':
    install_path => $install_path,
    plugin_path  => $plugin_path,
    user         => $user,
    download_url => "${newrelic_plugins::params::aws_cloudwatch_download_baseurl}/${version}.tar.gz",
    version      => $version
  }

  # newrelic_plugin.yml template
  file { "${plugin_path}/config/newrelic_plugin.yml":
    ensure  => file,
    content => template('newrelic_plugins/aws_cloudwatch/newrelic_plugin.yml.erb'),
    owner   => $user
  }

  # install bundler gem and run 'bundle install'
  newrelic_plugins::resource::bundle_install { 'AWS Cloudwatch Plugin: bundle install':
    plugin_path => $plugin_path,
    user        => $user
  }

  # install init.d script and start service
  newrelic_plugins::resource::plugin_service { 'newrelic-aws-cloudwatch-plugin':
    daemon         => './bin/newrelic_aws',
    daemon_dir     => $plugin_path,
    plugin_name    => 'AWS Cloudwatch',
    plugin_version => $version,
    user           => $user,
    run_command    => 'bundle exec',
    service_name   => 'newrelic-aws-cloudwatch-plugin'
  }

  # ordering
  Newrelic_plugins::Resource::Verify_ruby['AWS Cloudwatch Plugin']
  ->
  Newrelic_plugins::Resource::Verify_license_key['AWS Cloudwatch Plugin: Verify New Relic License Key']
  ->
  Newrelic_plugins::Resource::Install_plugin['newrelic_aws_cloudwatch_plugin']
  ->
  File["${plugin_path}/config/newrelic_plugin.yml"]
  ->
  Newrelic_plugins::Resource::Bundle_install['AWS Cloudwatch Plugin: bundle install']
  ->
  Newrelic_plugins::Resource::Plugin_service['newrelic-aws-cloudwatch-plugin']
}

