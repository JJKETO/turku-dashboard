#This job updates the mood icon. Currently only uses random number to choose the emotion.
#This should later be updated to be based on the face API.
SCHEDULER.every '10s', :first_in => 0 do |job|
	value = rand(10)
	if value > 3 
		image = '/Icon_Emotion_happy.svg'
	elsif value > 1
		image = '/Icon_Emotion_neutral.svg'
	else	
		image = '/Icon_Emotion_sad.svg'
	end
  send_event('changeMood', {image: image })
end