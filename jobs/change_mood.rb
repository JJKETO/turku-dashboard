# :first_in sets how long it takes before the job is first run. In this case, it is run immediately
SCHEDULER.every '4s', :first_in => 0 do |job|
	value = rand(10)
	if value > 6 
		image = '/Icon_Emotion_happy.svg'
	elsif value > 3
		image = '/Icon_Emotion_neutral.svg'
	else	
		image = '/Icon_Emotion_sad.svg'
	end
  send_event('changeMood', {image: image })
end