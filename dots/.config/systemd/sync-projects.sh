#!/bin/bash

source ~/.private/pi

~/bin/osync/osync.sh \
  --initiator="~/projects" \
  --target="ssh://$PI_URL:22//mnt/data/projects" \
  --rsakey="$PI_KEY_PATH" \
  --stats

