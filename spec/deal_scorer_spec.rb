# frozen_string_literal: true

require "spec_helper"

RSpec.describe DealScorer do
  let(:deal) do
    Deal.new(
      discount_percentage: 50,
      average_rating: 4.5,
      quantity_sold: 300,
      location: { "lat" => 37.78, "lng" => -122.41 }
    )
  end

  it "calculates a score with distance" do
    scorer = DealScorer.new(user_lat: 37.78, user_lng: -122.41)
    score = scorer.score(deal)
    expect(score).to be_positive
  end

  it "penalizes distant deals" do
    far_deal = Deal.new(deal.to_h.merge(location: { "lat" => 0, "lng" => 0 }))
    scorer = DealScorer.new(user_lat: 37.78, user_lng: -122.41)
    expect(scorer.score(far_deal).to_f).to be <= scorer.score(deal).to_f
  end
end
