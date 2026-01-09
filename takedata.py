import pymysql
from dotenv import load_dotenv
import os


load_dotenv() # load data file .env

def connect():
    return pymysql.connect(
        host = 'localhost', 
        user = os.getenv('MYSQL_USER'),
        password = os.getenv('MYSQL_PASSWORD'), 
        database = 'hotel_management', 
        charset = 'utf8mb4',
        cursorclass = pymysql.cursors.DictCursor
    )
def getAvailableroom():
    conn = connect()
    try:
        with conn.cursor() as cursor:
            sql = "SELECT room_number FROM `rooms` WHERE `status` = 'available' "
            cursor.execute(sql)
            result = cursor.fetchall()
            for row in result:
                print(row)
    finally:
        conn.close()
def addBooking():
    conn = connect()
    try:
        with conn.cursor() as cursor:
            sql = "SELECT room_number FROM `rooms` WHERE `status` = 'available' "
            cursor.execute(sql)
            result = cursor.fetchall()
            for row in result:
                print(row)
    finally:
        conn.close()
