require 'json'
require 'csv'
require 'date'
require 'fitgem'

module Fitgem
  class Client
    BODY_SERIES = %w(
      body/weight
      body/bmi
      body/fat
    )

    SLEEP_SERIES = %w(
      sleep/startTime
      sleep/timeInBed
      sleep/minutesAsleep
      sleep/awakeningsCount
      sleep/minutesAwake
      sleep/minutesToFallAsleep
      sleep/minutesAfterWakeup
      sleep/efficiency
    )

    ACTIVITY_SERIES = %w(
      activities/calories
      activities/caloriesBMR
      activities/steps
      activities/distance
      activities/floors
      activities/minutesSedentary
      activities/minutesLightlyActive
      activities/minutesFairlyActive
      activities/minutesVeryActive
      activities/activityCalories
      activities/tracker/calories
      activities/tracker/steps
      activities/tracker/distance
      activities/tracker/floors
      activities/tracker/elevation
      activities/tracker/minutesSedentary
      activities/tracker/minutesLightlyActive
      activities/tracker/minutesFairlyActive
      activities/tracker/minutesVeryActive
      activities/tracker/activityCalories
    )

    FOOD_SERIES = %w(
      foods/log/caloriesIn
      foods/log/water
    )

    def time_series(type = 'body/weight')
      three_years_ago = (Date.today - 365*3 + 1)
      get("/user/#{@user_id}/#{type}/date/#{three_years_ago}/#{Date.today}.json")
    end

    def body_series
      time_series_group(BODY_SERIES)
    end

    def all_series
      time_series_group(BODY_SERIES + SLEEP_SERIES + ACTIVITY_SERIES + FOOD_SERIES)
    end

    def time_series_group(types)
      types.inject({}) do |data_hash, series|
        data_hash.merge! time_series(series)
      end
    end

    def set_debug_mode!
      @debug = true
    end

    private

    alias_method :orig_consumer, :consumer

    def consumer
      orig_consumer
      @consumer.http.set_debug_output($stderr) if @debug && @consumer
      @consumer
    end
  end
end

def fitbit_client(client_id, client_secret)
  Fitgem::Client.new({
    consumer_key: client_id,
    consumer_secret: client_secret
  })
end

def authorize_client(client)
  client.set_debug_mode!
  token = client.request_token

  puts "Navigate to the following address and enter your pin."
  puts "https://www.fitbit.com/oauth/authenticate?oauth_token=#{token.token}"
  print "PIN: "
  pin = STDIN.gets.chomp()

  client.authorize(token.token, token.secret, {:oauth_verifier => pin})
end

def parse_data(data)
  data_hash = {}
  data.each do |type, values|
    values.each do |date_value_hash|
      date = date_value_hash['dateTime']
      val = date_value_hash['value']

      data_hash[date] ||= {}
      data_hash[date][type] = val
    end
  end
  data_hash
end

def write_csv(data_hash, output_file)
  CSV.open(output_file, 'wb') do |csv|
    csv << ['date'].concat(data_hash.first.last.keys)
    data_hash.each do |date, value_hash|
      csv << [date].concat(value_hash.values)
    end
  end
end

def main(output_file = 'data.csv', client_id = '', client_secret = '')
  client = fitbit_client(client_id, client_secret)
  authorize_client(client)

  #time_series_data = client.all_series
  time_series_data = client.time_series
  parsed_data = parse_data(time_series_data)
  write_csv(parsed_data, output_file)
end

main(*ARGV)
