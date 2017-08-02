# :first_in sets how long it takes before the job is first run. In this case, it is run immediately
SCHEDULER.every '1s', :first_in => 0 do |job|
  send_event('moodOfTheDay', { 
  		moodvalue: rand(5)
  	})
end