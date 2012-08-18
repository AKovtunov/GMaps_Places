require 'spec_helper'

shared_examples_for "any_search_answer" do
  it "should return value" do
    @search_result.should_not be_nil
  end
  it "should be an collection of hashes" do
    @search_result.should be_a_kind_of Array
    @search_result.each {|result| result.should be_a_kind_of Hash}
  end
end

describe GMaps_Places do
  before (:all) do
    @place = GMaps_Places::Places.new('AIzaSyArMjXaIJq10VlSHXBt9I0ikcSAeaa23tc')
  end
  context "#key" do
    it "should return key value" do
      @place.key.length.should > 8
    end
    it "should be string" do
      @place.key.should be_a_kind_of String
    end
  end
  context "#search" do
    context "By text" do
      before(:all) {@search_result = @place.search(:text, "Australia Food")}
      it_behaves_like "any_search_answer"
    end
    context "By longitude and latitude" do
      before(:all) {@search_result = @place.search(:place, -33.8670522, 151.1957362, 500, "food")}
      it_behaves_like "any_search_answer"
    end
    context "Any other" do
      it "should rise an error" do
       lambda {@place.search()}.should raise_error(ArgumentError)
      end
    end
  end
  context "#details" do
    before (:all) do
      @reference = "CmRYAAAAciqGsTRX1mXRvuXSH2ErwW-jCINE1aLiwP64MCWDN5vkXvXoQGPKldMfmdGyqWSpm7BEYCgDm-iv7Kc2PF7QA7brMAwBbAcqMr5i1f4PwTpaovIZjysCEZTry8Ez30wpEhCNCXpynextCld2EBsDkRKsGhSLayuRyFsex6JA6NPh9dyupoTH3g"
    end
    it "must have reference in args" do
      lambda{@place.details()}.should raise_error(ArgumentError)
    end
    it "must rise an error if arguments are invalid" do
      lambda{@place.details("oh_lol,_it's_reference!","some_args")}.should raise_error(RuntimeError)
    end
    it "should check status of an answer" do
      @place.details(@reference)
      @place.status.should be_a_kind_of String
      @place.status.inspect.should_not be_empty
    end
    it "should show me name if i want it" do
      @place.details(@reference, "name")
      @place.name.should_not be_empty
    end
    it "should show me as many items, as i want" do
      @place.details(@reference, "name", "rating", "formatted_phone_number")
      @place.name.should_not be_empty
      @place.rating.should_not be_nil
      @place.formatted_phone_number.should_not be_empty
    end
    it "also should give me access to address details packed in own class Address" do
      @place.details(@reference, "name", "address_components")
      @place.address_components.should be_a_kind_of GMaps_Places::Address
      @place.address_components.country.should_not be_empty
      @place.address_components.route.should_not be_empty
      @place.address_components.street_number.should_not be_empty
    end
    it "even to user's reviews!" do
      @place.details(@reference, "reviews")
      @place.reviews[1].author_name.should_not be_empty
      @place.reviews[1].text.should_not be_empty
    end
    it "should return reviews as an array of classes" do
      @place.details(@reference, "reviews")
      @place.reviews.should be_a_kind_of Array
      @place.reviews.each {|review|
        review.should be_a_kind_of GMaps_Places::Review
        }
    end
    it "should show us geometry data of object, packed in class Geometry" do
      @place.details(@reference, "geometry")
      @place.geometry.lat.should_not be_nil
      @place.geometry.lng.should_not be_nil
      @place.geometry.should be_a_kind_of GMaps_Places::Geometry
    end
    it "should show us events, as array Events class" do
      @place.details(@reference, "events")
      @place.events.should be_a_kind_of Array
      @place.events[0].event_id.should_not be_nil
      @place.events[0].start_time.should_not be_nil
      @place.events[0].should be_a_kind_of GMaps_Places::Events
    end
    it "should catch all of the errors in variable and show the as an array" do
      @place.errors.should be_a_kind_of Array
    end
  end
  context "#add" do
    xit "should add place" do

    end
  end
  context "#delete" do
    xit "should delete place" do

    end
  end
end