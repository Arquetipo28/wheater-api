# frozen_string_literal: true

task check_wheather: :environment do
  begin
    CITY = 'Monterrey'
    weather_api_url = 'https://api.openweathermap.org/data/2.5'
    url_with_query = built_url(weather_api_url, CITY)
    response = HTTParty.get(url_with_query)
    temp = cleared_temp(response.parsed_response)
    raise 'No temp found' unless temp

    Wheater.create!(city: CITY, temp: temp)
  rescue ActiveRecord::RecordInvalid => error
    # TODO: what is going to happen if record is not created
  rescue StandardError => error
    # TODO: what is going to happen if there is no temp found
  end
end

def built_url(api_url, city)
  "#{api_url}/find?q=#{city}&units=metric&appid=#{ENV['WEATHER_APPID']}"
end

def cleared_temp(parsed_response)
  first_element = parsed_response['list'][0]
  return unless first_element

  temp = first_element.dig('main', 'temp')
end
