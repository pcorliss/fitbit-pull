Fitbit JSON Parser
==================

Just a quick script to convert the JSON from [Fitbit's time-series API](https://wiki.fitbit.com/display/API/API-Get-Time-Series) into a CSV for importing and processing.

Getting the Data
----------------

```
gem install bundler
bundle install
ruby fitbit_data_to_csv.rb output.csv <YOUR_CONSUMER_KEY> <YOUR_CONSUMER_SECRET> [DEBUG_MODE]
```

Maybe I'll add in a Web GUI later on for ease of use.
