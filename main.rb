# Given a CSV (comma-separated values) containing historical Bitcoin trades,
# we want to represent the trades in a candlestick chart. In order to do so,
# the historical data needs to be transformed.

# The desired period will be in seconds. Assume that this value will always
# be greater than or equal to 30 seconds and less than or equal to 86400
# seconds (1 day)


# open: string Price (in KRW) at the start of the period.
# close: string Price (in KRW) at the end of the period.
# high: string Highest price (in KRW) during the period.
# low: string Lowest price (in KRW) during the period.
# start: integer Start time (in UNIX timestamp) of the period.
# end: integer End time (in UNIX timestamp) of the period.
# average: string Average price per trade (in KRW) during the period.
# weighted_average: string Weighted average price (in KRW) during the period.
# volume: string Total volume traded during the period (in BTC).

require 'csv'
require 'json'

# You will need to create a function that takes a CSV file and the desired
# period (window size) and outputs the result in JSON format.
#
# For units of KRW round to the nearest ones digit
# for units of BTC round to the nearest Satoshi

def retrieve_data_window(data_path, period)
  # The desired period will be in seconds. Assume that this value will always
  # be greater than or equal to 30 seconds and less than or equal to 86400
  # seconds (1 day).

  start_time = nil
  end_time = 0
  prices = []
  coins = []
  formatted_data = []

  CSV.foreach(data_path) do |row|
    # check for null values to prevent exceptions
    next unless row[0] && row[1] && row[2]
    # initialize a start_time
    start_time = row[0].to_i unless start_time

    if row[0].to_i - start_time > period
      # this accounts for the case where you overshoot the period
      # as a result, use up to the previous data row for calculations
      formatted_data << format_json(prices[0].round,
                                    prices[-1].round,
                                    prices.max.round,
                                    prices.min.round,
                                    start_time,
                                    end_time.to_i,
                                    calc_avg(prices),
                                    'weighted_average',
                                    btc_volume(coins))
      # need to reset values
      start_time = start_time + period
      prices = []
      coins = []
    elsif row[0].to_i - start_time == period
      # case where the end_time falls exactly on a open_time + period
      end_time = row[0]
      prices << row[1].to_i
      coins << row[2].to_f
      formatted_data << format_json(prices[0].round,
                                    prices[-1].round,
                                    prices.max.round,
                                    prices.min.round,
                                    start_time,
                                    end_time.to_i,
                                    calc_avg(prices),
                                    'weighted_average',
                                    btc_volume(coins))
      # need to reset values
      start_time = start_time + period
      prices = []
      coins = []
    end

    # accumulate CSV data
    # I do this at the end of the loop to account for overshooting the period
    end_time = row[0]
    prices << row[1].to_i
    coins << row[2].to_f
  end

  puts formatted_data.to_json
  File.open('data/data.json', 'w') do |f|
    f.write(JSON.pretty_generate(formatted_data))
  end
end

def btc_volume(coins)
  '%.8f' % (((coins.inject(:+)) * 100_000_000).round / 100_000_000.0).to_s
end

def calc_avg(prices)
  ((prices.inject(:+).to_f/prices.size).round).to_s
end

def format_json(open_price, close_price, high_price, low_price, start_time, end_time, average, weighted_average, volume)
  # open: string Price (in KRW) at the start of the period.
# close: string Price (in KRW) at the end of the period.
# high: string Highest price (in KRW) during the period.
# low: string Lowest price (in KRW) during the period.
# start: integer Start time (in UNIX timestamp) of the period.
# end: integer End time (in UNIX timestamp) of the period.
# average: string Average price per trade (in KRW) during the period.
# weighted_average: string Weighted average price (in KRW) during the period.
# volume: string Total volume traded during the period (in BTC).
  {
    open: open_price,
    close: close_price,
    high: high_price,
    low: low_price,
    start: start_time,
    end: end_time,
    average: average,
    weighted_average: weighted_average,
    volume: volume
  }
end

data_path = 'data/small.csv'
retrieve_data_window(data_path, 50_000)
