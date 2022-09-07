from selenium import webdriver
from selenium.webdriver.common.keys import Keys
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
from selenium.webdriver.common.by import By
from selenium.webdriver.common.action_chains import ActionChains
import time
import pandas as pd
import numpy as np
import regex as re
import requests
import os
import sys
from io import StringIO
import pymongo

# Set up mongodb connection:
client = pymongo.MongoClient("mongodb+srv://Jiaming:jiaming@jifeng.5dnvo.mongodb.net/?retryWrites=true&w=majority")
db = client.JiFeng
con = db.ILthermo

def extract_data_table():
    '''
    Extract experimental data table on the right side.
    '''
    data_first_row = driver.find_element(By.XPATH, '//*[@id="dsdata_pane"]/table[2]/tr[1]').text
    data_not_first_row = driver.find_element(By.XPATH, '//*[@id="dsdata_pane"]/table[2]').text[len(data_first_row):]
    data_not_first_row = re.sub("±", " ", data_not_first_row)
    df = pd.read_csv(StringIO(data_not_first_row), sep=' +', header=None, engine='python')
    num_cols = df.shape[1] - 1

    names_cols = []
    for i in range(num_cols):
        names_cols.append(driver.find_element(By.XPATH, '//*[@id="dsdata_pane"]/table[2]/tr[1]/th[{}]'.format(i+1)).text)
    names_cols.append("Error")
    df.columns = names_cols
    
    return df

def extract_component_table( ):
    '''
    requires: get_smiles function.
    
    return component table as dataframe, and save structure images to images folder in current folder.
    '''
    if not os.path.exists('./images'):
        os.mkdir("./images")
        
    names_cols = ['Component', 'Name', 'Formula', 'Mol weight', 'SMILES', 'Structure']
    ## Number of components. use for image saving loop.
    num_rows = len(re.findall("\n", driver.find_element(By.XPATH, "//*[@id='dscomp_pane']/table").text))
    component_matrix = []

    for i in range(num_rows):
        component_row = []
        for j in range(4):
            component_row.append(driver.find_element( By.XPATH, "//*[@id='dscomp_pane']/table/tr[{}]/td[{}]".format(i+2, j+1)).text)


        img_url = driver.find_element(By.XPATH, "//*[@id='dscomp_pane']/table/tr[{}]/td[5]/input".format(i+2)).get_attribute("src")
        img_name = re.split('=',img_url)[-1]

        ## Avoiding save if exists duplicated file.
        if not os.path.exists('./images/{}.jpeg'.format(img_name)):
            img = requests.get(img_url, headers={'user-agent':'Chrome/16.0'}, timeout=30)

            with open('./images/{}.jpeg'.format(img_name), 'wb') as imgf:
                imgf.write(img.content)
                
        component_row.append(get_smiles(component_row[1] ))
        component_row.append(img_url)
        component_matrix.append(component_row)
    
    df = pd.DataFrame(component_matrix, columns=names_cols)
    
    return df

def get_smiles(chemical_name):
    '''
    This function require "requests" package to run. 
    :param chemical_name: chemical name, alphanumeric,.
    
    '''
    smiles = []
    for i in chemical_name.split(" "):
        r = requests.get("https://pubchem.ncbi.nlm.nih.gov/rest/pug/compound/name/%s/property/CanonicalSMILES/txt"%i)
        
        if r.status_code == 200:
            smiles.append(r.content.decode('ascii').strip())
        else:
            smiles.append("None")
    return '.'.join(smiles)

def extract_reference():
    '''
    return title and reference of data.
    '''
    return driver.find_element(By.ID, "refview").text.split('\n')[1:]  

if __name__ == '__main__':

    chrome_options = webdriver.ChromeOptions()
    chrome_options.add_argument('--headless')
    chrome_options.add_argument('--no-sandbox')

    driver = webdriver.Chrome(options=chrome_options, service_args = ['--verbose', '--log-path=./chromedriver.log'])
    url = "https://ilthermo.boulder.nist.gov"
    driver.get(url)

    IL_name = "a"

    ## Pull up search results by key_words.
    search_box = driver.find_element(By.ID, 'sbutton_label')
    search_box.click()

    IL_search_box = driver.find_element(By.ID, "cmp")
    IL_search_box.send_keys(IL_name)

    IL_search_button = driver.find_element(By.XPATH, "/html/body/div[4]/div[2]/div[2]/span[1]")
    IL_search_button.click()

    time.sleep(30)

    
    ## Calculate number of pages would be looping through
    num_pages = int(driver.find_element(By.XPATH, '//*[@id="dsgrid"]/div[4]/div/div[2]/span[2]/span[5]').text)
    count = 0

    ## Resize data panel.
    driver.maximize_window()
    split_bar_id = "gridholder_splitter"
    split_bar = driver.find_element(By.ID, split_bar_id)
    time.sleep(2)
    action = ActionChains(driver)
    action.drag_and_drop_by_offset(split_bar, -500, 0).perform()

    ## Looping each row in the left table.
    next_page_locator = [2,3,4,5,6] + list(np.repeat(6, num_pages))

    for page in range(num_pages):

        if page % 10 == 0:
            print("{} out of {}.".format(page, num_pages))
        ## Find all rows.
        IL_rows = driver.find_elements(By.XPATH, '//*[contains(@id, "dsgrid-row-")]')

        for i, IL_row in enumerate(IL_rows):

            IL_row.click()
            time.sleep(3)
            ## Get info from left table
            t = re.sub("\) ", ")\n", IL_row.text).split('\n')
            ## Get title and reference.
            title, reference = extract_reference()
            ## extract basic information for each component:
            comp_table = extract_component_table().to_dict(orient = 'records')
            #print(comp_table)
            ## Make sure list contains three elements.
            if len(comp_table) == 1:
                comp_table.append({'Name':'None'})
                comp_table.append({'Name':'None'})
            elif len(comp_table) == 2:
                comp_table.append({'Name':'None'})
                
            ## Extract Data table:
            data_table = extract_data_table().to_dict(orient = 'records')
            
            
            ## define post array.        
            post_array = {"_id": count, "ref": t[0], "property": t[1], "phase": t[2], "datapoints": t[3],
                         "title": title, "reference": reference, 
                          "component 1": comp_table[0],
                          "component 2": comp_table[1],
                          "component 3": comp_table[2],
                          "data": data_table}
            try:
                con.insert_one(post_array)
                count += 1
            except pymongo.errors.DuplicateKeyError:
                count += 1
                print("{} skip due to DuplicateKeyError".format(count))
            #print(count)
            #print(extract_component_table())



        next_page_button = driver.find_element(By.XPATH, '//*[@id="dsgrid"]/div[4]/div/div[2]/span[2]/span[{}]'.format(next_page_locator[page]))
        next_page_button.click()


