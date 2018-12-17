# linter-mypy

[![Build Status](https://travis-ci.org/elarivie/linter-mypy.svg?branch=master)](https://travis-ci.org/elarivie/linter-mypy)
[![linter-mypy_package](https://img.shields.io/apm/dm/linter-mypy.svg?style=flat-square)][linter-mypy_package]
[![linter-mypy_BugTracker](https://img.shields.io/github/issues/elarivie/linter-mypy.svg)][linter-mypy_BugTracker]

An [Atom][atom] [Linter][linter] plugin which displays warnings related to [Python][python] optional static type as defined in [PEP 484][spec] using [mypy][mypy homepage].

![Screen shot demo](https://github.com/elarivie/linter-mypy/raw/master/doc/ScreenShotDemo.png)

## Installation

1.  Install python package [mypy][mypy], run:

    ```ShellSession
    python3 -m pip install -U mypy
    ```

2.  Install atom package, run:

    ```ShellSession
    apm install linter-mypy
    ```

## Available settings

| Setting                                     | Default Values       |
| ------------------------------------------- | -------------------- |
| Lint trigger                                          |  `Lint on file save` |
| Path to the executable of [Python][python]            |     `python3`        |
| [Mypy Incremental][MypyIncremental]                   |     `True`           |
| [Mypy Incremental][MypyIncremental] Cache Folder Path |                      |
| Mypy Notify Internal Error                            |     `True`           |
| Ignore File path Regex                                |                      |
| [Mypy Path][MypyPath]                                 |                      |
| [Mypy ini File][OptMypyIni]                           |                      |
| [Follow Imports][OptFollowImports]                    |     `silent`         |
| [Namespace Packages][OptNamespacePackages]            |     `True`           |
| Disallow Untyped Calls                                |     `True`           |
| Disallow Untyped Defs                                 |     `True`           |
| Disallow Untyped Globals                              |     `True`           |
| Disallow Incomplete Defs                              |     `True`           |
| Check Untyped Defs                                    |     `True`           |
| Warn Incomplete Stub                                  |     `True`           |
| Disallow Untyped Decorators                           |     `True`           |
| Warn Redundant Casts                                  |     `True`           |
| Warn No Return                                        |     `True`           |
| Warn Return Any                                       |     `True`           |
| Disallow Subclassing Any                              |     `True`           |
| Disallow Any Unimported                               |     `True`           |
| Disallow Any Expr                                     |     `True`           |
| Disallow Any Decorated                                |     `True`           |
| Disallow Any Explicit                                 |     `True`           |
| Disallow Any Generics                                 |     `True`           |
| Warn Unused Ignores                                   |     `True`           |
| Warn Unused Configs                                   |     `True`           |
| Warn Missing Imports                                  |     `True`           |
| Strict Optional                                       |     `True`           |
| No Implicit Optional                                  |     `True`           |

[linter]: https://github.com/atom-community/linter
[install linter]: https://github.com/atom-community/linter#installation
[mypy]: https://pypi.python.org/pypi/mypy
[mypy homepage]: http://www.mypy-lang.org/
[spec]: https://www.python.org/dev/peps/pep-0484/
[atom]: https://atom.io/
[linter-mypy_repo]: https://github.com/elarivie/linter-mypy
[linter-mypy_package]: https://atom.io/packages/linter-mypy
[linter-mypy_BugTracker]: https://github.com/elarivie/linter-mypy/issues
[python]: https://www.python.org
[OptMypyIni]: http://mypy.readthedocs.io/en/latest/config_file.html
[OptFollowImports]: http://mypy.readthedocs.io/en/latest/command_line.html#following-imports-or-not
[OptNamespacePackages]: https://mypy.readthedocs.io/en/latest/command_line.html#import-discovery
[MypyPath]: http://mypy.readthedocs.io/en/latest/command_line.html#how-imports-are-found
[MypyIncremental]: http://mypy.readthedocs.io/en/latest/command_line.html#incremental
