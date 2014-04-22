#New Relic Plugins

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

To use the module, add it to your Puppet modules path under the name `newrelic_plugins`.

##Module Description

The following New Relic plugins are supported through this module:

 - [AWS Cloudwatch](#aws-cloudwatch-plugin)
 - [MySQL](#mysql-plugin)
 - [F5](#f-plugin)
 - [Memcached (Java)](#memcached-java)
 - [Memcached (Ruby)](#memcached-ruby)
 - [Rackspace Load Balancers](#rackspace-load-balancers-plugin)
 - [Example](#example-plugin)
 - [Wikipedia Example Java](#wikipedia-example-java)
 - [Wikipedia Example Ruby](#wikipedia-example-ruby)

##Setup

###Requirements

The AWS Cloudwatch, F5, Example and Wikipedia Example Ruby plugins require:

- Ruby >= 1.8.7
- Rubygems >= 1.8

The MySQL and Wikipedia Example Java plugins require:

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

###Memcached (Java)

####Parameters

`install_path` - _(required)_ Install Directory. Any downloaded files will be placed here. The plugin will be installed within this directory at `newrelic_memcached_java_plugin`.

`user` - _(required)_ User to run as

`servers` - _(required)_ Array of Memcached server information

`version` - _(optional)_ Plugin version. Defaults to latest release version

`java_options` - _(optional)_ String of java options that will be passed to the init script java command. E.g. `-Dhttps.proxyHost=proxy.example.com -Dhttps.proxyPort=12345` for proxy support. Defaults to `-Xmx128m` (max 128mb heap size) but may be overridden.

####Class

    class { 'newrelic_plugins::memcached_java':
      license_key    => 'NEW_RELIC_LICENSE_KEY',
      install_path   => '/path/to/plugin',
      user           => 'newrelic',
      java_options   => '-Dhttps.proxyHost=proxy.example.com -Dhttps.proxyPort=12345',
      servers        => [
        {
          name          => 'Production Master',
          host          => 'host.example.com',
          port          => 11211
        },
        {
          name          => 'Memcached Host - 2',
          host          => 'host2.example.com'
        }
      ]
    }

For additional info, see https://github.com/newrelic-platform/newrelic_memcached_java_plugin

###Memcached (Ruby)

####Parameters

`license_key` - _(required)_ New Relic License Key

`install_path` - _(required)_ Install Directory. Any downloaded files will be placed here. The plugin will be installed within this directory at `newrelic_memcached_ruby_plugin`.

`user` - _(required)_ User to run as

`agents` - _(required)_ Array of Memcached hosts that require a name and host and take an optional port.

`version` - _(optional)_ Plugin version. Defaults to latest release version

####Class

    class { 'newrelic_plugins::memcached_ruby':
     license_key    => 'NEW_RELIC_LICENSE_KEY',
     install_path   => '/path/to/plugin',
     user           => 'newrelic',
     agents         => [
       {
         name     => 'Memcached Host - 1',
         endpoint => 'memcached.example.com',
         port     => 11211
       }
     ]
    }

For additional info, see https://github.com/newrelic-platform/newrelic_memcached_plugin

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

###Rackspace Load Balancers Plugin

####Parameters

`license_key` - _(required)_ New Relic License Key

`install_path` - _(required)_ Install Directory. Any downloaded files will be placed here. The plugin will be installed within this directory at `newrelic_rackspace_load_balancers_plugin`.

`user` - _(required)_ User to run as

`username` - _(required)_ Username for Rackspace Load Balancers

`api_key` - _(required)_ API Key for Rackspace Load Balancers

`region` - _(required)_ Region for Rackspace Load Balancers. Valid regions are: `ord`, `dfw`, and `lon`.

`version` - _(optional)_ Plugin version. Defaults to latest release version

####Class

    class { 'newrelic_plugins::rackspace_load_balancers':
      license_key    => 'NEW_RELIC_LICENSE_KEY',
      install_path   => '/path/to/plugin',
      user           => 'newrelic',
      username       => 'RACKSPACE_USERNAME',
      api_key        => 'RACKSPACE_API_KEY',
      region         => 'dfw'
    }

For additional info, see https://github.com/newrelic-platform/newrelic_rackspace_load_balancers_plugin

###Wikipedia Example Java

####Parameters

`license_key` - _(required)_ New Relic License Key

`install_path` - _(required)_ Install Directory. Any downloaded files will be placed here. The plugin will be installed within this directory at `newrelic_wikipedia_example_java_plugin`.

`user` - _(required)_ User to run as

`version` - _(optional)_ Plugin version. Defaults to latest release version.

####Class

    class { 'newrelic_plugins::wikipedia_example_java':
      license_key    => 'NEW_RELIC_LICENSE_KEY',
      install_path   => '/path/to/plugin',
      user           => 'newrelic'
    }

For additional info, see https://github.com/newrelic-platform/newrelic_java_wikipedia_plugin

###Wikipedia Example Ruby

####Parameters

`license_key` - _(required)_ New Relic License Key

`install_path` - _(required)_ Install Directory. Any downloaded files will be placed here. The plugin will be installed within this directory at `newrelic_wikipedia_example_ruby_plugin`.

`user` - _(required)_ User to run as

`version` - _(optional)_ Plugin version. Defaults to latest release version.

####Class

    class { 'newrelic_plugins::wikipedia_example_ruby':
      license_key    => 'NEW_RELIC_LICENSE_KEY',
      install_path   => '/path/to/plugin',
      user           => 'newrelic'
    }

For additional info, see https://github.com/newrelic-platform/newrelic_ruby_wikipedia_plugin

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
