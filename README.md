# Project Description
A Python lambda template for use with Insight Engine 2.0

# Pre-Requisites
    - Docker Desktop

# Run Locally

## WINDOWS

1. Build the Container
    - `docker run --platform linux/amd64 -p 9000:8080 ie2pylambdatemplate:latest`
2. Test your Function
    - `Invoke-WebRequest -Uri "http://localhost:9000/2015-03-31/functions/function/invocations" -Method Post -Body '{}' -ContentType "application/json"`

## OSX / LINUX

1. Build the Container
    - `docker run --platform linux/amd64 -p 9000:8080 ie2pylambdatemplate:latest`
2. Test your Function
    - `curl "http://localhost:9000/2015-03-31/functions/function/invocations" -d '{}'`