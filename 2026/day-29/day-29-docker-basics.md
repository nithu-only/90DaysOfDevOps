**\### Day 29 -- Introduction to Docker**

**\## Task 1: What is Docker?**

1.  **What is a Container?**

> A \*\*container\*\* is a lightweight, portable package that includes:
>
> \- application code
>
> \- runtime
>
> \- libraries
>
> \- dependencies
>
> \- system tools
>
> Containers ensure software runs the same everywhere.
>
> **Why Do We Need Containers?**
>
> Before containers:
>
> \- apps worked on one machine but failed on another
>
> \- dependency conflicts were common
>
> \- environment setup was time-consuming
>
> Containers solve this by packaging everything together.

2.  **Containers vs Virtual Machines**

| **Feature**      | **Containers**       | **Virtual Machines**     |
|------------------|----------------------|--------------------------|
| **OS**           | Share host OS        | Each VM has full OS      |
| **Size**         | MBs                  | GBs                      |
| **Startup Time** | Seconds              | Minutes                  |
| **Performance**  | Near native          | Overhead from hypervisor |
| **Isolation**    | Process-level        | Full OS isolation        |
| **Use Case**     | Microservices, CI/CD | Running different OS     |

> Containers are lightweight and fast.
>
> VMs provide stronger isolation.

3.  **Docker Architecture**

> Docker uses a \*\*client-server architecture\*\*:
>
> \*\*Docker Client\*\*
>
> \- Command line interface (\`docker run\`, \`docker build\`)
>
> \- Sends requests to the daemon
>
> \*\*Docker Daemon\*\*
>
> \- Builds images
>
> \- Runs containers
>
> \- Manages networks & volumes
>
> \*\*Docker Images\*\*
>
> \- Read-only templates used to create containers
>
> \*\*Docker Containers\*\*
>
> \- Running instances of images
>
> \*\*Docker Registry (Docker Hub)\*\*
>
> \- Stores and distributes images

4.  **Architecture in Simple Words**

> When you run:
>
> docker run nginx
>
> ✔ Docker client sends request
>
> ✔ Docker daemon checks local images
>
> ✔ If not found → pulls from Docker Hub
>
> ✔ Creates container from image
>
> ✔ Container starts running

**\## Task 2: Install Docker**

1.  **Verify the installation:  
    **![](media/image1.png){width="4.008681102362205in" height="2.0210083114610673in"}

2.  **Run the hello-world container**

> ![](media/image2.png){width="3.696153762029746in" height="2.0418438320209975in"}
>
> **What happened?  
> **Docker contacted Docker Hub
>
> Downloaded hello-world image
>
> Created container
>
> Ran it and printed a message**  
> **

**\## Task 3: Run Real Containers**

1.  **Run an Nginx container and access it in your browser**

> docker run -d -p 8080:80 nginx
>
> ![](media/image3.png){width="2.5418864829396326in" height="1.0000863954505688in"}
>
> ![](media/image4.png){width="5.179003718285214in" height="1.6706463254593176in"}

2.  **Run an Ubuntu container in interactive mode --- explore it like a mini Linux machine**

> docker run -it ubuntu bash
>
> ![](media/image5.png){width="3.1461056430446193in" height="1.5209656605424322in"}

3.  **List all running containers**

> docker ps
>
> ![](media/image6.png){width="4.042016622922135in" height="0.9167465004374453in"}

4.  **List all containers (including stopped ones)**

> ![](media/image7.png){width="4.071186570428696in" height="1.0209219160104988in"}

5.  **Stop and remove a container**

> ![](media/image8.png){width="4.029515529308837in" height="1.654309930008749in"}

**\## Task 4: Explore**

1.  **Run a container in detached mode --- what\'s different?**

> Docker run --d nginx
>
> ![](media/image9.png){width="2.029342738407699in" height="0.3958672353455818in"}

2.  **Give a container a custom name**

> docker run -d \--name my-nginx nginx
>
> ![](media/image10.png){width="2.1668547681539807in" height="0.3333617672790901in"}

3.  **Map a port from the container to your host**

> docker run -d -p 9090:80 nginx
>
> ![](media/image11.png){width="2.3210345581802274in" height="0.3416961942257218in"}
>
> ![](media/image12.png){width="4.325709755030621in" height="1.4953062117235345in"}

4.  **Check logs of a running container**

> docker logs my-nginx
>
> ![](media/image13.png){width="3.104435695538058in" height="1.6251410761154856in"}

5.  **Run a command inside a running container**

> docker exec -it my-nginx bash
>
> ![](media/image14.png){width="1.9585028433945757in" height="0.4583727034120735in"}
