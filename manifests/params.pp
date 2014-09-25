# == Class: newrelic_plugins::params
#
# Default parameters for all newrelic_plugins
#
# == Parameters:
#
#  None
#
# == Requires:
#
#  None
#
# == Sample Usage:
#
#   class { 'newrelic_plugins::params': }
#
class newrelic_plugins::params {

  $aws_cloudwatch_version = '3.3.2'
  $aws_cloudwatch_download_baseurl = 'https://github.com/newrelic-platform/newrelic_aws_cloudwatch_plugin/archive'

  # nokogiri dependencies
  if $::osfamily == 'Debian' {
    $nokogiri_packages = ['libxml2-dev', 'libxslt-dev']
  }
  else {
    $nokogiri_packages = ['libxml2', 'libxml2-devel', 'libxslt', 'libxslt-devel']
  }

  $f5_version = '1.0.16'

  $memcached_ruby_version = '1.0.1'
  $memcached_ruby_download_baseurl = 'https://github.com/newrelic-platform/newrelic_memcached_plugin/archive/release'

  $example_version = '1.0.1'
  $example_download_baseurl = 'https://github.com/newrelic-platform/newrelic_example_plugin/archive/release'

  $mysql_version = '2.0.0'
  $mysql_download_baseurl = 'https://github.com/newrelic-platform/newrelic_mysql_java_plugin/raw/master/dist/newrelic_mysql_plugin'
  $mysql_java_options = '-Xmx128m'

  $memcached_java_version = '2.0.1'
  $memcached_java_options = '-Xmx128m'
  $memcached_java_download_baseurl = 'https://raw.github.com/newrelic-platform/newrelic_memcached_java_plugin/master/dist/newrelic_memcached_plugin'

  $rackspace_load_balancers_version = '1.2.0'
  $rackspace_load_balancers_download_baseurl = 'https://github.com/newrelic-platform/newrelic_rackspace_load_balancers_plugin/archive'

  $wikipedia_example_java_version = '2.0.0'
  $wikipedia_example_java_download_baseurl = 'https://github.com/newrelic-platform/newrelic_java_wikipedia_plugin/raw/master/dist/newrelic_wikipedia_plugin'

  $wikipedia_example_ruby_version = '1.0.3'
  $wikipedia_example_ruby_download_baseurl = 'https://github.com/newrelic-platform/newrelic_wikipedia_plugin/archive'
}

