#!/bin/bash


if [ "$WERCKER_RANCHER_INSERVICE_UPGRADE_HTTPS" == true ]; then
    export DTR_PROTO=https;
else
    export DTR_PROTO=http;
fi

if [ -z "$WERCKER_RANCHER_INSERVICE_UPGRADE_COMPOSE_CLI_URL"]; then
  COMPOSER_URL="https://github.com/rancher/rancher-compose/releases/download/v0.7.0/rancher-compose-linux-amd64-v0.7.0.tar.gz"
else
  COMPOSER_URL=WERCKER_RANCHER_INSERVICE_UPGRADE_COMPOSE_CLI_URL
fi

curl -L -o composer.tar.gz "$COMPOSER_URL";

tar -xzf composer.tar.gz
rm composer.tar.gz
mv rancher-compose-*/rancher-compose .
rm -rf rancher-compose-*
ls


"WERCKER_STEP_ROOT/rancher-compose" \
  --url "$DTR_PROTO://$WERCKER_RANCHER_INSERVICE_UPGRADE_RANCHER_URL" \
  --access-key "$WERCKER_RANCHER_INSERVICE_UPGRADE_ACCESS_KEY" \
  --secret-key "$WERCKER_RANCHER_INSERVICE_UPGRADE_SECRET_KEY" \
  --project-name "$WERCKER_RANCHER_INSERVICE_UPGRADE_STACK_NAME" \
  up --upgrade --pull -c --interval 3000 --batch-size 1
