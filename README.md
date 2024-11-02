

# todo
- [ ] reply to this post https://redcap.vumc.org/community/post.php?id=48179
- [ ] edocs volume and pvc
- [ ] host path pv/ storageClass that works in k3d, docker desktop defaults, and rancher desktop defaults
- [x] sql init script updates that REDCap db with changes or defaults from the helm chart (ex: the edocs dir, name of site, default users, etc)
- [ ] heml chart flags to support windows paths and mac paths for local deployment

### Debugging

If you need to use a local image, you have to import it into your k3d cluster registry

```bash
k3d cluster create derp --registry-create redcap-dev

k3d cluster create derp --port "80:80@loadbalancer" --port "443:443@loadbalancer" --registry-create redcap-dev



```

Now we can push to the this local k3d repo. Use the localhost and published port. Will need to check that with the docker ps command.

```bash
# get port published
 docker ps -f name=redcap-dev

 6e109fb9221c   registry:2                       "/entrypoint.sh /etc…"   About an hour ago   Up About an hour   0.0.0.0:50030->5000/tcp                                             redcap-dev

# now change port published (port 50030) and use in the  next commands

docker tag rc-test:latest localhost:50030/rc-test:tag
docker push  localhost:50030/rc-test:tag
```


Would also need to update the image in the deployment

```yaml
spec:
      containers:
        image: redcap-dev:5000/rc-test:latest

```

## host files updates

need to add some lines to your hosts files.

```bash
127.0.0.1   redcap.local
127.0.0.1   mailhog.local
```

