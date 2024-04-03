# Project 4

## Project Overview

The goal for this project is to containerize a simple application in docker.
The application that will be used is the webserver software nginx along with a demo site.
Once the application has been successully containerize, the goal is to automate that project pipline 
using Github Actions (Continuous Integration).

## Part 1 - Dockerize It

- How to install Docker + Dependencies
  - I installed Docker on top of WSL2. For windows 10 as far as I know this is not doable directly from apt.
    Eg. `apt install docker`. With this in mind, I had to use Docker desktop.
  - To install WSL2 on Windows, open Powershell as administrator and run `wsl --install -d Ubuntu`.
    - You will have to reboot to finish the installation.
  - To install Docker desktop visit [Docker Website](https://www.docker.com/products/docker-desktop/) and 
    download the Windows executable. 
    - Run the installer and continue through it.
    - Once installed it will likely prompt you to create an account, and after that it will be up and running.
  - To test Docker in WSL2 run `Docker --help` or your test command of choice.

- How to build an image from the Dockerfile
  - The first step, and likely the most important, is ensure you have a Dockerfile.
    - For this project its pretty simple as it uses nginx as a base and copies in the demo site.
  - Once you have a Dockerfile and your desired demosite in the same directory (or atleast the prespecified 
    directories), then you can run `docker build -t image_name:tag .`. 
    - This will build an new image based on the Dockerfile with the name `image_name` and tag `tag`.

- How to run a container using the built image
  - To run a container using the image you can use the command `docker run --name container_name -p 80:80 -d image_name`.
    - This command will start a detatched container with the name `container_name`, expose system port 80 from container 
      port 80, from the image `image_name`.

- How to view the project once its running
  - To view the project once its running locally, open a web browser and enter the `address:port` of the project.
  - As I am running this locally and using the default port, I entered `localhost`.
  - If you were running it on an AWS instance or on a non default port you would enter `Elastic-ip:port`.

## Part 2 - Github Actions and Dockerhub

- How to create a public repo in Dockerhub
  - Using the account created when installing Docker desktop, go to the repositories section on hub.docker.com and
    click create repository.
    - Give the repository a title and description and click create.

- How to authenticate with Dockerhub via CLI
  - To login to Dockerhub use the command `docker login -u USERNAME -p PASSWORD`.
    - It is recommended to use a token instead of a password. You can generate a token using the account section
      of Dockerhub.

- How to push an image to Dockerhub
  - Assuming you have logged into Dockerhub on the CLI and have an image built, you can push the image to Dockerhub 
    by running `docker push USERNAME/IMAGE_NAME:TAG`.

- My Dockerhub repository
  - [Link](https://hub.docker.com/repository/docker/angrynerd2103/nginx-test/general)

- Configuring Github Secrets
  - How to create a Github secret
    - Go to your repository.
    - Click into the settings tab -> Secrets and Variables -> actions -> repository secrets.
    - Click add new repository secret and add it.
 - What secrets are in use for this project
   - DOCKER_USERNAME
   - DOCKER_TOKEN

- Behavior of Github actions
  - What does it do an when
    - The action for this project is docker build push.
    - It starts by setting up the environment.
    - Next it logs into Dockerhub.
    - Finally it builds and pushes the docker image.
  - Important variables for this action
    - Branch
    - Username
    - password
    - tags
    - Each of these will need to be modified to fit the values used by the specific person and project.

## Part 3 - Diagram
[Project Overview](#Project-Overview)