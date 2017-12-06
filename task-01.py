# Python script for pulling and running a container 
# usage: python task-01.py  

# loading modules 
import docker

# creating connection to docker daemon 
client = docker.from_env()

# running container in detached mode
container = client.containers.run('nclcloudcomputing/javabenchmarkapp',detach=True,ports={8080:8080},name='primecheck',remove=True)

# print container id to terminal
print container.id