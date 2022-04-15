
TYPE
	DeciderStationIntTyp : 	STRUCT 
		state : DeciderStationStateEnum;
		errorState : DeciderStationStateEnum;
		currentIdx : USINT;
		Fbs : DeciderStationFbTyp;
	END_STRUCT;
	DeciderStationStateEnum : 
		(
		DECIDER_OFF,
		DECIDER_INIT,
		DECIDER_WAIT,
		DECIDER_PROCESS_SHUTTLE,
		DECIDER_ERROR
		);
	DeciderStationFbTyp : 	STRUCT 
		procWrapperFb : procWrapper;
	END_STRUCT;
END_TYPE
