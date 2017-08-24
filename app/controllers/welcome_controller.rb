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

    #set background image depending on key words in weather description
    @bg_img = ''
    case @weather_words
    when /Drizzle/, /Rain/, /Spray/, /Hail/
      @bg_img = "gabriele-diwald-201135.jpg"
    when /Snow/, /Ice/
      @bg_img = "alexey-kuzmin-175371.jpg"
    when /Thunder/
      @bg_img = "jeremy-bishop-72584"
    when /Mist/, /Fog/, /Overcast/, /Cloud/
      @bg_img = "antoine-barres-198888.jpg"
    when "Clear"
      @bg_img = "larm-rmah-217759.jpg"
    end
      

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
