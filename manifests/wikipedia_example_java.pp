# = Class: newrelic_plugins::wikipedia_example_java
#
# This class installs/configures/manages New Relic's Wikipedia Example Java Plugin.
# Only supported on Debian-derived and Red Hat-derived OSes.
#
# == Parameters:
#
# $license_key::     License Key for your New Relic account
#
# $install_path::    Install Path for New Relic Wikipedia Example Java Plugin.
#                    Any downloaded files will be placed here.
#                    The plugin will be installed within this
#                    directory at `newrelic_wikipedia_example_java_plugin`.
#
# $user::            User to run as
#
# $version::         New Relic Wikipedia Example Java Plugin Version.
#                    Currently defaults to the latest version.
#
#
# == Requires:
#
#   puppetlabs/stdlib
#
# == Sample Usage:
#
#   class { 'newrelic_plugins::wikipedia_example_java':
#     license_key    => 'NEW_RELIC_LICENSE_KEY',
#     install_path   => '/path/to/plugin',
#     user           => 'newrelic'
#   }
#
class newrelic_plugins::wikipedia_example_java (
    $license_key,
    $install_path,
    $user,
    $version = $newrelic_plugins::params::wikipedia_example_java_version
) inherits params {

  include stdlib

  # verify java is installed
  newrelic_plugins::resource::verify_java { 'Wikipedia Example Java Plugin': }

  # verify attributes
  validate_absolute_path($install_path)
  validate_string($user)
  validate_string($version)

  # verify license_key
  newrelic_plugins::resource::verify_license_key { 'Wikipedia Example Java Plugin: Verify New Relic License Key':
    license_key => $license_key
  }

  $plugin_path = "${install_path}/newrelic_wikipedia_example_java_plugin"

  # install plugin
  newrelic_plugins::resource::install_plugin { 'newrelic_wikipedia_example_java_plugin':
    install_path => $install_path,
    plugin_path  => $plugin_path,
    download_url => "${$newrelic_plugins::params::wikipedia_example_java_download_baseurl}-${version}.tar.gz",
    version      => $version,
    user         => $user
  }

  # newrelic.json template
  file { "${plugin_path}/config/newrelic.json":
    ensure  => file,
    content => template('newrelic_plugins/wikipedia_example_java/newrelic.json.erb'),
    owner   => $user,
    notify  => Service['newrelic-wikipedia-example-java-plugin']
  }

  # plugin.json template
  file { "${plugin_path}/config/plugin.json":
    ensure  => file,
    content => template('newrelic_plugins/wikipedia_example_java/plugin.json'),
    owner   => $user,
    notify  => Service['newrelic-wikipedia-example-java-plugin']
  }

  # install init.d script and start service
  newrelic_plugins::resource::plugin_service { 'newrelic-wikipedia-example-java-plugin':
    daemon         => 'plugin.jar',
    daemon_dir     => $plugin_path,
    plugin_name    => 'Wikipedia Example Java',
    plugin_version => $version,
    user           => $user,
    run_command    => "java ${java_options} -jar",
    service_name   => 'newrelic-wikipedia-example-java-plugin'
  }

  # ordering
  Newrelic_plugins::Resource::Verify_java['Wikipedia Example Java Plugin']
  ->
  Newrelic_plugins::Resource::Verify_license_key['Wikipedia Example Java Plugin: Verify New Relic License Key']
  ->
  Newrelic_plugins::Resource::Install_plugin['newrelic_wikipedia_example_java_plugin']
  ->
  File["${plugin_path}/config/newrelic.json"]
  ->
  File["${plugin_path}/config/plugin.json"]
  ->
  Newrelic_plugins::Resource::Plugin_service['newrelic-wikipedia-example-java-plugin']
}

