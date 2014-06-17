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
  $ftpusers_file     = '',
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
  $sql_logmsgcolumn  = 'msg'
) {

  package { 'pam_mysql' :
    ensure => latest
  }

  file { 'pam.d_vsftpd':
    ensure   => file,
    path     => $pam_file,
    mode     => '0600',
    owner    => 'root',
    group    => 'root',
    require  => Package['pam_mysql'],
    content  => template('vsftpd/pam_mysql.erb')
  }
}
