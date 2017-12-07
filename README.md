# Task 1: Pull and run web app
Pulling and running a docker container using the Docker CLI and the Python SDK. All commands should be run in the command line. 

### - CLI 
```{r, engine='bash'}
docker run -p 8080:8080 -d --name primecheck --rm nclcloudcomputing/javabenchmarkapp # Pull and run the web app
open http://localhost:8080/primecheck # Check the app is working 
```
### - Python SDK 
```python
python task-01.py # Pull and run the web app
```

# Task 2: deploy multi-service app
Deploying a multi-service application with 2 replications of a prime number check, a MongoDB database and a swarm visualiser
### - CLI 
```{r, engine='bash'}
docker swarm init # Initialse swarm
docker stack deploy -c docker-compose.yml cloudproject # Deploy services
docker service ls # Show services 
docker container ls -a # Show containers 
open http://localhost:88 # Check they are running 
open http://localhost:80/primecheck
open http://localhost:3306
docker stack rm cloudproject # Remove stack 
docker swarm leave --force # Leave swarm 
```
### - Python SDK 
```python
python task-02-deploy.py # deploy app
python task-02-display.py # displaying services and container ids
```
```{r, engine='bash'}
open http://localhost:8081 # Check they are running 
open http://localhost:8080/primecheck
open http://localhost:3306
```
```python
python task-02-leave.py # leave swarm 
```

# Task 3: Load generator 
This calls the prime number check URL placing a load on the web application. Allowing system benchmarking. 
```{r, engine='bash'}
sh ./task-03-load-generator.sh http://localhost:8080/primecheck 4 2 4
```

# Task 4: Add a Docker monitoring tool
This section adds a Docker monitoring tool, cAdvisor. 
### - CLI
Run when stack is deployed
```{r, engine='bash'}
docker run --volume=/:/rootfs:ro --volume=/var/run:/var/run:rw --volume=/sys:/sys:ro --volume=/var/lib/docker/:/var/lib/docker:ro --publish=70:8080 --detach=true --rm --name cadvisor google/cadvisor:latest --storage_duration=2m0s --allow_dynamic_housekeeping=false --housekeeping_interval=1s
```
### - Python SDK
```python
python task-04-cadvisor.py # run cadvisor  
```
Check it is working 
```{r, engine='bash'}
open http://localhost:70
sh ./task-03-load-generator.sh http://localhost:80/primecheck 3 5 5 # run the load gen and observe changes 
```

# Task 5: Insert benchmark into mongoDB
Open terminals side by side. Note, the mongoDB has been mounted on the host machine working directory
### Terminal 1  
Here you can whats going on in the database
```{r, engine='bash'}
docker exec -it 6d8e17481bed mongo # access mongo interactive shell
show dbs # show databases
use project # switch to project database
show collections # show collections 
```
### Terminal 2 
This places the load and stores the results 
```{r, engine='bash'}
sh ./task-05-master.sh http://localhost:8080/primecheck 150 10 1 four # placing load on web app and storing data 
```

## Task 6: Using R to recreate plot
Running this script recreates plot, memory or cpu usage, in cAdvisor using the data stored in the mongoDB
Prerequisites:
- `graphics/` folder in working directory, graphics are saved here.
- `collection.csv` created during Task 4
- `databases-names.csv` created during Task 4
```{r, engine='bash'}
Rscript R/graphs.R <absolute path to R script directory> <metric> # format
Rscript R/graphs.R /Users/jackwaudby/Library/'Mobile Documents'/com~apple~CloudDocs/csc8110/docker/R memory #example
```

 