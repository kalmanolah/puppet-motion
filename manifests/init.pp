# This module manages motion.
class motion (
    $conf_dir              = '/etc/motion',
    $var_dir               = '/var/lib/motion',

    $owner                 = 'motion',
    $group                 = 'motion',

    $default_template      = "${module_name}/motion_default.erb",
    $config_template       = "${module_name}/motion.conf.erb",

    $package_manage        = true,
    $package_name          = 'motion',
    $package_ensure        = 'present',

    $service_manage        = true,
    $service_name          = 'motion',
    $service_ensure        = 'running',

    $archive_enable        = false,
    $archive_threshold     = '7',

    $prune_enable          = false,
    $prune_threshold       = '14',

    #####
    ### Camera-specific
    ####
    $camera_netcam_tolerant_check = 'on',
    $camera_netcam_keepalive      = 'on',
    # $camera_netcam_userpass       = undef,
    $camera_netcam_username       = undef,
    $camera_netcam_password       = undef,
    $camera_stream_port           = '0',
    $camera_stream_quality        = '50',
    $camera_stream_motion         = 'off',
    $camera_stream_maxrate        = '1',
    $camera_stream_localhost      = 'on',
    $camera_stream_limit          = '0',
    $camera_stream_auth_method    = '1',
    # $camera_stream_authentication = undef,
    $camera_stream_username       = undef,
    $camera_stream_password       = undef,
    $camera_threshold             = '2000',
    $camera_threshold_tune        = 'off',
    $camera_noise_level           = '32',
    $camera_noise_tune            = 'on',
    $camera_despeckle_filter      = 'EedDl',
    $camera_smart_mask_speed      = '0',
    $camera_lightswitch           = '0',
    $camera_mask_file             = undef,
    $camera_minimum_motion_frames = '1',
    $camera_event_gap             = '60',
    $camera_max_movie_time        = '0',
    $camera_emulate_motion        = 'off',
    $camera_thread_template       = "${module_name}/motion_thread.conf.erb",
) {
    $cameras = hiera_hash('motion::cameras', {})

    $service_notify = $service_manage ? {
        true    => Service[$service_name],
        default => undef,
    }

    if $package_manage {
        package { $package_name:
            ensure => $package_ensure,
        }
    }

    if $service_manage {
        service { $service_name:
            ensure =>  $service_ensure,
        }
    }

    file {
        '/etc/default/motion':
            ensure  => 'present',
            content => template($default_template),
            notify  => $service_notify;

        [
            $var_dir,
            $conf_dir,
            "${conf_dir}/masks",
            "${conf_dir}/threads",
            "${conf_dir}/scripts",
        ]:
            ensure  => 'directory',
            mode    => '0755',
            owner   => $owner,
            group   => $group;

        "${conf_dir}/motion.conf":
            ensure  => 'present',
            content => template($config_template),
            notify  => $service_notify;

        "${conf_dir}/scripts/motion_archive.sh":
            ensure  => 'present',
            content => template("${module_name}/motion_archive.sh.erb"),
            mode    => '0770',
            owner   => $owner,
            group   => $group;

        "${conf_dir}/scripts/motion_prune.sh":
            ensure  => 'present',
            content => template("${module_name}/motion_prune.sh.erb"),
            mode    => '0770',
            owner   => $owner,
            group   => $group;
    }

    if $archive_enable {
        cron { 'motion_archive_media':
          command => "/bin/bash ${conf_dir}/motion_archive.sh",
          user    => $owner,
          hour    => fqdn_rand(24),
          minute  => fqdn_rand(60),
        }
    }

    if $prune_enable {
        cron { 'motion_prune_media':
            command => "/bin/bash ${conf_dir}/motion_prune.sh",
            user    => $owner,
            hour    => fqdn_rand(24),
            minute  => fqdn_rand(60),
        }
    }

    create_resources(motion::camera, $cameras, {})
}
