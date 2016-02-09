#!/bin/bash
#

if [[ -z "$1" ]]; then
  echo $"Usage: $0 <VERSION> [ARCH]"
  exit 1
fi

NAME=consul-template
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

URL="https://releases.hashicorp.com/consul-template/${VERSION}/${ZIP}"
echo $"Creating ${NAME} RPM build file version ${VERSION}"

# fetching consul
curl -k -L -o $ZIP $URL || {
    echo $"URL or version not found!" >&2
    exit 1
}

# create target structure
mkdir -p target/usr/bin/
cp -r sources/${NAME}/etc/ target/

# unzip
unzip -qq ${ZIP} -d target/usr/bin/
rm ${ZIP}

# create rpm
fpm -s dir -t rpm -f \
       -C target -n ${NAME} \
       -v ${VERSION}_${CI_BUILD_ID} \
       -p target \
       -d "consul" \
       --config-files etc/sysconfig/consul-template \
       --after-upgrade spec/empty_upgrade.spec \
       --before-upgrade spec/empty_upgrade.spec \
       --after-install spec/template_install.spec \
       --before-remove spec/template_uninstall.spec \
       --description "Consul-template RPM package for RedHat Enterprise Linux 6" \
       --url "https://github.com/hypoport/consul-rpm-rhel6" \
       usr/ etc/

rm -rf target/etc target/usr
