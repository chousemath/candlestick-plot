# Candlestick Chart

## Introduction

1. This is both a programming and a design test. Note down the assumptions you make.

2. You are free to choose any language from the list and code

    * Java

    * Javascript

    * Ruby

    * Scala

    * C/C++

    * Python

3. It is okay to use reference language documentation or use an IDE that has code completion features. However it is not acceptable to consult/copy code from any source including a website, book, or friend/colleague to complete these tests.



## Submission instructions

1. Clone this repository on your local computer using the `git clone` command in the terminal.  Enter your GitHub username and password when prompted.
```
$ git clone https://github.com/korbitdev/candlestick-chart-problem-[your GitHub username].git
```

2. Commit and push your code
```
$ git add .
$ git commit -m "Your commit message"
$ git push origin master
```



## Problem description

Given a CSV (comma-separated values) containing historical Bitcoin trades, we want to represent the trades in a [candlestick chart](https://en.wikipedia.org/wiki/Candlestick_chart). In order to do so, the historical data needs to be transformed.

You will need to create a function that takes a CSV file and the desired period (window size) and outputs the result in JSON format. 


### Input format

CSV file `trades.csv` ([http://api.bitcoincharts.com/v1/csv/korbitKRW.csv.gz](http://api.bitcoincharts.com/v1/csv/korbitKRW.csv.gz)) containing *N* trades in the following format:

`timestamp,price,size`

where:

* timestamp: Time where the trade got filled in UNIX time.

* price: Price of the trade in Korean Won (KRW).

* size: Size of the trade in Bitcoins (BTC).

##### sample CSV file:
```
timestamp,price,size
1383037954,227000,0.30000000
1383038122,245000,1.19300000
1383038122,250000,0.30020000
1383038122,250000,2.00000000
1383038169,259000,0.09700000
1383038169,259000,1.90300000
1383059294,230000,0.69000000
1383059458,230000,0.31000000
1383059491,259000,0.09700000
1383059658,259500,3.00000000
1383059737,260000,5.00000000
1383067046,220000,0.15000000
1383089545,269500,1.00000000
1383089648,269500,1.00000000
1383091563,269500,1.00000000
1383091580,269500,0.76000000
1383091581,270000,4.24000000
1383091594,270000,0.76000000
1383091621,279000,1.80000000
1383092762,279000,0.20000000
1383092780,280000,0.20000000
1383092780,280000,0.80000000
1383094787,279000,6.60000000
1383102079,245000,1.02000000
1383102211,245000,0.98000000
1383102509,250000,2.00000000
1383104598,230000,0.10000000
```
 

* The desired period will be in seconds.  Assume that this value will always be greater than or equal to 30 seconds and less than or equal to 86400 seconds (1 day).

 

### Output format

* JSON Array

 

The output should be a list containing:

* open: `string` Price (in KRW) at the start of the period.

* close: `string` Price (in KRW) at the end of the period.

* high: `string` Highest price (in KRW) during the period.

* low: `string` Lowest price (in KRW) during the period.

* start: `integer` Start time (in UNIX timestamp) of the period.

* end: `integer` End time (in UNIX timestamp) of the period.

* average: `string` Average price per trade (in KRW) during the period.

* weighted_average: `string` Weighted average price (in KRW) during the period.

* volume: `string` Total volume traded during the period (in BTC).

 

## Design considerations

* Assume that you already have a CSV parsing library. You do not have to write the parser.

* For units of KRW round to the nearest ones digit, for units of BTC round to the nearest [Satoshi](https://en.bitcoin.it/wiki/Satoshi_(unit)).

* Write down any assumptions you make and be ready to discuss them with us.

* A code that works is the main goal.  Optimize only when you have time left.

 
##### Sample input:
```
1383038122,250000,2.00000000
1383038169,254000,0.09700000
1383038169,259000,1.90300000
1383038233,251000,1.39100000
```

##### Sample output for period of 30 seconds:
```
[{
  "start": 1383038122,
  "end": 1383038151,
  "open": "250000",
  "close": "250000",
  "high": "250000",
  "low": "250000",
  "average": "250000",
  "weighted_average": "250000",
  "volume": "2.00000000"
}, {
  "start": 1383038152,
  "end": 1383038181,
  "open": "254000",
  "close": "259000",
  "high": "259000",
  "low": "254000",
  "average": "256500",
  "weighted_average": "258,758",
  "volume": "2.00000000"
}, {
  "start": 1383038182,
  "end": 1383038211,
  "open": null,
  "close": null,
  "high": null,
  "low": null,
  "average": null,
  "weighted_average": null,
  "volume": "0.00000000"
}, {
  "start": 1383038212,
  "end": 1383038241,
  "open": "251000",
  "close": "251000",
  "high": "251000",
  "low": "251000",
  "average": "251000",
  "weighted_average": "251000",
  "volume": "1.39100000"
}]
```


 

