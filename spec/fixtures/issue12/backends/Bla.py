from .. import *
from typing import Iterable

class Bla:
    def __init__(self, path: str) -> None:
        self.path = path

    def method(self, options: Iterable[str]) -> str:
        return call_command.call(["BLA"])

