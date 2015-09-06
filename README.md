docker-qtox
==============

Because why run a shady community project like tox on your local system? Throw it in a container where you don't care if it behaves or not.

# Build from Dockerfile #

```
docker build -t qtox .
```

# Run it
```
docker run -d -p 55556:22 qtox
```

# Run it with a volume, so you can have persistent identity (TODO: demonstrate encrypted volume mount persistence)
```
docker run -d -v /home/$USER/.config/tox:/home/docker/.config/tox -p 55556:22 qtox
```

## Start ##

*~/.ssh/config entry for easy ssh*
```
Host docker-qtox
  User      docker
  Port      55556
  HostName  127.0.0.1
  RemoteForward 64713 localhost:4713
  ForwardX11 yes
```
*use a script or tmux line to start a session*
```
tmux new -s qtox -d "ssh docker-qtox 'qtox'"
```
