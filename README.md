## puppet-motion

Puppet module for managing Motion, a software motion detector.

See http://lavrsen.dk/foswiki/bin/view/Motion/WebHome

### Usage

Check out the manifests. Usage example (hiera):

```
# hieradata/something.yaml
classes:
    - motion

motion::prune_enable:            true
motion::camera_stream_quality:   75
motion::camera_lightswitch:      50
motion::camera_smart_mask_speed: 5
motion::cameras:
    one:
        netcam_url:       http://netcam.local:40580/cgi-bin/hi3510/snap.cgi?&-getstream&-chn=1
        netcam_username:  admin
        netcam_password:  poocooR7Aigi
        stream_port:      9091
        mask_file:        puppet:///modules/profile_motion/cameras/masks/street_camera_mask.pgm
    two:
        netcam_url:       http://netcam.local:40380/cgi-bin/hi3510/snap.cgi?&-getstream&-chn=1
        netcam_username:  admin
        netcam_password:  Oop6Du3jejaY
        stream_port:      9092
```

### License

See [LICENSE](LICENSE).
