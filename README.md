# ![Limbarine] Limbas-Docker

## Introduction
Limbas is a database framework for creating database-driven business applications.
As a graphical database front-end, it enables the efficient processing of data stocks and the flexible development of comfortable database applications.

## Usage (docker-compose, including PostgreSQL)
```
> git clone https://github.com/limbas/limbas-docker.git
> cd limbas-docker
> docker-compose up
```

Limbas will be available for usage at http://localhost:8000

User: admin

Pass: limbas

## Usage (with your custom database)
```
> docker pull limbas/limbas
> docker run -p 8000:80 ... limbas/limbas
```

Connecting the limbas container and your database container is up to you.

Limbas will be available for configuration at http://localhost:8000/admin/install/

[Limbarine]: ./Limbarine.png "Limbarine"
