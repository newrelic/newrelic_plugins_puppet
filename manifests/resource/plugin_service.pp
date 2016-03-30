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

  case $::operatingsystem {
    'Ubuntu': {
      if versioncmp($::operatingsystemmajrelease, '14.10') > 0 {
        $config_file = "/etc/systemd/system/${name}.service"
        $template    = 'newrelic_plugins/systemd_service.erb'
      } else {
        $config_file = "/etc/init.d/${name}"
        $template    = 'newrelic_plugins/service.erb'
      }
    }
  }
  file { $config_file:
    ensure  => $ensure,
    content => template($template),
    mode    => '0755',
  }

  service { $name:
    ensure    => $service_ensure,
    enable    => $service_enable,
    subscribe => File[$config_file]
  }
}
