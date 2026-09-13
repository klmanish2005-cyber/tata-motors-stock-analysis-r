# Tata Motors Stock Market Analysis Using R

## Project Overview

This project focuses on analyzing the historical stock market performance of Tata Motors using R.

The project uses historical Tata Motors stock price data to understand price movements, returns, trading volume, volatility, moving averages, drawdowns, annual performance, and short-term price forecasting.

An ARIMA time-series model is also used to forecast Tata Motors' closing price for the next 30 trading days.

---

## Objectives

The main objectives of this project are:

1. Analyze the historical stock price movement of Tata Motors.
2. Understand daily stock returns and price fluctuations.
3. Analyze trading volume over time.
4. Calculate and study moving averages.
5. Measure stock volatility and drawdown.
6. Compare annual stock performance.
7. Analyze monthly price trends.
8. Forecast the next 30 trading days using an ARIMA model.

---

## Dataset

The project uses historical Tata Motors stock market data.

The main dataset contains the following variables:

| Variable | Description |
|---|---|
| Date | Trading date |
| Open | Opening stock price |
| High | Highest price during the trading day |
| Low | Lowest price during the trading day |
| Close | Closing stock price |
| Adj Close | Adjusted closing price |
| Volume | Number of shares traded |

The analysis mainly uses the **Close** price to study Tata Motors' historical price behaviour.

---

## Data Analysis

The project performs the following analysis:

### 1. Data Cleaning

The data is prepared by:

- Converting dates into the correct date format
- Converting price and volume columns into numeric format
- Removing missing closing-price observations
- Sorting the data chronologically

### 2. Feature Engineering

Additional variables are calculated, including:

- Daily Return
- Year
- Month
- Year-Month
- Day Range
- Intraday Return
- 20-Day Moving Average
- 50-Day Moving Average
- 200-Day Moving Average
- Rolling Volatility
- Running Peak
- Drawdown

---

## Visualizations

The project contains 9 visualizations:

### 1. Tata Motors Price Trend

`01_price_trend.png`

Shows the historical movement of Tata Motors' closing stock price.

### 2. Moving Averages

`02_moving_averages.png`

Compares the stock price with 20-day, 50-day, and 200-day moving averages.

### 3. Daily Returns

`03_daily_returns.png`

Shows the daily percentage changes in Tata Motors' stock price.

### 4. Trading Volume

`04_trading_volume.png`

Shows changes in the number of shares traded over time.

### 5. Annual Returns

`05_annual_returns.png`

Compares Tata Motors' stock performance across different years.

### 6. Volatility

`06_volatility.png`

Shows changes in rolling stock-price volatility.

### 7. Drawdown

`07_drawdown.png`

Shows the decline in stock price from its previous running peak.

### 8. Monthly Average Price

`08_monthly_price.png`

Shows the monthly average closing price over time.

### 9. ARIMA Forecast

`09_arima_forecast.png`

Shows the 30-day stock price forecast generated using the ARIMA model.

---

## ARIMA Forecasting

The project uses an **ARIMA (AutoRegressive Integrated Moving Average)** model for time-series forecasting.

The model uses recent historical Tata Motors closing-price data to generate a forecast for the next **30 trading days**.

The forecast output contains:

- Forecasted price
- 80% prediction interval
- 95% prediction interval

The forecast results are stored in:

`30_day_arima_forecast.csv`

The forecast visualization is stored in:

`09_arima_forecast.png`

### Important Note

The ARIMA forecast is created for educational and analytical purposes. It is a statistical estimate based on historical data and should not be considered financial advice or a guaranteed prediction of future stock prices.

---

## Project Files

The repository currently contains the following files:

### R Analysis

`Tata_Motors_Analysis.R`

This is the main R script containing the complete project workflow, including:

- Data loading
- Data cleaning
- Feature engineering
- Statistical analysis
- Data visualization
- ARIMA forecasting

### Historical Dataset

`tata_motors_historical.csv`

Original historical Tata Motors stock market dataset.

### Cleaned Dataset

`tata_motors_analysis_ready.csv`

Processed dataset containing the analytical variables created during the project.

### Annual Performance

`annual_performance.csv`

Contains annual stock performance calculations.

### Monthly Summary

`monthly_summary.csv`

Contains monthly stock-price summary information available in the project dataset.

### Forecast Dataset

`30_day_arima_forecast.csv`

Contains the 30-day ARIMA forecast results.

### Visualization Files

- `01_price_trend.png`
- `02_moving_averages.png`
- `03_daily_returns.png`
- `04_trading_volume.png`
- `05_annual_returns.png`
- `06_volatility.png`
- `07_drawdown.png`
- `08_monthly_price.png`
- `09_arima_forecast.png`

---

## Technologies Used

- R
- RStudio
- readr
- dplyr
- ggplot2
- zoo
- forecast
- GitHub

---

## R Packages Used

### readr

Used for reading and writing CSV datasets.

### dplyr

Used for data manipulation, grouping and summarization.

### ggplot2

Used for creating data visualizations.

### zoo

Used for moving averages and rolling volatility calculations.

### forecast

Used for ARIMA time-series forecasting.

---

## How to Run the Project

### Step 1

Install R and RStudio.

### Step 2

Download or clone this GitHub repository.

### Step 3

Open:

`Tata_Motors_Analysis.R`

in RStudio.

### Step 4

Make sure the project folder contains the required CSV dataset.

### Step 5

Run the complete R script.

The script performs the analysis and generates the required output files and visualizations.

---

## Key Business Questions

This project helps answer questions such as:

- How has Tata Motors' stock price changed over time?
- What are the major price trends?
- How frequently does the stock price fluctuate?
- What is the average daily return?
- Which years performed better?
- How does trading volume change over time?
- What do the moving averages indicate?
- What are the major drawdown periods?
- How volatile is Tata Motors stock?
- What does the ARIMA model forecast for the next 30 trading days?

---

## Project Outcome

The project provides a complete data analytics workflow for Tata Motors stock market data.

It combines:

**Data → Cleaning → Feature Engineering → Statistical Analysis → Visualization → Time-Series Forecasting**

The project demonstrates how R can be used to analyze real-world financial data and build a basic forecasting model.

---

## Future Scope

The project can be further improved by adding:

- Random Forest forecasting
- XGBoost forecasting
- LSTM deep learning models
- RSI and MACD technical indicators
- Tata Motors news sentiment analysis
- Comparison with other automobile companies
- Comparison with NIFTY Auto Index
- Interactive dashboard using Shiny
- Real-time market data analysis

---

## Author

**KL Manish**

Data Analytics Project using R

---

## Disclaimer

This project is created for educational and academic purposes.

The analysis and forecasts are based on historical market data. Past performance does not guarantee future results, and the forecast should not be considered financial or investment advice.
