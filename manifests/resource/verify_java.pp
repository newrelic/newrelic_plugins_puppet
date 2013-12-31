define newrelic_plugins::resource::verify_java {
  if !(str2bool($nr_java_found)) and !(defined(Class['java'])) {
    fail("The New Relic ${name} requires a Java version >= 1.6 - For more information, see https://docs.newrelic.com/docs/plugins/java-plugin-installation-example")
  }
}
