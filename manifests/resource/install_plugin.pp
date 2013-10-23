define newrelic_plugins_puppet::resource::install_plugin (
  $install_path,
  $download_url,
  $version
) {
  # create install directory
  file { $install_path:
    ensure => directory,
    mode   => '0644'
  }

  $directory_name = "${name}-${version}" 
  $file_name = "${directory_name}.tar.gz"

  # download plugin tar file
  exec { "curl ${file_name}":
    command => "curl -L -o ${file_name} ${download_url}",
    cwd => $install_path,
    creates => "${install_path}/${file_name}",
    path => $::path,
    require => File[$install_path]
  }

  # extract plugin tar file
  exec { "extract ${file_name}":
    command => "tar zxvf ${install_path}/${file_name}",
    cwd => $install_path,
    creates => "${install_path}/${directory_name}",
    path => $::path,
    require => Exec["curl ${file_name}"]
  }
}