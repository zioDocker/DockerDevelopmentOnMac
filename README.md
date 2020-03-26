# DockerDevelopmentOnMac
Optimised docker development environent for Mac Os.
---

This repo has the purpose to provide an optimised docker environment for Mac Os using NFS and other best practises.
Docker for mac has known problems of filesystem performances, for this reasons using NFS seems to be a good workaround.
This script want to centralise the NFS docker configuration in one point, in order to be always able to set up docker
volumes for multiple project with NFS.

Technlogies used:
* [NFS](https://en.wikipedia.org/wiki/Network_File_System)

## How use it
clone this repository:
```
git clone git@github.com:zioDocker/DockerDevelopmentOnMac.git {my-project}
```

Now go in the folder **configuration/etc/exports** and add the path of the folders where your docker containers
and related volumes will run.

Start nfs script:
```
chmod +x nfs-start.sh
./nfs-start.sh
```

When the scripts ends, all the folders you mentioned in the configurations are ready to be used with volumes of type 
nfs3, here an example using docker-compose volume declaration:
```
volumes:
  my-volume:
    driver: local
    driver_opts:
      type: nfs
      device: ':${PWD}'
      o: addr=host.docker.internal,rw,nolock,hard,nointr,nfsvers=3
```

[Here and example](https://github.com/learning-by-failing/magento2ceDevEnvironment) about how this could work with a repo handling Magento2.

## Ispirations
This scipt is inspired from this 
[gist repo](https://gist.github.com/seanhandley/7dad300420e5f8f02e7243b7651c6657#file-setup_native_nfs_docker_osx-sh) 
and is resuming the solution coming from [this discussion](https://github.com/docker/for-mac/issues/1592)

