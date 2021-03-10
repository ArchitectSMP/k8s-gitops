#!/usr/bin/env bash
# shellcheck disable=SC1090

REPO_ROOT=$(git rev-parse --show-toplevel)

need() {
    which "$1" &>/dev/null || die "Binary '$1' is missing but required"
}

need "kubectl"
need "flux"
need "vault"
need "sed"
need "jq"

message() {
  echo -e "\n######################################################################"
  echo "# $1"
  echo "######################################################################"
}

installFlux() {
  . "$REPO_ROOT"/setup/.env
  message "installing fluxv2"
  flux check --pre > /dev/null
  FLUX_PRE=$?
  if [ $FLUX_PRE != 0 ]; then 
    echo -e "flux prereqs not met:\n"
    flux check --pre
    exit 1
  fi
  if [ -z "$GITHUB_TOKEN" ]; then
    echo "GITHUB_TOKEN is not set! Check $REPO_ROOT/setup/.env"
    exit 1
  fi
  flux bootstrap github \
    --owner=architectsmp \
    --repository=k8s-gitops \
    --branch main \
    --personal

  FLUX_INSTALLED=$?
  if [ $FLUX_INSTALLED != 0 ]; then 
    echo -e "flux did not install correctly, aborting!"
    exit 1
  fi
}

"$REPO_ROOT"/setup/bootstrap-objects.sh
installFlux
"$REPO_ROOT"/setup/bootstrap-vault.sh

message "all done!"
kubectl get nodes -o=wide
