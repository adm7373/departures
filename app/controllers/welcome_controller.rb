require 'csv'
require 'open-uri'
require 'date'

class WelcomeController < ApplicationController
  def index
    csv = open('http://developer.mbta.com/lib/gtrtfs/Departures.csv')
    csvData = CSV.parse(csv, {headers: true})
    @data = csvData.map(&:to_h)

    @data.each do |train|
      train[:origin] = train["Origin"]
      train[:carrier] = "MBTA"
      train[:time] = DateTime.strptime(train["ScheduledTime"], '%s')
      train[:destination] = train["Destination"]
      train[:train_number] = train["Trip"]
      train[:track_number] = train["Track"] || "TBD"
      train[:status] = train["Status"] || "???"
    end
    @north = @data.select { |train| train["Origin"] == "North Station" }
    @south = @data.select { |train| train["Origin"] == "South Station" }

  end
end
