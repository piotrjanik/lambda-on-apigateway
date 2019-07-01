import {AWSError, DynamoDB} from 'aws-sdk'
import {PromiseResult} from "aws-sdk/lib/request";
import * as uuid from 'uuid'

export module ContactRequestsDao {
    const dynamoDb = new DynamoDB.DocumentClient();

    export function put(table: string, contactRequest: ContactRequestModel): Promise<PromiseResult<AWS.DynamoDB.DocumentClient.PutItemOutput, AWSError>> {
        const body = contactRequest;
        body.uuid = uuid.v1();
        // write the todo to the database
        return dynamoDb.put({
            TableName: table,
            Item: body
        }).promise();
    }

}