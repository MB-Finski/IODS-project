# MB-Finski
# 20.11.2020 (and 25.11. for chapter 5)
#Data wrangling script for IODS chapter 4 and 5 (see below)
#Data source 1: http://s3.amazonaws.com/assets.datacamp.com/production/course_2218/datasets/human_development.csv
#Data source 2: http://s3.amazonaws.com/assets.datacamp.com/production/course_2218/datasets/gender_inequality.csv

#Read in the data sets
hd <- read.csv("http://s3.amazonaws.com/assets.datacamp.com/production/course_2218/datasets/human_development.csv", stringsAsFactors = F)
gii <- read.csv("http://s3.amazonaws.com/assets.datacamp.com/production/course_2218/datasets/gender_inequality.csv", stringsAsFactors = F, na.strings = "..")

#Explore the data sets
str(hd)
str(gii)

#Rename the variables to something shorter
names(hd) <- c("hdi_rank","country","hdi","life_exp","expected_edu","mean_edu", "gni","gni_minus_hdi_rank")
names(gii) <- c("gii_rank","country","gii","mat_mortality", "adol_births","repr_in_parl", "f_2_ed","m_2_ed","f_lab","m_lab") 

#Take a look at what we have done!
str(hd)
str(gii)

library(dplyr)

#Create the new variables as instructed
gii <- mutate(gii,fm_2edu_ratio = f_2_ed/m_2_ed)
gii <- mutate(gii,fm_lab_ratio = f_lab/m_lab)

#Check, check
str(gii)

#Join the data sets
human <- inner_join(hd,gii, by = "country")

#Final check
str(human)

#write the data out
write.table(x = human, file = ".\\data\\human_data.txt")





####################################################################
#
# CHAPTER 5:
# PART 2 OF DATAWRANGLING
#
####################################################################





#Load the data from the previously saved file
human2 <- read.table(file = ".\\data\\human_data.txt")

#Show data structure and dimensions:
str(human2)

####################################################################
# Data description:
# The data consists of two tables combined to one (sources above):
# a table of human development index (and various demographics) by country
# and a table on gender inequality (and various demographics) by country.
# These tables were previously inclusively joined based on the 
# stated country.
#
# Here's the variable decoding table:
#
# hdi_rank          : Rank of countries based on HDI
# country           : Country name as string
# hdi               : Human Development Index (HDI)
# life_exp          : Life expectancy in years
# expected_edu      : Expected education (years)
# mean_edu          : Mean education (years)
# gni               : Gross national income
# gni_minus_hdi_rank: GNI rank of country minus HDI rank
# gii_rank          : Rank of countries based on GII
# gii               : Gender Inequality Index (GII)
# mat_mortality     : Maternal mortality (%)
# adol_births       : Adolecent birth rate (%)
# repr_in_parl      : Precentage of female representation in parliament
# f_2_ed            : % of females with secondary education
# m_2_ed            : % of males with secondary education
# f_lab             : Labour force participation % of females 
# m_lab             : Labour force participation % of males 
# fm_2edu_ratio     : Female to male secondary education ratio
# fm_lab_ratio      : Female to male labour force participation ratio
####################################################################

library(stringr)

#Conver gni to numeric (and remove the commas)
#No need to mutate anything, the task can be done with base functions, as well
human2$gni <- as.numeric(str_replace(human2$gni, pattern=",", replace =""))

#Demonstrate outcome
str(human2$gni)

#Eclude unnecessary variables
human2 <- human2[,c("country", "fm_2edu_ratio", "fm_lab_ratio","expected_edu","life_exp","gni","mat_mortality","adol_births","repr_in_parl")]

#Again, demonstrate outcome
str(human2)

#Remove observations with missing values of any variable
human2 <- filter(human2, complete.cases(human2))

#... demonstrate outcome
str(human2)

#Check where the regions of world (as opposed to countries are located)
human2$country

#The last rows of the print:
#[155] "Niger"
#[156] "Arab States"
#[157] "East Asia and the Pacific"
#[158] "Europe and Central Asia"
#[159] "Latin America and the Caribbean"
#[160] "South Asia"
#[161] "Sub-Saharan Africa"
#[162] "World"

#The regions clumped together at the end of the table;
#Great, let's just drop the last 7 observations
human2 <- human2[1:(nrow(human2) - 7), ]

#...
dim(human2)

#Set countries as row names
rownames(human2) <- human2[,"country"]

#Check the result and drop country from the table
rownames(human2)
human2 <- human2[,!(colnames(human2) %in% "country")]

#Demonstrate the final result (155 obs, 8 vars)
str(human2)

#Save the data (including rownames)
write.table(human2,file = ".\\data\\human_data2.txt", row.names = TRUE)
#Comment: the "row.names = TRUE" is actually not 
#needed since it's set TRUE by default but I included it here
#just for posterity's sake...

#Demonstrate the outcome:
test_table = read.table(".\\data\\human_data2.txt")
str(test_table)
rownames(test_table)



# All done!