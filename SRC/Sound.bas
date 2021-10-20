ChannelID = 0
SetSoundChannels(10)

for ii = 0 to 9
	SetChannelVolume(ii,100)
next

sub Sound(Slot)

	ChannelID = ChannelID + 1
	if(ChannelID > 9) then
		ChannelID = 0
	end if
	
	PlaySound(Slot, ChannelID, 0)


end sub
