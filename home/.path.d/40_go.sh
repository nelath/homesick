#! /bin/bash

# Go location
GOPATH=$(readlink -f "${HOME}/software")/go
GOROOT=${GOPATH}
export GOPATH GOROOT
