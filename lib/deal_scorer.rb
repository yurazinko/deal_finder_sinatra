# frozen_string_literal: true

require "bigdecimal"
require "bigdecimal/util"

class DealScorer
  WEIGHTS = {
    discount: 0.4,
    rating: 0.2,
    popularity: 0.2,
    distance: 0.2
  }.freeze

  def initialize(user_lat:, user_lng:)
    @user_lat = parse_coordinate(user_lat)
    @user_lng = parse_coordinate(user_lng)
  end

  def score(deal)
    weighted_discount_score(deal) +
      weighted_rating_score(deal) +
      weighted_popularity_score(deal) +
      weighted_distance_score(deal)
  end

  private

  def weighted_discount_score(deal)
    WEIGHTS[:discount] * to_float(deal.discount_percentage)
  end

  def weighted_rating_score(deal)
    WEIGHTS[:rating] * to_float(deal.average_rating)
  end

  def weighted_popularity_score(deal)
    popularity = (deal.quantity_sold || 0) + 1
    WEIGHTS[:popularity] * Math.log(popularity)
  end

  def weighted_distance_score(deal)
    distance = deal.distance_to(@user_lat, @user_lng) || 10_000
    WEIGHTS[:distance] * (1.0 / (distance + 1))
  end

  def parse_coordinate(value)
    return if value.nil? || value.to_s.strip.empty?

    BigDecimal(value.to_s)
  rescue ArgumentError
    nil
  end

  def to_float(value)
    Float(value)
  rescue StandardError
    0.0
  end
end
