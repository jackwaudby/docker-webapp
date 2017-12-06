# Python script for leaving a swarm
# usage: python leave-swarm.py  

# loading modules
import docker

# setting up client 
client = docker.from_env()

# initialising the swarm 
client.swarm.leave(force=True)