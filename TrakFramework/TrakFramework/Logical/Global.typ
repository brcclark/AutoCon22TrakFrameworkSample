(*Main Interfaces Types*)

TYPE
	MainIfTyp : 	STRUCT 
		Cmd : MainIfCmdTyp;
		Par : MainIfParTyp;
		Sts : MainIfStsTyp;
	END_STRUCT;
	MainIfCmdTyp : 	STRUCT 
		Power : BOOL;
		Run : BOOL;
		Reset : BOOL;
		ShowError : BOOL;
	END_STRUCT;
	MainIfParTyp : 	STRUCT 
		DefaultVelocity : REAL;
		DefaultAccel : REAL;
		DefaultDecel : REAL;
	END_STRUCT;
	MainIfStsTyp : 	STRUCT 
		TrakPowered : BOOL;
		Running : BOOL;
		Error : BOOL;
	END_STRUCT;
END_TYPE

(*Trak Assembly Interface Types*)

TYPE
	AcpTrakAsmIfTyp : 	STRUCT 
		Cmd : AcpTrakAsmCmdsTyp;
		Par : AcpTrakAsmParTyp;
		Sts : AcpTrakAsmStsTyp;
	END_STRUCT;
	AcpTrakAsmCmdsTyp : 	STRUCT 
		Power : BOOL;
		Run : BOOL;
		Reset : BOOL;
	END_STRUCT;
	AcpTrakAsmParTyp : 	STRUCT 
		NumShuttles : USINT;
		Startup : AcpTrakAsmStartupParTyp;
		FirstMove : SystemDestinationsEnum;
	END_STRUCT;
	AcpTrakAsmStartupParTyp : 	STRUCT 
		Sector : McSectorType;
		Position : LREAL;
		Gap : LREAL;
	END_STRUCT;
	AcpTrakAsmStsTyp : 	STRUCT 
		Powered : BOOL;
		WaitingToStart : BOOL;
		Running : BOOL;
		CurrentShuttleIdx : USINT;
		Error : BOOL;
		ErrorID : UDINT;
	END_STRUCT;
END_TYPE
