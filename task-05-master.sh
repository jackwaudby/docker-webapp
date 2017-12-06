# This shell script calls the load generator and then input the data into the mongo db 
# usage sh ./task-05-master.sh 

#!/bin/bash

sh ./task-03-load-generator.sh $1 $2 $3 $4 $5
#sh ./task-03-load-generator.sh http://localhost:8080/primecheck 10 10 5

sleep 10s

a='loadgen'
echo $a$5 >> database-names.csv

python task-05-pipeline.py $5 > collections.csv

echo "FINISHED"