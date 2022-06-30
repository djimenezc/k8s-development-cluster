#!/bin/bash
REMOTE_HOST=$1
REMOTE_PORT=$2
LOCAL_PORT=$3
#ASSUME_ROLE_NAME=$3
#REGION=$4

JUMPER_MACHINE_ID=$4

#check if they exist to throw an error

#################
### FUNCTIONS ###
#################

# assume role function to obtain tmp token
# param1: role, param2: region
# Important: use regional issuer as AWS recommends in order to avoid dealing with token versions
assumeRole() {
    set +x
    export AWS_STS_REGIONAL_ENDPOINTS=regional
    ROLE_ARN="${1}"
    SESSIONID=$(date +"%s")
    DURATIONSECONDS="${3:-3600}"

    RESULT=(`aws sts assume-role --role-arn $ROLE_ARN \
            --role-session-name $SESSIONID \
	          --duration-seconds $DURATIONSECONDS \
            --query '[Credentials.AccessKeyId,Credentials.SecretAccessKey,Credentials.SessionToken]' \
            --output text --region ${2}`)

    export AWS_ACCESS_KEY_ID=${RESULT[0]}
    export AWS_SECRET_ACCESS_KEY=${RESULT[1]}
    export AWS_SECURITY_TOKEN=${RESULT[2]}
    export AWS_SESSION_TOKEN=${AWS_SECURITY_TOKEN}
    export AWS_REGION="${2}"
    export AWS_DEFAULT_REGION="${AWS_REGION}"
    set -x
}

##assume role
#assumeRole $ASSUME_ROLE_NAME $REGION

#obtain all running bastion instances
INSTANCE_ID_JSON_ARRAY=$(aws ec2 describe-instances \
               --filter "Name=tag:Name,Values=${JUMPER_MACHINE_ID}" \
               --query "Reservations[].Instances[?State.Name == 'running'].InstanceId[]" \
               --output json)

# get number of running instances
BASTION_LENGTH=$(echo "$INSTANCE_ID_JSON_ARRAY" | jq '. | length')

# get a random position to implement "self managed balancing"
RANDOM_ARRAY_LENGTH=$(( $RANDOM % $BASTION_LENGTH ))

# obtaining a random instance
INSTANCE_ID=$(echo "$INSTANCE_ID_JSON_ARRAY" | jq -r --argjson index $RANDOM_ARRAY_LENGTH '.[$index]')

#LOCAL_PORT=$(getLocalFreePort)

# do tunneling
ssh -L "$LOCAL_PORT:$REMOTE_HOST:$REMOTE_PORT" -o ExitOnForwardFailure=True -fN "${INSTANCE_ID}" && \
echo "$LOCAL_PORT" || echo "ERROR"
