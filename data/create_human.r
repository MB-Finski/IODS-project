# MB-Finski
# 20.11.2020
#Data wrangling script for IODS chapter 4
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

#ALL DONE!