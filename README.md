# linter-mypy

An [Atom][atom] [Linter][linter] plugin which display warnings related to Python optional static type as defined in [PEP 484][spec].

![Screen shot demo](https://github.com/elarivie/linter-mypy/raw/master/doc/ScreenShotDemo.png)

## Installation

1.  Install python package [mypy-lang][mypy], run:

    ```ShellSession
    python3 -m pip install mypy-lang
    ```

2. *(Optional)* Install python package typed-ast (required for the setting "Fast Parser"), run:

	```ShellSession
	python3 -m pip install typed-ast
	```

3.  [Install Linter][install linter].

	```ShellSession
	apm install linter
	```

4.  Install package, run:

    ```ShellSession
    apm install linter-mypy
    ```

## Configuration

| Setting                             | Values         |
| ----------------------------------- | -------------- |
| Path to executable `mypy` cmd       | Default: mypy  |
| Ignore File name Regex              | Default:       |
| Fast Parser                         | Default: True  |
| Disallow Untyped Calls              | Default: True  |
| Disallow Untyped Defs               | Default: True  |
| Check Untyped Defs                  | Default: True  |
| Disallow Subclassing Any            | Default: True  |
| Warn Incomplete Stub                | Default: True  |
| Warn Redundant Casts                | Default: True  |
| Warn No Return                      | Default: True  |
| Warn Unused Ignores                 | Default: True  |

If using python version management, like [pyenv][pyenv], the path configuration will
need to be set.  For pyenv, the path for mypy is discoverable by executing:

```ShellSession
pyenv which mypy
```

[linter]: https://github.com/atom-community/linter
[install linter]: https://github.com/atom-community/linter#installation
[mypy]: https://pypi.python.org/pypi/mypy-lang
[mypy homepage]: http://www.mypy-lang.org/
[pyenv]: https://github.com/yyuu/pyenv
[spec]: https://www.python.org/dev/peps/pep-0484/
[atom]: https://atom.io/
