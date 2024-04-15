## 사전 준비
- IAM Access Key / Secret Key
- ACM SSL/TSL 인증서
- Route 53 도메인


1. terraform.tfvars 폴더에 아래 형식으로 정보를 등록한다.
```
region_1_acm = "<리전1 인증서 arn>"
region_2_acm = "<리전2 인증서 arn>"
access_key = "<액세스 키>"
secret_key = "<시크릿 키>"
```

2. main.tf 파일의 locals 블록에 사용할 리전 값과 블로그 이름을 입력한다.

3. 사용하고 싶은 리전이 HTTP API Gateway를 지원하는 리전인지 확인한다.
지원하지 않는 경우에 다른 리전으로 변경하거나 API Gateway v1을 사용해야한다.

4. AMI의 권한을 퍼블릭으로 공유했으나 리전별로 복제 후 공유해야 하므로 다른 지역에서 사용하고 싶으면 해당 지역에 AMI 복제를 요청한다.

5. Route 53 도메인을 보유해야 한다.

6. CI/CD의 경우 현재는 콘솔에서 해당 GitHub 계정으로 직접 인증해야 소스의 업데이트 사항을 가져올 수 있기 때문에 다른 계정에선 사용하지 않는다. 추후 Terraform에서 인증이 가능하게 변경되기 전까진 사용 불가