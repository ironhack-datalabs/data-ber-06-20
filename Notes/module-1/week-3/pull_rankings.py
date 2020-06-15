import pandas as pd
import requests
import bs4
import re
import datetime
import pymysql
import getpass

def get_rank(list_item):
    rank_pattern = r"(^\d{1,2})"
    school = list_item.div.h3.a.text
    return int(re.findall(rank_pattern, school)[0])

def get_name(list_item):
    name_pattern = r"^\d{1,2}\.\s(.+)"
    school = list_item.div.h3.a.text
    return re.findall(name_pattern, school)[0]

def get_rating(list_item):
    rating_pattern = r"^Avg Rating:\s(\d\.\d{1,2})"
    text = list_item.find("p", class_="rating-number").text
    return float(re.findall(rating_pattern, text)[0])

def get_reviews(list_item):
    review_pattern = r"\((\d+)\sreviews\)$"
    text = list_item.find("p", class_="rating-number").text
    return int(re.findall(review_pattern, text)[0])

def get_stars(list_item):
    stars = {"icon-full_star": 1,
             "icon-half_star": .5,
             "icon-empty_star": 0}
    stars_list = list_item.find("p", class_="ratings").find_all("span")
    return sum([stars[star["class"][0]] for star in stars_list])

def get_locations(list_item):
    return "|".join([x.text for x in (list_item
                                      .find("span", class_="location")
                                      .find_all("a"))])

def get_description(list_item):
    return list_item.find("p", class_="description").p.text

def create_row(list_item):
    return {"date_id": datetime.datetime.today().strftime("%Y-%m-%d"),
            "rank": get_rank(list_item),
            "name": get_name(list_item),
            "rating": get_rating(list_item),
            "stars": get_stars(list_item),
            "reviews": get_reviews(list_item),
            "locations": get_locations(list_item),
            "description": get_description(list_item)}

def get_rankings(bootcamp):
    url = f"https://www.coursereport.com/best-{bootcamp}-bootcamps"
    resp = requests.get(url)
    soup = bs4.BeautifulSoup(resp.content, "html.parser")
    school_list_items = soup.find("ul", id="schools").find_all("li")
    df = pd.DataFrame([create_row(school) for school in school_list_items])
    return df

def create_insert_query(table, df):
    insert_query = f"INSERT INTO {table} VALUES "
    for idx, row in df.iterrows():
        if idx != 0:
            insert_query = insert_query + ", "
        insert_query = insert_query + str((row["date_id"],
                                           row["rank"],
                                           row["name"],
                                           row["rating"],
                                           row["stars"],
                                           row["reviews"],
                                           row["locations"],
                                           row["description"]))
    return insert_query

def insert_rows(df, insert_query, conn):
    cursor = conn.cursor()
    rows = cursor.execute(insert_query)
    conn.commit()
    print(f"{rows} rows written")

if __name__=="__main__":
    bootcamps = ["coding", "data-science", "online"]
    dfs = {ranking: get_rankings(ranking) for ranking in bootcamps}
    
    conn = pymysql.connect(host="localhost",
                           port=3306,
                           user="ironhack",
                           database="bootcamp_rankings",
                           passwd=getpass.getpass("Gimme you password:"))

    for bc in bootcamps:
        df = dfs[bc]
        
        if bc == "data-science":
            bc = "data_science"
        insert_query = create_insert_query(bc, df)
        insert_rows(df, insert_query, conn)
    
    conn.close()
    