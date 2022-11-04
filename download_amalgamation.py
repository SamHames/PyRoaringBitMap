"""
Helper script to download a specific release amalgamation file for CRoaring.

Usage: python download_amalgamation.py <croaring_release_version, like v0.6.0>

The version needs to be the specific release tag on github.

"""
import os
from urllib.request import urlretrieve
import sys

version = sys.argv[1]

release = f"https://github.com/RoaringBitmap/CRoaring/releases/download/{version}/"

print(f"Downloading version {version} of the croaring amalgamation")

files = ["roaring.c", "roaring.h"]

for file in files:
	r = urlretrieve(release + file, os.path.join("pyroaring", file))

print("If this is a new version of CRoaring, don't forget to update pyroaring/version.pxi")