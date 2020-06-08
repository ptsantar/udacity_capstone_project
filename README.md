## Udacity Cloud DevOps Nanodegree - Capstone Project
The goal of this repository is to test my skills and knowledge which were developed throughout the Cloud DevOps Nanodegree program, such as:
 * Working in AWS
 * Using Jenkins to implement Continuous Integration and Continuous Deployment
 * Building pipelines
 * Working with Ansible and CloudFormation to deploy clusters
 * Building Kubernetes clusters
 * Building Docker containers in pipelines

## Project scope
In this project, I am developing a CI/CD pipeline for micro services applications with blue/green deployment. A simple website will be used for starters with simple linting. Down the road a more advanced app may be added with more advanced steps, such as integration and performance testing or security scanning.

The idea is to have to different branches, master (blue) and green. The only difference between the branches is that the backgound of `index.html` is blue in master branch, and green in greeen branch. 

The deployment is done through Jenkins. At the end of the pipeline there is a step that asks the user to deploy the branch (i.e., change the load balancer to redirect traffic to the other "app"). 

At first, the traffic from the Load balancer is redirected to blue pods (i.e, master branch is deployed) and thus, the `index.html` has a blue background. Then, the green pipeline is executed and at the final stage asks the user for deploying the green branch to the cluster. If the user confirms this, the backgound of `index.html` changes to green. Note that the blue backgound can return by re-playing the pipeline for the master.

#### Step 1
Created the GitHub repository that contains a directory (`my_site`) with a simple html file to be deployed. Then, created a Dockerfile and containerized the application. Also, test the docker image locally and pushed it in the Docker Hub.

GitHub Repo: https://github.com/ptsantar/udacity_capstone_project
DockerHub Repo: https://hub.docker.com/r/ptsantar/udacity_cloud_devops_capstone

#### Step 2
Setup Jenkins in a EC2 instance. The instance was created with a cloudformation script (`jenkins.yml`), but the installation of Jenkins failed due to GPG key. Thus, additional steps were required to complete the installation of Jenkins. In addition, the installation of Hadolint, docker, kubectl, aws_cli and eksctl are not included in the 'yml' file (TODO). 

Created a piple with the following steps:
 * Linting: checks the format of the html (tidy) and the Dockerfile (hadolint) 
 * Build the Docker Image: builds the docker image 
 * Push Docker Image: pushes the image that was just build to Docker Hub
 * Stops & Remove Docker Image: cleanup activities 


#### Step 3
The EKS cluster was created manually with the following command:
```
        eksctl create cluster \
        --name mycluster \
        --region us-west-2 \
        --nodegroup-name standard-workers \
        --node-type t2.nano \
        --nodes 2 \
        --nodes-min 1 \
        --nodes-max 3 \
        --ssh-access=true \
        --ssh-public-key <key-name> \
        --managed
```

#### Step 4
Added an additional stage to deploy the app to the EKS Cluster (assuming that the cluster was created)
 * Deploy to AWS EKS Cluster: deploys the container to **existing** AWS Cluster. It requires user confirmation to change the Load Balancer to depoly the new application.

At this point the master branch is deployed to the cluster and can be access through the internet. The url is retrieved looking at the services:
```
kubectl get services

NAME          TYPE           CLUSTER-IP      EXTERNAL-IP                                                               PORT(S)          AGE
bluegreenlb   LoadBalancer   10.100.13.162   *ac257a5b8ad5a48e68923cd3a4ca5b76-20104264.us-west-2.elb.amazonaws.com*   8000:32446/TCP   12h
kubernetes    ClusterIP      10.100.0.1      <none>                                                                    443/TCP          16h
```

#### Step 5
Created a new branch `green` with the only difference that the backgound of the html is now green. Also, updated the `controller.json` to create new pods when it is deployed. Note the `service.json` remained the same, so that when the green branch is deployed will override the previous setting and the traffic is redirected to the green pods (instead of the blue).
 - Validate that the load balancer changes to  `app=green` (previously set to `app=blue`)
 - Validate that the html file is updated and the green background is shown.

Also, tested that replaying the master branch (blue) pipeline will change the background back to blue. The green branch can re-played to change to green and so on... 

## TODO
 - `jenkins.yml`: software installation for Jenkins fails due to GPG key, requires manual work. Add installation of hadolint (v 1.17.6), docker, kubectl, aws_cli, eksctl