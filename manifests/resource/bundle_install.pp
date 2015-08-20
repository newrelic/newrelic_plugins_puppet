define newrelic_plugins::resource::bundle_install ($plugin_path, $user) {

  if !(defined(Package['bundler'])) {
    # install bundler gem
    package { 'bundler' :
      ensure   => present,
      provider => gem
    }
  }

  # bundle install
  exec { "${name}: bundle install":
    path        => $::path,
    command     => "sudo -u ${user} bundle install",
    cwd         => $plugin_path,
    require     => Package['bundler'],
    onlyif      => "test `/usr/bin/gem list newrelic_plugin -i` -eq false",
    user        => $user
  }
}
