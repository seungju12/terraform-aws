import AWS from 'aws-sdk';


const s3 = new AWS.S3();

export const handler = async (event) => {
    
    const bucketName = event.queryStringParameters.bucketName
    const contentType = event.queryStringParameters.contentType
    
    const params = {
        Bucket: bucketName,
        Key: event.queryStringParameters.fileName,
        Expires: 300, // URL 유효 시간 (초)
 
    };

    
        const presignedUrl = await s3.getSignedUrlPromise('putObject', params);
        try{
        return {
            statusCode: 200,
            headers: {
                "Access-Control-Allow-Headers": "Content-Type"
        },
            body: JSON.stringify({ url: presignedUrl }),
        };
        }catch(error){
              console.error(error);
        return {
            statusCode: 500,
            body: JSON.stringify({
                message: 'Error uploading file',
                error: error.message
            })
        };
        }
  
};