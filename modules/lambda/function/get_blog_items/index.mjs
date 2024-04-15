import AWS from 'aws-sdk';

const dynamoDb = new AWS.DynamoDB.DocumentClient();

const tableName = 'blogTable'


export const handler = async (event) => {
  // TODO implement
  try{
    
    const params = {
        TableName: tableName
    };
    
    const data = await dynamoDb.scan(params).promise();
    
    
   return { statusCode: 200, body: JSON.stringify(data.Items) };
   
  }catch(error){
       console.error('DynamoDB error: ', error);
       return {
            statusCode: 500,
            body: JSON.stringify({ error: 'Could not create item' }),
        };
  }
};
