

FUNCTION_BLOCK procWrapper
	//Enable the Trg Point
	//Check for shuttles
	//Read
	IF Enable THEN
		CASE int.state OF
			//************************** Idle/Off/Default State
			PROC_OFF:
				int.Fbs.TrgPtFb.Enable := TRUE;
				int.Fbs.TrgPtFb.ProcessPoint := ADR(DestLookups[ProcessPt].ProcPoint);
				
				int.state := PROC_INIT;
			//************************** Init State
			PROC_INIT:
				IF int.Fbs.TrgPtFb.Valid THEN
					int.state := PROC_WAIT_SHUTTLE;
				END_IF
				//************************** Waiting For A Shuttle State
			PROC_WAIT_SHUTTLE:
				IF int.Fbs.TrgPtFb.Error THEN
					int.errorState := int.state;
					Error := TRUE;
					ErrorID := int.Fbs.TrgPtFb.ErrorID;
					int.state := PROC_ERROR;
				ELSIF int.Fbs.TrgPtFb.EventCount > 0 THEN
					int.Fbs.TrgPtGetInfoFb.Execute := TRUE;
					int.Fbs.TrgPtGetInfoFb.ProcessPoint := ADR(DestLookups[ProcessPt].ProcPoint);
					
					int.state := PROC_GET_TRG_INFO;
				END_IF
			//************************** Get Trigger Point Info State
			PROC_GET_TRG_INFO:
				IF int.Fbs.TrgPtGetInfoFb.Error THEN
					int.errorState := int.state;
					Error := TRUE;
					ErrorID := int.Fbs.TrgPtGetInfoFb.ErrorID;
					int.state := PROC_ERROR;
				ELSIF int.Fbs.TrgPtGetInfoFb.Done THEN
					int.Shuttle.Axis := int.Fbs.TrgPtGetInfoFb.TrgPointInfo.Axis;
					int.Fbs.TrgPtGetInfoFb.Execute := FALSE;
					
					int.Fbs.ShCopyDataFb.Axis := ADR(int.Shuttle.Axis);
					int.Fbs.ShCopyDataFb.DataAddress := ADR(int.Shuttle.UserData);
					int.Fbs.ShCopyDataFb.DataSize := SIZEOF(int.Shuttle.UserData);
					int.Fbs.ShCopyDataFb.Mode := mcACPTRAK_USERDATA_GET;
					int.Fbs.ShCopyDataFb.Execute := TRUE;
					
					int.Fbs.ShReadInfoFb.Axis := ADR(int.Shuttle.Axis);
					int.Fbs.ShReadInfoFb.Enable := TRUE;
					
					int.state := PROC_GET_USER_DATA;						
				END_IF
			//************************** Getting User Data and Sh Info State
			PROC_GET_USER_DATA:
				IF int.Fbs.ShReadInfoFb.Error OR int.Fbs.ShCopyDataFb.Error THEN
					int.errorState := int.state;
					Error := TRUE;
					int.state := PROC_ERROR;
				ELSIF int.Fbs.ShReadInfoFb.Valid AND int.Fbs.ShCopyDataFb.Done THEN
					int.Fbs.ShCopyDataFb.Execute := FALSE;
					
					IF int.Fbs.ShReadInfoFb.ShuttleInfo.RouteDestinationInfo.SectorType <> mcACPTRAK_SEC_INTERNAL THEN
						int.state := PROC_CHECK;
					ELSE
						int.Fbs.ShReadInfoFb.Enable := FALSE;
						int.Fbs.TrgPtGetInfoFb.Execute := FALSE;
					
						brsmemset(ADR(int.Shuttle),0,SIZEOF(int.Shuttle));
					
						int.state := PROC_WAIT_SHUTTLE;
					END_IF
				END_IF
			//************************** Preforming The Decision State
			PROC_CHECK:
				IF ( Pars.DestinationCheck AND DestLookups[ProcessPt].Sector.controlif = DestLookups[int.Shuttle.UserData.Destination].Sector.controlif) 
					OR NOT Pars.DestinationCheck THEN
					ShPresent := TRUE;
					
					shSetColor(Pars.Dest.Color,ADR(int.Shuttle.UserData.ColorRGB));
					int.Shuttle.UserData.Destination := Pars.Dest.Destination;
					
					int.Fbs.ShCopyDataFb.Execute := TRUE;
					int.Fbs.ShCopyDataFb.Mode := mcACPTRAK_USERDATA_SET;
					
					int.state := PROC_UPDATE_USER_DATA;
				ELSE
					int.Fbs.ShReadInfoFb.Enable := FALSE;
					
					brsmemset(ADR(int.Shuttle),0,SIZEOF(int.Shuttle));
					
					int.state := PROC_WAIT_SHUTTLE;
				END_IF
			//************************** Updating the User Data State	
			PROC_UPDATE_USER_DATA:
				IF int.Fbs.ShCopyDataFb.Error THEN
				ELSIF int.Fbs.ShCopyDataFb.Done THEN
					int.Fbs.ShCopyDataFb.Execute := FALSE;
					int.Test := DestLookups[int.Shuttle.UserData.Destination].Name;
					CASE Pars.Dest.MoveType OF
						MV_ROUTE_ABSOLUTE:
							int.Fbs.RouteAbsFb.Axis := ADR(int.Shuttle.Axis);
							int.Fbs.RouteAbsFb.Sector := ADR(DestLookups[int.Shuttle.UserData.Destination].Sector);
							int.Fbs.RouteAbsFb.Position := DestLookups[int.Shuttle.UserData.Destination].Position;
							int.Fbs.RouteAbsFb.Velocity := Pars.Dest.Velocity;
							int.Fbs.RouteAbsFb.Acceleration := Pars.Dest.Accel;
							int.Fbs.RouteAbsFb.Deceleration := Pars.Dest.Decel;
							int.Fbs.RouteAbsFb.Execute := TRUE;
						MV_ROUTE_VELOCITY:
							int.Fbs.RouteVelFb.Axis := ADR(int.Shuttle.Axis);
							int.Fbs.RouteVelFb.Sector := ADR(DestLookups[int.Shuttle.UserData.Destination].Sector);
							int.Fbs.RouteVelFb.Position := DestLookups[int.Shuttle.UserData.Destination].Position;
							int.Fbs.RouteVelFb.Velocity := Pars.Dest.Velocity;
							int.Fbs.RouteVelFb.RouteVelocity := Pars.Dest.Velocity;
							int.Fbs.RouteVelFb.Acceleration := Pars.Dest.Accel;
							int.Fbs.RouteVelFb.Deceleration := Pars.Dest.Decel;
							int.Fbs.RouteVelFb.Execute := TRUE;
						MV_ELASTIC_ABSOLUTE:
							int.Fbs.ElasticAbsFb.Axis := ADR(int.Shuttle.Axis);
							int.Fbs.ElasticAbsFb.Position := DestLookups[int.Shuttle.UserData.Destination].Position;
							int.Fbs.ElasticAbsFb.Velocity := Pars.Dest.Velocity;
							int.Fbs.ElasticAbsFb.Acceleration := Pars.Dest.Accel;
							int.Fbs.ElasticAbsFb.Deceleration := Pars.Dest.Decel;
							int.Fbs.ElasticAbsFb.Execute := TRUE;
						MV_ELASTIC_VELOCITY:
							int.Fbs.ElasticVelFb.Axis := ADR(int.Shuttle.Axis);
							int.Fbs.ElasticVelFb.Velocity := Pars.Dest.Velocity;
							int.Fbs.ElasticVelFb.Acceleration := Pars.Dest.Accel;
							int.Fbs.ElasticVelFb.Deceleration := Pars.Dest.Decel;
							int.Fbs.ElasticVelFb.Execute := TRUE;
					END_CASE;
					int.state := PROC_SEND;
				END_IF
			//************************** Sending the Shuttle State
			PROC_SEND:
				IF int.Fbs.RouteAbsFb.Error OR
					int.Fbs.RouteVelFb.Error OR
					int.Fbs.ElasticAbsFb.Error OR
					int.Fbs.ElasticVelFb.Error THEN
					
					int.errorState := int.state;
					Error := TRUE;
					int.state := PROC_ERROR;
				ELSIF NOT int.Fbs.RouteAbsFb.Execute AND
					NOT int.Fbs.RouteVelFb.Execute AND
					NOT int.Fbs.ElasticAbsFb.Execute AND
					NOT int.Fbs.ElasticVelFb.Execute THEN
					
					ShPresent := FALSE;
					
					int.Fbs.ShReadInfoFb.Enable := FALSE;
					int.state := PROC_WAIT_SHUTTLE;
				END_IF
			//************************** Error State
			PROC_ERROR:
		END_CASE;
		int.Fbs.ElasticAbsFb();
		int.Fbs.ElasticVelFb();
		int.Fbs.RouteAbsFb();
		int.Fbs.RouteVelFb();
		int.Fbs.ShCopyDataFb();
		int.Fbs.ShReadInfoFb();
		int.Fbs.TrgPtFb();
		int.Fbs.TrgPtGetInfoFb();
		
		IF int.Fbs.ElasticAbsFb.Active THEN
			int.Fbs.ElasticAbsFb.Execute := FALSE;
		END_IF
		IF int.Fbs.ElasticVelFb.Active THEN
			int.Fbs.ElasticVelFb.Execute := FALSE;
		END_IF
		IF int.Fbs.RouteAbsFb.Active THEN
			int.Fbs.RouteAbsFb.Execute := FALSE;
		END_IF
		IF int.Fbs.RouteVelFb.Active THEN
			int.Fbs.RouteVelFb.Execute := FALSE;
		END_IF
		
	ELSE
		
	END_IF
END_FUNCTION_BLOCK
