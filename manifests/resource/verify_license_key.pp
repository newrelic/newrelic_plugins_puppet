define newrelic_plugins::resource::verify_license_key ($license_key) {
  unless $license_key =~ /^[0-9a-fA-F]{40}$/ {
    fail("The provided New Relic License Key is invalid: ${license_key}. For more information, see <INSERT_URL_HERE>.")
  }
}
