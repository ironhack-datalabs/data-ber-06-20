import csv
import re

def read_csv(path: str) -> list:
    """
    Take a path to a csv file and return it as a list of dicts
    """
    data = []
    with open(path, "r") as csvfile:
        reader = csv.DictReader(csvfile)
        
        for i, row in enumerate(reader):
            data.append(row)

    return data

def to_sqm(value: str) -> float:
    return round(int(value) / 10.764, 1)

def extract_year(value: str) -> str:
    year_pattern = r"\d{4}$"
    year, = re.findall(year_pattern, value)
    return year

def extract_month(value: str) -> str:
    month_to_digit = {"January": "01",
                  "February": "02",
                  "March": "03",
                  "April": "04",
                  "May": "05",
                  "June": "06",
                  "July": "07",
                  "August": "08",
                  "September": "09",
                  "October": "10",
                  "November": "11",
                  "December": "12"}
    month_pattern = r"^[A-Z][a-z]{2}\s([A-Z][a-z]+)\s"
    
    month_str, = re.findall(month_pattern, value)
    month = month_to_digit[month_str]
    return month

def extract_day(value: str) -> str:
    day_pattern = r"\s(\d{2})\s"
    day, = re.findall(day_pattern, value)
    return day

def extract_date(value: str) -> str:
    return "-".join([extract_year(value),
                     extract_month(value),
                     extract_day(value)])

def process_row(row: dict) -> dict:
    conversions = {"beds": int,
               "baths": int,
               "price": int,
               "sq__ft": to_sqm,
               "sale_date": extract_date,
               "latitude": float,
               "longitude": float,
               "city": lambda x: x.title()}
    
    new_row = {}
    for column, value in row.items():
        if column in conversions:
            new_row["sq_m" if column == "sq__ft" else column] = conversions[column](value)
        else:
            new_row[column] = value
            
    return new_row
