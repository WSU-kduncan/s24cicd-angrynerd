# Project 4

## Project Overview

The goal for this project is to:
  - Implement semantic versioning into the github workflow via `git tag`.
  - Utilize `webhooks` to automatically deploy new container images on an AWS instance.

## Part 1 Semantic Versioning

- How to create a `git tag`
  - To create a `git tag` you need to run `git tag v*.*.*` where the *'s are the specific version numbers.
  - This will create a local tag for the latest commit. 
  - Then you need to run `git push (source) v*.*.*` where source is the remote destination. This makes the tag visible on github
    and will be what triggers your workflow.
    - The source is normally `origin` but in my case working with both github desktop and git on the command line, I had to add
      an additional `ssh` source.

- The next step is the github workflow
  - This builds of of the previous workflow with the important inclusion of the `docker-metadata@v5` action.
  - After the modifications the workflow does the following:
    - Runs on push of a tag formatted as `v*.*.*`.
    - Checks out your github repo.
    - Generates dockerhub tags using your repo/image_name and specified patterns. In this case `version` which uses the entire
      `*.*.*` tag, `major.minor` which uses `*.*`, and finally `major` which uses `*`.
    - Builds the docker image based on the current commit and tags it with the generated tags.
    - Finally the tagged images are uploaded to dockerhub.

- [DockerHub Repo](https://hub.docker.com/r/angrynerd2103/nginx-test/tags)

## Part 2 Deployment

- Installing Docker on your instance
  - To install docker on an ubuntu AWS instance Docker's documentation says to do this.
  - First run these commands in order
    ```# Add Docker's official GPG key:
       sudo apt-get update
       sudo apt-get install ca-certificates curl
       sudo install -m 0755 -d /etc/apt/keyrings
       sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
       sudo chmod a+r /etc/apt/keyrings/docker.asc

       # Add the repository to Apt sources:
       echo \
        "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
        $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
        sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
       sudo apt-get update```
  - This updates apt, installs dockers GPG key, and adds the docker repository to apt.
  - Next run this:
    - `sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin`
    - This command is what installs Docker and its components from apt.
  - Now Docker should be running. You can test it with `systemctl` or Docker's own `hello-world` container.

- Setting up a container restart script
  - [script](deployment/deploy.sh)
  - This script starts by killing and removing the desired container.
  - Next it pulls a fresh image from dockerhub.
  - Finally it starts the new image detatched and set to auto restart.
  - For my setup this script is place in `/home/ubuntu/deploy.sh` however as long as you modify hooks.json you can store the 
    script where ever you prefer.

- Installing and setting up Adnanh's Webhook
  - On ubuntu to install webhook, all you need to do is run `sudo apt install webhook`.
    - If webhook was not in `apt` you would need to build it from source.
  - Next you need to create a `hooks.json` file. The location does not matter as it is specified later.
    - I have mind stored in `/home/ubuntu` as well.
    - [hooks](deployment/hooks.json)
    - The hooks file has an `id`, `execute-command`, and `command-working-directory`.
      - The `id` is the name of the webhook to be called later.
      - The `execute-command` is what the hook runs when called. In this case its the path to the deploy script.
      - Lastly, `command-working-directory` is the working directory used when the script is executed.
  - Once you have a `hooks.json` file you can start your webhook with `webhook --hooks /path/to/hooks.json --verbose`.
  - To start the webhooks automatically you need to create a service file like [this](deployment/webhook.service).
    - To do so you need to create a file called `webhooks.service` in `/etc/systemd/system`.
    - In the file you need 3 things.
      - A `Unit` section where you specify the service description.
      - The `Service` section where you put the webhook start command.
      - And an `Install` section that contains this `WantedBy=multi-user.target`.
        - This basically says where in the startup process to start this service.
    - With that in place you can now run these commands manage the webhook service.
      - `sudo systemctl daemon-reload` reloads systemctl allowing it to see the service file changes.
      - `sudo systemctl start webhook.service` will start the service. Needs to be ran the first time atleast.
      - `sudo systemctl status webhook.service` allows you to see if its running and view the logs when a hook is triggered.
  - Adding this webhook to github
    - Go to your repository settings and to the webhooks section.
    - Add webhook link which is `ip.of.aws.instance:9000/hooks/hook_id`.
    - Configure the conditions in which you want it to trigger, in this case on workflow run.
      