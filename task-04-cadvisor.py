# Python script for pulling and running a container 
# usage: python task-04-cadvisor.py  

# loading modules 
import docker

# creating connection to docker daemon 
client = docker.from_env()

# running container in detached mode
container = client.containers.run('google/cadvisor',detach=True,ports={'8080/tcp': ('127.0.0.1', 8090)},name='cadvisor',remove=True,volumes={'/': {'bind': '/rootfs', 'mode': 'ro'},'/var/run': {'bind': '/var/run', 'mode': 'rw'},'/sys': {'bind': '/sys', 'mode': 'ro'},'/var/lib/docker/': {'bind': '/var/lib/docker', 'mode': 'ro'}})

# print container id to terminal
print container.id