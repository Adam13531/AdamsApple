#!/usr/bin/python3

# Tue 02/22/2022 - 01:30 PM - this is intended to be run with no
# arguments. It will copy a homepage file like "homepage (12).html" from
# Downloads to the proper homepage directory.

import os
import shutil
import time

def is_homepage_path(full_path):
  _, ext = os.path.splitext(full_path)
  filename = os.path.basename(full_path)
  return os.path.isfile(full_path) and filename.startswith("homepage") and ext == ".html"

def main():
  start_dir = "/Users/adam/Downloads"
  dest_file = "/Users/adam/Library/CloudStorage/OneDrive-Personal/Documents/Homepage/homepagerized.html"
  all_entries = os.listdir(start_dir)
  all_entries_full_paths = [os.path.join(start_dir, p) for p in all_entries]

  homepage_entries = list(filter(is_homepage_path, all_entries_full_paths))
  homepage_entries.sort(key=lambda p: os.path.getmtime(p), reverse=True)

  if len(homepage_entries) == 0:
    print("No homepage entries found in " + start_dir)
  else:
    latest = homepage_entries[0]
    print("Copying %s to %s" % (latest, dest_file))
    shutil.copyfile(latest, dest_file)


if __name__ == '__main__':
  main()
