**\### Day 31 -- Dockerfile: Build Your Own Images**

**\##Task 1: Docker Images**

1.  **Create a folder called my-first-image**

2.  **Inside it, create a Dockerfile that:**

- **Uses ubuntu as the base image**

- **Installs curl**

- **Sets a default command to print \"Hello from my custom image!\"**

> ![](media/image1.png){width="5.698572834645669in" height="1.5587839020122485in"}

3.  **Build the image and tag it my-ubuntu:v1**

docker build -t my-ubuntu:v1 .

![](media/image2.png){width="5.312173009623797in" height="1.859928915135608in"}

4.  **Run a container from your image**

docker run my-ubuntu:v1

![](media/image3.png){width="8.188209755030622in" height="0.5417136920384952in"}

**\## Task 2: Dockerfile Instructions**

**Create a new Dockerfile that uses all of these instructions:**

- **FROM --- base image**

- **RUN --- execute commands during build**

- **COPY --- copy files from host to image**

- **WORKDIR --- set working directory**

- **EXPOSE --- document the port**

- **CMD --- default command**

**Build and run it. Understand what each line does.**

![](media/image4.png){width="4.212156605424322in" height="3.2492191601049867in"}

**What each instruction Does:**

**\| Instruction \| Purpose \|**

> **\| \-\-\-\-\-\-\-\-\-\-- \| \-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-- \|**
>
> \| FROM \| Defines base image \|
>
> \| RUN \| Executes commands during build \|
>
> \| COPY \| Copies files from host → container \|
>
> \| WORKDIR \| Sets working directory \|
>
> \| EXPOSE \| Documents container port \|
>
> \| CMD \| Default runtime command \|

**Building the image**

docker build -t docker-demo:v1 .

**Run the container**

docker run docker-demo:v1

**\## Task 3: CMD vs ENTRYPOINT**

1.  **Create an image with CMD \[\"echo\", \"hello\"\] --- run it, then run it with a custom command. What happens?**

![](media/image5.png){width="3.133604549431321in" height="0.9167465004374453in"}

docker build -t cmd-image .

docker run cmd-image

![](media/image6.png){width="5.8154604111986in" height="1.6945253718285214in"}

docker run cmd-image ls

![](media/image7.png){width="5.6078182414698166in" height="1.9892607174103236in"}

CMD gets overridden. ls runs instead.

2.  **Create an image with ENTRYPOINT \[\"echo\"\] --- run it, then run it with additional arguments. What happens?**

![](media/image8.png){width="3.271116579177603in" height="0.9459153543307086in"}

docker build -t entrypoint-image .

docker run entrypoint-image hello

![](media/image9.png){width="5.68169728783902in" height="1.81169728783902in"}

docker run entrypoint-image world

![](media/image10.png){width="6.193045713035871in" height="0.3200831146106737in"}

ENTRYPOINT does NOT get overridden.

Arguments are appended.

3.  **Write in your notes: When would you use CMD vs ENTRYPOINT?**

**\| Use Case \| Use \|**

**\| \-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-- \| \-\-\-\-\-\-\-\-\-- \|**

\| Default command that users can override \| CMD \|

\| Force container to behave like an executable \| ENTRYPOINT \|

\| CLI tools \| ENTRYPOINT \|

\| Flexible dev images \| CMD \|

**\## Task 4: Build a Simple Web App Image**

1.  **Create a small static HTML file (index.html) with any content**

![](media/image11.png){width="4.58373031496063in" height="2.1335181539807526in"}

2.  **Write a Dockerfile that:**

- **Uses nginx:alpine as base**

- **Copies your index.html to the Nginx web directory**

> ![](media/image12.png){width="5.0004330708661415in" height="1.5001301399825022in"}

3.  **Build and tag it my-website:v1**

docker build -t my-website:v1 .

4.  **Run it with port mapping and access it in your browser**

docker run -p 8080:80 my-website:v1

![](media/image13.png){width="5.314853455818023in" height="1.4911406386701662in"}

![](media/image14.png){width="2.7377373140857393in" height="0.6667246281714786in"}

**\## Task 5: .dockerignore**

1.  **Create a .dockerignore file in one of your project folders**

2.  **Add entries for: node_modules, .git, \*.md, .env**

![](media/image15.png){width="5.167784339457568in" height="2.5541272965879265in"}

3.  **Build the image --- verify that ignored files are not included**

![](media/image16.png){width="5.10582239720035in" height="1.9885837707786527in"}

**\## Task 6: Build Optimization**

1.  **Build an image, then change one line and rebuild --- notice how Docker uses cache**

Docker reuses unchanged layers.

2.  **Reorder your Dockerfile so that frequently changing lines come last**

3.  **Write in your notes: Why does layer order matter for build speed?**

Docker builds images layer by layer.

If a layer changes:

- All layers after it rebuild.

Best Practice:

Put:

- Dependencies first

- Frequently changing code last

> ![](media/image17.png){width="3.833665791776028in" height="2.383540026246719in"}
>
> If app.js changes → only last layer rebuilds
>
> If package.json changes → npm install runs again
