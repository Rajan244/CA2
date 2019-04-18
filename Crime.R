#1#
#here,we have read multiple csv files together 
library(dplyr)
setwd("NI Crime Data") #this used to locate NI crime Data file
# to read all files
read_files <- list.files( pattern="*.csv$", full.names = TRUE, recursive = TRUE)
# below for loop used to read each csv files and row binding all files using rbind() 
for(i in 1:length(read_files))
{
  if(i == 1)
    all_files <- read.csv(read_files[i])
  else
    all_files <- rbind(all_files, read.csv(read_files[i]))
}
all_files <- rbind_list(lapply(all_files, read.csv))
head(all_files) #to show the data
nrow(all_files) #to show total number of rows

setwd("..")
write.csv(all_files,file = "AllNICrimeData.csv", row.names = FALSE) #made csv file
str(all_files)
#2#
#here we removed some attributes 
all_crime <- read.csv("AllNICrimeData.csv", header = TRUE)
attach(all_crime)
all_crime <- subset(all_crime, select = -c(Crime.ID,Reported.by, Falls.within, 
                                           LSOA.code, LSOA.name, Last.outcome.category, Context))
str(all_crime)

#3#
#here we have given a category to perticular crime type
attach(all_crime)
all_crime$Crime_Cat[Crime.type == "Anti-social behaviour"] <- "Penalized" 
all_crime$Crime_Cat[Crime.type == "Drugs"]<- "Punishable"
all_crime$Crime_Cat[Crime.type == "Possession of weapons"] <- "Punishable"
all_crime$Crime_Cat[Crime.type == "Public order"]  <- "Penalized"
all_crime$Crime_Cat[Crime.type == "Theft from the person" ] <- "Punishable"
all_crime$Crime_Cat[Crime.type == "Violence and sexual offences"] <- "Punishable"
all_crime$Crime_Cat[Crime.type == "Bicycle theft"] <- "Punishable"
all_crime$Crime_Cat[Crime.type == "Burglary"] <- "Punishable"
all_crime$Crime_Cat[Crime.type == "Criminal damage and arson"] <- "Punishable"
all_crime$Crime_Cat[Crime.type == "Other crime"] <- "Punishable"
all_crime$Crime_Cat[Crime.type == "Other theft"] <- "Penalized"
all_crime$Crime_Cat[Crime.type == "Robbery"] <- "Punishable"
all_crime$Crime_Cat[Crime.type == "Shoplifting"] <- "Punishable"
all_crime$Crime_Cat[Crime.type == "Vehicle crime"] <- "Punishable"
detach(all_crime)
crime_cat <- factor(all_crime$Damage.type, order = TRUE, 
                      levels = c("Punishable", "Penalized"))
all_crime$Crime_Cat <- as.factor(all_crime$Crime_Cat)
str(all_crime)
sum(is.na(all_crime))

#4#
#here we remved on or near from the location
all_crime$Location <- gsub("On or near", '', all_crime$Location, ignore.case = FALSE)
all_crime$Location <- trimws(all_crime$Location, which = "both")
#then gave Not available to those balnk fields
all_crime$Location <- sub("^$", "Not Available", all_crime$Location)
head(all_crime)
str(all_crime)

#5#
attach(all_crime)
all_crime <- filter(all_crime, Location != "Not Available") #to select NA
"Not Available" %in% all_crime$Location #to check table contains NA value
random_crime_sample <- all_crime[sample(nrow(all_crime), 1000),] #to take only 1000 rows
head(random_crime_sample)
nrow(random_crime_sample)
str(random_crime_sample)

p_code <- read.csv("CleanNIPostcodeData.csv")

c_loc <- random_crime_sample$Location
p_loc <- p_code$Primary_Thorfare
p_pcode <- p_code$Postcode
new_post <- p_code[, c(6, 13)]

find_a_postcode <- function(new_post, random_crime_sample) 
{
  library(sqldf)
  new_post <- sqldf("select max(Postcode),Primary_Thorfare from new_post group by Postcode")
  new_post <- new_post[!duplicated(new_post$Primary_Thorfare),]
  colnames(new_post) <- c("Postcode", "Location")
  new_post
  random_crime_sample$Location <- toupper(random_crime_sample$Location)
  code <- new_post$Postcode[match(random_crime_sample$Location,
                                      new_post$Location)]
  return(code)
}

codes <- find_a_postcode(new_post, random_crime_sample)

#6#
random_crime_sample$Postcode <- codes
nrow(random_crime_sample)
str(random_crime_sample)
#made a new csv file
write.csv(random_crime_sample, file = "random_crime_sample.csv", row.names = FALSE, 
          col.names = FALSE)

#7#
# Here, we are Updating the random sample dataset such that it only contains specific columns 
# and sorting those columns with respect 
# to postcode column containing "BT1" and Crime.type

update_random_sample <- subset(random_crime_sample, select = -c(6))
chart_data <- update_random_sample
chart_data <- filter(chart_data, grepl("BT1", Postcode))
chart_data <- chart_data[order(chart_data$Postcode == "BT1", chart_data$Crime.type), ]
summary(chart_data)
str(chart_data)

#8#
# here, visulizing crime type 
counts <- table(chart_data$Crime.type)
barplot(counts, main = "Crime Type Distribution", xlab = "Types of Crime", 
        ylab = "Count of Crime Type", col = "red", beside=TRUE)

str(chart_data)
