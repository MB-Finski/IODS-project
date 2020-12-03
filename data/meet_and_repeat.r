# MB-Finski
# 1.12.2020
#Data wrangling script for IODS chapter 6
#Data source 1: https://raw.githubusercontent.com/KimmoVehkalahti/MABS/master/Examples/data/bprs.txt
#Data source 2: https://raw.githubusercontent.com/KimmoVehkalahti/MABS/master/Examples/data/rats.txt

library(tidyr)

#We're all R-grownups already so you'll know what the following code snippets do
bprs = read.table("https://raw.githubusercontent.com/KimmoVehkalahti/MABS/master/Examples/data/BPRS.txt", header = TRUE)
rats = read.table("https://raw.githubusercontent.com/KimmoVehkalahti/MABS/master/Examples/data/rats.txt", header = TRUE)
str(bprs)
str(rats)

#The BPRS-coding of "subject" is entirely bonkers;
#(same ids for [supposedly] different individuals).
#Let's fix that while we're at it:
bprs["subject"] <- 1:nrow(bprs)

str(bprs)
#Now that's much better...

#"Autobots, factorize!"
bprs[1:2] <- lapply(bprs[1:2], factor)
rats[1:2] <- lapply(rats[1:2], factor)

#Add some labeling for clarity later on
rats$Group <- factor(rats$Group,
                    labels = c("Group 1", "Group 2", "Group 3"))
bprs$treatment <- factor(bprs$treatment,
                    labels = c("Treatment 1", "Treatment 2"))

str(bprs)
str(rats)

#gather() is slowly being deprecated, so let's rather use
#the currently supported function for long conversion, i.e. pivot_longer()
bprs_long <- pivot_longer(bprs, 3:11, names_to = "week", values_to = "bprs")
bprs_long$week <- substring(bprs_long$week, 5, 5) %>% as.numeric

rats_long <- pivot_longer(rats, 3:13, names_to = "time", values_to = "weight")
rats_long$time <- substring(rats_long$time, 3, 4) %>% as.numeric

#Now, as per the instructions, let's get VERY SERIOUS about this!
#... I.e. let's inspect what the long format of the data actually means
str(bprs_long)
str(rats_long)

#Summaries of the data/variables
summary(bprs_long)
summary(rats_long)

# INTERPRETATION of long format: As you you can see, in the long format
# (as opposed to the wide format), all reponse variables are gathered
# under a single variable. The timepoint of the observation/row is
# signified by the added time/week -variable. Because each
# subject has multiple time points, each subject also now has multiple
# rows (i.e. rows with the same subject/id number). Therefore
# the table now has quite a bit more rows (and less columns).
# Hence the terms "long format" and "wide format".
#
# This "long format" facilitates the later use of repeated-
# measures analysis methods.

write.table(bprs, file = ".\\data\\bprs_data.txt")
write.table(bprs_long, file = ".\\data\\bprs_long_data.txt")
write.table(rats, file = ".\\data\\rats_data.txt")
write.table(rats_long, file = ".\\data\\rats_long_data.txt")
