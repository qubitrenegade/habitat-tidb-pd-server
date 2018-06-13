pkg_name=pd
pkg_distname=pd-server
pkg_origin=qubitrenegade
pkg_version=2.0.3
pkg_maintainer="QubitRenegade <qubitrenegade@gmail.com>"
pkg_license=("MPL-2")
pkg_source=http://download.pingcap.org/tidb-latest-linux-amd64.tar.gz
pkg_shasum=1c58d4837a0e6da6a034e8ff48da073f8119bd3c9bf3dc56442a42aed4978c6c
pkg_deps=(core/bash)
pkg_build_deps=()
pkg_bin_dirs=(bin)

pkg_exports=(
  [client-port]=cfg.client-port
  [peer-port]=cfg.peer-port
)

pkg_exposes=(client-port peer-port)

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
