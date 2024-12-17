FROM public.ecr.aws/y8l1o1z1/ros2-jazzy:latest

USER root

RUN apt-get update
RUN apt-get install udev -y

# Using robot workspace
WORKDIR /home/user/robot_ws/src

# Clone RPLidar
RUN git clone -b ros2 https://github.com/Slamtec/rplidar_ros.git

WORKDIR /home/user/robot_ws
RUN rosdep install --from-paths src --ignore-src -r -y
RUN . /opt/ros/${ROS_DISTRO}/setup.sh && colcon build

# Setup RPLidar related rules
RUN cp /home/user/robot_ws/src/rplidar_ros/scripts/rplidar.rules  /etc/udev/rules.d/rplidar.rules

# Setup entrypoint
COPY --chown=user:netizen_robotics ./script/entrypoint.sh  /home/user/entrypoint.sh
RUN chmod +x /home/user/entrypoint.sh

# Switch to user
USER user
WORKDIR /home/user
ENTRYPOINT ["/home/user/entrypoint.sh"]