import {AWSError, DynamoDB} from 'aws-sdk'
import {PromiseResult} from "aws-sdk/lib/request";

export module ContactRequestsDao {
    const dynamoDb = new DynamoDB.DocumentClient();

    export function put(table: string, contactRequest: ContactRequestModel): Promise<PromiseResult<AWS.DynamoDB.DocumentClient.PutItemOutput, AWSError>> {

        // write the todo to the database
        return dynamoDb.put({
            TableName: table,
            Item: contactRequest
        }).promise();
    }

}