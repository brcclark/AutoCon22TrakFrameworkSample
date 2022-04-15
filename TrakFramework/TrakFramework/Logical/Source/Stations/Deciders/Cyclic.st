
PROGRAM _CYCLIC
	
	loopDeciderFb.Enable := gAsmIf.Cmd.Run;
	proc1Fb.Enable := gAsmIf.Cmd.Run;
	proc2Fb.Enable := gAsmIf.Cmd.Run;
	
	loopDeciderFb();
	proc1Fb();
	proc2Fb();
END_PROGRAM

