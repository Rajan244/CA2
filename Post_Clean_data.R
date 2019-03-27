library(dplyr) 

post_data <- read.csv("NIPostcodes.csv", header = FALSE, na.strings=c("","NA"))
Dummy2 <- read.csv("NIPostcodes.csv")


colnames(post_data) <- c("Organisation_Name", "Sub-building_Name", "Building_Name", "Number",
                     "Primary_Thorfare", "Alt_Thorfare", "Secondary_Thorfare", "Locality",
                     "Townland", "Town", "County", "Postcode", "x-coordinates", "y-coordinates",
                     "Primary_Key")



head(post_data, n=10)
str(post_data)
class(post_data)

sum(is.na(post_data))
mean(is.na(post_data))


colnames(post_data)
clean_post <- post_data[,c(15,1,2,3,4,5,6,7,8,9,10,11,12,13,14)]
head(clean_post)

#limavady_data <- clean_post[which(clean_post$Town == "LIMAVADY" ),]
#limavady_data


attach(clean_post)
limavady_data <- filter(clean_post, Town == "LIMAVADY" | Locality == "LIMAVADY" |
                           Townland == "LIMAVADY")

limavady_data

