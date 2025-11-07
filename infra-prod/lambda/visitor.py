import boto3
import json
import os

dynamodb = boto3.resource('dynamodb')
table = dynamodb.Table(os.environ['TABLE_NAME'])

def lambda_handler(event, context):
    # increment visitor count
    table.update_item(
        Key={'id': 'counter'},
        UpdateExpression='ADD visits :inc',
        ExpressionAttributeValues={':inc': 1}
    )

    # read updated count
    response = table.get_item(Key={'id': 'counter'})
    count = int(response['Item'].get('visits', 0))

    return {
        'statusCode': 200,
        'headers': {
            'Access-Control-Allow-Origin': '*'
        },
        'body': json.dumps({"count": count})
    }
