#! /usr/bin/env nix-shell
#! nix-shell -i bash -p coreutils-full patchelf gnutar

set -euo pipefail

# The idea shamelessly stolen from:
# https://github.com/digital-asset/daml/blob/main/bazel_tools/packaging/package-app.sh

# Script usage:
# vendor.sh <binary> <desired-output-location>

abspath() { realpath -s "$@"; }
canonicalpath() { readlink -f "$@"; }

INPUT=$(abspath $1) 
WRAPPER_DIR_NAME=$(basename $INPUT)
ORIGIN=$(dirname $(canonicalpath $INPUT))
OUTPUT=$(abspath $2)
WORKDIR="$(mktemp -d)"

trap "rm -rf $WORKDIR" EXIT

copy_and_patchelf_deps() {
  local from target needed libOK rpaths top_rpaths
  ld=$1
  top_rpaths=$2
  from=$3
  target=$4

  needed=$(patchelf --print-needed "$from")
  rpaths="$(patchelf --print-rpath "$from"|tr ':' ' ') $top_rpaths"

  for lib in $needed; do
    if [ ! -f "$target/$lib" ]; then
      libOK=0
      for rpath in $rpaths; do
        rpath="$(eval echo $rpath)" # expand variables, e.g. $ORIGIN
        if [ -e "$rpath/$lib" ]; then
          libOK=1
          cp "$rpath/$lib" "$target/$lib"
          chmod u+rwx "$target/$lib"
          if [ "$lib" != "$ld" ]; then
            # clear the old rpaths (silence stderr as it always warns
            # with "working around a Linux kernel bug".
            patchelf --set-rpath '$ORIGIN' "$target/$lib" 2> /dev/null
          fi
          copy_and_patchelf_deps "$ld" "$top_rpaths" "$rpath/$lib" "$target"
          break
        fi
      done
      if [ $libOK -ne 1 ]; then
        echo "ERROR: Dynamic library $lib for $from not found from RPATH!"
        echo "RPATH=$rpaths"
        return 1
      fi
    fi
  done
}

vendor() {
  local binary binary_ld binary_rpaths wrapper
  mkdir -p $WORKDIR/$WRAPPER_DIR_NAME/lib

  binary="$WORKDIR/$WRAPPER_DIR_NAME/$WRAPPER_DIR_NAME.binary"
  cp $INPUT $binary
  chmod u+w $binary

  binary_ld=$(basename $(patchelf --print-interpreter "$binary"))
  binary_rpaths=$(patchelf --print-rpath "$binary"|tr ':' ' ')

  copy_and_patchelf_deps "$binary_ld" "$binary_rpaths" "$binary" "$WORKDIR/$WRAPPER_DIR_NAME/lib"

  patchelf --set-rpath '$ORIGIN/lib' "$binary"
  patchelf --set-interpreter ld-undefined.so "$binary"

  wrapper="$WORKDIR/$WRAPPER_DIR_NAME/$WRAPPER_DIR_NAME"
  cat > "${wrapper}" << EOF
#!/usr/bin/env sh
SOURCE_DIR="\$(cd \$(dirname \$(readlink -f "\$0")); pwd)"
LIB_DIR="\$SOURCE_DIR/lib"
exec \$LIB_DIR/${binary_ld} --library-path "\$LIB_DIR" "\$SOURCE_DIR/$WRAPPER_DIR_NAME.binary" "\$@"
EOF
  chmod a+x "$wrapper"
  cd $WORKDIR && mv $WRAPPER_DIR_NAME $OUTPUT
}

vendor
