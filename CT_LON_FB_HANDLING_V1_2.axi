PROGRAM_NAME='CT_LON_FB_HANDLING_V1_2'

(*
	This Include will operate feedbacks from module v1.2 and up.
	
	In Module from v1.2, the feedbacks are also available as strings from the virtual LON device.
	
	The syntax of the responses is similar to the Command Strings
	which can be used to control the gateway with the v1.2 module.
	
*)

/*
    Addresses:

*/

// CT_LON_FB_HANDLING_V1_2.AXI requires the CT_CTGLON_COMMOM.AXI
// so if it is still not included, do it automatically
#IF_NOT_DEFINED _CTGLON_COMMON_
#INCLUDE 'CT_CTGLON_COMMOM' 
#END_IF


DEFINE_DEVICE

dvHVAC_Panel_1		= 10001:6:1
dvHVAC_Panel_2		= 10002:6:1
dvHVAC_Panel_3		= 10003:6:1
dvHVAC_Panel_4		= 10004:6:1
dvHVAC_Panel_5		= 10005:6:1
dvHVAC_Panel_6		= 10006:6:1
dvHVAC_Panel_7		= 10007:6:1
dvHVAC_Panel_8		= 10008:6:1
dvHVAC_Panel_9		= 10009:6:1
dvHVAC_Panel_10		= 10010:6:1
dvHVAC_Panel_11		= 10011:6:1
dvHVAC_Panel_12		= 10012:6:1
dvHVAC_Panel_13		= 10013:6:1
dvHVAC_Panel_14		= 10014:6:1
dvHVAC_Panel_15		= 10015:6:1
dvHVAC_Panel_16		= 10016:6:1

(***********************************************************)
DEFINE_CONSTANT
// Timeline identifier
LONG lTL_LON_FB2 = $C1 // eindeutige ID im gesamten Code
                        // unique ID in complete code
float DegreeCorrection = -2

(***********************************************************)
DEFINE_VARIABLE

volatile dev g_dvaHVAC_Panels[]		= { dvHVAC_Panel_1, dvHVAC_Panel_2, dvHVAC_Panel_3, dvHVAC_Panel_4, dvHVAC_Panel_5,
					    dvHVAC_Panel_6, dvHVAC_Panel_7, dvHVAC_Panel_8, dvHVAC_Panel_9, dvHVAC_Panel_10,
					    dvHVAC_Panel_11, dvHVAC_Panel_12, dvHVAC_Panel_13, dvHVAC_Panel_14, dvHVAC_Panel_15,
					    dvHVAC_Panel_16 }

//
persistent integer g_iaTempp[32]
persistent integer g_iaSetpoint_Tempp[32]
// the Structure definitions are part of the CT_CTGLON_COMMON.AXI,
// and are used to store the feedback values
VOLATILE _sSNVT_SWITCH strSwitchValues_Xenta[64]
VOLATILE _sSNVT_STATE strStateValues_Xenta[16]
VOLATILE _sSNVT_SETTING strSettingValues_Xenta[64]
VOLATILE _sSNVT_TEMPP strTemppValues_Xenta[32]
VOLATILE _sSNVT_PRESET strPresetValues_Xenta[32]
VOLATILE _sSNVT_COUNT strCountValues_Xenta[32]
VOLATILE _sSNVT_TIMESTAMP strTimeStampValues_Xenta[1]
VOLATILE _sSNVT_SCENE strSceneValues_Xenta[32]
VOLATILE _sSNVT_OCCUPANCY strOccupancyValues_Xenta[32]
VOLATILE _sSNVT_HVACMODE strHvacmodeValues_Xenta[32]

VOLATILE _sSNVT_SWITCH strSwitchValues_Daikin[64]
VOLATILE _sSNVT_STATE strStateValues_Daikin[16]
VOLATILE _sSNVT_SETTING strSettingValues_Daikin[64]
VOLATILE _sSNVT_TEMPP strTemppValues_Daikin[32]
VOLATILE _sSNVT_PRESET strPresetValues_Daikin[32]
VOLATILE _sSNVT_COUNT strCountValues_Daikin[32]
VOLATILE _sSNVT_TIMESTAMP strTimeStampValues_Daikin[1]
VOLATILE _sSNVT_SCENE strSceneValues_Daikin[32]
VOLATILE _sSNVT_OCCUPANCY strOccupancyValues_Daikin[32]
VOLATILE _sSNVT_HVACMODE strHvacmodeValues_Daikin[32]

// das/die Zeitintervall(e), um die Rückmeldungen zu aktualisieren
// timeframe(s) to update panel feedbacks
VOLATILE LONG lTL_LON_FB2_TIMES[1] = 5*60000 // in Millisekunden
                                  // in milliseconds




(***********************************************************)
// this function will pick up the feedback strings
// and can be modified for your own needs
DEFINE_FUNCTION MyOwnFeedbackOperation(CHAR sData[])
{
	STACK_VAR CHAR sCmd[30], tmp[10]	// received command
	STACK_VAR INTEGER nIndex		// Index number of feedback
	STACK_VAR integer l_iDegree, l_iHund, c,r, minus
	stack_var float l_fTemp
	
	// let's say the feedback was 'TEMPP=1:1:-123.45'
	sCmd = REMOVE_STRING(sData,"'='",1) // get feedback class, sCmd is 'TEMPP=' now
	SWITCH(sCmd)
	{
		CASE 'TEMPP=': // it was a temperature feedback
		{
			// sData is '1:1:-123.45' now
			REMOVE_STRING(sData,"':'",1) // remove gateway number
			// sData is '1:-123.45' now
			nIndex = ATOI(sData) // nIndex is 1 now
			REMOVE_STRING(sData,"':'",1) // remove index
			// sData is '-123.45' now
			
			if(nIndex == 10) {
			    
			    l_fTemp = atof(sData) + DegreeCorrection
			    sData = format('%5.1f', l_fTemp)
			    SEND_COMMAND g_dvaHVAC_Panels,"'^TXT-10,0,', sData, $B0,'C'"
			}
			/*
			if(nIndex >= 27 && nIndex <= 32) {
			    send_string vdvXentaDebug, "'XENTA Debug >> TEMPP [', itoa(nIndex),'] = ', sData"
			    send_string 0, 	       "'XENTA Debug >> TEMPP [', itoa(nIndex),'] = ', sData"
			}
			*/
		}
		case 'SWITCH=':
		{
		    stack_var 
			integer l_iIndex
			char l_caState[10], l_caValue[10]
			
		    // SWITCH=1:<index>:<value>:<state>
			// sData is '1:1:123.45:1' now
			REMOVE_STRING(sData,"':'",1) // remove gateway number
			// sData is '1:123.45:1' now
			nIndex = ATOI(sData) // nIndex is 1 now
			REMOVE_STRING(sData,"':'",1) // remove index
			// sData is '-123.45:1' now
			l_caValue = remove_string(sData, ':', 1)
			l_caState = sData
			
			//send_string vdvXentaDebug, "'SWITCH = : Value = ', l_caValue,'State = ', l_caState"
			
			// Wardrobe 2 (2)
			// temp AMX	- nviTempp 27
			// setPoint AMX	- Count 1 
			// Arm Signal 	- Count 2
			// Permit ARM 	- Count 3
			// Set Point 	- Tempp 28
			// Signal Local - Count 4
			// Permit Local - Count 5
			// 21A3 control - Count 6

			
			// Bedroom
			// temp AMX	- nviTempp 30
			// setPoint AMX - Count 11 
			// Arm Signal 	- Count 12
			// Permit ARM 	- Count 13
			// Set Point  	- Tempp 31
			// Signal Local - Count 14
			// Permit Local - Count 15
			// 22A3 control - Count 16

		}
		case 'COUNT=':
		{
		    REMOVE_STRING(sData,"':'",1) // remove gateway number
		    nIndex = ATOI(sData) // nIndex is 1 now
		    REMOVE_STRING(sData,"':'",1) // remove
		    
		    /*
		    if(nIndex >= 1 && nIndex <= 16) {
			send_string vdvXentaDebug, "'XENTA Debug >> COUNT [', itoa(nIndex),'] = ', sData"
			send_string 0		 , "'XENTA Debug >> COUNT [', itoa(nIndex),'] = ', sData"
		    }
		    */
		}
		case 'HVACMODE=':
		{
		    // HVACMODE=1:1:0
		}
	}
}

define_function fnUpdateHVACPanelsFb(integer in_iPanel)
{
    for(i = 1; i <= 12; i++)
    {
	send_command g_dvaHVAC_Panels[in_iPanel], "'^TXT-',itoa(1000 + 10*i + 0),',0,', itoa(strTemppValues_Daikin[i].fVALUE)"
	send_command g_dvaHVAC_Panels[in_iPanel], "'^TXT-',itoa(1000 + 10*i + 1),',0,', itoa(g_iaTempp[i])"
	//
	if(strSwitchValues_Daikin[2*i].snState == 0)
	{
	    [g_dvaHVAC_Panels[in_iPanel], 1000 + 10*i + 6] = 0 //auto
	    [g_dvaHVAC_Panels[in_iPanel], 1000 + 10*i + 4] = 0 //fan
	    [g_dvaHVAC_Panels[in_iPanel], 1000 + 10*i + 5] = 0 //cool
	    [g_dvaHVAC_Panels[in_iPanel], 1000 + 10*i + 7] = 0 //fan speed HI
	    [g_dvaHVAC_Panels[in_iPanel], 1000 + 10*i + 8] = 0 //fan speed LO
	    [g_dvaHVAC_Panels[in_iPanel], 1000 + 10*i + 3] = 0 //on/off state
	} else {
	    [g_dvaHVAC_Panels[in_iPanel], 1000 + 10*i + 6] = (strHvacmodeValues_Daikin[i].nValue == 0) //auto
	    [g_dvaHVAC_Panels[in_iPanel], 1000 + 10*i + 4] = (strHvacmodeValues_Daikin[i].nValue == 9) //fan
	    [g_dvaHVAC_Panels[in_iPanel], 1000 + 10*i + 5] = (strHvacmodeValues_Daikin[i].nValue == 3) //cool
	    [g_dvaHVAC_Panels[in_iPanel], 1000 + 10*i + 7] = (strSwitchValues_Daikin[2*i - 1].fValue == 100) //fan speed HI
	    [g_dvaHVAC_Panels[in_iPanel], 1000 + 10*i + 8] = (strSwitchValues_Daikin[2*i - 1].fValue == 50) //fan speed LO
	    [g_dvaHVAC_Panels[in_iPanel], 1000 + 10*i + 3] = 1 //on/off state
	}
    }
}

define_function fnOnUpdateHVACPanelsFb()
{
    for(i = 1; i <= 16; i++)
    {
	if(strSwitchValues_Daikin[2*i].snState == 0)
	{
	    [g_dvaHVAC_Panels, 1000 + 10*i + 6] = 0 //auto
	    [g_dvaHVAC_Panels, 1000 + 10*i + 4] = 0 //heat
	    [g_dvaHVAC_Panels, 1000 + 10*i + 5] = 0 //cool
	    [g_dvaHVAC_Panels, 1000 + 10*i + 7] = 0 //fan speed HI
	    [g_dvaHVAC_Panels, 1000 + 10*i + 8] = 0 //fan speed LO
	    [g_dvaHVAC_Panels, 1000 + 10*i + 3] = 0 //on/off state
	} else {
	    [g_dvaHVAC_Panels, 1000 + 10*i + 6] = (strHvacmodeValues_Daikin[i].nValue == 0) //auto
	    [g_dvaHVAC_Panels, 1000 + 10*i + 4] = (strHvacmodeValues_Daikin[i].nValue == 9) //fan
	    [g_dvaHVAC_Panels, 1000 + 10*i + 5] = (strHvacmodeValues_Daikin[i].nValue == 3) //cool
	    [g_dvaHVAC_Panels, 1000 + 10*i + 7] = (strSwitchValues_Daikin[2*i - 1].fValue == 100) //fan speed HI
	    [g_dvaHVAC_Panels, 1000 + 10*i + 8] = (strSwitchValues_Daikin[2*i - 1].fValue == 50) //fan speed LO
	    [g_dvaHVAC_Panels, 1000 + 10*i + 3] = 1 //on/off state
	}
    }
}
(***********************************************************)
DEFINE_START

TIMELINE_CREATE(lTL_LON_FB2,lTL_LON_FB2_TIMES,1,TIMELINE_ABSOLUTE,TIMELINE_REPEAT)


(***********************************************************)
DEFINE_EVENT

DATA_EVENT[vdvXenta]
{
	STRING:
	{	
		// The following Functions are part of the CT_CTGLON_COMMON.AXI,
		// and are responsible for automatically parsing the String Feedbacks
		// from the Module into Feedback Structures
		CTGLON_SWITCH_FB	(strSwitchValues_Xenta, 	data.text)	// parses SWITCH responses
		CTGLON_STATE_FB		(strStateValues_Xenta, 		data.text)
		CTGLON_SETTING_FB	(strSettingValues_Xenta, 	data.text)
		CTGLON_TEMPP_FB		(strTemppValues_Xenta, 		data.text)
		CTGLON_PRESET_FB	(strPresetValues_Xenta, 	data.text)
		CTGLON_COUNT_FB		(strCountValues_Xenta, 		data.text)
		CTGLON_SCENE_FB		(strSceneValues_Xenta, 		data.text)
		CTGLON_TIMESTAMP_FB	(strTimeStampValues_Xenta, 	data.text)
		CTGLON_OCCUPANCY_FB	(strOccupancyValues_Xenta, 	data.text)
		CTGLON_HVACMODE_FB	(strHvacmodeValues_Xenta,	data.text)
		
		// additional parsing and operation of the feedback string
		MyOwnFeedbackOperation(data.text)
	}
}

DATA_EVENT[vdvDaikin]
{
	STRING:
	{	
		// The following Functions are part of the CT_CTGLON_COMMON.AXI,
		// and are responsible for automatically parsing the String Feedbacks
		// from the Module into Feedback Structures
		CTGLON_SWITCH_FB	(strSwitchValues_Daikin, 	data.text)	// parses SWITCH responses
		CTGLON_STATE_FB		(strStateValues_Daikin, 	data.text)
		CTGLON_SETTING_FB	(strSettingValues_Daikin, 	data.text)
		CTGLON_TEMPP_FB		(strTemppValues_Daikin, 	data.text)
		CTGLON_PRESET_FB	(strPresetValues_Daikin, 	data.text)
		CTGLON_COUNT_FB		(strCountValues_Daikin, 	data.text)
		CTGLON_SCENE_FB		(strSceneValues_Daikin, 	data.text)
		CTGLON_TIMESTAMP_FB	(strTimeStampValues_Daikin, 	data.text)
		CTGLON_OCCUPANCY_FB	(strOccupancyValues_Daikin, 	data.text)
		CTGLON_HVACMODE_FB	(strHvacmodeValues_Daikin,	data.text)
		
		// additional parsing and operation of the feedback string
		//MyOwnFeedbackOperation(data.text)
	}
}

data_event[g_dvaHVAC_Panels]
{
    online:
    {
	SEND_COMMAND vdvXenta, "'TEMPP?1:10'"
    }
}

TIMELINE_EVENT[lTL_LON_FB2]
{
    //fnOnUpdateHVACPanelsFb()
	SEND_COMMAND vdvXenta, "'TEMPP?1:10'"
}


DEFINE_PROGRAM






