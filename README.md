## 사전 준비
- IAM Access Key / Secret Key
- ACM SSL/TSL 인증서
- Route 53 도메인
- Route 53 트래픽 흐름 정책


1. terraform.tfvars 파일을 생성 후 아래 형식으로 정보를 등록한다. 인증서는 와일드카드 인증서로 발급한다.
```
region_1_acm = "<리전1 인증서 arn>"
region_2_acm = "<리전2 인증서 arn>"
access_key = "<액세스 키>"
secret_key = "<시크릿 키>"
us_acm = "<US-EAST-1 인증서 arn>"
```

2. main.tf 파일의 locals 블록에 사용할 리전 값과 블로그 이름, 도메인을 입력한다. 도메인은 Route 53에서 미리 등록해야 한다.

3. 사용하고 싶은 리전이 HTTP API Gateway를 지원하는 리전인지 확인한다.
지원하지 않는 경우에 다른 리전으로 변경하거나 API Gateway v1을 사용해야한다.

4. AMI의 권한을 퍼블릭으로 공유했으나 리전별로 복제 후 공유해야 하므로 다른 지역에서 사용하고 싶으면 해당 지역에 AMI 복제를 요청한다. (rlatmdwn0702@gmail.com)

5. Route 53에 도메인을 등록해야 한다. 트래픽 흐름 정책으로 지리 근접성 정책(geoproximity_routing_policy)과 상태 확인(health check)을 결합한다. 그 다음 트래픽 레코드를 도메인의 이름과 같게 A레코드를 생성한다. 트래픽 흐름 레코드는 월 $50으로 가격이 부담되면 트래픽 흐름을 사용하지 않고 호스팅 영역에서 지리 근접성 정책으로 ALB와 A레코드로 연결한다.  

6. CI/CD의 경우 현재는 콘솔에서 해당 GitHub 계정으로 직접 인증해야 소스의 업데이트 사항을 가져올 수 있기 때문에 다른 계정에선 사용하지 않는다. 추후 Terraform에서 인증이 가능하게 변경되기 전까진 사용 불가