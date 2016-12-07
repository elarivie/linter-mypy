# Change Log
All notable changes to this project will be documented in this file.
This project adheres to [Semantic Versioning](http://semver.org/).

## [Unreleased]
### Added
- A screen shot on the README.

### Changed
- The settings order.
- Improved documentation.

## [Released] - 1.0.3 2016-12-05

### Added
- More user friendly error notification
 - It is now possible to deactivate "--fast-parser" directly from the notification when the required tool are not present.
 - A spec to track mypy futur command line interface change.
 - A work around for a false positive lint message of mypy when the flag --disallow-subclassing-any is provided

### Changed
- The extra validation settings are now activated by default.

## [Released] - 1.0.2 2016-12-03

### Added
- Specs
- A lot of settings for extra validations
- User friendly notification messages if mypy is not installed.

### Changed
- Better file ignore functionality (now accepts regex).
- Lint messages are now "Warning" instead of "Info".

## [Released] - 0.1.0 2016-12-02

### Changed
- Made it works.

### Added
- Project's info files (AUTHORS, HEARTBEAT, CHANGELOG, LICENSE)
- A makefile to ease frequent task.
