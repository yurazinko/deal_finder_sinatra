# frozen_string_literal: true

require "geokit"

class Deal
  attr_reader :attributes

  def initialize(attributes)
    @attributes = attributes
    attributes.each do |key, value|
      define_singleton_method(key) { value }
    end
  end

  def to_h
    attributes.transform_keys(&:to_sym)
  end

  def distance_to(user_lat, user_lng)
    return unless valid_coordinates?(user_lat, user_lng)

    deal_location = Geokit::LatLng.new(attributes["location"]["lat"], attributes["location"]["lng"])
    user_location = Geokit::LatLng.new(user_lat, user_lng)

    deal_location.distance_to(user_location, units: :kms)
  end

  private

  def valid_coordinates?(user_lat, user_lng)
    attributes["location"] && user_lat && user_lng
  end
end
