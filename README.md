# Simple mpv audio ipc server service to play your songs

The client is designed to be a cli wrapper of [mpv ipc
reference](https://mpv.io/manual/master/#json-ipc)

## Requirements
* mpv
* yt-dlp
* socat
* systemd system

## Installation

To enable the service run:
```
sudo install -Dm 644 mpv-audio-server.service /usr/lib/systemd/user
systemctl --user enable --now mpv-audio-server
```

Install the script ipc client with:
```
install -Dm 755 mpv-ipc-client.sh ~/.local/bin
```

or make your own script using [mpv json-ipc reference](https://mpv.io/manual/master/#json-ipc)

## Usage

```
Usage: mpv-ipc-client.sh [-h] [-s SOCKET] <cmd> [ARGS...]
Options:
  -h, --help              Show this message
  -s, --socket=SOCKET     Point to socket file [default: /tmp/mpv-audio-server-vech.socket]
```

Play a song, it is important enclose song query in quotation marks
```
mpv-ipc-client.sh loadfile "master of puppets"
```

Append a song, to the playlist
```
mpv-ipc-client.sh loadfile "master of puppets" append-play
```

toggle between pause or play 
```
mpv-ipc-client.sh cycle pause
``` 

get playlist:
```
mpv-ipc-client.sh get_property playlist
``` 

## See Also

To checkout all properties and commands availables run `mpv --list-properties`
and `mpv --input-cmdlist` respectively

Find more info at [mpv json-ipc reference](https://mpv.io/manual/master/#json-ipc)
