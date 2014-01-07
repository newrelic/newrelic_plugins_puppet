define newrelic_plugins::resource::install_plugin (
  $install_path,
  $plugin_path,
  $user,
  $download_url,
  $version
) {

  $tar_file = "${name}-${version}.tar.gz"

  # create install directory
  exec { "${name}: create ${install_path}":
    command => "mkdir -p ${install_path}",
    path    => $::path,
    user    => $user,
    unless  => "test -d ${install_path}",
    before  => Exec["curl ${tar_file}"]
  }

  # download plugin tar file
  exec { "curl ${tar_file}":
    command => "curl -L -o ${tar_file} ${download_url}",
    cwd     => $install_path,
    path    => $::path,
    user    => $user,
    onlyif  => "test -d ${install_path}",
    unless  => "test -f ${tar_file}",
    notify  => Exec["${name}: create ${plugin_path}"]
  }

  # remove/recreate plugin path directory only after curling tar file
  exec { "${name}: create ${plugin_path}":
    command     => "[ -d ${plugin_path} ] && (rm -r ${plugin_path} && mkdir ${plugin_path}) || mkdir ${plugin_path}",
    path        => $::path,
    user        => $user,
    notify      => Exec["extract ${tar_file}"],
    refreshonly => true
  }

  # extract plugin tar file only after create plugin directory
  exec { "extract ${tar_file}":
    command     => "tar zxvf ${install_path}/${tar_file} --strip-components=1",
    cwd         => $plugin_path,
    path        => $::path,
    user        => $user,
    refreshonly => true
  }
}
