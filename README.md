# Akaunting™ container

Akaunting is a free, open source and online accounting software designed for small businesses and freelancers. It is built with modern technologies such as Laravel, VueJS, Bootstrap 4, RESTful API etc. Thanks to its modular structure, Akaunting provides an awesome App Store for users and developers.

* [Home](https://akaunting.com) - The house of Akaunting
* [Forum](https://akaunting.com/forum) - Ask for support
* [Documentation](https://akaunting.com/docs) - Learn how to use
* [Developer Portal](https://developer.akaunting.com) - Generate passive income
* [App Store](https://akaunting.com/apps) - Extend your Akaunting
* [Translations](https://crowdin.com/project/akaunting) - Help us translate Akaunting
* [Repo](https://github.com/akaunting/akaunting) - Github  

## Installation (modified by Asliddin Oripov)

project contains ```Dockerfile``` and ```docker-compose.yml``` files to deplay project on the cloud.

to compose containers
```docker-compose up --detach```

after successfully building image yo have to migrate database
#### Migrating databse

Get app container ID or name
```docker ps```

migrate database
```docker exec -it [container_id] php artisan install --db-host=db --db-port=3306 --db-name=akaunting --db-username=root --db-password="" --db-prefix=cxm_ --admin-email="admin@company.com" --admin-password="123456""```