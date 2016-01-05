#!/bin/bash

if [ "$WERCKER_DEPLOY_TO_RANCHER_HTTPS" == true ]; then
    export DTR_PROTO=https;
else
    export DTR_PROTO=http;
fi

function get_env_id { curl -s "$DTR_PROTO://$WERCKER_DEPLOY_TO_RANCHER_ACCESS_KEY:$WERCKER_DEPLOY_TO_RANCHER_SECRET_KEY@$WERCKER_DEPLOY_TO_RANCHER_RANCHER_URL/environments?name=$WERCKER_DEPLOY_TO_RANCHER_STACK_NAME" | "$WERCKER_STEP_ROOT/jq" '.data[0].id' | sed s/\"//g; }

DTR_ENV_ID=$(get_env_id)

sed -i -e "s/$WERCKER_DEPLOY_TO_RANCHER_DOCKER_IMAGE/$WERCKER_DEPLOY_TO_RANCHER_DOCKER_IMAGE:$WERCKER_DEPLOY_TO_RANCHER_TAG/g" docker-compose.yml

# get rancher-compose cli
curl -o rancher-compose.zip "$DTR_PROTO://$WERCKER_DEPLOY_TO_RANCHER_ACCESS_KEY:$WERCKER_DEPLOY_TO_RANCHER_SECRET_KEY@$WERCKER_DEPLOY_TO_RANCHER_RANCHER_URL/environments/$DTR_ENV_ID/composeconfig"

# unzip
unzip -o rancher-compose.zip

"$WERCKER_STEP_ROOT/rancher-compose" \
  --url "$DTR_PROTO://$WERCKER_DEPLOY_TO_RANCHER_RANCHER_URL" \
  --access-key "$WERCKER_DEPLOY_TO_RANCHER_ACCESS_KEY" \
  --secret-key "$WERCKER_DEPLOY_TO_RANCHER_SECRET_KEY" \
  --project-name "$WERCKER_DEPLOY_TO_RANCHER_STACK_NAME" \
  up --upgrade --pull -c --interval 3000 --batch-size 1
