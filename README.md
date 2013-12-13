#newrelic_plugins

### Note: This Module is currently in Beta ###

This module is currently in Beta and will be moved to the Puppet Forge site after the beta. To use the module, clone or download this repo and add it to your Puppet modules path under the name `newrelic_plugins`. Follow the usage instructions below.

Please provide any feedback to <jstenhouse@newrelic.com> or create a pull request here. Thanks!

####Table of Contents

1. [Overview](#overview)
2. [Module Description - What the does the module do?](#module-description)
3. [Setup - The basics of getting started with New Relic Plugins](#setup)
    * [Requirements](#requirements)
    * [What New Relic Plugins affect](#what-new-relic-plugins-affect)
4. [Usage - Configuration options and additional functionality](#usage)
5. [Limitations - OS compatibility, etc.](#limitations)
6. [License](#license)
6. [Contact - Contributing to the module or feedback](#contact)

##Overview

This module installs, configures and manages as a service, New Relic Plugins on Debian/RHEL.

##Module Description

The following New Relic plugins are supported through this module:

 - AWS Cloudwatch
 - MySQL
 - F5
 - Example

##Setup

###Requirements

The AWS Cloudwatch, F5 and Example plugins require:

- Ruby >= 1.8.7 
- Rubygems >= 1.8

The MySQL plugin requires: 

- Java Runtime Environment (JRE) >= 1.6

There are several Java and Ruby Puppet Modules available on Puppet Forge.

- https://forge.puppetlabs.com/puppetlabs/java
- https://forge.puppetlabs.com/puppetlabs/ruby

###What New Relic Plugins affect

 - Creates installation path
 - Curls and extracts distribution file(s) (e.g. tarball)
 - Creates configuration files
 - Installs bundler gem (ruby plugins)
 - Creates and manages service init script

##Usage

An example of using the AWS Cloudwatch and MySQL plugins with two classes. See the below sections for plugin specifics.

    class { 'newrelic_plugins::aws_cloudwatch':
      license_key    => 'NEW_RELIC_LICENSE_KEY',
      install_path   => '/path/to/plugin',
      user           => 'newrelic',
      aws_access_key => 'AWS_ACCESS_KEY',
      aws_secret_key => 'AWS_SECRET_KEY',
      agents         => [ 'ec2', 'ebs', 'elb' ]
    }
    
    class { 'newrelic_plugins::mysql':
      license_key    => 'NEW_RELIC_LICENSE_KEY',
      install_path   => '/path/to/plugin',
      user           => 'newrelic',
      java_options   => '-Dhttps.proxyHost=proxy.example.com -Dhttps.proxyPort=12345',
      servers        => [
        {
          name          => 'Production 1',
          host          => 'localhost',
          metrics       => 'status,newrelic',
          mysql_user    => 'USER',
          mysql_passwd  => 'CLEAR_TEXT_PASSWORD'
        }
      ]
    }

###AWS Cloudwatch Plugin

####Parameters

`license_key` - _(required)_ New Relic License Key

`install_path` - _(required)_ Install Directory. Any downloaded files will be placed here. The plugin will be installed within this directory at `newrelic_aws_cloudwatch_plugin`.

`user` - _(required)_ User to run as

`aws_access_key` - _(required)_ AWS Cloudwatch Access Key

`aws_secret_key` - _(required)_ AWS Cloudwatch Secret Key

`agents` - _(required)_ Array of AWS Cloudwatch agents. Valid values are `ec`, `ec2`, `ebs`, `elb`, `rds`, `sqs`, and `sns`

`version` - _(optional)_ Plugin version. Defaults to latest release version.

`regions` - _(optional)_ Array of AWS Cloudwatch regions. e.g. `us-east-1`. Defaults to all available regions

####Class

    class { 'newrelic_plugins::aws_cloudwatch':
      license_key    => 'NEW_RELIC_LICENSE_KEY',
      install_path   => '/path/to/plugin',
      user           => 'newrelic',
      aws_access_key => 'AWS_ACCESS_KEY',
      aws_secret_key => 'AWS_SECRET_KEY',
      agents         => [ 'ec2', 'ebs', 'elb' ]
    }

For additional info, see https://github.com/newrelic-platform/newrelic_aws_cloudwatch_plugin

###Example Plugin

####Parameters

`license_key` - _(required)_ New Relic License Key

`install_path` - _(required)_ Install Directory. Any downloaded files will be placed here. The plugin will be installed within this directory at `newrelic_example_plugin`.

`user` - _(required)_ User to run as

####Class

    class { 'newrelic_plugins::example_plugin':
     license_key    => 'NEW_RELIC_LICENSE_KEY',
     install_path   => '/path/to/plugin',
     user           => 'newrelic'
    }

For additional info, see https://github.com/newrelic-platform/newrelic_example_plugin

###F5 Plugin

####Parameters

`license_key` - _(required)_ New Relic License Key

`install_path` - _(required)_ Install Directory. Any downloaded files will be placed here. The plugin will be installed within this directory at `newrelic_f5_plugin`.

`user` - _(required)_ User to run as

`agents` - _(required)_ Array of F5 agents that require a name, host, port and snmp_community

`version` - _(optional)_ Plugin version. Defaults to latest release version

####Class

    class { 'newrelic_plugins::f5':
     license_key    => 'NEW_RELIC_LICENSE_KEY',
     install_path   => '/path/to/plugin',
     user           => 'newrelic',
     agents         => [
       {
         name           => 'My F5',
         host           => 'my-f5',
         port           => 161,
         snmp_community => 'community'
       }
     ]
    }

For additional info, see https://github.com/newrelic-platform/newrelic_f5_plugin

###MySQL Plugin

####Parameters

`license_key` - _(required)_ New Relic License Key

`install_path` - _(required)_ Install Directory. Any downloaded files will be placed here. The plugin will be installed within this directory at `newrelic_mysql_plugin`.

`user` - _(required)_ User to run as

`servers` - _(required)_ Array of MySQL server information

`metrics` - _(optional)_ Default set of metrics. Can be overriden in `servers`

`mysql_user` - _(optional)_ Default user name. Can be overriden in `servers`

`mysql_passwd` - _(optional)_ Default clear text password. Can be overriden in `servers`

`version` - _(optional)_ Plugin version. Defaults to latest release version

`java_options` - _(optional)_ String of java options that will be passed to the init script java command. E.g. `-Dhttps.proxyHost=proxy.example.com -Dhttps.proxyPort=12345` for proxy support. Defaults to `-Xmx128m` (max 128mb heap size) but may be overridden.

####Class

    class { 'newrelic_plugins::mysql':
      license_key    => 'NEW_RELIC_LICENSE_KEY',
      install_path   => '/path/to/plugin',
      user           => 'newrelic',
      metrics        => 'status,newrelic',
      mysql_user     => 'USER_NAME_HERE',
      mysql_passwd   => 'USER_CLEAR_TEXT_PASSWORD_HERE',
      java_options   => '-Dhttps.proxyHost=proxy.example.com -Dhttps.proxyPort=12345',
      servers        => [
        {
          name       => 'Production Master',
          host       => 'master-host'
        },
        {
          name       => 'Production Slave',
          host       => 'slave-host'
        }
      ]
    }

    class { 'newrelic_plugins::mysql':
      license_key    => 'NEW_RELIC_LICENSE_KEY',
      install_path   => '/path/to/plugin',
      user           => 'newrelic',
      java_options   => '-Dhttps.proxyHost=proxy.example.com -Dhttps.proxyPort=12345',
      servers        => [
        {
          name          => 'Production Master',
          host          => 'master-host',
          metrics       => 'status,newrelic,master',
          mysql_user    => 'USER_NAME_HERE',
          mysql_passwd  => 'USER_CLEAR_TEXT_PASSWORD_HERE'
        },
        {
          name          => 'Production Slave',
          host          => 'slave-host',
          metrics       => 'status,newrelic,slave',
          mysql_user    => 'USER_NAME_HERE',
          mysql_passwd  => 'USER_CLEAR_TEXT_PASSWORD_HERE'
        }
      ]
    }

For additional info, see https://github.com/newrelic-platform/newrelic_mysql_java_plugin

##Limitations

This module supports:

 - Debian 
 - Ubuntu 
 - CentOS
 - Red Hat
 - Fedora
 - Amazon
 - FreeBSD

## License

This cookbook is under the included MIT License.

## Contact

Contribute to this Cookbook at https://github.com/newrelic-platform/newrelic_plugins_puppet. Any other feedback or support related questions can be sent to support @ newrelic.com. 