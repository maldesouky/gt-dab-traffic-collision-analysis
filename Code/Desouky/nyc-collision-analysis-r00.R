#
# nyc-collision-analysis-r00.R
#
# New York City Traffic Collision Analysis
# Built for MGT6203 Course Project
# Based on the work of Marco LoConte

# change working directory to current
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

# clear environment
rm(list = ls())

# needed libraries
library(pROC)
library(car)
library(caret)
library(testit)
library(glmnet)
library(dplyr)
library(ROCR)

# load data
nyc.df <- read.csv("nyc-collisions-weather-tod-final.csv")
sprintf("Loaded %d records...", nrow(nyc.df))

##
## Prepare Data
##
# IOD = Injury or Death
nyc.df$IOD <- ifelse(nyc.df$INJURY + nyc.df$DEATH > 0, 1, 0)

# In-state / Out-of-state Licenses
nyc.df$instate_lic_1 <- 0
nyc.df$instate_lic_2 <- 0
nyc.df$instate_lic_2[(nyc.df$DRIVER_LICENSE_JURISDICTION_2 == 'NY')] <- 1
nyc.df$instate_lic_1[(nyc.df$DRIVER_LICENSE_JURISDICTION_1 == 'NY')] <- 1

# Car make
nyc.df$VM_1 <- substring(tolower(nyc.df$VEHICLE_MAKE_1),1,4)
nyc.df$VM_2 <- substring(tolower(nyc.df$VEHICLE_MAKE_2),1,4)

nyc.df$VM_1[grepl("kia",nyc.df$VM_1) == TRUE] <- "kia"
nyc.df$VM_1[grepl("bmw",nyc.df$VM_1) == TRUE] <- "bmw"
nyc.df$VM_1[grepl("isu",nyc.df$VM_1) == TRUE] <- "isuz"
nyc.df$VM_2[grepl("kia",nyc.df$VM_2) == TRUE] <- "kia"
nyc.df$VM_2[grepl("bmw",nyc.df$VM_2) == TRUE] <- "bmw"
nyc.df$VM_2[grepl("isu",nyc.df$VM_2) == TRUE] <- "isuz"

car_make_keeps <- c( 'toyt',  'hond',  'niss',  'ford',  'chev',  'hyun',
                     'merz',  'jeep',   'bmw',  'dodg',  'lexs',  'acur',
                     'infi',  'volk',  'suba',  'chry',   'kia',  'gmc',
                     'linc',  'audi',  'mazd') 

nyc.df$VM_1[!(nyc.df$VM_1 %in% car_make_keeps)] <- 'other'
nyc.df$VM_2[!(nyc.df$VM_2 %in% car_make_keeps)] <- 'other'
##
## END OF: Prepare Data
##

# split into training, validation, and test datasets
set.seed(1973)

# 70% - training
# 30% - testing
ds.split.train <- 0.7
ds.split.valid <- 0.0
ds.split.test <- 0.3

assert(ds.split.train + ds.split.valid + ds.split.test == 1)

nyc.sampler <- sample( c(1,2,3), nrow(nyc.df), replace=TRUE,
                       prob=c(ds.split.train, ds.split.valid, ds.split.test))

nyc.train <- nyc.df[nyc.sampler == 1,]
nyc.valid <- nyc.df[nyc.sampler == 2,]
nyc.test  <- nyc.df[nyc.sampler == 3,]

sprintf("Dataset splitted into:")
sprintf("> Training (%d%%): %d records", ds.split.train*100, nrow(nyc.train))
sprintf("> Validation (%d%%): %d records", ds.split.valid*100, nrow(nyc.valid))
sprintf("> Testing (%d%%): %d records", ds.split.test*100, nrow(nyc.test))

# free memory
#rm(nyc.sampler)

## MODEL 1
## Sex Predictor
model_sex <- glm(IOD ~ DRIVER_SEX_1 + DRIVER_SEX_2 + DRIVER_SEX_1:DRIVER_SEX_2,
                 family=binomial(link='logit'), data=nyc.train)

summary(model_sex)

nyc.train <- nyc.train %>%
  mutate(IOD = factor(IOD, levels=c(0, 1)))



trControl <- trainControl(method = 'repeatedcv',
                          number = 5,
                          repeats =  5,
                          search = 'random')

logit.CV <- train(IOD ~ DRIVER_SEX_1 + DRIVER_SEX_2 + DRIVER_SEX_1:DRIVER_SEX_2,
                  data = nyc.train,
                  method = 'glm',
                  trControl = trControl,
                  family = 'binomial')

PredLR <- predict(logit.CV, nyc.train, type = "prob")
lgPredObj <- prediction((1-PredLR[,2]), nyc.train$IOD)
lgPerfObj <- performance(lgPredObj, "tpr","fpr")

aucLR <- performance(lgPredObj, measure = "auc")
aucLR <- aucLR@y.values[[1]]
aucLR
abline(a = 0,b = 1,lwd = 2,lty = 3,col = "black")
