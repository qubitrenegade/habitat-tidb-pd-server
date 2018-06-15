#!/usr/bin/env bash
hab pkg build .
source results/last_build.env
hab pkg export results/$pkg_artifact
