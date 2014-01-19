require 'json'
require 'csv'

def kg_to_lbs(kg)
  kg.to_f * 2.20462
end

def km_to_mi(km)
  km.to_f * 0.621371
end

def main
  data = JSON.parse(File.read('phil.json'))
  
  data_hash = {}
  data.each do |type, values|
    values.each do |date_value_hash|
      date = date_value_hash['dateTime']
      val = date_value_hash['value']
      val = km_to_mi(val) if type == 'activities-distance'
      val = kg_to_lbs(val) if type == 'body-weight'

      data_hash[date] ||= {}
      data_hash[date][type] = val
    end
  end

  CSV.open('phil.csv', 'wb') do |csv|
    csv << ['date'].concat(data_hash.first.last.keys)
    data_hash.each do |date, value_hash|
      csv << [date].concat(value_hash.values)
    end
  end
end

main
