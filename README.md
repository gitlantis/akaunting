# Akaunting™ container

Akaunting is a free, open source and online accounting software designed for small businesses and freelancers. It is built with modern technologies such as Laravel, VueJS, Bootstrap 4, RESTful API etc. Thanks to its modular structure, Akaunting provides an awesome App Store for users and developers.
* [Source](https://github.com/akaunting/akaunting) - Source code of Project
* [Home](https://akaunting.com) - The house of Akaunting
* [Forum](https://akaunting.com/forum) - Ask for support
* [Documentation](https://akaunting.com/docs) - Learn how to use
* [Developer Portal](https://developer.akaunting.com) - Generate passive income
* [App Store](https://akaunting.com/apps) - Extend your Akaunting
* [Translations](https://crowdin.com/project/akaunting) - Help us translate Akaunting
* [Repo](https://github.com/akaunting/akaunting) - Github  

## 1. Prepear repository
## Installation

In the project created ```Dockerfile``` and ```docker-compose.yml``` files to deplay project on the cloud.

create docker network
```docker network create akaunting-network```

to compose containers
```docker-compose up --detach```

after successfully building image yo have to migrate database
#### Migrating databse 

it foes not work with Azure DevOps there methodology will be different

Get app container ID or name
```docker ps```

migrate database
```docker exec -it [container_id] php artisan install --db-host=db --db-port=3306 --db-name=akaunting --db-username=root --db-password="" --db-prefix=cxm_ --admin-email="admin@company.com" --admin-password="123456"```

```push``` repository to [dev.azure.com](dev.azure.com)

## 2. Prepare ```Resource Group``` in [portal.azure.com](portal.azure.com)

#### 1. add Resource Group
![Resource group](./assets/res_group.png)

in our case it is called ```akaunting_rg```
#### 2. add Container Registery
![Resource group](./assets/container_reg.png)

and configure it:
select resource group and SKU for container registery

![Resource group](./assets/container_reg_conf.png)

enable admin user

![Resource group](./assets/container_rg_access.png)

#### 3. Link Azure account to our DevOps account

![resource group](./assets/link_azure_devops.jpeg)

Link to resource group

![resource group](./assets/rg_link.png)

Link to Container

![container registery](./assets/rg_docker.png)

![container registery](./assets/rg_docker_conf.png)

#### 4. Create Pipeline

![pipeline](./assets/pipeline.jpeg)

select ```Azure Repos Git``` in our case reopsitory called ```akaunting```

![container registery](./assets/pipeline_repo.png)

you can find zaur pipeline configuration inside of ```akaunting/azure-pipelines.yml```

save configuration for now

![container registery](./assets/pipeline_save.png)

we have to create relase pipeline for the results

go to ```Pipelines > Releases``` and click the ```New``` pipeline button, select ```Empty Job```

![container registery](./assets/pipeline_release.jpeg)

![container registery](./assets/pipeline_release_job.png)

![container registery](./assets/pipeline_rel_add_jpb.png)

get container name from DevOps profile 

![container registery](./assets/container_name.png)

set it into Image name field

![container registery](./assets/pipeline_image_name.png)

and save pipeline

and create default artifact 

![container registery](./assets/pipeline_artifact.png)

instruct the pipeline to automatically create a new release every time a build is available

![container registery](./assets/contribution.png)

save all actions

and go to ```Pipeline``` from ```Dashboard```

run pipeline

when you build you will get error on release.
when we building system looks for Azure Web App service which we had created job befor. 

![container registery](./assets/pipeline_cont_error.png)

Container was not exist before.

#### 5. add Web App Service to see results

we build image in the last step, we have to add image to app service to see results

![App Service](./assets/app_service.png)

![App Service](./assets/app_service_conf.png)

![App Service](./assets/app_cont_conf.png)

Create App service

try to rebuild pipeline next run will completed successfully

![App Service](./assets/job_success.png)

![App Service](./assets/job_screen.png)

http://akaunting.azurewebsites.net/

#### 6. Migrating database

Create MySQL database into Service Group

![App Service](./assets/azure_my_sql.png)

configure it for your need

![App Service](./assets/my_sql_conf.png)

after saving you have to connection security 

make sure to migrate database you must allow your ISP ip to firewall

![App Service](./assets/my_sql_access.png)

add .env file to security file for security resons

![App Service](./assets/security.png)

after including you must configure ```azure-pipelines.yml``` to copy this ```.env``` file to app diraectory

run ```php artisan install --db-host=azure_mysql --db-port=3306 --db-name=akaunting --db-username=root --db-password="" --db-prefix=cxm_ --admin-email="admin@company.com" --admin-password="123456"``` for mysql database migration 

after migration you can log in to service with admin password of platform 

```sh
admin@company.com
123456
```
some javascript files were missing, 

![App Service](./assets/final_result.png)

and this is our final deployment result after fix

![App Service](./assets/final_result01.png)

#### 7. Backuping database

for this process we have to:
1. create VM to run ```mysqldump``` command job script is inside of ```data/muskl_backup.sh
2. create ```storage account``` to store backups
3. join them together
##### 7.1. create VM

![VM config](./assets/vm_icon.png)

configure it

![VM config](./assets/vm_create.png)

to connect vm I am using ```ssh``` key you can use login and password
leave other settings as default, download ssh key after generation completed.

connect to VM via SSh
and install ```mysql-client``` and azure cli

```sh
sudo apt update 
sudo apt install mysql-client
sudo apt install azure-cli
```

##### 7.2. create storage account

![VM config](./assets/storage_account.png)

configure it

![VM config](./assets/stor_acc_conf.png)

you can leave other settings to default

nest step is we must add ```file share``` to this service

select ```file shares``` from left side menu

![VM config](./assets/fileshare.png)

we will link to this file share from our VM.

to link to this ```file share``` go to fileshare we have created,
and press ```connect``` button go to Linux and copy it into vm

![VM config](./assets/fileshare_script.png)

you can see example script inside of ```data/vmfiles.sh``` file

##### 7.3. join them together

I am going to join this services to work together
in the ```data/muscle_backup.sh``` script file you can find example to backup mysql data, just provide your own connection credentials.

to reduce price ```muscle_backup.sh``` used azure vm shutting down command after complating task

```az vm deallocate -g akaunting-rg -n akauntvm```

to integrate you have to integrate cli with azure 
```az login```

![VM config](./assets/az_login.png)

to test this script just run script

```sh ./muscle_backup.sh```

![VM config](./assets/runscript.png)

backup file will be stored into ```$year/$month/$day/$hour/back_[timastamp].sql```

![VM config](./assets/backup_fileshare.png)

#### we must set this script into ```crontab``` jobs

open crontab job 
```crontab -e```

add 

```0 0 * * * sh /home/azureuser/muscle_backup.sh >> /home/azureuser/backup.log```

this will run job every 00:00 by UTC

for now, we have to schedule vm turn on 20mis before running our job.

find ```Logic App``` and press ```+ Add``` button

![VM config](./assets/logic_apps.png)

![VM config](./assets/logic_app_conf.png)

when it is created go to resource

![VM config](./assets/logic_app_resource.png)

select ```Recurrance```

![VM config](./assets/vm_start.png)


### 8. Kubernets(fixed scale)

#### 8.1 Kubernets integration into DevOps Service
Open Kubernets reource

![Kubernets config](./assets/kubernets_icon.png)

press ```+ Create``` dropdown ```+ Add Kubernets Cluster```

set ```Rsource group```, ```Kubernetes cluster name```, change ```Node size```
and set scale method to ```Manual```

![Kubernets config](./assets/kuber_config.png)

set other parameters as default
and ```Create```

![Kubernets config](./assets/kuber_service_conn.png)    

go to azure DevOps service 
and create pipeline for ```Kubernets```

**Note**: in the resource group yo must have container registery to push and pull container image

![Kubernets config](./assets/kuber_pipe.png)

just save yaml file for now
we have to add secure files into it

you can find yaml azure compose file into ```azure-pipelines-kuber.yml```
after saveing run pipeline.

when deploying complated,
We must get ```Public IP``` of ```Nodes```

go to azure command line tool

```sh
az login
#do not forget path of credentials, we will use it in kubernets dashboard
az aks get-credentials --resource-group akaunting-rg --name akaunt-kube
#get pods
kubectl get pods
```

![Kubernets config](./assets/pods_list.png)

```
#in our case pod name starts with 'acaunting'
kubectl get service akaunting --watch
```

![Kubernets config](./assets/pod_ip.png)

![Kubernets config](./assets/pod_result.png)

pod connects to our MySQL database and our result is:

![Kubernets config](./assets/pod_result_conn.png)

#### 8.2 Kubernets Monnitoring tool

Kubernets have own dashboard to monnitor Pods and Nodes

type ```kubectl proxy``` to console and go to following url

[http://localhost:8001/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/](http://localhost:8001/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/)

**if you get Json failure text**
```kubernets-dashboard``` have not installed

you have to install ```kubernets-dashboard```

```sh
#create role to bind dashboard with kubernets
kubectl create clusterrolebinding kubernetes-dashboard --clusterrole=cluster-admin --serviceaccount=kube-system:kubernetes-dashboard --user=clusterUser
#apply kubernets-dashboard configuration
kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.3.1/aio/deploy/recommended.yaml

```

try to reconnect dashboard

```kubectl proxy```

connecting to resource

![Kubernets config](./assets/kuber_dash.png)

after signing in:

![Kubernets config](./assets/kuber_dash_ivew.png)

if you want to reduce cost of service you can stop kubernet temporarly

```sh
#stop kubernet
az aks stop --resource-group akaunting-rg --name akaunt-kube
#start kubernet
az aks start --resource-group akaunting-rg --name akaunt-kube 
```

### 8. Kubernets(Horizontal pod autoscaling)

autoscaling deployment scripts are inside of ```minifests_hpa``` folder.
```azure-pipelines-hpa.yml``` for azure pipeline 

I am using ```slowhttptest``` to test load to server, 

this will create 1000 connctions 

```slowhttptest -c 1000 -H -g -o outputfile -i 10 -r 200 -t GET -u http://13.88.222.185 -p 2```

![Kubernets config](./assets/kali_request_test.png)

500 milicore

![Kubernets config](./assets/500_millicore.png)

creating next node to move pod to next node

![Kubernets config](./assets/moving_to_next_node_container.png)

```sh
kubectl get all # to get all namespaces
kubectl get hpa -w # horizontal pod autoscalors
kubectl get pods # pods list
kubectl top pods # pods with resource statistics
kubectl get nodes # nodes list 
kubectl get deployments #deployments list
```

### 9. Web hook

I am using [pipedream.com](pipedream.com) service to get notifications

![Kubernets config](./assets/webhook.png)

here is example of webhook configuration
we will send result to our web listener on git push for our specified repository

![Kubernets config](./assets/webhook_conf.png)

create webhook listener in [pipedream.com](pipedream.com)

![Kubernets config](./assets/webhook_request.png)

our service ready and listening now

copy http listener link in the textbox

![Kubernets config](./assets/webhook_link.png)

first time to check connection you can use Test button.

In the following you can see result after push

![Kubernets config](./assets/webhook_result.png)

### 10. Logging

Azure supports build in logging system,
In the following image you can see kubernets logs

![Kubernets config](./assets/log_filter.png)

Queries will make using Kusto query language.

In the following query you can filter ```ContainerLogs``` by
field ```LogEntry``` by containing keywoard ```[php-fpm:access]```
and executed commands ```TimeOfCommand``` in last 24 hour,
query takes only ```100``` log results 

```sh
let FindString = "[php-fpm:access]";
ContainerLog 
| where LogEntry has FindString 
| where TimeOfCommand > ago(24h)
|take 100
```

lets put script into query screen and test it

![Kubernets config](./assets/log_result.png)

this is our result