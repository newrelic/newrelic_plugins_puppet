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

  $aws_cloudwatch_version = '3.1.0'
  $aws_cloudwatch_download_baseurl = 'https://github.com/newrelic-platform/newrelic_aws_cloudwatch_plugin/archive'

  # nokogiri dependencies
  if $::osfamily == 'Debian' {
    $aws_cloudwatch_nokogiri_packages = ['libxml2-dev', 'libxslt-dev']
  }
  else {
    $aws_cloudwatch_nokogiri_packages = ['libxml2', 'libxml2-devel', 'libxslt', 'libxslt-devel']
  }
}

