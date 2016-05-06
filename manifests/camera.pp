# Camera defined type
define motion::camera (
    $netcam_url,
    $netcam_tolerant_check = $motion::camera_netcam_tolerant_check,
    $netcam_keepalive      = $motion::camera_netcam_keepalive,
    # $netcam_userpass       = $motion::camera_netcam_userpass,
    $netcam_username       = $motion::camera_netcam_username,
    $netcam_password       = $motion::camera_netcam_password,

    $stream_port           = $motion::camera_stream_port,
    $stream_quality        = $motion::camera_stream_quality,
    $stream_motion         = $motion::camera_stream_motion,
    $stream_maxrate        = $motion::camera_stream_maxrate,
    $stream_localhost      = $motion::camera_stream_localhost,
    $stream_limit          = $motion::camera_stream_limit,
    $stream_auth_method    = $motion::camera_stream_auth_method,
    # $stream_authentication = $motion::camera_stream_authentication,
    $stream_username       = $motion::camera_stream_username,
    $stream_password       = $motion::camera_stream_password,

    $threshold             = $motion::camera_threshold,
    $threshold_tune        = $motion::camera_threshold_tune,
    $noise_level           = $motion::camera_noise_level,
    $noise_tune            = $motion::camera_noise_tune,
    $despeckle_filter      = $motion::camera_despeckle_filter,
    $smart_mask_speed      = $motion::camera_smart_mask_speed,
    $lightswitch           = $motion::camera_lightswitch,
    $mask_file             = $motion::camera_mask_file,
    $minimum_motion_frames = $motion::camera_minimum_motion_frames,
    $event_gap             = $motion::camera_event_gap,
    $max_movie_time        = $motion::camera_max_movie_time,
    $emulate_motion        = $motion::camera_emulate_motion,

    $thread_template       = $motion::camera_thread_template,
    $label                 = $name
) {
    $mask_file_path = $mask_file ? {
        undef   => undef,
        default => "${motion::conf_dir}/masks/${name}_mask.pgm",
    }

    if $mask_file_path {
        file { $mask_file_path:
            ensure => 'present',
            source => $mask_file,
            owner  => $motion::owner,
            group  => $motion::group,
            mode   => '0660',
        }
    }

    file { "${motion::conf_dir}/threads/thread_${name}.conf":
        ensure  => 'present',
        content => template($thread_template),
        notify  => $motion::service_notify,
    }
}
