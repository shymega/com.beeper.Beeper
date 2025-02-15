import requests
import yaml
from sys import argv, exit
import argparse

PKG_BASE_URL: str = "https://download.todesktop.com/2003241lzgn20jd"
PKG_INDEX: str = f"{PKG_BASE_URL}/latest-linux.yml"

def get_pkg_index() -> dict:
    raw = requests.get(PKG_INDEX, allow_redirects=True).content.decode("utf-8")

    raw = yaml.safe_load(raw)

    return {
        "path": f"{PKG_BASE_URL}/{raw["path"]}",
        "sha512": raw["sha512"]
    }


def main():
    input_data = dict()
    with open(argv[1], 'r') as file:
        input_data = yaml.safe_load(file)

    print(get_pkg_index())
