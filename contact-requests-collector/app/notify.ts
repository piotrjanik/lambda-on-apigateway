import AWS from "aws-sdk";

export module Notifier {
    const TOPIC_ARN = process.env['TOPIC_ARN'];

    export function notify(body: any) {
        const params = {
            Message: JSON.stringify(body),
            TopicArn: TOPIC_ARN
        };
        return new AWS.SNS({apiVersion: '2010-03-31'})
            .publish(params)
            .promise()
            .then(
                data => {
                    console.log(`Message ${params.Message} send sent to the topic ${params.TopicArn}`);
                    console.log("MessageID is " + data.MessageId);
                }).catch(
                err => {
                    console.error(err, err.stack);
                });
    }
}

