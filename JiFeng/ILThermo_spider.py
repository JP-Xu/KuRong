from selenium import webdriver
from selenium.webdriver.common.keys import Keys
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
from selenium.webdriver.common.by import By
import time

# url = "https://ilthermo.boulder.nist.gov/"
url = "https://www.techwithtim.net/"

driver = webdriver.Chrome()
driver.get(url)

print(driver.title) ## Print webpage title.

## Locating elements from HTML:
search_bar = driver.find_element_by_name("s")
search_bar.send_keys("test")
search_bar.send_keys(Keys.RETURN)

#print(driver.page_source)

try:
    main = WebDriverWait(driver, 10).until(
        EC.presence_of_element_located((By.ID, "main"))
    )

    articles = main.find_elements_by_tag_name("article")
    for article in articles:
        header = article.find_element_by_class_name("entry-summary")
        print(header.text)

except:
    driver.quit()


driver.close()  ## Close one tab
time.sleep(5)
driver.quit()  ## Close chrome program