# DockerDevelopmentOnMac
Optimised docker development environent for Mac Os.
---

This repo has the purpose to provide an optimised docker environment for Mac Os using NFS and other best practises.
Docker for mac has known problems of filesystem performances, for this reasons using NFS seems to be a good workaround.
This script want to centralise the NFS docker configuration in one point, in order to be always able to set up docker
volumes for multiple project with **NFS**.

In order to be able to handle multiple projects on the same machine, we use a **reverse proxy (Traefik)** that run in front of all our 
containers: all ports and traffic  are distributed dynamically by the reverse proxy and we have not to care about ports
 conflics

Technlogies used:
* [NFS](https://en.wikipedia.org/wiki/Network_File_System)
* [Traefik v1.7](https://github.com/containous/traefik)

## How use it
clone this repository:
```
git clone git@github.com:zioDocker/DockerDevelopmentOnMac.git {my-project}
```
Now there are three ways to use this repo:
* Use only the *NFS* server to speed up the filesystem running `/nfs-staert.sh` script
* Use *traefik* like reverse proxy for all your containers running `./traefik.sh` script
* Use as Nfs server as traefik running `/dev-start.sh` script.

### NFS Configuration
Now go in the folder **configuration/etc/exports** and add the path of the folders where your docker containers
and related volumes will run.

### NFS script

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

**Volume options are the most important part in your volume declaration, please use the same of the example above**

### Reverse proxy (Traefik)
Run the Traefik with the script:
```
./reverseProxy-start.sh
```

Now on [http://localhost:8080](http://localhost:8080) you can find Traefik dashboard where is possible to monitor 
all our running containers.
Every time you spin up a new container, this is visible immediately on traeffik.
Remember to configure labels inside your docker-compose files for your containers, i.e.:
```
web:
    image: nginx:latest
    labels:
        - traefik.backend=puls.local
        - traefik.frontend.rule=Host:mywebsite.local,www.mywebsite.local
        - traefik.docker.network=reverse-proxy
        - traefik.port=80
    networks:
        - reverse-proxy
```
All containers, to be visible outside of traffik, has to be part of the same Traeffik network (*revere-proxy)*

All containers, of the same application(i.e. inside the same docker-compose file) has to share the same network.

For more informations about Traefik and its configuration visit its website.

## Ispirations
- [http://nfs.sourceforge.net/](http://nfs.sourceforge.net/)
- This scipt is inspired from this 
[gist repo](https://gist.github.com/seanhandley/7dad300420e5f8f02e7243b7651c6657#file-setup_native_nfs_docker_osx-sh) 
and is resuming the solution coming from [this discussion](https://github.com/docker/for-mac/issues/1592)
- [https://www.tecmint.com/how-to-setup-nfs-server-in-linux/](https://www.tecmint.com/how-to-setup-nfs-server-in-linux/)
- [https://docs.docker.com/engine/reference/commandline/volume_create/](https://docs.docker.com/engine/reference/commandline/volume_create/)

