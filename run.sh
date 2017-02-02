#!/bin/bash

if [ "$WERCKER_RANCHER_INSERVICE_UPGRADE_HTTPS" == true ]; then
    export DTR_PROTO=https;
else
    export DTR_PROTO=http;
fi

if [ -z "$WERCKER_RANCHER_INSERVICE_UPGRADE_COMPOSE_CLI_URL" ]; then
  COMPOSER_URL="https://github.com/rancher/rancher-compose/releases/download/v0.12.2/rancher-compose-linux-amd64-v0.12.2.tar.gz"
else
  COMPOSER_URL=WERCKER_RANCHER_INSERVICE_UPGRADE_COMPOSE_CLI_URL
fi

if [ "$WERCKER_RANCHER_INSERVICE_UPGRADE_VERBOSE" == true ]; then
  VERBOSE="--verbose"
else
  VERBOSE=""
fi

if [ "$WERCKER_RANCHER_INSERVICE_UPGRADE_FORCE" == true ]; then
  FORCE="--force-upgrade"
else
  FORCE=""
fi

# add tag to new image
sed -i-e "s#$WERCKER_RANCHER_INSERVICE_UPGRADE_DOCKER_IMAGE#$WERCKER_RANCHER_INSERVICE_UPGRADE_DOCKER_IMAGE:$WERCKER_RANCHER_INSERVICE_UPGRADE_TAG#g" docker-compose.yml

# output docker-compose file
cat docker-compose.yml

# download rancher-compose cli
curl -L -o composer.tar.gz "$COMPOSER_URL";
tar -xzf composer.tar.gz
rm composer.tar.gz
mv rancher-compose-*/rancher-compose .
rm -rf rancher-compose-*
chmod +x rancher-compose

# print upgrade command
echo "rancher-compose $VERBOSE -f docker-compose.yml up -d --upgrade --pull -c --interval 3000 --batch-size 1 $FORCE"

# exec the in-service upgrade
./rancher-compose \
  --url "$DTR_PROTO://$WERCKER_RANCHER_INSERVICE_UPGRADE_RANCHER_URL" \
  --access-key "$WERCKER_RANCHER_INSERVICE_UPGRADE_ACCESS_KEY" \
  --secret-key "$WERCKER_RANCHER_INSERVICE_UPGRADE_SECRET_KEY" \
  --project-name "$WERCKER_RANCHER_INSERVICE_UPGRADE_STACK_NAME" \
  $VERBOSE \
  -f docker-compose.yml \
  up -d --upgrade --pull -c --interval 3000 --batch-size 1 $FORCE
