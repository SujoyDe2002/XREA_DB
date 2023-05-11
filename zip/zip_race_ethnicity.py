import urllib.request
import urllib.parse
import json
import psycopg2
from datetime import datetime, timezone

# ----------------------- Establish DB connection -----------------------
conn = psycopg2.connect(host="xrea-india-postgres.postgres.database.azure.com", database="postgres",
                        user="xreaadmin@xrea-india-postgres", password="xr34-4dm1n-0e2K5!")

cursor = conn.cursor()


def get_data(url):
    req = urllib.request.urlopen(url)
    data = req.read()
    json_object = json.loads(data.decode('utf-8'))
    return json_object


# ***for 2011-2021***
def map_data(entry):
    output = []
    output.append(entry[0])
    output.append(publication_year)
    
    ## Indices of required values (from api url lists) corresponding to each column in table 
    index_list = [9,13,17,21,25,45]
    for ind in index_list:
        output.append(entry[ind])

    current_time = datetime.now(timezone.utc)
    output.append(current_time)
    return output

## Function used to insert data to 'zip_race_ethnicity' table
def data_pop(values):
    query ='''INSERT INTO zip_race_ethnicity(geo_id, publication_year, white_alone, black_or_aa_alone,
        american_indian_alaskan_alone, asian_alone, hawaiian_pacific_islander_alone,hispanic_latino, timestamp)
        VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s)'''
    del values[0]
    print("Inserting", len(values), "records into the DB for", publication_year, "...")
    
    for ele in values:
        try:
            cursor.execute(query, ele)
        except:
            pass
    
    conn.commit()
    print(publication_year, "done!")


#--- 2021 --- 2021-2011: Columns grabbed are GEO_ID,B03002_003E,B03002_004E,B03002_005E,B03002_006E,B03002_007E,B03002_012E ***
url = 'http://api.census.gov/data/2021/acs/acs5?get=GEO_ID,group(B03002)&for=zip%20code%20tabulation%20area:*&key=9460c060853309137ffb4ea65569ab961ed47c57'
publication_year = 2021
values = list(map(map_data, get_data(url)))
data_pop(values)


# --- 2020 ---
url = 'http://api.census.gov/data/2020/acs/acs5?get=GEO_ID,group(B03002)&for=zip%20code%20tabulation%20area:*&key=9460c060853309137ffb4ea65569ab961ed47c57'
publication_year = 2020
values = list(map(map_data, get_data(url)))
data_pop(values)

# --- 2019 ---
url = 'http://api.census.gov/data/2019/acs/acs5?get=GEO_ID,group(B03002)&for=zip%20code%20tabulation%20area:*&key=9460c060853309137ffb4ea65569ab961ed47c57'
publication_year = 2019
values = list(map(map_data, get_data(url)))
data_pop(values)

# --- 2018 ---
url = 'http://api.census.gov/data/2018/acs/acs5?get=GEO_ID,group(B03002)&for=zip%20code%20tabulation%20area:*&key=9460c060853309137ffb4ea65569ab961ed47c57'
publication_year = 2018
values = list(map(map_data, get_data(url)))
data_pop(values)

# --- 2017 ---
url = 'http://api.census.gov/data/2017/acs/acs5?get=GEO_ID,group(B03002)&for=zip%20code%20tabulation%20area:*&key=9460c060853309137ffb4ea65569ab961ed47c57'
publication_year = 2017
values = list(map(map_data, get_data(url)))
data_pop(values)

# --- 2016 ---
url = 'http://api.census.gov/data/2016/acs/acs5?get=GEO_ID,group(B03002)&for=zip%20code%20tabulation%20area:*&key=9460c060853309137ffb4ea65569ab961ed47c57'
publication_year = 2016
values = list(map(map_data, get_data(url)))
data_pop(values)

# --- 2015 ---
url = 'http://api.census.gov/data/2015/acs/acs5?get=GEO_ID,group(B03002)&for=zip%20code%20tabulation%20area:*&key=9460c060853309137ffb4ea65569ab961ed47c57'
publication_year = 2015
values = list(map(map_data, get_data(url)))
data_pop(values)

# --- 2014 ---
url = 'http://api.census.gov/data/2014/acs/acs5?get=GEO_ID,group(B03002)&for=zip%20code%20tabulation%20area:*&key=9460c060853309137ffb4ea65569ab961ed47c57'
publication_year = 2014
values = list(map(map_data, get_data(url)))
data_pop(values)

# --- 2013 ---
url = 'http://api.census.gov/data/2013/acs/acs5?get=GEO_ID,group(B03002)&for=zip%20code%20tabulation%20area:*&key=9460c060853309137ffb4ea65569ab961ed47c57'
publication_year = 2013
values = list(map(map_data, get_data(url)))
data_pop(values)

# --- 2012 ---
url = 'http://api.census.gov/data/2012/acs/acs5?get=GEO_ID,group(B03002)&for=zip%20code%20tabulation%20area:*&key=9460c060853309137ffb4ea65569ab961ed47c57'
publication_year = 2012
values = list(map(map_data, get_data(url)))
data_pop(values)

# --- 2011 ---
url = 'http://api.census.gov/data/2011/acs/acs5?get=GEO_ID,group(B03002)&for=zip%20code%20tabulation%20area:*&key=9460c060853309137ffb4ea65569ab961ed47c57'
publication_year = 2011
values = list(map(map_data, get_data(url)))
data_pop(values)


# --- 2010 --- ** No data available for 2010 year **
# url = 'http://api.census.gov/data/2010/acs/acs5?get=GEO_ID,group(B03002)&for=zip%20code%20tabulation%20area:*&key=9460c060853309137ffb4ea65569ab961ed47c57'
# publication_year = 2010
# values = list(map(map_data, get_data(url)))     
# data_pop(values)

conn.close()
