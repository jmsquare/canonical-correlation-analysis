install.packages("CCA")
library(CCA)

install.packages("FactoMineR")
library(FactoMineR)

install.packages("gdata")
library(gdata)

library(plyr) 
library(XLConnect)


#################
#db1 and db2 are the two data matrices used to implement canonical correlation analysis
#############################
db1<-as.matrix(db1);
db2<-as.matrix(db21);

####################
#Creation of the latent dimensions between the two data matrices
############################################
#Package CCA
res.cc=cc(db1,db2)
plot(res.cc$cor,type="b")
plt.cc(res.cc)
summary(res.cc$scores)

###################################
#Kmeans to create a distance between individuals using first 4 latent dimensions
###########################################"
km<-kmeans(res.cc$scores$xscore[,1:4], 350, iter.max = 2000, algorithm="Lloyd", nstart = 2);
diss<-dist(km$centers, method="euclidean");

domest_resume<-cbind(km$cluster,domest);

#######################################
#Hierarchical Clustering On Principle Components using preprocessed kmeans
##################################################################"
cl <- HCPC(as.data.frame(km$centers), nb.clust=7, consol=TRUE, iter.max=10, min=3,
max=NULL, metric="euclidean", method="ward", order=TRUE,
graph.scale="inertia", nb.par=5, graph=TRUE, proba=0.05,
cluster.CA="rows")

cl$data.clust$km<-(1:dim(cl$data.clust)[1]);
names(interna1_resume)[names(interna1_resume) == 'km$cluster'] <- 'km';
interna1_donnee<-merge(x = interna1_resume, y = cl$data.clust, by = "km", all.x=TRUE);

#####################################
#Profiling of the different groups using descriptive statitistics
#################################################################
profiling <- catdes(interna1_donnee,
                         num.var = 39,
                         proba = 0.05)

#################################################"
#Exportation to Excel
#############################################""

setwd("D:/Users/jjohnmat/Desktop/project)

for (i in 1:length(names(profiling$category))) {
  
  quali <- as.data.frame(profiling$category[i])
  quali$modalite <- row.names(quali)
  
  quanti <- as.data.frame(profiling$quanti[i])
  quanti$modalite <- row.names(quanti)
  
  writeWorksheetToFile("interna.xlsx",
                       data = quali,
                       sheet = paste("quali", names(profiling$category)[i], sep = "_"),
                       startRow = 1,
                       startCol = 1)
  
  writeWorksheetToFile("interna.xlsx",
                       data = quanti,
                       sheet = paste("quanti", names(profiling$quanti)[i], sep = "_"),
                       startRow = 1,
                       startCol = 1)
  
}