require 'csv'
require 'open-uri'
require 'date'

class WelcomeController < ApplicationController
  def index
    csv = open('http://developer.mbta.com/lib/gtrtfs/Departures.csv')
    csvData = CSV.parse(csv, {headers: true})
    @data = csvData.map(&:to_h)

    @data.each do |t|
      t[:origin] = t["Origin"]
      t[:carrier] = "MBTA"
      t[:scheduled] = DateTime.strptime(t["ScheduledTime"], '%s').strftime("%I:%M %P")
      t[:estimated] = DateTime.strptime(t["ScheduledTime"] + t["Lateness"], '%s').strftime("%I:%M %P")
      t[:destination] = t["Destination"]
      t[:train_number] = t["Trip"]
      t[:track_number] = t["Track"] || "TBD"
      t[:status] = t["Status"] || "???"
      t[:status_class] = case t["Status"]
      when "Delayed", "Late"
        "late"
      when "Now Boarding", "All Aboard", "Arriving", "Arrived"
        "now"
      when "Hold", "Cancelled"
        "problem"
      when "End", "TBD", "Info to follow"
        "unknown"
      when "On Time"
        "on-time"
      when "Departed"
        "gone"
      end
    end


  end
end
