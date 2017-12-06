# Libraries 
{
# load mongolite
library(mongolite)
# load ggplot
library(ggplot2)
}

# Set up 
{
# read in collection names 
(collectionNames = readLines("../collections.csv"))
# remove cadvisor
collectionNames = collectionNames[-1]
# read in database names 
(databaseNames = readLines("../database-names.csv"))
# directories for printing out plots
graph.direct = "/Users/jackwaudby/Library/Mobile Documents/com~apple~CloudDocs/csc8110/docker/graphics"
r.direct = "/Users/jackwaudby/Library/Mobile Documents/com~apple~CloudDocs/csc8110/docker/R"
}

# Function
{
# Parameters:
# - database name 
# - collection names 
# - plot type (cpu/memory/joint)
# Returns:
# - specficied plots
# - number of documents in the collection 
cadvisor.plots <- function(collections, database, type){
  
  # TEST RUN PARAMETERS 
  #collections = collectionNames
  #database = databaseNames[1]
  #type = "cpu"
  
  # creating empty dataframe for number of documents in each collection
  number.docs = rep(0,length(collections))
  df = data.frame(collections,number.docs)

  # Iterating through the collections in the database
  for (i in 1:length(collections)) {
    
    # connect to mongodb instance
    m = mongo(collection = collections[i], db = database, url = "mongodb://localhost:3306")
    # number of documents in collection 
    df[i,2] = m$count()
    # loading in all documents in the collection
    alldata <- m$find('{}')
    # extracting timestamps
    (times = alldata$timestamp)
    (times = gsub("T"," ",times))
    (times = gsub("Z","",times))
    (times <- strptime(times, "%Y-%m-%d %H:%M:%OS"))
    (times <- as.POSIXct(times, format="%H:%M:%S"))
    (delta.time <- diff(times))
    time.delta = as.numeric(delta.time)
    
    # if cpu usage specified 
    if ( type == "cpu" ) {
      
      # extracting cpu data 
      cpu = alldata$cpu
      # extracting cpu usage 
      cpu.usage = cpu$usage
      # total cpu usage 
      cpu.usage.total = cpu.usage$total
      # differences between usages 
      delta = diff(cpu.usage.total, lag = 1) 
      # calculating core usage 
      cores = delta/time.delta
      cores = cores/1000000000
      
      # creating dataframe for ggplot
      dat = data.frame(cores,times[-1])
      names(dat) <- c("cores","time")
      
      # creating the plot object 
      g = ggplot(data=dat, aes(x=time,y=cores)) +
        ggtitle(paste("Total Usage of",collections[i]),subtitle=database) +
        geom_line(color=i+1) +
        theme(plot.subtitle = element_text(size=10, face="italic"))
      
      mypath <- file.path("/Users/jackwaudby/Library/Mobile Documents/com~apple~CloudDocs/csc8110/docker/graphics",paste(collections[i],"-", database, ".png", sep = ""))
      
      png(file=mypath)
      
      print(g)
      
      dev.off()
      
    }

    else if ( type == "memory" ){
      
      # extracting memory 
      memory = alldata$memory
      # extracting memory usage
      memory.usage = memory$usage
      # convert to megabytes
      memory.usage = memory.usage/1000000
      
      # extracting timestamps
      times = alldata$timestamp
      # cleaning timestamps 
      ct = cleantime(times)
      
      # creating dataframe for ggplot
      dat = data.frame(memory.usage,ct)
      names(dat) <- c("memory","time")
      # creating the plot object 
      
      setwd(graph.direct)
      png(filename=paste("totalmemory-",collections[i],".png",sep=""))
      
      g = ggplot(data=dat, aes(x=time,y=memory)) + 
            geom_line(color=i) +
              ggtitle(paste("Total Memory Usage of",collections[i])) +
                ylab("megabytes") 
      print(g)
      
      dev.off()
      
      setwd(r.direct)

    }
      
  }
  
  return(df=df)

}
}

# Function calls
{
# CPU 
for (i in 1:length(databaseNames)) {
  cadvisor.plots(collections = collectionNames, database = databaseNames[i], type = "cpu")
}

}
