(*Shuttle User Data and Other Modifyable Types*)

TYPE
	SystemDestinationsEnum : 
		(
		DEST_STARTUP,
		DEST_DECIDE_1 := 5,
		DEST_PROCESS_1 := 10,
		DEST_PROCESS_1A,
		DEST_PROCESS_1B,
		DEST_PROCESS_2 := 20,
		DEST_PROCESS_2A,
		DEST_PROCESS_2B,
		DEST_PROCESS_3 := 30
		);
	shUserData : 	STRUCT 
		Color : TrkPaperColorEnum;
		ShId : STRING[10];
		Destination : SystemDestinationsEnum;
	END_STRUCT;
	shColors_Typ : 
		(
		COLOR_RED,
		COLOR_GREEN,
		COLOR_BLUE,
		COLOR_YELLOW,
		COLOR_WHITE,
		COLOR_ORANGE,
		COLOR_CYAN,
		COLOR_BLACK,
		COLOR_PINK
		);
	SystemDestinationsTyp : 	STRUCT 
		Name : STRING[32];
		Sector : McSectorType;
		Position : LREAL;
		ProcPoint : McProcessPointType;
	END_STRUCT;
END_TYPE

(*Process Point Wrapper Type*)

TYPE
	ProcWrapperParTyp : 	STRUCT 
		Dest : ProcWrapperDestParTyp;
		DestinationCheck : BOOL;
	END_STRUCT;
	ProcWrapperDestParTyp : 	STRUCT 
		Color : TrkPaperColorEnum;
		MoveType : ProcWrapperMoveTypes;
		Destination : SystemDestinationsEnum;
		Velocity : REAL;
		Accel : REAL;
		Decel : REAL;
	END_STRUCT;
	ProcWrapperMoveTypes : 
		(
		MV_ROUTE_ABSOLUTE,
		MV_ROUTE_VELOCITY,
		MV_ELASTIC_ABSOLUTE,
		MV_ELASTIC_VELOCITY
		);
	ProcWrapperInternalTyp : 	STRUCT 
		state : ProcWrapperStatesEnum;
		errorState : ProcWrapperStatesEnum;
		Shuttle : ProcWrapperShInfoTyp;
		Fbs : ProcWrapperIntFbsTyp;
		Test : STRING[80];
	END_STRUCT;
	ProcWrapperShInfoTyp : 	STRUCT 
		Axis : McAxisType;
		UserData : shUserData;
	END_STRUCT;
	ProcWrapperIntFbsTyp : 	STRUCT 
		RouteVelFb : MC_BR_RoutedMoveVel_AcpTrak;
		RouteAbsFb : MC_BR_RoutedMoveAbs_AcpTrak;
		ElasticVelFb : MC_BR_ElasticMoveVel_AcpTrak;
		ElasticAbsFb : MC_BR_ElasticMoveAbs_AcpTrak;
		ElasticAddFb : MC_BR_ElasticMoveAdd_AcpTrak;
		TrgPtFb : MC_BR_TrgPointEnable_AcpTrak;
		TrgPtGetInfoFb : MC_BR_TrgPointGetInfo_AcpTrak;
		ShCopyDataFb : MC_BR_ShCopyUserData_AcpTrak;
		ShReadInfoFb : MC_BR_ShReadInfo_AcpTrak;
	END_STRUCT;
	ProcWrapperStatesEnum : 
		(
		PROC_OFF,
		PROC_INIT,
		PROC_WAIT_SHUTTLE,
		PROC_GET_TRG_INFO,
		PROC_GET_USER_DATA,
		PROC_CHECK,
		PROC_UPDATE_USER_DATA,
		PROC_SEND,
		PROC_ERROR
		);
END_TYPE
