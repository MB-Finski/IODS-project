####################################################################################################################################
# Assignment 1:
####################################################################################################################################

#Creating this file in the "data" folder under the project 

####################################################################################################################################
# Assignment 2:
####################################################################################################################################

#Read the data to a table:
learning2014 = read.table("http://www.helsinki.fi/~kvehkala/JYTmooc/JYTOPKYS3-data.txt", sep="\t", header = TRUE)
learning2014

#Convert all variable names to lower case for convenience
names(learning2014) <- tolower(names(learning2014))
str(learning2014)

#Explore dimensions of the table:
dim(learning2014)
#Outputs the n of rows and columns, respectively, in the data table

#Inspect the structure of the data:
str(learning2014)
#Outputs the names of each row, their variable type, and first few observations. Also the dimensions of the table are printed


####################################################################################################################################
# Assignment 3:
####################################################################################################################################

#Create a new table from subset of the relevant variables
varsOfInterest <- c("gender","points","attitude","age", "deep", )
analysisDataset <- learning2014[varsOfInterest]

#Copy-pasted definitions for the relevant question vectors
deep_questions <- c("D03", "D11", "D19", "D27", "D07", "D14", "D22", "D30","D06",  "D15", "D23", "D31")
surf_questions <- c("SU02","SU10","SU18","SU26", "SU05","SU13","SU21","SU29","SU08","SU16","SU24","SU32")
stra_questions <- c("ST01","ST09","ST17","ST25","ST04","ST12","ST20","ST28")

deep_questions <- tolower(deep_questions)
surf_questions <- tolower(surf_questions)
stra_questions <- tolower(stra_questions)


#Create deep, stra, and surf variables as requested
analysisDataset$deep = rowMeans(learning2014[deep_questions])
analysisDataset$stra = rowMeans(learning2014[stra_questions])
analysisDataset$surf = rowMeans(learning2014[surf_questions])

#Scale attitude accordingly:
analysisDataset$attitude <- analysisDataset$attitude / 10

#Only choose cases where points != 0
analysisDataset <- subset(analysisDataset, points!=0)

#Inspect the analysisDataset structure:
str(analysisDataset)
head(analysisDataset)

#Write out the analysisDataset:
write.table(analysisDataset,file = ".\\data\\learning2014.txt")

#Read the file and demonstrate that the data remained untouched
analysisDataset <- read.table(".\\data\\learning2014.txt")
str(analysisDataset)
head(analysisDataset)
