# Group 4 : Django webapp CICD

## #1 Goal

This project is a proof of concept (PoC) of a running pyhton app that need a postgres database.

:warning: The code here must not be used in production as we will only use the default python http server and default password

The app was given as is by EAZYTraining

## #2 Used tools

In order to achieve our goal we used :

- Docker : Used to build, run and test image artefacts
- Docker-compose : Used to run and test the full app, python with postgres
- Jenkins : Used to run all tests, delivering et deploying
- Ansible : Driven by Jenkins, used to deploy the full app on production & staging worker nodes
- GitHub : Used to store, share, organize source code and team work
- Vagrant : Used to build some demo VMs thanks to EAZYTraining

## #3 GitHub architecture

There are 2 major branches

- Main : The developpement branch where commits are first merged
- release : Used for production ready deployments, merged are done manualy from main once all funcionnal tests have been done from staging deployment.

## #4 Delivery architecture

Artefacts are the `docker` images built by `jenkins`, stored in the public docker hub `registry` under 2 tags :

- staging : This is the developpement tag used for staging environment
- release : Can be interpreted as the `latest` usually encountered, intended to be use in production environment

## #5 Deployment architecture

The 2 major branches, `Main` and `release`, are intended to run app in, respectively, `staging` and `production` environment worker nodes defined in the `Ansible playbook`
The 2 worker nodes are deployed using `vagrant` files given by EAZYTraining

- Centos 7 with :
  - Docker
  - Python

## #6 Security

We didn't hardened our PoC as it's a Poc with harcoded password (except for github and Docker hub) default python http server and so on, we well know that !

## #7 how to

You can't use this code out of the box, some informations are hardcoded so they will not fit your environment 
You should be able to run the `docker-compose.yaml` file, just run this command :

```shell
docker-compose up -d -f ./docker-compose.yaml
```
