# linter-mypy

A [Linter][linter] plugin to lint Python optional static type as defined in [PEP 484][spec].

In use side-by-side with the flake8 linter:

![Screenshot of mypy feedback](https://cloud.githubusercontent.com/assets/154988/9623112/5ee0bf1e-510a-11e5-815b-a339fa85ebac.png)

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
| Error codes to ignore               | Example: `D100,D101` - [all available error codes][pydocstyle codes] |
| Path to executable `pydocstyle` cmd | Default: pydocstyle                                                  |

If using python version management, like [pyenv][], the path configuration will
need to be set.  For pyenv, the path for pydocstyle is discoverable by executing:

```ShellSession
pyenv which mypy
```

[linter]: https://github.com/atom-community/linter
[install linter]: https://github.com/atom-community/linter#installation
[mypy]: https://pypi.python.org/pypi/mypy-lang
[mypy homepage]: http://www.mypy-lang.org/
[pyenv]: https://github.com/yyuu/pyenv
[spec]: https://www.python.org/dev/peps/pep-0484/
