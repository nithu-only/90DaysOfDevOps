**\### Day 35 -- Multi-Stage Builds & Docker Hub**

**\## Task 1: Build Your Own App Stack**

1.  **Write a simple Go, Java, or Node.js app (even a \"Hello World\" is fine)**

![](media/image1.png){width="7.583333333333333in" height="1.6041666666666667in"}

![](media/image2.png){width="4.229166666666667in" height="2.1979166666666665in"}

2.  **Create a Dockerfile that builds and runs it in a single stage**

![](media/image3.png){width="4.71875in" height="3.2291666666666665in"}

3.  **Build the image and check its size**

![](media/image4.png){width="7.433977471566054in" height="2.3001990376202976in"}

**Note down the size --- you\'ll compare it later.** (Size is 1.09 GB)

**\##Task 2: Multi-Stage Build**

4.  **Rewrite the Dockerfile using multi-stage build:**

**Stage 1: Build the app (install dependencies, compile)**

**Stage 2: Copy only the built artifact into a minimal base image (alpine, distroless, or scratch)**

![](media/image5.png){width="6.582233158355206in" height="4.741563867016623in"}

5.  **Build the image and check its size again**

![](media/image6.png){width="6.508897637795275in" height="3.0710990813648293in"}

6.  **Compare the two sizes**

Single stage it is 1.09 GB

Multistage it is 127 MB

**Write in your notes: Why is the multi-stage image so much smaller?**

- Builder tools don't go to final image

- No extra compilers

- Minimal base image (alpine)

- Fewer layers

- Only required runtime files copied

**\##Task 3: Push to Docker Hub**

1.  **Create a free account on Docker Hub (if you don\'t have one)**

2.  **Log in from your terminal**

docker login

3.  **Tag your image properly: yourusername/image-name:tag**

docker tag day35-multistage axata/day35-app:v1

4.  **Push it to Docker Hub**

docker push axata/day35-app:v1

![](media/image7.png){width="8.244286964129484in" height="2.05121062992126in"}

5.  **Pull it on a different machine (or after removing locally) to verify**

docker rmi axata/day35-app:v1

docker pull axata/day35-app:v1

docker run axata/day35-app:v1

![](media/image8.png){width="8.917439851268592in" height="3.0002602799650044in"}

**\## Task 4: Docker Hub Repository**

1.  **Go to Docker Hub and check your pushed image**

> ![](media/image9.png){width="7.410668197725284in" height="2.8430205599300087in"}

2.  **Add a description to the repository**

![](media/image10.png){width="6.942331583552056in" height="3.2553423009623796in"}

3.  **Explore the tags tab --- understand how versioning works**

**\| Tag \| Meaning \|**

**\| \-\-\-\-\-- \| \-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-- \|**

\| v1 \| Stable release \|

\| v2 \| New version \|

\| latest \| Default if no tag specified \|

4.  **Pull a specific tag vs latest --- what happens?**

docker pull axata/day35-app:v1

docker pull axatadarji/day35-app

If no tag specified → Docker pulls latest.  
  
**\## Task 5: Image Best Practices**

1.  **Use a minimal base image (alpine vs ubuntu --- compare sizes)**

2.  **Don\'t run as root --- add a non-root USER in your Dockerfile**

![](media/image11.png){width="7.531829615048119in" height="3.937551399825022in"}

3.  **Combine RUN commands to reduce layers**

RUN apt update && apt install -y curl

4.  **Use specific tags for base images (not latest)**

FROM node:18.18-alpine3.18

![](media/image12.png){width="6.438057742782152in" height="3.550307305336833in"}
