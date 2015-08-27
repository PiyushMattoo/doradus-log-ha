# Doradus LogHA Dockerfile

This is a highly configurable Doradus LogHA image running two instances of logstash and a custom Doradus GEM published to the public <a href="https://registry.hub.docker.com/">Docker Hub Registry</a>.  The docker container logs are read by mounting the directory containing your Docker data (`/var/log/` in the below example) into the containers `/host/var/log`. The Doradus LogHA container monitors the mounted directory, tailing the log files and buffers the log events to Redis. The image also monitors the linked Redis container, tailing the log files, queueing up batches of records and when it either reaches the maximum batch size or when the maximum idle time has elapsed then docker-redis-logstash would then write the log events to Doradus for enhanced performance reasons. The image employs the Doradus-logstash GEM to interact with Doradus which is characterized by batch_size, batch_wait and can be viewed at https://git.labs.dell.com/projects/BD/repos/logstash-output-batched_http/browse

## Environment Variables

Runtime behavior of docker-doradus-logstash can be modified by passing the below environment to `docker run` :

 * **`DORADUS_HOST`**: URL of the Doradus hosting server. 
 * **`DORADUS_PORT`**: Port-number of the Doradus service. 
 * **`DOCKER_APP_NAME`**: Docker app name. 
 * **`DOCKER_NAMESPACE`**: Docker namespace.  
 * **`DOCKER_DORADUS_USER`**: Doradus User.
 * **`DOCKER_DORADUS_PWD`**: Doradus Password.

## How to build the image

`sudo docker build -t pmattoo/doradus-logHA .`

## How to use this image

To start a basic container, execute the below command:
`docker run --link redis:redis --env DORADUS_HOST=<Doradus_Host_Name> --env DORADUS_PORT=<Doradus_Port> --env DOCKER_APP_NAME=<Docker_App_Name> --env DOCKER_NAMESPACE=<Docker_Namespace> --env DOCKER_DORADUS_USER=<Doradus_User> --env DOCKER_DORADUS_PWD=<Doradus_Password> --name <container-name> -i -t pmattoo/doradus-logHA`