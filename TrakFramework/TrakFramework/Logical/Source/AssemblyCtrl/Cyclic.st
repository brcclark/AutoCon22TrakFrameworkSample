
PROGRAM _CYCLIC
	
	//Idle
	//Power On the assembly
	//Add shuttles
	//Wait Start Command
	//Send all shuttles moving
	//Power Off the assembly
	//Error
	//Reset
	 
	
	CASE state OF
		//******************************************************************** Idle State
		ASM_IDLE:
			IF gAsmIf.Cmd.Power THEN
				
				gAsmIf.Sts.CurrentShuttleIdx := 0;
				gAsmIf.Par.Startup.Sector := secStartup;
				
				fbs.PowerOnFb.Assembly := ADR(gTestAssembly);
				fbs.PowerOnFb.Execute := TRUE;
				
				state := ASM_POWER_ON;
			END_IF
		//******************************************************************** Power On State
		ASM_POWER_ON:
			IF fbs.PowerOnFb.Error THEN
				errorState := state;
				state := ASM_ERROR;
				gAsmIf.Sts.Error := TRUE;
			ELSIF fbs.PowerOnFb.Done THEN
				fbs.PowerOnFb.Execute := FALSE;
				gAsmIf.Sts.Powered := TRUE;
				
				state := ASM_CHECK_COUNT;
			END_IF
		//******************************************************************** Adding Shuttles State
		ASM_ADD_SHUTTLE:
			IF fbs.SecAddShFb.Error THEN
				errorState := state;
				state := ASM_ERROR;
				gAsmIf.Sts.Error := TRUE;
			ELSIF fbs.SecAddShFb.Done THEN
				shSetColor(COLOR_GREEN,ADR(userData.ColorRGB));
				brsitoa(USINT_TO_DINT(gAsmIf.Sts.CurrentShuttleIdx),ADR(userData.ShId));
				userData.Destination := DEST_DECIDE_1;
				
				fbs.ShCopyDataFb.Axis := ADR(fbs.SecAddShFb.Axis);
				fbs.ShCopyDataFb.DataAddress := ADR(userData);
				fbs.ShCopyDataFb.DataSize := SIZEOF(userData);
				fbs.ShCopyDataFb.Mode := mcACPTRAK_USERDATA_SET;
				fbs.ShCopyDataFb.Execute := TRUE;
				
				state := ASM_WRITE_DATA;				
			END_IF 
		//******************************************************************** Update Shuttle User Data State
		ASM_WRITE_DATA:
			IF fbs.ShCopyDataFb.Error THEN
				errorState := state;
				state := ASM_ERROR;
				gAsmIf.Sts.Error := TRUE;
			ELSIF fbs.ShCopyDataFb.Done THEN
				fbs.ShCopyDataFb.Execute := FALSE;
				fbs.SecAddShFb.Execute := FALSE;
				gAsmIf.Sts.CurrentShuttleIdx := gAsmIf.Sts.CurrentShuttleIdx + 1;
				
				state := ASM_CHECK_COUNT;
			END_IF
			
		//******************************************************************** Check Count State
		ASM_CHECK_COUNT:
			IF gAsmIf.Sts.CurrentShuttleIdx >= gAsmIf.Par.NumShuttles THEN
				gAsmIf.Sts.WaitingToStart := TRUE;
				
				state := ASM_WAIT_START;						
			ELSE
				fbs.SecAddShFb.Sector := ADR(gAsmIf.Par.Startup.Sector);
				fbs.SecAddShFb.Position := gAsmIf.Par.Startup.Position + gAsmIf.Par.Startup.Gap * gAsmIf.Sts.CurrentShuttleIdx;
				fbs.SecAddShFb.Execute := TRUE;
				
				state := ASM_ADD_SHUTTLE;
			END_IF
		//******************************************************************** Idle State
		ASM_WAIT_START:
			IF gAsmIf.Cmd.Run THEN
				fbs.SecGetShFb.Sector := ADR(gAsmIf.Par.Startup.Sector);
				fbs.SecGetShFb.Mode := mcACPTRAK_SEARCH_BACKWARD;
				fbs.SecGetShFb.Enable := TRUE;
				
				state := ASM_GET_SHUTTLE;				
			END_IF
		//******************************************************************** Idle State
		ASM_GET_SHUTTLE:
			IF fbs.SecGetShFb.Error THEN
				errorState := state;
				state := ASM_ERROR;
				gAsmIf.Sts.Error := TRUE;
			ELSIF fbs.SecGetShFb.Valid THEN
				fbs.SecGetShFb.Next := FALSE;
				fbs.RoutedMoveVelFb.Axis := ADR(fbs.SecGetShFb.Axis);
				fbs.RoutedMoveVelFb.Sector := ADR(gDestLookups[gAsmIf.Par.FirstMove].Sector);
				fbs.RoutedMoveVelFb.Position := gDestLookups[gAsmIf.Par.FirstMove].Position;
				fbs.RoutedMoveVelFb.Velocity := gMainIf.Par.DefaultVelocity;
				fbs.RoutedMoveVelFb.RouteVelocity := gMainIf.Par.DefaultVelocity;
				fbs.RoutedMoveVelFb.Acceleration := gMainIf.Par.DefaultAccel;
				fbs.RoutedMoveVelFb.Deceleration := gMainIf.Par.DefaultDecel;
				fbs.RoutedMoveVelFb.AdvancedParameters.StartDirection := mcDIR_POSITIVE;
				fbs.RoutedMoveVelFb.Execute := TRUE;
				
				state := ASM_SEND_SHUTTLE;
				
			END_IF
			
		//******************************************************************** Idle State
		ASM_SEND_SHUTTLE:
			IF fbs.RoutedMoveVelFb.Error THEN
				errorState := state;
				state := ASM_ERROR;
				gAsmIf.Sts.Error := TRUE;
			ELSIF NOT fbs.RoutedMoveVelFb.Execute THEN
				IF fbs.SecGetShFb.RemainingCount = 0 THEN
					fbs.SecGetShFb.Enable := FALSE;
					fbs.SecGetShFb.Next := FALSE;
					gAsmIf.Sts.Running := TRUE;
					
					state := ASM_RUNNING;
				ELSE
					fbs.SecGetShFb.Next := TRUE;
				
					state := ASM_GET_SHUTTLE;
				END_IF
			END_IF
		//******************************************************************** Idle State
		ASM_RUNNING:
		//******************************************************************** Idle State
		ASM_ERROR:

	END_CASE;
	
	fbs.PowerOnFb();
	fbs.RoutedMoveVelFb();
	fbs.SecAddShFb();
	fbs.SecGetShFb();
	fbs.ShCopyDataFb();
	
	IF fbs.RoutedMoveVelFb.Active THEN
		fbs.RoutedMoveVelFb.Execute := FALSE;
	END_IF
END_PROGRAM
