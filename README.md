# Task 1: Pull and run web app

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
python task-02-deploy.py 
python task-02-display.py
```
```{r, engine='bash'}
open http://localhost:8081 # Check they are running 
open http://localhost:8080/primecheck
open http://localhost:3306
```
```python
python task-02-leave.py
```

# Task 3: Load generator 
```{r, engine='bash'}
sh ./task-03-load-generator.sh http://localhost:8080/primecheck 4 2 4
```

# Task 4: Add a docker monitoring tool

### - CLI
Run when stack is deployed
```{r, engine='bash'}
docker run --volume=/:/rootfs:ro --volume=/var/run:/var/run:rw --volume=/sys:/sys:ro --volume=/var/lib/docker/:/var/lib/docker:ro --publish=70:8080 --detach=true --rm --name cadvisor google/cadvisor:latest --storage_duration=2m0s --allow_dynamic_housekeeping=false --housekeeping_interval=1s
open http://localhost:70
sh ./task-03-load-generator.sh http://localhost:80/primecheck 3 5 5 # run the load gen and observe changes 
```

# Task 5: Insert benchmark into mongoDB
Open terminals side by side
### Terminal 1  
```{r, engine='bash'}
docker exec -it 6d8e17481bed mongo # access mongo interactive shell
show dbs # show databases
use project # switch to project database
show collections # show collections 
```

### Terminal 2 
```{r, engine='bash'}
sh ./task-05-master.sh http://localhost:8080/primecheck 150 10 1 four # placing load on web app and storing data 
```



 