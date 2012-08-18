require 'json'
require 'net/http'
module GMaps_Places
  class Places
    attr_reader :key
    attr_accessor :status, :errors, :geometry, :name, :icon, :reference, :events, :vicinity, :types, :id, :formatted_phone_number, :international_phone_number, :formatted_address, :address_components, :street_number, :street, :city, :region, :postal_code, :country, :rating, :url, :cid, :website, :reviews

    def initialize (api_key, *smth)
      @key = api_key
      @errors = Array.new
    end

    def search (type, *args)
     url = "https://maps.googleapis.com/maps/api/place/"
      case type
        when :text
         url+= "textsearch/json?key=#{key}&sensor=false&query="+args.map{|str| str.scan(/([a-zA-Z0-9]+)/)}.join("+")
         uri = URI.parse(url)
         connection = Net::HTTP.new(uri.host, 443)
         connection.use_ssl = true
         resp = connection.request_get(uri.path+'?'+uri.query)
         result= JSON.parse(resp.body)
          if result["status"] == "OK"
            result["results"]
          else
            raise result["status"].inspect
          end
       when :place
          url+="search/json?key=#{@key}&sensor=false&location=#{args[0]},#{args[1]}&radius=#{args[2]}&keyword="+args[3..args.length].map{|str| str.scan(/([a-zA-Z0-9]+)/)}.join("+")
          uri = URI.parse(url)
          connection = Net::HTTP.new(uri.host, 443)
          connection.use_ssl = true
          resp = connection.request_get(uri.path+'?'+uri.query)
          result= JSON.parse(resp.body)
          if result["status"] == "OK"
            result["results"]
          else
            raise result["status"].inspect
          end
       else
         raise ArgumentError
     end
    end

    def details (reference, *args)
      if reference.empty? == false
        url = "https://maps.googleapis.com/maps/api/place/details/json?key=#{key}&sensor=false&reference=#{reference}"
        uri = URI.parse(url)
        connection = Net::HTTP.new(uri.host, 443)
        connection.use_ssl = true
        resp = connection.request_get(uri.path+'?'+uri.query)
        result= JSON.parse(resp.body)
        @status = result["status"]
        if @status == "OK"
          args.each { |param|
            begin #catching errors
              result_w_param = result["result"][param]
              case param
                when "address_components"
                  address = Address.new(
                    result_w_param[0]["long_name"].nil? ? result_w_param[0]["short_name"] : result_w_param[0]["long_name"],
                    result_w_param[1]["long_name"].nil? ? result_w_param[1]["short_name"] : result_w_param[1]["long_name"],
                    result_w_param[2]["long_name"].nil? ? result_w_param[2]["short_name"] : result_w_param[2]["long_name"],
                    result_w_param[3]["long_name"].nil? ? result_w_param[3]["short_name"] : result_w_param[3]["long_name"],
                    result_w_param[4]["long_name"].nil? ? result_w_param[4]["short_name"] : result_w_param[4]["long_name"],
                    result_w_param[5]["long_name"].nil? ? result_w_param[5]["short_name"] : result_w_param[5]["long_name"]
                  )
                  instance_variable_set("@#{param}".to_sym, address)
                when "geometry"
                  geo = Geometry.new(result_w_param["location"]["lat"],
                                    result_w_param["location"]["lng"])
                  instance_variable_set("@#{param}".to_sym, geo)
                when "reviews"
                  reviews = Array.new
                  if result_w_param.nil? == false
                  result_w_param.each {|review|
                    reviews << Review.new(review["aspects"][0]["type"],
                              review["aspects"][0]["rating"],
                              review["author_name"],
                              review["author_url"],
                              review["text"],
                              review["time"])
                  }
                  else
                    reviews << Review.new(     "EMPTY",
                                               "EMPTY",
                                               "EMPTY",
                                               "EMPTY",
                                               "EMPTY",
                                               "EMPTY")
                  end
                  instance_variable_set("@#{param}".to_sym, reviews)
                when "events"
                  events = Array.new
                  if result_w_param.nil? == true
                    events << Events.new("No_events", "No_events", "No_events", "No_events")
                    instance_variable_set("@#{param}".to_sym, events)
                  else
                    result_w_param.each{|event|
                        events << Events.new(event["event_id"], event["start_time"], event["summary"], event["url"])
                      }
                      instance_variable_set("@#{param}".to_sym, events)
                  end
                else
                 instance_variable_set("@#{param}".to_sym, result["result"]["#{param}"])
              end
            rescue Exception => e
              @errors << e
              #some places throwing errors in reviews and countries. dont know why. :\
              #for example "South Steyne Function & Special events centre", AU
            end
          }
        else
          raise @status.inspect
        end
      else
        raise ArgumentError
      end
    end
  end

  class Geometry
    attr_accessor :lat, :lng
    def initialize(lat, lng)
      @lat = lat
      @lng = lng
    end
  end

  class Review
    attr_accessor :type, :rating, :author_name, :author_url, :text, :time
    def initialize(type, rating, author_name, author_url, text, time)
      @type = type
      @rating = rating
      @author_name = author_name
      @author_url = author_url
      @text = text
      @time = time
    end
  end

  class Address
    attr_accessor :street_number, :route, :locality, :administrative_area_level_1, :country, :postal_code
    def initialize(street_number, route, locality, administrative_area_level_1, country, postal_code)
      @street_number = street_number
      @route = route
      @locality = locality
      @administrative_area_level_1 = administrative_area_level_1
      @country = country
      @postal_code = postal_code
    end
  end

  class Events
    attr_accessor :event_id, :start_time, :summary, :url
    def initialize(event_id, start_time, summary, url)
      @event_id = event_id
      @start_time = start_time
      @summary = summary
      @url = url
    end
  end

end


