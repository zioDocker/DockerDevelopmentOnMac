# DockerDevelopmentOnMac
Optimised docker development environent for Mac Os.
---

This repo has the purpose to provide an optimised docker environment for Mac Os.

Technlogies used:
* [NFS](https://en.wikipedia.org/wiki/Network_File_System)

## How use it
clone this repo in your future project:
```
git clone git@github.com:ridesoft/nfsForDockerForMac.git {my-project}
```

Go to your new project, remove the git directory and start to create your new project with your new repo or add your new project like a git submodule

[Here and example](https://github.com/learning-by-failing/magento2ceDevEnvironment) about how this could work with a repo handling Magento2.

**Now before spin up your containers, just run `./nfs-start.sh` to start nfs server**

## Ispirations
This scipt is inspired from this [gist repo](https://gist.github.com/seanhandley/7dad300420e5f8f02e7243b7651c6657#file-setup_native_nfs_docker_osx-sh) and is resuming the solution coming from [this discussion](https://github.com/docker/for-mac/issues/1592)

