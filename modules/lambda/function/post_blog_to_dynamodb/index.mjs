import AWS from 'aws-sdk';

const dynamoDb = new AWS.DynamoDB.DocumentClient();

const tableName = 'blogTable'

export const handler = async (event) => {
  // TODO implement
  
  const body = JSON.parse(event.body);;
  
  try{
    const params = {
        TableName: tableName,
        Item: body
    };
    
    await dynamoDb.put(params).promise();
    
    
    return  {
    statusCode: 201,
    body: JSON.stringify({ message: 'success'}),
  };
  }catch(error){
       console.error('DynamoDB error: ', error);
       return {
            statusCode: 500,
            body: JSON.stringify({ error: 'Could not create item' }),
        };
  }
  
 

};
