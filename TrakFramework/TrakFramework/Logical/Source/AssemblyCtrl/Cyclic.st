
PROGRAM _CYCLIC
	
	//Idle
	//Power On the assembly
	//Add shuttles
	//Wait Start Command
	//Send all shuttles moving
	//Power Off the assembly
	//Error
	//Reset
	
//	MpAlarmXCore_0.MpLink := ADR(gAlarmXCore);
//	MpAlarmXCore_0();
	
	CASE state OF
		//******************************************************************** Idle State
		ASM_IDLE:
			IF gAsmIf.Cmd.Power THEN
				
				gAsmIf.Sts.CurrentShuttleIdx := 0;
				gAsmIf.Par.Startup.Sector := secStartup;
				
				IF fbs.AsmReadStatus.AssemblyReady THEN
					state := ASM_CHECK_COUNT;
				ELSE
					fbs.PowerOnFb.Assembly := ADR(gTestAssembly);
					fbs.PowerOnFb.Execute := TRUE;
					state := ASM_POWER_ON;
				END_IF
				
				fbs.AsmReadStatus.Assembly := ADR(gTestAssembly);
				fbs.AsmReadStatus.Enable := TRUE;
				
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
				userData.Color := TP_GREEN;
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
			IF gAsmIf.Sts.CurrentShuttleIdx >= gAsmIf.Par.NumShuttles OR gAsmIf.Sts.ShuttlesSpawned THEN
				gAsmIf.Sts.WaitingToStart := TRUE;
				
				state := ASM_WAIT_START;
				gAsmIf.Sts.ShuttlesSpawned := TRUE;
			ELSE
				fbs.SecAddShFb.Sector := ADR(gAsmIf.Par.Startup.Sector);
				fbs.SecAddShFb.Position := gAsmIf.Par.Startup.Position + gAsmIf.Par.Startup.Gap * gAsmIf.Sts.CurrentShuttleIdx;
				fbs.SecAddShFb.Execute := TRUE;
				
				state := ASM_ADD_SHUTTLE;
			END_IF
		//******************************************************************** Wait For Start Command
		ASM_WAIT_START:
			IF gAsmIf.Cmd.Run THEN
								
				fbs.AsmGetShFb.Enable := TRUE;
				fbs.AsmGetShFb.Assembly := ADR(gTestAssembly);
				
				state := ASM_GET_SHUTTLE;				
			END_IF
		ASM_GET_SHUTTLE:
			IF fbs.AsmGetShFb.Error THEN
				errorState := state;
				state := ASM_ERROR;
				gAsmIf.Sts.Error := TRUE;
			ELSIF fbs.AsmGetShFb.Valid THEN
				
				fbs.ShCopyDataFb.Axis := ADR(fbs.AsmGetShFb.Axis);
				fbs.ShCopyDataFb.DataAddress := ADR(userData);
				fbs.ShCopyDataFb.DataSize := SIZEOF(userData);
				fbs.ShCopyDataFb.Mode := mcACPTRAK_USERDATA_GET;
				fbs.ShCopyDataFb.Execute := TRUE;
				
				IF fbs.ShCopyDataFb.Done THEN
					fbs.AsmGetShFb.Next := FALSE;
					
					
					fbs.RoutedMoveVelFb.Axis := ADR(fbs.AsmGetShFb.Axis);
					fbs.RoutedMoveVelFb.Sector := ADR(gDestLookups[userData.Destination].Sector);
					fbs.RoutedMoveVelFb.Position := gDestLookups[userData.Destination].Position;
					fbs.RoutedMoveVelFb.Velocity := gMainIf.Par.DefaultVelocity;
					fbs.RoutedMoveVelFb.RouteVelocity := gMainIf.Par.DefaultVelocity;
					fbs.RoutedMoveVelFb.Acceleration := gMainIf.Par.DefaultAccel;
					fbs.RoutedMoveVelFb.Deceleration := gMainIf.Par.DefaultDecel;
					fbs.RoutedMoveVelFb.AdvancedParameters.StartDirection := mcDIR_UNDEFINED;
					fbs.RoutedMoveVelFb.Execute := TRUE;
				
				
					state := ASM_SEND_SHUTTLE;
				END_IF
				
			END_IF
			
		ASM_SEND_SHUTTLE:
			IF fbs.RoutedMoveVelFb.Error THEN
				errorState := state;
				state := ASM_ERROR;
				gAsmIf.Sts.Error := TRUE;
			ELSIF NOT fbs.RoutedMoveVelFb.Execute THEN
				
				fbs.ShCopyDataFb.Execute := FALSE;
				IF fbs.AsmGetShFb.RemainingCount = 0 THEN
					fbs.AsmGetShFb.Enable := FALSE;
					fbs.AsmGetShFb.Next := FALSE;
					gAsmIf.Sts.Running := TRUE;
					
					state := ASM_RUNNING;
				ELSE
					fbs.AsmGetShFb.Next := TRUE;
					
				
					state := ASM_GET_SHUTTLE;
				END_IF
			END_IF
		//******************************************************************** Idle State
		ASM_RUNNING:
			IF gAsmIf.Cmd.TriggerError THEN
				//Trigger User Created Error Reaction
				fbs.SegCmdErrorFb.Segment := ADR(gCenterLoop_0);
				fbs.SegCmdErrorFb.Execute := TRUE;
				fbs.SegCmdErrorFb.Command := mcERROR_STOP_CMD;
				
				
				gAsmIf.Cmd.TriggerError := FALSE;
				gAsmIf.Cmd.Run := FALSE;
				gAsmIf.Sts.Running := FALSE;
				gAsmIf.Sts.Error := TRUE;
				gAsmIf.Sts.Powered := FALSE;
				
				state := ASM_ERROR;
			END_IF
		ASM_ERROR:
			gAsmIf.Cmd.Power := FALSE;
			gAsmIf.Cmd.Run := FALSE;
			fbs.PowerOnFb.Execute := FALSE;
			fbs.RoutedMoveVelFb.Execute := FALSE;
			
			IF gAsmIf.Cmd.Reset THEN
				gAsmIf.Cmd.TriggerError := FALSE;
				fbs.SegCmdErrorFb.Execute := FALSE;
				fbs.AsmResetFb.Assembly := ADR(gTestAssembly);
				fbs.AsmResetFb.Execute := TRUE;
				
				state := ASM_ERROR_RESET;
			END_IF
		ASM_ERROR_RESET:
			IF fbs.AsmReadStatus.AssemblyDisabled AND NOT fbs.AsmReadStatus.AssemblyErrorStop OR fbs.AsmReadStatus.AssemblyReady THEN
				gAsmIf.Cmd.Reset := FALSE;
				gAsmIf.Sts.Error := FALSE;	
				fbs.AsmResetFb.Execute := FALSE;
				state := ASM_IDLE;
			END_IF
			IF fbs.AsmResetFb.Error THEN
				gAsmIf.Cmd.Reset := FALSE;
				fbs.AsmResetFb.Execute := FALSE;				
				state := ASM_ERROR;
			END_IF
			
	END_CASE;
	
	fbs.PowerOnFb();
	fbs.RoutedMoveVelFb();
	fbs.SecAddShFb();
	fbs.SecGetShFb();
	fbs.AsmGetShFb();
	fbs.ShCopyDataFb();
	fbs.SegCmdErrorFb();
	fbs.AsmResetFb();
	fbs.AsmReadStatus();
	
	fbs.SegReadStatus.Enable := TRUE;
	fbs.SegReadStatus.Segment := ADR(gCenterLoop_0);
	fbs.SegReadStatus();
	
	IF fbs.RoutedMoveVelFb.Active THEN
		fbs.RoutedMoveVelFb.Execute := FALSE;
	END_IF
	
	
END_PROGRAM
