# linter-pydocstyle

A [Linter][linter] plugin to lint Python docstrings according to the semantics
and conventions spec'd in [PEP 257][spec].

In use side-by-side with the flake8 linter:

![Screenshot of pydocstyle feedback](https://cloud.githubusercontent.com/assets/154988/9623112/5ee0bf1e-510a-11e5-815b-a339fa85ebac.png)

## Installation

1.  [Install Linter][install linter].

2.  Install python package [pydocstyle][], run:

    ```ShellSession
    pip install pydocstyle
    ```

3.  Install package, run:

    ```ShellSession
    apm install linter-pydocstyle
    ```

## Configuration

| Setting                             | Values                                                               |
| ----------------------------------- | -------------------------------------------------------------------- |
| Error codes to ignore               | Example: `D100,D101` - [all available error codes][pydocstyle codes] |
| Path to executable `pydocstyle` cmd | Default: pydocstyle                                                  |

If using python version management, like [pyenv][], the path configuration will
need to be set.  For pyenv, the path for pydocstyle is discoverable by executing:

```ShellSession
pyenv which pydocstyle
```

[linter]: https://github.com/atom-community/linter
[install linter]: https://github.com/atom-community/linter#installation
[pydocstyle]: https://pypi.python.org/pypi/pydocstyle
[pydocstyle codes]: http://pydocstyle.readthedocs.org/en/latest/error_codes.html
[pyenv]: https://github.com/yyuu/pyenv
[spec]: https://www.python.org/dev/peps/pep-0257/
