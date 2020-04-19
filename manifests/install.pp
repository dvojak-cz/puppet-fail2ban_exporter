# @summary This class install Fail2ban exporter requirements and binaries.
#
# @param version
#  Fail2ban exporter release. See https://github.com/anclrii/Fail2ban-Exporter/releases
# @param base_dir
#  Base directory where Fail2ban is extracted.
# @param bin_dir
#  Directory where binaries are located.
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
# @param python_required_packages
#  Python required package list.
# @example
#   include fail2ban_exporter::install
class fail2ban_exporter::install (
  String                   $version                  = $fail2ban_exporter::version,
  Stdlib::Absolutepath     $base_dir                 = $fail2ban_exporter::base_dir,
  Stdlib::Absolutepath     $bin_dir                  = $fail2ban_exporter::bin_dir,
  String                   $download_extension       = $fail2ban_exporter::download_extension,
  Stdlib::HTTPUrl          $download_url             = $fail2ban_exporter::real_download_url,
  Optional[String]         $extract_command          = $fail2ban_exporter::extract_command,

  # User Management
  Boolean                  $manage_user              = $fail2ban_exporter::manage_user,
  Boolean                  $manage_group             = $fail2ban_exporter::manage_group,
  String                   $user                     = $fail2ban_exporter::user,
  String                   $group                    = $fail2ban_exporter::group,
  Stdlib::Absolutepath     $user_shell               = $fail2ban_exporter::user_shell,
  Array[String]            $extra_groups             = $fail2ban_exporter::extra_groups,

  # Python dependencies
  Array[String]            $python_required_packages = $fail2ban_exporter::python_required_packages,
) {
  archive { "/tmp/fail2ban_exporter-${version}.${download_extension}":
    ensure          => 'present',
    extract         => true,
    extract_path    => $base_dir,
    source          => $download_url,
    checksum_verify => false,
    creates         => "${base_dir}/fail2ban_exporter-${version}",
    cleanup         => true,
    extract_command => $extract_command,
  }
  file {
    "${base_dir}/fail2ban_exporter-${version}/fail2ban_exporter.py":
      owner => 'root',
      group => 0, # 0 instead of root because OS X uses "wheel".
      mode  => '0555';
    "${bin_dir}/fail2ban_exporter":
      ensure => link,
      target => "${base_dir}/fail2ban_exporter-${version}/fail2ban_exporter.py";
  }

  Archive["/tmp/fail2ban_exporter-${version}.${download_extension}"]
  -> File["${base_dir}/fail2ban_exporter-${version}/fail2ban_exporter.py"]
  -> File["${bin_dir}/fail2ban_exporter"]

  if $manage_user {
    ensure_resource('user', [ $user ], {
      ensure => 'present',
      system => true,
      groups => concat([$group], $extra_groups),
      shell  => $user_shell,
    })

    if $manage_group {
      Group[$group] -> User[$user]
    }
  }
  if $manage_group {
    ensure_resource('group', [ $group ], {
      ensure => 'present',
      system => true,
    })
  }

  # Python dependencies
  if $python_required_packages {
    $python_required_packages.each |String $package| {
      ensure_resource('python::pip', $package, {
        ensure       => 'present',
        pkgname      => $package,
        pip_provider => 'pip3',
      })
    }
  }
}
