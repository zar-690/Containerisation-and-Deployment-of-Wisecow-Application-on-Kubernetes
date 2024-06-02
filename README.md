Clone the repository:
https://github.com/zar-690/Containerisation-and-Deployment-of-Wisecow-Application-on-Kubernetes.git


Write Dockerfile:
# Use an official Python runtime as a parent image
FROM python:3.9-slim

# Set the working directory in the container
WORKDIR /app

# Copy the current directory contents into the container at /app
COPY . /app

# Install any needed packages specified in requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

# Make port 80 available to the world outside this container
EXPOSE 80

# Define environment variable
ENV NAME Wisecow

# Run app.py when the container launches
CMD ["python", "app.py"]
Build the Docker image:
docker build -t wisecow-app .
Test the Docker image locally:
docker run -p 8080:80 wisecow-app
Kubernetes Deployment
Create Deployment YAML (wisecow-deployment.yaml):
apiVersion: apps/v1
kind: Deployment
metadata:
  name: wisecow-deployment
  labels:
    app: wisecow
spec:
  replicas: 1
  selector:
    matchLabels:
      app: wisecow
  template:
    metadata:
      labels:
        app: wisecow
    spec:
      containers:
      - name: wisecow
        image: <your-container-registry>/wisecow-app:latest
        ports:
        - containerPort: 80
Create Service YAML (wisecow-service.yaml):
apiVersion: v1
kind: Service
metadata:
  name: wisecow-service
spec:
  selector:
    app: wisecow
  ports:
  - protocol: TCP
    port: 80
    targetPort: 80
  type: LoadBalancer
Apply the manifest files:
kubectl apply -f wisecow-deployment.yaml
kubectl apply -f wisecow-service.yaml
Continuous Integration and Deployment (CI/CD)
GitHub Actions Workflow:
Create .github/workflows/ci-cd.yml:
name: CI/CD Pipeline

on:
  push:
    branches:
      - main

jobs:
  build-and-deploy:
    runs-on: ubuntu-latest
    steps:
    - name: Checkout code
      uses: actions/checkout@v2
    - name: Login to Container Registry
      uses: docker/login-action@v1
      with:
        username: ${{ secrets.REGISTRY_USERNAME }}
        password: ${{ secrets.REGISTRY_PASSWORD }}
    - name: Build Docker image
      run: docker build -t <your-container-registry>/wisecow-app:latest .
    - name: Push Docker image
      run: docker push <your-container-registry>/wisecow-app:latest
    - name: Deploy to Kubernetes
      run: kubectl apply -f wisecow-deployment.yaml
      env:
        KUBECONFIG: ${{ secrets.KUBE_CONFIG_DATA }}
Configure Docker and Kubernetes secrets in the GitHub repository settings.
TLS Implementation
Generate TLS Certificates:
Use tools like Let's Encrypt to generate certificates.
Configure TLS in Kubernetes Ingress:
Create an Ingress resource for TLS termination.
Update wisecow-service.yaml to use NodePort or ClusterIP type.
Configure Ingress rules for secure communication.
