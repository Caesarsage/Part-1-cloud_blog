# Techpet Global DevOps Interns Challenge Part 1 
## Cloud Blog Web Application

- [Challenge](#challenge)
  - [Instructions](#instructions)
- [Documentation](#documentation)
  - [Image Dockerization](#image-dockerization)
  - [Image Dockerization Process Overview](#image-dockerization-process-overview)
  - [CICD With GitHub Action](#cicd-with-github-action)
  - [CICD With GitHub Action Process Overview](#cicd-with-github-action-process-overview)
  - [Final](#final)

## Challenge

This is a Flask application that lists the latest articles within the cloud-native ecosystem.

### Instructions
1. Fork this repo
2. Create an optimized dockerfile to dockerize the application.
3. Use any CICD tool of your choice, create a pipeline that will dockerize and deploy to your docker hub.
4. Create your own Readme.md file to document the process and your choices.

To run this application there are 2 steps required:

1. Initialize the database by using the `python init_db.py` command. This will create or overwrite the `database.db` file that is used by the web application.
2.  Run the Cloud Blog application by using the `python app.py` command. The application is running on port `3111` and you can access it by querying the `http://127.0.0.1:3111/` endpoint.


## Documentation

### Image Dockerization 
>But it working on my laptop 💻😃, why is it not working on yours ?  "The whole reason for Containerization of an application."

- Open your terminal and move to a suitable file path
- Clone the forked repo with the following command:

```
   git clone https://github.com/Caesarsage/Part-1-cloud_blog.git 

```
- move to the directory

```

cd Part-1-cloud_blog

```
- Create a Dockerfile, docker-compose.yml and .dockerignore files inside the project directory :

```

touch Dockerfile, docker-compose, .dockerignore


```

- Open the Dockerfile with your favorite editor (vim)


```
vi Dockerfile 

```

- Enter insert mode(for vim user) and Paste the following inside the Dockerfile


```

FROM python:3.8-alpine
WORKDIR /app
 
COPY requirements.txt requirements.txt
RUN pip3 install -r requirements.txt
COPY . .
RUN python init_db.py
CMD [ "python", "app.py"]

```

- Save file and exit


```
:wq

```

- Open docker-compose and paste the following

```

version: "3"
services:
  flask-app:
    build: .
    ports:
      - "3111:3111

```

- similarly, do same for .dockerignore and paste the following

```
Dockerfile
.dockerignore
.git
.gitignore
docker-compose*

```

- build the image and spin up the container using

```
docker-compose -f docker-compose.yml up --build -d

```

- Now, your code should run at

```
localhost:3111
```

![browser view](assets\run.PNG)

### Image Dockerization Process Overview 

##### Dockerfile 

- FROM python-alpine: Docker Base image to use

- WORKDIR /app: Working directory of the Docker container

- COPY requirements.txt requirements.txt: Copy the contents of our requirements file into the container image's requirements.txt file.

- RUN pip3 install -r requirements.txt: Install all required dependencies.

- COPY . . : Copy all the files in our local working directory to the docker image directory 

- RUN python init_db.py : Docker initialization of the database file "database.db".

- CMD [ "python", "app.py"] : Start up the application.

##### docker-compose

- version: Specify the version of docker compose 
- services: Specify all services managed by the docker compose 
  - flask-app: Name of one service
    - build: Image to build on
    - ports: Port to listen in building the image 


##### .dockerignore

Contains files/directory Docker should ignore building

### CICD With Github Action

> Half the pain, twice the value

- Create a dockerhub repository: This is where we are continuously pushing our code to.

- In your root directory, create a folder/file structure as 

```
------.github
      ----- workflows
            --------- main.yml

```

- Paste the following inside the main.yml file located inside the workflows directory

```
# This workflow will install Python dependencies, run tests and lint with a variety of Python versions
# For more information see: https://help.github.com/actions/language-and-framework-guides/using-python-with-github-actions

name: flask application

on:
  push:
    branches: [ main ]
  pull_request:
    branches: [ main ]

jobs:
  build:

    runs-on: ubuntu-latest

    steps:
    - uses: actions/checkout@v3
    
    - name: Set up Python
      uses: actions/setup-python@v3
      
    - name: Install dependencies
      run: |
        python -m pip install --upgrade pip
        python -m pip install flake8 pytest
        if [ -f requirements.txt ]; then pip install -r requirements.txt; fi
        
    - name: Lint with flake8
      run: |
        # stop the build if there are Python syntax errors or undefined names
        flake8 . --count --select=E9,F63,F7,F82 --show-source --statistics
        # exit-zero treats all errors as warnings. The GitHub editor is 127 chars wide
        flake8 . --count --exit-zero --max-complexity=10 --max-line-length=127 --statistics
        
    - name: Build & push Docker image
      uses: mr-smithers-excellent/docker-build-push@v5
      with:
        image: caesarsage/flask-app
        registry: docker.io
        username: ${{ secrets.DOCKER_USERNAME }}
        password: ${{ secrets.DOCKER_PASSWORD
```

- git add, commit and push your code

### CICD With Github Action Process Overview

#### main.yml

This is the entry file for the ci cd pipeline and it has three major segments namely: name, on and jobs.

- Names : The name of the application

- on: Contains useful information that describes when the pipeline will be triggered and what github branch triggers it.
    - pull_request
    - push

- jobs: Different stages the pipeline takes to perform an action.
     - build on unbutu os
     - Setup the python environment
     - Install dependencies of the application 
     - Carryout some linting
     - Build and push docker image to appropriate provided docker Hub repository name and secrets

 #### Saving secrets in GitHub repository.
> Check Security under repository settings 

### Final

Now your docker file pipeline is done. For every push and pull request made, check the action tab if its passed the pipeline stages 
