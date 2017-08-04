#This job fetches the daily menu for Sodexo old mill. 
#Todo: Tomorrows menu at some time (15:00?)


require 'json'
require 'date'
require 'open-uri'
require 'active_support/core_ext/hash/slice'


#Fetch the data from sodexo
def get_json(sourceURL)
	sodexoData = JSON.parse(open(sourceURL).read)
        return sodexoData
end

#Create the url needed. 
def getURL
	basePart = "http://www.sodexo.fi/ruokalistat/output/daily_json/70/"
	datePart = Date.today.strftime("%Y/%m/%d")
	endPart = "/fi"
	return basePart + datePart + endPart
end




#Fetch and parse the data every 30 minutes
SCHEDULER.every '30m', :first_in => 0 do |job|
	#Columns are currentyly not used
	#cols = [{ cols: [ {value: 'Ruoka'}, {value: 'Hinta'}, {value: 'Extra'} ] }]
	sodexoURL = getURL
	begin
		sodexoData = get_json(sodexoURL).fetch("courses")

		ary = Array.new
		sodexoData.each do |row|
			rows = { cols: [ {value: "#{row['title_fi']}"},
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
