define newrelic_plugins::resource::verify_ruby {
  unless str2bool($nr_ruby_found) {
    fail("The New Relic ${name} requires a Ruby version >= 1.8.7 - For more information, see https://docs.newrelic.com/docs/plugins/ruby-plugin-installation-example")
  }
}
