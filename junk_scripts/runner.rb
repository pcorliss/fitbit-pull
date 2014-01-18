require 'fitgem'

def get_data(client, date)
  data = {
    body_measurements: client.body_measurements_on_date(date.to_s),
    sleep: client.sleep_on_date(date.to_s),
    date: date.to_s
  }
  data
end


client = Fitgem::Client.new({
  consumer_key: '3441fb91c1c14313a3122d358c7d2c23',
  consumer_secret: 'ca769ddd09b24230b2bceffba9f93877',
})

client.user_id = '25W8NL'

token = client.request_token

puts "Navigate to https://www.fitbit.com/oauth/authenticate?oauth_token=#{token.token}, login and enter the pin."
print "PIN: "
pin = STDIN.gets.chomp()

client.authorize(token.token, token.secret, {:oauth_verifier => pin})

starting_date = Date.parse('2013-05-01')

# Rate Limit Exceeded
data = (starting_date..Date.today).map do |date|
  puts "Processing #{date}"

  data = get_data(client, date)
  while(data[:sleep]['errors']) do
    puts "Sleeping for 60 seconds due to errors"
    puts data[:sleep]['errors'].to_json
    sleep 60
    data = get_data(client, date)
  end
  data
end

File.open('fitbit.json', 'w') do |fh|
  fh.write data.to_json
end

