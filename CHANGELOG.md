# Change Log

All notable changes to this project will be documented in this file.
The format is based on [Keep a Changelog](http://keepachangelog.com/) 
and this project adheres to [Semantic Versioning](http://semver.org/).

## [Unreleased]

## [Released] - 1.0.7 2017-01-11

### Added
- BUILDME

### Changed

- Build steps are now independent from TravisCI
 - A build can now be launch locally using the command *./BUILDME* or *make*.

### Removed
- A no more needed hack related to --disallow-subclassing-any

### Fixed
- Fix typo
- Fix a bug where hundreds of issues from file outside of the opened workspace were reported (mainly about mypy's .pyi files)

## [Released] - 1.0.6 2016-12-12

### Fixed
- Fix a bug which was creating an issue to a file path starting by undefined

## [Released] - 1.0.5 2016-12-08

### Added
- A screen shot on the README.
- TravisCi integration
- Added a first heuristic to underline the warnings

### Changed
- The settings order.
- Improved documentation.
- Fixed the work around for a false positive lint message of mypy when the flag --disallow-subclassing-any is provided
- Adjusted the styles due to some Atom v1.13.0 deprecation

## 1.0.4 2016-12-08 [YANKED]
- Atom.io was unavailable and it failed the release.

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

### Added
- Project's info files (AUTHORS, HEARTBEAT, CHANGELOG, LICENSE)
- A makefile to ease frequent task.

### Changed
- Made it works.
