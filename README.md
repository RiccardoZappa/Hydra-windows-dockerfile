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

### 2. Run the Docker Container

Once the image is built, you can run it as an interactive container. This command also mounts your 
local `Hydra` project directory into the container's workspace.

**Command:**
docker run -it -v "${PWD}/Hydra:/catkin_ws/src/hydra" hydra_ros_image bash

- **`docker run`**: The command to create and start a new container from an image.
- **`-it`**: Runs the container in interactive mode (`-i`) and allocates a pseudo-TTY (`-t`), allowing you to use the `bash` shell inside the container.
- **`-v "${PWD}/Hydra:/catkin_ws/src/hydra"`**: This mounts (`-v` for volume) your local directory (`${PWD}/Hydra`) to a directory inside the container (`/catkin_ws/src/hydra`). This is crucial as it allows you to edit code on your local machine and see the changes reflected inside the container instantly.
- **`hydra_ros_image`**: The name of the image to run.
- **`bash`**: The command to execute inside the container when it starts, in this case, launching the Bash shell.

### 3. Build hydra

After you run the container, see the hydra guide to build the project in the container at [Hydra](https://github.com/MIT-SPARK/Hydra).

### 4. Set Up the ROS Environment (Every New Terminal)

After the workspace is built, you must `source` the setup file. **You must do this every time you open a new terminal in the container.** This tells ROS where to find your compiled packages.

**Command:**
source /catkin_ws/devel/setup.bash
