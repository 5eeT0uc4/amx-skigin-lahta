PROGRAM_NAME='CT_CTGLON_COMMOM'

(***********************************************************)
(* !!!!!!!!!!!!!! DO NOT MODIFY THIS INCLUDE !!!!!!!!!!!!! *)
(* !!!!!!!!!!!!!! DO NOT MODIFY THIS INCLUDE !!!!!!!!!!!!! *)
(* !!!!!!!!!!!!!! DO NOT MODIFY THIS INCLUDE !!!!!!!!!!!!! *)
(***********************************************************)

#IF_NOT_DEFINED _CTGLON_COMMON_
#DEFINE _CTGLON_COMMON_

DEFINE_CONSTANT
_CT_CTGLON_COMMON_VERSION_ = '1.2.1'


DEFINE_TYPE
STRUCTURE _sSNVT_SWITCH
{
  FLOAT fVALUE      // 8 bit percentage 0 .. 100% intensity as percentage of full scale, resolution 0.5%
  SINTEGER snSTATE  // state  0 .. 1, 0xFF  0 means off, 1 means on, 0xFF means undefined
}

STRUCTURE _sSNVT_STATE
{
  INTEGER nBIT0
  INTEGER nBIT1
  INTEGER nBIT2
  INTEGER nBIT3
  INTEGER nBIT4
  INTEGER nBIT5
  INTEGER nBIT6
  INTEGER nBIT7
  INTEGER nBIT8
  INTEGER nBIT9
  INTEGER nBIT10
  INTEGER nBIT11
  INTEGER nBIT12
  INTEGER nBIT13
  INTEGER nBIT14
  INTEGER nBIT15
}

STRUCTURE _sSNVT_SETTING
{
  INTEGER nFUNCTION   // 0  SET_OFF Setting off
                      // 1  SET_ON  Setting on 
                      // 2  SET_DOWN  Decrease setting by specified value
                      // 3  SET_UP  Increase setting by specified value
                      // 4  SET_STOP  Stop action
                      // 5  SET_STATE Setting on at specified value
                      // $FF SET_NUL  Value not available
  INTEGER nSETTING    // 0%..100%, setting as percentage of full-scale
  FLOAT fROTATION     // -359.98 to +360.00 deg rotational angle, resolution 0.02 degrees
}

STRUCTURE _sSNVT_TEMPP
{
  FLOAT fVALUE        // -273.17 .. +327.66 degrees C  (0.01 degrees C)
                      // real values: -27317..32166
}

STRUCTURE _sSNVT_PRESET
{
  INTEGER nLEARN        // 0 LN_RECALL recall specified preset
                        // 1 LN_LEARN_CURRENT store current value as preset
                        // 2 LN_LEARN_VALUE store specified value as preset
                        // 3 LN_REPORT_VALUE retrieve preset without recalling it
                        // $FF LN_NUL value not available
  INTEGER nSELECTOR     // preset selector 1..65,535 selects a specific preset
  INTEGER nVALUE1       // Specific to SNVT value, Byte1
  INTEGER nVALUE2       // Specific to SNVT value, Byte2
  INTEGER nVALUE3       // Specific to SNVT value, Byte3
  INTEGER nVALUE4       // Specific to SNVT value, Byte4
  INTEGER nDAY          // 0..65,534 65,535 means null elapsed time;
  INTEGER nHOUR         // 0..23
  INTEGER nMINUTE       // 0..59
  INTEGER nSECOND       // 0..60
  INTEGER nMILLISECOND  // 0..999
}

STRUCTURE _sSNVT_COUNT
{
  INTEGER nVALUE        // 0..65535
}

STRUCTURE _sSNVT_TIMESTAMP
{
  INTEGER nYEAR
  INTEGER nMONTH
  INTEGER nDAY
  INTEGER nHOUR
  INTEGER nMINUTE
  INTEGER nSECOND
}

STRUCTURE _sSNVT_SCENE
{
  INTEGER nFUNCTION       // 0 = SCENE_RECALL Recall value of specified scene
                          // 1 = SCENE_LEARN Learns current value for specified scene
  INTEGER nSCENENUMBER    // Scene 1..255
}

STRUCTURE _sSNVT_OCCUPANCY
{
  INTEGER nVALUE        // 0..255
}

STRUCTURE _sSNVT_HVACMODE
{
  INTEGER nVALUE        // 0..255
												// 0 = HVAC_AUTO
												// 1 = HVAC_HEAT
												// 2 = HVAC_MRNG_WRMUP
												// 3 = HVAC_COOL
												// 4 = HVAC_NIGHT_PURGE
												// 6 = HVAC_OFF
												// 7 = HVAC_TEST
												// 8 = HVAC_EMERG_HEAT
												// 9 = HVAC_FAN_ONLY
												// 10 = HVAC_FREE_COOL
												// 11 = HVAC_ICE
												// $FF = HVAC_NUL (value not available))
}


DEFINE_FUNCTION CTGLON_SWITCH_FB(_sSNVT_SWITCH _sValues[],CHAR sDT[2100])
{
	// The feedback strings of the LON module have a fixed number of parameters,
	// so parsing is simple (but "simple" does not mean "trivial" ;-)
	STACK_VAR CHAR sCmd[30] // to get the response type keyword
	STACK_VAR INTEGER nGw // gateway number
	STACK_VAR INTEGER nIdx // index number of LON node response
	STACK_VAR CHAR sDataText[2100]
	sDataText = sDT // do not modify source data (DATA.TEXT)
	IF(LENGTH_STRING(sDataText)) // still a feedback available?
	{
		sCmd = REMOVE_STRING(sDataText,"'='",1)
		IF(sCmd = 'SWITCH=') // Switch Response is like 'SWITCH=1:1:50.0:1'
		{
			// the following lines will parse the feedback and store the values in a structure
			nGw = ATOI(sDataText)
			REMOVE_STRING(sDataText,"':'",1)
			nIdx = ATOI(sDataText)
			REMOVE_STRING(sDataText,"':'",1)
			_sValues[nIdx].fValue = ATOF(sDataText)
			REMOVE_STRING(sDataText,"':'",1)
			_sValues[nIdx].snState = ATOI(sDataText)
			sDataText = ''
		}
	}
}


DEFINE_FUNCTION CTGLON_STATE_FB(_sSNVT_STATE _sValues[],CHAR sDT[2100])
{
	// The feedback strings of the LON module have a fixed number of parameters,
	// so parsing is simple (but "simple" does not mean "trivial" ;-)
	STACK_VAR CHAR sCmd[30] // to get the response type keyword
	STACK_VAR INTEGER nGw // gateway number
	STACK_VAR INTEGER nIdx // index number of LON node response
	STACK_VAR CHAR sDataText[2100]
	sDataText = sDT // do not modify source data (DATA.TEXT)
	IF(LENGTH_STRING(sDataText)) // still a feedback available?
	{
		sCmd = REMOVE_STRING(sDataText,"'='",1)
		IF(sCmd = 'STATE=') // State response is like 'STATE=1:3:1:1:1:1:1:1:1:1:0:0:0:0:0:0:0:0'
		{
			STACK_VAR INTEGER nX
			// the following lines will parse the feedback and store the values in a structure
			nGw = ATOI(sDataText)
			REMOVE_STRING(sDataText,"':'",1)
			nIdx = ATOI(sDataText)
			FOR(NX=1;nX<=16;nX++)
			{
				REMOVE_STRING(sDataText,"':'",1)
				SWITCH(nX)
				{
					CASE 1: { _sValues[nIdx].nBit15 = ATOI(sDataText) }
					CASE 2: { _sValues[nIdx].nBit14 = ATOI(sDataText) }
					CASE 3: { _sValues[nIdx].nBit13 = ATOI(sDataText) }
					CASE 4: { _sValues[nIdx].nBit12 = ATOI(sDataText) }
					CASE 5: { _sValues[nIdx].nBit11 = ATOI(sDataText) }
					CASE 6: { _sValues[nIdx].nBit10 = ATOI(sDataText) }
					CASE 7: { _sValues[nIdx].nBit9 = ATOI(sDataText) }
					CASE 8: { _sValues[nIdx].nBit8 = ATOI(sDataText) }
					CASE 9: { _sValues[nIdx].nBit7 = ATOI(sDataText) }
					CASE 10: { _sValues[nIdx].nBit6 = ATOI(sDataText) }
					CASE 11: { _sValues[nIdx].nBit5 = ATOI(sDataText) }
					CASE 12: { _sValues[nIdx].nBit4 = ATOI(sDataText) }
					CASE 13: { _sValues[nIdx].nBit3 = ATOI(sDataText) }
					CASE 14: { _sValues[nIdx].nBit2 = ATOI(sDataText) }
					CASE 15: { _sValues[nIdx].nBit1 = ATOI(sDataText) }
					CASE 16: { _sValues[nIdx].nBit0 = ATOI(sDataText) }
				}
			}
			sDataText = ''
		}
	}
}


DEFINE_FUNCTION CTGLON_SETTING_FB(_sSNVT_SETTING _sValues[],CHAR sDT[2100])
{
	// The feedback strings of the LON module have a fixed number of parameters,
	// so parsing is simple (but "simple" does not mean "trivial" ;-)
	STACK_VAR CHAR sCmd[30] // to get the response type keyword
	STACK_VAR INTEGER nGw // gateway number
	STACK_VAR INTEGER nIdx // index number of LON node response
	STACK_VAR CHAR sDataText[2100]
	sDataText = sDT // do not modify source data (DATA.TEXT)
	IF(LENGTH_STRING(sDataText)) // still a feedback available?
	{
		sCmd = REMOVE_STRING(sDataText,"'='",1)
		IF(sCmd = 'SETTING=') // Setting response is like 'SETTING=1:3:4:74:0'
		{
			// the following lines will parse the feedback and store the values in a structure
			nGw = ATOI(sDataText)
			REMOVE_STRING(sDataText,"':'",1)
			nIdx = ATOI(sDataText)
			REMOVE_STRING(sDataText,"':'",1)
			_sValues[nIdx].nFunction = ATOI(sDataText)
			REMOVE_STRING(sDataText,"':'",1)
			_sValues[nIdx].nSetting = ATOI(sDataText)
			REMOVE_STRING(sDataText,"':'",1)
			_sValues[nIdx].fRotation = ATOF(sDataText)
			sDataText = ''
		}
	}
}


DEFINE_FUNCTION CTGLON_TEMPP_FB(_sSNVT_TEMPP _sValues[],CHAR sDT[2100])
{
	// The feedback strings of the LON module have a fixed number of parameters,
	// so parsing is simple (but "simple" does not mean "trivial" ;-)
	STACK_VAR CHAR sCmd[30] // to get the response type keyword
	STACK_VAR INTEGER nGw // gateway number
	STACK_VAR INTEGER nIdx // index number of LON node response
	STACK_VAR CHAR sDataText[2100]
	sDataText = sDT // do not modify source data (DATA.TEXT)
	IF(LENGTH_STRING(sDataText)) // still a feedback available?
	{
		sCmd = REMOVE_STRING(sDataText,"'='",1)
		IF(sCmd = 'TEMPP=') // temperature response like 'TEMPP=1:5:-123.45'
		{
			nGw = ATOI(sDataText)
			REMOVE_STRING(sDataText,"':'",1)
			nIdx = ATOI(sDataText)
			REMOVE_STRING(sDataText,"':'",1)
			_sValues[nIdx].fValue = ATOF(sDataText)
			sDataText = ''
		}
	}
}


DEFINE_FUNCTION CTGLON_PRESET_FB(_sSNVT_PRESET _sValues[],CHAR sDT[2100])
{
	// The feedback strings of the LON module have a fixed number of parameters,
	// so parsing is simple (but "simple" does not mean "trivial" ;-)
	STACK_VAR CHAR sCmd[30] // to get the response type keyword
	STACK_VAR INTEGER nGw // gateway number
	STACK_VAR INTEGER nIdx // index number of LON node response
	STACK_VAR CHAR sDataText[2100]
	sDataText = sDT // do not modify source data (DATA.TEXT)
	IF(LENGTH_STRING(sDataText)) // still a feedback available?
	{
		sCmd = REMOVE_STRING(sDataText,"'='",1)
		IF(sCmd = 'PRESET=')
		{
			nGw = ATOI(sDataText)
			REMOVE_STRING(sDataText,"':'",1)
			nIdx = ATOI(sDataText)
			REMOVE_STRING(sDataText,"':'",1)
			_sValues[nIdx].nLearn = ATOI(sDataText)
			REMOVE_STRING(sDataText,"':'",1)
			_sValues[nIdx].nSelector = ATOI(sDataText)
			REMOVE_STRING(sDataText,"':'",1)
			_sValues[nIdx].nValue1 = ATOI(sDataText)
			REMOVE_STRING(sDataText,"':'",1)
			_sValues[nIdx].nValue2 = ATOI(sDataText)
			REMOVE_STRING(sDataText,"':'",1)
			_sValues[nIdx].nValue3 = ATOI(sDataText)
			REMOVE_STRING(sDataText,"':'",1)
			_sValues[nIdx].nValue4 = ATOI(sDataText)
			REMOVE_STRING(sDataText,"':'",1)
			_sValues[nIdx].nDay = ATOI(sDataText)
			REMOVE_STRING(sDataText,"':'",1)
			_sValues[nIdx].nHour = ATOI(sDataText)
			REMOVE_STRING(sDataText,"':'",1)
			_sValues[nIdx].nMinute = ATOI(sDataText)
			REMOVE_STRING(sDataText,"':'",1)
			_sValues[nIdx].nSecond = ATOI(sDataText)
			REMOVE_STRING(sDataText,"':'",1)
			_sValues[nIdx].nMillisecond = ATOI(sDataText)
			sDataText = ''
		}
	}
}


DEFINE_FUNCTION CTGLON_COUNT_FB(_sSNVT_COUNT _sValues[],CHAR sDT[2100])
{
	// The feedback strings of the LON module have a fixed number of parameters,
	// so parsing is simple (but "simple" does not mean "trivial" ;-)
	STACK_VAR CHAR sCmd[30] // to get the response type keyword
	STACK_VAR INTEGER nGw // gateway number
	STACK_VAR INTEGER nIdx // index number of LON node response
	STACK_VAR CHAR sDataText[2100]
	sDataText = sDT // do not modify source data (DATA.TEXT)
	IF(LENGTH_STRING(sDataText)) // still a feedback available?
	{
		sCmd = REMOVE_STRING(sDataText,"'='",1)
		IF(sCmd = 'COUNT=') // COUNT response like 'COUNT=1:30:46888'
		{
			nGw = ATOI(sDataText)
			REMOVE_STRING(sDataText,"':'",1)
			nIdx = ATOI(sDataText)
			REMOVE_STRING(sDataText,"':'",1)
			_sValues[nIdx].nValue = ATOI(sDataText)
			sDataText = ''
		}
	}
}


DEFINE_FUNCTION CTGLON_TIMESTAMP_FB(_sSNVT_TIMESTAMP _sValues[],CHAR sDT[2100])
{
	// The feedback strings of the LON module have a fixed number of parameters,
	// so parsing is simple (but "simple" does not mean "trivial" ;-)
	STACK_VAR CHAR sCmd[30] // to get the response type keyword
	STACK_VAR INTEGER nGw // gateway number
	STACK_VAR INTEGER nIdx // index number of LON node response
	STACK_VAR CHAR sDataText[2100]
	sDataText = sDT // do not modify source data (DATA.TEXT)
	IF(LENGTH_STRING(sDataText)) // still a feedback available?
	{
		sCmd = REMOVE_STRING(sDataText,"'='",1)
		IF(sCmd = 'TIMESTAMP=') // TIMESTAMP response like 'TIMESTAMP=1:1:2003:3:12:14:54:0'
		{
			nGw = ATOI(sDataText)
			REMOVE_STRING(sDataText,"':'",1)
			nIdx = ATOI(sDataText)
			REMOVE_STRING(sDataText,"':'",1)
			_sValues[nIdx].nYear = ATOI(sDataText)
			REMOVE_STRING(sDataText,"':'",1)
			_sValues[nIdx].nMonth = ATOI(sDataText)
			REMOVE_STRING(sDataText,"':'",1)
			_sValues[nIdx].nDay = ATOI(sDataText)
			REMOVE_STRING(sDataText,"':'",1)
			_sValues[nIdx].nHour = ATOI(sDataText)
			REMOVE_STRING(sDataText,"':'",1)
			_sValues[nIdx].nMinute = ATOI(sDataText)
			REMOVE_STRING(sDataText,"':'",1)
			_sValues[nIdx].nSecond = ATOI(sDataText)
			sDataText = ''
		}
	}
}


DEFINE_FUNCTION CTGLON_SCENE_FB(_sSNVT_SCENE _sValues[],CHAR sDT[2100])
{
	// The feedback strings of the LON module have a fixed number of parameters,
	// so parsing is simple (but "simple" does not mean "trivial" ;-)
	STACK_VAR CHAR sCmd[30] // to get the response type keyword
	STACK_VAR INTEGER nGw // gateway number
	STACK_VAR INTEGER nIdx // index number of LON node response
	STACK_VAR CHAR sDataText[2100]
	sDataText = sDT // do not modify source data (DATA.TEXT)
	IF(LENGTH_STRING(sDataText)) // still a feedback available?
	{
		sCmd = REMOVE_STRING(sDataText,"'='",1)
		IF(sCmd = 'SCENE=') // SCENE response like 'SCENE=1:23:0:44'
		{
			nGw = ATOI(sDataText)
			REMOVE_STRING(sDataText,"':'",1)
			nIdx = ATOI(sDataText)
			REMOVE_STRING(sDataText,"':'",1)
			_sValues[nIdx].nFUNCTION = ATOI(sDataText)
			REMOVE_STRING(sDataText,"':'",1)
			_sValues[nIdx].nSCENENUMBER = ATOI(sDataText)
			sDataText = ''
		}
	}
}


DEFINE_FUNCTION CTGLON_OCCUPANCY_FB(_sSNVT_OCCUPANCY _sValues[],CHAR sDT[2100])
{
	// The feedback strings of the LON module have a fixed number of parameters,
	// so parsing is simple (but "simple" does not mean "trivial" ;-)
	STACK_VAR CHAR sCmd[30] // to get the response type keyword
	STACK_VAR INTEGER nGw // gateway number
	STACK_VAR INTEGER nIdx // index number of LON node response
	STACK_VAR CHAR sDataText[2100]
	sDataText = sDT // do not modify source data (DATA.TEXT)
	IF(LENGTH_STRING(sDataText)) // still a feedback available?
	{
		sCmd = REMOVE_STRING(sDataText,"'='",1)
		IF(sCmd = 'OCCUPANCY=') // OCCUPANCY response like 'OCCUPANCY=1:30:0'
		{
			nGw = ATOI(sDataText)
			REMOVE_STRING(sDataText,"':'",1)
			nIdx = ATOI(sDataText)
			REMOVE_STRING(sDataText,"':'",1)
			_sValues[nIdx].nVALUE = ATOI(sDataText)
			sDataText = ''
		}
	}
}


DEFINE_FUNCTION CTGLON_HVACMODE_FB(_sSNVT_HVACMODE _sValues[],CHAR sDT[2100])
{
	// The feedback strings of the LON module have a fixed number of parameters,
	// so parsing is simple (but "simple" does not mean "trivial" ;-)
	STACK_VAR CHAR sCmd[30] // to get the response type keyword
	STACK_VAR INTEGER nGw // gateway number
	STACK_VAR INTEGER nIdx // index number of LON node response
	STACK_VAR CHAR sDataText[2100]
	sDataText = sDT // do not modify source data (DATA.TEXT)
	IF(LENGTH_STRING(sDataText)) // still a feedback available?
	{
		sCmd = REMOVE_STRING(sDataText,"'='",1)
		IF(sCmd = 'HVACMODE=') // HVACMODE response like 'HVACMODE=1:11:6'
		{
			nGw = ATOI(sDataText)
			REMOVE_STRING(sDataText,"':'",1)
			nIdx = ATOI(sDataText)
			REMOVE_STRING(sDataText,"':'",1)
			_sValues[nIdx].nVALUE = ATOI(sDataText)
			sDataText = ''
		}
	}
}

#END_IF

(***********************************************************)
(***********************************************************)
(***********************************************************)

