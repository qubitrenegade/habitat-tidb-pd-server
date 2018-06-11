# This file is the heart of your application's habitat.
# See full docs at https://www.habitat.sh/docs/reference/plan-syntax/
pkg_name=pd
pkg_distname=pd-server
pkg_origin=qubitrenegade
pkg_version=2.0.3
pkg_maintainer=""
pkg_license=("MPL-2")
pkg_source=http://download.pingcap.org/tidb-latest-linux-amd64.tar.gz
pkg_shasum="37ddca23b740510c48510f637b64d3636dbff9f0c7614e6773b1e0c0d3841b1b"
pkg_deps=(core/bash)
pkg_build_deps=()
pkg_bin_dirs=(bin)

# Optional.
# An associative array representing configuration data which should be gossiped to peers. The keys
# in this array represent the name the value will be assigned and the values represent the toml path
# to read the value.
# pkg_exports=(
#   [host]=srv.address
#   [port]=srv.port
#   [ssl-port]=srv.ssl.port
# )

# Optional.
# An array of `pkg_exports` keys containing default values for which ports that this package
# exposes. These values are used as sensible defaults for other tools. For example, when exporting
# a package to a container format.
# pkg_exposes=(port ssl-port)

# Optional.
# An associative array representing services which you depend on and the configuration keys that
# you expect the service to export (by their `pkg_exports`). These binds *must* be set for the
# Supervisor to load the service. The loaded service will wait to run until it's bind becomes
# available. If the bind does not contain the expected keys, the service will not start
# successfully.
# pkg_binds=(
#   [database]="port host"
# )


# Optional.
# Same as `pkg_binds` but these represent optional services to connect to.
# pkg_binds_optional=(
#   [storage]="port host"
# )

# Optional.
# pkg_svc_user="hab"
# pkg_svc_group="$pkg_svc_user"

pkg_description="PD - Placement Driver for TiKV; "
pkg_upstream_url="https://github.com/pingcap/pd"

do_clean() {
  # remove any old binaries
  rm -rf ${HAB_CACHE_SRC_PATH}/tidb-latest-linux-amd64/
  do_default_clean
}

do_prepare() {
  # the binaries are distributed together.  We'll separate them out now
  cp -v ${HAB_CACHE_SRC_PATH}/tidb-latest-linux-amd64/bin/${pkg_name}* \
    ${HAB_CACHE_SRC_PATH}/$pkg_dirname
}

do_build() {
  # We're just installing a binary, so do nothing during the "build" phase.
  return 0
}

do_install() {
  # iterate through all of the files in ${HAB_CACHE_SRC_PATH}/$pkg_dirname
  for i in ./${pkg_name}*; do
    install_path=${pkg_prefix}/bin/${i}
    echo "installing ${i} to ${install_path}"
    install -D ${i} ${install_path}
  done
}
