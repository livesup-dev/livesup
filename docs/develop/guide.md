# Developer Guide

This is the official guide to LiveSup.

It will advance chapter by chapter and go more and more into details, advanced usages, and special cases.

We will start by introducing basic concepts and features, and then dig deeper into configurations and projects, dashboards and widgets details in later chapters.

## Summary

1. [Introduction](./introduction.md)
1. [Setup](./setup.md)

## How data is structure

Livesup has a very flexible data structure that lets you organize the data in the way you want. The top level component is a "Project". A Project can be part of more projects (the current UI only supports one level of projects), and it can have several dashboards, each dashboard has widgets. 

![](/docs/images/projects-data-structure.png)

The relationship between users and projects, is controlled by `Groups`. A Group can have many projects and users. So you can control who can see what. New signup will be associated to a default group called `All Users`. And any new project will be associated to that group by default, meaning that when you create a project it will become available to all existing users. 

![](/docs/images/users-projects.png)



## Seeding

Since we don't have a proper UI yet to manage all the components. The easiest way to seed the app is to use a YAML definition. You can see the demo [here](/docs/demo-seed.yaml). 
 
There are 2 ways you can import that file. 

* Console

Log in into the console and do: 

```
YamlElixir.read_from_file('docs/demo-seed.yaml')
|> LiveSup.LiveSup.DataImporter.Importer.import()
```

* API

To use the API you first need to have a valid token, to do that, you can use the following curl command (change the host accordingly):

```
curl --location --request POST 'http://localhost:4000/api/sessions' \
--header 'accept: application/json' \
--header 'Content-Type: application/json' \
--data-raw '{
    "email": "emiliano@summing-up.com",
    "password": "Very@Safe@Password"
}'
```

Grab the token and convert the yaml file into json. You can use `jq --raw-input --slurp < demo-seed.yaml`

```
curl --location --request POST 'http://localhost:4000/api/seed' \
--header 'Authorization: Bearer YOUR-TOKEN-HERE' \
--header 'Content-Type: application/json' \
--data-raw '{
    "data":"....."
  }'
```
