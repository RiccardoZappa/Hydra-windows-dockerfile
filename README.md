Docker file needed to set up the hydra enviroment on windows. There is also a python script to change the relative addresses of github repository of the rosintall file of hydra.
I inserted a hydra copy in this repository and below there is the explanation of how to build the docker image and run it with the hydra project mounted, so that you can work and modify the hydra project and build it even on windows computers.

# Hydra Docker Setup

This guide provides the necessary steps to build the Docker image and run the container for the Hydra project.

---

### 1. Build the Docker Image

First, you need to build the Docker image from the `Dockerfile` in your project's root directory. 
This command will package all the necessary dependencies and configurations.

**Command:**
docker image build -t hydra_ros_image .

- **`docker image build`**: The command to build an image.
- **`-t hydra_ros_image`**: This tags (-t) the image with the name `hydra_ros_image` for easy reference.
- **`.`**: Specifies that the build context (the `Dockerfile` and related files) is in the current directory.

---

### 2. Platform-Specific Setup (for GUI Applications)

To run graphical applications like RViz, you must configure your host machine to allow the container to access your display. The steps are different for Linux and Windows.

#### For Windows Users:
You need to install and run an X Server. We recommend **VcXsrv**.

1.  **Download & Install:** Get VcXsrv from [SourceForge](https://sourceforge.net/projects/vcxsrv/).
2.  **Launch VcXsrv:** Find "XLaunch" in your Start Menu.
3.  **Configure Display Settings:**
    * Choose **"Multiple windows"** and set the "Display number" to **0**.
    * Click Next.
4.  **Configure Client Startup:**
    * Choose **"Start no client"**.
    * Click Next.
5.  **Configure Extra Settings:**
    * **IMPORTANT:** Check the box for **"Disable access control"**. This is the Windows equivalent of the `xhost +` command.
    * Click Next, then Finish to start the server. You should see a VcXsrv icon in your system tray.

#### For Linux Users:
Open a terminal on your host machine and run the following command to allow clients to connect from any host.

**Command:**
xhost +

---


### 3. Run the Docker Container

Once the image is built, you can run it as an interactive container. This command also mounts your 
local `Hydra` project directory into the container's workspace.

The command to run the container is slightly different for each platform.

#### For Windows Users (in PowerShell):
This command connects to the VcXsrv display you just started.

**Command:**
docker run -it --rm `
  -e DISPLAY=host.docker.internal:0.0 `
  -v "${pwd}/Hydra:/catkin_ws/src/hydra" `
  --name hydra_container `
  hydra_ros_image bash

* **`docker run`**: The command to create and start a new container from an image.
* **`-it`**: Runs the container in interactive mode (`-i`) and allocates a pseudo-TTY (`-t`).
* **`--rm`**: Automatically removes the container when you exit, keeping things clean.
* **`-e DISPLAY=host.docker.internal:0.0`**: Sets the `DISPLAY` environment variable to point to your host PC's VcXsrv instance, allowing GUIs to be displayed.
* **`-v "${pwd}/Hydra:/catkin_ws/src/hydra"`**: Mounts (`-v`) your local directory (`${pwd}\Hydra`) into the container. This lets you edit code locally and see changes instantly inside the container.
* **`--name hydra_container`**: Assigns a memorable name to the container, making it easy to open new terminals into it.
* **`hydra_ros_image`**: The name of the image to run.
* **`bash`**: The command to execute inside the container when it starts.

#### For Linux Users:
**Command:**
docker run -it --rm \
  --env="DISPLAY" \
  --volume="/tmp/.X11-unix:/tmp/.X11-unix:rw" \
  -v "${PWD}/Hydra:/catkin_ws/src/hydra" \
  --name hydra_container \
  hydra_ros_image bash
  
* **`docker run`**: The command to create and start a new container from an image.
* **`-it`**: Runs the container in interactive mode (`-i`) and allocates a pseudo-TTY (`-t`).
* **`--rm`**: Automatically removes the container when you exit.
* **`--env="DISPLAY"`**: Shares your host machine's `DISPLAY` environment variable with the container.
* **`--volume="/tmp/.X11-unix..."`**: Shares the X11 socket from the host to the container, which is required for GUIs to work.
* **`-v "${PWD}/Hydra:/catkin_ws/src/hydra"`**: Mounts (`-v`) your local directory (`${PWD}/Hydra`) into the container. This lets you edit code locally and see changes instantly inside the container.
* **`--name hydra_container`**: Assigns a memorable name to the container, making it easy to open new terminals into it.
* **`hydra_ros_image`**: The name of the image to run.
* **`bash`**: The command to execute inside the container when it starts.

### 4. Set Up the ROS Environment (Every New Terminal)

After the workspace is built, you must `source` the setup file. **You must do this every time you open a new terminal in the container.** This tells ROS where to find your compiled packages.

**Command:**
source /catkin_ws/devel/setup.bash


### 5. Build and launch hydra

After you run the container, see the hydra guide to build the project in the container at [Hydra](https://github.com/MIT-SPARK/Hydra).
