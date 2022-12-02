
data = read.csv("datasets/Auto.csv")

# Produce scatterplot matrix for all variables in Auto dataset.
plot(data)

# Extract only the numeric data from our dataset.
numeric_data = data[,-9]

# Convert numeric data represented in non-numeric form.
numeric_data[,4] = as.integer(numeric_data[,4])

# Interpret non-data as zeroes
for(i in 1:length(numeric_data[,4])){
  if(is.na(numeric_data[i,4])){
    numeric_data[i,4] = 0
  }
}

# Print summary of numeric data.
summary(numeric_data)

# Create correlation matrix of all numeric fields in dataset.
cor(numeric_data)

