#!/bin/sh

#set -x

# testing values
OPENSHIFT_BUILD_COMMIT="acab614ca92010f9cdaaafa59e55fcaeac8060b1"
OPENSHIFT_BUILD_NAME="payment-42"

#
# Main
#
API_KEY="api key here"
INSTANA_API="https://marketingtemp-instana.instana.io/api/releases"

# RedHat Linux does not have jq and uses yum
yum install -y epel-release && yum install -y jq

# get details from github
GITHUB_API="https://api.github.com/repos/steveww/robot-shop/commits/$OPENSHIFT_BUILD_COMMIT"
MESSAGE=$(curl -s -L $GITHUB_API | jq -r '.commit.message')

MESSAGE="$OPENSHIFT_BUILD_NAME - $MESSAGE"
# need milliseconds
DATE="$(date '+%s')000"

RET=$(curl -s -L -X POST \
    -H "Content-Type: application/json" \
    -H "Authorization: apiToken $API_KEY" \
    -d "{\"name\": \"$MESSAGE\", \"start\": $DATE}" \
    $INSTANA_API | jq '.code,.message')
if echo "$RET" | egrep -qv '^null'
then
    echo "Instana API error $RET"
else
    echo "Pipeline feedback sent"
fi


# always exit with 0 to ensure API error does not stop build
exit 0

