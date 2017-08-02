require 'json'
require 'date'
require 'open-uri'
require 'active_support/core_ext/hash/slice'



def get_json(sourceURL)
	sodexoData = JSON.parse(open(sourceURL).read)
        return sodexoData
end

def getURL
	basePart = "http://www.sodexo.fi/ruokalistat/output/daily_json/70/"
	datePart = Date.today.strftime("%Y/%m/%d")
	endPart = "/fi"
	return basePart + datePart + endPart
end





SCHEDULER.every '1m', :first_in => 0 do |job|
	cols = [{ cols: [ {value: 'Ruoka'}, {value: 'Kategoria'}, {value: 'Hinta'}, {value: 'Extra'} ] }]
	sodexoURL = getURL
	begin
		sodexoData = get_json(sodexoURL).fetch("courses")

		ary = Array.new
		sodexoData.each do |row|
			rows = { cols: [ {value: "#{row['title_fi']}"},
        			{value: "#{row['category']}"},
        			{value: "#{row['price']}"},
      				{value: "#{row['properties']}"}
      			] }
    		ary.push(rows)
 		end
  		send_event('sodexo', {rows: ary})
  	rescue	
		puts "Fetching data from Sodexo failed"
	end
end
