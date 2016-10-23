# = Class: users::home
#
# Description
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
#  class { 'users':
#    servers => [ 'pool.ntp.org', 'ntp.local.company.com' ],
#  }
#
# === Authors
#
# Matthew Hansen
#
# === Copyright
#
# Copyright 2016 Matthew Hansen
#
define users::home (
  $user = $title,
  $db_password = '',
) {


  # .my.cnf for mysql database password
  file { "/home/$user/.my.cnf":
    ensure    => file,
    owner    => "$user",
    mode     => '0644',
    path      => "/home/$user/.my.cnf",
    content   => template('users/.my.cnf.erb'),
    notify    => Service['mysql'],
    require   => Package['mysql-server'],
  }


  file { "/home/$user/.bash_aliases":
    ensure   => file,
    owner    => "$user",
    mode     => '0644',
    path     => "/home/$user/.bash_aliases",
    source   => 'puppet:///modules/users/home/.bash_aliases',
  }

  file { "/home/$user/.bash_git":
    ensure   => file,
    owner    => "$user",
    mode     => '0644',
    path     => "/home/$user/.bash_git",
    source   => 'puppet:///modules/users/home/.bash_git',
  }

  file { "/home/$user/.bash_profile":
    ensure   => file,
    owner    => "$user",
    mode     => '0644',
    path     => "/home/$user/.bash_profile",
    source   => 'puppet:///modules/users/home/.bash_profile',
  }

  file { "/home/$user/.bashrc":
    ensure   => file,
    owner    => "$user",
    mode     => '0644',
    path     => "/home/$user/.bashrc",
    source   => 'puppet:///modules/users/home/.bashrc',
  }

  file { "/home/$user/.git-completion.bash":
    ensure   => file,
    owner    => "$user",
    mode     => '0644',
    path     => "/home/$user/.git-completion.bash",
    source   => 'puppet:///modules/users/home/.git-completion.bash',
  }

  file { "/home/$user/.git-prompt.sh":
    ensure   => file,
    owner    => "$user",
    mode     => '0644',
    path     => "/home/$user/.git-prompt.sh",
    source   => 'puppet:///modules/users/home/.git-prompt.sh',
  }

  # ScreenRC
  file { ".screenrc for $user":
    ensure   => file,
    owner    => "$user",
    mode     => '0644',
    path     => "/home/$user/.screenrc",
    source   => 'puppet:///modules/users/home/.screenrc',
  }

  # Leaves out rdoc / ri files for Gems
  # see http://stackoverflow.com/questions/1381725/how-to-make-no-ri-no-rdoc-the-default-for-gem-install
  file { ".gemrc for $user":
    ensure   => file,
    owner    => "$user",
    mode     => '0644',
    path     => "/home/$user/.gemrc",
    source   => 'puppet:///modules/users/home/.gemrc',
  }
}
