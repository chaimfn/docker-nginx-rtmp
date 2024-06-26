### Based on [tiangolo](https://github.com/tiangolo/nginx-rtmp-docker)


## Get nginx image:
docker pull nginx:{ver}

## Get nginx source:
1. Go to https://nginx.org/download/ and pickup the tar according the {ver} above.
2. Extract the 'tar' file: ```tar xzf nginx-{ver}.tar```

## Get the module source code:
git clone https://github.com/arut/nginx-rtmp-module

## Get config section for rtmp:
[Example 1](https://www.digitalocean.com/community/tutorials/how-to-set-up-a-video-streaming-server-using-nginx-rtmp-on-ubuntu-20-04)

[Example 2](https://medium.com/@peer5/setting-up-hls-live-streaming-server-using-nginx-67f6b71758db)

[Example 3](https://sites.google.com/view/facebook-rtmp-to-rtmps/home#h.p_9sKSEFWMM1dQ)

[Example 4](https://github.com/tiangolo/nginx-rtmp-docker/blob/master/nginx.conf)

## Get the original nginx files (config, html, modules, etc.):
```docker run --name nginx-tmp -d nginx:{ver} ```

```docker cp nginx-tmp:/etc/nginx/ src/```

```docker cp nginx-tmp:/usr/lib/nginx/modules src/usr/lib/nginx/```

```docker cp nginx-tmp:/usr/share/nginx/html src/usr/share/nginx/```

And at last: ```docker rm -f nginx-tmp```

## Add rtmp config section:
Add the 'rtmp' configuration section to the end of the 'src/etc/nginx/nginx.conf' file.


## Build the image:
For example: ```docker build --no-cache -t nginx:{ver}.rtmp .```

## Run the server:
For example: ```docker run --name nginx-rtmp -d -p 8880:80 -p 4443:443 -p 1935:1935 nginx:{ver}.rtmp```

## Test the server, by streaming a video:
1. Install ffmpeg tool: ```sudo apt install ffmpeg -y```
2. Send your video as stream: ```ffmpeg -re -i {path/to/video} -c:v copy -c:a aac -ar 44100 -ac 1 -f flv rtmp://localhost:1935/live/{output-key}``` <br />
(Description of those flags: [here](https://www.digitalocean.com/community/tutorials/how-to-set-up-a-video-streaming-server-using-nginx-rtmp-on-ubuntu-20-04])
3. Check the output: ```docker run -ti nginx-rtmp /bin/bash -c "ls -la /tmp/record | grep {output-key}"```
4. You can copy your video file back from the container to your host: ```docker cp nginx-rtmp:/tmp/record/{output-key}-{unique-id}.flv {/your/host/path/}```

### Refs:
https://github.com/datarhei/nginx-rtmp?tab=readme-ov-file#ffmpeg-example

https://github.com/tiangolo/nginx-rtmp-docker/blob/master/README.md#how-to-test-with-obs-studio-and-vlc

https://www.okdo.com/project/streaming-server/

https://www.digitalocean.com/community/tutorials/how-to-set-up-a-video-streaming-server-using-nginx-rtmp-on-ubuntu-20-04


