# oracleinstantclient

#### Table of Contents

1. [Overview](#overview)
4. [Usage - Configuration options and additional functionality](#usage)
5. [Limitations - OS compatibility, etc.](#limitations)
6. [Development - Guide for contributing to the module](#development)

## Overview

This module installs the Oracle Instant Client, plus related tools, libraries
and SDKs.

This module does **not** include the Oracle binary packages. You must [download
these from Oracle's website](http://www.oracle.com/technetwork/database/features/instant-client/index-097480.html)
and place them in a Yum repo which is accessible by your system.

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
The preference order of which directories to use to locate your Oracle server. Default `(LDAP,TNSNAMES)`

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

This is where you list OS compatibility, version compatibility, etc.

## Development

Since your module is awesome, other users will want to play with it. Let them
know what the ground rules for contributing are.

## Release Notes/Contributors/Etc **Optional**

If you aren't using changelog, put your release notes here (though you should
consider using changelog). You may also add any additional sections you feel are
necessary or important to include here. Please use the `## ` header.
