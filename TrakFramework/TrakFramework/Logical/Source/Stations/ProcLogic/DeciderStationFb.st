
(* TODO: Add your comment here *)
FUNCTION_BLOCK DeciderStationFb
	CASE int.state OF
		//*************************** Off/Idle State
		DECIDER_OFF:
			IF Enable THEN
				int.currentIdx := 0;
				StationPars.Dest.Destination := DestList[int.currentIdx];
				
				int.Fbs.procWrapperFb.Enable := TRUE;
				int.Fbs.procWrapperFb.Pars := ADR(StationPars);
				int.Fbs.procWrapperFb.DestLookups := ADR(DestLookup);
				int.Fbs.procWrapperFb.ProcessPt := ProcPt;
				int.state := DECIDER_INIT;
			END_IF
		//*************************** Init State
		DECIDER_INIT:
			int.state := DECIDER_WAIT;

		//*************************** Waiting for a shuttle State
		DECIDER_WAIT:
			IF int.Fbs.procWrapperFb.ShPresent THEN
				int.state := DECIDER_PROCESS_SHUTTLE;
			END_IF
		//*************************** Processing the Shuttle State
		DECIDER_PROCESS_SHUTTLE:
			IF NOT int.Fbs.procWrapperFb.ShPresent THEN
				int.currentIdx := int.currentIdx + 1;
				IF int.currentIdx > MAX_DECIDERS_IDX OR int.currentIdx + 1 > NumberOfDestinations THEN
					int.currentIdx := 0;
				END_IF
				
				StationPars.Dest.Destination := DestList[int.currentIdx];
				int.state := DECIDER_WAIT;
			END_IF
	END_CASE;
	
	NextDest := DestList[int.currentIdx];
	
	int.Fbs.procWrapperFb();
		
END_FUNCTION_BLOCK
