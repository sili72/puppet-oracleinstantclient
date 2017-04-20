# Installs and configures Oracle Instant Client
class oracleinstantclient {
  # Install the basic yum packages
  package { [
    'openldap-clients',
    'oracle-instantclient',
    'perl-DBD-Oracle',
    'libaio',
  ]:
    ensure  => installed,
    require => Yumrepo['resnet'],
  }

  # The oracle client has a different path depending on architecture
  $oracleclient = $::architecture ? {
    'i386'   => 'client',
    'x86_64' => 'client64',
    default  => 'client',
  }

  # Install a few files
  file { 'oracle.conf':
    name    => '/etc/ld.so.conf.d/oracle.conf',
    mode    => '0644',
    owner   => 'root',
    group   => 'root',
    source  => 'puppet:///modules/oracleinstantclient/oracle.conf',
    require => [
      Package['oracle-instantclient'],
      File['/usr/lib/oracle/current'],
    ],
    notify  => Exec['ldlibcfg'],
  }

  file { 'oracle_env.sh':
    name    => '/etc/profile.d/oracle_env.sh',
    mode    => '0755',
    owner   => 'root',
    group   => 'root',
    source  => 'puppet:///modules/oracleinstantclient/oracle_env.sh',
    require => [
      Package['oracle-instantclient'],
      File['/usr/lib/oracle/current'],
    ],
  }

  file { 'oracle_env.csh':
    name    => '/etc/profile.d/oracle_env.csh',
    mode    => '0755',
    owner   => 'root',
    group   => 'root',
    source  => 'puppet:///modules/oracleinstantclient/oracle_env.csh',
    require => [
      Package['oracle-instantclient'],
      File['/usr/lib/oracle/current'],
    ],
  }

  file { 'eplan.sql':
    name    => "/usr/lib/oracle/${::oracle_version}/${oracleclient}/eplan.sql",
    mode    => '0644',
    owner   => 'root',
    group   => 'root',
    source  => 'puppet:///modules/oracleinstantclient/eplan.sql',
    require => [
      Package['oracle-instantclient'],
      File['/usr/lib/oracle/current'],
    ],
  }

  # Make the symlink to current versions
  file { '/usr/lib/oracle/current':
    ensure  => link,
    target  => "/usr/lib/oracle/${::oracle_version}",
    require => Package['oracle-instantclient'],
    notify  => Exec['ldlibcfg'],
  }

  if $::architecture == 'x86_64' {
    file { '/usr/bin/sqlplus':
      ensure  => link,
      target  => '/usr/bin/sqlplus64',
      require => Package['oracle-instantclient'],
      notify  => Exec['ldlibcfg'],
    }
    file { '/usr/lib/oracle/current/client':
      ensure  => link,
      target  => '/usr/lib/oracle/current/client64',
      require => Package['oracle-instantclient'],
      notify  => Exec['ldlibcfg'],
    }
  }

  # Run ldconfig to make it work
  exec { 'ldlibcfg':
    command     => '/sbin/ldconfig',
    refreshonly => true,
  }

  # SELinux config
  if $::osfamily == 'RedHat' {
    selinux::module { 'oracle':
      ensure => 'present',
      source => 'puppet:///modules/oracleinstantclient/oracle.te',
    }

    selboolean { 'httpd_can_network_connect':
      name       => 'httpd_can_network_connect',
      persistent => true,
      value      => on,
    }
    selboolean { 'httpd_execmem':
      name       => 'httpd_execmem',
      persistent => true,
      value      => on,
    }
    selboolean { 'httpd_enable_homedirs':
      name       => 'httpd_enable_homedirs',
      persistent => true,
      value      => on,
    }
  }
}
