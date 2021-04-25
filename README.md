## Flyway

### Prerequisites:

Download [Flyway](https://flywaydb.org/download/community)
 
[Docker Desktop](https://hub.docker.com/editions/community/docker-ce-desktop-windows)

[Visual Studio Code](https://code.visualstudio.com/)

### Loose Agenda:

Implement and iterate on a database schema using Flyway

Get Postgres server instance
Create database in postgres server
Create flyway versioned migration scripts
Run Flyway migration


### Step by Step

#### Playground setup

Create a new playground directory for today's exercise.

For the purpose of today's exercise we will extract the downloaded Flyway zip file to the playground directory such that the Flyway executable is in the root directory.

Add a `sql` directory in the root of the new playground directory

#### Setup Postgres instance

Obtain a Postgres server and database leveraging insights from [our Postgres exercise](https://github.com/Non-Zero-Days/postgres#create-a-database)

For the recorded demo we will use the Postgres docker image and pass it the following `init.sql` file to create a database.

``` sql/init.sql
CREATE DATABASE nonzero;
```

``` Dockerfile
FROM postgres:11

ENV POSTGRES_USER "docker"
ENV POSTGRES_PASSWORD "docker"

EXPOSE 5432

COPY sql/init.sql /docker-entrypoint-initdb.d/init.sql
```

In a terminal instance from the root directory of this repository run 
```
docker build -t nonzerodb .
docker run -d --rm -p 5432:5432 nonzerodb
```

#### Create flyway versioned migration scripts

Create a new file in the sql directory named `V1.0.0__Table.sql` with the following contents

``` V1.0.0__Table.sql
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

CREATE TABLE nonzerotable (
   id uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
   name TEXT NOT NULL,
   age INT NOT NULL,
   address CHAR(50)
);
```

#### Run Flyway Migration

In the root directory of your repository, run the following command
```
.\flyway migrate -url=jdbc:postgresql://localhost:5432/nonzero -locations=filesystem:./sql -connectRetries=60 -mixed=true -user=docker -password=docker
```

You should see a message such as 
` Successfully applied 1 migration to schema "public", now at version v1.0.0`

#### Iterate on the database

Create another new file in the sql directory and name it `V1.0.1__AnotherTable.sql` with the following contents

``` V1.0.1__AnotherTable.sql
CREATE TABLE anothertable (
   id uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
   name TEXT NOT NULL,
   age INT NOT NULL,
   address CHAR(50)
);
```

In the root directory of your repository, run the following command
```
.\flyway migrate -url=jdbc:postgresql://localhost:5432/nonzero -locations=filesystem:./sql -connectRetries=60 -mixed=true -user=docker -password=docker
```

You should see a message such as
`Successfully applied 1 migration to schema "public", now at version v1.0.1`


#### Clean and recreate database

Stop and clean up the postgres docker image. In PowerShell for the demonstration I will clean up all running containers by running `docker rm -f $(docker ps -aq)`

Start another instance of Postgres by running `docker run -d --rm -p 5432:5432 nonzerodb`

Run Flyway migration again with
```
.\flyway migrate -url=jdbc:postgresql://localhost:5432/nonzero -locations=filesystem:./sql -connectRetries=60 -mixed=true -user=docker -password=docker
```

You should see a message such as
`Successfully applied 2 migrations to schema "public", now at version v1.0.1`

### Additional Resources

- [Flyway Documentation](https://flywaydb.org/documentation/)
- [Postgres Docker Image](https://hub.docker.com/_/postgres)

Congratulations on a non-zero day!
