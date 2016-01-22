#!/bin/bash
#

if [[ -z "$1" ]]; then
  echo $"Usage: $0 <VERSION>"
  exit 1
fi

VERSION=$1


ZIP=consul_${VERSION}_web_ui.zip

URL="https://releases.hashicorp.com/consul/${VERSION}/${ZIP}"
echo $"Creating consul-ui RPM build file version ${VERSION}"

# fetching consul
wget --no-check-certificate -q $URL  || {
    echo $"URL or version not found!" >&2
    exit 1
}

# clear target foler
#rm -rf target/*

# create target structure
mkdir -p target/opt/consul-ui/
cp -r sources/consul-ui/etc/ target/

# unzip
unzip -qq ${ZIP} -d target/opt/consul-ui/
rm ${ZIP}

# create rpm
fpm -s dir -t rpm -f \
       -C target -n consul-ui \
       -v ${VERSION} \
       -p target \
       -d "consul" \
       --after-install spec/ui_install.spec \
       --rpm-ignore-iteration-in-dependencies \
       --description "Consul-UI RPM package for RedHat Enterprise Linux 6" \
       --url "https://github.com/hypoport/consul-rpm-rhel6" \
       opt/ etc/

rm -rf target/opt
