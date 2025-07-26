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

# Bootstraping on a clean system

Usually when you start a fresh VPS, you don't have anything useful installed*.

0. set up SSH connection (how are you here without an SSH conn???)
1. install curl if it's not installed.
2. install nix. (DeterminateSystem's installed is recommended)
3. `nix run nixpkgs#git clone https://github.com/aster-void/mcserver /srv/minecraft`
4. `cd /srv/minecraft; nix develop`
5. Now you can use nix, git, and every other utility tool.

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

