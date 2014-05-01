#!/bin/bash
set -e

UPSTREAM_GIT="git://github.com/kr/pty"
SOURCE_NAME="golang-pty"

WORK_DIR=$(mktemp -d)
pushd ${WORK_DIR}

git clone ${UPSTREAM_GIT} ${SOURCE_NAME}
pushd ${SOURCE_NAME}

UPSTREAM_CONFIG=$(git log -n 1 --date="short" --pretty="%ad %h" | sed 's/\-//g')
UPSTREAM_DATE=$(echo ${UPSTREAM_CONFIG} | awk '{print $1}')
UPSTREAM_HASH=$(echo ${UPSTREAM_CONFIG} | awk '{print $2}')
ARCHIVE_NAME="golang-pty_0.0~git${UPSTREAM_DATE}.1.${UPSTREAM_HASH}.orig.tar.gz"

git archive \
    --prefix golang-pty_${UPSTREAM_HASH} \
    -o ../${ARCHIVE_NAME} \
    ${UPSTREAM_HASH}

popd

echo $(pwd)

popd

if [ ! -d ../tarballs/ ]; then
    mkdir -p ../tarballs/
fi

mv ${WORK_DIR}/${ARCHIVE_NAME} ../tarballs/

echo ""
echo "   ../tarballs/${ARCHIVE_NAME}"
echo ""
echo "   dch --newversion 0.0~git${UPSTREAM_DATE}.1.${UPSTREAM_HASH}-1 'New upstream release.'"
echo ""

rm -rf ${WORK_DIR}
