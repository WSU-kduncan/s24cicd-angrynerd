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
