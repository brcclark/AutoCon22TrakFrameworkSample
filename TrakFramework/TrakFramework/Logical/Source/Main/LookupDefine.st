
ACTION LookupDefine: 
	//DEST_STARTUP
	gDestLookups[DEST_STARTUP].Name := 'DEST_STARTUP';
	gDestLookups[DEST_STARTUP].Position := 0.0;
	gDestLookups[DEST_STARTUP].Sector := secStartup;
	//gDestLookups[DEST_STARTUP].ProcPoint := ppCellDecision;
	
	//DEST_DECIDE_1
	gDestLookups[DEST_DECIDE_1].Name := 'DEST_DECIDE_1';
	gDestLookups[DEST_DECIDE_1].Position := 0.0;
	gDestLookups[DEST_DECIDE_1].Sector := secLoadDecision;
	gDestLookups[DEST_DECIDE_1].ProcPoint := ppLoadDecision;
	
	
	//DEST_PROCESS_1
	gDestLookups[DEST_PROCESS_1].Name := 'DEST_PROCESS_1';
	gDestLookups[DEST_PROCESS_1].Position := 0.0;
	gDestLookups[DEST_PROCESS_1].Sector := secProcess1;
	gDestLookups[DEST_PROCESS_1].ProcPoint := ppProcess1;
	
	//DEST_PROCESS_2
	gDestLookups[DEST_PROCESS_2].Name := 'DEST_PROCESS_2';
	gDestLookups[DEST_PROCESS_2].Position := 0.0;
	gDestLookups[DEST_PROCESS_2].Sector := secProcess2;
	gDestLookups[DEST_PROCESS_2].ProcPoint := ppProcess2;
END_ACTION
