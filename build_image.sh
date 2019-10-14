#!/bin/bash

COMPONENT=$(python -c "print('${TRAVIS_TAG}'.split('-v')[0])")
echo "Component is ${COMPONENT}"
case "${COMPONENT}" in
  api-server)
    DOCKERFILE_PATH=backend/Dockerfile
    ;;

  viewer-crd-controller)
    DOCKERFILE_PATH=backend/Dockerfile.viewercontroller
    ;;

  *)
    echo "Unknown component ${COMPONENT}"
    exit 1
    ;;
esac

# BRANCH=$(git rev-parse --abbrev-ref HEAD | tr / - | tr _ -)
# SHORT_COMMIT=$(git log -n 1 --pretty=format:'%h')
IMAGE_TAG=$(python -c "print('v' + '${TRAVIS_TAG}'.split('-v')[1])")
IMAGE_NAME=${DOCKER_HUB_USERNAME}/kubeflow-pipelines-${COMPONENT}:${IMAGE_TAG}
echo "Image name is ${IMAGE_NAME}"
echo "$DOCKER_HUB_ACCESS_TOKEN" | docker login -u "$DOCKER_HUB_USERNAME" --password-stdin && \
  docker build -t $IMAGE_NAME -f $DOCKERFILE_PATH . && \
  docker push $IMAGE_NAME
