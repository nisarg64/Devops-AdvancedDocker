#!/bin/sh

echo "Starting to build a docker image for a Simple Node.js App"
docker build -t ncsu-app .
echo "Docker Image build successfully complete"
docker tag ncsu-app localhost:5000/ncsu:latest
echo "Pushing the new docker image to private registry"
docker push localhost:5000/ncsu:latest
echo "Deploying Simple Node.js App on blue slice"
docker run -p 50100:8080 -d --name blue-app ncsu-app
echo "Deploying Simple Node.js App on green slice"
docker run -p 50101:8080 -d --name green-app ncsu-app
echo "Done"