# -*- coding: utf-8 -*-
"""
Created on Mon Feb 17 19:00:20 2025

@author: Allen
"""

import pandas as pd
from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.common.keys import Keys
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
import time

# Step 1: Load country data
csv_file = 'latte_prices_standardized.csv'
countries = pd.read_csv(csv_file)

# Set up Selenium WebDriver
driver = webdriver.Chrome()  # Ensure you have ChromeDriver installed

# Country to currency mapping
country_to_currency = {
    "Brazil": "BRL",
    "Canada": "CAD",
    "United Kingdom": "GBP",
    "Japan": "JPY",
    "Mexico": "MXN",
    "India": "INR"
}

# Function to get exchange rate from DuckDuckGo
def get_exchange_rate_from_duckduckgo(country_name):
    try:
        # Convert country name to currency code if available
        currency_code = country_to_currency.get(country_name, country_name)

        # Open DuckDuckGo
        driver.get("https://duckduckgo.com/")

        # Locate and enter search query in search box
        search_box = driver.find_element(By.NAME, "q")
        search_box.clear()
        search_box.send_keys(f"1 USD to {currency_code} exchange rate")
        search_box.send_keys(Keys.RETURN)

        # Wait for results to load
        try:
            rate_element = WebDriverWait(driver, 10).until(
                EC.presence_of_element_located((By.XPATH, "//div[contains(text(),'1 USD =')]"))
            )
            exchange_rate = rate_element.text.split('=')[1].strip()
            return exchange_rate
        except:
            print(f"No exchange rate found for {country_name}")
            return None

    except Exception as e:
        print(f"Error fetching exchange rate for {country_name}: {e}")
        return None

# Loop through each country and fetch exchange rates
exchange_rates = []
for _, row in countries.iterrows():
    country_name = row['Country']
    print(f"Fetching exchange rate for {country_name}...")
    rate = get_exchange_rate_from_duckduckgo(country_name)
    exchange_rates.append({'Country': country_name, 'Exchange Rate': rate})

# Save results to CSV
df_exchange_rates = pd.DataFrame(exchange_rates)
output_file = 'exchange_rates_duckduckgo.csv'
df_exchange_rates.to_csv(output_file, index=False)
print(f"Exchange rates saved to {output_file}")

# Close Selenium WebDriver
driver.quit()
