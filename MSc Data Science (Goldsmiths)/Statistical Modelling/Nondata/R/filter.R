# Coded by Elliot Walker (2022)
# berw96@gmail.com
# GNU General Public License Vers.3

filter_nondata <- function(df){
  # scan provided dataset 'df' for nondata such as 'NA' or '?'.
  # Once found, set it to 0 or "".
  nondata_count = 0

  for(j in 1:length(df)){
    for(i in 1:length(df[,j])){
      if(is.na(df[i,j]) || df[i,j] == '?'){
        cat("Non-data detected ", "(", df[i,j], "), ", "at ", "[", i, ",", j, "]", "\n", sep = "")
        nondata_count = nondata_count + 1
        if(typeof(df[,j]) == "integer"){
          print("Integer field")
          df[i,j] = 0
        } else if(typeof(df[,j]) == "double"){
          print("Double or Numeric field")
          df[i,j] = 0.0
        } else if(typeof(df[,j]) == "character"){
          print("Character field")
          df[i,j] = ""
        }
      }
    }
  }
  # Use recursion to rescan the dataframe for more nondata.
  if(nondata_count != 0){
    df = filter_nondata(df)
  } else {
    print("All nondata successfully removed.")
  }
  # If all nondata has been successfully removed, return the dataframe.
  return(df)
}
