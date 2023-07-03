#!/usr/bin/python3
# Usage: python3 ccd.py [path1] [path2] [...]

import os
import sys

def get_parent_dir(path, num_levels):
  for i in range(num_levels):
    path = os.path.dirname(path)
  return path

def get_immediate_subdirectories(path):
  all_entries = os.listdir(path)
  return list(filter(lambda p: os.path.isdir(os.path.join(path, p)), all_entries))

def ccd(paths):
  working_path = os.getcwd()
  for path in paths:
    if path == "..":
      working_path = get_parent_dir(working_path, 1)
    elif path == "...":
      working_path = get_parent_dir(working_path, 2)
    elif path == "....":
      working_path = get_parent_dir(working_path, 3)
    elif path == ".....":
      working_path = get_parent_dir(working_path, 4)
    elif os.path.isdir(os.path.join(working_path, path)):
      working_path = os.path.join(working_path, path)
    else:
      subdirs = get_immediate_subdirectories(working_path)
      matched = False

      # Try a case-sensitive partial match
      for subdir in subdirs:
        if subdir.startswith(path) or (path.startswith("*") and path[1:] in subdir):
          working_path = os.path.join(working_path, subdir)
          matched = True
          break
      # Try a case-insensitive partial match
      if not matched:
        lower_path = path.lower()
        for subdir in subdirs:
          lower_subdir = subdir.lower()
          if lower_subdir.startswith(lower_path) or (lower_path.startswith("*") and lower_path[1:] in lower_subdir):
            working_path = os.path.join(working_path, subdir)
            matched = True
            break

      if not matched:
        subdirs.sort()
        print("No directory matches %s: %s" % (path, str(subdirs)))
        sys.exit(1)

  print(working_path)

def main():
  ccd(sys.argv[1:])

if __name__ == '__main__':
  main()
