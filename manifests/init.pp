# @summary This module manages Fail2ban Exporter
#
# Init class of Fail2ban Exporter module. It can installes Fail2ban Exporter binaries and single Service.
#
# @param version
#  Fail2ban exporter release. See https://github.com/anclrii/Fail2ban-Exporter/releases
# @param base_dir
#  Base directory where Fail2ban is extracted.
# @param bin_dir
#  Directory where binaries are located.
# @param base_url
#  Base URL for Fail2ban Exporter.
# @param download_extension
#  Extension of Fail2ban exporter binaries archive.
# @param download_url
#  Complete URL corresponding to the Fail2ban exporter release, default to undef.
# @param extract_command
#  Custom command passed to the archive resource to extract the downloaded archive.
# @param manage_user
#  Whether to create user for fail2ban_exporter or rely on external code for that.
# @param manage_group
#  Whether to create user for fail2ban_exporter or rely on external code for that.
# @param user
#  User running fail2ban_exporter.
# @param group
#  Group under which fail2ban_exporter is running.
# @param user_shell
#  if requested, we create a user for fail2ban_exporter. The default shell is false. It can be overwritten to any valid path.
# @param extra_groups
#  Add other groups to the managed user.
# @param service_ensure
#  State ensured from fail2ban_exporter service.
# @param listen_address
#  Fail2ban exporter listen address.
# @param listen_port
#  Fail2ban exporter listen port (required to be accessible).
# @param manage_python
#  Whether to install python3 or rely on external code for that.
#  Python3 is required to run exporter binary.
# @param python_required_packages
#  Python required package list.
# @example
#   include fail2ban_exporter
class fail2ban_exporter (
  String                                           $version                  = 'master',

  # Installation
  Stdlib::Absolutepath                             $base_dir                 = '/opt',
  Stdlib::Absolutepath                             $bin_dir                  = '/usr/local/bin',
  Stdlib::HTTPUrl                                  $base_url                 = 'https://github.com/Kylapaallikko/fail2ban_exporter/archive',
  String                                           $download_extension       = 'tar.gz',
  Optional[Stdlib::HTTPUrl]                        $download_url             = undef,
  Optional[String]                                 $extract_command          = undef,

  # User Management
  Boolean                                          $manage_user              = true,
  Boolean                                          $manage_group             = true,
  String                                           $user                     = 'root',
  String                                           $group                    = 'root',
  Stdlib::Absolutepath                             $user_shell               = '/bin/false',
  Array[String]                                    $extra_groups             = [],

  # Service
  Variant[Stdlib::Ensure::Service, Enum['absent']] $service_ensure           = 'running',
  Stdlib::Host                                     $listen_address           = '0.0.0.0',
  Stdlib::Port                                     $listen_port              = 9180,

  # Extra Management
  Boolean                                          $manage_python            = true,
  Array[String]                                    $python_required_packages = ['prometheus_client'],
) {
  if $download_url {
    $real_download_url = $download_url
  } else {
    $real_download_url = "${base_url}/${version}.${download_extension}"
  }

  include fail2ban_exporter::install
  include fail2ban_exporter::service

  Class['fail2ban_exporter::install'] -> Class['fail2ban_exporter::service']

  if $manage_python {
    ensure_resource('class', 'python', { version => 'python3' })

    Class['python'] -> Class['fail2ban_exporter::service']
  }
}
