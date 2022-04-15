
TYPE
	AssemblyStatesEnum : 
		(
		ASM_IDLE,
		ASM_POWER_ON,
		ASM_CHECK_COUNT,
		ASM_ADD_SHUTTLE,
		ASM_WRITE_DATA,
		ASM_WAIT_START,
		ASM_GET_SHUTTLE,
		ASM_SEND_SHUTTLE,
		ASM_RUNNING,
		ASM_ERROR
		);
	AsmFbsTyp : 	STRUCT 
		PowerOnFb : MC_BR_AsmPowerOn_AcpTrak;
		PowerOffFb : MC_BR_AsmPowerOff_AcpTrak;
		SecAddShFb : MC_BR_SecAddShuttle_AcpTrak;
		SecGetShFb : MC_BR_SecGetShuttle_AcpTrak;
		RoutedMoveVelFb : MC_BR_RoutedMoveVel_AcpTrak;
		ShCopyDataFb : MC_BR_ShCopyUserData_AcpTrak;
	END_STRUCT;
END_TYPE
