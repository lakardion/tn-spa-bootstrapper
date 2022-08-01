#!/usr/bin/env bash

set -e

repo=$GITHUB_REPO
token=$GITHUB_TOKEN

app=$HEROKU_APP_NAME
pr=$HEROKU_PR_NUMBER

curl -v -X POST \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Authorization: Bearer $token" \
     https://api.github.com/repos/thinknimble/my_project/dispatches \
     -d '{"event_type":"review-app-test",
       "client_payload":{
         "review_app_url": "https://$app.herokuapp.com",
         "PR_NUM": "1"
       }
     }'

echo "Done."
