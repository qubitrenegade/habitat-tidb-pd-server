pkg_name=pd
pkg_distname=pd-server
pkg_origin=qubitrenegade
pkg_version=2.0.3
pkg_maintainer="QubitRenegade <qubitrenegade@gmail.com>"
pkg_license=("MPL-2")
pkg_source=http://download.pingcap.org/tidb-v${pkg_version}-linux-amd64.tar.gz
pkg_shasum=5a5d153f3df4cb286de92619edae0f7de910f8f7c29a81385d2790ad13b5bb17
pkg_deps=(core/bash)
pkg_build_deps=()
pkg_bin_dirs=(bin)

pkg_exports=(
  [client-port]=client-port
  [peer-port]=peer-port
)

pkg_exposes=(client-port peer-port)

# Optional.
# pkg_svc_user="hab"
# pkg_svc_group="$pkg_svc_user"

pkg_description="PD - Placement Driver for TiKV; https://github.com/qubitrenegade/habitat-tidb-pd-server"
pkg_upstream_url="https://github.com/pingcap/pd"

do_clean() {
  # remove any old binaries
  build_line $(rm -rf ${HAB_CACHE_SRC_PATH}/tidb-v${pkg_version}-linux-amd64/)
  do_default_clean
}

do_prepare() {
  # the binaries are distributed together.  We'll separate them out now
  build_line $(cp -v ${HAB_CACHE_SRC_PATH}/tidb-v${pkg_version}-linux-amd64/bin/${pkg_name}* \
    ${HAB_CACHE_SRC_PATH}/$pkg_dirname)
}

do_build() {
  # We're just installing a binary, so do nothing during the "build" phase.
  return 0
}

do_install() {
  # iterate through all of the files in ${HAB_CACHE_SRC_PATH}/$pkg_dirname
  for i in ./${pkg_name}*; do
    install_path=${pkg_prefix}/bin/${i}
    build_line "installing ${i} to ${install_path}"
    install -D ${i} ${install_path}
  done
}
