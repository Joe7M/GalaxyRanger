Program_is_running = true
Menue_is_running = true
Level_Data_loaded = 0
Level_Number = 1
Active_Enemies = 0

DIM Level[MAX_LEVEL_SIZE_X, MAX_LEVEL_SIZE_Y]
DIM TileLayerPosition[MAX_LEVEL_SIZE_X, MAX_LEVEL_SIZE_Y]

Dim TickStart, TimeStep, NumberOfFrames, Position, LevelTilePosX, ScrollOffset, GameTicks
DIM PlayerShots[MAX_PLAYER_SHOTS,5]
DIM EnemyShots[ENEMY_MAX_SHOTS,7]
DIM Bonus[BONUS_MAX_BONUS,6]
DIM Player[2, 15]
LoadSavePath$ = PrefPath$("J7M", "GalaxyRanger")


sub Init_Window()
	if(SETTINGS_FULLSCREEN = true) then
		w = 0
		h = 0
		f = 0
		GetDesktopDisplayMode(0, w, h, f)
		WindowRatio = (w/h) / (SCREENX/SCREENY)
		WindowOpen(0, "Galaxy Ranger", 0 ,0, SCREENX * WindowRatio, SCREENY, OrBit(WINDOW_VISIBLE, WINDOW_FULLSCREEN), SETTINGS_VSYNC)
		CANVAS_OFFSET = -1*(SCREENX - SCREENX * WindowRatio)/2
	else
		WindowOpen(0, "Galaxy Ranger", WINDOWPOS_CENTERED, WINDOWPOS_CENTERED, SCREENX, SCREENY, WINDOW_VISIBLE, SETTINGS_VSYNC)		
	end if

	CanvasOpen(CANVAS_MAIN  , SCREENX, SCREENY - 32,  CANVAS_OFFSET, 32, SCREENX, SCREENY - 32, 0)
	CanvasOpen(CANVAS_HEADER, SCREENX, 32,  CANVAS_OFFSET, 0, SCREENX, 32, 0)
	CanvasOpen(CANVAS_MENUE, SCREENX, SCREENY, CANVAS_OFFSET,0, SCREENX, SCREENY, 0)

	SetCanvasZ(CANVAS_MENUE,0)
	SetCanvasZ(CANVAS_HEADER,1)
	SetCanvasZ(CANVAS_MAIN,2)
	'SetRenderScaleQuality(0)
end sub



sub Init()

	TickStart = Timer()
	TimeStep = 0
	NumberOfFrames = 0
	if(not IsTesting) then
		Position = 0
	end if
	LevelTilePosX = 0
	ScrollOffset = 0
	GameTicks = 0
	GAME_STATE = GAME_STATE_GAME_IS_RUNNING
	
	Font(0)

	for ii = 0 to MAX_PLAYER_SHOTS - 1
		PlayerShots[ii, PLAYER_SHOT_STATUS] = PLAYER_SHOT_STATUS_INACTIVE
		PlayerShots[ii, PLAYER_SHOT_SHOT_TYPE] = 1
		PlayerShots[ii, PLAYER_SHOT_POSITION_X] = 0
		PlayerShots[ii, PLAYER_SHOT_POSITION_Y] = 0
		PlayerShots[ii, PLAYER_SHOT_ANIMATION_FRAME] = 0
	next


	for ii = 0 to ENEMY_MAX_SHOTS - 1
		EnemyShots[ii, ENEMY_SHOT_STATUS] = ENEMY_SHOT_STATUS_INACTIVE
		EnemyShots[ii, ENEMY_SHOT_TYPE] = 1	
		EnemyShots[ii, ENEMY_SHOT_POSITION_X] = 0
		EnemyShots[ii, ENEMY_SHOT_POSITION_Y] = 0
		EnemyShots[ii, ENEMY_SHOT_ANIMATION_FRAME] = 0
		EnemyShots[ii, ENEMY_SHOT_VX] = 0
		EnemyShots[ii, ENEMY_SHOT_VY] = 0
	next


	for ii = 0 to BONUS_MAX_BONUS - 1
		Bonus[ii, BONUS_STATUS] = BONUS_STATUS_INACTIVE
		Bonus[ii, BONUS_TYPE] = BONUS_TYPE_NONE	
		Bonus[ii, BONUS_POSITION_X] = 0
		Bonus[ii, BONUS_POSITION_Y] = 0
		Bonus[ii, BONUS_ANIMATION_FRAME] = 0
		Bonus[ii, BONUS_POINTS] = 0
	next

	
	Player[0, PLAYER_STATUS] = PLAYER_STATUS_SPAWNED
	Player[0, PLAYER_ANIMATION_FRAME] = 0
	Player[0, PLAYER_POSITION_X] = 20
	Player[0, PLAYER_POSITION_Y] = 190
	Player[0, PLAYER_ACCELERATION] = 0.0007
	Player[0, PLAYER_MAX_ACCELERATION] = 0.07
	Player[0, PLAYER_ACCELERATION_X] = 0
	Player[0, PLAYER_ACCELERATION_Y] = 0
	Player[0, PLAYER_HITPOINTS] = 1000
	Player[0, PLAYER_LIVES] = 3
	Player[0, PLAYER_POINTS] = 0
	Player[0, PLAYER_MAX_HITPOINTS] = 1000
	Player[0, PLAYER_SPAWN_TIMER] = 3000
	Player[0, PLAYER_SHOT_TYPE] = 1
	Player[0, PLAYER_SHOT_DELAY] = PLAYER_SHOTS_SETTINGS_DELAY
	
end sub


sub Free_Dynamic_Data()
	Print("Free RAM")
	print(ImageID_DynamicData_Offset)
	print(ImageID)
	
	if(ImageID > ImageID_DynamicData_Offset) then
		For ii = ImageID_DynamicData_Offset to ImageID - 1
			DeleteImage(ii)
			print ii
		next
		ImageID = ImageID_DynamicData_Offset
	end if

end sub
