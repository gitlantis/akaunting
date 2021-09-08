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
```docker exec -it [container_id] php artisan install --db-host=db --db-port=3306 --db-name=akaunting --db-username=root --db-password="" --db-prefix=cxm_ --admin-email="admin@company.com" --admin-password="123456""```

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