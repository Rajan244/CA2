#first of all read the NIpostcode file
post_data <- read.csv("NIPostcodes.csv", header = FALSE, na.strings = c("", "NA"))

#1#

nrow(post_data) #To display total number of rows
head(post_data, n=10) #to display first ten row of table 
str(post_data) #to display the structure of dataframe
class(post_data)

#2#

# here using the clonames() we have given the suitable title for each attribute of data 
colnames(post_data) <- c("Organisation_Name", "Sub_building_Name", "Building_Name", "Number",
                     "Primary_Thorfare", "Alt_Thorfare", "Secondary_Thorfare", "Locality",
                     "Townland", "Town", "County", "Postcode", "x_coordinates", "y_coordinates",
                     "Post_ID")
head(post_data)
str(post_data)
#3#
# TO place NA in null value I have putted na.string in read.csv()
#post_data[post_data == " "] <- NA
head(post_data)
str(post_data)

#4#

sum(is.na(post_data)) #To see the total number of missing values in table 

# below we have written code to display the total number of  missing values and thier mean
#of each attributes
sum(is.na(post_data$Organisation_Name))
mean(is.na(post_data$Organisation_Name))
sum(is.na(post_data$Sub_building_Name))
mean(is.na(post_data$Sub_building_Name))
sum(is.na(post_data$Building_Name))
mean(is.na(post_data$Building_Name))
sum(is.na(post_data$Number))
mean(is.na(post_data$Number))
sum(is.na(post_data$Primary_Thorfare))
mean(is.na(post_data$Primary_Thorfare))
sum(is.na(post_data$Alt_Thorfare))
mean(is.na(post_data$Alt_Thorfare))
sum(is.na(post_data$Secondary_Thorfare))
mean(is.na(post_data$Secondary_Thorfare))
sum(is.na(post_data$Locality))
mean(is.na(post_data$Locality))
sum(is.na(post_data$Townland))
mean(is.na(post_data$Townland))
sum(is.na(post_data$Town))
mean(is.na(post_data$Town))
sum(is.na(post_data$County))
mean(is.na(post_data$County))
sum(is.na(post_data$Postcode))
mean(is.na(post_data$Postcode))
sum(is.na(post_data$x_coordinates))
mean(is.na(post_data$x_coordinates))
sum(is.na(post_data$y_coordinates))
mean(is.na(post_data$y_coordinates))
sum(is.na(post_data$Post_ID))
mean(is.na(post_data$Post_ID))

mean(is.na(post_data)) #To see the mean of missing total null values in dataset
str(post_data)
#5#

post_data$Geo_location[post_data$County == "ANTRIM"] <- "North-East"
post_data$Geo_location[post_data$County == "DOWN"] <- "South-East"
post_data$Geo_location[post_data$County == "ARMAGH"] <- "South"
post_data$Geo_location[post_data$County == "LONDONDERRY"] <- "North-West"
post_data$Geo_location[post_data$County == "TYRAN"] <- "West"
post_data$Geo_location[post_data$County == "FERMANAGH"] <- "South-West"
Geo_location <- factor(post_data$Geo_location, order = TRUE, levels = c("North-East",
                                                                          "South-East", 
                                                                          "South",
                                                                          "North-West",
                                                                          "West",
                                                                          "South-West"))
post_data$Geo_location <- Geo_location
head(post_data)
str(post_data)
#sum(is.na(post))
#print(is.factor(post_data$County))

#6#

#we moved primary key Post_ID to start of the dataset
colnames(post_data)
clean_post <- post_data[,c(15,1:14,16)]
head(clean_post)
str(clean_post)

#7#

#using the filter function we filtered the LIMAVADY data from the dataframe and made another CSV file 
#call Limavady
library(dplyr) # for filter function
attach(clean_post) #to use for the attached clean_post database
limavady_data <- filter(clean_post, Town == "LIMAVADY" | Locality == "LIMAVADY" |
                           Townland == "LIMAVADY")
limavady_data
str(limavady_data)
detach(clean_post)
write.csv(limavady_data, file = "Limavady_data.csv")

#8#

write.csv(clean_post, file = "CleanNIPostcodeData.csv", row.names = FALSE)
str(clean_post)
