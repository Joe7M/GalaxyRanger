' RCBASIC
' J7M - Joerg Siebenmorgen
' License: MIT

' For testing
IsTesting = false
Start_Position = 1590
Number_of_Bonus_HitPoints = 0
Number_of_Bonus_Speed = 3
Number_of_Bonus_Power = 1
Number_of_Bonus_Life = 1
Number_of_Bonus_Shot_Repetition = 1

include "./SRC/Definitions.bas"
include "./SRC/Joystick.bas"
include "./SRC/Init.bas"
include "./SRC/LoadData.bas"
include "./SRC/Sound.bas"
include "./SRC/Keyboard.bas"
include "./SRC/ProcessInput.bas"
include "./SRC/CheckCollitions.bas"
include "./SRC/Update.bas"
include "./SRC/Draw.bas"
include "./SRC/GUI.bas"

InitJoystick()
LoadSettings()
Init_Window()
Load_GlobalData()
Init()
GUI_Load_Highscore()




if(IsTesting) then
	Position = Start_Position
	Player[0, PLAYER_ACCELERATION] = 0.0007 * 1.20^Number_of_Bonus_Speed
	Player[0, PLAYER_MAX_ACCELERATION] = 0.07 * 1.20^Number_of_Bonus_Speed					
	Player[0, PLAYER_SHOT_TYPE] = Number_of_Bonus_Power + 1
	Player[0, PLAYER_LIVES] = 3 + Number_of_Bonus_Life
	Player[0, PLAYER_LIVES] = -1
	Player[0, PLAYER_SHOT_DELAY] = PLAYER_SHOTS_SETTINGS_DELAY * 0.8^Number_of_Bonus_Shot_Repetition
else	
	Canvas(CANVAS_MENUE)
	PlayMusic(-1)
	SetMusicVolume(100)
	GUI_Reset_Stars()
	GUI_Show_Splash_Screen()
end if



while(Program_is_running)

	ResumeMusic()
	SetMusicVolume(100)
	
	'####################### Menue Loop ###########################
	if(NOT IsTesting) then
		Menue_is_running = true
		Canvas(CANVAS_MENUE)
		SetCanvasVisible(CANVAS_MENUE, true)		
		
		while(Menue_is_running)
				
			MeassureFrameTimeStart = Timer()
			
			ClearCanvas()
			GUI_Process_Input()
			GUI_Show_Stars()
			
			select case GUI_STATE
				case GUI_STATE_MENUE:
					GUI_Show_Menue()
				case GUI_STATE_HIGHSCORE:
					GUI_Show_Highscore()
				case GUI_STATE_SETTINGS:
					GUI_Show_Settings()
				case GUI_STATE_CREDITS:
					GUI_Show_Credits()
			end select
			
			update()
		
			TimeStep = ((Timer() - MeassureFrameTimeStart))
			if(TimeStep < 20) then 'Throttle to 20ms per frame
				wait(20 - TimeStep)
				TimeStep = 20
			end if
		wend
	end if
	
	SetCanvasVisible(CANVAS_MENUE, false)
	
	SetMusicVolume(SETTINGS_MUSIC_VOLUME)
	
	if(SETTINGS_MUSIC_VOLUME = 0) then
		PauseMusic()		
	end if

	'####################### Game Loop ###########################

	Init()
	
	select case Level_Number
		case 1:
			if(Level_Data_loaded <> 1) then
				Free_Dynamic_Data()
				LevelFile$ = "./DATA/LVL1/LEVEL.TXT"
				EnemyFile$ = "./DATA/LVL1/ENEMIES.TXT"
				BGFile$ = "./DATA/LVL1/BG.TXT"
				Load_DynamicData(LevelFile$, EnemyFile$, BGFile$)
				Active_Enemies = NUMBER_OF_ENEMIES
				GAME_STATE = GAME_STATE_GAME_IS_RUNNING			
			end if	
		case 2:
			GAME_STATE = GAME_STATE_ALL_LEVEL_FINISHED
	end select	
	
	
	While( GAME_STATE <> GAME_STATE_GAME_CANCELED AND GAME_STATE <> GAME_STATE_PLAYERS_DEAD AND GAME_STATE <> GAME_STATE_LEVEL_FINISHED)
	
		MeassureFrameTimeStart = Timer()
		NumberOfFrames = NumberOfFrames + 1
	  
		GameTicks = GameTicks + TimeStep
		Position = Position + TimeStep * SCROLLSPEED

		if(Position > (TILESIZE * (LEVEL_SIZE_X - NUMBER_OF_TILES_X - 1))) then 'Boss fight 
			'stop scrolling
			BACKGROUND_IMAGES_SCROLLSPEED = 0
			if(Active_Enemies < 1) then
				GAME_STATE = GAME_STATE_LEVEL_FINISHED
			end if
		else	
			LevelTilePosX  = int(int(Position) / TileSize)
			ScrollOffset = int(Position) MOD TileSize
		end if
		  
	   
		ProcessInput()
		
		UpdatePlayerShots()
		UpdateEnemyShots()
		UpdateBonus()
		
		CheckCollisionsPlayerShots()
		CheckCollisionPlayerBonus()
			
		UpdatePlayer()		

		Canvas(CANVAS_HEADER)	
		DrawHeader()
		
		Canvas(CANVAS_MAIN)
		ClearCanvas()
		Draw_Shake_Canvas(CANVAS_MAIN, 32)
		DrawBackgroundImages()
		DrawLevel_BackgroundCenter_Layer()
		DrawBonus()
		DrawPlayer()
		DrawEnemyShots()
		DrawEnemey()
		DrawPlayerShots()
		DrawLevel_Front_Layer()
		'DrawInfos()
		
		if(not WindowExists(0)) then
			WindowClose(0)
			end
		end if
		
		update
		
		TimeStep = ((Timer() - MeassureFrameTimeStart))
		if(TimeStep < 20) then 'Throttle to 20ms per frame
			wait(20 - TimeStep)
			TimeStep = 20
		end if		
			 
	wend
	
	if(GAME_STATE = GAME_STATE_LEVEL_FINISHED) then
		Level_Number = Level_Number + 1
		if(Level_Number > NUMBER_OF_LEVELS) then
			GAME_STATE = GAME_STATE_ALL_LEVEL_FINISHED  'End game and jump to highscore
		end if
	end if
		
	'####################### Game Over Loop #######################
	if(GAME_STATE <> GAME_STATE_LEVEL_FINISHED) then
		
		Level_Number = 1
		
		'Save last frame
		CanvasClip ( ImageID, 0, 0, SCREENX, SCREENY - 32, 1 )
		Game_Over_Timer = 1000
		
		PosX_Game = 640
		PosX_Over = 640 + 64*5
		PosY = 200
		Loop_is_running = true
		
		while(Loop_is_running)
		
			MeassureFrameTimeStart = Timer()
			Game_Over_Timer = Game_Over_Timer - TimeStep
			if(Game_Over_Timer < 1) then
				Game_Over_Timer = 1
				if(key(K_ESCAPE) OR key(K_SPACE) OR key(K_RETURN) OR GetJoystick(JOYSTICK_FIRE)) then
					Loop_is_running = false
				end if
			end if
			
			Canvas(CANVAS_HEADER)	
			DrawHeader()
		
			Canvas(CANVAS_MAIN)
			ClearCanvas()
			DrawImage(ImageID,0,0)
			
			
			
			if(GAME_STATE = GAME_STATE_ALL_LEVEL_FINISHED) then
				
				PosX_Game = PosX_Game - 1
				if(PosX_Game < -64*14) then
					PosX_Game = 640
				end if
			
				DrawImage(MENUE_IMAGE_ID_FONT_64x64 + asc("C"), PosX_Game , PosY)
				DrawImage(MENUE_IMAGE_ID_FONT_64x64 + asc("O"), PosX_Game+64 , PosY)
				DrawImage(MENUE_IMAGE_ID_FONT_64x64 + asc("N"), PosX_Game+64*2 , PosY)
				DrawImage(MENUE_IMAGE_ID_FONT_64x64 + asc("G"), PosX_Game+64*3 , PosY)
				DrawImage(MENUE_IMAGE_ID_FONT_64x64 + asc("R"), PosX_Game+64*4 , PosY)
				DrawImage(MENUE_IMAGE_ID_FONT_64x64 + asc("A"), PosX_Game+64*5 , PosY)
				DrawImage(MENUE_IMAGE_ID_FONT_64x64 + asc("T"), PosX_Game+64*6 , PosY)
				DrawImage(MENUE_IMAGE_ID_FONT_64x64 + asc("U"), PosX_Game+64*7 , PosY)
				DrawImage(MENUE_IMAGE_ID_FONT_64x64 + asc("L"), PosX_Game+64*8 , PosY)
				DrawImage(MENUE_IMAGE_ID_FONT_64x64 + asc("A"), PosX_Game+64*9 , PosY)
				DrawImage(MENUE_IMAGE_ID_FONT_64x64 + asc("T"), PosX_Game+64*10 , PosY)
				DrawImage(MENUE_IMAGE_ID_FONT_64x64 + asc("I"), PosX_Game+64*11 , PosY)
				DrawImage(MENUE_IMAGE_ID_FONT_64x64 + asc("O"), PosX_Game+64*12 , PosY)
				DrawImage(MENUE_IMAGE_ID_FONT_64x64 + asc("N"), PosX_Game+64*13 , PosY)
			else
				PosX_Game = PosX_Game - 1
				if(PosX_Game < -64*4) then
					PosX_Game = 640
				end if
				PosX_Over = PosX_Over - 1
				if(PosX_Over < -64*4) then
					PosX_Over = 640
				end if
				DrawImage(MENUE_IMAGE_ID_FONT_64x64 + asc("G"), PosX_Game , PosY)
				DrawImage(MENUE_IMAGE_ID_FONT_64x64 + asc("A"), PosX_Game+64 , PosY)
				DrawImage(MENUE_IMAGE_ID_FONT_64x64 + asc("M"), PosX_Game+64*2 , PosY)
				DrawImage(MENUE_IMAGE_ID_FONT_64x64 + asc("E"), PosX_Game+64*3 , PosY)
				DrawImage(MENUE_IMAGE_ID_FONT_64x64 + asc("O"), PosX_Over , PosY)
				DrawImage(MENUE_IMAGE_ID_FONT_64x64 + asc("V"), PosX_Over+64 , PosY)
				DrawImage(MENUE_IMAGE_ID_FONT_64x64 + asc("E"), PosX_Over+64*2 , PosY)
				DrawImage(MENUE_IMAGE_ID_FONT_64x64 + asc("R"), PosX_Over+64*3 , PosY)
			end if
		
			if(not WindowExists(0)) then
				WindowClose(0)
				end
			end if
		
			update
			TimeStep = ((Timer() - MeassureFrameTimeStart))
			if(TimeStep < 20) then 'Throttle to 20ms per frame
				wait(20 - TimeStep)
				TimeStep = 20
			end if	
		wend
		DeleteImage(ImageID)
	end if
	
	
	'####################### Highscore Loop #######################

	'GAME_STATE = GAME_STATE_PLAYERS_DEAD 'For testing
	GUI_Button_Cooldown = GUI_MAX_BUTTON_COOLDOWN
	
	'if Players are dead, then update highscore
	if(GAME_STATE = GAME_STATE_PLAYERS_DEAD OR GAME_STATE = GAME_STATE_GAME_CANCELED OR GAME_STATE = GAME_STATE_ALL_LEVEL_FINISHED) then
		GUI_Reset_Stars()
		'New higscore?
		
		Highscore_Position = -1
		
		for ii = 8 to 0 step -1
			if(Player[0, PLAYER_POINTS] > HighscoreValue[ii]) then
				Highscore_Position = ii
			end if
		next
		if(Highscore_Position > -1) then
			'Shift highscore entries
			for ii = 7 to Highscore_Position step -1
				HighscoreName[ii + 1] =  HighscoreName[ii]
				HighscoreValue[ii + 1] = HighscoreValue[ii]
			next
			HighscoreName[Highscore_Position] = "???"
			HighscoreValue[Highscore_Position] = Player[0, PLAYER_POINTS]
			
			GUI_STATE = GUI_STATE_EDIT_HIGHSCORE
		end if
		
		'Display Highsore
		Menue_is_running = true
		
		Canvas(CANVAS_MENUE)
		SetCanvasVisible(CANVAS_MENUE, true)
		
		
		While( (Menue_is_running))
	
			MeassureFrameTimeStart = Timer()
			ClearCanvas()			
			
			GUI_Process_Input()
			GUI_Show_Stars()
			GUI_Show_Highscore()
			
			
			if(not WindowExists(0)) then
				WindowClose(0)
				end
			end if
		
			update()	
		
			TimeStep = ((Timer() - MeassureFrameTimeStart))
		
			if(TimeStep < 20) then 'Throttle to 20ms per frame
				wait(20 - TimeStep)
				TimeStep = 20
			end if
		
		wend
		
		SetCanvasVisible(CANVAS_MENUE, false)
	
	end if
	
	'Program_is_running = false
	
wend 'Program_is_running

WindowClose(0)


ElapsedTime = (Timer() - TickStart)/1000
fprint("Elapsed Time = ")
print(ElapsedTime)
fprint("FPS = ")
print(NumberOfFrames / ElapsedTime)


end
'#############################################################################################



