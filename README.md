# Notes on Using oc cluster up

- Do not use Ubuntu nor AWS Linux as the base OS. Ubuntu has DNS issues inside the containers, see [stack overflow](https://stackoverflow.com/questions/20430371/my-docker-container-has-no-internet/45644890#45644890). AWS Linux has Docker issues.
- CentOS appears to work OK. Use the commercial AMI on EC2.
- Install [oc and kubectl](https://www.okd.io/download.html) both are in the download
- Install [docker ce](https://docs.docker.com/install/)
- Edit */etc/docker/daemon.json*

```json
{
  "insecure-registries": ["172.30.1.1:5000"]
}
```

- Restart Docker

The insecure registry is the internal OpenShift registry. Images will be pushed to this registry after they have been built.

Due to extensive use of iptables, evrything must be run as root.

Use the `cluster-up.sh` script or enter the following by hand.

```shell
$ oc cluster up \
--base-dir=$HOME/oc-cluster \
--public-hostname=$PUBLIC_DNS_NAME_FOR_YOUR_EC2 \
--skip-registry-check=true
```

You **must** set public hostname the first time that the cluster is created, it is ignored when given to an existing cluster.

Once the cluster up command has completed the console is accessed via

https://your-ec2-instance.amazon.com:8443/console

The /console on the end is **important**

