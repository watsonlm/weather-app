class WelcomeController < ApplicationController
	before_action :set_states, :locations, except: :test
	after_action :record_location, except: :test

  def index
  	 # removes spaces from the 2-word city names and replaces the space with an underscore 
    if params[:city] != nil
        params[:city].gsub!(" ", "_")
    end

    #checks that the state and city params are not empty before calling the API
    if params[:state] != "" && params[:city] != "" && params[:state] != nil && params[:city] != nil

      results = HTTParty.get("http://api.wunderground.com/api/#{Figaro.env.wunderground_api_key}/geolookup/conditions/q/#{params[:state]}/#{params[:city]}.json")

        # if no error is returned from the call, we fill our instanceariables with the result of the call	 
      if results['response']['error'] == nil || results['error'] ==""  	
		    @location = results['location']['city']
        @temp_f = results['current_observation']['temp_f']
        @temp_c = results['current_observation']['temp_c']
        @weather_icon = results['current_observation']['icon_url']
        @weather_words = results['current_observation']['weather']
        @forecast_link = results['current_observation']['forecast_url']
        @real_feel_f = results['current_observation']['feelslike_f']
        @real_feel_c = results['current_observation']['feelslike_c']
      else
        # if there is an error, we report it to our user via the @error variable 	
        @error = results['response']['error']['description']
      end	   
    end
  end
 
  def test
  response = HTTParty.get("http://api.wunderground.com/api/#{ENV['wunderground_api_key']}/geolookup/conditions/q/AZ/Phoenix.json")

  
  @results = {}
    @results[:location] = response['location']['city']
    @results[:temp_f] = response['current_observation']['temp_f']
    @results[:temp_c] = response['current_observation']['temp_c']
    @results[:weather_icon] = response['current_observation']['icon_url']
    @results[:weather_words] = response['current_observation']['weather'] 
    @results[:forecast_link] = response['current_observation']['forecast_url']
    @results[:real_feel] = response['current_observation']['feelslike_f']
  end

  def set_states
  	@states = %w(HI AK CA OR WA ID UT NV AZ NM CO WY MT ND SD NE KS OK TX LA AR MO IA MN WI IL IN MI OH KY TN MS AL GA FL SC NC VA WV DE MD PA NY NJ CT RI MA VT NH ME DC).sort!
  end

  def locations
  	@locations = Location.all
  end

  def record_location
  	#checks for existence of location record
    location = Location.find_or_create_by(city: params[:city], state: params[:state])
  end

end
