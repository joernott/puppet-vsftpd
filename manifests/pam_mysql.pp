# Class: vsftpd::pam_mysql
#
# This class is used to manage pam_mysql configuration
# to allow logins from users which are specified in a
# database
#
# == Usage
#
# class { 'vsftpd::pam_mysql :}
#
class vsftpd::pam_mysql(
  $pam_file          = '/etc/pam.d/vsftpd',
  $ftpusers_file     = '/etc/vsftpd/ftpusers',
  $sql_user          = 'ftpd',
  $sql_password      = '',
  $sql_host          = 'localhost',
  $sql_db            = 'users',
  $sql_table         = 'users',
  $sql_usercolumn    = 'user',
  $sql_passwdcolumn  = 'password',
  $sql_crypt         = 3,
  $sql_logtable      = 'log',
  $sql_logusercolumn = 'user',
  $sql_logpidcolumn  = 'pid',
  $sql_loghostcolumn = 'host',
  $sql_logtimecolumn = 'time',
  $sql_logmsgcolumn  = 'msg',
  $debug             = false
) {

  package { 'pam_mysql' :
    ensure => latest
  }

  file { '/etc/pam.d/vsftpd':
    ensure   => file,
    path     => $pam_file,
    mode     => '0600',
    owner    => 'root',
    group    => 'root',
    require  => Package['pam_mysql'],
    content  => template('vsftpd/pam_mysql.erb')
  }

  if $ftpusers_file == '' {
    file { '/etc/vsftpd/ftpusers': 
      ensure => absent,
      path   => $ftpusers_file
    }
  }
  else {
    file { '/etc/vsftpd/ftpusers':
      ensure   => file,
      path     => $ftpusers_file,
      mode     => '0644',
      owner    => 'root',
      group    => 'root',
      require  => Package['pam_mysql', 'vsftpd'],
      source   => 'puppet:///modules/vsftpd/user_list',
    }
  }
}
