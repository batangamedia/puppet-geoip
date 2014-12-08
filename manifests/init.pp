# = Class: geoip::common
#
# GeoIP configuration used by other classes.
#
class geoip inherits geoip::params {
 
  package { $geoip::params::package: ensure => installed }


  if ($geoip::params::userid and $geoip::params::licensekey) {
    class {'geoip::conf':
      require => Package[$geoip::params::package]
    } -> exec {'run geoipupdate':
      command => '/usr/bin/geoipupdate',
      unless  => '/usr/bin/test -f /usr/share/GeoIP/GeoIPCity.dat'
    }
  } else {
    notify{ 'Geoip module not configured, credentials missings':  }
  }

  if ($geoip::params::update_cron) {

    file{'/etc/cron.weekly/geoip-update':
        ensure => present,
        source => 'puppet:///modules/geoip/geoipupdate.cron'
    }

  }

}

