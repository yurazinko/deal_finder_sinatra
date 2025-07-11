# frozen_string_literal: true

require "spec_helper"

RSpec.describe DealFinder do
  let(:deals) do
    [
      Deal.new(
        discount_price: 40,
        category: "Food & Drink",
        tags: %w[sushi japanese],
        discount_percentage: 50,
        average_rating: 4.5,
        quantity_sold: 100,
        location: { "lat" => 37.78, "lng" => -122.41 }
      ),
      Deal.new(
        discount_price: 80,
        category: "Beauty & Spas",
        tags: %w[massage relaxation],
        discount_percentage: 30,
        average_rating: 4.0,
        quantity_sold: 50,
        location: { "lat" => 37.77, "lng" => -122.42 }
      )
    ]
  end

  before do
    allow(DealRepository).to receive(:all).and_return(deals)
  end

  it "filters by price and category and scores deals" do
    params = {
      "min_price" => "20",
      "max_price" => "60",
      "category" => "Food & Drink",
      "lat" => "37.78",
      "lng" => "-122.41"
    }

    results = DealFinder.new(params).call
    expect(results.size).to eq(1)
    expect(results.first[:category]).to eq("Food & Drink")
    expect(results.first[:score]).to be > 0
  end

  it "returns empty array if no deals match" do
    params = {
      "min_price" => "200",
      "max_price" => "300",
      "category" => "Travel"
    }

    results = DealFinder.new(params).call
    expect(results).to eq([])
  end

  it "matches tags correctly" do
    params = {
      "tags" => ["sushi"],
      "lat" => "37.78",
      "lng" => "-122.41"
    }

    results = DealFinder.new(params).call
    expect(results.size).to eq(1)
    expect(results.first[:tags]).to include("sushi")
  end
end
