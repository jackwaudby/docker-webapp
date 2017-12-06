# This python script pull raw data from cAdvisor using the REST API for each active container.
# It then stores the JSON files in a mongoDB database, with a collection for each container. 

# usage: python task-05-pipeline.py database 
# returns: prints the collection names within the database 

# loading modules
import docker
import requests
import json
import pymongo
import sys
from pymongo import MongoClient

# setting up client 
client = docker.from_env()

# connecting to mongoDB 
mclient = MongoClient('localhost', 3306)

# defining database 
number = sys.argv[1]
name = 'loadgen' + number
db = mclient[name] 

# for each container in the web application
for item in client.containers.list():
    
    # get id and name 
    cont_id = item.id 
    cont_name = item.name
    print cont_name
    # cadvisor url
    url = 'http://localhost:70/api/v1.2/docker/' + cont_id
    # pull raw data 
    res = requests.get(url).json()
    parsed = res
    # creating collection   
    records = db[cont_name]
    # unique container search parameter 
    search = '/docker/' + cont_id
    # storing each stats record in container's collection in the database
    for record in parsed[search]['stats']:
        records.insert(record)




   
