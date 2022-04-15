
{REDUND_ERROR} FUNCTION shSetColor : UDINT (*Wrapper to set a RGB color value for a shuttle based upon an enumeration*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		Color : shColors_Typ;
		pRGB : REFERENCE TO ARRAY[0..2] OF REAL;
	END_VAR
END_FUNCTION

{REDUND_ERROR} FUNCTION_BLOCK procWrapper (*TODO: Add your comment here*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		Enable : {REDUND_UNREPLICABLE} BOOL;
		ProcessPt : SystemDestinationsEnum;
		DestLookups : REFERENCE TO ARRAY[0..MAX_DESTINATIONS_IDX] OF SystemDestinationsTyp;
		Pars : REFERENCE TO ProcWrapperParTyp;
	END_VAR
	VAR_OUTPUT
		Active : BOOL;
		Error : BOOL;
		ErrorID : UDINT;
		ShPresent : BOOL;
	END_VAR
	VAR
		int : ProcWrapperInternalTyp;
	END_VAR
END_FUNCTION_BLOCK
