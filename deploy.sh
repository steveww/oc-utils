#!/bin/sh

set -e

APPS="cart catalogue dispatch mongo mysql payment ratings shipping user web"
REPO="https://github.com/steveww/rshop"

echo "logging in as developer"
oc login -u developer
CHECK=$(oc projects | fgrep robot-shop)
if [ -z "$CHECK" ]
then
    echo "Project robot-shop not detected. Run setup.sh first"
    exit 1
fi
oc project robot-shop

# Standard app images from Docker Hub
oc import-image redis --from redis:4.0.6 --confirm
oc import-image rabbitmq --from rabbitmq:3.7-management-alpine --confirm

oc new-app -i redis --name redis
oc new-app -i rabbitmq --name rabbitmq

# Apps from source in GitHub
for APP in $APPS
do
    if [ "$APP" = "mongo" ]
    then
        NAME="mongodb"
    else
        NAME="$APP"
    fi

    # create build
    oc new-app $REPO --context-dir $APP --name $NAME

    # Wait for build to complete
    COMPLETE=""
    while [ -z "$COMPLETE"  ]
    do
        sleep 5
        /bin/echo -n '. '
        # grep returns non zero if it does not find a match
        set +e
        COMPLETE=$(oc get pod | fgrep -v build | fgrep -v deploy | fgrep $NAME | fgrep Running)
        set -e
    done
done

