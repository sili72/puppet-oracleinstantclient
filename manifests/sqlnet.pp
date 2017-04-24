# Install SQL*Net config via sqlnet.ora
class oracleinstantclient::sqlnet (
  String $sqlnetdomain,
  String $sqlnetdirectory,
  String $sqlnetseed,
  String $sqlnetzone = 'world',
  Integer $sqlnetexpire = 50,
) {
  file { 'sqlnet.ora':
    name    => "/usr/lib/oracle/${::oracle_version}/${::oracleinstantclient::oracleclient}/sqlnet.ora",
    mode    => '0644',
    owner   => 'root',
    group   => 'root',
    content => template('oracleinstantclient/sqlnet.ora.erb'),
    require => [
      Package['oracle-instantclient'],
      File['/usr/lib/oracle/current'],
    ],
  }
}
