require 'csv'
require 'json'

def retrieve_data_window(data_path, period)
  start_time = nil # will be initialized at the start of the loop
  end_time = 0
  prices = [] # contains all the prices over a period
  coins = [] # contains all btc trade volumes over a period
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
                                    calc_weighted_avg(prices, coins),
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
                                    calc_weighted_avg(prices, coins),
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

  puts "Please check the data folder!"
  File.open('data/data.json', 'w') do |f|
    f.write(JSON.pretty_generate(formatted_data))
  end
end

def btc_volume(coins)
  # for units of BTC round to the nearest Satoshi
  '%.8f' % (((coins.inject(:+)) * 100_000_000).round / 100_000_000.0).to_s
end

def calc_avg(prices)
  # For units of KRW round to the nearest ones digit
  ((prices.inject(:+).to_f/prices.size).round).to_s
end

def calc_weighted_avg(prices, coins)
  # I am making the assumption that the weight average is calculated by considering
  # the btc trade volume for any particular day relative to the total btc trade volume
  # over the period of time
  total_btc = coins.inject(:+)
  # multiply each price by its btc weight
  weighted_prices = prices.each_with_index.map { |x, i| x * coins[i]/total_btc }
  weighted_prices.inject(:+).round.to_s
end

def format_json(open_price, close_price, high_price, low_price, start_time, end_time, average, weighted_average, volume)
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
retrieve_data_window(data_path, 82_000)
