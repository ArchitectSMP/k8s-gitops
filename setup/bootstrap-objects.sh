#!/usr/bin/env bash
# shellcheck disable=SC1090

REPO_ROOT=$(git rev-parse --show-toplevel)

need() {
    which "$1" &>/dev/null || die "Binary '$1' is missing but required"
}

need "kubectl"

message() {
  echo -e "\n######################################################################"
  echo "# $1"
  echo "######################################################################"
}

kapply() {
  if output=$(envsubst < "$@"); then
    printf '%s' "$output" | kubectl apply -f -
  fi
}

installManualObjects(){
  . "$REPO_ROOT"/setup/.env

  message "installing manual secrets and objects"

  ##########
  # secrets
  ##########
  kubectl -n kube-system create secret generic kms-vault --from-literal=account.json="$(echo "$VAULT_KMS_ACCOUNT_JSON" | base64 --decode)"
}

installManualObjects

message "all done!"
