import json
import boto3
from decimal import Decimal

client = boto3.client('dynamodb')
dynamodb = boto3.resource("dynamodb")
table = dynamodb.Table('resumeVisitorTable')
tableName = 'resumeVisitorTable'

def lambda_handler(event, context):
    try:
        statusCode = 200
        response = table.update_item(
            Key={
                "id": "visitors-count"},
            UpdateExpression="SET visitors = visitors + :val",
            ExpressionAttributeValues={':val': 1},
            ReturnValues="UPDATED_NEW"
        )
        body = json.dumps({"count": int(response['Attributes']['visitors'])})
        
    except Exception as e:
        statusCode = 400
        body = json.dumps({"error": str(e)})
    
    apiRes = {
        "statusCode": statusCode,
        'headers': {
            'Content-Type': 'application/json',
            'Access-Control-Allow-Methods': 'OPTIONS,POST,GET'
        },
        "body": body
    }
    
    return apiRes