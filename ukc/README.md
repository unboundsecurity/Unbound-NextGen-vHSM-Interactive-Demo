# Running UKC on docker

This setup will create a docker based environment that load EKM (EP+Partner+Aux). 
The Setup also 

* Uses CASP backup file

* Creates `casp` partition

* Set `password1!` for user, in `casp` partition

The docker containers will be setup to restart automatically when docker starts

## Prerequisites

Download EKM rpm to $HOME/unbound/setup

```bash
cd $HOME/unbound/setup
wget https://repo.dyadicsec.com/Products/ekm/EKM201812/snapshots/linux/ekm-2.0.1812.32053-RHES.x86_64.rpm
```

copy `casp_backup.pem` from `SVN\casp\services\casp-service` to `$HOME/unbound/setup`

## Initial Setup

Create EKM network

```bash
sudo docker network create ekm-net
```

Start EP

```bash
sudo docker run \
    --hostname ekm-ep \
    --name ekm-ep \
    -dit \
    --restart unless-stopped \
    --volume $HOME/unbound/setup:/setup \
    --net ekm-net \
    --publish=8443:443 \
    dyadic/ukc-centos \
    ep ekm-partner
```

Start Partner

```bash
sudo docker \
    run \
    --hostname ekm-partner \
    --name ekm-partner \
    -dit \
    --restart unless-stopped \
    --volume $HOME/unbound/setup:/setup \
    --net ekm-net \
    dyadic/ukc-centos \
    partner ekm-ep
```

Load Aux

``` bash
sudo docker \
     run    \
     --hostname ekm-aux \
     --name ekm-aux   \
     -dit \
     --restart unless-stopped \
     --volume $HOME/unbound/setup:/setup   \
     --net ekm-net   \
     dyadic/ukc-centos   \
     aux
```

### Connecting Aux

Add Aux

```
sudo docker exec -ti ekm-ep ucl server create -a ekm-aux -w Password1!
```

Restart Aux

```
sudo docker exec -ti ekm-aux bash
service ekm restart
exit
```

## Testing

Login to ep

```bash
sudo docker exec -ti ekm-ep bash
```

Run Test

```bash
ucl server test
```

View partitions

```bash
ucl partition list
```

Connect to running container and check something:

```bash
docker exec -it *_container_name_* /bin/bash
```

check UKC logs

```bash
cat  /opt/ekm/logs/ekm.log
```

