#! /bin/bash

docker stop nginx-test
docker remove nginx-test
docker pull angrynerd2103/nginx-test:latest
docker run -d -p 80:80 --name nginx-test --restart always angrynerd2103/nginx-test:latest