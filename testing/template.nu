#!/usr/bin/env nu
# Use this script to view rendered Dockerfiles
# Requires jinja-cli installed
open molecule/default/molecule.yml
|get platforms.0
|echo {item: $in}
|to json
|jinja -d - -f json molecule/default/Dockerfile.j2