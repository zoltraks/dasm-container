#!/bin/sh

DEFAULT_VERSION="2.20.14.1"
DEFAULT_CACHE="cache"
DEFAULT_IMAGE="dasm"

: ${VERSION:=$DEFAULT_VERSION}

echo "Selected version: $VERSION"

DEFAULT_URL="https://github.com/dasm-assembler/dasm/releases/download/$VERSION/dasm-$VERSION-linux-x64.tar.gz"

: ${URL:=$DEFAULT_URL}
: ${CACHE:=$DEFAULT_CACHE}
: ${IMAGE:=$DEFAULT_IMAGE}

mkdir -p "$CACHE"

FILE="$CACHE/dasm-$VERSION-linux-x64.tar.gz"

check_command() {
    local cmd="$1"
    command -v "$cmd" >/dev/null 2>&1
    if [ $? -ne 0 ]; then
        echo "Error: $cmd is not installed"
        exit 1
    fi
}

if [ -f "$FILE" ]
then
  echo "File $FILE already exists"
else
  check_command wget
  wget -P "$CACHE" "$URL" || exit 1
fi

check_command tar

if [ -d "$CACHE/dasm" ]
then
  rm -rf "$CACHE/dasm"
fi

mkdir -p "$CACHE/dasm"

tar -xzf "$FILE" -C "$CACHE/dasm"

check_command docker

docker buildx build --progress plain -t "$IMAGE" .

echo
echo "Now you can use docker command to compile your project using dasm"
echo
echo "docker run --rm -v \$(pwd):/src $IMAGE dasm main.asm -omain.prg"
echo
