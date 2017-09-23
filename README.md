# build-caddy

Builds [caddy](https://caddyserver.com/) with the specified plugins from `plugins.txt`.

If you want to support [caddy](https://caddyserver.com/), consider buying a license or sponsoring their project!

I am in no way associated or affiliated with the original project.

## requirements

* go > 1.8
* git

## usage

1. put url's to the wanted plugin repos in `plugins.txt`. **THE FILE MUST END WITH AN EMPTY LINE**
1. execute `./build.sh`
1. the built caddy binary resides in `./build`

## additional info

* execute `sudo setcap "cap_net_bind_service=+ep" /opt/caddy/caddy` on the target system to make caddy executable by non-root users
* execute `adduser --disabled-password --disabled-login caddy` (on debian and friends) to create a non-root user for caddy
* i use this systemd unit file to run caddy

    ```
    [Unit]
    Description=Caddy HTTP/2 web server
    Documentation=https://caddyserver.com/docs
    After=network.target

    [Service]
    User=caddy
    Group=caddy
    LimitNOFILE=8192
    Environment=STNORESTART=yes
    ExecStart=/opt/caddy/caddy -agree=true -conf=/etc/caddy
    ExecReload=/bin/kill -USR1 $MAINPID
    Restart=on-failure

    [Install]
    WantedBy=multi-user.target
    ```