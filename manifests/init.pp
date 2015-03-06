# == Class: newrelic_plugins
#
# This is the parent class for all newrelic_plugins
#
# == Parameters:
#
# None
#
# == Requires:
#
#   puppetlabs/stdlib
#
# == Sample Usage:
#
#   class { 'newrelic_plugins': }
#
class newrelic_plugins(
  $aws_cloudwatch_download_baseurl = $::newrelic_plugins::params::aws_cloudwatch_download_baseurl,
  $aws_cloudwatch_version =  $::newrelic_plugins::params::aws_cloudwatch_version,
  $example_download_baseurl = $::newrelic_plugins::params::example_download_baseurl,
  $example_version = $::newrelic_plugins::params::example_version,
  $f5_version = $::newrelic_plugins::params::f5_version,
  $memcached_java_download_baseurl = $::newrelic_plugins::params::memcached_java_download_baseurl,
  $memcached_java_options = $::newrelic_plugins::params::memcached_java_options,
  $memcached_java_version = $::newrelic_plugins::params::memcached_java_version,
  $memcached_ruby_download_baseurl = $::newrelic_plugins::params::memcached_ruby_download_baseurl,
  $memcached_ruby_version = $::newrelic_plugins::params::memcached_ruby_version,
  $mysql_download_baseurl = $::newrelic_plugins::params::mysql_download_baseurl,
  $mysql_java_options = $::newrelic_plugins::params::mysql_java_options,
  $mysql_version = $::newrelic_plugins::params::mysql_version,
  $nokogiri_packages = $::newrelic_plugins::params::nokogiri_packages,
  $rackspace_load_balancers_download_baseurl = $::newrelic_plugins::params::rackspace_load_balancers_download_baseurl,
  $rackspace_load_balancers_version = $::newrelic_plugins::params::rackspace_load_balancers_version,
  $wikipedia_example_java_download_baseurl = $::newrelic_plugins::params::wikipedia_example_java_download_baseurl,
  $wikipedia_example_java_version = $::newrelic_plugins::params::wikipedia_example_java_version,
  $wikipedia_example_ruby_download_baseurl = $::newrelic_plugins::params::wikipedia_example_ruby_download_baseurl,
  $wikipedia_example_ruby_version = $::newrelic_plugins::params::wikipedia_example_ruby_version,
) inherits ::newrelic_plugins::params {

}
