# oracleinstantclient

#### Table of Contents

1. [Overview](#overview)
2. [Usage - Configuration options and additional functionality](#usage)
3. [Limitations - OS compatibility, etc.](#limitations)
4. [Development - Guide for contributing to the module](#development)
5. [Release Notes](#releasenotes)

## Overview

This module installs the Oracle Instant Client, plus related tools, libraries
and SDKs.

This module does **not** include the Oracle RPM binary packages. You must [download
these from Oracle's website](http://www.oracle.com/technetwork/database/features/instant-client/index-097480.html)
and place them in a Yum repo which is accessible by your system.

This module does not currently have the ability to serve up RPM packages
from Puppet's fileserver. This could be added if necessary.

## Usage

### `oracleinstantclient`

The main usage of this module is via the `oracleinstantclient` class, which installs packages
and handles a few extra bits required to make the Instant Client work.

#### `version`
Specify the version of Oracle Instant Client to install. This **must** match the packages you have
downloaded from Oracle and placed in a local Yum repo. Default: `12.2`

#### `devel`
Install the development package. Default: `false`

#### `jdbc`
Install the JDBC package. Default: `false`

#### `odbc`
Install the ODBC package. Default: `false`

#### `sqlplus`
Install the SQLPlus application package. Default: `false`

#### `tools`
Install the tools package. Default: `false`

#### `selinux`
Manage SELinux policies to allow Oracle Instant Client to work on RHEL. Default: `true`

#### `eplan`
Install `eplan` SQL script to enable `explain plan` usage in SQLPlus. Default: `false`

#### Example
This example shows all parameters with their default values.

```puppet
class { oracleinstantclient:
  version => '12.2',
  devel   => false,
  jdbc    => false,
  odbc    => false,
  sqlplus => false,
  tools   => false,
  selinux => true,
  eplan   => false,
}
```

### `oracleinstantclient::ldap`

The `oracleinstantclient::ldap` class allows you to configure Oracle Instant Client
to use LDAP to look up Oracle server names.

#### `ldapserver`
The name of the LDAP server to use. This is a required parameter. Example: `ldap.example.com`

#### `ldapcontext`
The LDAP context to run in. This is a required parameter. Example: `dc=example,dc=com`

#### `ldapport`
The port to connect to the LDAP server on. Default: `389`

#### `ldaptype`
The type of LDAP search to run. Default: `OID`

#### Example
```puppet
class { oracleinstantclient::ldap:
  ldapserver  => 'ldap.example.com',
  ldapcontext => 'dc=example,dc=com',
  ldapport    => 389,
  ldaptype    => 'OID',
}
```

### `oracleinstantclient::sqlnet`

The `oracleinstantclient::sqlnet` class allows you to configure Oracle Instant Client
to use SQLNet to locate Oracle servers

#### `sqlnetdomain`
The default domain of your Oracle server. Example: `example.com`

#### `sqlnetdirectory`
The preference order of which directories to use to locate your Oracle server. Example: `(LDAP,TNSNAMES)`

#### `sqlnetseed`
The seed to use for crypto purposes. Example: `SECRETSEED`

#### `sqlnetzone`
The default zone of your Oracle server. Default: `world`

#### `sqlnetexpire`
SQLNet expire time. Default: `50`

#### Example

```puppet
class { oracleinstantclient::sqlnet:
  sqlnetdomain    => 'example.com',
  sqlnetdirectory => '(LDAP,TNSNAMES)',
  sqlnetseed      => 'SECRETSEED',
  sqlnetzone      => 'world',
  sqlnetexpire    => 50,
}
```

## Limitations

This module is developed and tested on CentOS 6 and 7. Oracle's packages
are in RPM format so it would not be easy to extend to other platforms.

## Development

Pull requests welcome. No guarantee of development effort if the features
are not useful to my employer.
