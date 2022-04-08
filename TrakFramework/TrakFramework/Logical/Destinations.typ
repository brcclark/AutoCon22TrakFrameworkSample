(*Destinations*)

TYPE
	SystemDestinationsEnum : 
		(
		DEST_STARTUP,
		DEST_PROCESS_1 := 10,
		DEST_PROCESS_1A,
		DEST_PROCESS_1B,
		DEST_PROCESS_2 := 20,
		DEST_PROCESS_2A,
		DEST_PROCESS_2B,
		DEST_PROCESS_3 := 30
		);
	SystemDestinationsTyp : 	STRUCT 
		Name : STRING[32];
		Sector : McSectorType;
		Position : LREAL;
	END_STRUCT;
END_TYPE
