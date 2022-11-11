import numpy as npy
import pandas as pd
from sklearn.impute import SimpleImputer

df = None

def csv_to_df(fpath):
    """Read the contents of a CSV file to a Pandas data frame"""
    if(fpath != None):
        if(fpath.__contains__(".csv") == False):
            print("Non-CSV file path detected")
            print("Exiting function...")
            print("Please provide a valid CSV file")
            return
        elif(fpath.__contains__(".csv")):
            print("CSV file path detected")
            try:
                with open(fpath, mode = "r") as f:
                    try:
                        global df
                        df = pd.read_csv(f)
                    except:
                        print("Could not read contents from CSV file " + fpath)
            except:
                print("Could not load CSV file " + fpath)
    else:
        print("Please specify a valid location path")

def scan_for_nondata_df():
    """Iterate through the contents of a data frame by row and check for non-data"""
    # iterate rows/entries
    for i in range(len(df)):
        # iterate columns/fields of row i
        for j in df.iloc[[i]]:
            # access jth column/field of ith row/entry
            # if entry value is NaN, fix it
            if(pd.isna(df.iloc[[i]][j].values)):
                cleanse_df()
                return
    return

def cleanse_df():
    """Uses a SimpleImputer object to cleanse non-data from a given data frame"""
    global df
    # declare an imputer object
    imputer = SimpleImputer(missing_values=npy.nan, strategy="most_frequent")
    # fit/attach data frame to imputer
    imputer.fit(df)
    # impute data
    df = pd.DataFrame(imputer.transform(df))
    return

def encode_data():
    """Uses encoders to format classical and Boolean values into 0s and 1s"""
    pass

def partition_train_test():
    """Separates data used for training and testing models"""
    pass

def main():
    """Driver function"""
    csv_to_df("test data/employees.csv")
    scan_for_nondata_df()
    print(df)
    
    return

# Program start point
main()


