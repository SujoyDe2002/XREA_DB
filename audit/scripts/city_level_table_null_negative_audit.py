import psycopg2
import os
import csv

# ----------------------- Establish DB connection -----------------------
conn = psycopg2.connect(host="xrea-india-postgres.postgres.database.azure.com", database="postgres", 
                        user="xreaadmin@xrea-india-postgres", password="xr34-4dm1n-0e2K5!")

cursor = conn.cursor()

print("Connection established!")


# dictionary containing list of variables with respective to each city-level-table

dictionary_table_variables = {
            'city_master':['total_population'],

            'aggregate_travel_time':['aggregate_travel_time'],

            'education':['hs_graduation_rate','bs_graduation_rate'],

            'employment':['total_in_labor_force','total_civilian_labor_force',
                        'employed_civilian_labor_force','unemployed_civilian_labor_force', 
                        'armed_forces_labor_force', 'total_not_in_labor_force'],

            'home_ownership':['owner_occupied_housing_rate'],

            'home_ownership_cost':['monthly_ownership_cost'],

            'means_of_transportation':['drove_alone','carpooled','public_transportation',
                                        'walked','other', 'worked_from_home'],

            'median_home_value':['median_home_value'],

            'median_income':['median_household_income'],

            'median_rent':['median_contract_rent'],

            'population_age_sex':['total_male_population', 'total_male_under_5', 
                'total_male_5_to_9', 'total_male_10_to_14',
                'total_male_15_to_17', 'total_male_18_and_19', 
                'total_male_20', 'total_male_21', 'total_male_22_to_24',
                'total_male_25_to_29', 'total_male_30_to_34', 
                'total_male_35_to_39', 'total_male_40_to_44', 
                'total_male_45_to_49','total_male_50_to_54',
                  'total_male_55_to_59', 'total_male_60_and_61', 
                  'total_male_62_to_64', 'total_male_65_and_66',
                 'total_male_67_to_69', 'total_male_70_to_74', 
                 'total_male_75_to_79', 'total_male_80_to_84',
                'total_male_85_and_over', 'total_female_population', 
                'total_female_under_5', 'total_female_5_to_9', 
                'total_female_10_to_14', 'total_female_15_to_17',
                'total_female_18_and_19', 'total_female_20', 
                'total_female_21', 'total_female_22_to_24', 
                'total_female_25_to_29', 'total_female_30_to_34',
                  'total_female_35_to_39', 'total_female_40_to_44', 
                  'total_female_45_to_49', 'total_female_50_to_54',
                'total_female_55_to_59', 'total_female_60_and_61',
                'total_female_62_to_64', 'total_female_65_and_66',
                'total_female_67_to_69', 'total_female_70_to_74', 
                'total_female_75_to_79', 
                'total_female_80_to_84', 'total_female_85_and_over'],

            'poverty':['poverty_rate'],

            'general_stat_city':['ten_year_pop_growth_rate','home_p_to_income'],

            'race_ethnicity':['white_alone', 'black_or_aa_alone', 'american_indian_alaskan_alone',
                            'asian_alone',  'hawaiian_pacific_islander_alone', 'hispanic_latino']
}



# Query to check null value counts and percentage of a variable in a column

query_count_total_null = 'SELECT count(*) from '
query_population_grp_null = '(SELECT geo_id from city_population_grouping where population_group='


## Query to get all the distinct publication years - 
query_publication_year_1 = 'select distinct(publication_year) from '
query_publication_year_2 =' order by publication_year asc'



# Sample query - 
# select count(*) from means_of_transportation where drove_alone is null and geo_id in 
# (select geo_id from city_population_grouping where population_group='50,000-99,999')


pop_group_list = ["'0 to 49,999'", "'50,000-99,999'", "'100,000-249,999'", "'250,000-999,999'", "'1,000,000+'"]


column_headings = ['Year','Table','Variable','Population_Grouping','No. of Null Values',
                    'Percentage of Null Values','No. of -ve values','Percentage of -ve values']

#pop_group_wise_null_count_dict = {}
print("________________________")
print(" ")

print("Processing . ", end=' ')

## Output file name
file_to_write_output = os.path.join("E:\XREA_Project_Documents","Null_Audit_Report.csv")
        

second_temporary_info_list = []

for atable in dictionary_table_variables:

    cursor.execute(query_publication_year_1+atable+query_publication_year_2)
    years_list=cursor.fetchall()

    years_list_1 = []

    for year in years_list:
        y = int(year[0])
        years_list_1.append(y)
    

    list_of_variables = dictionary_table_variables[atable]

    ## Traversing for a year
    for year in years_list_1:

        ## traversing for each table and checking the null value amounts
        for avar in list_of_variables:
            
            total_null = 0

            for a_pop_group in pop_group_list:
                percent_null_values = 0
                percent_neg_values=0

                temporary_result_list = []

                # Sample query to get the total no. of rows containing the variable value as null and
                # falling under '50,000-99,999' city population grouping and where the publication year=2019

                # select count(*) from aggregate_travel_time where aggregate_travel_time is null 
                # and publication_year=2021 and geo_id in 
                # (select geo_id from city_population_grouping where population_group='50,000-99,999') 

                try:

                    cursor.execute(query_count_total_null+atable+' where '+avar+' IS NULL and publication_year='+str(year)+' and geo_id in '+query_population_grp_null+a_pop_group+")")
                    count_null=cursor.fetchone()[0]

                except:
                    ## This portion is not working correctly
                    try:
                        cursor.execute(query_count_total_null+atable+' where '+avar+' IS NULL and '+atable +".year=" +str(year)+' and geo_id in '+query_population_grp_null+a_pop_group+")")
                        count_null=cursor.fetchone()[0]

                    except:
                        pass
                
                #print(query_count_total_null+atable+' where '+avar+' IS NULL and publication_year='+str(year)+' and geo_id in '+query_population_grp_null+a_pop_group+")")


                # Query to get the total no. of negative variable value containing rows under 
                # '0 to 49,999' city population grouping and where the publication year=2019 -

                #select count(*) from aggregate_travel_time where aggregate_travel_time<0 and publication_year=2019 and geo_id in 
                #(select geo_id from city_population_grouping where population_group='0 to 49,999') 
                try:

                    cursor.execute(query_count_total_null+atable+' where '+avar+'<0 and publication_year='+str(year)+' and geo_id in '+query_population_grp_null+a_pop_group+")")
                    count_negative=cursor.fetchone()[0]

                except:
                    ## This portion needs to be revisited
                    try:
                        cursor.execute(query_count_total_null+atable+' where '+avar+'<0 and ' +atable +'.year='+str(year)+' and geo_id in '+query_population_grp_null+a_pop_group+")")
                        count_negative=cursor.fetchone()[0]
                    except:
                        pass 

                #print(query_count_total_null+atable+' where '+avar+'<0 and publication_year='+str(year)+' and geo_id in '+query_population_grp_null+a_pop_group+")")

                # Sample query to get the total records falling under '50,000-99,999' city population grouping 
                # and where the publication year=2019 - 

                # select count(*) from aggregate_travel_time where publication_year=2019 and geo_id in 
                # (select geo_id from city_population_grouping where population_group='50,000-99,999') 
                try:

                    cursor.execute(query_count_total_null+atable+' where publication_year='+str(year)+' and geo_id in '+query_population_grp_null+a_pop_group+")")
                    count_total_records=cursor.fetchone()[0]

                except:
                    ## This portion is not working correctly
                    try:
                        cursor.execute(query_count_total_null+atable+' where '+atable+'.year='+str(year)+' and geo_id in '+query_population_grp_null+a_pop_group+")")
                        count_total_records=cursor.fetchone()[0]

                    except:
                        pass 

                
                #print(query_count_total_null+atable+' where publication_year='+str(year)+' and geo_id in '+query_population_grp_null+a_pop_group+")")
                try:
                    percent_null_values = (count_null/count_total_records)*100
                except:
                    pass 

                try:
                    percent_neg_values = (count_negative/count_total_records)*100
                except:
                    pass 

                temporary_result_list.append(year)
                temporary_result_list.append(atable)
                temporary_result_list.append(avar)
                temporary_result_list.append(a_pop_group)
                temporary_result_list.append(count_null)
                temporary_result_list.append(percent_null_values)
                temporary_result_list.append(count_negative)
                temporary_result_list.append(percent_neg_values)

                second_temporary_info_list.append(temporary_result_list)

    print('... ', end=' ')

print(" ")



with open(file_to_write_output, 'w') as csvfile:
        
        # creating a csv writer object 
        csvwriter = csv.writer(csvfile) 
        
        # writing the fields 
        csvwriter.writerow(column_headings) 

        # writing the output data rows in the csv file
        for information in second_temporary_info_list:
            try:
                csvwriter.writerows([information])
            except:
                pass

# Closing the file
csvfile.close()

print("Finished!")

conn.close()