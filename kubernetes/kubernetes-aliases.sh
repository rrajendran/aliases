#!/usr/bin/env bash
#
# kube-aliases.sh
#
# Lightweight collection of kubectl wrappers, aliases and helpers.
# Place this file somewhere and source it from your shell rc:
#   # Bash
#   source ~/scripts/aliases/kubernetes/kube-aliases.sh
#   # Zsh
#   source ~/scripts/aliases/kubernetes/kube-aliases.sh
#
# Quick install:
#   mkdir -p ~/.local/share/kube-aliases
#   curl -fsSL -o ~/.local/share/kube-aliases/kube-aliases.sh https://example.com/kube-aliases.sh
#   echo 'source ~/.local/share/kube-aliases/kube-aliases.sh' >> ~/.bashrc
#
# Overview:
# - k  : wrapper for kubectl
# - kg* : quick get helpers (pods/services/deployments, wide output)
# - kd* : describe shortcuts
# - klog, klogs : log helpers (follow by default)
# - kctx, kns : context and namespace helpers
# - kexec, ksh : exec into pod
# - kpf : port-forward helper
# - kapply, kdel, kroll, kscale : common actions
# - kwe : events (sorted)
# - ktop : resource top (nodes/pods)
# - khelp : prints this help / usage
#
# Examples:
#   k get nodes
#   kgp                       # get pods in current namespace (wide)
#   kgd my-deployment         # get deployments
#   kctx                      # list contexts
#   kctx my-cluster           # switch context
#   kns kube-system           # set namespace for current context
#   klog my-pod               # tail logs (follows)
#   ksh my-pod                # get an interactive shell in the pod
#   kpf svc/my-service 8080:80 # forward local 8080 to remote 80 on the service
#
# Notes:
# - These helpers are intended to be convenience wrappers. You can still
#   pass full kubectl args; use uppercase -f or others as usual.
# - If kubectl is not present, functions print an error and return non-zero.
#
# Copyright: reusable convenience helpers licensed for personal/team use.

if [ -n "${KUBE_ALIASES_LOADED:-}" ]; then
    return 0
fi
KUBE_ALIASES_LOADED=1

# ---------- helpers ----------
_kubectl_exists() {
    command -v kubectl >/dev/null 2>&1 || { printf 'kubectl not found in PATH\n' >&2; return 1; }
    return 0
}

_kube_current_ns() {
    # returns the current namespace for the current context (default: default)
    _kubectl_exists || { printf 'kubectl not found\n' >&2; return 1; }
    ns=$(kubectl config view --minify --output 'jsonpath={..namespace}' 2>/dev/null || true)
    [ -z "$ns" ] && printf 'default' || printf '%s' "$ns"
}

_kube_current_ctx() {
    _kubectl_exists || { printf 'kubectl not found\n' >&2; return 1; }
    kubectl config current-context 2>/dev/null || printf ''
}

# ---------- main wrapper ----------
k() {
    _kubectl_exists || return 1
    kubectl "$@"
}

# ---------- context / namespace ----------
kctx() {
    _kubectl_exists || return 1
    if [ $# -eq 0 ]; then
        kubectl config get-contexts
        echo
        printf 'Current: %s\n' "$(_kube_current_ctx)"
        printf 'Namespace: %s\n' "$(_kube_current_ns)"
        return 0
    fi
    kubectl config use-context "$1"
}

kns() {
    _kubectl_exists || return 1
    if [ $# -eq 0 ]; then
        kubectl get namespaces
        printf '\nSet current namespace: kns <namespace>\n'
        return 0
    fi
    kubectl config set-context --current --namespace="$1"
    printf 'Context: %s' "$(_kube_current_ctx)"; printf ' | Namespace: %s\n' "$(_kube_current_ns)"
}

kctxns() {
    # show current context and namespace together
    printf 'Context: %s\nNamespace: %s\n' "$(_kube_current_ctx)" "$(_kube_current_ns)"
}

# ---------- quick get (kg = kubectl get) ----------
kg() { _kubectl_exists || return 1; kubectl get "$@"; }
kgp() { _kubectl_exists || return 1; kubectl get pods -o wide "$@"; }
kgs() { _kubectl_exists || return 1; kubectl get svc -o wide "$@"; }
kgd() { _kubectl_exists || return 1; kubectl get deployments -o wide "$@"; }
kgall() { _kubectl_exists || return 1; kubectl get all "$@"; }
kgn() { _kubectl_exists || return 1; kubectl get nodes -o wide "$@"; }

# get resources filtered by label: kgl <kind> "<label-selector>"
kgl() {
    _kubectl_exists || return 1
    if [ $# -lt 2 ]; then
        printf 'usage: kgl <kind> "<label-selector>"\n'
        return 1
    fi
    kubectl get "$1" -l "$2" -o wide
}

# ---------- describe ----------
kd() { _kubectl_exists || return 1; kubectl describe "$@"; }
kdp() { _kubectl_exists || return 1; kubectl describe pod "$@"; }
kdd() { _kubectl_exists || return 1; kubectl describe deployment "$@"; }

# ---------- logs ----------
klog() {
    _kubectl_exists || return 1
    if [ $# -lt 1 ]; then
        printf 'usage: klog <pod-name> [-c container] [-- since=...] (follows by default)\n'
        printf 'Example: klog my-pod -c my-container\n'
        return 1
    fi
    kubectl logs -f "$@"
}

klogs() { klog "$@"; }  # alias

# ---------- exec / shell ----------
kexec() {
    _kubectl_exists || return 1
    if [ $# -lt 2 ]; then
        printf 'usage: kexec <pod> <command> [-- <args>]\n'
        printf 'Example: kexec my-pod /bin/sh -c "echo hi"\n'
        return 1
    fi
    kubectl exec -it "$@"
}

ksh() {
    _kubectl_exists || return 1
    if [ $# -lt 1 ]; then
        printf 'usage: ksh <pod> [container]\n'
        return 1
    fi
    pod="$1"
    shift || true
    if [ $# -ge 1 ]; then
        container="$1"
        kubectl exec -it "$pod" -c "$container" -- bash -l 2>/dev/null || kubectl exec -it "$pod" -c "$container" -- sh
    else
        kubectl exec -it "$pod" -- bash -l 2>/dev/null || kubectl exec -it "$pod" -- sh
    fi
}

# ---------- port-forward ----------
kpf() {
    _kubectl_exists || return 1
    if [ $# -lt 2 ]; then
        printf 'usage: kpf <pod|svc/name> <local_port:remote_port> [--namespace ns]\n'
        return 1
    fi
    kubectl port-forward "$@"
}

# ---------- apply / delete / rollout / scale ----------
kapply() { _kubectl_exists || return 1; kubectl apply -f "$@"; }
kdel()   { _kubectl_exists || return 1; kubectl delete "$@"; }
kroll()  { _kubectl_exists || return 1; kubectl rollout "$@"; }        # e.g., kroll status deployment/my-app
kscale() { _kubectl_exists || return 1; kubectl scale --replicas="$2" "$1"; } # kscale deployment/my-app 3

# restart a deployment by annotation bump
krestart() {
    _kubectl_exists || return 1
    if [ $# -ne 1 ]; then
        printf 'usage: krestart <deployment/name>\n'
        return 1
    fi
    kubectl rollout restart "$1"
}

# ---------- events / top / describe useful info ----------
kwe() { _kubectl_exists || return 1; kubectl get events --sort-by=.metadata.creationTimestamp "$@"; }
ktop() {
    _kubectl_exists || return 1
    if [ $# -eq 0 ]; then
        kubectl top pods
    else
        kubectl top "$@"
    fi
}

# ---------- copy files ----------
kcp() {
    _kubectl_exists || return 1
    if [ $# -lt 2 ]; then
        printf 'usage: kcp <src> <dest>\n'
        printf 'src/dest examples: pod/mypod:/path localfile, localfile pod/mypod:/path\n'
        return 1
    fi
    kubectl cp "$@"
}

# ---------- helpful combined commands ----------
knsresources() {
    # show all resources in the given namespace (or current if none)
    _kubectl_exists || return 1
    ns="${1:-$(_kube_current_ns)}"
    kubectl get all -n "$ns"
}

kfind() {
    # find objects by name across all resource types (basic grep over get all)
    _kubectl_exists || return 1
    if [ $# -lt 1 ]; then
        printf 'usage: kfind <term>\n'
        return 1
    fi
    term="$1"
    kubectl get all --all-namespaces -o wide 2>/dev/null | grep -i --color=always "$term" || return 1
}

# ---------- convenience aliases ----------
alias kga='kubectl get all'
alias kgc='kubectl config'
alias kgns='kubectl get ns'
alias kr='kubectl run'
alias kaf='kubectl apply -f'
alias kdelf='kubectl delete -f'

# ---------- help ----------
khelp() {
    cat <<'EOF'
kube-aliases - quick kubectl helpers

Main:
    k <kubectl args>           : wrapper for kubectl
    khelp                      : show this help

Context / Namespace:
    kctx [context]             : list / switch contexts
    kns [namespace]            : list namespaces or set current namespace
    kctxns                     : print current context and namespace

Get / Describe:
    kg <...>                   : kubectl get ...
    kgp                        : get pods -o wide
    kgs                        : get svc -o wide
    kgd                        : get deployments -o wide
    kgall                      : kubectl get all
    kd <resource>              : kubectl describe resource

Logs / Exec:
    klog <pod> [opts]          : kubectl logs -f ...
    ksh <pod> [container]      : interactive shell in pod
    kexec <pod> <cmd> ...      : exec a command in pod

Common Actions:
    kapply <file>              : kubectl apply -f file
    kdel <resource>            : kubectl delete resource
    kroll <args>               : kubectl rollout ...
    krestart <deployment>      : restart a deployment
    kscale <resource> <rep>    : scale resource

Utilities:
    kpf <pod|svc/name> 8080:80 : port-forward
    kcp <src> <dest>           : copy to/from pod
    kwe                        : get events (sorted)
    ktop                       : kubectl top pods

Examples:
    kgp                       # get pods
    klog my-pod               # follow logs
    ksh my-pod                # get shell
    krestart deployment/my-app

EOF
}

# Make khelp visible in --help lists for shells that auto-list functions (optional)
export -f k kctx kns kg kgp kgall kd klog ksh kpf kapply kdel kroll krestart kscale kwe ktop kcp

# End of kube-aliases.sh