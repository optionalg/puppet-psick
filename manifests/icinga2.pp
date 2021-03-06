# This class manages the installation and initialisation of icinga2
#
# @param ensure If to install or remove icinga2
# @param auto_prerequisites If to automatically install all the prerequisites
#                           resources needed to install the runner
# @param template The path to the erb template (as used in template()) to use
#                 to populate the Runner configuration file. Note that if you
#                 use the runners parameter this file is automatically generated
#                 during runners registration
# @param options An open hash of options you may use in your template
#
class psick::icinga2 (
  String                $ensure      = 'present',
  Boolean               $auto_prerequisites = true,
  Optional[String]      $template    = undef,
  Hash                  $options     = { },
  Boolean        $install_icinga_cli = false,
  Boolean        $install_classic_ui = false,

  String         $master             = "icinga.${::domain}",
  Boolean        $is_client          = true,
  Boolean        $is_server          = false,
) {

  $options_default = {
  }
  $real_options = $options_default + $options
  ::tp::install { 'icinga2' :
    ensure             => $ensure,
    auto_prerequisites => $auto_prerequisites,
  }

  if $template {
    ::tp::conf { 'icinga2':
      ensure       => $ensure,
      template     => $template,
      base_dir     => 'conf',
      options_hash => $real_options,
    }
  }

  if $install_icinga_cli {
    package { 'icingacli':
      ensure => $ensure,
    }
  }
  if $install_classic_ui {
    package { 'icinga2-classicui-config':
      ensure => $ensure,
    }
  }
}
