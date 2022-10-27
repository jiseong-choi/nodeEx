```shell
node tfvars.js \
--debug \
--path=origin.tfvars.json \
--output-path=variables.tfvars.json \
--service=outqource-docker \
--ecr-repo=outqource-docker \
--root-domain=outqource.com \
--record-domain=docker.outqource.com \
--port=8000 \
--database-port=3312 \
--region=ap-northeast-2 \
--profile=default \
--vpc-cidr=172.32.0.0/16 \
--instance-count=2 \
--availability-zone=ap-northeast-2a,ap-northeast-2c \
--min-capacity=1 \
--max-capacity=3
```

```shell
terraform plan --var-file=variables.tfvars.json
terraform apply --var-file=variables.tfvars.json
terraform apply -destroy --var-file=variables.tfvars.json
```

```shell
docker build --platform linux/arm64 -t outqource-docker .
docker run -it -p 8000:8000 outqource-docker
```
