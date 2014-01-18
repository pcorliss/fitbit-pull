# Set Cookies
def login(email, password)

end

# Get a week's worth of data
def get_weeek_range(date_start)
  ts = Time.now.to_i * 1000
  https://www.fitbit.com/graph/getNewGraphData?userId=25W8NL&type=weight&dateFrom=2013-06-01&dateTo=2013-06-07&version=&dataVersion=2887&ts=1390086376097

end

def capture_email
  print "Email: "
  STDIN.gets.chomp()
end

def capture_password
  print "Password: "
  STDIN.gets.chomp()
end

def get_history_in_reverse
  today = Date.today
  historical_data = {}
  while(true) do
    fresh_data = get_week_range(today - 7.days)
    parsed = JSON.parse(fresh_data)
    parsed['graph']['dataSets']['weight']['dataPoints']
    # if data exists for returned date, return
  end
end

def write_data(data)
  File.open('data.json', 'w') do |fh|
    fh.write data.to_json
  end
end

def main
  email = capture_email
  password = capture_password
  login(email, password)
  data = get_history_in_reverse
  write_data(data)
end

main
