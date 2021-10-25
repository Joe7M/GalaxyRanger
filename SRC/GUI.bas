GUI_MAX_BUTTON_COOLDOWN = 200
GUI_Button_Cooldown = 0

GUI_STATE_MENUE = 0
GUI_STATE_START_GAME = 1
GUI_STATE_SETTINGS = 2
GUI_STATE_CREDITS = 3
GUI_STATE_EXIT = 4
GUI_STATE_HIGHSCORE = 5
GUI_STATE_EDIT_HIGHSCORE = 6
GUI_STATE_SETTINGS_WAIT_FOR_INPUT = 7

GUI_STATE = GUI_STATE_MENUE

GUI_NUMBER_OF_STARS = 30
GUI_STARS_X = 0
GUI_STARS_Y = 1
GUI_STARS_VX = 2
GUI_STARS_VY = 3
GUI_STARS_SPEED = 0.1

DIM Stars[GUI_NUMBER_OF_STARS,4]
Dim Menue_Active_Position
Menue_Active_Position = 0

DIM HighscoreName$[9]
DIM HighscoreValue[9]
dim HighscoreColors[9]
HighscoreColors[0] = COLOR_PALETTE[2]
HighscoreColors[1] = COLOR_PALETTE[3]
HighscoreColors[2] = COLOR_PALETTE[4]
HighscoreColors[3] = COLOR_PALETTE[5]
HighscoreColors[4] = COLOR_PALETTE[21]
HighscoreColors[5] = COLOR_PALETTE[22]
HighscoreColors[6] = COLOR_PALETTE[23]
HighscoreColors[7] = COLOR_PALETTE[26]
HighscoreColors[8] = COLOR_PALETTE[27]
Highscore_ColorTimer = 0
Highscore_Position = -1
Highscore_Edit_Position = 0

GUI_STATE_SETTINGS_P1_JOY = -1
GUI_STATE_SETTINGS_P1_KEY = -1
SettingsPosition = 0
SettingsPositionActive = -1

sub GUI_Reset_Stars()
	
	for ii = 0 to GUI_NUMBER_OF_STARS - 1
		Stars[ii, GUI_STARS_VX] = (rand(200) / 100 - 1)
		Stars[ii, GUI_STARS_VY] = (rand(200) / 100 - 1)
		Stars[ii, GUI_STARS_X] = 320
		Stars[ii, GUI_STARS_Y] = 240
	next
	
	for tt = 0 to 500
		for ii = 0 to GUI_NUMBER_OF_STARS - 1
		
			Stars[ii, GUI_STARS_X] = Stars[ii, GUI_STARS_X] + Stars[ii, GUI_STARS_VX] 
			Stars[ii, GUI_STARS_Y] = Stars[ii, GUI_STARS_Y] + Stars[ii, GUI_STARS_VY]
			
			if(Stars[ii, GUI_STARS_X] > SCREENX OR Stars[ii, GUI_STARS_X] < 0 OR Stars[ii, GUI_STARS_Y] > SCREENY OR Stars[ii, GUI_STARS_Y] < 0) then
				Stars[ii, GUI_STARS_X] = SCREENX/2
				Stars[ii, GUI_STARS_Y] = SCREENY/2
				
				Stars[ii, GUI_STARS_VX] = (rand(200) / 100 - 1)
				Stars[ii, GUI_STARS_VY] = (rand(200) / 100 - 1)
				
			end if
		next
	next
	
	
end sub


sub GUI_Show_Stars()

	dim Color

	for ii = 0 to GUI_NUMBER_OF_STARS - 1
	
		Stars[ii, GUI_STARS_X] = Stars[ii, GUI_STARS_X] + Stars[ii, GUI_STARS_VX] * TimeStep * GUI_STARS_SPEED
		Stars[ii, GUI_STARS_Y] = Stars[ii, GUI_STARS_Y] + Stars[ii, GUI_STARS_VY] * TimeStep * GUI_STARS_SPEED
		
		if(Stars[ii, GUI_STARS_X] > SCREENX OR Stars[ii, GUI_STARS_X] < 0 OR Stars[ii, GUI_STARS_Y] > SCREENY OR Stars[ii, GUI_STARS_Y] < 0) then
			Stars[ii, GUI_STARS_X] = SCREENX/2
			Stars[ii, GUI_STARS_Y] = SCREENY/2
			
			Stars[ii, GUI_STARS_VX] = (rand(200) / 100 - 1)
			Stars[ii, GUI_STARS_VY] = (rand(200) / 100 - 1)
		end if
	
		Color = (Stars[ii, GUI_STARS_VX] * Stars[ii, GUI_STARS_VX] + Stars[ii, GUI_STARS_VY] * Stars[ii, GUI_STARS_VY]) * 1000
		SetColor(rgb(Color,Color,Color))
		BoxFill(Stars[ii,GUI_STARS_X], Stars[ii,GUI_STARS_Y], Stars[ii, GUI_STARS_X] + 2, Stars[ii, GUI_STARS_Y] + 2)
		
	next
		
end sub

sub GUI_Load_Highscore()
	if(FileExists(LoadSavePath + "HIGHSCORE.TXT")) then
		File = Freefile()
		FileOpen(File, LoadSavePath + "HIGHSCORE.TXT",TEXT_INPUT)
		for ii = 0 to 8
			HighscoreName$[ii] = ReadLine(File)
			HighscoreValue[ii] = val(ReadLine(File))
		next
		FileClose(File)
	else
		for ii = 0 to 8 
			HighscoreName[ii] = "ABC"
			HighscoreValue[ii] = 10000 - (10000/8 * ii)
		next
	end if
end sub

sub GUI_Save_Highscore()
	File = Freefile()
	FileOpen(File, LoadSavePath + "HIGHSCORE.TXT",TEXT_OUTPUT)
	for ii = 0 to 8
		WriteLine(File, HighscoreName$[ii])
		WriteLine(File, str(HighscoreValue[ii]))
	next
	FileClose(File)
end sub

sub GUI_SaveSettings()
	File = Freefile()
	FileOpen(File, LoadSavePath + "SETTINGS.TXT",TEXT_OUTPUT)
	
	WriteLine(File, str(SETTINGS_DIFFICULTY))
	WriteLine(File, str(SETTINGS_VSYNC))
	WriteLine(File, str(SETTINGS_FULLSCREEN))
	WriteLine(File, str(SETTINGS_MUSIC_VOLUME))
	for ii = 0 to 5
		WriteLine(File, str(JOYSTICK[ii, JOYSTICK_NUMBER]))
		WriteLine(File, str(JOYSTICK[ii, JOYSTICK_DEVICE]))
		WriteLine(File, str(JOYSTICK[ii, JOYSTICK_DEVICE_NUMBER]))
		WriteLine(File, str(JOYSTICK[ii, JOYSTICK_DEVICE_VALUE]))
	next
	WriteLine(File, str_f(KEY_USER_LEFT))
	WriteLine(File, str_f(KEY_USER_RIGHT))
	WriteLine(File, str_f(KEY_USER_UP))
	WriteLine(File, str_f(KEY_USER_DOWN))
	WriteLine(File, str_f(KEY_USER_FIRE))
	
	FileClose(File)
end sub


sub GUI_Process_Input()

	'Escape works always
	if(GUI_Button_Cooldown = 0) then
		if(key(K_ESCAPE) OR GetJoystick(JOYSTICK_ESCAPE)) then
	
			select case GUI_STATE
				case GUI_STATE_MENUE:
					end
				case GUI_STATE_SETTINGS:
					if(GUI_STATE_SETTINGS_P1_JOY > -1) then
						GUI_STATE_SETTINGS_P1_JOY = -1
					elseif(GUI_STATE_SETTINGS_P1_KEY > -1) then
						GUI_STATE_SETTINGS_P1_KEY = -1
					else
						GUI_STATE = GUI_STATE_MENUE
						GUI_SaveSettings()
					end if
					
				default
					GUI_STATE = GUI_STATE_MENUE
			end select
						
			GUI_Button_Cooldown = GUI_MAX_BUTTON_COOLDOWN*2
			
		end if
	end if
		
	'If in Settings and setting a new key then all keys are blocked
	if(GUI_Button_Cooldown = 0 AND GUI_STATE_SETTINGS_P1_KEY = -1 AND GUI_STATE_SETTINGS_P1_JOY = -1) then
		
		if(key(K_UP) OR key(KEY_USER_UP) OR GetJoystick(JOYSTICK_UP)) then
		
			select case GUI_STATE
				case GUI_STATE_MENUE:
					Menue_Active_Position = Menue_Active_Position - 1
					if(Menue_Active_Position < 0) then
						Menue_Active_Position = 4
					end if
				
				case GUI_STATE_EDIT_HIGHSCORE:
					temp$ = HighscoreName[Highscore_Position]
					Letter = asc(mid(temp,Highscore_Edit_Position,1))
					
					if(Letter < 90) then
						Letter = Letter + 1
					else
						Letter = 48
					end if
					
					'string$=chr$(Letter)
					temp$ = ReplaceSubstr$(HighscoreName[Highscore_Position], chr$(Letter), Highscore_Edit_Position)
					HighscoreName[Highscore_Position] = temp$
					
				case GUI_STATE_SETTINGS:
					if(SettingsPosition > 0) then
						SettingsPosition = SettingsPosition - 1
					end if
				
			end select
			
			GUI_Button_Cooldown = GUI_MAX_BUTTON_COOLDOWN
			
		end if
		if(key(K_DOWN) OR key(KEY_USER_DOWN) OR GetJoystick(JOYSTICK_DOWN)) then
			select case GUI_STATE
				case GUI_STATE_MENUE:
					Menue_Active_Position = Menue_Active_Position + 1
					if(Menue_Active_Position > 4) then
						Menue_Active_Position = 0
					end if
				case GUI_STATE_EDIT_HIGHSCORE:
					temp$ = HighscoreName[Highscore_Position]
					Letter = asc(mid(temp,Highscore_Edit_Position,1))
					
					if(Letter > 48) then
						Letter = Letter - 1
					else
						Letter = 91
					end if
					
					'string$=chr$(Letter)
					temp$ = ReplaceSubstr$(HighscoreName[Highscore_Position], chr$(Letter), Highscore_Edit_Position)
					HighscoreName[Highscore_Position] = temp$
					
				case GUI_STATE_SETTINGS:
						if(SettingsPosition < 14) then
							SettingsPosition = SettingsPosition + 1
						end if
						
				
			end select
			
			GUI_Button_Cooldown = GUI_MAX_BUTTON_COOLDOWN
			
		end if
		if(key(K_RETURN) OR key(K_SPACE) OR key(KEY_USER_FIRE) OR GetJoystick(JOYSTICK_FIRE)) then
			
			GUI_Button_Cooldown = GUI_MAX_BUTTON_COOLDOWN
			
			select case GUI_STATE
				
				case GUI_STATE_MENUE:
				
					select case Menue_Active_Position
					
						case 0:
							Menue_is_running = false
						case 1:
							GUI_STATE = GUI_STATE_SETTINGS
						case 2:
							GUI_STATE = GUI_STATE_HIGHSCORE
						case 3:
							GUI_STATE = GUI_STATE_CREDITS
						case 4:
							end					
					end select					
					
				case GUI_STATE_HIGHSCORE:
					GUI_STATE = GUI_STATE_MENUE
						
				case GUI_STATE_CREDITS:
					GUI_STATE = GUI_STATE_MENUE
				
				case GUI_STATE_EDIT_HIGHSCORE:					
					Highscore_Edit_Position = Highscore_Edit_Position + 1
					if(Highscore_Edit_Position > 2) then
						GUI_STATE = GUI_STATE_HIGHSCORE
						GUI_Save_Highscore()
					end if
					
				case GUI_STATE_SETTINGS:
					select case SettingsPosition
						case 0: 'Difficulty
							SETTINGS_DIFFICULTY = SETTINGS_DIFFICULTY + 0.2
							if(SETTINGS_DIFFICULTY = 1.4) then
								SETTINGS_DIFFICULTY = 0.6
							end if
						case 1: 'VSYNC
							SETTINGS_VSYNC = 1 - SETTINGS_VSYNC
						case 2: 'Fullscreen
							SETTINGS_FULLSCREEN = 1 - SETTINGS_FULLSCREEN
						case 3:
							SETTINGS_MUSIC_VOLUME = SETTINGS_MUSIC_VOLUME + 10
							SetMusicVolume(SETTINGS_MUSIC_VOLUME)
							if(SETTINGS_MUSIC_VOLUME > 100) then
								SETTINGS_MUSIC_VOLUME = 0
								SetMusicVolume(0)
							end if							
						case 4: 'P1 Joystick left
							GUI_STATE_SETTINGS_P1_JOY = JOYSTICK_LEFT
						case 5: 'P1 Joystick right
							GUI_STATE_SETTINGS_P1_JOY = JOYSTICK_RIGHT
						case 6: 'P1 Joystick up
							GUI_STATE_SETTINGS_P1_JOY = JOYSTICK_UP
						case 7: 'P1 Joystick down
							GUI_STATE_SETTINGS_P1_JOY = JOYSTICK_DOWN
						case 8: 'P1 Joystick fire
							GUI_STATE_SETTINGS_P1_JOY = JOYSTICK_FIRE
						case 9: 'P1 Joystick escape
							GUI_STATE_SETTINGS_P1_JOY = JOYSTICK_ESCAPE
						case 10: 'Key Left
							GUI_STATE_SETTINGS_P1_KEY = K_LEFT
						case 11: 'Key Right
							GUI_STATE_SETTINGS_P1_KEY = K_RIGHT
						case 12: 'Key Up
							GUI_STATE_SETTINGS_P1_KEY = K_UP
						case 13: 'Key Down
							GUI_STATE_SETTINGS_P1_KEY = K_DOWN
						case 14: 'Key Fire
							GUI_STATE_SETTINGS_P1_KEY = K_SPACE
							
					end select
					GUI_Button_Cooldown = GUI_MAX_BUTTON_COOLDOWN*3 'Relaxe a little bit, otherwise setting new keys is not easy
				
				
			end select
			
			
		end if
			
		if(key(K_RIGHT) OR key(KEY_USER_RIGHT) OR GetJoystick(JOYSTICK_RIGHT)) then
		
			select case GUI_STATE
								
				case GUI_STATE_EDIT_HIGHSCORE:					
					Highscore_Edit_Position = Highscore_Edit_Position + 1
					if(Highscore_Edit_Position > 2) then
						Highscore_Edit_Position = 2
					end if
					
			end select
			
			GUI_Button_Cooldown = GUI_MAX_BUTTON_COOLDOWN
			
		end if
		if(key(K_LEFT) OR key(KEY_USER_LEFT) OR GetJoystick(JOYSTICK_LEFT)) then
		
			select case GUI_STATE
								
				case GUI_STATE_EDIT_HIGHSCORE:					
					Highscore_Edit_Position = Highscore_Edit_Position - 1
					if(Highscore_Edit_Position < 0) then
						Highscore_Edit_Position = 0
					end if
					
			end select
			
			GUI_Button_Cooldown = GUI_MAX_BUTTON_COOLDOWN
			
		end if
		
	end if

	GUI_Button_Cooldown = GUI_Button_Cooldown  - TimeStep
	
	if(GUI_Button_Cooldown < 0) then
		GUI_Button_Cooldown = 0
	end if		
		

end sub



sub GUI_Show_Highscore()
	
	Font(1)
	
	'DrawImage(MENUE_IMAGE_ID_HIGHSCORE, 50,10)		
		
	Highscore_ColorTimer = Highscore_ColorTimer - TimeStep
	if(Highscore_ColorTimer < 0 ) then
		
		Highscore_ColorTimer = 50
		TempColor = HighscoreColors[8]
		
		for ii = 8 to 1 step -1
			HighscoreColors[ii] = HighscoreColors[ii - 1]
		next
		
		HighscoreColors[0] = TempColor
		
	end if
				
	for ii = 0 to 8
	
		if(GUI_STATE = GUI_STATE_EDIT_HIGHSCORE) then
			if(ii = Highscore_Position) then
				SetColor(HighscoreColors[ii])
				
				select case Highscore_Edit_Position
					case 0:
						DrawText("_  ", 200, 96 + ii * 34)
					case 1:
						DrawText(" _ ", 200, 96 + ii * 34)
					case 2:
						DrawText("  _", 200, 96 + ii * 34)
				
				end select
				
			else
				SetColor(COLOR_PALETTE[23])
			end if
		else	
			SetColor(HighscoreColors[ii])	
		end if
		
				
		DrawText(str(ii + 1), 130, 90 + ii * 34)
		DrawText(HighscoreName[ii], 200, 90 + ii * 34)
		
			
		
		StringValue$ = str(HighscoreValue[ii])
	
		select case length(StringValue)
				case 1: StringValue = "0000" + StringValue
				case 2: StringValue = "000" + StringValue
				case 3: StringValue = "00" + StringValue
				case 4: StringValue = "0" + StringValue
				'case 5: TempPlayer1Points = "0" + TempPlayer1Points
		end select
		
		DrawText(StringValue, 350, 90 + ii * 34) 
	next
	
	Font(0)
	
end sub


sub GUI_Show_Menue()
	Offset = 32
	select case Menue_Active_Position
		case 0:
			DrawImage(MENUE_IMAGE_ID_ARROW, 		SCREENX/2 - 256 - Offset, SCREENY/2 - 96)
			DrawImage(MENUE_IMAGE_ID_PLAY + 1, 		SCREENX/2 - 192 - Offset, SCREENY/2 - 96)
			DrawImage(MENUE_IMAGE_ID_SETTINGS, 		SCREENX/2 - 192 - Offset, SCREENY/2 - 32 )
			DrawImage(MENUE_IMAGE_ID_HIGHSCORE, 	SCREENX/2 - 192 - Offset, SCREENY/2 + 32)
			DrawImage(MENUE_IMAGE_ID_CREDITS, 		SCREENX/2 - 192 - Offset, SCREENY/2 + 96)
			DrawImage(MENUE_IMAGE_ID_EXIT, 			SCREENX/2 - 192 - Offset, SCREENY/2 + 160)
		case 1:
			DrawImage(MENUE_IMAGE_ID_ARROW, 		SCREENX/2 - 256 - Offset, SCREENY/2 - 32 )
			DrawImage(MENUE_IMAGE_ID_PLAY, 			SCREENX/2 - 192 - Offset, SCREENY/2 - 96)
			DrawImage(MENUE_IMAGE_ID_SETTINGS + 1, 	SCREENX/2 - 192 - Offset, SCREENY/2 - 32 )
			DrawImage(MENUE_IMAGE_ID_HIGHSCORE, 	SCREENX/2 - 192 - Offset, SCREENY/2 + 32)
			DrawImage(MENUE_IMAGE_ID_CREDITS, 		SCREENX/2 - 192 - Offset, SCREENY/2 + 96)
			DrawImage(MENUE_IMAGE_ID_EXIT, 			SCREENX/2 - 192 - Offset, SCREENY/2 + 160)
		case 2:
			DrawImage(MENUE_IMAGE_ID_ARROW, 		SCREENX/2 - 256 - Offset, SCREENY/2 + 32)
			DrawImage(MENUE_IMAGE_ID_PLAY, 			SCREENX/2 - 192 - Offset, SCREENY/2 - 96)
			DrawImage(MENUE_IMAGE_ID_SETTINGS, 		SCREENX/2 - 192 - Offset, SCREENY/2 - 32 )
			DrawImage(MENUE_IMAGE_ID_HIGHSCORE + 1, SCREENX/2 - 192 - Offset, SCREENY/2 + 32)
			DrawImage(MENUE_IMAGE_ID_CREDITS, 		SCREENX/2 - 192 - Offset, SCREENY/2 + 96)
			DrawImage(MENUE_IMAGE_ID_EXIT, 			SCREENX/2 - 192 - Offset, SCREENY/2 + 160)
		case 3:
			DrawImage(MENUE_IMAGE_ID_ARROW, 		SCREENX/2 - 256 - Offset, SCREENY/2 + 96)
			DrawImage(MENUE_IMAGE_ID_PLAY, 			SCREENX/2 - 192 - Offset, SCREENY/2 - 96)
			DrawImage(MENUE_IMAGE_ID_SETTINGS, 		SCREENX/2 - 192 - Offset, SCREENY/2 - 32 )
			DrawImage(MENUE_IMAGE_ID_HIGHSCORE, 	SCREENX/2 - 192 - Offset, SCREENY/2 + 32)
			DrawImage(MENUE_IMAGE_ID_CREDITS + 1, 	SCREENX/2 - 192 - Offset, SCREENY/2 + 96)
			DrawImage(MENUE_IMAGE_ID_EXIT, 			SCREENX/2 - 192 - Offset, SCREENY/2 + 160)
		case 4:
			DrawImage(MENUE_IMAGE_ID_ARROW,			SCREENX/2 - 256 - Offset, SCREENY/2 + 160)
			DrawImage(MENUE_IMAGE_ID_PLAY, 			SCREENX/2 - 192 - Offset, SCREENY/2 - 96)
			DrawImage(MENUE_IMAGE_ID_SETTINGS, 		SCREENX/2 - 192 - Offset, SCREENY/2 - 32 )
			DrawImage(MENUE_IMAGE_ID_HIGHSCORE, 	SCREENX/2 - 192 - Offset, SCREENY/2 + 32)
			DrawImage(MENUE_IMAGE_ID_CREDITS, 		SCREENX/2 - 192 - Offset, SCREENY/2 + 96)
			DrawImage(MENUE_IMAGE_ID_EXIT + 1, 		SCREENX/2 - 192 - Offset, SCREENY/2 + 160)
	end select

end sub


sub GUI_Show_Splash_Screen() 

	LOGO_ID = ImageID
	Check_and_LoadImage("./DATA/MISC/J7M.png")
	PRESENTS_ID = ImageID
	Check_and_LoadImage("./DATA/MISC/Presents.png")
	GALAXYRANGER_ID = ImageID
	Check_and_LoadImage("./DATA/MISC/GalaxyRangerLogo.png")
	
	Number_of_Flying_Images = 15
	DIM FlyingImages[Number_of_Flying_Images]
	DIM FlyingImages_PosX[Number_of_Flying_Images]
	DIM FlyingImages_PosY[Number_of_Flying_Images]
	DIM FlyingImages_OffsetX[Number_of_Flying_Images]
	DIM FlyingImages_OffsetY[Number_of_Flying_Images]
	DIM FlyingImages_Time[Number_of_Flying_Images]
	DIM FlyingImages_PlaySound[Number_of_Flying_Images]
	
	FlyingImages_Speed = 0.05 '0.04
	
	FlyingImages[0] = LOGO_ID
	FlyingImages[1] = PRESENTS_ID
	FlyingImages[2] = MENUE_IMAGE_ID_FONT_64x64 + asc("G")
	FlyingImages[3] = MENUE_IMAGE_ID_FONT_64x64 + asc("A")
	FlyingImages[4] = MENUE_IMAGE_ID_FONT_64x64 + asc("L")
	FlyingImages[5] = MENUE_IMAGE_ID_FONT_64x64 + asc("A")
	FlyingImages[6] = MENUE_IMAGE_ID_FONT_64x64 + asc("X")
	FlyingImages[7] = MENUE_IMAGE_ID_FONT_64x64 + asc("Y")
	FlyingImages[8] = MENUE_IMAGE_ID_FONT_64x64 + asc("R")
	FlyingImages[9] = MENUE_IMAGE_ID_FONT_64x64 + asc("A")
	FlyingImages[10] = MENUE_IMAGE_ID_FONT_64x64 + asc("N")
	FlyingImages[11] = MENUE_IMAGE_ID_FONT_64x64 + asc("G")
	FlyingImages[12] = MENUE_IMAGE_ID_FONT_64x64 + asc("E")
	FlyingImages[13] = MENUE_IMAGE_ID_FONT_64x64 + asc("R")
	FlyingImages[14] = GALAXYRANGER_ID
	
	Start1 = 64
	Start2 = 96
	FlyingImages_PosX[0] = 90
	FlyingImages_PosY[0] = 8
	FlyingImages_PosX[1] = 358
	FlyingImages_PosY[1] = 160 
	FlyingImages_PosX[2] = Start1
	FlyingImages_PosY[2] = 192 + 60
	FlyingImages_PosX[3] = Start1 + 64
	FlyingImages_PosY[3] = 192 + 60
	FlyingImages_PosX[4] = Start1 + 64 * 2
	FlyingImages_PosY[4] = 192 + 60
	FlyingImages_PosX[5] = Start1 + 64 * 3
	FlyingImages_PosY[5] = 192 + 60
	FlyingImages_PosX[6] = Start1 + 64 * 4
	FlyingImages_PosY[6] = 192 + 60
	FlyingImages_PosX[7] = Start1 + 64 * 5
	FlyingImages_PosY[7] = 192 + 60
	FlyingImages_PosX[8] = Start2
	FlyingImages_PosY[8] = 278 + 60
	FlyingImages_PosX[9] = Start2 + 64
	FlyingImages_PosY[9] = 278 + 60
	FlyingImages_PosX[10] = Start2 + 64 * 2
	FlyingImages_PosY[10] = 278 + 60
	FlyingImages_PosX[11] = Start2 + 64 * 3
	FlyingImages_PosY[11] = 278 + 60
	FlyingImages_PosX[12] = Start2 + 64 * 4
	FlyingImages_PosY[12] = 278 + 60
	FlyingImages_PosX[13] = Start2 + 64 * 5
	FlyingImages_PosY[13] = 278 + 60
	FlyingImages_PosX[14] = 470
	FlyingImages_PosY[14] = 180 + 60
		
	OffsetX = 0
	OffsetY = 0
		
	for ii = 0 to Number_of_Flying_Images - 1
		FlyingImages_Time[ii] = -40 * ii - 40
		GetImageSize(FlyingImages[ii], OffsetX, OffsetY)
		FlyingImages_OffsetX[ii] = OffsetX/2
		FlyingImages_OffsetY[ii] = OffsetY/2
		FlyingImages_PlaySound[ii] = true
	next
	FlyingImages_Time[0] = -50
	FlyingImages_Time[1] = -80
	
	SplashScreen_isRunning = true
	TimeStep = 0
	PosX = 0
	PosY = 0
	Wait_a_while = 0
	
	while(SplashScreen_isRunning)
	
		if(key(K_ESCAPE) OR key(K_RETURN) OR key(K_SPACE) OR GetJoystick(JOYSTICK_ESCAPE) OR GetJoystick(JOYSTICK_FIRE) ) then
			SplashScreen_isRunning = false			
			GUI_Button_Cooldown = GUI_MAX_BUTTON_COOLDOWN*2
		end if
			
	
		MeassureFrameTimeStart = Timer()
		ClearCanvas()
		Draw_Shake_Canvas(CANVAS_MENUE, 0)
		GUI_Show_Stars()
	
		for ii = Number_of_Flying_Images - 1 to 0 Step -1
		
			FlyingImages_Time[ii] = FlyingImages_Time[ii] + TimeStep * FlyingImages_Speed
		
			if( FlyingImages_Time[ii] > 1/FlyingImages_Speed) then 
					FlyingImages_Time[ii] = 1/FlyingImages_Speed
					
					if(FlyingImages_PlaySound[ii]) then
						FlyingImages_PlaySound[ii] = false
						'PlaySound(ENEMY_SETTINGS_SOUND_OFFSET_EXPLODE_TYPE_1,SOUND_CHANNEL_ENEMY,0)
						CANVAS_SHAKE = true
					end if
			end if
		
			if(FlyingImages_Time[ii] > 0) then 
				
				Zoom = FlyingImages_Time[ii] * FlyingImages_Speed 
				
				PosX = SCREENX/2 - FlyingImages_OffsetX[ii]*Zoom/2 + (FlyingImages_PosX[ii] + FlyingImages_OffsetX[ii]*Zoom/2 - SCREENX/2) * FlyingImages_Time[ii] * FlyingImages_Speed
				PosY = SCREENY/2 - FlyingImages_OffsetY[ii]*Zoom/2 + (FlyingImages_PosY[ii] + FlyingImages_OffsetY[ii]*Zoom/2 - SCREENY/2) * FlyingImages_Time[ii] * FlyingImages_Speed
							
				
				DrawImage_Zoom(FlyingImages[ii], PosX, PosY,Zoom,Zoom)
				
			end if
			
		next
		
		
		if(FlyingImages_Time[Number_of_Flying_Images - 1] = 1/FlyingImages_Speed) then 
			Wait_a_while = Wait_a_while + TimeStep
			if(Wait_a_while > 5000) then
				SplashScreen_isRunning = false
			end if
		end if
		
		update()
		
		TimeStep = ((Timer() - MeassureFrameTimeStart))
		if(TimeStep < 20) then 'Throttle to 20ms per frame
			wait(20 - TimeStep)
			TimeStep = 20
		end if
		
		
	wend


	'Free data
	DeleteImage(LOGO_ID)
	DeleteImage(PRESENTS_ID)
	DeleteImage(GALAXYRANGER_ID)
	ImageID = LOGO_ID
	
end sub

sub SetFlashingColor(pos)
	if(SettingsPosition = pos) then
		SetColor(HighscoreColors[0])
	end if
end sub

function GUI_GetJoystickString$(J)

	S$ = "J" + str(JOYSTICK[J, JOYSTICK_NUMBER])
	
	select case JOYSTICK[J, JOYSTICK_DEVICE]
		case JOYSTICK_HAT
			S = S + "H" + str(JOYSTICK[J, JOYSTICK_DEVICE_NUMBER]) + "D" + str(JOYSTICK[J, JOYSTICK_DEVICE_VALUE])
		case JOYSTICK_AXIS
			S = S + "A" + str(JOYSTICK[J, JOYSTICK_DEVICE_NUMBER])
		default
			S = S + "B" + str(JOYSTICK[J, JOYSTICK_DEVICE_NUMBER])
	end select

	return S

end function


sub GUI_Show_Settings()
	Font(1)
		
	Highscore_ColorTimer = Highscore_ColorTimer - TimeStep
	if(Highscore_ColorTimer < 0 ) then
		
		Highscore_ColorTimer = 50
		TempColor = HighscoreColors[8]
		
		for ii = 8 to 1 step -1
			HighscoreColors[ii] = HighscoreColors[ii - 1]
		next
		
		HighscoreColors[0] = TempColor
		
	end if
	
	
	OffsetY = SettingsPosition*32
	
	DifficultyStr$ = ""
	VsyncStr$ = ""
	FullScreenStr$ = ""
	
	P1_KeyUpStr$ = GUI_GetKeyString(KEY_USER_UP)
	P1_KeyDownStr$ = GUI_GetKeyString(KEY_USER_DOWN)
	P1_KeyLeftStr$= GUI_GetKeyString(KEY_USER_LEFT)
	P1_KeyRightStr$ = GUI_GetKeyString(KEY_USER_RIGHT)
	P1_KeyFireStr$ = GUI_GetKeyString(KEY_USER_FIRE)
		
	P1_JoyUpStr$ = GUI_GetJoystickString(JOYSTICK_UP)
	P1_JoyDownStr$ = GUI_GetJoystickString(JOYSTICK_Down)
	P1_JoyLeftStr$ = GUI_GetJoystickString(JOYSTICK_Left)
	P1_JoyRightStr$ = GUI_GetJoystickString(JOYSTICK_Right)
	P1_JoyFireStr$ = GUI_GetJoystickString(JOYSTICK_Fire)
	P1_JoyEscapeStr$ = GUI_GetJoystickString(JOYSTICK_ESCAPE)
	
	select case SETTINGS_DIFFICULTY
		case 0.6:
			DifficultyStr = "EASY"
		case 0.8:
			DifficultyStr = "NORMAL"
		case 1.0:
			DifficultyStr = "EXPERT"
		case 1.2:
			DifficultyStr = "GOD"
	end select
	select case SETTINGS_VSYNC
		case 0:
			VsyncStr = "OFF"
		case 1:
			VsyncStr = "ON"
	end select
	select case SETTINGS_FULLSCREEN
		case 0:
			FullScreenStr = "NO"
		case 1:
			FullScreenStr = "YES"
	end select
	
	'Player wants to change a key
	if(GUI_STATE_SETTINGS_P1_KEY <> -1) then
		select case GUI_STATE_SETTINGS_P1_KEY
			case K_LEFT:
				P1_KeyLeftStr = "???"
				if(GUI_Button_Cooldown = 0) then
					KeyCode = GUI_Setkey(KEY_USER_LEFT)
					if( KeyCode <> -1 AND KeyCode <> KEY_USER_RIGHT AND KeyCode <> KEY_USER_UP AND KeyCode <> KEY_USER_DOWN AND KeyCode <> KEY_USER_FIRE AND KeyCode <> K_RIGHT AND KeyCode <> K_UP AND KeyCode <> K_DOWN AND KeyCode <> K_RETURN AND KeyCode <> K_SPACE) then
						GUI_Button_Cooldown = GUI_MAX_BUTTON_COOLDOWN
						KEY_USER_LEFT = KeyCode
						GUI_STATE_SETTINGS_P1_KEY = -1
						P1_KeyLeftStr = GUI_GetKeyString(KEY_USER_LEFT)
					end if
				end if
			case K_RIGHT:
				P1_KeyRightStr = "???"
				if(GUI_Button_Cooldown = 0) then
					KeyCode = GUI_Setkey(KEY_USER_RIGHT)
					if( KeyCode <> -1 AND KeyCode <> KEY_USER_LEFT AND KeyCode <> KEY_USER_UP AND KeyCode <> KEY_USER_DOWN AND KeyCode <> KEY_USER_FIRE AND KeyCode <> K_LEFT AND KeyCode <> K_UP AND KeyCode <> K_DOWN AND KeyCode <> K_RETURN AND KeyCode <> K_SPACE) then
						GUI_Button_Cooldown = GUI_MAX_BUTTON_COOLDOWN
						KEY_USER_RIGHT = KeyCode
						GUI_STATE_SETTINGS_P1_KEY = -1
						P1_KeyRightStr = GUI_GetKeyString(KEY_USER_RIGHT)
					end if
				end if
			case K_UP:
				P1_KeyUpStr = "???"
				if(GUI_Button_Cooldown = 0) then
					KeyCode = GUI_Setkey(KEY_USER_UP)
					if( KeyCode <> -1 AND KeyCode <> KEY_USER_LEFT AND KeyCode <> KEY_USER_RIGHT AND KeyCode <> KEY_USER_DOWN AND KeyCode <> KEY_USER_FIRE AND KeyCode <> K_LEFT AND KeyCode <> K_RIGHT AND KeyCode <> K_DOWN AND KeyCode <> K_RETURN AND KeyCode <> K_SPACE) then
						GUI_Button_Cooldown = GUI_MAX_BUTTON_COOLDOWN
						KEY_USER_UP = KeyCode
						GUI_STATE_SETTINGS_P1_KEY = -1
						P1_KeyUpStr = GUI_GetKeyString(KEY_USER_UP)
					end if
				end if
			case K_DOWN:
				P1_KeyDownStr = "???"
				if(GUI_Button_Cooldown = 0) then
					KeyCode = GUI_Setkey(KEY_USER_DOWN)
					if( KeyCode <> -1 AND KeyCode <> KEY_USER_LEFT AND KeyCode <> KEY_USER_RIGHT AND KeyCode <> KEY_USER_UP AND KeyCode <> KEY_USER_FIRE AND KeyCode <> K_LEFT AND KeyCode <> K_RIGHT AND KeyCode <> K_UP AND KeyCode <> K_RETURN AND KeyCode <> K_SPACE) then
						GUI_Button_Cooldown = GUI_MAX_BUTTON_COOLDOWN
						KEY_USER_DOWN = KeyCode
						GUI_STATE_SETTINGS_P1_KEY = -1
						P1_KeyDownStr = GUI_GetKeyString(KEY_USER_DOWN)
					end if
				end if	
			case K_SPACE:
				P1_KeyFireStr = "???"
				if(GUI_Button_Cooldown = 0) then
					KeyCode = GUI_Setkey(KEY_USER_FIRE)
					if( KeyCode <> -1 AND KeyCode <> KEY_USER_LEFT AND KeyCode <> KEY_USER_RIGHT AND KeyCode <> KEY_USER_UP AND KeyCode <> KEY_USER_DOWN AND KeyCode <> K_LEFT AND KeyCode <> K_RIGHT AND KeyCode <> K_UP AND KeyCode <> K_DOWN ) then
						GUI_Button_Cooldown = GUI_MAX_BUTTON_COOLDOWN
						KEY_USER_FIRE = KeyCode
						GUI_STATE_SETTINGS_P1_KEY = -1
						P1_KeyFireStr = GUI_GetKeyString(KEY_USER_FIRE)
					end if
				end if		
		end select

	end if
	
	'Player wants to change a joystick
	
	if(GUI_STATE_SETTINGS_P1_JOY <> -1) then
		select case GUI_STATE_SETTINGS_P1_JOY
			case JOYSTICK_LEFT:
				P1_JoyLeftStr = "???"
				if(GUI_Button_Cooldown = 0) then
					if(SetJoystickButton()) then
						GUI_Button_Cooldown = GUI_MAX_BUTTON_COOLDOWN
						'Check if this button is already in use
						if(CompareJoystickSetting(JOYSTICK_LEFT)) then						
							JOYSTICK[JOYSTICK_LEFT, JOYSTICK_NUMBER] = JOYSTICK_TEMP[JOYSTICK_NUMBER]
							JOYSTICK[JOYSTICK_LEFT, JOYSTICK_DEVICE] = JOYSTICK_TEMP[JOYSTICK_DEVICE]
							JOYSTICK[JOYSTICK_LEFT, JOYSTICK_DEVICE_NUMBER] = JOYSTICK_TEMP[JOYSTICK_DEVICE_NUMBER]
							JOYSTICK[JOYSTICK_LEFT, JOYSTICK_DEVICE_VALUE] = JOYSTICK_TEMP[JOYSTICK_DEVICE_VALUE]
							GUI_STATE_SETTINGS_P1_JOY = -1
							GUI_Button_Cooldown = GUI_MAX_BUTTON_COOLDOWN*3
						end if
						
					end if
				end if
				
			case JOYSTICK_RIGHT:
				P1_JoyRightStr = "???"
				if(GUI_Button_Cooldown = 0) then

					if(SetJoystickButton()) then
						GUI_Button_Cooldown = GUI_MAX_BUTTON_COOLDOWN
						
						'Check if this button is already in use
						if(CompareJoystickSetting(JOYSTICK_RIGHT)) then						
							JOYSTICK[JOYSTICK_RIGHT, JOYSTICK_NUMBER] = JOYSTICK_TEMP[JOYSTICK_NUMBER]
							JOYSTICK[JOYSTICK_RIGHT, JOYSTICK_DEVICE] = JOYSTICK_TEMP[JOYSTICK_DEVICE]
							JOYSTICK[JOYSTICK_RIGHT, JOYSTICK_DEVICE_NUMBER] = JOYSTICK_TEMP[JOYSTICK_DEVICE_NUMBER]
							JOYSTICK[JOYSTICK_RIGHT, JOYSTICK_DEVICE_VALUE] = JOYSTICK_TEMP[JOYSTICK_DEVICE_VALUE]
							GUI_STATE_SETTINGS_P1_JOY = -1
							GUI_Button_Cooldown = GUI_MAX_BUTTON_COOLDOWN*3
						end if
						
					end if
				end if
			case JOYSTICK_UP:
				P1_JoyUpStr = "???"
				if(GUI_Button_Cooldown = 0) then

					if(SetJoystickButton()) then
						GUI_Button_Cooldown = GUI_MAX_BUTTON_COOLDOWN
						
						'Check if this button is already in use
						if(CompareJoystickSetting(JOYSTICK_UP)) then						
							JOYSTICK[JOYSTICK_UP, JOYSTICK_NUMBER] = JOYSTICK_TEMP[JOYSTICK_NUMBER]
							JOYSTICK[JOYSTICK_UP, JOYSTICK_DEVICE] = JOYSTICK_TEMP[JOYSTICK_DEVICE]
							JOYSTICK[JOYSTICK_UP, JOYSTICK_DEVICE_NUMBER] = JOYSTICK_TEMP[JOYSTICK_DEVICE_NUMBER]
							JOYSTICK[JOYSTICK_UP, JOYSTICK_DEVICE_VALUE] = JOYSTICK_TEMP[JOYSTICK_DEVICE_VALUE]
							GUI_STATE_SETTINGS_P1_JOY = -1
							GUI_Button_Cooldown = GUI_MAX_BUTTON_COOLDOWN*3
						end if
						
					end if
				end if
			case JOYSTICK_DOWN:
				P1_JoyDownStr = "???"
				if(GUI_Button_Cooldown = 0) then

					if(SetJoystickButton()) then
						GUI_Button_Cooldown = GUI_MAX_BUTTON_COOLDOWN
						
						'Check if this button is already in use
						if(CompareJoystickSetting(JOYSTICK_DOWN)) then						
							JOYSTICK[JOYSTICK_DOWN, JOYSTICK_NUMBER] = JOYSTICK_TEMP[JOYSTICK_NUMBER]
							JOYSTICK[JOYSTICK_DOWN, JOYSTICK_DEVICE] = JOYSTICK_TEMP[JOYSTICK_DEVICE]
							JOYSTICK[JOYSTICK_DOWN, JOYSTICK_DEVICE_NUMBER] = JOYSTICK_TEMP[JOYSTICK_DEVICE_NUMBER]
							JOYSTICK[JOYSTICK_DOWN, JOYSTICK_DEVICE_VALUE] = JOYSTICK_TEMP[JOYSTICK_DEVICE_VALUE]
							GUI_STATE_SETTINGS_P1_JOY = -1
							GUI_Button_Cooldown = GUI_MAX_BUTTON_COOLDOWN*3
						end if
						
					end if
				end if
			case JOYSTICK_FIRE:
				P1_JoyFireStr = "???"
				if(GUI_Button_Cooldown = 0) then

					if(SetJoystickButton()) then
						GUI_Button_Cooldown = GUI_MAX_BUTTON_COOLDOWN
						
						'Check if this button is already in use
						if(CompareJoystickSetting(JOYSTICK_FIRE)) then						
							JOYSTICK[JOYSTICK_FIRE, JOYSTICK_NUMBER] = JOYSTICK_TEMP[JOYSTICK_NUMBER]
							JOYSTICK[JOYSTICK_FIRE, JOYSTICK_DEVICE] = JOYSTICK_TEMP[JOYSTICK_DEVICE]
							JOYSTICK[JOYSTICK_FIRE, JOYSTICK_DEVICE_NUMBER] = JOYSTICK_TEMP[JOYSTICK_DEVICE_NUMBER]
							JOYSTICK[JOYSTICK_FIRE, JOYSTICK_DEVICE_VALUE] = JOYSTICK_TEMP[JOYSTICK_DEVICE_VALUE]
							GUI_STATE_SETTINGS_P1_JOY = -1
							GUI_Button_Cooldown = GUI_MAX_BUTTON_COOLDOWN*3
						end if
						
					end if
				end if
				
			case JOYSTICK_ESCAPE:
				P1_JoyEscapeStr = "???"
				if(GUI_Button_Cooldown = 0) then
					if(SetJoystickButton()) then
						GUI_Button_Cooldown = GUI_MAX_BUTTON_COOLDOWN
						'Check if this button is already in use
						if(CompareJoystickSetting(JOYSTICK_LEFT)) then						
							JOYSTICK[JOYSTICK_ESCAPE, JOYSTICK_NUMBER] = JOYSTICK_TEMP[JOYSTICK_NUMBER]
							JOYSTICK[JOYSTICK_ESCAPE, JOYSTICK_DEVICE] = JOYSTICK_TEMP[JOYSTICK_DEVICE]
							JOYSTICK[JOYSTICK_ESCAPE, JOYSTICK_DEVICE_NUMBER] = JOYSTICK_TEMP[JOYSTICK_DEVICE_NUMBER]
							JOYSTICK[JOYSTICK_ESCAPE, JOYSTICK_DEVICE_VALUE] = JOYSTICK_TEMP[JOYSTICK_DEVICE_VALUE]
							GUI_STATE_SETTINGS_P1_JOY = -1
							GUI_Button_Cooldown = GUI_MAX_BUTTON_COOLDOWN*3
						end if
						
					end if
				end if	
		end select

	end if
	
	
	SetColor(COLOR_PALETTE[22])
	SetFlashingColor(0)
	DrawText("DIFFICULTY: " + DifficultyStr,		32, 240        - OffsetY)
	SetColor(COLOR_PALETTE[22])
	SetFlashingColor(1)	
	DrawText("     VSYNC: " + VsyncStr,				32, 240 + 32   - OffsetY)
	SetColor(COLOR_PALETTE[22])
	SetFlashingColor(2)	
	DrawText("FULLSCREEN: " + FullScreenStr,		32, 240 + 32*2   - OffsetY)
	SetColor(COLOR_PALETTE[22])
	SetFlashingColor(3)	
	DrawText(" MUSIC VOL: " + str(SETTINGS_MUSIC_VOLUME),32, 240 + 32*3   - OffsetY)
	
	SetColor(COLOR_PALETTE[1])
	SetFlashingColor(4)	
	DrawText("P1 JOY  LEFT: " + P1_JoyLeftStr,		32, 240 + 32*4 - OffsetY)
	SetColor(COLOR_PALETTE[1])
	SetFlashingColor(5)	
	DrawText("P1 JOY RIGHT: " + P1_JoyRightStr,		32, 240 + 32*5 - OffsetY)
	SetColor(COLOR_PALETTE[1])
	SetFlashingColor(6)	
	DrawText("P1 JOY    UP: " + P1_JoyUpStr,		32, 240 + 32*6 - OffsetY)
	SetColor(COLOR_PALETTE[1])
	SetFlashingColor(7)	
	DrawText("P1 JOY  DOWN: " + P1_JoyDownStr,		32, 240 + 32*7 - OffsetY)
	SetColor(COLOR_PALETTE[1])
	SetFlashingColor(8)	
	DrawText("P1 JOY  FIRE: " + P1_JoyFireStr,		32, 240 + 32*8 - OffsetY)
	SetColor(COLOR_PALETTE[1])
	SetFlashingColor(9)	
	DrawText("P1 JOY   ESC: " + P1_JoyEscapeStr,	32, 240 + 32*9 - OffsetY)
	
	SetColor(COLOR_PALETTE[18])
	SetFlashingColor(10)		
	DrawText("P1 KEY  LEFT: " + P1_KeyLeftStr,		32, 240 + 32*10 - OffsetY)
	SetColor(COLOR_PALETTE[18])
	SetFlashingColor(11)	
	DrawText("P1 KEY RIGHT: " + P1_KeyRightStr,		32, 240 + 32*11 - OffsetY)
	SetColor(COLOR_PALETTE[18])
	SetFlashingColor(12)	
	DrawText("P1 KEY    UP: " + P1_KeyUpStr,		32, 240 + 32*12 - OffsetY)
	SetColor(COLOR_PALETTE[18])
	SetFlashingColor(13)	
	DrawText("P1 KEY  DOWN: " + P1_KeyDownStr,		32, 240 + 32*13 - OffsetY)
	SetColor(COLOR_PALETTE[18])
	SetFlashingColor(14)	
	DrawText("P1 KEY  FIRE: " + P1_KeyFireStr,		32, 240 + 32*14 - OffsetY)

	Font(0)
end sub

sub GUI_Show_Credits()
	OffsetY = 32
	
	Font(1)
		
	SetColor(COLOR_PALETTE[18])
	DrawText("GAME,GRAPHIC,SOUND",	32, 0 + OffsetY)
	SetColor(COLOR_PALETTE[22])
	DrawText(" J7M (2021)",				32, 32 + OffsetY)
	SetColor(COLOR_PALETTE[18])
	DrawText("MUSIC",				32, 32 * 3 + OffsetY)
	SetColor(COLOR_PALETTE[22])
	DrawText(" DUALTRAX CHIPTUNE",	32, 32 * 4 + OffsetY)
	DrawText(" AGAINST THE TIME",	32, 32 * 5 + OffsetY)
	DrawText(" (CC-BY)",			32, 32 * 6 + OffsetY)
	SetColor(COLOR_PALETTE[18])
	DrawText("MADE WITH",			32, 32 * 8 + OffsetY)
	SetColor(COLOR_PALETTE[22])
	DrawText(" RC-BASIC, KRITA,",	32, 32 * 9 + OffsetY)
	DrawText(" BLENDER, GEANY,",	32, 32 * 10 + OffsetY)
	DrawText(" CHIPTONE,",			32, 32 * 11 + OffsetY)
	DrawText(" PIXELORAMA",			32, 32 * 12 + OffsetY)
	
	
	Font(0)
end sub
