sub DrawBackgroundImages()

	BACKGROUND_IMAGES_POSITION_X = BACKGROUND_IMAGES_POSITION_X + TimeStep * BACKGROUND_IMAGES_SCROLLSPEED
	
	if(BACKGROUND_IMAGES_POSITION_X > (BACKGROUND_IMAGES_NUMBER-1) * 640) then
		BACKGROUND_IMAGES_POSITION_X = 0
	end if

	
	Image = int( int(BACKGROUND_IMAGES_POSITION_X) / 640) 
	PosX = int(BACKGROUND_IMAGES_POSITION_X) MOD 640
	DrawImage_Blit(BACKGROUND_IMAGES_OFFSET + Image, 0,0, PosX,0, 640-PosX, 448)
	DrawImage_Blit(BACKGROUND_IMAGES_OFFSET + Image + 1, 640-PosX,0, 0,0, PosX, 448)

end sub

sub DrawHeader()	
	
	DrawImage(HEADER_IMAGE_ID, 0,0)
	
	TempPlayer1Points$ = str(Player[0, PLAYER_POINTS])
	
	select case length(TempPlayer1Points)
			case 1: TempPlayer1Points = "0000" + TempPlayer1Points
			case 2: TempPlayer1Points = "000" + TempPlayer1Points
			case 3: TempPlayer1Points = "00" + TempPlayer1Points
			case 4: TempPlayer1Points = "0" + TempPlayer1Points
			'case 5: TempPlayer1Points = "0" + TempPlayer1Points
	end select
	
	TempPlayer1Lives$ = str(Player[0, PLAYER_LIVES])
	
	if( length(TempPlayer1Lives) = 1) then
		TempPlayer1Lives = "0" + TempPlayer1Lives
	end if
		
	SetColor(rgb(84,14,53))
	'DrawText(TempPlayer1Points,74,8)
	'DrawText(TempPlayer1Lives,240,8)
	DrawText(TempPlayer1Points,74,11)
	DrawText(TempPlayer1Lives,240,11) 
	
	SetColor(rgb(126,213,233))
	'DrawText(TempPlayer1Points,72,6)
	'DrawText(TempPlayer1Lives,238,6) 
	DrawText(TempPlayer1Points,72,9)
	DrawText(TempPlayer1Lives,238,9)
	
	DrawImage_Blit(HEADER_ENERGYBAR_ID, 154,10, 0,0, 52 * (Player[0, PLAYER_HITPOINTS] / Player[0, PLAYER_MAX_HITPOINTS]), 10)

end sub

sub DrawLevel_BackgroundCenter_Layer()

	'----------------------------------------------------------------------     
	'Draw background and center layer of Level
	for yy = 0 to LEVEL_SIZE_Y - 1

		tempy = yy*TileSize

		for xx = 0 to NUMBER_OF_TILES_X
		  
		  if(TileLayerPosition[LevelTilePosX + xx, yy] < LAYER_FRONT) then
			  TileNumber = Level[ LevelTilePosX + xx, yy]
			  if(TileNumber > ImageID_DynamicData_Offset) then
				 DrawImage(TileNumber, xx*TileSize - ScrollOffset , tempy)
			  end if
		  end if
		next
	next

end sub

sub DrawLevel_Front_Layer()

	'----------------------------------------------------------------------     
	'Draw background and center layer of Level
	for yy = 0 to LEVEL_SIZE_Y - 1

		tempy = yy*TileSize

		for xx = 0 to NUMBER_OF_TILES_X
		  
		  TileNumber = Level[ LevelTilePosX + xx, yy]
		  
		  if(TileLayerPosition[LevelTilePosX + xx, yy] = LAYER_FRONT) then
			  if(TileNumber > ImageID_DynamicData_Offset) then
				 DrawImage(TileNumber, xx*TileSize - ScrollOffset , tempy)
			  end if
		  end if
		next
	next

end sub


sub DrawPlayer()
	'----------------------------------------------------------------------------------------------
	'Draw player 1


	
	select case Player[0, PLAYER_STATUS] 
		
		case PLAYER_STATUS_NORMAL:
			
			TileNumber = PLAYER_SETTINGS_TILES_OFFSET + int(Player[0, PLAYER_ANIMATION_FRAME])
			DrawImage(TileNumber, Player[0, PLAYER_POSITION_X] , Player[0, PLAYER_POSITION_Y])

			Player[0, PLAYER_ANIMATION_FRAME] = Player[0, PLAYER_ANIMATION_FRAME] + TimeStep / PLAYER_SETTINGS_PLAYER_ANIMATION_SPEED
			if(int(Player[0, PLAYER_ANIMATION_FRAME]) > PLAYER_SETTINGS_NUMBER_OF_ANIMATIONS - 1) then 
				Player[0, PLAYER_ANIMATION_FRAME] = 0
			end if
			
			
			if(Player[0, PLAYER_SHOT_TYPE] > 3) then
				DrawImage(PLAYER_SETTINGS_WEAPON_1_P1_TILE_OFFSET, Player[0, PLAYER_POSITION_X] , Player[0, PLAYER_POSITION_Y])
				
				if(Player[0, PLAYER_SHOT_TYPE] > 6) then
					DrawImage(PLAYER_SETTINGS_WEAPON_2_P1_TILE_OFFSET, Player[0, PLAYER_POSITION_X] , Player[0, PLAYER_POSITION_Y])
				end if
			end if
			
			
		case PLAYER_STATUS_EXPLODING:		
			
			TileNumber = PLAYER_SETTINGS_EXPLOSION_TILE_OFFSET + int(Player[0, PLAYER_ANIMATION_FRAME])
			DrawImage(TileNumber, Player[0, PLAYER_POSITION_X] , Player[0, PLAYER_POSITION_Y])      
		
			Player[0, PLAYER_ANIMATION_FRAME] = Player[0, PLAYER_ANIMATION_FRAME] + TimeStep / 100 'Duration of Animation is 200ms
			if(int(Player[0, PLAYER_ANIMATION_FRAME]) > 3) then 
				  Player[0, PLAYER_STATUS] = PLAYER_STATUS_RESET
			end if
			
		case PLAYER_STATUS_SPAWNED:
		
			TileNumber = PLAYER_SETTINGS_TILES_OFFSET + int(Player[0, PLAYER_ANIMATION_FRAME])
						
			if( int(Player[0, PLAYER_ANIMATION_FRAME]) MOD 2) then
				DrawImage(TileNumber, Player[0, PLAYER_POSITION_X] , Player[0, PLAYER_POSITION_Y])
				
				if(Player[0, PLAYER_SHOT_TYPE] > 3) then
					DrawImage(PLAYER_SETTINGS_WEAPON_1_P1_TILE_OFFSET, Player[0, PLAYER_POSITION_X] , Player[0, PLAYER_POSITION_Y])
					
					if(Player[0, PLAYER_SHOT_TYPE] > 6) then
						DrawImage(PLAYER_SETTINGS_WEAPON_2_P1_TILE_OFFSET, Player[0, PLAYER_POSITION_X] , Player[0, PLAYER_POSITION_Y])
					end if
				end if
			end if
			
			Player[0, PLAYER_ANIMATION_FRAME] = Player[0, PLAYER_ANIMATION_FRAME] + TimeStep / PLAYER_SETTINGS_PLAYER_ANIMATION_SPEED
			if(int(Player[0, PLAYER_ANIMATION_FRAME]) > PLAYER_SETTINGS_NUMBER_OF_ANIMATIONS - 1) then 
				Player[0, PLAYER_ANIMATION_FRAME] = 0
			end if

	end select
	
end sub


sub DrawPlayerShots()

	'----------------------------------------------------------------------------
	' draw player shot
	
	TileOffset = 0
	for ii = 0 to MAX_PLAYER_SHOTS - 1
	
		if(PlayerShots[ii, PLAYER_SHOT_STATUS] = PLAYER_SHOT_STATUS_ACTIVE) then
			'print PlayerShots[ii, PLAYER_SHOT_TYPE]
			select case  PlayerShots[ii, PLAYER_SHOT_SHOT_TYPE]
				case 1
					Type = 1
					TileOffset = PLAYER_SHOTS_SETTINGS_TILES_OFFSET_TYPE_1
				case 2
					Type = 2
					TileOffset = PLAYER_SHOTS_SETTINGS_TILES_OFFSET_TYPE_2 
				case 3
					Type = 3
					TileOffset = PLAYER_SHOTS_SETTINGS_TILES_OFFSET_TYPE_3 
			end select
			
			
			TileNumber =  TileOffset + int(PlayerShots[ii, PLAYER_SHOT_ANIMATION_FRAME])
			
			DrawImage(TileNumber, PlayerShots[ii, PLAYER_SHOT_POSITION_X] , PlayerShots[ii, PLAYER_SHOT_POSITION_Y])
			
			PlayerShots[ii, PLAYER_SHOT_ANIMATION_FRAME] = PlayerShots[ii, PLAYER_SHOT_ANIMATION_FRAME] + TimeStep / PLAYER_SHOTS_SETTINGS_ANIMATION_SPEED	
			
			
			if(PlayerShots[ii, PLAYER_SHOT_ANIMATION_FRAME] > PLAYER_SHOTS_SETTINGS_NUMBER_OF_ANIMATIONS - 1) then
				PlayerShots[ii, PLAYER_SHOT_ANIMATION_FRAME] = 0
			end if
						
			
		elseif(PlayerShots[ii, PLAYER_SHOT_STATUS] = PLAYER_SHOT_STATUS_EXPLOSION) then
			
			select case  PlayerShots[ii, PLAYER_SHOT_SHOT_TYPE]
				case 1
					Type = 1
					TileOffset = PLAYER_SHOTS_SETTINGS_TILES_OFFSET_TYPE_1_EXPLODE
				case 2
					Type = 2
					TileOffset = PLAYER_SHOTS_SETTINGS_TILES_OFFSET_TYPE_2_EXPLODE 
				case 3
					Type = 3
					TileOffset = PLAYER_SHOTS_SETTINGS_TILES_OFFSET_TYPE_3_EXPLODE 
			end select
			
			
			TileNumber =  TileOffset + int(PlayerShots[ii, PLAYER_SHOT_ANIMATION_FRAME])
			
			DrawImage(TileNumber, PlayerShots[ii, PLAYER_SHOT_POSITION_X] , PlayerShots[ii, PLAYER_SHOT_POSITION_Y])
			
			PlayerShots[ii, PLAYER_SHOT_ANIMATION_FRAME] = PlayerShots[ii, PLAYER_SHOT_ANIMATION_FRAME] + TimeStep / PLAYER_SHOTS_SETTINGS_EXPLODE_ANIMATIONS_SPEED
			
			
			if(PlayerShots[ii, PLAYER_SHOT_ANIMATION_FRAME] > PLAYER_SHOTS_SETTINGS_EXPLODE_NUMBER_OF_ANIMATIONS - 1) then
				PlayerShots[ii, PLAYER_SHOT_ANIMATION_FRAME] = 0
				PlayerShots[ii, PLAYER_SHOT_STATUS] = PLAYER_SHOT_STATUS_INACTIVE
			end if
		
		end if
	
	next
	
end sub

sub DrawEnemyShots()
	
	'______________Draw Enemy Shots __________________________________________
	
	NumberOfAnimations = 0
	AnimationSpeed = 0
	TileOffset = 0
	ExplodeSize = 0
	
	for ii = 0 to ENEMY_MAX_SHOTS - 1
	
		if(EnemyShots[ii, ENEMY_SHOT_STATUS] = ENEMY_SHOT_STATUS_ACTIVE) then
			
			select case  EnemyShots[ii, ENEMY_SHOT_TYPE]
				case 1
					NumberOfAnimations = ENEMY_SHOT_SETTINGS_TYPE_1_NUMBER_OF_ANIMATIONS
					AnimationSpeed = ENEMY_SHOT_SETTINGS_TYPE_1_ANIMATION_SPEED
					TileOffset = ENEMY_SHOT_SETTINGS_TYPE_1_TILEOFFSET
				case 2
					NumberOfAnimations = ENEMY_SHOT_SETTINGS_TYPE_2_NUMBER_OF_ANIMATIONS
					AnimationSpeed = ENEMY_SHOT_SETTINGS_TYPE_2_ANIMATION_SPEED
					TileOffset = ENEMY_SHOT_SETTINGS_TYPE_2_TILEOFFSET
				case 3
					NumberOfAnimations = ENEMY_SHOT_SETTINGS_TYPE_3_NUMBER_OF_ANIMATIONS
					AnimationSpeed = ENEMY_SHOT_SETTINGS_TYPE_3_ANIMATION_SPEED
					TileOffset = ENEMY_SHOT_SETTINGS_TYPE_3_TILEOFFSET
			end select
			
			
			TileNumber =  TileOffset + int(EnemyShots[ii, ENEMY_SHOT_ANIMATION_FRAME])
			
			DrawImage(TileNumber, EnemyShots[ii, ENEMY_SHOT_POSITION_X] , EnemyShots[ii, ENEMY_SHOT_POSITION_Y])
			
			EnemyShots[ii, ENEMY_SHOT_ANIMATION_FRAME] = EnemyShots[ii, ENEMY_SHOT_ANIMATION_FRAME] + TimeStep / AnimationSpeed	
						
			if(EnemyShots[ii, ENEMY_SHOT_ANIMATION_FRAME] > NumberOfAnimations - 1) then
				EnemyShots[ii, ENEMY_SHOT_ANIMATION_FRAME] = 0
			end if
		
		elseif(EnemyShots[ii, ENEMY_SHOT_STATUS] = ENEMY_SHOT_STATUS_EXPLOSION) then
			
			select case  EnemyShots[ii, ENEMY_SHOT_TYPE]
				case 1
					TileOffset = ENEMY_SHOT_SETTINGS_TYPE_1_TILES_OFFSET_EXPLODE
					'ExplodeSize = ENEMY_SHOT_SETTINGS_TYPE_1_TILES_EXPLODE_SIZE_HALF
				case 2
					TileOffset = ENEMY_SHOT_SETTINGS_TYPE_2_TILES_OFFSET_EXPLODE
					'ExplodeSize = ENEMY_SHOT_SETTINGS_TYPE_2_TILES_EXPLODE_SIZE_HALF
				case 3
					TileOffset = ENEMY_SHOT_SETTINGS_TYPE_3_TILES_OFFSET_EXPLODE
				end select
			
			
			TileNumber =  TileOffset + int(EnemyShots[ii, ENEMY_SHOT_ANIMATION_FRAME])
			
			'DrawImage(TileNumber, EnemyShots[ii, ENEMY_SHOT_POSITION_X] - ExplodeSize , EnemyShots[ii, ENEMY_SHOT_POSITION_Y] - ExplodeSize)
			DrawImage(TileNumber, Player[0, PLAYER_POSITION_X] , Player[0, PLAYER_POSITION_Y])
			
			EnemyShots[ii, ENEMY_SHOT_ANIMATION_FRAME] = EnemyShots[ii, ENEMY_SHOT_ANIMATION_FRAME] + TimeStep / ENEMY_SHOT_SETTINGS_EXPLODE_ANIMATIONS_SPEED	
						
			if(EnemyShots[ii, ENEMY_SHOT_ANIMATION_FRAME] > ENEMY_SHOT_SETTINGS_EXPLODE_NUMBER_OF_ANIMATIONS - 1) then
				EnemyShots[ii, ENEMY_SHOT_ANIMATION_FRAME] = 0
				EnemyShots[ii, ENEMY_SHOT_STATUS] = ENEMY_SHOT_STATUS_INACTIVE
			end if
			
		end if

	next
	
end sub

sub DrawEnemey()

	'---------------------------------------------------------------------------------
	'Draw Enemies
	for ii = 0 to NUMBER_OF_ENEMIES - 1

		if(EnemyList[ii, ENEMY_STATUS] = ENEMY_STATUS_WAITING) then
			' Don't forget to remove AND Position - EnemyList[ii, ENEMY_TRIGGER_START_POSITION] > 10
			if(Position >= EnemyList[ii, ENEMY_TRIGGER_START_POSITION] AND Position - EnemyList[ii, ENEMY_TRIGGER_START_POSITION] < 5) Then
				EnemyList[ii, ENEMY_STATUS] = ENEMY_STATUS_ACTIVE
				EnemyList[ii, ENEMY_TRIGGER_START_POSITION] = 0
				EnemyList[ii, ENEMY_TIME_START] = GameTicks
				'print ii
			end if
		end if
		
		if(EnemyList[ii, ENEMY_STATUS] = ENEMY_STATUS_ACTIVE) then
			
		  ' P = A + B * (t-C)^D
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
		  		  
		  
		  if(Px < -64 OR Px > SCREENX + 64  OR Py < -64 OR Py > SCREENY + 64) Then
			EnemyList[ii, ENEMY_STATUS] = ENEMY_STATUS_INACTIVE
			Active_Enemies = Active_Enemies - 1
		  end if
		  
		  TileNumber = EnemyList[ii, ENEMY_TILES_OFFSET] + int(EnemyList[ii, ENEMY_ANIMATION_FRAME])
		   
		  DrawImage(TileNumber, Px , Py)      
					 
		  EnemyList[ii, ENEMY_ANIMATION_FRAME] = EnemyList[ii, ENEMY_ANIMATION_FRAME] + TimeStep / 200 'Duration of Animation is 200ms
				
		  if(int(EnemyList[ii, ENEMY_ANIMATION_FRAME]) > EnemyList[ii, ENEMY_NUMBER_OF_ANIMATIONS] - 1) then 
				  EnemyList[ii, ENEMY_ANIMATION_FRAME] = 0
		  end if
		   
		end if

		if(EnemyList[ii, ENEMY_STATUS] = ENEMY_STATUS_EXPLODING) then
		
			' P = A + B * (t-C)^D
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
			
			TileNumber = EnemyList[ii, ENEMY_EXPLOSION_TILE_OFFSET] + int(EnemyList[ii, ENEMY_ANIMATION_FRAME])
		   
			DrawImage(TileNumber, Px , Py)      
					 
			EnemyList[ii, ENEMY_ANIMATION_FRAME] = EnemyList[ii, ENEMY_ANIMATION_FRAME] + TimeStep / 100 'Duration of Animation is 100ms
				
			if(int(EnemyList[ii, ENEMY_ANIMATION_FRAME]) > 3) then 
				  EnemyList[ii, ENEMY_STATUS] = ENEMY_STATUS_INACTIVE
				  Active_Enemies = Active_Enemies - 1
			end if
		  
		
		end if
		
		if(EnemyList[ii, ENEMY_STATUS] = ENEMY_STATUS_HIT) then
			EnemyList[ii, ENEMY_STATUS] = ENEMY_STATUS_ACTIVE
		end if
		
		
		
	next
	
end sub



sub DrawBonus()

	'______________Draw Enemy Shots __________________________________________
	
	
	TileOffset = 0
	
	for ii = 0 to BONUS_MAX_BONUS - 1
	
		if(Bonus[ii, BONUS_STATUS] = BONUS_STATUS_ACTIVE) then
			
			select case  Bonus[ii, BONUS_TYPE]
				case BONUS_TYPE_HEALTH
					TileOffset = BONUS_SETTINGS_TILEOFFSET_HEALTH
				case BONUS_TYPE_SPEED
					TileOffset = BONUS_SETTINGS_TILEOFFSET_SPEED
				case BONUS_TYPE_POWER
					TileOffset = BONUS_SETTINGS_TILEOFFSET_POWER
				case BONUS_TYPE_LIFE
					TileOffset = BONUS_SETTINGS_TILEOFFSET_LIFE
				case BONUS_TYPE_POINTS
					TileOffset = BONUS_SETTINGS_TILEOFFSET_POINTS
				case BONUS_TYPE_SHOT_REPETITION
					TileOffset = BONUS_SETTINGS_TILEOFFSET_SHOT_REPETITION
			end select
			
			
			TileNumber =  TileOffset + int(Bonus[ii, BONUS_ANIMATION_FRAME])
			
			DrawImage(TileNumber, Bonus[ii, BONUS_POSITION_X] , Bonus[ii, BONUS_POSITION_Y])
			
			Bonus[ii, BONUS_ANIMATION_FRAME] = Bonus[ii, BONUS_ANIMATION_FRAME] + TimeStep / BONUS_SETTINGS_ANIMATION_SPEED	
						
			if(Bonus[ii, BONUS_ANIMATION_FRAME] > BONUS_SETTINGS_NUMBER_OF_ANIMATIONS - 1) then
				Bonus[ii, BONUS_ANIMATION_FRAME] = 0
			end if
		
		end if

	next



end sub



sub DrawInfos()

	'SetColor(rgb(0,0,0))
	'BoxFill(0, 0, 100, 50)
	SetColor(rgb(255,255,255))
	DrawText(str(GameTicks/1000),0,15)
	DrawText(str(Position),0,30) 
	DrawText(str(1000/TimeStep),0,45)
	
end sub
	

sub Draw_Shake_Canvas(CanvasID, Offset)
	
	if(CANVAS_SHAKE) then
	
		SetCanvasViewport(CanvasID, CANVAS_SHAKE_POS[int(CANVAS_SHAKE_ANIMATION_FRAME/1000),0] + CANVAS_OFFSET, Offset + CANVAS_SHAKE_POS[int(CANVAS_SHAKE_ANIMATION_FRAME/1000),1], SCREENX,SCREENY-Offset)
				
		CANVAS_SHAKE_ANIMATION_FRAME = CANVAS_SHAKE_ANIMATION_FRAME + CANVAS_SHAKE_SPEED * TimeStep
		
		if(CANVAS_SHAKE_ANIMATION_FRAME > (CANVAS_SHAKE_NUMBER_OF_ANIMATIONS - 1)*1000) then
			CANVAS_SHAKE = false
			CANVAS_SHAKE_ANIMATION_FRAME = 0
			SetCanvasViewport(CanvasID,CANVAS_OFFSET,Offset,SCREENX,SCREENY-Offset)
		end if
		
		
	end if

end sub
