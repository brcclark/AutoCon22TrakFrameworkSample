PROGRAM _INIT 
	
    // size of Vis.Trak structure - this value has to be entered in B&R scene viewer (PVI -> Options -> Size)
	SizeofVis := SIZEOF(Vis.Trak);
	
	userDataSize := SIZEOF(gUserData);
	
	// max number of displayed shuttles  
	NumVisShuttle := SIZEOF(Vis.Trak.Shuttle) / SIZEOF(Vis.Trak.Shuttle[0]);  

END_PROGRAM

PROGRAM _CYCLIC 

	
	//Problem with my approach is that we can't easily power cycle due to only wanting to be on the first 10 shuttles, need to fix this by using some modulus or something?
	
	FOR i:=0 TO (NumVisShuttle-1) DO 
		
		IF gShuttleMon.Shuttle[i].Available THEN
			// format selected monitor data to fit B&R scene viewer  
			//This is done to normalize the indecies, make sure we the scene viewer shuttles 1-20 always line up with shuttle index 1-20
			//			index := gShuttleMon.Shuttle[i].Index-1;
			//			index := index MOD numShuttles;
			CASE index OF
				0..19:
					Vis.Trak.Shuttle[i].Available    	:= 1;
					Vis.Trak.Shuttle[i].PositionX    	:= LREAL_TO_REAL(gShuttleMon.Shuttle[i].Position.X);
					Vis.Trak.Shuttle[i].PositionY    	:= LREAL_TO_REAL(gShuttleMon.Shuttle[i].Position.Y);
					Vis.Trak.Shuttle[i].RotationZ    	:= LREAL_TO_REAL(gShuttleMon.Shuttle[i].Orientation.Angle1);
					Vis.Trak.Shuttle[i].ExtentToFront    := LREAL_TO_REAL(gShuttleMon.Shuttle[i].ExtentToFront);
					Vis.Trak.Shuttle[i].ExtentToBack     := LREAL_TO_REAL(gShuttleMon.Shuttle[i].ExtentToBack);
					Vis.Trak.Shuttle[i].Width    		:= LREAL_TO_REAL(gShuttleMon.Shuttle[i].Width);  
				20..21:
					Vis.Trak.Shuttle[i].Available    	:= 1;
					Vis.Trak.Shuttle[i].PositionX    	:= LREAL_TO_REAL(gShuttleMon.Shuttle[i].Position.Z);
					Vis.Trak.Shuttle[i].PositionY    	:= LREAL_TO_REAL(gShuttleMon.Shuttle[i].Position.Y);
					Vis.Trak.Shuttle[i].RotationZ    	:= LREAL_TO_REAL(gShuttleMon.Shuttle[i].Orientation.Angle1);
					Vis.Trak.Shuttle[i].ExtentToFront    := LREAL_TO_REAL(gShuttleMon.Shuttle[i].ExtentToFront);
					Vis.Trak.Shuttle[i].ExtentToBack     := LREAL_TO_REAL(gShuttleMon.Shuttle[i].ExtentToBack);
					Vis.Trak.Shuttle[i].Width    		:= LREAL_TO_REAL(gShuttleMon.Shuttle[i].Width);  
			END_CASE;
			
			brsitoa(gShuttleMon.Shuttle[i].Index, ADR(Vis.Trak.Shuttle[i].Text));

			pUserData.ColorRGB[0]    	:= 0.5;    //
			pUserData.ColorRGB[1]    	:= 0.5;    // default shuttle color grey
			pUserData.ColorRGB[2]    	:= 0.5;    //
			
			// example: set shuttle colour via user data
			IF gShuttleMon.Shuttle[i].UserData <> 0 THEN  
				pUserData ACCESS gShuttleMon.Shuttle[i].UserData;    // access to user data of this shuttle
				IF pUserData.ColorEnum = COLOR_GREEN THEN    // product 1 -> display shuttle in green color
					pUserData.ColorRGB[0]    := 0.0;
					pUserData.ColorRGB[1]    := 1.0;
					pUserData.ColorRGB[2]    := 0.0;
				ELSIF pUserData.ColorEnum = COLOR_BLUE THEN    // product 2 -> display shuttle in blue color
					pUserData.ColorRGB[0]    := 0.0;
					pUserData.ColorRGB[1]    := 0.0;
					pUserData.ColorRGB[2]    := 1.0;
				ELSIF pUserData.ColorEnum = COLOR_RED THEN    // product 3 -> display shuttle in red color
					pUserData.ColorRGB[0]    := 1.0;
					pUserData.ColorRGB[1]    := 0.0;
					pUserData.ColorRGB[2]    := 0.0;
				ELSIF pUserData.ColorEnum = COLOR_YELLOW THEN
					pUserData.ColorRGB[0]    := 0.8;
					pUserData.ColorRGB[1]    := 0.8;
					pUserData.ColorRGB[2]    := 0.0;
				ELSIF pUserData.ColorEnum = COLOR_WHITE THEN
					pUserData.ColorRGB[0]    := 1.0;
					pUserData.ColorRGB[1]    := 1.0;
					pUserData.ColorRGB[2]    := 1.0;
				ELSIF pUserData.ColorEnum = COLOR_ORANGE THEN
					pUserData.ColorRGB[0]    := 1.0;
					pUserData.ColorRGB[1]    := 0.5;
					pUserData.ColorRGB[2]    := 0;
				ELSIF pUserData.ColorEnum = COLOR_CYAN THEN
					pUserData.ColorRGB[0]    := 0;
					pUserData.ColorRGB[1]    := 1.0;
					pUserData.ColorRGB[2]    := 1.0;
				ELSIF pUserData.ColorEnum = COLOR_BLACK THEN
					pUserData.ColorRGB[0]    := 0;
					pUserData.ColorRGB[1]    := 0;
					pUserData.ColorRGB[2]    := 0;
				ELSIF pUserData.ColorEnum = COLOR_PINK THEN
					pUserData.ColorRGB[0]    := 1;
					pUserData.ColorRGB[1]    := 0;
					pUserData.ColorRGB[2]    := 0.5;
				END_IF  
			END_IF
			
		ELSE
			brsmemset(ADR(Vis.Trak.Shuttle[i]), 0, SIZEOF(Vis.Trak.Shuttle[0]));
		END_IF
		
	END_FOR
	
	
	
END_PROGRAM
