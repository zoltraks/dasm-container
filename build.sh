#!/bin/sh

DEFAULT_VERSION="2.20.15"
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

require_command() {
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
  HAS_CURL=0
  HAS_WGET=0
  
  command -v curl >/dev/null 2>&1 && HAS_CURL=1
  command -v wget >/dev/null 2>&1 && HAS_WGET=1
  
  if [ $HAS_CURL -eq 0 ] && [ $HAS_WGET -eq 0 ]
  then
    echo "Error: Neither curl nor wget is installed"
    exit 1
  fi
  
  if [ $HAS_CURL -eq 1 ]
  then
    curl --version | head -n 1
    curl -f -L -o "$FILE" "$URL" || exit 1
  else
    wget --version | head -n 1
    wget -P "$CACHE" "$URL" || exit 1
  fi
fi

require_command tar

if [ -d "$CACHE/dasm" ]
then
  rm -rf "$CACHE/dasm"
fi

mkdir -p "$CACHE/dasm"

tar -xzf "$FILE" -C "$CACHE/dasm"

require_command docker

docker buildx build --progress plain -t "$IMAGE" .

if [ $? -ne 0 ]
then
    echo
    echo "Error: Docker build failed"
    exit 1
fi

echo
echo "Now you can use docker command to compile your project using dasm"
echo
echo "docker run --rm -v \$(pwd):/src $IMAGE dasm main.asm -omain.prg"
echo
