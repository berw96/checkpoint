# a script for demonstrating matrix creation and iteration

matrixA <- matrix(c(1L,2L,3L,4L,5L,6L,7L,8L), nrow = 2, ncol = 4)

for(row in 1:nrow(matrixA)){
  for(col in 1:ncol(matrixA)){
    print(matrixA[row, col])
  }
}

