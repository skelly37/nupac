#!/usr/bin/env nu
# Use this script after runnning molecule converge to launch a shell within test docker container
docker exec -it --user ansible (docker ps|detect columns|where IMAGE =~ molecule|get ID.0) /usr/bin/nu