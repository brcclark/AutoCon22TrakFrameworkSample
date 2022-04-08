
TYPE
	shUserData : 	STRUCT 
		ColorEnum : Colors_Typ;
		ColorRGB : ARRAY[0..2]OF REAL;
		Destination : SystemDestinationsEnum;
	END_STRUCT;
	Colors_Typ : 
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
END_TYPE

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
		DefaultVelocity : LREAL;
		DefaultAccel : LREAL;
		DefaultDecel : LREAL;
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
		Startup : AcpTrakAsmStartupParTyp;
		FirstMove : AcpTrakAsmStartupParTyp;
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
	END_STRUCT;
END_TYPE
