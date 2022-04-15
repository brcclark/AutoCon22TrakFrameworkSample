
{REDUND_ERROR} FUNCTION_BLOCK DeciderStationFb (*TODO: Add your comment here*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		Enable : {REDUND_UNREPLICABLE} BOOL;
		ProcPt : SystemDestinationsEnum;
		DestLookup : REFERENCE TO ARRAY[0..MAX_DESTINATIONS_IDX] OF SystemDestinationsTyp;
		DestList : {REDUND_UNREPLICABLE} ARRAY[0..MAX_DECIDERS_IDX] OF SystemDestinationsEnum;
		NumberOfDestinations : USINT;
		StationPars : ProcWrapperParTyp;
	END_VAR
	VAR_OUTPUT
		Active : BOOL;
		NextDest : SystemDestinationsEnum;
		Error : BOOL;
		ErrorID : BOOL;
	END_VAR
	VAR
		int : DeciderStationIntTyp;
	END_VAR
END_FUNCTION_BLOCK
