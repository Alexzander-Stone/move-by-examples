#!/bin/sh

set -e

echo "##### Running move script to create a todo list under a new object owned by sender and todos in 1 tx #####"

# Profile is the account you used to execute transaction
# Run "aptos init" to create the profile, then get the profile name from .aptos/config.yaml
PUBLISHER_PROFILE=testnet-profile-1

# Resource account seed is the seed used to derive the resource account address
# It can be any string, but it should be unique for each resource account
RESOURCE_ACCOUNT_SEED=resource-account-seed-1

PUBLISHER_ADDR=0x$(aptos config show-profiles --profile=$PUBLISHER_PROFILE | grep 'account' | sed -n 's/.*"account": \"\(.*\)\".*/\1/p')

RESOURCE_ACCOUNT_ADDR=0x$(aptos account derive-resource-account-address \
  --address $PUBLISHER_ADDR \
  --seed $RESOURCE_ACCOUNT_SEED \
  | jq -r '.Result')

# Need to compile the package first
aptos move compile \
  --named-addresses advanced_todo_list_addr=$RESOURCE_ACCOUNT_ADDR

# Profile is the account you used to execute transaction
# Run "aptos init" to create the profile, then get the profile name from .aptos/config.yaml
SENDER_PROFILE=testnet-profile-1

# Run the script
aptos move run-script \
	--assume-yes \
  --profile $SENDER_PROFILE \
  --compiled-script-path build/advanced_todo_list/bytecode_scripts/create_todo_list_and_todos.mv
