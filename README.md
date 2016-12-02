# linter-mypy

A [Linter][linter] plugin to lint Python optional static type as defined in [PEP 484][spec].

## Installation

1.  [Install Linter][install linter].

2.  Install python package [mypy-lang][], run:

    ```ShellSession
    pip install mypy-lang
    ```

3.  Install package, run:

    ```ShellSession
    apm install linter-mypy
    ```

## Configuration

| Setting                             | Values                                                               |
| ----------------------------------- | -------------------------------------------------------------------- |
| Path to executable `mypy` cmd | Default: mypy                                                  |

If using python version management, like [pyenv][], the path configuration will
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
