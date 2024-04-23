#!/bin/bash

#################################
#           Functions           #
#################################

display_help() {
  echo -e "\033[34mUsage: $0 [OPTIONS]\033[0m"
  echo
  echo -e "\033[34mOptions:\033[0m"
  echo -e "\033[34m  --url           URL of the Keycloak instance (required)\033[0m"
  echo -e "\033[34m  --realm         Keycloak realm. \033[33mDefault: master\033[0m"
  echo -e "\033[34m  --scope         Scope for authentication. \033[33mDefault: openid\033[0m"
  echo -e "\033[34m  --user          User for the Keycloak instance. \033[33mDefault: admin\033[0m"
  echo -e "\033[34m  --password      Password for the Keycloak instance (required)\033[0m"
  echo -e "\033[34m  --client_id     Client ID for authentication. \033[33mDefault: kubernetes\033[0m"
  echo -e "\033[34m  --client_secret Client secret for authentication (required)\033[0m"
  echo -e "\033[34m  --ca_cert       CA certificate for the Keycloak instance\033[0m"
  echo -e "\033[33m  --check         If set, it will only retrieve the token from oidc endpoint, but not touch the kubeconfig\033[0m"
  echo
  exit 0
}

#################################
#           Arguments           #
#################################

if [ $# -eq 0 ]; then
  display_help
fi

url=""
realm="master"
scope="openid"
user="admin"
password=""
client_id="kubernetes"
client_secret=""
check=false

while [[ $# -gt 0 ]]; do
  key="$1"

  case $key in
    --help)
      display_help
      ;;
    --check)
      check=true
      shift
      ;;
    --url)
      url="$2"
      shift
      shift
      ;;
    --realm)
      realm="$2"
      shift
      shift
      ;;
    --scope)
      scope="$2"
      shift
      shift
      ;;
    --user)
      user="$2"
      shift
      shift
      ;;
    --password)
      password="$2"
      shift
      shift
      ;;
    --client_id)
      client_id="$2"
      shift
      shift
      ;;
    --client_secret)
      client_secret="$2"
      shift
      shift
      ;;
    --ca_cert)
      client_secret="$2"
      shift
      shift
      ;;
    *)
      echo "Unknown option: $key"
      display_help
      exit 1
      ;;
  esac
done

#################################
#       Validation Checks       #
#################################

if [ -z "$url" ]; then
  echo -e "\033[31mError: --url is required.\033[0m"
  display_help
fi

if [ -z "$client_secret" ]; then
  if [ -z "$KAUTH_CLIENT_SECRET" ]; then
    echo -e "\033[31mError: --client_secret or KAUTH_CLIENT_SECRET environment variable is required.\033[0m"
    display_help
  else
    client_secret="$KAUTH_CLIENT_SECRET"
  fi
fi

if [ -z "$password" ]; then
  echo "Password not provided. Please enter your password:"
  read -s password
fi

#################################
#        Main Execution         #
#################################

echo -e "Configuring Keycloak with the following settings:"
echo -e "URL: $url"
echo -e "Realm: $realm"
echo -e "Scope: $scope"
echo -e "User: $user"
echo -e "Client ID: $client_id"
echo -e "Client Secret: Provided"

oidc_url="$url/realms/$realm/protocol/openid-connect/token"
realm_url="$url/admin/realms/$realm"

echo "OIDC URL: $oidc_url"

json_data=$(curl  --insecure -k -d "grant_type=password" -d "scope=$scope" -d "client_id=$client_id" -d "client_secret=$client_secret" -d "username=$user" -d "password=$password" $oidc_url)
echo $json_data
access_token=$(echo $json_data | jq -r '.access_token')
id_token=$(echo $json_data | jq -r '.id_token')
refresh_token=$(echo $json_data | jq -r '.refresh_token')


if [ "$check" = false ] ; then
kubectl config set-credentials $user \
  --auth-provider="oidc" --auth-provider-arg=idp-issuer-url="$realm_url" --auth-provider-arg=client-id="$client_id" \
  --auth-provider-arg=client-secret="$client_secret" --auth-provider-arg=refresh-token="$refresh_token" --auth-provider-arg=id-token="$id_token"

if [ -n "$ca_cert" ]; then
  kubectl config set-credentials $user --auth-provider-arg=idp-certificate-authority="$ca_cert"
fi
  kubectl config set-context $(kubectl config current-context) --user=$user
fi
