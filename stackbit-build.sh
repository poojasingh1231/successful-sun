#!/usr/bin/env bash

set -e
set -o pipefail
set -v

initialGitHash=$(git rev-list --max-parents=0 HEAD)
node ./studio-build.js $initialGitHash &

curl -s -X POST https://api.stackbit.com/project/5dbd03bfdd7fd5001a2039eb/webhook/build/pull > /dev/null
npx @stackbit/stackbit-pull --stackbit-pull-api-url=https://api.stackbit.com/pull/5dbd03bfdd7fd5001a2039eb
curl -s -X POST https://api.stackbit.com/project/5dbd03bfdd7fd5001a2039eb/webhook/build/ssgbuild > /dev/null
jekyll build
wait

curl -s -X POST https://api.stackbit.com/project/5dbd03bfdd7fd5001a2039eb/webhook/build/publish > /dev/null
echo "Stackbit-build.sh finished build"
