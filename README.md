# GMaps_Places

A small gem for Google Places API. It was made as a task for Ruby Garage courses.

## Installation

Add this line to your application's Gemfile:

    gem 'GMaps_Places'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install GMaps_Places

## Usage

###All usage was written in tests. But at first, you must add you own Google Developer key (from Google Console).
###Sample of usage:

    place = GMaps_Places::Places.new('YOUR_GOOGLE_API_KEY')
    puts "What we are looking for?"
    r = place.search(:text, gets.to_s)
    or r=place.search(:place, -33.8670522, 151.1957362, 500, "food")
    r.each {|result|
    place.details(result["reference"], "name", "address_components")#, "formatted_phone_number", "rating", "reviews", "geometry", "address_components", "events" )
    puts "Reference: #{place.reference}"
    puts "Status: #{place.status}"
    puts "Place name:  #{place.name}"
    puts "      Place rating: #{place.rating}"
    puts "      Place geo latitude #{place.geometry.lat}"
    place.reviews.each {
    |review|
      puts "      Review author #{review.author_name}"
      puts "      Review Rating #{review.rating}"
      puts "      Review text #{review.text}\n"
    }
    puts "      Place country is: #{place.address_components.country}"
    puts "      Events_id's: #{place.events[0].event_id}"
    }
    if place.errors.length > 0
        puts "WHERE ARE #{place.errors.length} ERRORS CATCHED:"
        place.errors.each {|error|
        puts "\n #{error.message} IN : \n #{error.backtrace.inspect}"}
    end


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
