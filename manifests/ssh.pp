# = Class: users::ssh
#
# Will copy the ssh keys.
# Don't save ssh keys to repo, create a folder in `files/{$user}` and generate `id_rsa` + `id_rsa.pub`.
# Use this command to create ssh keys `ssh-keygen -t rsa`
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
# users::ssh{ 'mrrobot': }
#
# === Authors
#
# Matthew Hansen
#
# === Copyright
#
# Copyright 2016 Matthew Hansen
#
define users::ssh ($user = $title) {

  file { "$user/id_rsa":
    ensure  => file,
    owner   => $user,
    group   => $user,
    mode    => '0600',
    path    => "/home/$user/.ssh/id_rsa",
    source  => "puppet:///modules/ssh/$user/id_rsa",
  }

  file { "$user/id_rsa.pub":
    ensure  => file,
    owner   => $user,
    group   => $user,
    mode    => '0600',
    path    => "/home/$user/.ssh/id_rsa.pub",
    source  => "puppet:///modules/ssh/$user/id_rsa.pub",
  }

  # add public key to authorized_keys
  exec { "$user/authorized_keys":
    command  => "cat /home/$user/.ssh/id_rsa.pub >> /home/$user/.ssh/authorized_keys",
    require  => File["$user/id_rsa.pub"],
    notify   => Service["sshd"]
  }

  # authorized_keys > create unique file
  exec { "$user/authorized_keys-unique-file":
    command  => "sort -u /home/$user/.ssh/authorized_keys > /home/$user/.ssh/authorized_keys_unique",
    require  => Exec["$user/authorized_keys"],
  }

  # authorized_keys > use unique file
  exec { "$user/authorized_keys-use-unique":
    command  => "mv /home/$user/.ssh/authorized_keys_unique /home/$user/.ssh/authorized_keys",
    require  => Exec["$user/authorized_keys-unique-file"],
    notify   => Service["sshd"]
  }

}
