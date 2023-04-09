## Assignment 7

#### Task 1: Load Packages ####
library(tidyverse)
library(data.table) ## For the fread function
library(lubridate)
library(tictoc)

source("sepsis_monitor_functions.R")

#### Task 2 ####
tic()
makeSepsisDataset(n = 100, read_fn = "fread")
fread_time <- toc()

tic()
makeSepsisDataset(n = 100, read_fn = "read_delim")
delim_time <- toc()


#### Task 3: Create Data in Google Drive ####
library(googledrive)

df <- makeSepsisDataset()

# We have to write the file to disk first, then upload it
df %>% write_csv("sepsis_data_temp.csv")

# Uploading happens here
sepsis_file <- drive_put(media = "sepsis_data_temp.csv", 
                         path = "https://drive.google.com/drive/folders/1EAz9vFVlS0Qe4KKQZAuLRJ7LymgYAhwn",
                         name = "sepsis_data.csv")

# Set the file permissions so anyone can download this file.
sepsis_file %>% drive_share_anyone()

#### Task 4 ####

##Getting Data
drive_deauth()
file_link <- "https://drive.google.com/drive/folders/1EAz9vFVlS0Qe4KKQZAuLRJ7LymgYAhwn"

## All data up until now
new_data <- updateData(file_link)

## Include only most recent data
most_recent_data <- new_data %>%
  group_by(PatientID) %>%
  filter(obsTime == max(obsTime))