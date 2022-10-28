"""
Helper script to download the latest amalgamation files for CRoaring.

"""
import os
from urllib.request import urlretrieve

latest_release = "https://github.com/RoaringBitmap/CRoaring/releases/latest/download/"

files = ["roaring.c", "roaring.h"]

for file in files:
	r = urlretrieve(latest_release + file, os.path.join("pyroaring", file))

print("If this is a new version of CRoaring, don't forget to update pyroaring/version.pxi")