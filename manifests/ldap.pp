# Install LDAP connector via ldap.ora
class oracleinstantclient::ldap (
  String $ldapserver,
  String $ldapcontext,
  Integer $ldapport = 389,
  String $ldaptype = 'OID',
) {

  package { 'openldap-clients':
    ensure => installed,
  }

  file { 'ldap.ora':
    name    => "/usr/lib/oracle/${::oracle_version}/${::oracleinstantclient::oracleclient}/ldap.ora",
    mode    => '0644',
    owner   => 'root',
    group   => 'root',
    content => template('oracleinstantclient/ldap.ora.erb'),
    require => [
      Package['oracle-instantclient'],
      File['/usr/lib/oracle/current'],
    ],
  }
}
