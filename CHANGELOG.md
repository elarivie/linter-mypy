# Change Log

All notable changes to this project will be documented in this file.
The format is based on [Keep a Changelog](http://keepachangelog.com/)
and this project adheres to [Semantic Versioning](http://semver.org/).

## [Unreleased]

### Changed

## [Released] - 2.6.12 2021-01-29

- Adjusted to change of MyPy 0.800

## [Released] - 2.6.11 2020-10-16

### Changed

- Adjusted to change of MyPy 0.790

### Fixed
- Python path variable scope

## [Released] - 2.6.10 2020-05-01

### Changed

- Made the Mypy internal error detection less picky
- Adjusted to change of MyPy 0.770

## [Released] - 2.6.9 2020-01-08

### Changed

- Run mypy with CWD set to the directory of the configuration file if provided (To allow relative path defined in the configuration file to work as expected).

- Use path.delimiter instead of hard coded ':' (Windows path separator is ';')

### Added

- New setting to define PYTHONPATH
- User friendly message to guide a user which does not have the required module 'typed-ast' installed.

### Fixed

- Removed an out of scope variable when reporting issue related to mypy config file.

## [Released] - 2.6.8 2019-12-11

### Changed

- Use the new cli parameter "[--show-absolute-path](https://mypy.readthedocs.io/en/latest/command_line.html#cmdoption-mypy-show-absolute-path)" added in MyPy 0.750 to avoid relying on a black magic trick of setting CWD to root when calling MyPy to obtain full file path.

 - Note: CWD must still be set at root due to one last reason — [Mypy Bug2974](https://github.com/python/mypy/issues/2974).

### Fixed

- Adjusted unit tests to match changes of MyPy 0.750

## [Released] - 2.6.7 2019-11-25


### Changed

- Rename the linter-mypy setting 'Mypy Ini File' -> 'Mypy Config File' since supported config files are not limited to ini (mypy.ini and setup.cfg)


## [Released] - 2.6.6 2019-11-01 [YANKED]


## [Released] - 2.6.5 2019-08-19

### Fixed

- Fix unit test.

### Added

- Argument no-implicit-reexport
- Argument warn-unreachable

### Changed

- Adjusted to change of MyPy 0.740

### Fixed

- Fix 'reveal_type'.

## [Released] - 2.6.4 2019-04-07

### Added

- Argument Strict Equality

## [Released] - 2.6.3 2019-04-02

### Changed

- Adjusted to change of MyPy 0.600
- Adjusted to change of MyPy 0.610
- Adjusted to change of MyPy 0.620
- Adjusted to change of MyPy 0.630
- Adjusted to change of MyPy 0.650
- Adjusted to change of MyPy 0.670

## [Released] - 2.6.2 2018-04-25

### Changed

- Adjusted to change of MyPy 0.590

## [Released] - 2.6.1 2018-03-09

### Changed

- Adjusted to change of MyPy 0.570

## [Released] - 2.6.0 2018-02-17

### Added

- The possibility to specify the Mypy Incremental cache location.

### Changed

- Reordered the settings.
- Display more output when running BUILDME

## [Released] - 2.5.2 2018-02-08

### Changed

- Correctly handle when no file path is provided by the editor.

## [Released] - 2.5.1 2018-01-20

### Changed

- Fix a bug where a new temp folder was created for each lint run instead of reusing those previously created.

## [Released] - 2.5.0 2018-01-20

### Added
- A setting to choose between "Lint as you type" or "Lint on file save".
- A setting to use Mypy experimental incremental analysis.
- Create & delete a random temporary folder to store the Mypy cache data.
- Documentation links on the README and within the settings.

### Changed
- Improve some Specs structure.
- If not using incremental mode, then no ".mypy_cache" folder gets created.

## [Released] - 2.4.4 2017-12-31

### Added
- A lot of new Specs.
- Heuristics for certain lint message.

### Changed
- Some lint now have a severity of Error (undefined name, invalid syntax, inconsistent indentation).
- Micro speed optimization related to not verifying some heuristics when we already can deduce they won't apply.
- Reorganized specs.
- Isolated some logic in their own function.
- Fix a bug related to the setting "noImplicitOptional" not being refreshed live.

## [Released] - 2.4.3 2017-11-17

### Changed
- Adapt to settings to match [Mypy 0.550](http://mypy-lang.blogspot.ca/2017/11/mypy-0550-released.html) command lines parameters changes.

## [Released] - 2.4.2 2017-11-09

### Added
- User friendly support of Mypy Internal Error.

## [Released] - 2.4.1 2017-10-22

### Added
- The possibility to use the variables $PROJECT_PATH and $PROJECT_NAME in the settings when defining the MYPYPATH.

### Changed
 - Reordered the settings.

### Fixed
- Fix a bug where $PROJECT_NAME was truncated if it was containing a dot.

## [Released] - 2.4.0 2017-10-17

### Changed
 - Adjusted to the command line interface change of MyPy 0.530

### Added
  - Add the setting "--warn-unused-configs"
  - Add the setting "--disallow-incomplete-defs"
  - Add the setting "--disallow-untyped-decorators"

## [Released] - 2.3.0 2017-09-12

### Added
 - Add the setting "Mypy Path"

## [Released] - 2.2.0 2017-07-15

### Added
 - Add the setting "No Implicit Optional"
 - Add the setting "Disallow Any"

### Changed
 - Adjusted to the command line interface change of mypy 0.520

## [Released] - 2.1.5 2017-07-01

### Changed
- Improved underlining heuristics.

## [Released] - 2.1.4 2017-06-05

### Added
- User friendly support for mypy [reveal_type](http://mypy.readthedocs.io/en/latest/cheat_sheet_py3.html#when-you-re-puzzled-or-when-things-are-complicated).

### Changed
- No more filter warnings which are in another file than the one being explicitly linted (related to the setting "Follow Imports")
- Updated the screen shot to show the behavior of [reveal_type](http://mypy.readthedocs.io/en/latest/cheat_sheet_py3.html#when-you-re-puzzled-or-when-things-are-complicated).

## [Released] - 2.1.3 2017-06-02

### Added
- The setting "Follow Imports"

## [Released] - 2.1.2 2017-06-01

### Changed
- Simplified installation instruction.

### Fixed
- Fix issue related to [Mypy Bug2974](https://github.com/python/mypy/issues/2974).

## [Released] - 2.1.1 2017-05-30

### Added
- Workaround for [Mypy Bug2974](https://github.com/python/mypy/issues/2974).

### Fixed
- Fix build by Upgrading TravisCi settings.

## [Released] - 2.1.0 2017-05-12

### Changed
- Updated the screen shot using Linter v2.X.X.
- The build success status is no more depend on the optional external tool "ncu".
- Removed the deprecated setting "--strict-boolean"
- Removed the deprecated setting "--fast-parser", "--no-fast-parser"
- Adjusted to the command line interface change of mypy 0.511
- http://mypy-lang.blogspot.ca/2017/05/mypy-0510-released.html
- Updated the README.

## [Released] - 2.0.12 2017-03-29

### Fixed
- Correctly handle warnings for which Mypy does not provide a start column.

## [Released] - 2.0.11 2017-03-28

### Changed
- Updated the dependency [Linter](https://libraries.io/atom/linter) to v2.X.X.

## [Released] - 2.0.10 2017-03-18

### Added
- The possibility to define in the settings a variable path to Python using the project path as a variable in the path.
- The possibility to use [mypy configuration file](http://mypy.readthedocs.io/en/latest/config_file.html) (related to the command line parameter --config-file).

## [Released] - 2.0.9 2017-03-14

### Added
- The possibility to define in the settings a variable path to Python using the project name as a variable in the path.

### Changed
- Better error message when mypy does not seem to be at the latest version.

## [Released] - 2.0.8 2017-03-13

### Changed
- The error message when mypy does not seem to be at the latest version (Quick fix).

## [Released] - 2.0.7 2017-03-12

### Changed
- Synched the commanand line parameters with mypy 0.501
- Updated the dependencies version

### Added
 - Add the setting "Warn Return Any"
 - Add the setting "Strict Boolean"
 - Add the setting "Strict Optional"

## [Released] - 2.0.6 2017-03-11

### Added
- The setting "Warn Missing Imports" (related to --ignore-missing-imports).

## [Released] - 2.0.5 2017-02-21

### Changed
- Only the filename is provided to mypy instead of the fullpath.
- Small Optimization

## [Released] - 2.0.4 2017-02-20

### Fixed
- Support mypy warnings to be reported with relative or absolute path.
 - For an unkown reason on some system mypy reports warning using relative path and on other system with absolute path.

## [Released] - 2.0.3 2017-02-08

### Fixed
- Fix minor bug in error handling.

## [Released] - 2.0.2 2017-02-06

### Added
- Comments in the code.
- Specs to validate the underlining position with and without fast-parser.
- Support for Windows.

### Changed
- It was found that mypy does not report the same start column of warnings with/without the option --fast-parser.
 - Improved the heuristic logic for underlining to behave correctly with and without fast-parser.

## [Released] - 2.0.1 2017-02-04

### Added
- A spec to validate that no warnings external to the file being linted are reported.

### Changed
- Greatly improved and simplified the ignore logic of errors which are outside of the file being linted.

## [Released] - 2.0.0 2017-02-02

### Changed
- The setting "Path to the executable" now has to point to Python instead of mypy.
 - This is a breaking change, a user friendly warning pop-up to help the transition.
- Now uses the python package *mypy* instead of *mypy-lang* since the package was renamed starting with version mypy 4.7.0:
 - http://mypy-lang.blogspot.ca/2017/01/mypy-0470-released.html
- Updated the README.
- Adjusted to the command line interface change of mypy 4.7.0

## [Released] - 1.0.9 2017-01-11

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

## 1.0.8 2017-01-11 [YANKED]
- APM publish failed, the process is so picky...

## 1.0.7 2017-01-11 [YANKED]
- APM publish failed, the process is so picky...

## [Released] - 1.0.6 2016-12-12

### Fixed
- Fix a bug which was creating an issue to a file path starting by undefined.

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
