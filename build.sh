#!/bin/sh

echo "--------------------------------------------------------------------"
echo "Building Dockers"
echo "--------------------------------------------------------------------"

for d in $(find . -name Dockerfile -exec dirname {} \;); do
  if [ -d $d ]; then
    echo "Building $d"
    image=$(basename $d)
    version=$(git describe --tags --abbrev=0 --always)
    tag="youmoni/$image:${version:1}"
    (cd $d; docker build -t $tag .; docker push $tag)
  fi
done