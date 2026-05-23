**\### Day 32 -- Docker Volumes & Networking**

**\## Task 1: The Problem**

1.  **Run a Postgres or MySQL container**

docker run \--name my-postgres -e POSTGRES_PASSWORD=admin -d postgres

![](media/image1.png){width="5.351733377077865in" height="1.8662456255468067in"}

2.  **Create some data inside it (a table, a few rows --- anything)**

Enter Container

docker exec -it my-postgres bash

![](media/image2.png){width="5.450077646544182in" height="0.9953565179352581in"}

![](media/image3.png){width="4.842542650918635in" height="2.746466535433071in"}

3.  **Stop and remove the container**

docker stop my-postgres

docker rm my-postgres

![](media/image4.png){width="4.701327646544182in" height="0.45205161854768156in"}

4.  **Run a new one --- is your data still there?**

docker run \--name my-postgres -e POSTGRES_PASSWORD=admin -d postgres

![](media/image5.png){width="4.790510717410323in" height="1.6487992125984252in"}

Result:

The database and table were gone.

Why?

Because container storage is ephemeral.

When the container is removed, its writable layer is deleted.

**\## Task 2: Named Volumes**

1.  **Create a named volume**

docker volume create pgdata

docker volume ls

![](media/image6.png){width="4.706667760279965in" height="0.9279713473315836in"}

![](media/image7.png){width="4.636586832895888in" height="1.1648293963254592in"}

![](media/image8.png){width="4.905844269466317in" height="1.4674442257217848in"}

2.  **Run the same database container, but this time attach the volume to it**

docker run \--name my-postgres -e POSTGRES_PASSWORD=admin -p 5432:5432 -v pgdata:/var/lib/postgresql -d postgres

![](media/image9.png){width="4.876422790901137in" height="0.28684930008748905in"}

3.  **Add some data, stop and remove the container**

![](media/image10.png){width="4.70588145231846in" height="1.9292563429571303in"}

4.  **Run a brand new container with the same volume**

![](media/image11.png){width="4.560967847769029in" height="1.5228860454943132in"}

5.  **Is the data still there?**

Yes, data is still here

**\## Task 3: Bind Mounts**

1.  **Create a folder on your host machine with an index.html file**

2.  **Run an Nginx container and bind mount your folder to the Nginx web directory**

docker run \--name my-nginx -p 8080:80 -v \${pwd}:/usr/share/nginx/html -d nginx

![](media/image12.png){width="5.565914260717411in" height="1.2233989501312337in"}

3.  **Access the page in your browser**

![](media/image13.png){width="3.3752919947506563in" height="0.8000688976377953in"}

4.  **Edit the index.html on your host --- refresh the browser**

![](media/image14.png){width="3.9381014873140856in" height="0.587082239720035in"}

![](media/image15.png){width="3.1877766841644792in" height="0.5708825459317586in"}

5.  **Write in your notes: What is the difference between a named volume and a bind mount?**

> **\| Named Volume \| Bind Mount \|**
>
> **\| \-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-- \| \-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-- \|**
>
> \| Managed by Docker \| Managed by Host \|
>
> \| Stored in Docker internal directory \| Direct mapping to host folder \|
>
> \| Better for production databases \| Great for development \|
>
> \| Harder to access directly \| Easy to edit files \|

**\## Task 4: Docker Networking Basics**

1.  **List all Docker networks on your machine**

docker network ls

![](media/image16.png){width="4.258070866141733in" height="0.9935498687664042in"}

2.  **Inspect the default bridge network**

docker network inspect bridge

![](media/image17.png){width="4.6088188976377955in" height="2.189785651793526in"}

3.  **Run two containers on the default bridge --- can they ping each other by name?**

docker run -dit \--name container1 ubuntu

docker run -dit \--name container2 ubuntu

![](media/image18.png){width="4.983619860017498in" height="2.491809930008749in"}

![](media/image19.png){width="4.5503947944007in" height="0.7709000437445319in"}

It fails

4.  **Run two containers on the default bridge --- can they ping each other by IP?**

> Identify IP address of container 2 using:  
> docker inspect container2
>
> ![](media/image20.png){width="4.92946741032371in" height="1.9774004811898513in"}
>
> Now from container 1 , ping container2 using ip address:  
> ![](media/image21.png){width="4.8492257217847765in" height="2.2551432633420823in"}

**\## Task 5: Custom Networks**

1.  **Create a custom bridge network called my-app-net**

docker network create my-app-net

![](media/image22.png){width="4.703213035870516in" height="0.2904932195975503in"}

2.  **Run two containers on my-app-net**

docker run -dit \--name container1 \--network my-app-net ubuntu

docker run -dit \--name container2 \--network my-app-net Ubuntu

![](media/image23.png){width="5.217496719160105in" height="0.476007217847769in"}

3.  **Can they ping each other by name now?**

![](media/image24.png){width="5.340516185476815in" height="1.4102395013123359in"}

Yes, they can ping each other by name

4.  **Write in your notes: Why does custom networking allow name-based communication but the default bridge doesn\'t?**

- User-defined bridge networks include an embedded DNS server.

- Default bridge does NOT automatically enable name resolution.

**\## Task 6: Put It Together**

1.  **Create a custom network**

docker network create my-full-app-net

2.  **Run a database container (MySQL/Postgres) on that network with a volume for data**

docker volume create mysql-data

docker run \--name mysql-db -e MYSQL_ROOT_PASSWORD=admin -v mysql-data:/var/lib/mysql \--network my-full-app-net -d mysql

![](media/image25.png){width="7.394423665791776in" height="2.5053849518810147in"}

3.  **Run an app container (use any image) on the same network**

docker run -it \--name app-container \--network my-full-app-net ubuntu bash

![](media/image26.png){width="7.413451443569554in" height="2.3687948381452317in"}

4.  **Verify the app container can reach the database by container name**

apt update && apt install mysql-client --y

mysql -h mysql-db -u root -p

![](media/image27.png){width="5.381211723534558in" height="2.3758562992125984in"}

Connection successful.
