# How to run

The run.sh is configured s.t. it can be called wherever nix is installed (with nix command enabled) and whatever CWD is, as long as it's Linux and sh is installed.

All you do is:

- Install nix
- Clone this repo
- Run `run.sh`.

```sh
git clone https://github.com/aster-void/mcserver
./mcserver/run.sh
```

# Define a systemd module (advanced)

```sh
# Prepare files
# note: always clone this repo to /srv/minecraft. the service definition expects `run.sh` to be there.
git clone https://github.com/aster-void/mcserver /srv/minecraft
ln -s /srv/minecraft/assets/minecraft.service /etc/systemd/system/minecraft.service 

# Start the minecraft service
sudo systemctl daemon-reload
sudo systemctl enable minecraft.service
sudo systemctl start minecraft.service

# Restarting minecraft service (after editing files)
sudo systemctl daemon-reload
sudo systemctl restart minecraft.service
```
