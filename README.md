# Docker image for DASM

DASM is a versatile macro assembler with support for several 8-bit microprocessors
including MOS 6502, 6507, Motorola 6803, 68705, and 68HC11, Hitachi HD6303 and Fairchild F8.

Clone this repository and run build script.

```bash
./build.sh
```

This will automatically download binary release of dasm and build docker image from it.

[DASM GitHub repository](https://github.com/dasm-assembler/dasm)

## What the build script does

The `build.sh` script performs the following steps:

1. **Downloads DASM** - fetches the specified version of DASM binary release from GitHub (uses `curl` or `wget`)
2. **Caches the archive** - stores the downloaded file in a cache directory to avoid re-downloading
3. **Extracts files** - unpacks the tar.gz archive
4. **Builds Docker image** - creates a Docker image containing the DASM assembler

## Environment variables

You can customize the build process using the following environment variables.

| Variable | Default | Description |
|----------|---------|-------------|
| `VERSION` | `2.20.14.1` | DASM version to download and install |
| `CACHE` | `cache` | Directory where downloaded files are cached |
| `IMAGE` | `dasm` | Name for the resulting Docker image |
| `URL` | (auto-generated) | Custom download URL (overrides VERSION) |

### Examples

Build with a different DASM version.

```bash
VERSION=2.20.13 ./build.sh
```

Use a custom cache directory.

```bash
CACHE=/tmp/dasm-cache ./build.sh
```

Build with a custom image name.

```bash
IMAGE=my-dasm ./build.sh
```

Combine multiple variables.

```bash
VERSION=2.20.13 IMAGE=dasm-legacy CACHE=.cache ./build.sh
```

## Usage

Compile your assembly files using the Docker image.

```bash
docker run --rm -v $(pwd):/src dasm dasm main.asm -omain.prg
```
