# autobuild-caddy

builds caddy with the specified plugins from `plugins.txt`

## requirements

* go > 1.8
* git

## usage

1. put url's to the wanted plugin repos in `plugins.txt`. **THE FILE MUST END WITH AN EMPTY LINE**
1. execute `./build.sh`
1. the built caddy binary resides in `./build`