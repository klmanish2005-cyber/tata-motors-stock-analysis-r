# ============================================================
# TATA MOTORS STOCK MARKET DATA ANALYSIS USING R
# Complete Project - Single File
# ============================================================

# ============================================================
# STEP 1: SET PROJECT FOLDER
# ============================================================

setwd("C:/DATA ANALYTICS/r studio/tata-motors-stock-analysis-R")

cat("Project folder:\n")
print(getwd())


# ============================================================
# STEP 2: INSTALL AND LOAD REQUIRED PACKAGES
# ============================================================

packages <- c(
  "readr",
  "dplyr",
  "ggplot2",
  "zoo",
  "forecast"
)

for (package in packages) {
  if (!require(package, character.only = TRUE)) {
    install.packages(package)
    library(package, character.only = TRUE)
  }
}


# ============================================================
# STEP 3: LOAD REAL TATA MOTORS DATA
# ============================================================

data_file <- "data/tata_motors_historical.csv"

if (!file.exists(data_file)) {
  stop("ERROR: tata_motors_historical.csv was not found inside the data folder.")
}

data <- read_csv(
  data_file,
  show_col_types = FALSE
)

cat("\n============================================\n")
cat("TATA MOTORS DATA LOADED\n")
cat("============================================\n")

cat("Rows:", nrow(data), "\n")
cat("Columns:", ncol(data), "\n")


# ============================================================
# STEP 4: CLEAN THE DATA
# ============================================================

data$Date <- as.Date(data$Date)

data$Open <- as.numeric(as.character(data$Open))
data$High <- as.numeric(as.character(data$High))
data$Low <- as.numeric(as.character(data$Low))
data$Close <- as.numeric(as.character(data$Close))

# The original dataset contains "Adj Close".
# We do not need it for this project.
# Close price will be used for the analysis.

data$Volume <- as.numeric(as.character(data$Volume))

# Remove rows where Close is missing

data <- data[!is.na(data$Close), ]

# Sort data by date

data <- data[order(data$Date), ]

cat("\nData cleaning completed.\n")
cat("Usable observations:", nrow(data), "\n")


# ============================================================
# STEP 5: CREATE ANALYTICAL VARIABLES
# ============================================================

# Daily percentage return

data$Daily_Return <- c(
  NA,
  diff(data$Close) / head(data$Close, -1) * 100
)

# Year

data$Year <- as.numeric(format(data$Date, "%Y"))

# Month

data$Month <- format(data$Date, "%m")

# Year-Month

data$Year_Month <- format(data$Date, "%Y-%m")

# Daily price range

data$Day_Range <- data$High - data$Low

# Intraday return

data$Intraday_Return <- (
  data$Close - data$Open
) / data$Open * 100

# 20-day moving average

data$MA_20 <- zoo::rollmean(
  data$Close,
  k = 20,
  fill = NA,
  align = "right"
)

# 50-day moving average

data$MA_50 <- zoo::rollmean(
  data$Close,
  k = 50,
  fill = NA,
  align = "right"
)

# 200-day moving average

data$MA_200 <- zoo::rollmean(
  data$Close,
  k = 200,
  fill = NA,
  align = "right"
)

# 20-day rolling volatility

data$Rolling_Volatility <- zoo::rollapply(
  data$Daily_Return,
  width = 20,
  FUN = sd,
  fill = NA,
  align = "right",
  na.rm = TRUE
)

# Running highest price

data$Running_Peak <- cummax(data$Close)

# Drawdown

data$Drawdown <- (
  data$Close - data$Running_Peak
) / data$Running_Peak * 100


# ============================================================
# STEP 6: SAVE CLEANED DATA
# ============================================================

write_csv(
  data,
  "data/tata_motors_analysis_ready.csv"
)

cat("\nCleaned analytical dataset saved.\n")


# ============================================================
# STEP 7: BASIC STATISTICS
# ============================================================

cat("\n============================================\n")
cat("BASIC STATISTICS\n")
cat("============================================\n")

cat("Number of observations:", nrow(data), "\n")
cat("Number of variables:", ncol(data), "\n")

cat("Start date:", min(data$Date), "\n")
cat("End date:", max(data$Date), "\n")

cat("\nCLOSING PRICE STATISTICS\n")

cat("Lowest Close:", round(min(data$Close, na.rm = TRUE), 2), "\n")

cat("Highest Close:", round(max(data$Close, na.rm = TRUE), 2), "\n")

cat("Average Close:", round(mean(data$Close, na.rm = TRUE), 2), "\n")

cat("Median Close:", round(median(data$Close, na.rm = TRUE), 2), "\n")

cat(
  "Standard Deviation:",
  round(sd(data$Close, na.rm = TRUE), 2),
  "\n"
)

cat("\nDAILY RETURN STATISTICS\n")

cat(
  "Average Daily Return:",
  round(mean(data$Daily_Return, na.rm = TRUE), 4),
  "%\n"
)

cat(
  "Daily Return Standard Deviation:",
  round(sd(data$Daily_Return, na.rm = TRUE), 4),
  "%\n"
)

cat(
  "Best Daily Return:",
  round(max(data$Daily_Return, na.rm = TRUE), 2),
  "%\n"
)

cat(
  "Worst Daily Return:",
  round(min(data$Daily_Return, na.rm = TRUE), 2),
  "%\n"
)

cat("\nVOLUME STATISTICS\n")

cat(
  "Average Volume:",
  round(mean(data$Volume, na.rm = TRUE), 0),
  "\n"
)

cat(
  "Highest Volume:",
  round(max(data$Volume, na.rm = TRUE), 0),
  "\n"
)

cat("\nRISK STATISTICS\n")

cat(
  "Maximum Drawdown:",
  round(min(data$Drawdown, na.rm = TRUE), 2),
  "%\n"
)

cat(
  "Average Rolling Volatility:",
  round(mean(data$Rolling_Volatility, na.rm = TRUE), 4),
  "%\n"
)


# ============================================================
# STEP 8: ANNUAL PERFORMANCE
# ============================================================

annual_performance <- data %>%
  group_by(Year) %>%
  summarise(
    Start_Price = first(Close),
    End_Price = last(Close),
    Annual_Return = (
      (last(Close) - first(Close)) /
        first(Close)
    ) * 100,
    Average_Price = mean(Close, na.rm = TRUE),
    Average_Volume = mean(Volume, na.rm = TRUE),
    .groups = "drop"
  )

write_csv(
  annual_performance,
  "data/annual_performance.csv"
)

cat("\n============================================\n")
cat("ANNUAL PERFORMANCE\n")
cat("============================================\n")

print(annual_performance)

best_year <- annual_performance$Year[
  which.max(annual_performance$Annual_Return)
]

cat(
  "\nBest performing year:",
  best_year,
  "\n"
)


# ============================================================
# STEP 9: CREATE PLOTS FOLDER
# ============================================================

if (!dir.exists("plots")) {
  dir.create("plots")
}

cat("\nCreating visualizations...\n")


# ============================================================
# STEP 10: PRICE TREND
# ============================================================

p1 <- ggplot(
  data,
  aes(x = Date, y = Close)
) +
  geom_line() +
  labs(
    title = "Tata Motors Stock Price Trend",
    x = "Date",
    y = "Closing Price"
  ) +
  theme_minimal()

ggsave(
  "plots/01_price_trend.png",
  p1,
  width = 10,
  height = 6
)


# ============================================================
# STEP 11: MOVING AVERAGES
# ============================================================

p2 <- ggplot(
  data,
  aes(x = Date)
) +
  geom_line(
    aes(y = Close),
    alpha = 0.5
  ) +
  geom_line(
    aes(y = MA_20)
  ) +
  geom_line(
    aes(y = MA_50)
  ) +
  geom_line(
    aes(y = MA_200)
  ) +
  labs(
    title = "Tata Motors Price with Moving Averages",
    x = "Date",
    y = "Price"
  ) +
  theme_minimal()

ggsave(
  "plots/02_moving_averages.png",
  p2,
  width = 10,
  height = 6
)


# ============================================================
# STEP 12: DAILY RETURNS
# ============================================================

p3 <- ggplot(
  data,
  aes(x = Date, y = Daily_Return)
) +
  geom_line() +
  labs(
    title = "Tata Motors Daily Returns",
    x = "Date",
    y = "Daily Return (%)"
  ) +
  theme_minimal()

ggsave(
  "plots/03_daily_returns.png",
  p3,
  width = 10,
  height = 6
)


# ============================================================
# STEP 13: TRADING VOLUME
# ============================================================

p4 <- ggplot(
  data,
  aes(x = Date, y = Volume)
) +
  geom_line() +
  labs(
    title = "Tata Motors Trading Volume",
    x = "Date",
    y = "Volume"
  ) +
  theme_minimal()

ggsave(
  "plots/04_trading_volume.png",
  p4,
  width = 10,
  height = 6
)


# ============================================================
# STEP 14: ANNUAL RETURNS
# ============================================================

p5 <- ggplot(
  annual_performance,
  aes(
    x = factor(Year),
    y = Annual_Return
  )
) +
  geom_col() +
  labs(
    title = "Tata Motors Annual Returns",
    x = "Year",
    y = "Annual Return (%)"
  ) +
  theme_minimal()

ggsave(
  "plots/05_annual_returns.png",
  p5,
  width = 10,
  height = 6
)


# ============================================================
# STEP 15: VOLATILITY
# ============================================================

p6 <- ggplot(
  data,
  aes(
    x = Date,
    y = Rolling_Volatility
  )
) +
  geom_line() +
  labs(
    title = "Tata Motors Rolling Volatility",
    x = "Date",
    y = "Volatility"
  ) +
  theme_minimal()

ggsave(
  "plots/06_volatility.png",
  p6,
  width = 10,
  height = 6
)


# ============================================================
# STEP 16: DRAWDOWN
# ============================================================

p7 <- ggplot(
  data,
  aes(
    x = Date,
    y = Drawdown
  )
) +
  geom_line() +
  labs(
    title = "Tata Motors Drawdown Analysis",
    x = "Date",
    y = "Drawdown (%)"
  ) +
  theme_minimal()

ggsave(
  "plots/07_drawdown.png",
  p7,
  width = 10,
  height = 6
)


# ============================================================
# STEP 17: MONTHLY PRICE
# ============================================================

monthly_price <- data %>%
  group_by(Year_Month) %>%
  summarise(
    Average_Price = mean(Close, na.rm = TRUE),
    .groups = "drop"
  )

p8 <- ggplot(
  monthly_price,
  aes(
    x = Year_Month,
    y = Average_Price,
    group = 1
  )
) +
  geom_line() +
  labs(
    title = "Tata Motors Monthly Average Price",
    x = "Year-Month",
    y = "Average Closing Price"
  ) +
  theme_minimal() +
  theme(
    axis.text.x = element_text(
      angle = 90,
      hjust = 1
    )
  )

ggsave(
  "plots/08_monthly_price.png",
  p8,
  width = 12,
  height = 6
)


# ============================================================
# STEP 18: ARIMA FORECASTING
# ============================================================

cat("\n============================================\n")
cat("BUILDING ARIMA FORECAST MODEL\n")
cat("============================================\n")

# Use recent 3 years

latest_date <- max(data$Date)

start_date <- latest_date - 365 * 3

recent <- data[
  data$Date >= start_date,
]

recent <- recent[
  !is.na(recent$Close),
]

cat(
  "Forecasting observations:",
  nrow(recent),
  "\n"
)

cat(
  "Forecasting from:",
  min(recent$Date),
  "\n"
)

cat(
  "Forecasting to:",
  max(recent$Date),
  "\n"
)

# Create time series using CLOSE price

price_ts <- ts(
  recent$Close,
  frequency = 252
)

cat("\nBuilding ARIMA model...\n")

model <- auto.arima(
  price_ts,
  seasonal = FALSE
)

cat("\nARIMA MODEL:\n")

print(model)


# ============================================================
# STEP 19: 30-DAY FORECAST
# ============================================================

forecast_result <- forecast(
  model,
  h = 30
)

forecast_data <- data.frame(
  Forecast_Day = 1:30,
  Forecast_Price =
    as.numeric(forecast_result$mean),
  Lower_80 =
    as.numeric(forecast_result$lower[, 1]),
  Upper_80 =
    as.numeric(forecast_result$upper[, 1]),
  Lower_95 =
    as.numeric(forecast_result$lower[, 2]),
  Upper_95 =
    as.numeric(forecast_result$upper[, 2])
)

write_csv(
  forecast_data,
  "data/30_day_arima_forecast.csv"
)

cat("\n30-DAY FORECAST:\n")

print(forecast_data)


# ============================================================
# STEP 20: SAVE FORECAST GRAPH
# ============================================================

png(
  "plots/09_arima_forecast.png",
  width = 1200,
  height = 700
)

plot(
  forecast_result,
  main =
    "Tata Motors 30-Day Stock Price Forecast",
  xlab = "Time",
  ylab = "Closing Price"
)

dev.off()


# ============================================================
# STEP 21: FINAL PROJECT OUTPUT
# ============================================================

cat("\n\n")
cat("====================================================\n")
cat("       TATA MOTORS DATA ANALYTICS PROJECT\n")
cat("              COMPLETED SUCCESSFULLY\n")
cat("====================================================\n")

cat("\nFiles created:\n")

cat("\n1. Cleaned dataset:\n")
cat("   data/tata_motors_analysis_ready.csv\n")

cat("\n2. Annual performance:\n")
cat("   data/annual_performance.csv\n")

cat("\n3. 30-day ARIMA forecast:\n")
cat("   data/30_day_arima_forecast.csv\n")

cat("\n4. Visualizations:\n")
cat("   plots/01_price_trend.png\n")
cat("   plots/02_moving_averages.png\n")
cat("   plots/03_daily_returns.png\n")
cat("   plots/04_trading_volume.png\n")
cat("   plots/05_annual_returns.png\n")
cat("   plots/06_volatility.png\n")
cat("   plots/07_drawdown.png\n")
cat("   plots/08_monthly_price.png\n")
cat("   plots/09_arima_forecast.png\n")

cat("\n====================================================\n")
cat("PROJECT FINISHED\n")
cat("====================================================\n")
