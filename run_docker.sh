#!/usr/bin/env bash

## The following steps to get Docker running locally

# Build image and add a descriptive tag
docker build --tag=udacity_cloud_devops_capstone .

# List docker images
docker image ls

# Step 3:
# Run flask app
docker run -it -p 8080:80 udacity_cloud_devops_capstone
