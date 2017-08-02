require 'rubygems'
require 'nokogiri'
require 'open-uri'
require 'certified'
require 'json'




SCHEDULER.every '10m', :first_in => 0 do
	begin
		page = Nokogiri::HTML(open("https://www.google.com/finance/historical?q=HEL%3AAFE1V"))
		values = page.css(".rgt").text.split("\n").reverse

		points = []
		for i in 1..30
			points[i-1] = [i, values[5*i-2].to_f]
		end

		a = points.map{|s| {x: s[0], y: s[1] }}

    	send_event('stock', { points: a.to_json })
	rescue
		puts "Fetching data from google failed"
	end
end
