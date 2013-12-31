define newrelic_plugins::resource::verify_license_key ($license_key) {
  if !($license_key =~ /^[0-9a-fA-F]{40}$/) {
    fail("The provided New Relic License Key is invalid: ${license_key}. For more information, see https://docs.newrelic.com/docs/subscriptions/license-key.")
  }
}
