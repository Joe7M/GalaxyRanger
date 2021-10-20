sub LoadSettings()
	if(FileExists("./DATA/SETTINGS.TXT")) then
		File = Freefile()
		FileOpen(File, "./DATA/SETTINGS.TXT",TEXT_INPUT)
		
		SETTINGS_DIFFICULTY = val(ReadLine(File))
		print "Difficulty: " + str(SETTINGS_DIFFICULTY)
		SETTINGS_VSYNC = val(ReadLine(File))
		SETTINGS_FULLSCREEN = val(ReadLine(File))
		SETTINGS_MUSIC_VOLUME = val(ReadLine(File))
		
		for ii = 0 to 5
			JOYSTICK[ii, JOYSTICK_NUMBER] = val(ReadLine(File))
			JOYSTICK[ii, JOYSTICK_DEVICE] = val(ReadLine(File))
			JOYSTICK[ii, JOYSTICK_DEVICE_NUMBER] = val(ReadLine(File))
			JOYSTICK[ii, JOYSTICK_DEVICE_VALUE] = val(ReadLine(File))
		next
		
		KEY_USER_LEFT = val(ReadLine(File))
		KEY_USER_RIGHT = val(ReadLine(File))
		KEY_USER_UP = val(ReadLine(File))
		KEY_USER_DOWN = val(ReadLine(File))
		KEY_USER_FIRE = val(ReadLine(File))
		
		FileClose(File)
	end if
end sub

function ReadValueFromFile(File)

	do
		String$ = ReadLine(File)
		
		if(EOF(File)) then
			return 0
		end if
		
		FirstCharacter$ = Left$(String,1)
	
		if(FirstCharacter <> "#") then
			return val(String) 
		end if
	loop 

end function

function ReadStringFromFile$(File)

	do
		String$ = ReadLine(File)
		
		if(EOF(File)) then
			return "0"
		end if
		
		FirstCharacter$ = Left$(String,1)
	
		if(FirstCharacter <> "#") then
			return String
		end if
	loop 

end function

sub Check_and_LoadImage(FileName$)

	if(FileExists(FileName)) then
		LoadImage(ImageID, FileName)
		fprint(str(ImageID))
		fprint(" ")
		print(FileName)
	else
		print("Could not open:")
		print(FileName)
		end
	end if
	
	ImageID = ImageID + 1

end sub

sub Check_and_LoadSound(FileName$)

	if(FileExists(FileName)) then
		LoadSound(SoundID, FileName)
		fprint(str(SoundID))
		fprint(" ")
		print(FileName)
	else
		print("Could not open:")
		print(FileName)
		end
	end if
	
	SoundID = SoundID + 1

end sub


'#################################################################################
' Load global data
'#################################################################################

sub Load_GlobalData()

	HEADER_IMAGE_ID = ImageID
	Check_and_LoadImage("./DATA/MISC/Header.png")

	HEADER_ENERGYBAR_ID = ImageID
	Check_and_LoadImage("./DATA/MISC/Header_EnergyBar.png")

	'Load Player Shot Type 1
	PLAYER_SHOTS_SETTINGS_TILES_OFFSET_TYPE_1 = ImageID
	Check_and_LoadImage("./DATA/PLAYER/PlayerShot_Type_1_0000.png")
	Check_and_LoadImage("./DATA/PLAYER/PlayerShot_Type_1_0001.png")
	Check_and_LoadImage("./DATA/PLAYER/PlayerShot_Type_1_0002.png")
	Check_and_LoadImage("./DATA/PLAYER/PlayerShot_Type_1_0003.png")

	'Load Player Shot Type 2
	PLAYER_SHOTS_SETTINGS_TILES_OFFSET_TYPE_2 = ImageID
	Check_and_LoadImage("./DATA/PLAYER/Player_Shot_Type_2_0000.png")
	Check_and_LoadImage("./DATA/PLAYER/Player_Shot_Type_2_0001.png")
	Check_and_LoadImage("./DATA/PLAYER/Player_Shot_Type_2_0002.png")
	Check_and_LoadImage("./DATA/PLAYER/Player_Shot_Type_2_0003.png")

	'Load Player Shot Type 3
	PLAYER_SHOTS_SETTINGS_TILES_OFFSET_TYPE_3 = ImageID
	Check_and_LoadImage("./DATA/PLAYER/Player_Shot_Type_3_0000.png")
	Check_and_LoadImage("./DATA/PLAYER/Player_Shot_Type_3_0001.png")
	Check_and_LoadImage("./DATA/PLAYER/Player_Shot_Type_3_0002.png")
	Check_and_LoadImage("./DATA/PLAYER/Player_Shot_Type_3_0003.png")

	PLAYER_SHOTS_SETTINGS_TILES_OFFSET_TYPE_1_EXPLODE = ImageID
	PLAYER_SHOTS_SETTINGS_TILES_OFFSET_TYPE_2_EXPLODE = ImageID
	Check_and_LoadImage("./DATA/PLAYER/PlayerShot_Type_1_Explosion_0000.png")
	Check_and_LoadImage("./DATA/PLAYER/PlayerShot_Type_1_Explosion_0001.png")
	Check_and_LoadImage("./DATA/PLAYER/PlayerShot_Type_1_Explosion_0002.png")
	Check_and_LoadImage("./DATA/PLAYER/PlayerShot_Type_1_Explosion_0003.png")

	PLAYER_SHOTS_SETTINGS_TILES_OFFSET_TYPE_3_EXPLODE = ImageID
	Check_and_LoadImage("./DATA/PLAYER/PlayerShot_Type_3_Explosion_0000.png")
	Check_and_LoadImage("./DATA/PLAYER/PlayerShot_Type_3_Explosion_0001.png")
	Check_and_LoadImage("./DATA/PLAYER/PlayerShot_Type_3_Explosion_0002.png")
	Check_and_LoadImage("./DATA/PLAYER/PlayerShot_Type_3_Explosion_0003.png")

	'Load Bonus
	BONUS_SETTINGS_TILEOFFSET_HEALTH = ImageID
	Check_and_LoadImage("./DATA/BONUS/Bonus_Health_0000.png")
	Check_and_LoadImage("./DATA/BONUS/Bonus_Health_0001.png")
	Check_and_LoadImage("./DATA/BONUS/Bonus_Health_0002.png")
	Check_and_LoadImage("./DATA/BONUS/Bonus_Health_0003.png")
	Check_and_LoadImage("./DATA/BONUS/Bonus_Health_0004.png")
	Check_and_LoadImage("./DATA/BONUS/Bonus_Health_0005.png")
	Check_and_LoadImage("./DATA/BONUS/Bonus_Health_0006.png")

	BONUS_SETTINGS_TILEOFFSET_SPEED  = ImageID
	Check_and_LoadImage("./DATA/BONUS/Bonus_Speed_0000.png")
	Check_and_LoadImage("./DATA/BONUS/Bonus_Speed_0001.png")
	Check_and_LoadImage("./DATA/BONUS/Bonus_Speed_0002.png")
	Check_and_LoadImage("./DATA/BONUS/Bonus_Speed_0003.png")
	Check_and_LoadImage("./DATA/BONUS/Bonus_Speed_0004.png")
	Check_and_LoadImage("./DATA/BONUS/Bonus_Speed_0005.png")
	Check_and_LoadImage("./DATA/BONUS/Bonus_Speed_0006.png")

	BONUS_SETTINGS_TILEOFFSET_POINTS  = ImageID
	Check_and_LoadImage("./DATA/BONUS/Bonus_Points_0000.png")
	Check_and_LoadImage("./DATA/BONUS/Bonus_Points_0001.png")
	Check_and_LoadImage("./DATA/BONUS/Bonus_Points_0002.png")
	Check_and_LoadImage("./DATA/BONUS/Bonus_Points_0003.png")
	Check_and_LoadImage("./DATA/BONUS/Bonus_Points_0004.png")
	Check_and_LoadImage("./DATA/BONUS/Bonus_Points_0005.png")
	Check_and_LoadImage("./DATA/BONUS/Bonus_Points_0006.png")

	BONUS_SETTINGS_TILEOFFSET_POWER  = ImageID
	Check_and_LoadImage("./DATA/BONUS/Bonus_Power_0000.png")
	Check_and_LoadImage("./DATA/BONUS/Bonus_Power_0001.png")
	Check_and_LoadImage("./DATA/BONUS/Bonus_Power_0002.png")
	Check_and_LoadImage("./DATA/BONUS/Bonus_Power_0003.png")
	Check_and_LoadImage("./DATA/BONUS/Bonus_Power_0004.png")
	Check_and_LoadImage("./DATA/BONUS/Bonus_Power_0005.png")
	Check_and_LoadImage("./DATA/BONUS/Bonus_Power_0006.png")

	BONUS_SETTINGS_TILEOFFSET_LIFE  = ImageID
	Check_and_LoadImage("./DATA/BONUS/Bonus_Life_0000.png")
	Check_and_LoadImage("./DATA/BONUS/Bonus_Life_0001.png")
	Check_and_LoadImage("./DATA/BONUS/Bonus_Life_0002.png")
	Check_and_LoadImage("./DATA/BONUS/Bonus_Life_0003.png")
	Check_and_LoadImage("./DATA/BONUS/Bonus_Life_0004.png")
	Check_and_LoadImage("./DATA/BONUS/Bonus_Life_0005.png")
	Check_and_LoadImage("./DATA/BONUS/Bonus_Life_0006.png")
	
	BONUS_SETTINGS_TILEOFFSET_SHOT_REPETITION  = ImageID
	Check_and_LoadImage("./DATA/BONUS/Bonus_Shot_Repetition_0000.png")
	Check_and_LoadImage("./DATA/BONUS/Bonus_Shot_Repetition_0001.png")
	Check_and_LoadImage("./DATA/BONUS/Bonus_Shot_Repetition_0002.png")
	Check_and_LoadImage("./DATA/BONUS/Bonus_Shot_Repetition_0003.png")
	Check_and_LoadImage("./DATA/BONUS/Bonus_Shot_Repetition_0004.png")
	Check_and_LoadImage("./DATA/BONUS/Bonus_Shot_Repetition_0005.png")
	Check_and_LoadImage("./DATA/BONUS/Bonus_Shot_Repetition_0006.png")

	PLAYER_SETTINGS_WEAPON_1_P1_TILE_OFFSET = ImageID
	Check_and_LoadImage("./DATA/PLAYER/Player1_Weapon_Top.png")

	PLAYER_SETTINGS_WEAPON_2_P1_TILE_OFFSET = ImageID
	Check_and_LoadImage("./DATA/PLAYER/Player1_Weapon_Bottom.png")

	PLAYER_SETTINGS_TILES_OFFSET = ImageID
	Check_and_LoadImage("./DATA/PLAYER/Player1_0000.png")
	Check_and_LoadImage("./DATA/PLAYER/Player1_0001.png")
	Check_and_LoadImage("./DATA/PLAYER/Player1_0002.png")
	Check_and_LoadImage("./DATA/PLAYER/Player1_0003.png")

	PLAYER_SETTINGS_EXPLOSION_TILE_OFFSET = ImageID
	Check_and_LoadImage("./DATA/PLAYER/Explosion_Big_0000.png")
	Check_and_LoadImage("./DATA/PLAYER/Explosion_Big_0001.png")
	Check_and_LoadImage("./DATA/PLAYER/Explosion_Big_0002.png")
	Check_and_LoadImage("./DATA/PLAYER/Explosion_Big_0003.png")

	MENUE_IMAGE_ID_PLAY = ImageID
	Check_and_LoadImage("./DATA/MISC/Menue_Play_1.png")
	Check_and_LoadImage("./DATA/MISC/Menue_Play_2.png")
	MENUE_IMAGE_ID_EXIT = ImageID
	Check_and_LoadImage("./DATA/MISC/Menue_Exit_1.png")
	Check_and_LoadImage("./DATA/MISC/Menue_Exit_2.png")
	MENUE_IMAGE_ID_HIGHSCORE = ImageID
	Check_and_LoadImage("./DATA/MISC/Menue_Highscore_1.png")
	Check_and_LoadImage("./DATA/MISC/Menue_Highscore_2.png")
	MENUE_IMAGE_ID_SETTINGS = ImageID
	Check_and_LoadImage("./DATA/MISC/Menue_Settings_1.png")
	Check_and_LoadImage("./DATA/MISC/Menue_Settings_2.png")
	MENUE_IMAGE_ID_CREDITS = ImageID
	Check_and_LoadImage("./DATA/MISC/Menue_Credits_1.png")
	Check_and_LoadImage("./DATA/MISC/Menue_Credits_2.png")
	MENUE_IMAGE_ID_ARROW = ImageID
	Check_and_LoadImage("./DATA/MISC/Menue_Arrow.png")
	
	MENUE_IMAGE_ID_FONT_64x64 = ImageID - asc("A")
	Check_and_LoadImage("./DATA/FONTS/A.png")
	Check_and_LoadImage("./DATA/FONTS/B.png")
	Check_and_LoadImage("./DATA/FONTS/C.png")
	Check_and_LoadImage("./DATA/FONTS/D.png")
	Check_and_LoadImage("./DATA/FONTS/E.png")
	Check_and_LoadImage("./DATA/FONTS/F.png")
	Check_and_LoadImage("./DATA/FONTS/G.png")
	Check_and_LoadImage("./DATA/FONTS/H.png")
	Check_and_LoadImage("./DATA/FONTS/I.png")
	Check_and_LoadImage("./DATA/FONTS/J.png")
	Check_and_LoadImage("./DATA/FONTS/K.png")
	Check_and_LoadImage("./DATA/FONTS/L.png")
	Check_and_LoadImage("./DATA/FONTS/M.png")
	Check_and_LoadImage("./DATA/FONTS/N.png")
	Check_and_LoadImage("./DATA/FONTS/O.png")
	Check_and_LoadImage("./DATA/FONTS/P.png")
	Check_and_LoadImage("./DATA/FONTS/Q.png")
	Check_and_LoadImage("./DATA/FONTS/R.png")
	Check_and_LoadImage("./DATA/FONTS/S.png")
	Check_and_LoadImage("./DATA/FONTS/T.png")
	Check_and_LoadImage("./DATA/FONTS/U.png")
	Check_and_LoadImage("./DATA/FONTS/V.png")
	Check_and_LoadImage("./DATA/FONTS/W.png")
	Check_and_LoadImage("./DATA/FONTS/X.png")
	Check_and_LoadImage("./DATA/FONTS/Y.png")
	Check_and_LoadImage("./DATA/FONTS/Z.png")
	
	PLAYER_SHOTS_SETTINGS_TYPE_1_SOUND_OFFSET = SoundID
	Check_and_LoadSound("./DATA/PLAYER/PlayerShot_Type_1.ogg")
	PLAYER_SHOTS_SETTINGS_TYPE_2_SOUND_OFFSET = SoundID
	Check_and_LoadSound("./DATA/PLAYER/PlayerShot_Type_1.ogg")
	PLAYER_SHOTS_SETTINGS_TYPE_3_SOUND_OFFSET = SoundID
	Check_and_LoadSound("./DATA/PLAYER/PlayerShot_Type_1.ogg")

	ENEMY_SETTINGS_SOUND_OFFSET_EXPLODE_TYPE_1 = SoundID
	Check_and_LoadSound("./DATA/ENEMY/Enemy_Explosion_Type_1.ogg")
	ENEMY_SETTINGS_SOUND_OFFSET_EXPLODE_TYPE_2 = SoundID
	Check_and_LoadSound("./DATA/ENEMY/Enemy_Explosion_Type_1.ogg")

	BONUS_SETTINGS_SOUND_OFFSET = SoundID
	Check_and_LoadSound("./DATA/BONUS/Bonus.ogg")

	ENEMY_SHOT_SETTINGS_SOUND_OFFSET = SoundID
	Check_and_LoadSound("./DATA/ENEMY/Enemy_Shot.ogg")

	PLAYER_SETTINGS_SOUND_ENEMY_SHOT_HIT_OFFSET = SoundID
	Check_and_LoadSound("./DATA/PLAYER/Enemy_Shot_Hit_Player.ogg")

	PLAYER_SETTINGS_SOUND_COLLISION_OFFSET = SoundID
	Check_and_LoadSound("./DATA/PLAYER/Player_Collision.ogg")
	
	LoadMusic("./DATA/MISC/dualtrax - against the time.ogg")

	LoadFont(0,"./DATA/FONTS/GravityRegular5.ttf", 10)
	LoadFont(1,"./DATA/FONTS/kongtext.ttf", 32)

	SoundID_DynamicData_Offset = SoundID
	ImageID_DynamicData_Offset = ImageID
end sub

'#################################################################


sub Load_DynamicData(LevelFile$, EnemyFile$, BGFile$)
	
	print("Load dynamic data")

	f = FreeFile

	if(NOT FileOpen(f, LevelFile, TEXT_INPUT)) Then
		print("Could not open level.txt")
		end
	end if

	NumberOfTiles = val(ReadLine(f))
	fprint("NumberOfTiles = ")
	print(NumberOfTiles)

	For ii = 0 to NumberOfTiles - 1
		TileFile$ = ReadLine(f)
		Check_and_LoadImage(TileFile)
		'DrawImage(ImageID, ii * 64, 20)
		'ImageID = ImageID + 1
	next


	LEVEL_SIZE_X = val(ReadLine(f))
	LEVEL_SIZE_Y = val(ReadLine(f))
	fprint("LevelSizeX = ")
	print(LEVEL_SIZE_X)
	fprint("LevelSizeY = ")
	print(LEVEL_SIZE_Y)

	for yy = 0 to LEVEL_SIZE_Y - 1
		
		for xx = 0 to LEVEL_SIZE_X - 1
			Level[xx,yy] = val(ReadLine(f)) + ImageID_DynamicData_Offset
			TileLayerPosition[xx,yy] = val(ReadLine(f))
			'print Level[xx,yy]
		next
	next
	FileClose(f)

	'#### Enemies ###################################################################################


	f = FreeFile

	if(NOT FileOpen(f, EnemyFile$, TEXT_INPUT)) Then
		print("Could not open Enemies.txt")
		end
	end if
		
		
	NumberOfTiles = ReadValueFromFile(f)

	fprint("Number of enemy tiles = ")
	print(NumberOfTiles)

	ENEMY_IMAGE_ID_OFFSET = ImageID

	For ii = 0 to NumberOfTiles - 1
		TileFile$ = ReadStringFromFile(f)
		Check_and_LoadImage(TileFile)
	next

	ENEMY_SHOT_SETTINGS_TYPE_1_TILEOFFSET = ENEMY_IMAGE_ID_OFFSET + ReadValueFromFile(f)
	ENEMY_SHOT_SETTINGS_TYPE_2_TILEOFFSET = ENEMY_IMAGE_ID_OFFSET + ReadValueFromFile(f)
	ENEMY_SHOT_SETTINGS_TYPE_3_TILEOFFSET = ENEMY_IMAGE_ID_OFFSET + ReadValueFromFile(f)
	ENEMY_SHOT_SETTINGS_TYPE_1_TILES_OFFSET_EXPLODE = ENEMY_IMAGE_ID_OFFSET + ReadValueFromFile(f)
	ENEMY_SHOT_SETTINGS_TYPE_2_TILES_OFFSET_EXPLODE = ENEMY_IMAGE_ID_OFFSET + ReadValueFromFile(f)
	ENEMY_SHOT_SETTINGS_TYPE_3_TILES_OFFSET_EXPLODE = ENEMY_IMAGE_ID_OFFSET + ReadValueFromFile(f)
	ENEMY_SHOT_SETTINGS_TYPE_1_NUMBER_OF_ANIMATIONS = ReadValueFromFile(f)
	ENEMY_SHOT_SETTINGS_TYPE_2_NUMBER_OF_ANIMATIONS = ReadValueFromFile(f)
	ENEMY_SHOT_SETTINGS_TYPE_3_NUMBER_OF_ANIMATIONS = ReadValueFromFile(f)
	ENEMY_SHOT_SETTINGS_TYPE_1_BOX_X1 = ReadValueFromFile(f)
	ENEMY_SHOT_SETTINGS_TYPE_1_BOX_Y1 = ReadValueFromFile(f)
	ENEMY_SHOT_SETTINGS_TYPE_1_BOX_X2 = ReadValueFromFile(f)
	ENEMY_SHOT_SETTINGS_TYPE_1_BOX_Y2 = ReadValueFromFile(f)
	ENEMY_SHOT_SETTINGS_TYPE_2_BOX_X1 = ReadValueFromFile(f)
	ENEMY_SHOT_SETTINGS_TYPE_2_BOX_Y1 = ReadValueFromFile(f)
	ENEMY_SHOT_SETTINGS_TYPE_2_BOX_X2 = ReadValueFromFile(f)
	ENEMY_SHOT_SETTINGS_TYPE_2_BOX_Y2 = ReadValueFromFile(f)
	ENEMY_SHOT_SETTINGS_TYPE_3_BOX_X1 = ReadValueFromFile(f)
	ENEMY_SHOT_SETTINGS_TYPE_3_BOX_Y1 = ReadValueFromFile(f)
	ENEMY_SHOT_SETTINGS_TYPE_3_BOX_X2 = ReadValueFromFile(f)
	ENEMY_SHOT_SETTINGS_TYPE_3_BOX_Y2 = ReadValueFromFile(f)
	ENEMY_SHOT_SETTINGS_TYPE_1_DAMAGE = ReadValueFromFile(f)
	ENEMY_SHOT_SETTINGS_TYPE_2_DAMAGE = ReadValueFromFile(f)
	ENEMY_SHOT_SETTINGS_TYPE_3_DAMAGE = ReadValueFromFile(f)	

	NUMBER_OF_ENEMIES = ReadValueFromFile(f)
	fprint("Number of Enemies: ")
	print(NUMBER_OF_ENEMIES)

	for ii = 0 to NUMBER_OF_ENEMIES - 1
		
		EnemyList[ii, ENEMY_STATUS] = ENEMY_STATUS_WAITING
		EnemyList[ii, ENEMY_TRIGGER_START_POSITION] = ReadValueFromFile(f)
		EnemyList[ii, ENEMY_TIME_START] = 0
		EnemyList[ii, ENEMY_PATH_X_A] = ReadValueFromFile(f)
		EnemyList[ii, ENEMY_PATH_X_B] = ReadValueFromFile(f)
		EnemyList[ii, ENEMY_PATH_X_C] = ReadValueFromFile(f)
		EnemyList[ii, ENEMY_PATH_X_D] = ReadValueFromFile(f)
		EnemyList[ii, ENEMY_PATH_X_E] = ReadValueFromFile(f)
		EnemyList[ii, ENEMY_PATH_X_F] = ReadValueFromFile(f)
		EnemyList[ii, ENEMY_PATH_X_STOP] = ReadValueFromFile(f)
		EnemyList[ii, ENEMY_PATH_Y_A] = ReadValueFromFile(f)
		EnemyList[ii, ENEMY_PATH_Y_B] = ReadValueFromFile(f)
		EnemyList[ii, ENEMY_PATH_Y_C] = ReadValueFromFile(f)
		EnemyList[ii, ENEMY_PATH_Y_D] = ReadValueFromFile(f)
		EnemyList[ii, ENEMY_PATH_Y_E] = ReadValueFromFile(f)
		EnemyList[ii, ENEMY_PATH_Y_F] = ReadValueFromFile(f)
		EnemyList[ii, ENEMY_PATH_Y_STOP] = ReadValueFromFile(f)
		EnemyList[ii, ENEMY_NUMBER_OF_ANIMATIONS] = ReadValueFromFile(f)
		EnemyList[ii, ENEMY_ANIMATION_FRAME] = 0
		EnemyList[ii, ENEMY_TILES_OFFSET] = ReadValueFromFile(f) + ENEMY_IMAGE_ID_OFFSET
		EnemyList[ii, ENEMY_HITPOINTS] = ReadValueFromFile(f)
		EnemyList[ii, ENEMY_BOX_X1] = ReadValueFromFile(f)
		EnemyList[ii, ENEMY_BOX_Y1] = ReadValueFromFile(f)
		EnemyList[ii, ENEMY_BOX_X2] = ReadValueFromFile(f)
		EnemyList[ii, ENEMY_BOX_Y2] = ReadValueFromFile(f)
		EnemyList[ii, ENEMY_EXPLOSION_TILE_OFFSET] = ReadValueFromFile(f) + ENEMY_IMAGE_ID_OFFSET
		EnemyList[ii, ENEMY_POINTS] = ReadValueFromFile(f)
		EnemyList[ii, ENEMY_SHOT_TRIGGER_START_POSITION] = ReadValueFromFile(f)
		EnemyList[ii, ENEMY_SHOT_NUMBER_OF_SHOTS] = ReadValueFromFile(f)
		EnemyList[ii, ENEMY_SHOT_NUMBER_OF_REMAINING_SHOTS] = EnemyList[ii, ENEMY_SHOT_NUMBER_OF_SHOTS]
		EnemyList[ii, ENEMY_SHOT_DELAY] = ReadValueFromFile(f)
		EnemyList[ii, ENEMY_SHOT_ANGLE] = radians(ReadValueFromFile(f))
		EnemyList[ii, ENEMY_SHOT_CURRENT_ANGLE] = EnemyList[ii, ENEMY_SHOT_ANGLE]
		EnemyList[ii, ENEMY_SHOT_SPEED] = ReadValueFromFile(f)
		EnemyList[ii, ENEMY_SHOT_ANGLE_INCREASE] = radians(ReadValueFromFile(f))
		EnemyList[ii, ENEMY_SHOT_TYPE_SETTING] = ReadValueFromFile(f)
		EnemyList[ii, ENEMY_SHOT_REMAINING_DELAY] = 0
		EnemyList[ii, ENEMY_BONUS_TYPE] = ReadValueFromFile(f)
		EnemyList[ii, ENEMY_SHOT_REPETITIONS] = ReadValueFromFile(f)
		EnemyList[ii, ENEMY_SHOT_REPETITIONS_DELAY] = ReadValueFromFile(f)
		EnemyList[ii, ENEMY_SHOT_REPETITIONS_REMAINING_DELAY] = EnemyList[ii, ENEMY_SHOT_REPETITIONS_DELAY]
		
		
	next

	FileClose(f)



	'#######################################################################################
	' Load BG


	f = FreeFile

	if(NOT FileOpen(f, BGFile$, TEXT_INPUT)) Then
		print("Could not open BG.txt")
		end
	end if
			
	BACKGROUND_IMAGES_NUMBER = ReadValueFromFile(f)


	fprint("Number of BG images = ")
	print(BACKGROUND_IMAGES_NUMBER)

	BACKGROUND_IMAGES_OFFSET = ImageID

	For ii = 0 to BACKGROUND_IMAGES_NUMBER - 1
		TileFile$ = ReadStringFromFile(f)
		Check_and_LoadImage(TileFile)
	next

	FileClose(f)
	print("Level successfully read")

	'#######################################################################################

end sub





