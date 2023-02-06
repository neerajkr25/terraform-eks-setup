Steps for UAT infra
===============================
1- S3 Bucket                - TF state file - Manual
2- DynamodbTable            - TF statelocking - TF - Pending
4- VPC                      - Networking (10.53.82.0/24) - TF
Subnet details :
•	10.53.82.0/26 (64 IP APP1)
•	10.53.82.64/26 (64 IP APP2)
•	10.53.82.128/28 (16 IP WEB/ALB1)
•	10.53.82.144/28 (16 IP WEB/ALB2)
•	10.53.82.160/28 (16 IP DB1)
•	10.53.82.176/28 (16 IP DB2)
Future Subnet - 10.53.82.192/26 (64 IP)     

5- EKS                      - EKSCTL 
Notes for eks :-
    AddOns needs to be defined by eksctl config as I have added addons manualy for UAT \
6- Helm                     - For deployment     - CLI
7 -Fluentbit                - Container insights - CLI
8- ECR                      - For storing images - Manual

Commands for ecr auth
aws ecr get-login-password --region ap-south-1 | docker login --username AWS --password-stdin 423224728550.dkr.ecr.ap-south-1.amazonaws.com


==============================================
K8s dashboard :- 
https://docs.aws.amazon.com/eks/latest/userguide/dashboard-tutorial.html


===============================================
Database creation           - manual -
================================================
EKS dashboard :- 
https://docs.aws.amazon.com/eks/latest/userguide/dashboard-tutorial.html

To get token
kubectl -n kube-system describe secret $(kubectl -n kube-system get secret | grep eks-admin | awk '{print $1}')

Login URL :-
http://localhost:8001/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/#!/login

To access the k8s dashboard 
kubectl proxy


===================================================
FluentBit:-
https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/Container-Insights-setup-logs-FluentBit.html

===================================================
Ingress-
Nginx ingress controller we are using 
find the sample ingress file :- We need to point it to the particular service in order to expose through load balanacer, We are using CLB as of now, Will use ALB in prod.

Temp CLB:-
a7df5fd28b8684f6f868a8c14533e060-1588195748.ap-south-1.elb.amazonaws.com
---
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: nk-test-ingress
  namespace: nk-test
  annotations:
    kubernetes.io/ingress.class: nginx
    nginx:ingress.kubernetes.io/rewrite-target: /
spec:
  rules:
  - http:
      paths:
        - pathType: /
          backend:
            service:
              name: nk-test-svc
              port:
                number: 80
          path: /
---
=================================================
Mapping the DNS 
1- K8s dashboard 
2- Grafana
Need to get the DNS from cloudflare team


====================================================
HPA :-
Guide :-
https://www.eksworkshop.com/beginner/080_scaling/deploy_hpa/
1-Install the Metrics Server
2-Deploy a sample application
3-Install Horizontal Pod Autoscaler
4-Monitor HPA events

kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/download/v0.5.0/components.yaml

========================================================
Jump server and CD server :-
EC2 for pushing images and deployment
it will have access to the EKS and ECR
Integration of CD server to EKS via Secret key and access of aws (RBAC needs to apply)

Jump server public ip- 13.233.109.106
EKScd server pvt ip- 10.53.82.14  
Master-key
Installed docker / Kubectl / aws cli / fetch aws cred for access the EKS / IAM role attached to access the ECR and EKS 

CD server to Github access:-
token :- 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
git clone -b eks-deploy https://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@github.com/vikash-au/ca-apis.git
git clone https://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@github.com/vikash-au/ca-poc.git

https://github.com/vikash-au/ca-poc.git - Frontend
https://github.com/vikash-au/ca-apis.git - Backend

=========================================================
Steps to get into CD server :-
1- Connect with CD-jump-server with Master pem key
ssh -i .\Master-key.pem ec2-user@13.233.109.106
2- Navigate into aws-key directory (Stored) master key file 
3- Do ssh to the CD server with below command
sudo ssh -i master-key.pem ec2-user@10.53.82.14
4- navigate the folders 
    k8s-deploymetns- Containts deployments YAML's
    becode - backendcode 
5- To deploy the YAML, Run below command 
kubectl apply -f <deployment file>
Note:- Make sure you are fetching the linux Secret key and Acesss keys from AWS
============================================================