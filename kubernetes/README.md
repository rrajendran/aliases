# Kubernetes aliases (kubectl wrappers)

A compact reference for the kubectl aliases and helper functions defined in `kube-aliases.sh`.

Quick install

- Source the file from your shell configuration (adjust the path):

```sh
# add to ~/.bashrc or ~/.zshrc
source ~/scripts/aliases/kubernetes/kube-aliases.sh
```

Prerequisites / safety

- Requires `kubectl` in your PATH. Functions print an error and return non-zero if `kubectl` is missing.
- Some commands are destructive (e.g., `kdel`). Confirm before running commands that modify resources.

---

## Overview 🔧
- `k` — wrapper for `kubectl` (pass any kubectl args)
- `kg*` — quick `kubectl get` helpers
- `kd*` — `kubectl describe` shortcuts
- `klog` / `klogs` — follow logs
- `kctx` / `kns` — context and namespace helpers
- `kexec` / `ksh` — exec into pod or open a shell
- `kpf` — port-forward helper
- `kapply` / `kdel` / `kroll` / `kscale` — common resource actions
- `kwe` / `ktop` — events and metrics helpers
- `kcp` — copy files to/from pods

## Commands & Usage 📋
### Main wrapper
- `k <kubectl args>` — run any kubectl command
  - Example: `k get nodes`

### Context / Namespace
- `kctx [context]` — list contexts or switch to `context`
  - Example: `kctx my-cluster`
- `kns [namespace]` — list namespaces or set current namespace
  - Example: `kns kube-system` (sets current context namespace)
- `kctxns` — print current context and namespace

### Quick get (kg = kubectl get)
- `kg` — `kubectl get ...`
- `kgp` — `kubectl get pods -o wide`
- `kgs` — `kubectl get svc -o wide`
- `kgd` — `kubectl get deployments -o wide`
- `kgall` — `kubectl get all`
- `kgn` — `kubectl get nodes -o wide`
- `kgl <kind> "<label-selector>"` — filter resources by label
  - Example: `kgl pods "app=my-app"`

### Describe
- `kd` — `kubectl describe ...`
- `kdp` — describe pod
- `kdd` — describe deployment

### Logs
- `klog <pod> [opts]` — tail logs (follows by default)
  - Example: `klog my-pod -c my-container`
- `klogs` — alias for `klog`

### Exec / Shell
- `kexec <pod> <command> [-- <args>]` — exec a command in a pod (interactive)
  - Example: `kexec my-pod /bin/sh -c "echo hi"`
- `ksh <pod> [container]` — open an interactive shell in a pod
  - Example: `ksh my-pod` or `ksh my-pod my-container`

### Port-forward
- `kpf <pod|svc/name> <local:remote> [--namespace ns]`
  - Example: `kpf svc/my-svc 8080:80`

### Apply / Delete / Rollout / Scale
- `kapply <file>` — `kubectl apply -f file`
- `kdel <resource>` — `kubectl delete resource`
- `kroll <args>` — `kubectl rollout ...` (e.g., `kroll status deployment/my-app`)
- `krestart <deployment/name>` — restart a deployment (rollout restart)
  - Example: `krestart deployment/my-app`
- `kscale <resource> <replicas>` — scale resource
  - Example: `kscale deployment/my-app 3`

### Events / Top / Copy
- `kwe` — `kubectl get events --sort-by=.metadata.creationTimestamp`
- `ktop [args]` — `kubectl top pods` (or `kubectl top <...>` when args provided)
- `kcp <src> <dest>` — copy files between pods and local
  - Example: `kcp pod/mypod:/path localfile`

### Combined helpers
- `knsresources [namespace]` — show all resources in namespace (defaults to current)
- `kfind <term>` — search for objects by name across all namespaces (grep over `kubectl get all`)

### Convenience aliases
- `kga` — `kubectl get all`
- `kgc` — `kubectl config`
- `kgns` — `kubectl get ns`
- `kr` — `kubectl run`
- `kaf` — `kubectl apply -f`
- `kdelf` — `kubectl delete -f`

---

## Examples ✅
- Get pods in current namespace (wide):

```sh
kgp
```

- Follow logs of a pod:

```sh
klog my-pod
```

- Open an interactive shell in the first container:

```sh
ksh my-pod
```

- Port-forward service `my-svc` to localhost 8080:

```sh
kpf svc/my-svc 8080:80
```

---

## Notes & Contributing
- These helpers are convenience wrappers — you can pass any standard kubectl flags.
- If you want additional helpers or different default flags, edit `kube-aliases.sh` and update this README or open a PR.

_Last updated: 2026-01-01_
