# Devops-AdvancedDocker

1) **File IO**: You want to create a container for a legacy application. You succeed, but you need access to a file that the legacy app creates.
* **Screencast**: https://youtu.be/jYzM69vhd5Y

- Create a [Dockerfile](https://github.com/nisarg64/Devops-AdvancedDocker/blob/master/FileIO/Dockerfile) for the Legacy Application that generates a file and use  socat to make its contents available on port 9001

- Build Docker file for Legacy Application
```
	docker build -t legacyappimage .
```

- Run Legacy App in a Legacy App Container
```
	docker run -it --rm --name legacyappcontainer legacyappimage
```

- Create a new container which is linked to Legacy App Container. This opens the bash shell of the container
```
	docker run -it --rm --name linkedcontainer --link legacyappcontainer ubuntu:14.04 /bin/bash
```

- Install curl in the the new container
```
	apt-get install curl
```

- Curl to the Legacy App Container at port 9001 to see the contents of the shared file
```	
  curl legacyappcontainer:9001
```


2) **Ambassador pattern**: Implement the remote ambassador pattern to encapsulate access to a redis container by a container on a different host.
* **Screencast**: https://youtu.be/fMNABcTAVcQ

- Setup two host machines with docker compose using "dbit/ubuntu-docker-fig" image
```	
	vagrant init dbit/ubuntu-docker-fig
```

- Create a private network, which allows host-only access to the machine using a IP Address: 192.168.33.10
  - Uncomment 'config.vm.network "private_network", ip: "192.168.33.10" ' in Vagrantfile of host machine 1.

- Start both machines using :
```	
	vagrant up
```

- ssh into Host Machine 1 and run [docker-compose.yml](https://github.com/nisarg64/Devops-AdvancedDocker/blob/master/AmbassadorPattern/Machine1/docker-compose.yml) to start the redis-server and redis ambassador image.
```
	sudo docker-compose up -d
```

  - Redis ambassador is linked to redis server through port 6379:6379 mapping.

- ssh into Host Machine 2 and run [docker-compose.yml](https://github.com/nisarg64/Devops-AdvancedDocker/blob/master/AmbassadorPattern/Machine2/docker-compose.yml) to start the redis-client and redis ambassador

- On Host2 we run redis-client which will automatically run redis-ambassador in this host2 with following command:
```
	sudo docker-compose run redis_client
```

- Set the key on redis client:
```
	set mykey "Hello World"
```

- Retrieve the key from redis-server
```
	get mykey
```

3) **Docker Deploy**: Extend the deployment workshop to run a docker deployment process.
* **Screencast**: https://youtu.be/NYQ6E6zkXIo

- Start private registry on port 5000.
```
	docker run -d -p 5000:5000 --restart=always --name registry registry:2
```

- Clone the App repository
```
	git clone https://github.com/CSC-DevOps/App.git
```

- Start [init-script.sh](https://github.com/nisarg64/Devops-AdvancedDocker/blob/master/DockerDeploy/init.sh) to do the following tasks:
  * Build a new docker image for a simple node.js app. 
  * Push the new docker image to the registry.
  * Deploy the App to Blue slice on port 50100 and Green slice on port 50101. 

- Check if the app is running in both the containers. 
```
	curl localhost:50100
	curl localhost:50101
```

- Change the message in the main.js file for blue slice. 

- A [commit](https://github.com/nisarg64/Devops-AdvancedDocker/blob/master/DockerDeploy/post-commit) will build a new docker image and push to the local registery. 

- Add remote origin for the blue and green slices
```
	git remote add blue "file://$ROOT/blue.git"
	git remote add green "file://$ROOT/green.git"
```

- [Deploy](https://github.com/nisarg64/Devops-AdvancedDocker/blob/master/DockerDeploy/post-receive-blue) the dockerized simple node.js App to blue slice. 
```
	git push blue master
	curl localhost:50100 
```

- Change the message in the main.js file for blue slice.

- [Deploy](https://github.com/nisarg64/Devops-AdvancedDocker/blob/master/DockerDeploy/post-receive-green) the dockerized simple node.js App to green slice.
```
	git push green master
	curl localhost:50101 
```
