# Python script for deploying a multi-service application
# MongoDB, swarm visualiser and 2 instances of a prime number check
# usage: python task-02-deploy.py  

# loading modules
import docker

# setting up client 
client = docker.from_env()

# initialising the swarm 
client.swarm.init()

# specifying service options
es_prime = docker.types.EndpointSpec(ports={8080:8080})
sm_prime = docker.types.ServiceMode('replicated',2)
es_viz = docker.types.EndpointSpec(ports={8081:8080})
mount_viz = ["/var/run/docker.sock:/var/run/docker.sock"]
es_mongo = docker.types.EndpointSpec(ports={3306:27017})
mount_mongo = ["/Users/jackwaudby/Desktop/myMongo:/data/db"]
manager = ["node.role == manager"]


# creating the services 
client.services.create('nclcloudcomputing/javabenchmarkapp',name='prime',endpoint_spec=es_prime,mode=sm_prime)
client.services.create('dockersamples/visualizer',name='viz',endpoint_spec=es_viz,constraints=manager,mounts=mount_viz)
client.services.create('mongo',name='mongo',endpoint_spec=es_mongo,constraints=manager,mounts=mount_mongo)