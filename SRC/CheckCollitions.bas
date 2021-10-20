sub CheckCollisionsPlayerShots()
	
	PosY = 0
	PosX = 0
	TileType = 0
	
	'Check Collisions with Tile at the position of the shot
	for ii = 0 to MAX_PLAYER_SHOTS - 1
		if(PlayerShots[ii, PLAYER_SHOT_STATUS] = PLAYER_SHOT_STATUS_ACTIVE) then
			
			'Get tile at position of shot
			'PosX = int( (PlayerShots[ii, PLAYER_SHOT_POSITION_X] + TILESIZE / 2 + ScrollOffset) / TILESIZE)
			PosX = int( (PlayerShots[ii, PLAYER_SHOT_POSITION_X] + PLAYER_SHOTS_SETTINGS_TYPE_1_BOX_X2 + ScrollOffset) / TILESIZE)
			PosY = int( (PlayerShots[ii, PLAYER_SHOT_POSITION_Y] + TILESIZE / 2 ) / TILESIZE)
			
			
			if(Level[ LevelTilePosX + PosX, PosY] > ImageID_DynamicData_Offset) then
				if(TileLayerPosition[LevelTilePosX + PosX, PosY] = LAYER_CENTER) then
						PlayerShots[ii, PLAYER_SHOT_STATUS] = PLAYER_SHOT_STATUS_EXPLOSION
						PlayerShots[ii, PLAYER_SHOT_ANIMATION_FRAME] = 0
				end if
			end if
		end if
	next
	
	'_______Collision with Enemy_____________________________________
	for aa = 0 to MAX_PLAYER_SHOTS - 1
		if(PlayerShots[aa, PLAYER_SHOT_STATUS] = PLAYER_SHOT_STATUS_ACTIVE) then
			
			
			for ii = 0 to NUMBER_OF_ENEMIES - 1
			
				if(EnemyList[ii, ENEMY_STATUS] = ENEMY_STATUS_ACTIVE) then
					
					
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
					
					
					Collision = 1
					ShotDamage = 0
					select case PlayerShots[aa, PLAYER_SHOT_SHOT_TYPE]
						case 1:
							if(     PlayerShots[aa, PLAYER_SHOT_POSITION_Y] + PLAYER_SHOTS_SETTINGS_TYPE_1_BOX_Y2 <= Py + EnemyList[ii, ENEMY_BOX_Y1]) then
								Collision = 0
							elseif( PlayerShots[aa, PLAYER_SHOT_POSITION_Y] + PLAYER_SHOTS_SETTINGS_TYPE_1_BOX_Y1 >= Py + EnemyList[ii, ENEMY_BOX_Y2]) then
								Collision = 0
							elseif( PlayerShots[aa, PLAYER_SHOT_POSITION_X] + PLAYER_SHOTS_SETTINGS_TYPE_1_BOX_X2 <= Px + EnemyList[ii, ENEMY_BOX_X1]) then
								Collision = 0
							elseif( PlayerShots[aa, PLAYER_SHOT_POSITION_X] + PLAYER_SHOTS_SETTINGS_TYPE_1_BOX_Y1  >= Px + EnemyList[ii, ENEMY_BOX_X2]) then
								Collision = 0
							end if
							ShotDamage = PLAYER_SHOTS_SETTINGS_DAMAGE_TYPE_1
						case 2:
							if(     PlayerShots[aa, PLAYER_SHOT_POSITION_Y] + PLAYER_SHOTS_SETTINGS_TYPE_2_BOX_Y2 <= Py + EnemyList[ii, ENEMY_BOX_Y1]) then
								Collision = 0
							elseif( PlayerShots[aa, PLAYER_SHOT_POSITION_Y] + PLAYER_SHOTS_SETTINGS_TYPE_2_BOX_Y1 >= Py + EnemyList[ii, ENEMY_BOX_Y2]) then
								Collision = 0
							elseif( PlayerShots[aa, PLAYER_SHOT_POSITION_X] + PLAYER_SHOTS_SETTINGS_TYPE_2_BOX_X2 <= Px + EnemyList[ii, ENEMY_BOX_X1]) then
								Collision = 0
							elseif( PlayerShots[aa, PLAYER_SHOT_POSITION_X] + PLAYER_SHOTS_SETTINGS_TYPE_2_BOX_Y1  >= Px + EnemyList[ii, ENEMY_BOX_X2]) then
								Collision = 0
							end if
							ShotDamage = PLAYER_SHOTS_SETTINGS_DAMAGE_TYPE_2
						case 3:
							if(     PlayerShots[aa, PLAYER_SHOT_POSITION_Y] + PLAYER_SHOTS_SETTINGS_TYPE_2_BOX_Y2 <= Py + EnemyList[ii, ENEMY_BOX_Y1]) then
								Collision = 0
							elseif( PlayerShots[aa, PLAYER_SHOT_POSITION_Y] + PLAYER_SHOTS_SETTINGS_TYPE_2_BOX_Y1 >= Py + EnemyList[ii, ENEMY_BOX_Y2]) then
								Collision = 0
							elseif( PlayerShots[aa, PLAYER_SHOT_POSITION_X] + PLAYER_SHOTS_SETTINGS_TYPE_2_BOX_X2 <= Px + EnemyList[ii, ENEMY_BOX_X1]) then
								Collision = 0
							elseif( PlayerShots[aa, PLAYER_SHOT_POSITION_X] + PLAYER_SHOTS_SETTINGS_TYPE_2_BOX_Y1 >= Px + EnemyList[ii, ENEMY_BOX_X2]) then
								Collision = 0
							end if
							ShotDamage = PLAYER_SHOTS_SETTINGS_DAMAGE_TYPE_3
					end select
					
					'print Collision
					
					
			
					if(Collision) then
						PlayerShots[aa, PLAYER_SHOT_STATUS] = PLAYER_SHOT_STATUS_EXPLOSION
						PlayerShots[aa, PLAYER_SHOT_ANIMATION_FRAME] = 0
						
						
						EnemyList[ii, ENEMY_HITPOINTS] = EnemyList[ii, ENEMY_HITPOINTS] - ShotDamage
						'EnemyList[ii, ENEMY_STATUS] = ENEMY_STATUS_HIT
						
						if(EnemyList[ii, ENEMY_HITPOINTS] < 0) then
						
							'PlaySound(ENEMY_SETTINGS_SOUND_OFFSET_EXPLODE_TYPE_1,SOUND_CHANNEL_ENEMY,0)
							Sound(ENEMY_SETTINGS_SOUND_OFFSET_EXPLODE_TYPE_1)
							CANVAS_SHAKE = true
							EnemyList[ii, ENEMY_STATUS] = ENEMY_STATUS_EXPLODING
							EnemyList[ii, ENEMY_ANIMATION_FRAME] = 0
							Player[0, PLAYER_POINTS] = Player[0, PLAYER_POINTS] +  EnemyList[ii, ENEMY_POINTS] * SETTINGS_DIFFICULTY
							
							if(EnemyList[ii, ENEMY_BONUS_TYPE]) then
								Bonus[BONUS_ID, BONUS_STATUS] = BONUS_STATUS_ACTIVE
								Bonus[BONUS_ID, BONUS_TYPE] = EnemyList[ii, ENEMY_BONUS_TYPE]
								Bonus[BONUS_ID, BONUS_POSITION_X] = Px
								Bonus[BONUS_ID, BONUS_POSITION_Y] = Py
								Bonus[BONUS_ID, BONUS_ANIMATION_FRAME] = 0
								Bonus[BONUS_ID, BONUS_POINTS] = 10 * EnemyList[ii, ENEMY_POINTS]
								BONUS_ID = BONUS_ID + 1
								if(BONUS_ID > BONUS_MAX_BONUS - 1) then
									BONUS_ID = 0
								end if
							end if
						end if
					end if
					
				end if
			
			next
			
		end if
	next
	
	
	
end sub


sub CheckCollisionsPlayer()
	
	PosY = 0
	PosX = 0
	TileType = 0
	Axx = 0
	
	'########### Collision with Tiles ##########################################
	
	
	'Get tile at position of Player RT 
	PosX = int( (Player[0, PLAYER_POSITION_X] + PLAYER_SETTINGS_BOX_X2 + ScrollOffset) / TILESIZE)
	PosY = int( (Player[0, PLAYER_POSITION_Y] + PLAYER_SETTINGS_BOX_Y1 ) / TILESIZE)
	TileType = Level[ LevelTilePosX + PosX, PosY]
	if(TileType > ImageID_DynamicData_Offset) then
		if(TileLayerPosition[LevelTilePosX + PosX, PosY] = LAYER_CENTER) then
			'PlaySound(PLAYER_SETTINGS_SOUND_COLLISION_OFFSET,SOUND_CHANNEL_PLAYER_HIT,0)
			Sound(PLAYER_SETTINGS_SOUND_COLLISION_OFFSET)
			'print "Collision RT"
			Player[0, PLAYER_ACCELERATION_X] = 0
			Player[0, PLAYER_ACCELERATION_Y] = 0
			Player[0, PLAYER_POSITION_X] = Player[0, PLAYER_POSITION_X] - TimeStep * ScrollSpeed
			Player[0, PLAYER_HITPOINTS] = Player[0, PLAYER_HITPOINTS] - 10 * SETTINGS_DIFFICULTY
			CANVAS_SHAKE = true
		end if
	end if
	
	'Get tile at position of Player RL 
	PosX = int( (Player[0, PLAYER_POSITION_X] + PLAYER_SETTINGS_BOX_X2 + ScrollOffset) / TILESIZE)
	PosY = int( (Player[0, PLAYER_POSITION_Y] + PLAYER_SETTINGS_BOX_Y2 ) / TILESIZE)	
	TileType = Level[ LevelTilePosX + PosX, PosY]
	if(TileType > ImageID_DynamicData_Offset) then
		if(TileLayerPosition[LevelTilePosX + PosX, PosY] = LAYER_CENTER) then
			'PlaySound(PLAYER_SETTINGS_SOUND_COLLISION_OFFSET,SOUND_CHANNEL_PLAYER_HIT,0)
			Sound(PLAYER_SETTINGS_SOUND_COLLISION_OFFSET)
			'print "Collision RL"
			Player[0, PLAYER_ACCELERATION_X] = 0
			Player[0, PLAYER_ACCELERATION_Y] = 0
			Player[0, PLAYER_POSITION_X] = Player[0, PLAYER_POSITION_X] - TimeStep * ScrollSpeed
			Player[0, PLAYER_HITPOINTS] = Player[0, PLAYER_HITPOINTS] - 10 * SETTINGS_DIFFICULTY
			CANVAS_SHAKE = true
		end if
	end if
		
	'Get tile at position of Player LL 
	PosX = int( (Player[0, PLAYER_POSITION_X] + PLAYER_SETTINGS_BOX_X1 + ScrollOffset) / TILESIZE)
	PosY = int( (Player[0, PLAYER_POSITION_Y] + PLAYER_SETTINGS_BOX_Y2 ) / TILESIZE)	
	TileType = Level[ LevelTilePosX + PosX, PosY]
	if(TileType > ImageID_DynamicData_Offset) then
		if(TileLayerPosition[LevelTilePosX + PosX, PosY] = LAYER_CENTER) then
			'PlaySound(PLAYER_SETTINGS_SOUND_COLLISION_OFFSET,SOUND_CHANNEL_PLAYER_HIT,0)
			Sound(PLAYER_SETTINGS_SOUND_COLLISION_OFFSET)
			'print "Collision LL"
			Player[0, PLAYER_ACCELERATION_X] = 0
			Player[0, PLAYER_ACCELERATION_Y] = 0
			Player[0, PLAYER_HITPOINTS] = Player[0, PLAYER_HITPOINTS] - 10 * SETTINGS_DIFFICULTY
			CANVAS_SHAKE = true
		end if
	end if
	
	'Get tile at position of Player LT 
	PosX = int( (Player[0, PLAYER_POSITION_X] + PLAYER_SETTINGS_BOX_X1 + ScrollOffset) / TILESIZE)
	PosY = int( (Player[0, PLAYER_POSITION_Y] + PLAYER_SETTINGS_BOX_Y1 ) / TILESIZE)	
	TileType = Level[ LevelTilePosX + PosX, PosY]
	if(TileType > ImageID_DynamicData_Offset) then
		if(TileLayerPosition[LevelTilePosX + PosX, PosY] = LAYER_CENTER) then
			'PlaySound(PLAYER_SETTINGS_SOUND_COLLISION_OFFSET,SOUND_CHANNEL_PLAYER_HIT,0)
			Sound(PLAYER_SETTINGS_SOUND_COLLISION_OFFSET)
			'print "Collision LT"
			Player[0, PLAYER_ACCELERATION_X] = 0
			Player[0, PLAYER_ACCELERATION_Y] = 0
			Player[0, PLAYER_HITPOINTS] = Player[0, PLAYER_HITPOINTS] - 10 * SETTINGS_DIFFICULTY
			CANVAS_SHAKE = true
		end if
	end if

	
	'########### Collision Player with Enemy ##########################################
	
	for ii = 0 to NUMBER_OF_ENEMIES - 1

		if(EnemyList[ii, ENEMY_STATUS] = ENEMY_STATUS_ACTIVE) then
		
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
		  
		  		 
		  Collision = 1
		  if( Player[0, PLAYER_POSITION_Y] + PLAYER_SETTINGS_BOX_Y2 <= Py + EnemyList[ii, ENEMY_BOX_Y1]) then
			Collision = 0
		  elseif ( Player[0, PLAYER_POSITION_Y] + PLAYER_SETTINGS_BOX_Y1 >= Py + EnemyList[ii, ENEMY_BOX_Y2]) then
			Collision = 0
		  elseif( Player[0, PLAYER_POSITION_X] + PLAYER_SETTINGS_BOX_X2 <= Px + EnemyList[ii, ENEMY_BOX_X1]) then
			Collision = 0
		  elseif( Player[0, PLAYER_POSITION_X] + PLAYER_SETTINGS_BOX_X1  >= Px + EnemyList[ii, ENEMY_BOX_X2]) then
			Collision = 0
		  end if
		  
		  if(Collision = 1) then
			
			Player[0, PLAYER_HITPOINTS] = Player[0, PLAYER_HITPOINTS] - 600 * SETTINGS_DIFFICULTY
			CANVAS_SHAKE = true
			EnemyList[ii, ENEMY_STATUS] = ENEMY_STATUS_EXPLODING
			EnemyList[ii, ENEMY_ANIMATION_FRAME] = 0
		  end if
		
		end if

	next

	
	
end sub

sub CheckCollisionsEnemyShots()

	for ii = 0 to ENEMY_MAX_SHOTS - 1
	
		if(EnemyShots[ii, ENEMY_SHOT_STATUS] = ENEMY_SHOT_STATUS_ACTIVE) then
			
			Collision = 1
			
			select case EnemyShots[ii, ENEMY_SHOT_TYPE]
				case 0:
					Collision = 0
				case 1:
					if(EnemyShots[ii, ENEMY_SHOT_POSITION_X] + ENEMY_SHOT_SETTINGS_TYPE_1_BOX_X2 <= Player[0, PLAYER_POSITION_X] + PLAYER_SETTINGS_BOX_X1) then
						Collision = 0
					elseif (EnemyShots[ii, ENEMY_SHOT_POSITION_X] + ENEMY_SHOT_SETTINGS_TYPE_1_BOX_X1 >= Player[0, PLAYER_POSITION_X] + PLAYER_SETTINGS_BOX_X2) then
						Collision = 0
					elseif (EnemyShots[ii, ENEMY_SHOT_POSITION_Y] + ENEMY_SHOT_SETTINGS_TYPE_1_BOX_Y2 <= Player[0, PLAYER_POSITION_Y] + PLAYER_SETTINGS_BOX_Y1) then
						Collision = 0
					elseif (EnemyShots[ii, ENEMY_SHOT_POSITION_Y] + ENEMY_SHOT_SETTINGS_TYPE_1_BOX_Y1 >= Player[0, PLAYER_POSITION_Y] + PLAYER_SETTINGS_BOX_Y2) then
						Collision = 0
					end if
				case 2:
					if(EnemyShots[ii, ENEMY_SHOT_POSITION_X] + ENEMY_SHOT_SETTINGS_TYPE_2_BOX_X2 <= Player[0, PLAYER_POSITION_X] + PLAYER_SETTINGS_BOX_X1) then
						Collision = 0
					elseif (EnemyShots[ii, ENEMY_SHOT_POSITION_X] + ENEMY_SHOT_SETTINGS_TYPE_2_BOX_X1 >= Player[0, PLAYER_POSITION_X] + PLAYER_SETTINGS_BOX_X2) then
						Collision = 0
					elseif (EnemyShots[ii, ENEMY_SHOT_POSITION_Y] + ENEMY_SHOT_SETTINGS_TYPE_2_BOX_Y2 <= Player[0, PLAYER_POSITION_Y] + PLAYER_SETTINGS_BOX_Y1) then
						Collision = 0
					elseif (EnemyShots[ii, ENEMY_SHOT_POSITION_Y] + ENEMY_SHOT_SETTINGS_TYPE_2_BOX_Y1 >= Player[0, PLAYER_POSITION_Y] + PLAYER_SETTINGS_BOX_Y2) then
						Collision = 0
					end if
				case 3:
					if(EnemyShots[ii, ENEMY_SHOT_POSITION_X] + ENEMY_SHOT_SETTINGS_TYPE_3_BOX_X2 <= Player[0, PLAYER_POSITION_X] + PLAYER_SETTINGS_BOX_X1) then
						Collision = 0
					elseif (EnemyShots[ii, ENEMY_SHOT_POSITION_X] + ENEMY_SHOT_SETTINGS_TYPE_3_BOX_X1 >= Player[0, PLAYER_POSITION_X] + PLAYER_SETTINGS_BOX_X2) then
						Collision = 0
					elseif (EnemyShots[ii, ENEMY_SHOT_POSITION_Y] + ENEMY_SHOT_SETTINGS_TYPE_3_BOX_Y2 <= Player[0, PLAYER_POSITION_Y] + PLAYER_SETTINGS_BOX_Y1) then
						Collision = 0
					elseif (EnemyShots[ii, ENEMY_SHOT_POSITION_Y] + ENEMY_SHOT_SETTINGS_TYPE_3_BOX_Y1 >= Player[0, PLAYER_POSITION_Y] + PLAYER_SETTINGS_BOX_Y2) then
						Collision = 0
					end if
				
			end select
			
			if(Collision = 1) then
			
				'PlaySound(PLAYER_SETTINGS_SOUND_ENEMY_SHOT_HIT_OFFSET,SOUND_CHANNEL_PLAYER_HIT,0)
				Sound(PLAYER_SETTINGS_SOUND_ENEMY_SHOT_HIT_OFFSET)
				CANVAS_SHAKE = true
				EnemyShots[ii, ENEMY_SHOT_STATUS] = ENEMY_SHOT_STATUS_EXPLOSION
				EnemyShots[ii, ENEMY_SHOT_ANIMATION_FRAME] = 0
				
				Damage = 0
				select case EnemyShots[ii,ENEMY_SHOT_TYPE]
					case 1: 
						Damage = ENEMY_SHOT_SETTINGS_TYPE_1_DAMAGE
					case 2: 
						Damage = ENEMY_SHOT_SETTINGS_TYPE_2_DAMAGE
					case 3: 
						Damage = ENEMY_SHOT_SETTINGS_TYPE_3_DAMAGE
				end select
				Player[0, PLAYER_HITPOINTS] = Player[0, PLAYER_HITPOINTS] - Damage * SETTINGS_DIFFICULTY
			end if
		end if
	next

end sub


sub CheckCollisionPlayerBonus()

	for ii = 0 to BONUS_MAX_BONUS - 1

		if(Bonus[ii, BONUS_STATUS] = BONUS_STATUS_ACTIVE) then
		
		  Collision = 1
		  if( Player[0, PLAYER_POSITION_Y] + PLAYER_SETTINGS_BOX_Y2 <= Bonus[ii, BONUS_POSITION_Y] + BONUS_SETTINGS_BOX_Y1) then
			Collision = 0
		  elseif ( Player[0, PLAYER_POSITION_Y] + PLAYER_SETTINGS_BOX_Y1 >= Bonus[ii, BONUS_POSITION_Y] + BONUS_SETTINGS_BOX_Y2) then
			Collision = 0
		  elseif( Player[0, PLAYER_POSITION_X] + PLAYER_SETTINGS_BOX_X2 <= Bonus[ii, BONUS_POSITION_X] + BONUS_SETTINGS_BOX_X1) then
			Collision = 0
		  elseif( Player[0, PLAYER_POSITION_X] + PLAYER_SETTINGS_BOX_X1  >= Bonus[ii, BONUS_POSITION_X] + BONUS_SETTINGS_BOX_X2) then
			Collision = 0
		  end if
		  
		  if(Collision = 1) then
			Bonus[ii, BONUS_STATUS] = BONUS_STATUS_INACTIVE
			
			'PlaySound(BONUS_SETTINGS_SOUND_OFFSET,SOUND_CHANNEL_BONUS, 0)
			Sound(BONUS_SETTINGS_SOUND_OFFSET)
			select case  Bonus[ii, BONUS_TYPE]
				case BONUS_TYPE_HEALTH
					Player[0, PLAYER_HITPOINTS] = Player[0, PLAYER_MAX_HITPOINTS]
				case BONUS_TYPE_SPEED
					Player[0, PLAYER_ACCELERATION] = 1.2 * Player[0, PLAYER_ACCELERATION]
					Player[0, PLAYER_MAX_ACCELERATION] = 1.2 * Player[0, PLAYER_MAX_ACCELERATION]					
				case BONUS_TYPE_POWER
					Player[0, PLAYER_SHOT_TYPE] = Player[0, PLAYER_SHOT_TYPE] + 1
					if(Player[0, PLAYER_SHOT_TYPE] = 10) then
							Player[0, PLAYER_SHOT_TYPE] = 9
					end if
				case BONUS_TYPE_LIFE
					Player[0, PLAYER_LIVES] = Player[0, PLAYER_LIVES] + 1
				case BONUS_TYPE_POINTS
					Player[0, PLAYER_POINTS] = Player[0, PLAYER_POINTS] + Bonus[ii, BONUS_POINTS] * SETTINGS_DIFFICULTY
				case BONUS_TYPE_SHOT_REPETITION
					Player[0, PLAYER_SHOT_DELAY] = 0.8 * Player[0, PLAYER_SHOT_DELAY]
			end select
			
		  end if
		
		end if

	next

end sub
