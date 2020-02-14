#!/bin/bash

#
# by TS, May 2019
#

VAR_MYNAME="$(basename "$0")"

# ----------------------------------------------------------

# Outputs CPU architecture string
#
# @param string $1 debian_rootfs|debian_dist
#
# @return int EXITCODE
function _getCpuArch() {
	case "$(uname -m)" in
		x86_64*)
			echo -n "amd64"
			;;
		i686*)
			if [ "$1" = "qemu" ]; then
				echo -n "i386"
			elif [ "$1" = "s6_overlay" -o "$1" = "alpine_dist" ]; then
				echo -n "x86"
			else
				echo -n "i386"
			fi
			;;
		aarch64*)
			if [ "$1" = "debian_rootfs" ]; then
				echo -n "arm64v8"
			elif [ "$1" = "debian_dist" ]; then
				echo -n "arm64"
			else
				echo "$VAR_MYNAME: Error: invalid arg '$1'" >/dev/stderr
				return 1
			fi
			;;
		armv7*)
			if [ "$1" = "debian_rootfs" ]; then
				echo -n "arm32v7"
			elif [ "$1" = "debian_dist" ]; then
				echo -n "armhf"
			else
				echo "$VAR_MYNAME: Error: invalid arg '$1'" >/dev/stderr
				return 1
			fi
			;;
		*)
			echo "$VAR_MYNAME: Error: Unknown CPU architecture '$(uname -m)'" >/dev/stderr
			return 1
			;;
	esac
	return 0
}

_getCpuArch debian_dist >/dev/null || exit 1

# ----------------------------------------------------------

LVAR_DEBIAN_DIST="$(_getCpuArch debian_dist)"
LVAR_DEBIAN_RELEASE="buster"
LVAR_DEBIAN_VERSION="10.02"

LVAR_LIBYAML_VERSION="0.2.2"
LVAR_PYYAML_VERSION="5.2"
LVAR_JINJA2_VERSION="2.10.3"
LVAR_MARKUPSAFE_VERSION="1.1.1"
LVAR_J2CLI_VERSION="0.3.12b"

LVAR_IMAGE_NAME="app-jinja2-${LVAR_DEBIAN_DIST}"
LVAR_IMAGE_VER="$LVAR_JINJA2_VERSION"

# ----------------------------------------------------------

cd build-ctx || exit 1

LVAR_SRC_OS_IMAGE="tsle/os-debian-${LVAR_DEBIAN_RELEASE}-${LVAR_DEBIAN_DIST}:${LVAR_DEBIAN_VERSION}"
docker pull $LVAR_SRC_OS_IMAGE || exit 1
echo

docker build \
		--build-arg CF_SRC_OS_IMAGE="$LVAR_SRC_OS_IMAGE" \
		--build-arg CF_LIBYAML_VERSION="$LVAR_LIBYAML_VERSION" \
		--build-arg CF_PYYAML_VERSION="$LVAR_PYYAML_VERSION" \
		--build-arg CF_JINJA2_VERSION="$LVAR_JINJA2_VERSION" \
		--build-arg CF_MARKUPSAFE_VERSION="$LVAR_MARKUPSAFE_VERSION" \
		--build-arg CF_J2CLI_VERSION="$LVAR_J2CLI_VERSION" \
		-t "$LVAR_IMAGE_NAME":"$LVAR_IMAGE_VER" \
		. || exit 1

docker image tag \
		"$LVAR_IMAGE_NAME":"$LVAR_IMAGE_VER" \
		"$LVAR_IMAGE_NAME":latest
