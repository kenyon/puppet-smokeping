# @summary Manage SmokePing installation
class smokeping::install {
  assert_private()

  package { 'smokeping':
    ensure => $smokeping::version,
  }

  if ! defined (Package['fping']) {
    ensure_packages(['fping'])
  }
  if ! defined (Package[$smokeping::package_perldoc]) {
    ensure_packages([$smokeping::package_perldoc])
  }

  $datadir_group = $smokeping::mode ? {
    'slave' => $smokeping::daemon_group,
    default => $smokeping::webserver_group,
  }

  $datadir_mode = $smokeping::mode ? {
    'slave' => undef,
    default => 'g+wX',
  }

  file { $smokeping::path_datadir:
    ensure  => directory,
    owner   => $smokeping::daemon_user,
    group   => $datadir_group,
    mode    => $datadir_mode,
    require => Package['smokeping'],
    recurse => true,
  }

  if $smokeping::mode =~ /(master|standalone)/ {
    file { $smokeping::path_imgcache:
      ensure  => directory,
      owner   => $smokeping::webserver_user,
      group   => $smokeping::webserver_group,
      require => Package['smokeping'],
      recurse => true,
    }
  }
}
