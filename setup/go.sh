#!/bin/bash
set -e

echo "Creating go/src and workspace..."
go_src=${HOME}/go/src
if [ ! -e ${go_src} ]; then
  mkdir -pv ${HOME}/go/src
fi

if [ -L ${go_src} ]; then
  echo "${go_src} exists, but is a symbolic link"
fi

GO_UTILS=(
	code.cloudfoundry.org/perm/cmd/perm
	github.com/rakyll/hey
  github.com/alecthomas/gometalinter
  github.com/jteeuwen/go-bindata/...
  github.com/maxbrunsfeld/counterfeiter
  github.com/onsi/ginkgo/ginkgo
  github.com/onsi/gomega
  github.com/XenoPhex/i18n4go/i18n4go
)

echo "Running $(go version)"
for gopkg in "${GO_UTILS[@]}"; do
  echo "Getting/Updating $gopkg"
  GOPATH=$HOME/go go get -u $gopkg
done
