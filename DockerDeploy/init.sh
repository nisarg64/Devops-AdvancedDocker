#!/bin/bash

# Start a private registry
sudo docker run -d -p 5000:5000 --restart=always --name registry registry:2
echo " Registry successfully started "

cd ~/App
sudo docker build -t ncsu-app .
echo " Successfully built a new image for this application "
sudo docker tag ncsu-app localhost:5000/ncsu:latest
sudo docker tag localhost:5000/ncsu:latest localhost:5000/ncsu:current_blue
sudo docker tag localhost:5000/ncsu:latest localhost:5000/ncsu:current_green
echo " Tagged Images "

sudo docker push localhost:5000/ncsu:latest
sudo docker push localhost:5000/ncsu:current_green
sudo docker push localhost:5000/ncsu:current_blue
echo " Pushed all the tagged images to the registry "

sudo docker run -p 50100:8080 -d --name app_blue localhost:5000/ncsu:current_blue
sudo docker run -p 50101:8080 -d --name app_green localhost:5000/ncsu:current_green
echo " Successfully deployed the blue and green slices "
