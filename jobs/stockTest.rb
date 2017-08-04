#This job scrapes Affecto stock history from Google finance
#Hopefully google doesn't change their site...
#To get around 30 days of data, the script chooses 23 values (weekends are excluded)

require 'rubygems'
require 'nokogiri'
require 'open-uri'
require 'certified'
require 'json'



#Fetch and parse the data every 10 minutes
SCHEDULER.every '10m', :first_in => 0 do
	begin
		page = Nokogiri::HTML(open("https://www.google.com/finance/historical?q=HEL%3AAFE1V"))
		values = page.css(".rgt").text.split("\n").reverse
		points = []
		for i in 8..30
			points[i-8] = [i, values[5*i-4].to_f]
		end

		a = points.map{|s| {x: s[0], y: s[1] }}

    	send_event('stock', { points: a.to_json})
	rescue
		puts "Fetching data from google failed"
	end
	
end
