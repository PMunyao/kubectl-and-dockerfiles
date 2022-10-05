# a docker image for training a reinforcement learning model using python, pytorch, gym and godot as the learning environment

FROM ubuntu:16.04

# install python3 and python3-pip
RUN apt-get update && \
    apt-get -y upgrade && \
    apt-get install -y python3 python3-pip

# install gym
RUN pip3 install gym

# install pytorch
RUN pip3 install torch torchvision

# install godot-python
RUN apt-get install -y libboost-all-dev libenet-dev libgl1-mesa-dev libglew-dev libgstreamer-plugins-base1.0-dev libgstreamer1.0-dev libjpeg-dev libogg-dev libpng-dev libssl-dev libtheora-dev libvorbis-dev libx11-dev libxext-dev libxfixes-dev libxrandr-dev pkg-config scons unzip zip

WORKDIR /godot-python
RUN git clone https://github.com/godotengine/godot-python.git .
RUN scons platform=x11 -j4

# install godot
RUN apt-get install -y wget
RUN wget https://downloads.tuxfamily.org/godotengine/3.1.1/Godot_v3.1.1-stable_x11.64.zip
RUN unzip Godot_v3.1.1-stable_x11.64.zip

# install tensorboard
RUN pip3 install tensorboard

# install gym-godot
RUN git clone https://github.com/godotengine/godot-gym.git
WORKDIR /godot-gym
RUN python3 setup.py install
WORKDIR /godot-python

# run the engine along with python and libraries to create an instance of cartpole environment
CMD ["python3", "-c", "import gym; import gym_godot; import pybullet_envs; env = gym.make('CartPole-v0'); env.reset(); env.render(); env.step(env.action_space.sample()); env.close();"]
