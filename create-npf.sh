#!/bin/bash
set -exuo pipefail
HEADS_GIT_VERSION=$(git describe --tags)
BOARD=$1
cd ./build/${BOARD}/
sha256sum heads-${BOARD}-${HEADS_GIT_VERSION}.rom > sha256sum
zip heads-${BOARD}-${HEADS_GIT_VERSION}.npf heads-${BOARD}-${HEADS_GIT_VERSION}.rom sha256sum
