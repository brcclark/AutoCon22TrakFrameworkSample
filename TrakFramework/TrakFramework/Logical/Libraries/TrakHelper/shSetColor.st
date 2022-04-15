
(* Wrapper to set a RGB color value for a shuttle based upon an enumeration *)
FUNCTION shSetColor
	CASE Color OF
		COLOR_GREEN:    
			pRGB[0] := 0.0;
			pRGB[1] := 1.0;
			pRGB[2] := 0.0;
		COLOR_BLUE:  
			pRGB[0] := 0.0;
			pRGB[1] := 0.0;
			pRGB[2] := 1.0;
		COLOR_RED:   
			pRGB[0] := 1.0;
			pRGB[1] := 0.0;
			pRGB[2] := 0.0;
		COLOR_YELLOW:
			pRGB[0] := 0.8;
			pRGB[1] := 0.8;
			pRGB[2] := 0.0;
		COLOR_WHITE:
			pRGB[0] := 1.0;
			pRGB[1] := 1.0;
			pRGB[2] := 1.0;
		COLOR_ORANGE:
			pRGB[0] := 1.0;
			pRGB[1] := 0.5;
			pRGB[2] := 0;
		COLOR_CYAN:
			pRGB[0] := 0;
			pRGB[1] := 1.0;
			pRGB[2] := 1.0;
		COLOR_BLACK:
			pRGB[0] := 0;
			pRGB[1] := 0;
			pRGB[2] := 0;
		COLOR_PINK:
			pRGB[0] := 1;
			pRGB[1] := 0;
			pRGB[2] := 0.5;
	END_CASE;
	
END_FUNCTION
