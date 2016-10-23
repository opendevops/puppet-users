# == Class: users
#
# Full description of class users here.
#
# === Parameters
#
# Document parameters here.
#
# [*sample_parameter*]
#   Explanation of what this parameter affects and what it defaults to.
#   e.g. "Specify one or more upstream ntp servers as an array."
#
# === Variables
#
# Here you should define a list of variables that this module would require.
#
# [*sample_variable*]
#   Explanation of how this variable affects the funtion of this class and if
#   it has a default. e.g. "The parameter enc_ntp_servers must be set by the
#   External Node Classifier as a comma separated list of hostnames." (Note,
#   global variables should be avoided in favor of class parameters as
#   of Puppet 2.6.)
#
# === Examples
#
# users { "${defaultUser}": db_password => $dbPassword }
#
# === Authors
#
# Matthew Hansen
#
# === Copyright
#
# Copyright 2016 Matthew Hansen
#
define users(
  $user = $title,
  $db_password = '',
) {


  user { $user:
    ensure  => 'present',
    groups  => ['sudo'],
    home    => "/home/$user",
    shell   => '/bin/bash',
    managehome => 'true',
  }

  # setup home files
  users::home { $user: db_password => $dbPassword }
}
