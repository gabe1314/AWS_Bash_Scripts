#!/usr/bin/env bas

for region in $(aws ec2 describe-regions --region eu-west-1 | jq -r .Regions[].RegionName); do

  echo "* Region ${region}"

  # get default security group
  sg=$(aws ec2 --region ${region} \
    describe-security-groups --filter Name=isDefault,Values=true \
    | jq -r .SecurityGroups[0].IpRanges)
  if [ "${sg}" = "null" ]; then
    echo "No default sg found"
    continue
  fi
  echo "Found default sg ${sg}"
  done
