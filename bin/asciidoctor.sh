#!/bin/bash

function make_html() {
  echo "Build html: $1/$2 $3"
  if [ -n "$3" ]; then
    local NAME="-o $3.html"
  fi
  pushd $1 >/dev/null 2>&1 || return 1
    asciidoctor -a revnumber="${CI_COMMIT_REF_NAME}" \
      -a revdate="${NOW}" \
      ${REV_OPTION} \
      -r asciidoctor-diagram \
      -D "${CURRENT_DIR}/out/$1" \
      ${NAME} \
      "$2"
  popd >/dev/null 2>&1 || return 1
  if [ -e "fonts" ]; then
    cp -r fonts ${CURRENT_DIR}/out/$1
  fi
  if [ -e "$1/images" ]; then
    cp -r "$1/images" "${CURRENT_DIR}/out/$1"
  fi
}