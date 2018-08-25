#!/usr/bin/env bash
hab pkg build .
source results/last_build.env
hab pkg export docker results/$pkg_artifact
