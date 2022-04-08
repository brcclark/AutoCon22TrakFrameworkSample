(*Visualization to Scene viewer types*)

TYPE
	Stations : 	STRUCT 
		Load : Station_Typ;
	END_STRUCT;
	Vis_typ : 	STRUCT 
		Trak : McAcpTrakAssemblyVisData;
		A1HumanStation1 : BOOL;
		A1HumanStation2 : BOOL;
		A2HumanStation1 : BOOL;
		A2HumanStation2 : BOOL;
	END_STRUCT;
	Scn_Color_typ : 	STRUCT  (*RGB Strucuture for the scene*)
		Red : REAL;
		Green : REAL;
		Blue : REAL;
	END_STRUCT;
	Station_Typ : 	STRUCT 
		Active : BOOL;
		TimeRemaining : STRING[31];
	END_STRUCT;
END_TYPE
