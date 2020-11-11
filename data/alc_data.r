# MB-Finski
# 11.11.2020
#Data wrangling script for IODS chapter 3
#Data source: https://archive.ics.uci.edu/ml/datasets/Student+Performance

#Imports
library(dplyr)

#Read in the csv files
data_mat <- read.csv(".//data//student-mat.csv", sep = ";")
data_por <- read.csv(".//data//student-por.csv", sep = ";")

#Explore data structure (dimensions are printed as a part of str() printout)
str(data_mat)
str(data_por)

#Import the names of columns for identifying students
join_by = c("school", "sex", "age", "address", "famsize", "Pstatus", "Medu", "Fedu", "Mjob", "Fjob", "reason", "nursery","internet")

#Join the two data tables
#Only include students present in both tables (inner_join)
data_alc <- inner_join(x = data_mat, y = data_por, by = join_by, suffix = c(".mat", ".por"))


#A generig algorithm for combining all non-joined
#columns with a "." in their name

#Continue stepping as long as there are columns with "." in their name.
while (ncol(select(data_alc, contains("."))) > 0) {
    #Take the first column with a "." in its name
    col_name <- colnames(select(data_alc, contains(".")))[1]

    #Drop ".xxx" from the col name
    short_col_name <- strsplit(x = col_name, split = "[.]")[[1]][1]

    #If the column is numeric, take rounded mean of the values
    #and then place it in a variable with an approapriate name
    if (data_alc[col_name] %>% is.numeric) {
        #Add the new column
        data_alc[short_col_name] <- select(data_alc, contains(short_col_name)) %>% mean %>% round
    }
    else {
        #If the column is not numeric, use the first instance
        #as the correct value
        data_alc[short_col_name] <- data_alc[col_name]
    }

    #Drop source columns since we don't need them anymore
    data_alc <- select(data_alc, -(contains(paste(short_col_name, ".", sep = ""))))
}

#Explore the structure
str(data_alc)

#Create alc_use variable as the average of Dalc and Walc
data_alc <- mutate(data_alc, alc_use = Dalc + Walc / 2)

#Create high_use variable which is true if alc_use > 2
data_alc <- mutate(data_alc, high = alc_use > 2)

#Glimpse at the resulting data
glimpse(data_alc)

#Save data
write.table(x = data_alc,file = ".\\data\\alc_data.txt")