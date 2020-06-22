import pymysql
import getpass

def connect(user="ironhack", db="olist"):
    return pymysql.connect(host="localhost",
                           port=3306,
                           user=user,
                           passwd=getpass.getpass("Please provide your password"),
                           db=db)
                           