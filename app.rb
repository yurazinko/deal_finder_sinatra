# frozen_string_literal: true

require "sinatra"
require "sinatra/json"
require_relative "lib/deal"
require_relative "lib/deal_repository"
require_relative "lib/deal_scorer"
require_relative "lib/deal_finder"

require "pry"

get "/deals/search" do
  json(DealFinder.new(params).call)
end
