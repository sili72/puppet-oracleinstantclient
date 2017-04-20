# Installs and configures Oracle Instant Client
class oracleinstantclient (
  String $version = '12.2',
  Boolean $devel = false,
  Boolean $jdbc = false,
  Boolean $odbc = false,
  Boolean $sqlplus = false,
  Boolean $tools = false,
  Boolean $selinux = true,
) {
  # Install the basic yum package
  package { "oracle-instantclient${version}-basic":
    ensure  => installed,
  }

  if ($devel) {
    package { "oracle-instantclient${version}-devel":
      ensure => installed,
    }
  }

  if ($jdbc) {
    package { "oracle-instantclient${version}-jdbc":
      ensure => installed,
    }
  }

  if ($odbc) {
    package { "oracle-instantclient${version}-odbc":
      ensure => installed,
    }
  }

  if ($sqlplus) {
    package { "oracle-instantclient${version}-sqlplus":
      ensure => installed,
    }
  }

  if ($tools) {
    package { "oracle-instantclient${version}-tools":
      ensure => installed,
    }
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
    content => '/usr/lib/oracle/current/client/lib',
    require => [
      Package["oracle-instantclient${version}-basic"],
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
      Package["oracle-instantclient${version}-basic"],
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
      Package["oracle-instantclient${version}-basic"],
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
      Package["oracle-instantclient${version}-basic"],
      File['/usr/lib/oracle/current'],
    ],
  }

  # Make the symlink to current versions
  file { '/usr/lib/oracle/current':
    ensure  => link,
    target  => "/usr/lib/oracle/${::oracle_version}",
    require => Package["oracle-instantclient${version}-basic"],
    notify  => Exec['ldlibcfg'],
  }

  if $::architecture == 'x86_64' {
    file { '/usr/bin/sqlplus':
      ensure  => link,
      target  => '/usr/bin/sqlplus64',
      require => Package["oracle-instantclient${version}-basic"],
      notify  => Exec['ldlibcfg'],
    }
    file { '/usr/lib/oracle/current/client':
      ensure  => link,
      target  => '/usr/lib/oracle/current/client64',
      require => Package["oracle-instantclient${version}-basic"],
      notify  => Exec['ldlibcfg'],
    }
  }

  # Run ldconfig to make it work
  exec { 'ldlibcfg':
    command     => '/sbin/ldconfig',
    refreshonly => true,
  }

  # SELinux config
  if ($selinux == true and $::osfamily == 'RedHat') {
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
