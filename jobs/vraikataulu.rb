require 'json'
require 'date'
require 'open-uri'
require 'active_support'

def get_json(sourceURL)
	vrData = JSON.parse(open(sourceURL).read)
        return vrData
end

#Function to get and parse the data. 
def getData()
	vrURL = "https://rata.digitraffic.fi/api/v1/schedules?departure_station=KUT&arrival_station=HKI&limit=7"

	vrData = get_json(vrURL)

	timetables = []
	timetables2 = []
	vrData.each do |a| 
		timetables << a.fetch("timeTableRows")
	end	

	#Make hard copy of timetables so you can use the original table twice
	timetables2 = Marshal.load(Marshal.dump(timetables))

	departures = []
	timetables.each do |a|
		a.keep_if {|b|
			b.fetch("stationShortCode") == "KUT" && b.fetch("type") == "DEPARTURE"
		}
		a.each do |b|
			departures << DateTime.strptime(b.slice("scheduledTime")["scheduledTime"],'%Y-%m-%dT%H:%M:%S.%L%z').to_time.to_s
		end

	end




	arrivals = []
	timetables2.each do |a|
		a.keep_if {|b|
			b.fetch("stationShortCode") == "HKI" && b.fetch("type") == "ARRIVAL"
		}
		a.each do |b|
			arrivals << DateTime.strptime(b.slice("scheduledTime")["scheduledTime"],'%Y-%m-%dT%H:%M:%S.%L%z').to_time.to_s
		end
	end



	output = []
	for i in 0..6
		output[i] = [
			departures[i][8..9] + "." + departures[i][5..6] + ". ",
			"Kupittaa", 
			"Helsinki", 
			departures[i][11..15], 
			arrivals[i][11..15]]
	end

	ary = Array.new
	output.each do |row|
		rows = { cols: [ {value: row[0]},
	      			{value: row[1]},
	       			{value: row[2]},
	    			{value: row[3]},
	    			{value: row[4]}
	   			] }
	   			ary.push(rows)
	 end

	return ary
end



SCHEDULER.every '5m', :first_in => 0 do |job|
	#Header row currently not used
	#cols = [{ cols: [{value: 'Päivä'}, {value: 'Lähtö'}, {value: 'Saapuminen'}, {value: 'Lähtöaika'}, {value: 'Saapumisaika'} ] }]
	begin
		rows = getData
  		send_event('vr', {rows: rows})
  	rescue
  		puts "Fetching data from ratapaikka failed"
  	end
end
