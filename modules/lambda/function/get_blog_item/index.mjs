import AWS from 'aws-sdk';

const dynamoDb = new AWS.DynamoDB.DocumentClient();

const tableName = 'blogTable'


export const handler = async (event) => {
  
  // TODO implement
  const queryParams = event.queryStringParameters;

    // 특정 쿼리 스트링 매개변수 접근, 예를 들어 'userId'
  
  const postId = queryParams ? queryParams.postId : null;
  
 try{
    
   const params = {
         TableName: tableName, // DynamoDB 테이블 이름
         KeyConditionExpression: "#pk = :partitionKeyVal",
         ExpressionAttributeNames: {
             "#pk": "post_id" // 실제 파티션 키 이름으로 교체해야 합니다.
         },
         ExpressionAttributeValues: {
             ":partitionKeyVal": postId
         }
     };
    
     const data = await dynamoDb.query(params).promise();
    
    
   return { statusCode: 200, body: JSON.stringify(data.Items) };
   
  }catch(error){
       console.error('DynamoDB error: ', error);
       return {
            statusCode: 500,
            body: JSON.stringify({ error: 'Could not create item' }),
        };
  }
};
