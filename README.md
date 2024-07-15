# Bolt6 software on-boarding 

Welcome to Bolt6. After our fall with Amazon, we have switched our cloud parnter to Heroku.

This page will help you get on-boarded with our stack that runs our comapny web page.  

### Cloning the webpage repository
Assuming you have set up SSH on your computer, clone this repository by running the following command 

``` git@github.com:deveshdatwanibolt6/devesh-app.git ```


### Introduction to the stack

We run our webpageb with Flask. Currently, the flask default WSGI server handles all the request, we would use gunicorn or similar servers in the future with a NGINX reverse proxy sitting in front of it to handle caching and load balancing.

The repository structure with two levels of detail is shown below

```
├── app
│   ├── app.py
│   ├── Dockerfile
│   ├── __init__.py
│   ├── requirements.txt
│   └── view.py
├── heroku.yaml
├── main.tf
├── Procfile
├── README.md
├── requirements.txt
├── terraform.tfstate
├── terraform.tfstate.backup
└── tests
    ├── __init__.py
    └── test_app.py
```

### Setting up Heroku

To live the application, we need to deploy it to Heroku with git. Do look at how Heroku PaaS architecture works here https://www.heroku.com/platform. Heroku basically uses git to deploy applications. We do so by setting up a git remote link to the heroku application in the repository and by pushing commits to the "main" branch. A Procfile contains the manifest / blueprint / command required to run the application. Once a commit is pushed, Heroku looks for the Procfile and runs the command inside it. A Procfile follows yaml structure. 

Login to to heroky 

To scale applications in Heroku, Heroku provides CLI functioanlity and also supports Terraform. 

We curently have 3 environments at which the application can be run

### Setting up local environment

execute the bash script set-up. by pasting the following command on your terminal
   
   ``` bash set-up-local.sh ```

this will install heroku CLI, docker and build a python virtual environment required to run the application 

Next, login in to heroku through your CLI by using the command 

``` heroku login ```

Seek whoever is helping you on-board for credentials to the heroku dashboard. In future, we should be employing an SSO solution which would authorize emails with domain with bol6.ai to access the application dashboard.   

### Scaling

If you have gone through's Heroku architecure, it will be clear that we use the "web" workloads to run our application. To scale applications

``` heroku ps:scale web=2 ```

where we replace web=2 with the number of dynos we require to sufficiently handle traffic. For staging environments, we do not require many, however, for production environment, we would require a higher number depending on the traffic. 

Alterantively, we can use terraform to scale applications. The file <i>main.tf</i> in the highest repository can be tweaked as per requirement and the command 

``` terraform apply ``` 

can be run to enforce the changes on heroku. 

### Running the application in DEV ENV

The "app" folder contains the flask application and contains the necessary modules for running a flask application along with a Dockerfile that instructs dokcer to build an image based from alpine OS so that we can run its container on any environment running docker on x86 architecture. You can tweak the Dockerfile and bash script to change configurations such as port bindings etc.

Spin the application sever by executing run-local-env.sh

   ``` bash run-dev-env.sh ```

You can now request localhost with the correct port from your web browser.

The docker container will be running as daemon, and hence would require shutting to stop from spinning. 

### Running the application in STAGING ENV

At Bolt6, we want to make sure our end users have a great experience on our webpage, so in addition to the dev environment, we have a staging environment hosted at Heroku which spins a flask server hosted on Heroku available to the public just like a production server, but under debug mode. Incorrect requests or exceptions are handled and with verbose stack traces, making it easier to debug the issue. The URL to this server is hidden from the public and is for internal use only. 

URL - ``` https://b6-app-staging-24f757098ecf.herokuapp.com/ ```

To deploy the app, set up heroku remote in the application's repository with

``` heroku git:remote -a b6-app-staging ```

``` git add . ```

``` git commit -m '<add message of choice>' ```

``` git push origin heroku main ```

### Running the application in PRODUCTION ENV

Finally, the application after running and passing tests, can be deployed to production environment by two ways

1. Merging a branch with main will autoamtically trigger a workflow (explained below) that deploys the new changes.
2. Using commands from staging env section, with remote set to the production app. The production app is named <i> b6-app </i>

URL - ``` https://b6-app-3c0679bee245.herokuapp.com/ ```

### Branch protection rule & sensitive information

Main branch of the repository has been protected for direct pushing, which means the only way to change content of it, is to create a pull request from another branch, have it reviewed by peers and then marge it.

Next, sensitive information such as API keys and environmental varibales are currently exposed to the public through env files and direct mention in workflow files. This is dangerous and a better solution is to use GitHub secrets through context for API Keys and / or AWS vault services to store and pull environment variables such as application version number, API keys, URLs etc. 

### GitHub Actions

The Bolt6 dev team work on their custom branches and merge their changes with the <i> V1 </i> branch. 

Then, we create a pull request for V1 to be merged with main.

This triggers the test workflow which runs pytest on the services and endpoints exposed by our application. 

At the moment, the pytest looks for keyword "VERSION" in response to making request to "/" end point. 

If the tests clear, our application can be staged, or alternatively deployed to production by approving the pull request and merging V1 to main. 

### .env

Currently, we use .env file to source environment variables such as application version number. As mentioned before, it is bad practice and should be avoided and changed to a better solution ASAP.

As a rule of thumb, env type files should be included in .gitignore so that sensitive information is not leaked, but at the moment, it has been excluded from it.
