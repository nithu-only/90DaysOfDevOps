**\### Day 33 -- Docker Compose: Multi-Container Basics**

**\## Task 1: Install & Verify**

1.  **Check if Docker Compose is available on your machine**

docker compose version

2.  **Verify the version**

> ![](media/image1.png){width="7.1464523184601925in" height="0.5500481189851268in"}

**\##Task 2: Your First Compose File**

1.  **Create a folder compose-basics**

2.  **Write a docker-compose.yml that runs a single Nginx container with port mapping**

![](media/image2.png){width="4.6962401574803145in" height="2.354371172353456in"}

3.  **Start it with docker compose up**

docker compose up

![](media/image3.png){width="10.247575459317586in" height="3.962655293088364in"}

4.  **Access it in your browser**

![](media/image4.png){width="5.042104111986002in" height="1.7501520122484688in"}

5.  **Stop it with docker compose down**

docker compose down  
![](media/image5.png){width="9.857503280839895in" height="1.429430227471566in"}

**\##Task 3: Two-Container Setup**

> **Write a docker-compose.yml that runs:**

- **A WordPress container**

- **A MySQL container**

> **They should:**

- **Be on the same network (Compose does this automatically)**

- **MySQL should have a named volume for data persistence**

- **WordPress should connect to MySQL using the service name**

> **Start it, access WordPress in your browser, and set it up.**

**Verify: Stop and restart with docker compose down and docker compose up --- is your WordPress data still there?**

![](media/image6.png){width="7.417309711286089in" height="6.833926071741033in"}

![](media/image7.png){width="5.8838429571303585in" height="3.341956474190726in"}

docker compose down

docker compose up --d  
After stopping and restarting docker, data is still there.

**\## Task 4: Compose Commands**

**Practice and document these:**

1.  **Start services in detached mode**

docker compose up -d

2.  **View running services**

docker compose ps

3.  **View logs of all services**

docker compose logs -f

4.  **View logs of a specific service**

docker compose logs -f wordpress

5.  **Stop services without removing**

docker compose down

6.  **Remove everything (containers, networks)**

docker compose down -v

7.  **Rebuild images if you make a change**

docker compose up \--build
