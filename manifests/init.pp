# = Class: geoip::common
#
# GeoIP configuration used by other classes.
#
class geoip inherits geoip::params {

  package { $geoip::params::package: ensure => installed }

  if ( $geoip::params::extra_package ) {
  	package { $geoip::params::extra_package: ensure => installed }  
  }
  
  if ( $facts['os']['family'] == 'Debian' and $facts['os']['distro']['release']['major'] == '9' ) {
    package{'geoipupdate':
      ensure => installed
    }
    # Debian 9 changes default path to /var/lib/GeoIP
    $real_save_path = '/var/lib/GeoIP'
  } else {
    $real_save_path = $geoip::params::save_path
  }
  if ($geoip::params::userid and $geoip::params::licensekey) {
    class {'geoip::conf':
      require => Package[$geoip::params::package]
    } -> exec {'run geoipupdate':
      command => '/usr/bin/geoipupdate',
      unless  => "/usr/bin/test -f ${real_save_path}/GeoIPCity.dat"
    }

    if ($geoip::params::update_cron) {

      cron { 'geoipupdate':
        ensure  => present,
        command => '/usr/bin/geoipupdate',
        user    => root,
        minute  => 0,
        hour    => 0,
        weekday => 7
      }

    }

  } else {
    fail('Geoip module not configured, credentials missings')
  }

}

