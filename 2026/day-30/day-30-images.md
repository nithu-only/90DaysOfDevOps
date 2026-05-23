**\### Day 30 -- Docker Images & Container Lifecycle  
  
**

**\##Task 1: Docker Images**

1.  **Pull the nginx, ubuntu, and alpine images from Docker Hub  
    **docker pull nginx

![](media/image1.png){width="6.202115048118985in" height="2.660298556430446in"}

docker pull Ubuntu

![](media/image2.png){width="6.184219160104987in" height="1.7021708223972003in"}

docker pull alpine  
![](media/image3.png){width="6.238900918635171in" height="1.716489501312336in"}

2.  **List all images on your machine --- note the sizes**

docker images

![](media/image4.png){width="6.318459098862642in" height="2.337465004374453in"}

3.  **Compare ubuntu vs alpine --- why is one much smaller?**

- Alpine is built for minimalism

- Uses musl libc instead of glibc

- No unnecessary packages

- Designed for containers

- Ubuntu includes:

- Full package ecosystem

- More libraries

- Larger base filesystem

- Alpine is ideal for production containers when you need smaller attack surface and faster pulls.

4.  **Inspect an image --- what information can you see?**

docker inspect nginx

![](media/image5.png){width="7.2578226159230095in" height="3.3306452318460193in"}

![](media/image6.png){width="7.33659230096238in" height="2.819828302712161in"}

![](media/image7.png){width="7.306208442694663in" height="2.416989282589676in"}

Information available:

- Image ID

- Created date

- OS/Architecture

- Environment variables

- Entrypoint

- Layers

- Metadata

5.  **Remove an image you no longer need**

docker rmi Ubuntu:latest

![](media/image8.png){width="7.392869641294838in" height="1.7810739282589676in"}

**\##Task 2: Image Layers**

1.  **Run docker image history nginx --- what do you see?**

docker image history nginx

![](media/image9.png){width="6.964596456692913in" height="2.8579079177602797in"}

2.  **Each line is a layer. Note how some layers show sizes and some show 0B**

3.  **What are layers and why does Docker use them?**

Docker images are built in layers.

Each:

- RUN

- COPY

- ADD

- ENV

- CMD

Creates a new layer.

Why Docker Uses Layers

- Faster builds (layer caching)

- Reuse unchanged layers

- Efficient storage

- Faster pulls

If one layer changes, only that layer rebuilds.

**\## Task 3: Container Lifecycle**

1.  **Create a container (without starting it)**

docker create \--name mycontainer Ubuntu

![](media/image10.png){width="5.5212806211723535in" height="1.1637674978127734in"}

2.  **Start the container**

docker start mycontainer

![](media/image11.png){width="3.8003291776027996in" height="0.6667246281714786in"}

3.  **Pause it and check status**

docker pause mycontainer

4.  **Unpause it**

docker unpause mycontainer

5.  **Stop it**

docker stop mycontainer

![](media/image12.png){width="2.7819663167104114in" height="0.2942465004374453in"}

6.  **Restart it**

docker restart mycontainer

![](media/image13.png){width="3.7001060804899386in" height="0.36046916010498686in"}

7.  **Kill it**

docker kill mycontainer

8.  **Remove it**

docker rm mycontainer

**\## Task 4: Working with Running Containers**

1.  **Run an Nginx container in detached mode**

docker run -d -p 8080:80 \--name mynginx nginx

![](media/image14.png){width="4.277279090113736in" height="0.33717300962379704in"}

![](media/image15.png){width="5.5138484251968505in" height="1.610353237095363in"}

2.  **View its logs**

docker logs mynginx

![](media/image16.png){width="6.247389545056868in" height="2.900573053368329in"}

3.  **View real-time logs (follow mode)**

docker logs -f mynginx

![](media/image17.png){width="6.107423447069117in" height="2.8849431321084866in"}

4.  **Exec into the container and look around the filesystem**

docker exec -it mynginx /bin/bash

5.  **Run a single command inside the container without entering it**

![](media/image18.png){width="5.753418635170604in" height="1.4370122484689414in"}

6.  **Inspect the container --- find its IP address, port mappings, and mounts**

> docker inspect mynginx
>
> ![](media/image19.png){width="6.0687160979877515in" height="2.5391590113735782in"}

**\## Task 5: Cleanup**

1.  **Stop all running containers in one command**

docker stop \$(docker ps -q)

![](media/image20.png){width="4.112856517935258in" height="0.6250546806649169in"}

2.  **Remove all stopped containers in one command**

docker rm \$(docker ps -aq)

![](media/image21.png){width="3.82116469816273in" height="1.5709689413823271in"}

3.  **Remove unused images**

docker image prune --a

![](media/image22.png){width="8.386590113735783in" height="2.8226509186351705in"}

4.  **Check how much disk space Docker is using**

docker system df

![](media/image23.png){width="5.375465879265092in" height="1.258442694663167in"}
