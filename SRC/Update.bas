
sub UpdatePlayer()
	
	Player[0, PLAYER_POSITION_X] = Player[0, PLAYER_POSITION_X] + Player[0, PLAYER_ACCELERATION_X] * TimeStep
	Player[0, PLAYER_POSITION_Y] = Player[0, PLAYER_POSITION_Y] + Player[0, PLAYER_ACCELERATION_Y] * TimeStep
  
	if(Player[0, PLAYER_POSITION_X] > SCREENX - TILESIZE) then
		'Position = Position + (Player[0, PLAYER_POSITION_X] - SCREENX + TILESIZE)
		Player[0, PLAYER_POSITION_X] = SCREENX - TILESIZE 
	elseif(Player[0, PLAYER_POSITION_X] < 0) then
		'Position = Position + Player[0, PLAYER_POSITION_X]
		Player[0, PLAYER_POSITION_X] = 0
	elseif(Player[0, PLAYER_POSITION_Y] < 0) then
		Player[0, PLAYER_POSITION_Y] = 0
	elseif(Player[0, PLAYER_POSITION_Y] > SCREENY - TILESIZE) then
		Player[0, PLAYER_POSITION_Y] = SCREENY - TILESIZE
	end if
	
	select case Player[0, PLAYER_STATUS]
	
		case PLAYER_STATUS_NORMAL:
			
			CheckCollisionsPlayer()
			CheckCollisionsEnemyShots()
			
			if(Player[0, PLAYER_HITPOINTS] < 0) then
				Player[0, PLAYER_STATUS] = PLAYER_STATUS_EXPLODING
				Player[0, PLAYER_ANIMATION_FRAME] = 0
			end if
		
		case PLAYER_STATUS_EXPLODING:
			
						
		case PLAYER_STATUS_SPAWNED:
		
			Player[0, PLAYER_SPAWN_TIMER] = Player[0, PLAYER_SPAWN_TIMER] - TimeStep
			
			if(Player[0, PLAYER_SPAWN_TIMER] < 0) then
				player[0, PLAYER_STATUS] = PLAYER_STATUS_NORMAL
			end if
			
		
		case PLAYER_STATUS_RESET:
		
			Player[0, PLAYER_LIVES] = Player[0, PLAYER_LIVES] - 1
			
			if(Player[0, PLAYER_LIVES] < 0) then
				GAME_STATE = GAME_STATE_PLAYERS_DEAD
			end if
			
			Player[0, PLAYER_POSITION_X] = 20
			Player[0, PLAYER_POSITION_Y] = 230
			Player[0, PLAYER_ANIMATION_FRAME] = 0
			Player[0, PLAYER_HITPOINTS] = Player[0, PLAYER_MAX_HITPOINTS]
			'Player[0, PLAYER_ACCELERATION] = 0.001
			'Player[0, PLAYER_MAX_ACCELERATION] = 0.1
			Player[0, PLAYER_ACCELERATION_X] = 0
			Player[0, PLAYER_ACCELERATION_Y] = 0
			Player[0, PLAYER_SPAWN_TIMER] = 3000
			Player[0, PLAYER_STATUS] = PLAYER_STATUS_SPAWNED
			
	end select

end sub


sub UpdatePlayerShots()
	
	'Player Shots
	for ii = 0 to MAX_PLAYER_SHOTS - 1
	
		if(PlayerShots[ii, PLAYER_SHOT_STATUS] = PLAYER_SHOT_STATUS_ACTIVE) then
			
			PlayerShots[ii, PLAYER_SHOT_POSITION_X] = PlayerShots[ii, PLAYER_SHOT_POSITION_X] + TimeStep * PLAYER_SHOTS_SETTINGS_SPEED
			
			if(PlayerShots[ii, PLAYER_SHOT_POSITION_X] > SCREENX) then
				PlayerShots[ii, PLAYER_SHOT_STATUS] = 0
			end if
						
			
		elseif(PlayerShots[ii, PLAYER_SHOT_STATUS] = PLAYER_SHOT_STATUS_EXPLOSION) then
			PlayerShots[ii, PLAYER_SHOT_POSITION_X] = PlayerShots[ii, PLAYER_SHOT_POSITION_X] - TimeStep * ScrollSpeed
		end if
		
	
	next
	
	PLAYER_SHOTS_SETTINGS_DELAY_COUNTER = PLAYER_SHOTS_SETTINGS_DELAY_COUNTER + TimeStep

end sub

sub UpdateEnemyShots()

	' Create new Enemy shot if Enemy reaches Trigger Position
	for ii = 0 to NUMBER_OF_ENEMIES - 1
	
		if(EnemyList[ii, ENEMY_STATUS] = ENEMY_STATUS_ACTIVE OR EnemyList[ii, ENEMY_STATUS] = ENEMY_STATUS_HIT) then
			
			if(EnemyList[ii, ENEMY_SHOT_TRIGGER_START_POSITION] < Position) then
				
				if(EnemyList[ii, ENEMY_SHOT_REPETITIONS] > 0) then
				
					ProcessingShots = true 
					SoundAlreadyPlayed = false
					
					While(ProcessingShots)  'In case the delay between shots is small i.e. 0, then process all shots at once
					
						if(EnemyList[ii, ENEMY_SHOT_NUMBER_OF_REMAINING_SHOTS] > 0) then
						
							EnemyList[ii, ENEMY_SHOT_REMAINING_DELAY] = EnemyList[ii, ENEMY_SHOT_REMAINING_DELAY] - TimeStep
							
							if(EnemyList[ii, ENEMY_SHOT_REMAINING_DELAY] < 0) then
						
								
								'PlaySound(ENEMY_SHOT_SETTINGS_SOUND_OFFSET, SOUND_CHANNEL_ENEMY, 0)
								if(SoundAlreadyPlayed = false) then
									Sound(ENEMY_SHOT_SETTINGS_SOUND_OFFSET)
									SoundAlreadyPlayed = true
								end if
																
								TimeDiff = GameTicks - EnemyList[ii, ENEMY_TIME_START]
								  Px = EnemyList[ii, ENEMY_PATH_X_A] + EnemyList[ii, ENEMY_PATH_X_B] * (TimeDiff - EnemyList[ii, ENEMY_PATH_X_C]) ^ EnemyList[ii, ENEMY_PATH_X_D]
								  Py = EnemyList[ii, ENEMY_PATH_Y_A] + EnemyList[ii, ENEMY_PATH_Y_B] * (TimeDiff - EnemyList[ii, ENEMY_PATH_Y_C]) ^ EnemyList[ii, ENEMY_PATH_Y_D]
								  
								  'Right now, stop condition just for right-to-left movement supported
								  if(Px < EnemyList[ii, ENEMY_PATH_X_STOP]) then
									Px = EnemyList[ii, ENEMY_PATH_X_STOP]
								  end if
								  'Right now, stop condition for y-direction not supported
								  'if(Py < EnemyList[ii, ENEMY_PATH_Y_STOP]) then
								  '	Py = EnemyList[ii, ENEMY_PATH_Y_STOP]
								  'end if
								  
								  'Add F*sin(E*t)
								  Px = Px + EnemyList[ii, ENEMY_PATH_X_F] * sin(EnemyList[ii, ENEMY_PATH_X_E] * TimeDiff)
								  Py = Py + EnemyList[ii, ENEMY_PATH_Y_F] * sin(EnemyList[ii, ENEMY_PATH_Y_E] * TimeDiff)
								
								EnemyShots[ENEMY_SHOT_ID, ENEMY_SHOT_STATUS] = ENEMY_SHOT_STATUS_ACTIVE
								EnemyShots[ENEMY_SHOT_ID, ENEMY_SHOT_TYPE] = EnemyList[ii, ENEMY_SHOT_TYPE_SETTING]
								
								'Take care that shot is coming from center of enemy
								ShotOffsetX = 0
								ShotOffsetY = 0
								select case EnemyShots[ENEMY_SHOT_ID, ENEMY_SHOT_TYPE]
									case 0:
										ShotOffsetX = 0
										ShotOffsetY = 0
									case 1:
										ShotOffsetX = ENEMY_SHOT_SETTINGS_TYPE_1_BOX_X1 + (ENEMY_SHOT_SETTINGS_TYPE_1_BOX_X2 - ENEMY_SHOT_SETTINGS_TYPE_1_BOX_X1)/2
										ShotOffsetY = ENEMY_SHOT_SETTINGS_TYPE_1_BOX_Y1 + (ENEMY_SHOT_SETTINGS_TYPE_1_BOX_Y2 - ENEMY_SHOT_SETTINGS_TYPE_1_BOX_Y1)/2
									case 2:
										ShotOffsetX = ENEMY_SHOT_SETTINGS_TYPE_2_BOX_X1 + (ENEMY_SHOT_SETTINGS_TYPE_2_BOX_X2 - ENEMY_SHOT_SETTINGS_TYPE_2_BOX_X1)/2
										ShotOffsetY = ENEMY_SHOT_SETTINGS_TYPE_2_BOX_Y1 + (ENEMY_SHOT_SETTINGS_TYPE_2_BOX_Y2 - ENEMY_SHOT_SETTINGS_TYPE_2_BOX_Y1)/2
									case 3:
										ShotOffsetX = ENEMY_SHOT_SETTINGS_TYPE_3_BOX_X1 + (ENEMY_SHOT_SETTINGS_TYPE_3_BOX_X2 - ENEMY_SHOT_SETTINGS_TYPE_3_BOX_X1)/2
										ShotOffsetY = ENEMY_SHOT_SETTINGS_TYPE_3_BOX_Y1 + (ENEMY_SHOT_SETTINGS_TYPE_3_BOX_Y2 - ENEMY_SHOT_SETTINGS_TYPE_3_BOX_Y1)/2
								end select
										
								EnemyShots[ENEMY_SHOT_ID, ENEMY_SHOT_POSITION_X] = Px + EnemyList[ii, ENEMY_BOX_X1] + (EnemyList[ii, ENEMY_BOX_X2] - EnemyList[ii, ENEMY_BOX_X1])/2 - ShotOffsetX  
								EnemyShots[ENEMY_SHOT_ID, ENEMY_SHOT_POSITION_Y] = Py + EnemyList[ii, ENEMY_BOX_Y1] + (EnemyList[ii, ENEMY_BOX_Y2] - EnemyList[ii, ENEMY_BOX_Y1])/2 - ShotOffsetY
								EnemyShots[ENEMY_SHOT_ID, ENEMY_SHOT_ANIMATION_FRAME] = 0
								EnemyShots[ENEMY_SHOT_ID, ENEMY_SHOT_VX] = EnemyList[ii, ENEMY_SHOT_SPEED] * cos(EnemyList[ii, ENEMY_SHOT_CURRENT_ANGLE])
								EnemyShots[ENEMY_SHOT_ID, ENEMY_SHOT_VY] = EnemyList[ii, ENEMY_SHOT_SPEED] * sin(EnemyList[ii, ENEMY_SHOT_CURRENT_ANGLE])
								
														
								ENEMY_SHOT_ID = ENEMY_SHOT_ID + 1
								if(ENEMY_SHOT_ID = ENEMY_MAX_SHOTS) Then
									ENEMY_SHOT_ID = 0
								end if
																
								EnemyList[ii, ENEMY_SHOT_CURRENT_ANGLE] = EnemyList[ii, ENEMY_SHOT_CURRENT_ANGLE] + EnemyList[ii, ENEMY_SHOT_ANGLE_INCREASE] 
								EnemyList[ii, ENEMY_SHOT_REMAINING_DELAY] = EnemyList[ii, ENEMY_SHOT_DELAY]
								EnemyList[ii, ENEMY_SHOT_NUMBER_OF_REMAINING_SHOTS] = EnemyList[ii, ENEMY_SHOT_NUMBER_OF_REMAINING_SHOTS] - 1
							else
								ProcessingShots = false							
							end if
							
						else 'ENEMY_SHOT_NUMBER_OF_REMAINING_SHOTS
							EnemyList[ii, ENEMY_SHOT_REPETITIONS_REMAINING_DELAY] = EnemyList[ii, ENEMY_SHOT_REPETITIONS_REMAINING_DELAY] - TimeStep
							
							if(EnemyList[ii, ENEMY_SHOT_REPETITIONS_REMAINING_DELAY] < 0) then
								EnemyList[ii, ENEMY_SHOT_REPETITIONS] = EnemyList[ii, ENEMY_SHOT_REPETITIONS] - 1
								EnemyList[ii, ENEMY_SHOT_REPETITIONS_REMAINING_DELAY] = EnemyList[ii, ENEMY_SHOT_REPETITIONS_DELAY]
								EnemyList[ii, ENEMY_SHOT_NUMBER_OF_REMAINING_SHOTS] = EnemyList[ii, ENEMY_SHOT_NUMBER_OF_SHOTS]
								EnemyList[ii, ENEMY_SHOT_CURRENT_ANGLE] = EnemyList[ii, ENEMY_SHOT_ANGLE]
								
							end if 
							ProcessingShots = false		
						end if
					wend
				end if
			end if
		end if
	next
	
	
	for ii = 0 to ENEMY_MAX_SHOTS - 1
	
		if(EnemyShots[ii, ENEMY_SHOT_STATUS] = ENEMY_SHOT_STATUS_ACTIVE) then
			
			EnemyShots[ii, ENEMY_SHOT_POSITION_X] = EnemyShots[ii, ENEMY_SHOT_POSITION_X] + TimeStep * EnemyShots[ii, ENEMY_SHOT_VX]
			EnemyShots[ii, ENEMY_SHOT_POSITION_Y] = EnemyShots[ii, ENEMY_SHOT_POSITION_Y] + TimeStep * EnemyShots[ii, ENEMY_SHOT_VY]
			
			if(EnemyShots[ii, ENEMY_SHOT_POSITION_X] > SCREENX) then
				EnemyShots[ii, ENEMY_SHOT_STATUS] = ENEMY_SHOT_STATUS_INACTIVE
			elseif(EnemyShots[ii, ENEMY_SHOT_POSITION_X] < 0) then
				EnemyShots[ii, ENEMY_SHOT_STATUS] = ENEMY_SHOT_STATUS_INACTIVE
			elseif(EnemyShots[ii, ENEMY_SHOT_POSITION_Y] < 0) then
				EnemyShots[ii, ENEMY_SHOT_STATUS] = ENEMY_SHOT_STATUS_INACTIVE
			elseif(EnemyShots[ii, ENEMY_SHOT_POSITION_Y] > SCREENY) then
				EnemyShots[ii, ENEMY_SHOT_STATUS] = ENEMY_SHOT_STATUS_INACTIVE
			end if	
		end if
	next


end sub

sub UpdateBonus()

	for ii = 0 to BONUS_MAX_BONUS - 1
	
		if(Bonus[ii, BONUS_STATUS] = BONUS_STATUS_ACTIVE) then
			
			Bonus[ii, BONUS_POSITION_X] = Bonus[ii, BONUS_POSITION_X] - TimeStep * ScrollSpeed
			
			if(Bonus[ii, BONUS_POSITION_X] < -64) then
				Bonus[ii, BONUS_STATUS] = BONUS_STATUS_INACTIVE
			end if
				
		end if
	next

end sub
