FROM osrf/ros:noetic-desktop
RUN rm /etc/apt/sources.list.d/ros1-latest.list \
  && rm /usr/share/keyrings/ros1-latest-archive-keyring.gpg

RUN apt-get update \
  && apt-get install -y ca-certificates curl
  
  RUN export ROS_APT_SOURCE_VERSION=$(curl -s https://api.github.com/repos/ros-infrastructure/ros-apt-source/releases/latest | grep -F "tag_name" | awk -F\" '{print $4}') ;\
  curl -L -s -o /tmp/ros-apt-source.deb "https://github.com/ros-infrastructure/ros-apt-source/releases/download/${ROS_APT_SOURCE_VERSION}/ros-apt-source_${ROS_APT_SOURCE_VERSION}.$(. /etc/os-release && echo $VERSION_CODENAME)_all.deb" \
  && apt-get update \
  && apt-get install /tmp/ros-apt-source.deb \
  && rm -f /tmp/ros-apt-source.deb
  
COPY utils/transform_rosinstall.py /
  
ENV DEBIAN_FRONTEND="noninteractive"
RUN apt update \
&& apt install -y python3-catkin-tools git python3-rosdep python3-vcstool