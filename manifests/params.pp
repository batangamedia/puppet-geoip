class geoip::params {

  $package       = hiera('geoip::package', 'geoip-bin')
  $userid        = hiera('geoip::userid', '')
  $licensekey    = hiera('geoip::licensekey', '')
  $productids    = hiera('geoip::products', '106 132')
  $extra_package = hiera('geoip::extra_package', 'geoip-database')
  $update_cron   = hiera('geoip::update_cron', true)
  $save_path     = hiera('groip::save_path', '/usr/share/GeoIP')
}