# Docker Aria2 Pydio Seedbox

## About
Docker seedbox, including Aria2, Aria2-webui password protected and Pydio to download with multiple protocols HTTP/HTTPS, FTP, SFTP, BitTorrent and Metalink.

## Services
```
Pydio : http://<your ip>/pydio | All downloads go on "Common Files"
Aria2 Webui : http://<your ip>/aria2-webui
```

## Usage
#### Parameters
```
-e RPC_SECRET - Is optional, if empty, a random key is generated.
-e DOMAIN - Is optional, if empty, public IP is selected.
```
#### Run without volume mount
```sh
$ docker run --name seedbox -p 8085:80 -p 6800:6800 \
-e RPC_SECRET=<password> -e DOMAIN=<domain or ip> quadeare/docker-aria2-pydio-seedbox
```
### Run with volume mount
```sh
$ docker run --name seedbox -p 8085:80 -p 6800:6800 -v ./downloads:/downloads
-e RPC_SECRET=<password> -e DOMAIN=<domain or ip>quadeare/docker-aria2-pydio-seedbox
```
#### Add/Remove user to http auth (aria2-webui)
```sh
$ docker exec -it seedbox add-user <user>
$ docker exec -it seedbox remove-user <user>
```

#### Pydio setup
```
For a standalone installation, choose sqlite3 database.
If you want to choose another database, you can.
All downloads go on "Common Files".
```
#### Download location
```
All downloads go on the "downloads" volume. You can mount this volume with -v argumment.
Ex : -v ./<you local folder>:/downloads

About Pydio : All downloads go on "Common Files".
```
## Build
You can edit and build the project as desired.

```sh
$ docker build -t <your_name>/docker-aria2-pydio-seedbox .
```

## Requirement
* [Docker](https://www.docker.com/)

## Licence
```
This work is under the MIT License (MIT)
```
