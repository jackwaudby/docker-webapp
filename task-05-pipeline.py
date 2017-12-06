# PIPELINE 
# PULLS RAW DATA -> CREATES JSON FILE -> UPLOADS DATA TO MONGODB 

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
#db = mclient.project

number = sys.argv[1]
name = 'loadgen' + number
# defining database 
db = mclient[name] 

# for each container
for item in client.containers.list():
    
    # get id and name 
    cont_id = item.id 
    cont_name = item.name
    print cont_name
    # cadvisor url
    url = 'http://localhost:70/api/v1.2/docker/' + cont_id
    # pull raw data 
    res = requests.get(url).json()
    # create suitable filename 
    #filename = 'usage-recordings/' + cont_id + '.json'
    # write out data to JSON file
    #with open(filename, 'w') as f:
     #   json.dump(res, f)
        
    # creating collection   
    records = db[cont_name]
    # access data
    #page = open(filename,'r')
    # parse data in
    #parsed = json.loads(page.read())
    parsed = res
    # unique search parameter
    search = '/docker/' + cont_id
    # storing each stats record in mongo db
    for record in parsed[search]['stats']:
        records.insert(record)




   
