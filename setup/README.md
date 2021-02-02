# installation (one-time actions)

Once a cluster is in-place, ensure that the `$KUBECONFIG` environment variable is set properly, or the target cluster is set in the `~/.kube/config` file.

```shell
./bootstrap-cluster.sh
```

This [script](bootstrap-cluster.sh) installs flux2
