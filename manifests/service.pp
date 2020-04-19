# @summary  This class manages service
#
# @param ensure
#  State ensured from fail2ban_exporter service.
# @param user
#  User running fail2ban_exporter.
# @param group
#  Group under which fail2ban_exporter is running.
# @param port
#  Fail2ban exporter port (required to be accessible).
# @param fail2ban_host_address
#  Fail2ban host address.
# @param fail2ban_api_port
#  Fail2ban api port.
# @param bin_dir
#  Directory where binaries are located.
# @example
#   include fail2ban_exporter::service
class fail2ban_exporter::service (
  Variant[Stdlib::Ensure::Service, Enum['absent']] $ensure         = $fail2ban_exporter::service_ensure,
  String                                           $user           = $fail2ban_exporter::user,
  String                                           $group          = $fail2ban_exporter::group,
  Stdlib::Host                                     $listen_address = $fail2ban_exporter::listen_address,
  Stdlib::Port                                     $listen_port    = $fail2ban_exporter::listen_port,
  Stdlib::Absolutepath                             $bin_dir        = $fail2ban_exporter::bin_dir,
) {
  $_file_ensure    = $ensure ? {
    'running' => file,
    'stopped' => file,
    default   => absent,
  }
  $_service_ensure = $ensure ? {
    'running' => running,
    default   => stopped,
  }

  file { '/lib/systemd/system/fail2ban_exporter.service':
    ensure  => $_file_ensure,
    content => template('fail2ban_exporter/service.erb'),
    notify  => Service['fail2ban_exporter']
  }
  service { 'fail2ban_exporter':
    ensure => $_service_ensure,
    enable => true,
  }

  File['/lib/systemd/system/fail2ban_exporter.service'] -> Service['fail2ban_exporter']
}
