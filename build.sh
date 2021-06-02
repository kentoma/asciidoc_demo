#!/bin/bash

set -e

. ./bin/asciidoctor.sh

CURRENT_DIR=$(cd $(dirname ${BASH_SOURCE:-$0}) 1> /dev/null && pwd)

export TZ=Asia/Tokyo
NOW=$(date +"%Y/%m/%d %H:%M:%S")
NOW="$NOW $(date | awk '{print $5}')"

if [ -e "doc-links.adoc" ]; then
  rm doc-links.adoc
fi

if [ -e "${CURRENT_DIR}/out" ]; then
  rm -fr ${CURRENT_DIR}/out
fi
mkdir -p ${CURRENT_DIR}/out

if [ -z "${CI_COMMIT_REF_NAME}" ]; then
  CI_COMMIT_REF_NAME=local
fi

cat 'documents.tsv' | while read LINE; do
  IFS="$(echo -e '\t')"
  LINE=($LINE)
  unset IFS
  export DOC_NAME=${LINE[0]}
  export BASEPATH=${LINE[1]}
  export SRC_DOC=${LINE[2]}
  export REV_OPTION=`echo "${LINE[3]}" | tr -d '\r'`

  make_html ${BASEPATH} ${SRC_DOC} ${DOC_NAME}

  echo "* link:${BASEPATH}/${DOC_NAME}.html[] [link:${BASEPATH}/${DOC_NAME}.pdf[PDF]]" >> doc-links.adoc
done

# make_html . index.adoc index

if [ -e "doc-links.adoc" ]; then
  rm doc-links.adoc
fi
