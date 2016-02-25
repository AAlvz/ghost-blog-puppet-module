class aalvz_ghost {

  $packages = ['unzip']

  Exec {
    provider => shell,
    timeout  => 180,
  }

  package {$packages:
    ensure => present,
  } ->

  exec {"get_ghost_latest_version":
    command => "curl -sL https://ghost.org/zip/ghost-latest.zip -o /tmp/ghost.zip",
    unless  => "test -e /tmp/ghost.zip",
  } ->

  file { '/home/ghost':
    ensure => directory,
  } ->

  exec {"unzip_ghost":
    command => "unzip -uo /tmp/ghost.zip -d /home/ghost/ghost",
    require => File['/home/ghost'],
    unless  => "test -e /home/ghost/ghost",
  } ->

  exec {"install_ghost":
    cwd     => '/home/ghost/ghost',
    command => 'sudo npm install --production',
    path    => ['/usr/local/sbin', '/usr/sbin', '/sbin', '/usr/bin', '/usr/local/bin'],
  } ->

  exec {"run_ghost":
    cwd     => '/home/ghost/ghost',
    command => "sudo npm start --production &",
    path    => ['/usr/local/sbin', '/usr/sbin', '/sbin', '/usr/bin', '/usr/local/bin'],
  }

  cron {"enable_ghost_blog":
    name     => 'ghost_blog_running',
    ensure   => present,
    command  => 'cd /home/ghost/ghost && npm start --production &',
    user     => root,
    provider => crontab,
    special  => reboot,
  }

  class { nginx: }

  nginx::resource::vhost { 'my_blog':
    ensure               => present,
    listen_port          => 80,
    proxy                => 'http://localhost:2368',
    #use_default_location => false,
    location_cfg_append  => {
      'proxy_set_header'  => {
        'Host'            => '$http_host',
        'X-Real-IP'       => '$remote_addr',
      },
    },
  }
}
