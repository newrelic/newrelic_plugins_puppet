define newrelic_plugins::resource::plugin_service (
  $ensure         = present,
  $user,
  $daemon_dir,
  $plugin_name,
  $plugin_version,
  $run_command,
  $service_name,
  $service_enable = true,
  $service_ensure = running,
  $daemon         = '',
) {
  file { "/etc/init.d/${name}":
    ensure  => $ensure,
    content => template('newrelic_plugins/service.erb'),
    mode    => '0755',
  }

  service { $name:
    ensure    => $service_ensure,
    enable    => $service_enable,
    subscribe => File["/etc/init.d/${name}"]
  }
}
