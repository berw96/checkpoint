import mysql.connector

config = {
    "user"      : "root",
    "password"  : "erw1996",
    "host"      : "localhost",
    "database"  : "coffee_store"
}        
            
connection = mysql.connector.connect(**config)
if connection != None:
    
    cursor = connection.cursor()
    cursor.execute("show tables")
    
    for table in cursor:
        print(table)
    
    connection.close()
