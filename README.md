Traccar in Docker
---

Traccar GPS Tracking System in Docker image.

Official website: <https://www.traccar.org>  
DockerHub image: <https://hub.docker.com/r/traccar/traccar>

[![](https://images.microbadger.com/badges/version/traccar/traccar:4.10.svg)](https://microbadger.com/images/traccar/traccar:4.10)
[![](https://images.microbadger.com/badges/image/traccar/traccar:4.10.svg)](https://microbadger.com/images/traccar/traccar:4.10)

### Available tags:
- **4.10-alpine**, **4-alpine**, **4.10**, **alpine**, **latest**
- **4.10-debian**, **4-debian**, **debian**
- **4.9-alpine**, **4.9**
- **4.9-debian**
- **4.8-alpine**, **4.8**
- **4.8-debian**
- **4.7-alpine**, **4.7**
- **4.7-debian**
- **4.6-alpine**, **4.6**
- **4.6-debian**
- **4.5-alpine**, **4.5**
- **4.5-debian**
- **4.4-alpine**, **4.4**
- **4.4-debian**
- **4.3-alpine**, **4.3**
- **4.3-debian**
- **4.2-alpine**, **4.2**
- **4.2-debian**
- **4.1-alpine**, **4.1**
- **4.1-debian**
- **4.0-alpine**, **4.0**
- **4.0-debian**
- **3.17-alpine**, **3.17**
- **3.17-debian**
- **3.16-alpine**, **3.16**
- **3.16-debian**

### Container create example:
1. **Create work directories:**
    ```bash
    mkdir -p /var/docker/traccar/logs
    ```

1. **Get default traccar.xml:**
    ```bash
    docker run \
    --rm \
    --entrypoint cat \
    traccar/traccar:latest \
    /opt/traccar/conf/traccar.xml > /var/docker/traccar/traccar.xml
    ```

1. **Edit traccar.xml:** <https://www.traccar.org/configuration-file/>

1. **Create container:**
    ```bash
    docker run \
    -d --restart always \
    --name traccar \
    --hostname traccar \
    -p 80:8082 \
    -p 5000-5150:5000-5150 \
    -p 5000-5150:5000-5150/udp \
    -v /var/docker/traccar/logs:/opt/traccar/logs:rw \
    -v /var/docker/traccar/traccar.xml:/opt/traccar/conf/traccar.xml:ro \
    traccar/traccar:latest
    ```

### Database
The default when executing the above `docker run` command is an internal H2 database but this should only be for basic use. 

The `docker run` command also doesn't create a mount point on the host for the data folder which will cause the database to be lost when the container is recreated. This point can be mitigated by adding the line `-v /var/docker/traccar/data:/opt/traccar/data:rw \` after `-v /var/docker/traccar/traccar.xml:/opt/traccar/conf/traccar.xml:ro \` but it will still be using the H2 database.

The **recommended solution** for production use is to link to an external MySQL database and update the configuration .xml file according to the [Traccar MySQL documentation](https://www.traccar.org/mysql/) and using the `docker run` command as-is.

### Default JVM options:
- -Xms512m
- -Xmx512m
- -Djava.net.preferIPv4Stack=true

## Podman-enabled setup

### Container composition

Tested with `podman` and `podman-compose`. 
Suggestion for up-to-date podman-compose:

```bash
mkdir -p ${HOME}/venv
python -m venv ${HOME}/venv/containers-python-3.6
source ${HOME}/venv/containers-python-3.6/bin/activate
pip install --upgrade pip
pip install pyyaml
pip install git+https://github.com/containers/podman-compose.git@devel
```

At first launch, MySQL database has to be initialized with root password and
traccar database and user credentials, i.e. by bringing up a client session via

    source ${HOME}/venv/containers-python-3.6/bin/activate
    podman-copose up -d
    docker exec -it mysql mysql -uroot -p

and 
```sql
ALTER USER 'root'@'localhost' IDENTIFIED BY 'new root password';
CREATE DATABASE traccar;

CREATE USER 'traccar'@'localhost' IDENTIFIED WITH mysql_native_password BY 'traccar';
GRANT ALL PRIVILEGES ON traccar.* TO 'traccar'@'localhost';
FLUSH PRIVILEGES;
```

### Secrets

podman does not handle `secrets` the way docker does. Similar behavior can be achieved with
a per-user configuration file `$HOME/.config/containers/mounts.conf` on the host containing, 
for example, a line

    /home/container/secrets:/run/secrets

that will make the content of `/home/user/containers/secrets` on the host available under
`/run/secrets` within *all containers* of the evoking user. The owner and group within 
the container will be `root:root` and file permissions will correspond to permissions 
on the host file system. Thus, an entrypoint script might have to adapt permissions.


