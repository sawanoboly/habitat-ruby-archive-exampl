pkg_name=rubygems4myscript
pkg_maintainer="SAWANOBORI Yukihiko <sawanoboly@mobingi.com>"
pkg_version=2.3.1
pkg_origin=sawanoboly
pkg_license=('Ruby')
pkg_source=nosuchfile.tar.gz
pkg_deps=(
  core/glibc
  core/ruby
  core/libffi
  core/bundler
)
pkg_build_deps=(
  core/ruby
  core/gcc
  core/make
  core/coreutils
  )
pkg_lib_dirs=(lib)
pkg_include_dirs=(include)
pkg_bin_dirs=(bin)

do_prepare() {
  build_line "Setting link for /usr/bin/env to 'coreutils'"
  [[ ! -f /usr/bin/env ]] && ln -s $(pkg_path_for coreutils)/bin/env /usr/bin/env
  [[ -d $PLAN_CONTEXT/.bundle  ]] && rm -rf $PLAN_CONTEXT/.bundle
  return 0
}

do_install() {
  # attach
  export CPPFLAGS="${CPPFLAGS} ${CFLAGS}"
  local _bundler_dir=$(pkg_path_for bundler)

  export GEM_HOME=${pkg_prefix}
  export GEM_PATH=${_bundler_dir}:${GEM_HOME}

  # attach
  BUNDLE_GEMFILE="$PLAN_CONTEXT/Gemfile" bundle install
  # attach

  for binexec in ${pkg_prefix}/bin/*; do
    build_line "Setting shebang for ${binexec} to 'core/ruby'"
    [[ -f $binexec ]] && sed -e "s#/usr/bin/env ruby#$(pkg_path_for core/ruby)/bin/ruby#" -i $binexec
  done

  if [[ `readlink /usr/bin/env` = "$(pkg_path_for coreutils)/bin/env" ]]; then
    build_line "Removing the symlink we created for '/usr/bin/env'"
    rm /usr/bin/env
  fi
}

do_download() {
  return 0
}

do_build() {
  return 0
}

do_verify() {
  return 0
}

do_unpack() {
  return 0
}

do_check() {
  return 0
}
