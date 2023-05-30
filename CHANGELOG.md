# Change Log


## [1.1.1] - 2023-05-30

### Changed

- Loosen `seg_seg` dependency requirement to include `0.1.x` and `1.x`


## [1.1.0] - 2022-05-02

### Added

- Add Vincenty's Inverse Formula Distance (thanks @Cameron-Kurth)


## [1.0.0] - 2021-11-24

### Added

- `project/3` - Projects a given distance in a given direction away from a point
- `angle_to/2` - Returns direction from one point to another
- `min_coterminal_angle/1` - Coterminal angle closest to 0 for the given angle
- `min_positive_coterminal_angle/1` - Smallest positive coterminal angle for the given angle
- `angular_difference/2` - Angular difference between two angles

### Changed

- Update CI to use Github Actions instead of travis-ci
- Update dependencies
