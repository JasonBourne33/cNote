

```sh
https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/

curl -LO https://dl.k8s.io/release/v1.24.0/bin/linux/amd64/kubectl

curl -LO "https://dl.k8s.io/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl.sha256"

echo "$(cat kubectl.sha256)  kubectl" | sha256sum --check

```

