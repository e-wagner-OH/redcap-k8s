### Debugging

If you need to use a local image, you have to import it into your k3d cluster registry

```bash
k3d cluster create derp --registry-create redcap-dev

```

Now we can push to the this local k3d repo. Use the localhost and published port. Will need to check that with the docker ps command.

```bash
# get port published
 docker ps -f name=redcap-dev

# now change port published and use in the  next commands

docker tag rc-test:latest localhost:58823/rc-test:latest
docker push  localhost:58823/rc-test:latest
```



```bash
# get clusters you are testing against
k3d cluster list

# use cluster to import image
k3d image import my-local-image:latest -c <cluster-name>
```

Would also need to update the image in the deployment

```yaml
spec:
      containers:
        image: redcap-dev:5000/rc-test:latest

```