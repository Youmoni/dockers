#!/bin/sh -x

echo "--------------------------------------------------------------------"
echo "Building Dockers"
echo "--------------------------------------------------------------------"

for d in $(find . -name Dockerfile -exec dirname {} \;); do
  if [ -d $d ]; then
    echo "Building $d"
    image=$(basename $d)
    version=$(git desciribe)
    tag="youmoni/$image:1.0.0"
    (cd $d; docker build -t $tag .; docker publish $tag)
  fi
done