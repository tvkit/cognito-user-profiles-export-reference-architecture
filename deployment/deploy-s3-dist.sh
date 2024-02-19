#!/bin/bash

. ./env

./build-s3-dist.sh $DIST_OUTPUT_BUCKET $SOLUTION_NAME $VERSION

export ACCOUNT_ID=$(aws --profile ipv:root:config sts get-caller-identity --query Account --output text)
aws --profile ipv:root:config s3api head-bucket --bucket $DIST_OUTPUT_BUCKET-$REGION --expected-bucket-owner $ACCOUNT_ID
aws --profile ipv:root:config s3api head-bucket --bucket $DIST_OUTPUT_BUCKET-$SECONDARY_REGION --expected-bucket-owner $ACCOUNT_ID
aws --profile ipv:root:config s3 cp ./regional-s3-assets/ s3://$DIST_OUTPUT_BUCKET-$REGION/$SOLUTION_NAME/$VERSION/ --recursive --acl bucket-owner-full-control
aws --profile ipv:root:config s3 cp ./regional-s3-assets/ s3://$DIST_OUTPUT_BUCKET-$SECONDARY_REGION/$SOLUTION_NAME/$VERSION/ --recursive --acl bucket-owner-full-control
