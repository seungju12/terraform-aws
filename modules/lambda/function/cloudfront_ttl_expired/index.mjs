import AWS from 'aws-sdk';

// CloudFront 서비스 객체를 생성합니다.
const cloudfront = new AWS.CloudFront();


export const handler = async (event) => {
  // CloudFront 배포 ID
  const distributionId = 'ECHOV0DRBSX0S';
  
  // 무효화할 객체 경로
  // 예: 모든 파일을 무효화하려면 '/*'를 사용합니다.
  const paths = ['/*'];
  
   // 무효화 요청 파라미터
    const invalidationParams = {
        DistributionId: distributionId,
        InvalidationBatch: {
            CallerReference: `TTLInvalidation-${new Date().getTime()}`, // 고유한 참조값
            Paths: {
                Quantity: paths.length,
                Items: paths
            }
        }
    };
  
  try {
        // CloudFront 캐시 무효화 요청
        const data = await cloudfront.createInvalidation(invalidationParams).promise();
        console.log("CloudFront 캐시 무효화 요청 성공:", data);
        return {
            statusCode: 200,
            body: JSON.stringify({
                message: "CloudFront 캐시 무효화 요청 완료",
                invalidationId: data.Invalidation.Id
            })
        };
    } catch (error) {
        console.error("CloudFront 캐시 무효화 요청 실패:", error);
        return {
            statusCode: 500,
            body: JSON.stringify({
                message: "CloudFront 캐시 무효화 요청 실패",
                error: error.message
            })
        };
    }
    
};
