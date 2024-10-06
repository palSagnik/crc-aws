import json
import boto3
from decimal import Decimal

client = boto3.client('dynamodb')
dynamodb = boto3.resource("dynamodb")
table = dynamodb.Table('resume-visitor-count')
tableName = 'resume-visitor-count'

def lambda_handler(event, context):
    try:
        response = table.update_item(
            Key={
                "id": "visitors-count"},
            UpdateExpression="SET visitors = visitors + :val",
            ExpressionAttributeValues={':val': 1},
            ReturnValues="UPDATED_NEW"
        )
        body = json.dumps({"count": int(response['Attributes']['visitors'])})
        
    except:
        # Means table is empty
        putItem = table.put_item(
            Item = {
                "id" : "visitors-count",
                "visitors": 1
            }
        )

        # getting count of 1
        response = table.get_item(
            Key = {
                "id": "visitors-count"
            }
        )

        body = json.dumps({"count": int(response['Item']['visitors'])})
    
    apiRes = {
        "statusCode": 200,
        'headers': {
            'Content-Type': 'application/json',
            'Access-Control-Allow-Methods': 'OPTIONS,POST,GET'
        },
        "body": body
    }
    return apiRes