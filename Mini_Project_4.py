import requests
import pandas as pd
import json

# BLS API Key
API_KEY = "6fd7ac1fe1a549f4a266fdbad98850d9"

# Define BLS Series ID for Unemployment Rate (National Level)
# This series ID is for "Unemployment Rate (Seasonally Adjusted), 16 years and over"
SERIES_ID = "LNS14000000"

# Define API URL
BLS_URL = "https://api.bls.gov/publicAPI/v2/timeseries/data/"

# Set Parameters for API Request
params = {
    "seriesid": [SERIES_ID], 
    "startyear": "2000",  # Adjust years as needed
    "endyear": "2024",
    "registrationkey": API_KEY
}

# Make the API Request
response = requests.post(BLS_URL, json=params)

# Parse the JSON response
data = response.json()
# Extract the unemployment rate data
records = []
for series in data['Results']['series']:
    series_id = series['seriesID']
    for item in series['data']:
        year = item['year']
        period = item['period']
        if "M" in period:  # Ensures we only get monthly data (ignores annual)
            month = int(period.replace("M", ""))
            value = float(item['value'])  # Unemployment rate
            records.append([series_id, year, month, value])

# Create a DataFrame
df = pd.DataFrame(records, columns=["Series ID", "Year", "Month", "Unemployment Rate"])

# Convert Year-Month into Date format
df['Date'] = pd.to_datetime(df[['Year', 'Month']].assign(day=1))

# Drop unnecessary columns
df = df[['Date', 'Unemployment Rate']]
print(df)
# Save to CSV for Tableau
csv_filename = "unemployment_rate.csv"
df.to_csv(csv_filename, index=False)
