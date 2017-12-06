# This shell script that calls the load generator, followed by task-05-pipeline. 
# This inputs the data into a mongo db database   

# usage: sh ./task-05-master.sh http://localhost:8080/primecheck 10 10 5 load-generator-number
# returns: a csv file with database names for use in the r script, a csv file with collection names for use in the r script 

#!/bin/bash

sh ./task-03-load-generator.sh $1 $2 $3 $4 $5

sleep 10s

a='loadgen'
echo $a$5 >> database-names.csv

python task-05-pipeline.py $5 > collections.csv

echo "FINISHED"