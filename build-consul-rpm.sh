#!/bin/bash
#

if [[ -z "$1" ]]; then
  echo $"Usage: $0 <VERSION> [ARCH]"
  exit 1
fi

NAME=consul
VERSION=$1

if [[ -z "$2" ]]; then
  ARCH=`uname -m`
else
  ARCH=$2
fi

case "${ARCH}" in
    i386)
        ZIP=${NAME}_${VERSION}_linux_386.zip
        ;;
    x86_64)
       ZIP=${NAME}_${VERSION}_linux_amd64.zip
        ;;
    *)
        echo $"Unknown architecture ${ARCH}" >&2
        exit 1
        ;;
esac

URL="https://releases.hashicorp.com/consul/${VERSION}/${ZIP}"
echo $"Creating consul ${ARCH} RPM build file version ${VERSION}"

# fetching consul
curl -k -L -o $ZIP $URL || {
    echo $"URL or version not found!" >&2
    exit 1
}

# create target structure
mkdir -p target/usr/bin
mkdir -p target/etc/init.d
cp -r sources/consul/etc/ target/

# unzip
unzip -qq ${ZIP} -d target/usr/bin/
rm ${ZIP}

# create rpm
fpm -s dir -t rpm -f \
       -C target \
       -n consul \
       -v ${VERSION}_${CI_BUILD_ID} \
       -p target \
       -a ${ARCH} \
       --config-files etc/sysconfig/consul \
       --after-upgrade spec/service_upgrade.spec \
       --before-upgrade spec/service_upgrade.spec \
       --after-install spec/service_install.spec \
       --before-remove spec/service_uninstall.spec \
       --description "Consul RPM package for RedHat Enterprise Linux 6" \
       --url "https://github.com/hypoport/consul-rpm-rhel6" \
       usr/ etc/

rm -rf target/etc target/usr
