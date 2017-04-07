#!/bin/bash

for TAG in "$@"; do
  TAG_PARAMS+=" -t $TAG"
done

docker build ${TAG_PARAMS} ./dockerfiles/server.Dockerfile
result=$?

if [[ $result != 0 ]]; then
  echo "Error building docker image"
  exit 1
fi

echo "Success..."
exit 0
