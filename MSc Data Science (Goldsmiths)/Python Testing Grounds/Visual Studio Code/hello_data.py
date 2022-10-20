#%%

from enum import Enum
import json
import csv
import asyncio
import pandas as pd
import numpy as np
from matplotlib import pyplot as pp
from typing import Final as const

def file_to_dict(fpath = "", dict = {}):
    """Opens a file from a specified path and, if it exists,
    it's data is read to a dictionary. JSON and CSV formats only."""
    print("file_to_dict()")
    if(fpath != None):
        if(fpath.__contains__(".json")):
            print("JSON file path detected")
            try:
                with open(fpath, mode = "r", encoding = "utf-8") as f:
                    try:
                        # REQUIRES IMPLEMENTATION
                        pass
                    except:
                        print("Could not read contents from JSON file " + fpath)
            except:
                print("Could not load JSON file " + fpath)

        elif(fpath.__contains__(".csv")):
            print("CSV file path detected")
            try:
                with open(fpath, mode = "r") as f:
                    dict = csv.DictReader(f)
                    for entry in dict:
                        print(entry)
            except:
                print("Could not load CSV file " + fpath)
                print("Check file permissions and location then try again")
        else:
            print("Unsupported file extension " + fpath)
            return
    else:
        print("Please specify a valid location path.")
    

def dict_to_file(dict = {}, fpath = ""):
    """Reads the contents of a provided dictionary to a
    specified file (if it exists)."""
    print("dict_to_file()")
    if(fpath != None):
        if(fpath.__contains__(".json")):
            print("JSON file path detected")
            try:
                with open(fpath, mode = "w", encoding = "utf-8") as f:
                    try:
                        json.dump(dict, f, ensure_ascii = False)
                    except:
                        print("Could not write contents to " + fpath)
            except:
                print("Could not load JSON file " + fpath)
        elif(fpath.__contains__(".csv")):
            print("CSV file path detected")
            try:
                with open(fpath, mode = "w") as f:
                    try:
                        fields = ["Name", "Age", "Sex"]
                        csv_writer = csv.DictWriter(f, fieldnames = fields)
                        csv_writer.writeheader()
                        csv_writer.writerow(dict)
                    except:
                        print("Could not write contents to " + fpath)
            except:
                print("Could not load CSV file " + fpath)
                print("Check file permissions and location then try again")
    else:
        print("Please specify a valid location path.")

def file_to_df(fpath):
    if(fpath != None):
        if(fpath.__contains__(".json")):
            print("JSON file path detected")
            try:
                with open(fpath, mode = "r", encoding = "utf-8") as f:
                    try:
                        df = pd.read_json(f)
                    except:
                        print("Could not read content from JSON file " + fpath)
            except:
                print("Could not load JSON file " + fpath)
        elif(fpath.__contains__(".csv")):
            print("CSV file path detected")
            try:
                with open(fpath, mode = "r") as f:
                    try:
                        df = pd.read_csv(f)
                        print(df)
                        df.plot.scatter(x = "Age", y = "Age")
                    except:
                        print("Could not read contents from CSV file " + fpath)
            except:
                print("Could not load CSV file " + fpath)
    else:
        print("Please specify a valid location path")

def df_to_file(df, fpath):
    pass

def format_data(d):
    pass

def cleanse_data(d):
    pass

def sanitize_data(d):
    pass

def main():
    """Driver function"""
    print("main()")
    #file_to_dict("../../Test Data/CSV/test.csv")
    #dict_to_file(dict = {"Name" : "David", "Age" : 22, "Sex" : "M"}, fpath = "../../Test Data/CSV/test.csv")
    file_to_df("../../Test Data/CSV/test.csv")

# run program
main()

# %%
