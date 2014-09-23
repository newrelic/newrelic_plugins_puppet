# = Class: newrelic_plugins::mysql
#
# This class installs/configures/manages New Relic's MySQL Plugin.
# Only supported on Debian-derived and Red Hat-derived OSes.
#
# == Parameters:
#
# $license_key::     License Key for your New Relic account
#
# $install_path::    Install Path for New Relic MySQL Plugin.
#                    Any downloaded files will be placed here.
#                    The plugin will be installed within this
#                    directory at `newrelic_mysql_plugin`.
#
# $user::            User to run as
#
# $version::         New Relic MySQL Plugin Version.
#                    Currently defaults to the latest version.
#
# $servers::         Array of MySQL server information. If using the default username
#                    and password, the user and passwd attributes can be left off.
#                    (see mysql_user and mysql_passwd)
#                    Note also that the "name" defaults to the same as the "host"
#                    unless overriden, and as such "name" is optional.
#
# $metrics::         Default set of metrics. Can override in $servers.
#
# $mysql_user::      Default username. Can override in $servers.
#
# $mysql_passwd::    Default clear text password. Can override in $servers.
#
# $java_options::    String of java options that will be passed to the init script java command.
#                    E.g. -Dhttps.proxyHost=proxy.example.com -Dhttps.proxyPort=12345
#                    for proxy support. Defaults to -Xmx128m (max 128mb heap size).
#
# $service_enable::  Boolean. Service enabled at boot. Maps to 'enabled' parameter for service.
#                    Default: true
#
# $service_ensure::  Service 'ensure' parameter. Default: running.
#
# == Requires:
#
#   puppetlabs/stdlib
#
# == Sample Usage:
#
#   class { 'newrelic_plugins::mysql':
#     license_key    => 'NEW_RELIC_LICENSE_KEY',
#     install_path   => '/path/to/plugin',
#     user           => 'newrelic',
#     metrics        => 'status,newrelic',
#     mysql_user     => 'USER_NAME_HERE',
#     mysql_passwd   => 'USER_CLEAR_TEXT_PASSWORD_HERE',
#     servers        => [
#       {
#         name  => 'Production Master',
#         host  => 'localhost'
#       },
#       {
#         name  => 'Production Slave',
#         host  => 'localhost'
#       }
#     ]
#   }
#
#   class { 'newrelic_plugins::mysql':
#     license_key    => 'NEW_RELIC_LICENSE_KEY',
#     install_path   => '/path/to/plugin',
#     servers        => [
#       {
#         name          => 'Production Master',
#         host          => 'localhost',
#         metrics       => 'status,newrelic',
#         mysql_user    => 'USER_NAME_HERE',
#         mysql_passwd  => 'USER_CLEAR_TEXT_PASSWORD_HERE'
#       }
#     ]
#   }
#
class newrelic_plugins::mysql (
    $license_key,
    $install_path,
    $user,
    $version = $newrelic_plugins::params::mysql_version,
    $servers,
    $metrics = '',
    $mysql_user = '',
    $mysql_passwd = '',
    $java_options = $newrelic_plugins::params::mysql_java_options,
    $newrelic_template = 'newrelic_plugins/mysql/newrelic.json.erb',
    $plugin_template = 'newrelic_plugins/mysql/plugin.json.erb',
    $service_enable = true,
    $service_ensure = running,
) inherits params {

  include stdlib

  # verify java is installed
  newrelic_plugins::resource::verify_java { 'MySQL Plugin': }

  # verify attributes
  validate_absolute_path($install_path)
  validate_string($user)
  validate_string($version)
  validate_array($servers)

  # verify license_key
  newrelic_plugins::resource::verify_license_key { 'MySQL Plugin: Verify New Relic License Key':
    license_key => $license_key
  }

  $plugin_path = "${install_path}/newrelic_mysql_plugin"

  # install plugin
  newrelic_plugins::resource::install_plugin { 'newrelic_mysql_plugin':
    install_path => $install_path,
    plugin_path  => $plugin_path,
    download_url => "${$newrelic_plugins::params::mysql_download_baseurl}-${version}.tar.gz",
    version      => $version,
    user         => $user
  }

  # newrelic.json template
  file { "${plugin_path}/config/newrelic.json":
    ensure  => file,
    content => template($newrelic_template),
    owner   => $user,
    notify  => Service['newrelic-mysql-plugin']
  }

  # plugin.json template
  file { "${plugin_path}/config/plugin.json":
    ensure  => file,
    content => template($plugin_template),
    owner   => $user,
    notify  => Service['newrelic-mysql-plugin']
  }

  # install init.d script and start service
  newrelic_plugins::resource::plugin_service { 'newrelic-mysql-plugin':
    daemon         => 'plugin.jar',
    daemon_dir     => $plugin_path,
    plugin_name    => 'MySQL',
    plugin_version => $version,
    user           => $user,
    run_command    => "java ${java_options} -jar",
    service_name   => 'newrelic-mysql-plugin',
    service_enable => $service_enable,
    service_ensure => $service_ensure,
  }

  # ordering
  Newrelic_plugins::Resource::Verify_java['MySQL Plugin']
  ->
  Newrelic_plugins::Resource::Verify_license_key['MySQL Plugin: Verify New Relic License Key']
  ->
  Newrelic_plugins::Resource::Install_plugin['newrelic_mysql_plugin']
  ->
  File["${plugin_path}/config/newrelic.json"]
  ->
  File["${plugin_path}/config/plugin.json"]
  ->
  Newrelic_plugins::Resource::Plugin_service['newrelic-mysql-plugin']
}

