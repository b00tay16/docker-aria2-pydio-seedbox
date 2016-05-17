# Docker Aria2 Pydio Seedbox

## About
Docker seedbox, including [Aria2](https://github.com/aria2/aria2), [Aria2-webui](https://github.com/ziahamza/webui-aria2) password protected, [Pure-FTP](https://www.pureftpd.org/project/pure-ftpd) and [Pydio](https://github.com/pydio/) to download with multiple protocols HTTP/HTTPS, FTP, SFTP, BitTorrent and Metalink.

## Services
```
Pydio       : http://<your ip>/pydio | All downloads go on "Common Files"
Aria2 Webui : http://<your ip>/aria2-webui
HTTP        : http://<your ip>/downloads
FTP         : On your IP on default or custom port
```

## Usage
#### Parameters
```
-e RPC_SECRET                   - Is optional, if empty, a random key is generated.
-e DOMAIN                       - Is optional, if empty, public IP is selected
-e FTP_PASSIVE_RANGE            - Is optional, if empty, 30000:30009 is choosen
-v <local folder>:/downloads.   - Is optional
```
#### Run

```sh
$ docker run -d --name seedbox -p 9080:80 -p 6800:6800 -p 9021:21 quadeare/aria2-pydio-seedbox
```
With options :
```sh
$ docker run -d --name seedbox -p 9080:80 -p 6800:6800 -p 9021:21 \
-v <local folder>:/downloads \
e FTP_PASSIVE_RANGE="30000:30009" -e RPC_SECRET=<password> -e DOMAIN=<domain or ip> \
quadeare/aria2-pydio-seedbox
```
#### Get informations
```sh
$ docker logs seedbox
```
#### Add/Remove user to http auth (aria2-webui/HTTP share) and FTP
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
#### Downloads location
```
All downloads go on the "downloads" volume. You can mount this volume with -v argumment.
Ex : -v <you local folder>:/downloads

About Pydio : All downloads go on "Common Files".
```
## Build
You can edit and build the project as desired.

```sh
$ docker build -t <your_name>/aria2-pydio-seedbox .
```

## Requirement
* [Docker](https://www.docker.com/)

## Licence
```
This work is under the MIT License (MIT)
```
