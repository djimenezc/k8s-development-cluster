import boto3

# example: ap-south-1, us-east-1, ap-northeast-3
region = 'eu-west-1'
# provide IDs of your instances in a comma separated fashion.
instances = ['i-0bb34eca4ad16d84d']
ec2 = boto3.client('ec2', region_name=region)


def lambda_handler(event, context):
    ec2.stop_instances(InstanceIds=instances)
    print('started your instances: ' + str(instances))