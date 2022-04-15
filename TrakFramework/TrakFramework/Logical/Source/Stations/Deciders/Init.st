

PROGRAM _INIT
	loopDeciderFb.DestList[0] := DEST_PROCESS_1;
	loopDeciderFb.DestList[1] := DEST_PROCESS_2;
	loopDeciderFb.NumberOfDestinations := 2;
	loopDeciderFb.ProcPt := DEST_DECIDE_1;
	loopDeciderFb.DestLookup := ADR(gDestLookups);
	 
	loopDeciderFb.StationPars.Dest.Accel := 20.0;
	loopDeciderFb.StationPars.Dest.Decel := 20.0;
	loopDeciderFb.StationPars.Dest.Velocity := 1.0;
	loopDeciderFb.StationPars.Dest.MoveType := MV_ROUTE_VELOCITY;
	loopDeciderFb.StationPars.Dest.Color := COLOR_CYAN;
	
	proc1Fb.DestList[0] := DEST_DECIDE_1;
	proc1Fb.NumberOfDestinations := 1;
	proc1Fb.ProcPt := DEST_PROCESS_1;
	proc1Fb.DestLookup := ADR(gDestLookups);
	
	proc1Fb.StationPars.Dest.Accel := 20.0;
	proc1Fb.StationPars.Dest.Decel := 20.0;
	proc1Fb.StationPars.Dest.Velocity := 1.5;
	proc1Fb.StationPars.Dest.MoveType := MV_ROUTE_VELOCITY;
	proc1Fb.StationPars.Dest.Color := COLOR_YELLOW;
	
	
	proc2Fb.DestList[0] := DEST_DECIDE_1;
	proc2Fb.NumberOfDestinations := 1;
	proc2Fb.ProcPt := DEST_PROCESS_2;
	proc2Fb.DestLookup := ADR(gDestLookups);
	
	proc2Fb.StationPars.Dest.Accel := 20.0;
	proc2Fb.StationPars.Dest.Decel := 20.0;
	proc2Fb.StationPars.Dest.Velocity := 1.5;
	proc2Fb.StationPars.Dest.MoveType := MV_ROUTE_VELOCITY;
	proc2Fb.StationPars.Dest.Color := COLOR_RED;
		
END_PROGRAM