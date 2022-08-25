# Design

## How data is structure

Livesup has a very flexible data structure that lets you organize the data in the way you want. The top level component is a "Project". A Project can be part of more projects (the current UI only supports one level of projects), and it can have several dashboards, each dashboard has widgets. 

![](/docs/images/projects-data-structure.png)

The relationship between users and projects, is controlled by `Groups`. A Group can have many projects and users. So you can control who can see what. New signup will be associated to a default group called `All Users`. And any new project will be associated to that group by default, meaning that when you create a project it will become available to all existing users. 

![](/docs/images/users-projects.png)
