PROGRAM_NAME='Lahta_2'

#INCLUDE 'EIB_Tools.axi'
#include 'Strings.axi'

/*
	79.134.195.218
	COUNT=1:15: - Laundry
*/
DEFINE_DEVICE

dvEIB		= 0:3:2
vdvEIB		= 34001:1:2

dvDaikin	= 5001:2:2
dvXenta		= 0:4:2

vdvDaikin	= 34002:1:2
vdvXenta	= 34003:1:2

vdvXentaDebug   = 34004:1:2

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
//определить панели управления климатом


(***********************************************************)
(*               CONSTANT DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_CONSTANT

float DegreeCorrection = -2

dvM2_IO		= 5001:4:2

MAX_EIB_PANELS = 30
MAX_AIR_COND = 16

TL_Panels_Init			= $F1
TL_SetPoint			= $F2

integer iTempp_min		= 16
integer iTempp_max		= 28

//уставка теплго пола
integer iSetPointFloor_min	= 16
integer iSetPointFloor_max	= 36
//уставка управления по воздуху
integer iSetPointAir_min	= 16
integer iSetPointAir_max	= 30
//уставка кондиционера
integer iSetPointAC_min		= 16
integer iSetPointAC_max		= 24

PANEL_TYPE_NONE			= 0 // панель ни чем не управляет
PANEL_TYPE_FULL			= 1 // полное управление ТП, воздух, кондиционер
PANEL_TYPE_FLOOR_AIR		= 2 // подеержание ТП/Воздух
PANEL_TYPE_AIR_AC		= 3 // Поддержание Воздух, управление кондиционером
PANEL_TYPE_AIR			= 5 // поддержание воздуха

CONTROL_AIR			= 1
CONTROL_FLOOR			= 0
CONTROL_AC			= 2

MODE_AIR			= 1
MODE_FLOOR			= 0
(***********************************************************)
(*              DATA TYPE DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_TYPE

structure eib_panel_s
{
    char m_caAddr[10]
    integer m_iTypeOfPanel //тип панели управления
    char m_caTempp[10] // температура в помещении от панели
    char m_caSetPoint[10]
    char m_caSetPointFloor[10]
    char m_caSetPointAir[10]
    char m_caSetPointAC[10]
    integer m_iSetPointFloor_Correction
    integer m_iSetPointAir_Correction
    integer m_iSetPointAC_Correction
    integer m_iBtn //pressed button
    integer m_iPushState //push state
    integer m_iMode // heat 1=air / 2=warm floor
    integer m_iCurrentControl //0=air,1=floor,2=AC
    integer m_iAC_State // on/off
    integer m_iAuto //
    integer m_iFanSpeed // 1-2
    
}

structure ac_s
{
    char m_caName[20]
    integer m_iPower
    char m_caSpaceTempp[10]
    char m_caSetPoint[10]
    char m_caHVACMode[10]
    char m_caFanSpeed[10] // 0, 50, 100
    //char m_caFanSpeedHI[10] = '100' // 0, 50, 100
    //char m_caFanSpeedLO[10] = '50'// 0, 50, 100
    char nviTempp[10]
    char nvoSetPoint[10]
    char nvoFanSpeed[10]
    char nvoHVAC[10]
    char nvoOnOff[10]
}
(***********************************************************)
(*               VARIABLE DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_VARIABLE

volatile dev g_dvaHVAC_Panels[]		= { dvHVAC_Panel_1, dvHVAC_Panel_2, dvHVAC_Panel_3, dvHVAC_Panel_4, dvHVAC_Panel_5,
					    dvHVAC_Panel_6, dvHVAC_Panel_7, dvHVAC_Panel_8, dvHVAC_Panel_9, dvHVAC_Panel_10,
					    dvHVAC_Panel_11, dvHVAC_Panel_12, dvHVAC_Panel_13, dvHVAC_Panel_14, dvHVAC_Panel_15,
					    dvHVAC_Panel_16 }

volatile devchan dvM2_IO_1	= {dvM2_IO, 1} // proj door is close
volatile devchan dvM2_IO_2	= {dvM2_IO, 2} // proj status
volatile devchan dvM2_IO_3	= {dvM2_IO, 3} // open/close door trigger
volatile devchan dvM2_IO_4	= {dvM2_IO, 4} // 


volatile integer g_iaXentaSetPointZones[] = { 27,27,17,18,19,20,14,16,2,0,13,13,29,4,1,
						7,9,6,10,5,11,12,8,22,25,26,24,21,23,28,0 }
						
volatile char m_caShnider_IP[] = '10.98.253.48'
/*

1. Панели Jung первого этажа
<номер панели> - <номер помещения без SetPoint> - описание
01 - [SetPoint27] - Холл первого этажа у входа в дом
02 - [SetPoint27] - Холл первого этажа у входа в столовую
03 - [SetPoint17] - Гардероб 1 Правый
04 - [SetPoint18] - Гардероб 2 Левый
05 - [SetPoint19] - Кабинет
06 - [SetPoint20] - Кинозал
07 - [SetPoint14] - Столовая
08 - [SetPoint16] - Кухня
09 - [SetPoint02] - Фитнес
10 - 
11 - [SetPoint13] - Салон (панель со стороны столовой)
12 - [SetPoint13] - Салон (панель со стороны бассейна)
13 - [SetPoint29] - Раздевалка бассейн
14 - [SetPoint04] - Восточная сигарная
15 - [SetPoint01] - Бассейн

2. Панели Jung второго этажа
<номер панели> - <номер помещения без SetPoint> - описание
01 - [SetPoint07] - Гостевая ванная 2 (правая)
02 - [SetPoint09] - Гостевая 2 (правая)
03 - [SetPoint06] - Гостевая ванная 1 (левая)
04 - [SetPoint10] - Гостевая 1 (левая)
05 - [SetPoint05] - Анна Ванная
06 - [SetPoint11] - Анна Спальня
07 - [SetPoint12] - Анна Гостевая
08 - [SetPoint08] - Игровая
09 - [SetPoint22] - Робик Ванная
10 - [SetPoint25] - Робик Спальня
11 - [SetPoint26] - Гардероб Скигина
12 - [SetPoint24] - Гардероб Ольги
13 - [SetPoint21] - Мастер Ванная
14 - [SetPoint23] - Мастер Спальня
15 - [SetPoint28] - Холл второго этажа

Постирочная и массажная - управление без панели и без датчиков температуры
    1. уставка в постирочной - SetPoint15
    2. уставка в массажной - SetPoint03

Адресация панели Jung
<номер панели> / <этаж> / <команда>

Команды: см. EIB_Table

*/
persistent integer g_iaSetPoint[MAX_EIB_PANELS]
persistent integer g_iaSetPointFloor[MAX_EIB_PANELS]
persistent integer g_iaSetPointAir[MAX_EIB_PANELS]
persistent integer g_iaSetPointAC[MAX_EIB_PANELS]

persistent integer g_iaSetPointFloor_Correction[MAX_EIB_PANELS]
persistent integer g_iaSetPointAir_Correction[MAX_EIB_PANELS]
persistent integer g_iaSetPointAC_Correction[MAX_EIB_PANELS]

i=0
nCounter
LONG lEIB_Value[3000]

volatile long m_laTL_SetPoint[1] = 30000

// Arrays for Feedbacks
volatile float 		fLON_SWITCH_RM_Xenta[10][64][2]     	// 10 Gateways; 64 SWITCHes w/ 2 Values
volatile integer 	nLON_STATE_RM_Xenta[10][16][16]   	// 10 Gateways; 16 STATEs w/ 16 Values
volatile float 		fLON_SETTING_RM_Xenta[10][64][3]    	// 10 Gateways; 64 SETTINGs w/ 3 Values
volatile float 		fLON_TEMPP_RM_Xenta[10][32][1]      	// 10 Gateways; 32 TEMPPs w/ 1 Value
volatile integer 	nLON_PRESET_RM_Xenta[10][32][11]  	// 10 Gateways; 32 PRESETs w/ 11 Values
volatile integer 	nLON_COUNT_RM_Xenta[10][32][1]    	// 10 Gateways; 32 COUNTs w/ 1 Value
volatile integer 	nLON_TIMESTAMP_RM_Xenta[10][1][6] 	// 10 Gateways; 1 TIMESTAMP w/ 6 Values
volatile integer 	nLON_SCENE_RM_Xenta[10][32][2]    	// 10 Gateways; 32 SCENEs w/ 2 Values
volatile integer 	nLON_OCCUP_RM_Xenta[10][32][1]    	// 10 Gateways; 32 OCCUPANCYs w/ 1 Value
volatile integer 	nLON_HVACMODE_RM_Xenta[10][32][1]	// 10 Gateways; 32 HVAC_MODEs w/ 1 Value

// Arrays for Feedbacks
volatile float 		fLON_SWITCH_RM_Daikin[10][64][2]     	// 10 Gateways; 64 SWITCHes w/ 2 Values
volatile integer 	nLON_STATE_RM_Daikin[10][16][16]   	// 10 Gateways; 16 STATEs w/ 16 Values
volatile float 		fLON_SETTING_RM_Daikin[10][64][3]    	// 10 Gateways; 64 SETTINGs w/ 3 Values
volatile float 		fLON_TEMPP_RM_Daikin[10][32][1]      	// 10 Gateways; 32 TEMPPs w/ 1 Value
volatile integer 	nLON_PRESET_RM_Daikin[10][32][11]  	// 10 Gateways; 32 PRESETs w/ 11 Values
volatile integer 	nLON_COUNT_RM_Daikin[10][32][1]    	// 10 Gateways; 32 COUNTs w/ 1 Value
volatile integer 	nLON_TIMESTAMP_RM_Daikin[10][1][6] 	// 10 Gateways; 1 TIMESTAMP w/ 6 Values
volatile integer 	nLON_SCENE_RM_Daikin[10][32][2]    	// 10 Gateways; 32 SCENEs w/ 2 Values
volatile integer 	nLON_OCCUP_RM_Daikin[10][32][1]    	// 10 Gateways; 32 OCCUPANCYs w/ 1 Value
volatile integer 	nLON_HVACMODE_RM_Daikin[10][32][1]	// 10 Gateways; 32 HVAC_MODEs w/ 1 Value


persistent eib_panel_s EIBPanel[MAX_EIB_PANELS]
persistent ac_s	AirCond[MAX_AIR_COND]
// The following parameter will define Comm settings
// CTG-LON operates in RS485 mode
// CTG-LON II operates in RS232 mode
VOLATILE INTEGER nGW_PROTOKOLL  = 1 // 1=RS232, Anderer Wert = RS485
                                    // 1=RS232, other values = RS485
// The following Includes are used for the Command/String interface
// supported by Module version v1.2 and up
//#include 'CT_CTGLON_COMMOM.axi'					
//#include 'CT_LON_FB_HANDLING_V1_2.axi'

(***********************************************************)
(*               LATCHING DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_LATCHING

(***********************************************************)
(*       MUTUALLY EXCLUSIVE DEFINITIONS GO BELOW           *)
(***********************************************************)
DEFINE_MUTUALLY_EXCLUSIVE

(***********************************************************)
(*        SUBROUTINE/FUNCTION DEFINITIONS GO BELOW         *)
(***********************************************************)
(* EXAMPLE: DEFINE_FUNCTION <RETURN_TYPE> <NAME> (<PARAMETERS>) *)
(* EXAMPLE: DEFINE_CALL '<NAME>' (<PARAMETERS>) *)
/*
define_function integer  fnEIS5Decode(integer in_iLevel)
{
    stack_var 
	integer M
	integer E
	integer result, pow
    
    M = in_iLevel & $07FF
    E = (in_iLevel & $7800) >> 11
    pow = power_value(2,E)
    result = M*pow
    return result
}
*/

define_function integer fnReturn_SetPoint(integer in_iValue)
{
    if(in_iValue > iTempp_min && in_iValue < iTempp_max)
	in_iValue = in_iValue
    if(in_iValue <= iTempp_min)
	in_iValue = iTempp_min
    if(in_iValue >= iTempp_max)
	in_iValue = iTempp_max
	
    return in_iValue
}

define_function integer fnReturn_SetPoint_byParam(integer in_iValue, integer in_iMin, integer in_iMax)
{
    if(in_iValue > in_iMin && in_iValue < in_iMax)
	in_iValue = in_iValue
    if(in_iValue <= in_iMin)
	in_iValue = in_iMin
    if(in_iValue >= in_iMax)
	in_iValue = in_iMax
	
    return in_iValue
}


define_function integer fnGetEibChannel(char in_cParam[])
{
    stack_var integer l_iChannel
    
    l_iChannel = atoi(left_string(in_cParam,2)) - 10
    
    return l_iChannel
}

define_function integer fnGetEibPanel(char in_cParam[])
{
    stack_var integer l_iPanel
    
    l_iPanel = atoi(right_string(in_cParam, 2))
    return l_iPanel
}

define_function char[10] fnReturnAverageTempp(integer in_iPnl1, in_iPnl2)
{
    stack_var
    integer v1,v2
    char res[10]
    float tempp1
    float tempp2
    float aver
    char l_caResult[10]
    
    tempp1 = atof(EIBPanel[in_iPnl1].m_caTempp)
    tempp2 = atof(EIBPanel[in_iPnl2].m_caTempp)
    
    aver = (tempp1 + tempp2)/2;
    res = format('%2.2f', aver);//itoa((v1 + v2)/2)

    return res
}

define_function fnEIBonReceive(char in_caData[])
{
    stack_var 
    char l_caTempData[100]
    char l_caEIB_id[10]
    char l_caParam[10]
    long l_lParam
    integer l_iParam
    integer l_iBtn
    integer l_iPanel
    
    if(find_string(in_caData, 'EIS5=', 1) == 1) {
	l_caTempData = remove_string(in_caData, 'EIS5=', 1)
	
	l_caEIB_id = remove_string(in_caData, ':', 1)
	set_length_string(l_caEIB_id, length_string(l_caEIB_id) - 1);
	
	l_caParam = in_caData
	//l_lParam = atol(l_caParam)
	l_iPanel = fnGetEibPanel(l_caEIB_id)
	
	l_iBtn = fnGetEibChannel(l_caEIB_id)
	
	if(l_iPanel != 0 && l_iPanel <= MAX_EIB_PANELS) {
	    EIBPanel[l_iPanel].m_caAddr = l_caEIB_id
	    
	    // Temp from EIB Panel
	    if(l_iBtn == 11) {
		if(l_iPanel == 29){
		    EIBSet(vdvEIB, l_iPanel, 5)
		}else
		if(l_iPanel == 21 || l_iPanel == 17 || l_iPanel == 19){
		    EIBSet(vdvEIB, l_iPanel, 10)
		}else{
		    EIBSet(vdvEIB, l_iPanel, 80)
		}
		
		EIBPanel[l_iPanel].m_caTempp = l_caParam
		
		if(l_iPanel != 1 && l_iPanel != 2 && l_iPanel != 10 && l_iPanel != 11 && l_iPanel != 12) {
		    send_command vdvXenta, "'SET_HR 1,', itoa(g_iaXentaSetPointZones[l_iPanel] + 100),',', itoa(atof(EIBPanel[l_iPanel].m_caTempp)*10),';'"
		} else
		if(l_iPanel == 11 || l_iPanel == 12) {
		    send_command vdvXenta, "'SET_HR 1,', itoa(g_iaXentaSetPointZones[l_iPanel] + 100),',', itoa(atof(fnReturnAverageTempp(11,12))*10),';'"
		} else
		if(l_iPanel == 1 || l_iPanel == 2) {
		    send_command vdvXenta, "'SET_HR 1,', itoa(g_iaXentaSetPointZones[l_iPanel] + 100),',', itoa(atof(fnReturnAverageTempp(1,2))*10),';'"
		}
	    }
	}
    } else
    if(find_string(in_caData, 'SET=', 1) == 1) {
	l_caTempData = remove_string(in_caData, 'SET=', 1)
	fnStr_GetStringWhile(in_caData, l_caEIB_id, ':')
	l_caTempData = remove_string(in_caData, ':', 1)
	l_caParam = in_caData
	
	//send_string 0, "'>>> EIB SET = ', l_caEIB_id,' :: ', l_caParam"
	
	l_iParam = atoi(l_caParam)
	l_iBtn = fnGetEibChannel(l_caEIB_id)
	l_iPanel = fnGetEibPanel(l_caEIB_id)
	
	if(l_iPanel) {
	    EIBPanel[l_iPanel].m_caAddr = l_caEIB_id
	    if((l_iParam == 0 || l_iParam == 1) && (l_iBtn >= 1 && l_iBtn <= 6)) {
		EIBPanel[l_iPanel].m_iBtn = l_iBtn
		EIBPanel[l_iPanel].m_iPushState = l_iParam
		
		fnProcessEibControl(l_iPanel)
	    }
	}
    }
}

define_function fnProcessEibControl(integer in_iEibPanel)
{
    stack_var 
    integer l_iBtn
    integer l_iPushState
    integer l_iACState
    integer l_iCurrentControl
    integer l_iSetPoint
    integer l_iTypeOfPanel
    
    l_iBtn 		= EIBPanel[in_iEibPanel].m_iBtn
    l_iPushState 	= EIBPanel[in_iEibPanel].m_iPushState
    l_iCurrentControl	= EIBPanel[in_iEibPanel].m_iCurrentControl
    l_iTypeOfPanel	= EIBPanel[in_iEibPanel].m_iTypeOfPanel
    
    if(l_iPushState) {
	switch(l_iBtn)
	{
	    case 1: { //Set +
			switch(l_iCurrentControl)
			{
			    case CONTROL_AIR: 	l_iSetPoint = fnReturn_SetPoint_byParam(g_iaSetPointAir[in_iEibPanel] + 1, iSetPointAir_min, iSetPointAir_max)
						g_iaSetPointAir[in_iEibPanel] = l_iSetPoint
						
			    case CONTROL_FLOOR: l_iSetPoint = fnReturn_SetPoint_byParam(g_iaSetPointFloor[in_iEibPanel] + 1, iSetPointFloor_min, iSetPointFloor_max)
						g_iaSetPointFloor[in_iEibPanel] = l_iSetPoint
						
			    case CONTROL_AC: 	l_iSetPoint = fnReturn_SetPoint_byParam(g_iaSetPointAC[in_iEibPanel] + 1, iSetPointAC_min, iSetPointAC_max)
						g_iaSetPointAC[in_iEibPanel] = l_iSetPoint						
			}
			
			//g_iaSetPoint[in_iEibPanel] = l_iSetPoint
			//EIBPanel[in_iEibPanel].m_caSetPoint = itoa(l_iSetPoint)
			
			fnSendSetPointToEibPanel(in_iEibPanel)
		    break
		    }
	    case 2: { // Set -
			switch(l_iCurrentControl)
			{
			    case CONTROL_AIR: 	l_iSetPoint = fnReturn_SetPoint_byParam(g_iaSetPointAir[in_iEibPanel] - 1, iSetPointAir_min, iSetPointAir_max)
						g_iaSetPointAir[in_iEibPanel] = l_iSetPoint
						
			    case CONTROL_FLOOR: l_iSetPoint = fnReturn_SetPoint_byParam(g_iaSetPointFloor[in_iEibPanel] - 1, iSetPointFloor_min, iSetPointFloor_max)
						g_iaSetPointFloor[in_iEibPanel] = l_iSetPoint
						
			    case CONTROL_AC: 	l_iSetPoint = fnReturn_SetPoint_byParam(g_iaSetPointAC[in_iEibPanel] - 1, iSetPointAC_min, iSetPointAC_max)
						g_iaSetPointAC[in_iEibPanel] = l_iSetPoint						
			}
			
			//g_iaSetPoint[in_iEibPanel] = l_iSetPoint
			//EIBPanel[in_iEibPanel].m_caSetPoint = itoa(l_iSetPoint)
			
			fnSendSetPointToEibPanel(in_iEibPanel)
		    break
		    }
	    case 3:
	    case 4:
	    case 6: { // AC control
			/*
			if(EIBPanel[in_iEibPanel].m_iTypeOfPanel == PANEL_TYPE_FULL || EIBPanel[in_iEibPanel].m_iTypeOfPanel == PANEL_TYPE_AIR_AC)
			    fnEibPanelAC_Control(in_iEibPanel)
			*/
		    break
		    }
	    case 5: { // mode
			/*
			if(EIBPanel[in_iEibPanel].m_iCurrentControl == CONTROL_AC) {
			    
			    if(EIBPanel[in_iEibPanel].m_iMode == MODE_AIR)
				EIBSet(vdvEIB, 2700 + in_iEibPanel, 128 + 8)
			    if(EIBPanel[in_iEibPanel].m_iMode == MODE_FLOOR)
				EIBSet(vdvEIB, 2700 + in_iEibPanel, 128 + 8 + 32)
				
			    wait 30
			    {
				if(EIBPanel[in_iEibPanel].m_iMode == MODE_AIR)
				    EIBSet(vdvEIB, 2700 + in_iEibPanel, 8)
				if(EIBPanel[in_iEibPanel].m_iMode == MODE_FLOOR)
				    EIBSet(vdvEIB, 2700 + in_iEibPanel, 8 + 32)
			    }
			} else {
			    if(l_iTypeOfPanel == PANEL_TYPE_FULL || l_iTypeOfPanel == PANEL_TYPE_FLOOR_AIR) {
				EIBPanel[in_iEibPanel].m_iMode = EIBPanel[in_iEibPanel].m_iMode ^ 1
				EIBPanel[in_iEibPanel].m_iCurrentControl = EIBPanel[in_iEibPanel].m_iMode
			    } else {
				EIBPanel[in_iEibPanel].m_iCurrentControl = EIBPanel[in_iEibPanel].m_iMode
			    }
			    
			    fnSendSetPointToEibPanel(in_iEibPanel)
			    fnEibPanelSetMode(in_iEibPanel)
			}
			*/
			//fnEibPanelSetMode(in_iEibPanel)
		    break
		    }
	}
    }
}

define_function fnEibPanelAC_Control(integer in_iEibPanel)
{
    stack_var 
    integer l_iBtn
    integer l_iPushState
    integer l_iAC_State
    
    l_iBtn 		= EIBPanel[in_iEibPanel].m_iBtn
    l_iPushState 	= EIBPanel[in_iEibPanel].m_iPushState
    l_iAC_State 	= EIBPanel[in_iEibPanel].m_iAC_State

    if(l_iPushState)
    {
	switch(l_iBtn)
	{
	    case 3: { // AC on/off
			EIBPanel[in_iEibPanel].m_iAC_State = EIBPanel[in_iEibPanel].m_iAC_State ^ 1
			
			fnEibPanelACInit(in_iEibPanel)
			
			//send to lon AC status
		    }
	    case 4: { // auto
			if(l_iAC_State) {
			    EIBPanel[in_iEibPanel].m_iFanSpeed = 0
			    EIBPanel[in_iEibPanel].m_iAuto = 1
			}
			
			fnEibPanelACInit(in_iEibPanel)
			
			//send to lon auto
		    }
	    case 6: { // fan speed
			if(l_iAC_State) {
			    if(EIBPanel[in_iEibPanel].m_iAuto) {
				EIBPanel[in_iEibPanel].m_iFanSpeed = 8
				EIBPanel[in_iEibPanel].m_iAuto = 0
			    } else {
				if(EIBPanel[in_iEibPanel].m_iFanSpeed > 4)
				    EIBPanel[in_iEibPanel].m_iFanSpeed = 4
				else
				    EIBPanel[in_iEibPanel].m_iFanSpeed = 8
			    }
			}
			
			fnEibPanelACInit(in_iEibPanel)
			
			//send to lon fan speed
		    }
	}
	
    }
}

define_function fnEibPanelACInit(integer in_iEibPanel)
{
    stack_var 
    integer l_iAC_State
    integer l_iMode
    integer l_iFanSpeed
    integer l_iAuto
    
    l_iAC_State 	= EIBPanel[in_iEibPanel].m_iAC_State
    l_iMode 		= EIBPanel[in_iEibPanel].m_iMode
    l_iFanSpeed		= EIBPanel[in_iEibPanel].m_iFanSpeed
    l_iAuto		= EIBPanel[in_iEibPanel].m_iAuto
    
    //
    //при работе с панелями iPad сделать чтоб панель не переключалась на кондей
    //
    if(l_iAC_State)
	EIBPanel[in_iEibPanel].m_iCurrentControl = CONTROL_AC
    else
	EIBPanel[in_iEibPanel].m_iCurrentControl = l_iMode
    
    EIBSet(vdvEIB, 1700 + in_iEibPanel, l_iAC_State) //blue led activity
    
    if(l_iAC_State && l_iFanSpeed > 0) {
	EIBSet(vdvEIB, 1900 + in_iEibPanel, 1) //red2 led
	EIBSet(vdvEIB, 2800 + in_iEibPanel, l_iFanSpeed) //fan speed
    }
    if(l_iAC_State && l_iFanSpeed == 0) {
	EIBSet(vdvEIB, 1900 + in_iEibPanel, 0) //red 2 led
	EIBSet(vdvEIB, 2800 + in_iEibPanel, 0) //fan speed
    }
    if(l_iAC_State == 0) {
	EIBSet(vdvEIB, 1900 + in_iEibPanel, 0)
	EIBSet(vdvEIB, 2800 + in_iEibPanel, 0)
    }
    
    fnSendSetPointToEibPanel(in_iEibPanel)
    fnEibPanelSetMode(in_iEibPanel)
}

//установка режима работы контура 0 - поддержание температуры ТП, 1 - поддерж темп воздуха
define_function fnPermitCascade(integer in_iEibPanel)
{
    stack_var 
    integer l_iMode
    
    l_iMode = EIBPanel[in_iEibPanel].m_iMode
    /*
    switch(in_iEibPanel)
    {
	case 01: send_command vdvXenta, "'STATE=1:3:13:', itoa(l_iMode)" //main hall
	case 07: send_command vdvXenta, "'STATE=1:3:9:', itoa(l_iMode)" //dining
	case 08: send_command vdvXenta, "'STATE=1:3:10:', itoa(l_iMode)" // Kitchen
	case 11: send_command vdvXenta, "'STATE=1:3:8:', itoa(l_iMode)" //Salon
	case 13: send_command vdvXenta, "'STATE=1:3:2:', itoa(l_iMode)" //
	case 14: send_command vdvXenta, "'STATE=1:3:4:', itoa(l_iMode)" //
	//case 16: send_command vdvXenta, "'STATE=1:3:7:', itoa(l_iMode)" //
	//case 18: send_command vdvXenta, "'STATE=1:3:6:', itoa(l_iMode)" //
	case 20: send_command vdvXenta, "'STATE=1:3:5:', itoa(l_iMode)" //
	case 24: send_command vdvXenta, "'STATE=1:3:12:', itoa(l_iMode)" //
	case 28: send_command vdvXenta, "'STATE=1:3:11:', itoa(l_iMode)" //
	//case : send_command vdvXenta, "'STATE=1:3:13:', itoa(l_iMode)" //
    }
    */
}


//разрешение на работу отопления 0 - отопление выключено, 1 - отопление включено
define_function fnPermitARM(integer in_iValue)
{
/*
    for(i = 1; i <= 15; i++) {
	if(i <= 14)
	    send_command vdvXenta, "'STATE=1:1:', itoa(i),':', itoa(in_iValue)"
	
	send_command vdvXenta, "'STATE=1:2:', itoa(i),':', itoa(in_iValue) "
    }
    */
}
//установка режимов работы панели в зависимости от режима работы и типа панели
define_function fnEibPanelSetMode(integer in_iEibPanel)
{
    stack_var 
    integer l_iAC_State
    integer l_iMode
    integer l_iPanelType
    integer l_iCurrentControl
    
    l_iPanelType 	= EIBPanel[in_iEibPanel].m_iTypeOfPanel

    if(l_iPanelType == PANEL_TYPE_AIR) {
	EIBPanel[in_iEibPanel].m_iCurrentControl = CONTROL_AIR
	EIBPanel[in_iEibPanel].m_iMode = CONTROL_AIR
    }

    l_iCurrentControl 	= EIBPanel[in_iEibPanel].m_iCurrentControl    
    l_iAC_State 	= EIBPanel[in_iEibPanel].m_iAC_State
    l_iMode 		= EIBPanel[in_iEibPanel].m_iMode
    
    switch(l_iCurrentControl)
    {
	//управление по воздуху с панели в данный момент
	case CONTROL_AIR:
	{
	    fnPermitCascade(in_iEibPanel)
	    
	    switch(l_iPanelType)
	    {
		case PANEL_TYPE_FULL:
		case PANEL_TYPE_AIR_AC:
		{
		    if(l_iAC_State) //AC On
			EIBSet(vdvEIB, 2700 + in_iEibPanel, 8)
		    else //AC Off
			EIBSet(vdvEIB, 2700 + in_iEibPanel, 4)
		}
		case PANEL_TYPE_AIR:
		case PANEL_TYPE_FLOOR_AIR:
		{
		    EIBSet(vdvEIB, 2700 + in_iEibPanel, 0)
		}
	    }
	}
	//управление по теплому полу в данный момент
	case CONTROL_FLOOR:
	{
	    fnPermitCascade(in_iEibPanel)
	    
	    switch(l_iPanelType)
	    {
		case PANEL_TYPE_FULL:
		{
		    if(l_iAC_State) //AC On
			EIBSet(vdvEIB, 2700 + in_iEibPanel, 32 + 8)
		    else //AC Off
			EIBSet(vdvEIB, 2700 + in_iEibPanel, 32 + 4)
		}
		case PANEL_TYPE_FLOOR_AIR:
		{
		    EIBSet(vdvEIB, 2700 + in_iEibPanel, 32)
		}
	    }
	}
	//управление кондиционером в данный момент
	case CONTROL_AC:
	{
	    switch(l_iPanelType)
	    {
		case PANEL_TYPE_FULL:
		{
		    switch(l_iMode)
		    {
			case MODE_FLOOR: { //Mode Warm Floor
				    if(l_iAC_State) //AC On
					EIBSet(vdvEIB, 2700 + in_iEibPanel, 32 + 8)
				    else //AC Off
					EIBSet(vdvEIB, 2700 + in_iEibPanel, 32 + 4)
				}
			case MODE_AIR: { //Mode Air Heating
				    if(l_iAC_State) //AC On
					EIBSet(vdvEIB, 2700 + in_iEibPanel, 8)
				    else //AC Off
					EIBSet(vdvEIB, 2700 + in_iEibPanel, 4)
				}
		    }
		}
		case PANEL_TYPE_AIR_AC:
		{
		    if(l_iAC_State) //AC On
			EIBSet(vdvEIB, 2700 + in_iEibPanel, 8)
		    else //AC Off
			EIBSet(vdvEIB, 2700 + in_iEibPanel, 4)
		}
	    }
	}
    }
}

define_function fnSendSetPointToEibPanel(integer in_iEibPanel)
{
    stack_var 
    integer l_iCurrentControl
    integer l_iSetPoint
    integer l_iMode
    
    l_iCurrentControl = EIBPanel[in_iEibPanel].m_iCurrentControl
    l_iMode = EIBPanel[in_iEibPanel].m_iMode
    
    switch(l_iCurrentControl)
    {
	case CONTROL_AIR:	l_iSetPoint = g_iaSetPointAir[in_iEibPanel]
	case CONTROL_FLOOR:	l_iSetPoint = g_iaSetPointFloor[in_iEibPanel]
	case CONTROL_AC:	l_iSetPoint = g_iaSetPointAC[in_iEibPanel]
    }
    
    //if(l_iCurrentControl = CONTROL_FLOOR)
	//EIS5Set(vdvEIB, 2000 + in_iEibPanel, 0) //send setpoint tempp
    //else
    EIS5Set(vdvEIB, 2000 + in_iEibPanel, l_iSetPoint) //send setpoint tempp
    
    //send to LON
    if(l_iMode == MODE_AIR){	
	send_command vdvXenta, "'SET_HR 1,',itoa(g_iaXentaSetPointZones[in_iEibPanel]),',', itoa(g_iaSetPointAir[in_iEibPanel]*10),';'"
    } else
    if(l_iMode == MODE_FLOOR){	
	send_command vdvXenta, "'SET_HR 1,',itoa(g_iaXentaSetPointZones[in_iEibPanel]),',', itoa(g_iaSetPointFloor[in_iEibPanel]*10),';'"
    }
    //Send to TP
}

define_function fnEibPanelOnInit(integer in_iEibPanel)
{
    stack_var integer l_iPanelType
    
    l_iPanelType = EIBPanel[in_iEibPanel].m_iTypeOfPanel
    
    EIBSet(vdvEIB, 2500 + in_iEibPanel, 240) // init panel for icons
    //fnSendSetPointToEibPanel(in_iEibPanel)
    //fnEibPanelSetMode(in_iEibPanel) //init mode
    fnEibPanelACInit(in_iEibPanel) //init AC mode
    /*
    switch(l_iPanelType)
    {
	case PANEL_TYPE_NONE: {
				    
			    }
	case PANEL_TYPE_FULL: {
			    }
	case PANEL_TYPE_FLOOR_AIR: {
				    EIBSet(vdvEIB, 2500 + in_iEibPanel, 240) // init panel for icons
			    }
	case PANEL_TYPE_AIR: {
				    EIBSet(vdvEIB, 2500 + in_iEibPanel, 240) // init panel for icons
			    }
	case PANEL_TYPE_AIR_AC: {
				    EIBSet(vdvEIB, 2500 + in_iEibPanel, 240) // init panel for icons
			    }
    }
    */
    
}

//Init all panels
define_function fnOnInit()
{
    for(i = 1; i <= 30; i++) {
	wait 1 'onInit'
	if(i != 10) { fnEibPanelOnInit(i) }
    }
}

define_function fnXentaSetMode()
{
    //
}
(***********************************************************)
(*                STARTUP CODE GOES BELOW                  *)
(***********************************************************)
DEFINE_START

// кондиционеры
AirCond[01].m_caName 	= 'Fitness'
AirCond[01].nviTempp 	= '02'
AirCond[01].nvoSetPoint = '01'
AirCond[01].nvoFanSpeed = '01'
AirCond[01].nvoOnOff 	= '02'
AirCond[01].nvoHVAC 	= '01'

AirCond[02].m_caName 	= 'Oriental Relax'
AirCond[02].nviTempp 	= '04'
AirCond[02].nvoSetPoint = '02'
AirCond[02].nvoFanSpeed = '03'
AirCond[02].nvoOnOff 	= '04'
AirCond[02].nvoHVAC 	= '02'

AirCond[03].m_caName 	= 'Salon'
AirCond[03].nviTempp 	= '06'
AirCond[03].nvoSetPoint = '03'
AirCond[03].nvoFanSpeed = '05'
AirCond[03].nvoOnOff 	= '06'
AirCond[03].nvoHVAC 	= '03'//ok

AirCond[04].m_caName 	= 'Dining'
AirCond[04].nviTempp 	= '02'
AirCond[04].nvoSetPoint = '06'
AirCond[04].nvoFanSpeed = '01'
AirCond[04].nvoOnOff 	= '02'
AirCond[04].nvoHVAC 	= '02'

AirCond[05].m_caName 	= 'Cinema'
AirCond[05].nviTempp 	= '02'
AirCond[05].nvoSetPoint = '07'
AirCond[05].nvoFanSpeed = '01'
AirCond[05].nvoOnOff 	= '02'
AirCond[05].nvoHVAC 	= '02'

AirCond[06].m_caName 	= 'Office'
AirCond[06].nviTempp 	= '02'
AirCond[06].nvoSetPoint = '08'
AirCond[06].nvoFanSpeed = '01'
AirCond[06].nvoOnOff 	= '02'
AirCond[06].nvoHVAC 	= '02'

AirCond[07].m_caName 	= 'Server Floor'
AirCond[07].nviTempp 	= '02'
AirCond[07].nvoSetPoint = '09'
AirCond[07].nvoFanSpeed = '01'
AirCond[07].nvoOnOff 	= '02'
AirCond[07].nvoHVAC 	= '02'

AirCond[08].m_caName 	= 'Server Wall'
AirCond[08].nviTempp 	= '02'
AirCond[08].nvoSetPoint = '10'
AirCond[08].nvoFanSpeed = '01'
AirCond[08].nvoOnOff 	= '02'
AirCond[08].nvoHVAC 	= '02'

AirCond[09].m_caName 	= 'Master Bedroom'
AirCond[09].nviTempp 	= '02'
AirCond[09].nvoSetPoint = '11'
AirCond[09].nvoFanSpeed = '01'
AirCond[09].nvoOnOff 	= '02'
AirCond[09].nvoHVAC 	= '02'

AirCond[10].m_caName 	= 'Hall'
AirCond[10].nviTempp 	= '02'
AirCond[10].nvoSetPoint = '12'
AirCond[10].nvoFanSpeed = '01'
AirCond[10].nvoOnOff 	= '02'
AirCond[10].nvoHVAC 	= '02'

AirCond[11].m_caName 	= 'Robik'
AirCond[11].nviTempp 	= '02'
AirCond[11].nvoSetPoint = '13'
AirCond[11].nvoFanSpeed = '01'
AirCond[11].nvoOnOff 	= '02'
AirCond[11].nvoHVAC 	= '02'

AirCond[12].m_caName 	= 'Playroom'
AirCond[12].nviTempp 	= '02'
AirCond[12].nvoSetPoint = '14'
AirCond[12].nvoFanSpeed = '01'
AirCond[12].nvoOnOff 	= '02'
AirCond[12].nvoHVAC 	= '02'

AirCond[13].m_caName 	= 'Anna Living'
AirCond[13].nviTempp 	= '02'
AirCond[13].nvoSetPoint = '15'
AirCond[13].nvoFanSpeed = '01'
AirCond[13].nvoOnOff 	= '02'
AirCond[13].nvoHVAC 	= '02'

AirCond[14].m_caName 	= 'Anna Bedroom'
AirCond[14].nviTempp 	= '02'
AirCond[14].nvoSetPoint = '16'
AirCond[14].nvoFanSpeed = '01'
AirCond[14].nvoOnOff 	= '02'
AirCond[14].nvoHVAC 	= '02'

AirCond[15].m_caName 	= 'Guest Left'
AirCond[15].nviTempp 	= '02'
AirCond[15].nvoSetPoint = '17'
AirCond[15].nvoFanSpeed = '01'
AirCond[15].nvoOnOff 	= '02'
AirCond[15].nvoHVAC 	= '02'

AirCond[16].m_caName 	= 'Guest Right'
AirCond[16].nviTempp 	= '02'
AirCond[16].nvoSetPoint = '18'
AirCond[16].nvoFanSpeed = '01'
AirCond[16].nvoOnOff 	= '02'
AirCond[16].nvoHVAC 	= '02'

//
EIBPanel[01].m_iTypeOfPanel = PANEL_TYPE_AIR //Panel 1 Main Hall
//EIBPanel[02].m_iTypeOfPanel = PANEL_TYPE_FULL //panel 2 Main Hall
EIBPanel[03].m_iTypeOfPanel = PANEL_TYPE_AIR //Wardrobe Right
EIBPanel[04].m_iTypeOfPanel = PANEL_TYPE_AIR //Wardrobe Left
EIBPanel[05].m_iTypeOfPanel = PANEL_TYPE_AIR //Cabinet
EIBPanel[06].m_iTypeOfPanel = PANEL_TYPE_AIR //Cinema
EIBPanel[07].m_iTypeOfPanel = PANEL_TYPE_AIR //Dining
EIBPanel[08].m_iTypeOfPanel = PANEL_TYPE_AIR //Kitchen
EIBPanel[09].m_iTypeOfPanel = PANEL_TYPE_AIR //Sport
//EIBPanel[10].m_iTypeOfPanel = 
EIBPanel[11].m_iTypeOfPanel = PANEL_TYPE_AIR //panel 1 salon
//EIBPanel[12].m_iTypeOfPanel = PANEL_TYPE_FULL //panel 2 salon
EIBPanel[13].m_iTypeOfPanel = PANEL_TYPE_AIR //Razdevalka Dush
EIBPanel[14].m_iTypeOfPanel = PANEL_TYPE_AIR //Sigar
EIBPanel[15].m_iTypeOfPanel = PANEL_TYPE_NONE //pool
EIBPanel[16].m_iTypeOfPanel = PANEL_TYPE_AIR //Guest Bath Right
EIBPanel[17].m_iTypeOfPanel = PANEL_TYPE_AIR //Guest Right
EIBPanel[18].m_iTypeOfPanel = PANEL_TYPE_AIR //Guest Bath Left
EIBPanel[19].m_iTypeOfPanel = PANEL_TYPE_AIR //Guest Left
EIBPanel[20].m_iTypeOfPanel = PANEL_TYPE_AIR //Anna Bath
EIBPanel[21].m_iTypeOfPanel = PANEL_TYPE_AIR //Anna Bed
EIBPanel[22].m_iTypeOfPanel = PANEL_TYPE_AIR //Anna Living
EIBPanel[23].m_iTypeOfPanel = PANEL_TYPE_AIR //Playroom
EIBPanel[24].m_iTypeOfPanel = PANEL_TYPE_AIR //Robobath
EIBPanel[25].m_iTypeOfPanel = PANEL_TYPE_AIR //Robobed
EIBPanel[26].m_iTypeOfPanel = PANEL_TYPE_AIR //Wardrobe Skigin
EIBPanel[27].m_iTypeOfPanel = PANEL_TYPE_AIR //Wardobe Olga
EIBPanel[28].m_iTypeOfPanel = PANEL_TYPE_AIR //Skigin Bath
EIBPanel[29].m_iTypeOfPanel = PANEL_TYPE_AIR //Skigin Bed
EIBPanel[30].m_iTypeOfPanel = PANEL_TYPE_AIR //hall 2nd floor

for(i = 1; i <= 30; i++) {
    if(g_iaSetPointFloor[i] == 0) {
	g_iaSetPointFloor[i] = 26
	EIBPanel[i].m_caSetPointFloor = itoa(g_iaSetPointFloor[i])
    }
    if(g_iaSetPointAir[i] == 0) {
	g_iaSetPointAir[i] = 24
	EIBPanel[i].m_caSetPointAir = itoa(g_iaSetPointAir[i])
    }
    if(g_iaSetPointAC[i] == 0) {
	g_iaSetPointAC[i] = 20
	EIBPanel[i].m_caSetPointAC = itoa(g_iaSetPointAC[i])
    }
}

nCounter = 0

wait_until ([vdvEIB, 3001])	{ nCounter = 1 }

//timeline init
//timeline_create()

//wait 600 'Xenta_SetMode' { fnXentaSetMode() }

//wait 600 'permit_arm' { fnPermitARM(1)}

wait 1200 'eib_panel_init' { fnOnInit() }

wait 1500 'eib_set_mode' {
    for(i = 1; i <= 30; i++) {
	if(i != 10)
	    fnEibPanelSetMode(i)
    }
    timeline_create(TL_SetPoint, m_laTL_SetPoint, 1, timeline_absolute, timeline_repeat)
}
SEND_COMMAND vdvXenta, 'START;'

DEFINE_MODULE 'CTEIB7_mod' 	EIB7( vdvEIB, dvEIB, lEIB_Value)
DEFINE_MODULE 'Modbus_TCP'	ModBus(vdvXenta, dvXenta, m_caShnider_IP)
/*
DEFINE_MODULE 'CT_LON1_UI1_mod'LON_Xenta (vdvXenta,             // Virtuell
                                    dvXenta,              // Hardware
                                    fLON_SWITCH_RM_Xenta,
                                    nLON_STATE_RM_Xenta,
                                    fLON_SETTING_RM_Xenta,
                                    fLON_TEMPP_RM_Xenta,
                                    nLON_PRESET_RM_Xenta,
                                    nLON_COUNT_RM_Xenta,
                                    nLON_TIMESTAMP_RM_Xenta,
                                    nLON_SCENE_RM_Xenta,
                                    nLON_OCCUP_RM_Xenta,
				    nLON_HVACMODE_RM_Xenta,
                                    nGW_PROTOKOLL)      // Protokolltype

DEFINE_MODULE 'CT_LON1_UI1_mod'LON_Daikin (vdvDaikin,             // Virtuell
                                    dvDaikin,              // Hardware
                                    fLON_SWITCH_RM_Daikin,
                                    nLON_STATE_RM_Daikin,
                                    fLON_SETTING_RM_Daikin,
                                    fLON_TEMPP_RM_Daikin,
                                    nLON_PRESET_RM_Daikin,
                                    nLON_COUNT_RM_Daikin,
                                    nLON_TIMESTAMP_RM_Daikin,
                                    nLON_SCENE_RM_Daikin,
                                    nLON_OCCUP_RM_Daikin,
				    nLON_HVACMODE_RM_Daikin,
                                    nGW_PROTOKOLL)      // Protokolltype
*/

(***********************************************************)
(*                THE EVENTS GO BELOW                      *)
(***********************************************************)
DEFINE_EVENT

timeline_event[TL_SetPoint]
{
    stack_var integer l_iTl, ii, l_iSetPoint, l_iMode
    stack_var char mode[255], setP[255], temppX[255], temppE[255]
    
    for(l_iTl = 1; l_iTl <= 30; l_iTl++) {
	if(l_iTl != 10 && l_iTl != 2 && l_iTl != 12) {
	    fnSendSetPointToEibPanel(l_iTl)
	    fnEibPanelSetMode(l_iTl)
	}
    }
    
    //уставка в постирочной
    send_command vdvXenta, "'SET_HR 1,15,300;'"
    //уставка в массажной
    send_command vdvXenta, "'SET_HR 1,3,210;'"
    
    mode = '|'
    setP = '|'
    temppX = '|'
    temppE = '|'
    
    for(ii = 1; ii <= 30; ii++) {
	
	l_iMode = EIBPanel[ii].m_iMode
	
	if(l_iMode == MODE_AIR)   l_iSetPoint = g_iaSetPointAir[ii]
	if(l_iMode == MODE_FLOOR) l_iSetPoint = g_iaSetPointFloor[ii]
	
	
	mode 	= "mode, itoa(l_iMode),'|'" 
	setP 	= "setP, itoa(l_iSetPoint),'|'" 
	//temppX 	= "temppX, ftoa(strTemppValues_Xenta[ii].fVALUE),'|'" 
	temppE 	= "temppE, format('%3.1f', atof(EIBPanel[ii].m_caTempp)),'|'" 
	
    }
    
    send_string 0, '------------------------------------------------------------'
    send_string 0, "'SYSTEM DATE - ', DATE"
    //вывод информаци об уставках
    send_string 0, "'          SET_POINTS >> ', setP"
    //режим работы панели
    send_string 0, "'MODE Floor=0 ? Air=1 >> ', mode"
    //вывод информации температур с Ксенты по контурам
    send_string 0, "'    TEMPP from Xenta >> ', temppX"
    //температура с рум-контроллеров
    send_string 0, "'TEMPP from EIB Panel >> ', temppE"
    send_string 0, '------------------------------------------------------------'

}

DATA_EVENT[vdvEIB]
{
    online:	{ SEND_COMMAND vdvEIB,'IP=10.98.253.59' }
    string:
    {
	stack_var l_caData[100]
	
	l_caData = data.text
	
	fnEibOnReceive(l_caData)
    }
}

data_event[g_dvaHVAC_Panels]
{
    online:
    {
	//SEND_COMMAND g_dvaHVAC_Panels,"'^TXT-10,0,', g_caTempp, $B0,'C'"
    }
}

(***********************************************************)
(*            THE ACTUAL PROGRAM GOES BELOW                *)
(***********************************************************)
DEFINE_PROGRAM


wait 2 'eib_init_startup' {
    if(nCounter) {
	switch(nCounter)
	{
	    //kitchen panel 8/1/..
	    case 01: EIBAdd(vdvEIB, 1108, eibSWITCH,	'8/1/1', "") // set +
	    case 02: EIBAdd(vdvEIB, 1208, eibSWITCH,	'8/1/2', "") // set -
	    case 03: EIBAdd(vdvEIB, 1308, eibSWITCH,	'8/1/3', "") // AC on/off
	    case 04: EIBAdd(vdvEIB, 1408, eibSWITCH,	'8/1/4', "") // auto/manual
	    case 05: EIBAdd(vdvEIB, 1508, eibSWITCH,	'8/1/5', "") // fan 1
	    case 06: EIBAdd(vdvEIB, 1608, eibSWITCH,	'8/1/6', "") // fan 2
	    case 07: EIBAdd(vdvEIB, 1708, eibSWITCH,	'8/1/10', "") // blue led 
	    case 08: EIBAdd(vdvEIB, 1808, eibSWITCH,	'8/1/11', "") // red 1
	    case 09: EIBAdd(vdvEIB, 1908, eibSWITCH,	'8/1/12', "") // red 2
	    case 10: EIBAdd(vdvEIB, 2008, eib2BYTE,	'8/1/20', "eibEIS5") // set_point to EIB
	    case 11: EIBAdd(vdvEIB, 2108, eib2BYTE,	'8/1/21', "eibEIS5, ',', eibPollStart") // temp from EIP panel
	    case 12: EIBAdd(vdvEIB, 2508, eib1BYTE,	'8/1/25', "") //init air icon
	    case 13: EIBAdd(vdvEIB, 2608, eib1BYTE,	'8/1/26', "") //init warm floor icon
	    case 14: EIBAdd(vdvEIB, 2708, eib1BYTE,	'8/1/27', "") //mode
	    case 15: EIBAdd(vdvEIB, 2808, eib1BYTE,	'8/1/28', "") //fan speed
	    //Dining Panel 7/1/..
	    case 16: EIBAdd(vdvEIB, 1107, eibSWITCH,	'7/1/1', "") // set +
	    case 17: EIBAdd(vdvEIB, 1207, eibSWITCH,	'7/1/2', "") // set -
	    case 18: EIBAdd(vdvEIB, 1307, eibSWITCH,	'7/1/3', "") // AC on/off
	    case 19: EIBAdd(vdvEIB, 1407, eibSWITCH,	'7/1/4', "") // auto/manual
	    case 20: EIBAdd(vdvEIB, 1507, eibSWITCH,	'7/1/5', "") // fan 1
	    case 21: EIBAdd(vdvEIB, 1607, eibSWITCH,	'7/1/6', "") // fan 2
	    case 22: EIBAdd(vdvEIB, 1707, eibSWITCH,	'7/1/10', "") // blue led 
	    case 23: EIBAdd(vdvEIB, 1807, eibSWITCH,	'7/1/11', "") // red 1
	    case 24: EIBAdd(vdvEIB, 1907, eibSWITCH,	'7/1/12', "") // red 2
	    case 25: EIBAdd(vdvEIB, 2007, eib2BYTE,	'7/1/20', "eibEIS5") // set_point to EIB
	    case 26: EIBAdd(vdvEIB, 2107, eib2BYTE,	'7/1/21', "eibEIS5, ',', eibPollStart") // temp from EIP panel
	    case 27: EIBAdd(vdvEIB, 2507, eib1BYTE,	'7/1/25', "") //init air icon
	    case 28: EIBAdd(vdvEIB, 2607, eib1BYTE,	'7/1/26', "") //init warm floor icon
	    case 29: EIBAdd(vdvEIB, 2707, eib1BYTE,	'7/1/27', "") //mode
	    case 30: EIBAdd(vdvEIB, 2807, eib1BYTE,	'7/1/28', "") //fan speed
	    //Cinema     6/1/..          
	    case 31: EIBAdd(vdvEIB, 1106, eibSWITCH,	'6/1/1', "") // set +
	    case 32: EIBAdd(vdvEIB, 1206, eibSWITCH,	'6/1/2', "") // set -
	    case 33: EIBAdd(vdvEIB, 1306, eibSWITCH,	'6/1/3', "") // AC on/off
	    case 34: EIBAdd(vdvEIB, 1406, eibSWITCH,	'6/1/4', "") // auto/manual
	    case 35: EIBAdd(vdvEIB, 1506, eibSWITCH,	'6/1/5', "") // fan 1
	    case 36: EIBAdd(vdvEIB, 1606, eibSWITCH,	'6/1/6', "") // fan 2
	    case 37: EIBAdd(vdvEIB, 1706, eibSWITCH,	'6/1/10', "") // blue led 
	    case 38: EIBAdd(vdvEIB, 1806, eibSWITCH,	'6/1/11', "") // red 1
	    case 39: EIBAdd(vdvEIB, 1906, eibSWITCH,	'6/1/12', "") // red 2
	    case 40: EIBAdd(vdvEIB, 2006, eib2BYTE,	'6/1/20', "eibEIS5") // set_point to EIB
	    case 41: EIBAdd(vdvEIB, 2106, eib2BYTE,	'6/1/21', "eibEIS5, ',', eibPollStart") // temp from EIP panel
	    case 42: EIBAdd(vdvEIB, 2506, eib1BYTE,	'6/1/25', "") //init air icon
	    case 43: EIBAdd(vdvEIB, 2606, eib1BYTE,	'6/1/26', "") //init warm floor icon
	    case 44: EIBAdd(vdvEIB, 2706, eib1BYTE,	'6/1/27', "") //mode
	    case 45: EIBAdd(vdvEIB, 2806, eib1BYTE,	'6/1/28', "") //fan speed
	    //Hall 1st floor on Dining Entrance 2/1/..
	    case 46: EIBAdd(vdvEIB, 1102, eibSWITCH,	'2/1/1', "") // set +
	    case 47: EIBAdd(vdvEIB, 1202, eibSWITCH,	'2/1/2', "") // set -
	    case 48: EIBAdd(vdvEIB, 1302, eibSWITCH,	'2/1/3', "") // AC on/off
	    case 49: EIBAdd(vdvEIB, 1402, eibSWITCH,	'2/1/4', "") // auto/manual
	    case 50: EIBAdd(vdvEIB, 1502, eibSWITCH,	'2/1/5', "") // fan 1
	    case 51: EIBAdd(vdvEIB, 1602, eibSWITCH,	'2/1/6', "") // fan 2
	    case 52: EIBAdd(vdvEIB, 1702, eibSWITCH,	'2/1/10', "") // blue led 
	    case 53: EIBAdd(vdvEIB, 1802, eibSWITCH,	'2/1/11', "") // red 1
	    case 54: EIBAdd(vdvEIB, 1902, eibSWITCH,	'2/1/12', "") // red 2
	    case 55: EIBAdd(vdvEIB, 2002, eib2BYTE,	'2/1/20', "eibEIS5") // set_point to EIB
	    case 56: EIBAdd(vdvEIB, 2102, eib2BYTE,	'2/1/21', "eibEIS5, ',', eibPollStart") // temp from EIP panel
	    case 57: EIBAdd(vdvEIB, 2502, eib1BYTE,	'2/1/25', "") //init air icon
	    case 58: EIBAdd(vdvEIB, 2602, eib1BYTE,	'2/1/26', "") //init warm floor icon
	    case 59: EIBAdd(vdvEIB, 2702, eib1BYTE,	'2/1/27', "") //mode
	    case 60: EIBAdd(vdvEIB, 2802, eib1BYTE,	'2/1/28', "") //fan speed
	    //Гардероб при входе Правый     3/1/..          
	    case 61: EIBAdd(vdvEIB, 1103, eibSWITCH,	'3/1/1', "") // set +
	    case 62: EIBAdd(vdvEIB, 1203, eibSWITCH,	'3/1/2', "") // set -
	    case 63: EIBAdd(vdvEIB, 1303, eibSWITCH,	'3/1/3', "") // AC on/off
	    case 64: EIBAdd(vdvEIB, 1403, eibSWITCH,	'3/1/4', "") // auto/manual
	    case 65: EIBAdd(vdvEIB, 1503, eibSWITCH,	'3/1/5', "") // fan 1
	    case 66: EIBAdd(vdvEIB, 1603, eibSWITCH,	'3/1/6', "") // fan 2
	    case 67: EIBAdd(vdvEIB, 1703, eibSWITCH,	'3/1/10', "") // blue led 
	    case 68: EIBAdd(vdvEIB, 1803, eibSWITCH,	'3/1/11', "") // red 1
	    case 69: EIBAdd(vdvEIB, 1903, eibSWITCH,	'3/1/12', "") // red 2
	    case 70: EIBAdd(vdvEIB, 2003, eib2BYTE,	'3/1/20', "eibEIS5") // set_point to EIB
	    case 71: EIBAdd(vdvEIB, 2103, eib2BYTE,	'3/1/21', "eibEIS5, ',', eibPollStart") // temp from EIP panel
	    case 72: EIBAdd(vdvEIB, 2503, eib1BYTE,	'3/1/25', "") //init air icon
	    case 73: EIBAdd(vdvEIB, 2603, eib1BYTE,	'3/1/26', "") //init warm floor icon
	    case 74: EIBAdd(vdvEIB, 2703, eib1BYTE,	'3/1/27', "") //mode
	    case 75: EIBAdd(vdvEIB, 2803, eib1BYTE,	'3/1/28', "") //fan speed
	    //Гардероб при входе Левый 4/1/..
	    case 76: EIBAdd(vdvEIB, 1104, eibSWITCH,	'4/1/1', "") // set +
	    case 77: EIBAdd(vdvEIB, 1204, eibSWITCH,	'4/1/2', "") // set -
	    case 78: EIBAdd(vdvEIB, 1304, eibSWITCH,	'4/1/3', "") // AC on/off
	    case 79: EIBAdd(vdvEIB, 1404, eibSWITCH,	'4/1/4', "") // auto/manual
	    case 80: EIBAdd(vdvEIB, 1504, eibSWITCH,	'4/1/5', "") // fan 1
	    case 81: EIBAdd(vdvEIB, 1604, eibSWITCH,	'4/1/6', "") // fan 2
	    case 82: EIBAdd(vdvEIB, 1704, eibSWITCH,	'4/1/10', "") // blue led 
	    case 83: EIBAdd(vdvEIB, 1804, eibSWITCH,	'4/1/11', "") // red 1
	    case 84: EIBAdd(vdvEIB, 1904, eibSWITCH,	'4/1/12', "") // red 2
	    case 85: EIBAdd(vdvEIB, 2004, eib2BYTE,	'4/1/20', "eibEIS5") // set_point to EIB
	    case 86: EIBAdd(vdvEIB, 2104, eib2BYTE,	'4/1/21', "eibEIS5, ',', eibPollStart") // temp from EIP panel
	    case 87: EIBAdd(vdvEIB, 2504, eib1BYTE,	'4/1/25', "") //init air icon
	    case 88: EIBAdd(vdvEIB, 2604, eib1BYTE,	'4/1/26', "") //init warm floor icon
	    case 89: EIBAdd(vdvEIB, 2704, eib1BYTE,	'4/1/27', "") //mode
	    case 90: EIBAdd(vdvEIB, 2804, eib1BYTE,	'4/1/28', "") //fan speed
	    //Cabinet panel 5/1/..  
	    case 101: EIBAdd(vdvEIB, 1105, eibSWITCH,	'5/1/1', "") // set +
	    case 102: EIBAdd(vdvEIB, 1205, eibSWITCH,	'5/1/2', "") // set -
	    case 103: EIBAdd(vdvEIB, 1305, eibSWITCH,	'5/1/3', "") // AC on/off
	    case 104: EIBAdd(vdvEIB, 1405, eibSWITCH,	'5/1/4', "") // auto/manual
	    case 105: EIBAdd(vdvEIB, 1505, eibSWITCH,	'5/1/5', "") // fan 1
	    case 106: EIBAdd(vdvEIB, 1605, eibSWITCH,	'5/1/6', "") // fan 2
	    case 107: EIBAdd(vdvEIB, 1705, eibSWITCH,	'5/1/10', "") // blue led 
	    case 108: EIBAdd(vdvEIB, 1805, eibSWITCH,	'5/1/11', "") // red 1
	    case 109: EIBAdd(vdvEIB, 1905, eibSWITCH,	'5/1/12', "") // red 2
	    case 110: EIBAdd(vdvEIB, 2005, eib2BYTE,	'5/1/20', "eibEIS5") // set_point to EIB
	    case 111: EIBAdd(vdvEIB, 2105, eib2BYTE,	'5/1/21', "eibEIS5, ',', eibPollStart") // temp from EIP panel
	    case 112: EIBAdd(vdvEIB, 2505, eib1BYTE,	'5/1/25', "") //init air icon
	    case 113: EIBAdd(vdvEIB, 2605, eib1BYTE,	'5/1/26', "") //init warm floor icon
	    case 114: EIBAdd(vdvEIB, 2705, eib1BYTE,	'5/1/27', "") //mode
	    case 115: EIBAdd(vdvEIB, 2805, eib1BYTE,	'5/1/28', "") //fan speed
	    //Fitness Panel 9/1/..   
	    case 116: EIBAdd(vdvEIB, 1109, eibSWITCH,	'9/1/1', "") // set +
	    case 117: EIBAdd(vdvEIB, 1209, eibSWITCH,	'9/1/2', "") // set -
	    case 118: EIBAdd(vdvEIB, 1309, eibSWITCH,	'9/1/3', "") // AC on/off
	    case 119: EIBAdd(vdvEIB, 1409, eibSWITCH,	'9/1/4', "") // auto/manual
	    case 120: EIBAdd(vdvEIB, 1509, eibSWITCH,	'9/1/5', "") // fan 1
	    case 121: EIBAdd(vdvEIB, 1609, eibSWITCH,	'9/1/6', "") // fan 2
	    case 122: EIBAdd(vdvEIB, 1709, eibSWITCH,	'9/1/10', "") // blue led 
	    case 123: EIBAdd(vdvEIB, 1809, eibSWITCH,	'9/1/11', "") // red 1
	    case 124: EIBAdd(vdvEIB, 1909, eibSWITCH,	'9/1/12', "") // red 2
	    case 125: EIBAdd(vdvEIB, 2009, eib2BYTE,	'9/1/20', "eibEIS5") // set_point to EIB
	    case 126: EIBAdd(vdvEIB, 2109, eib2BYTE,	'9/1/21', "eibEIS5, ',', eibPollStart") // temp from EIP panel
	    case 127: EIBAdd(vdvEIB, 2509, eib1BYTE,	'9/1/25', "") //init air icon
	    case 128: EIBAdd(vdvEIB, 2609, eib1BYTE,	'9/1/26', "") //init warm floor icon
	    case 129: EIBAdd(vdvEIB, 2709, eib1BYTE,	'9/1/27', "") //mode
	    case 130: EIBAdd(vdvEIB, 2809, eib1BYTE,	'9/1/28', "") //fan speed
	    //Овальная гостиная со стороны столовой     11/1/..          
	    case 131: EIBAdd(vdvEIB, 1111, eibSWITCH,	'11/1/1', "") // set +
	    case 132: EIBAdd(vdvEIB, 1211, eibSWITCH,	'11/1/2', "") // set -
	    case 133: EIBAdd(vdvEIB, 1311, eibSWITCH,	'11/1/3', "") // AC on/off
	    case 134: EIBAdd(vdvEIB, 1411, eibSWITCH,	'11/1/4', "") // auto/manual
	    case 135: EIBAdd(vdvEIB, 1511, eibSWITCH,	'11/1/5', "") // fan 1
	    case 136: EIBAdd(vdvEIB, 1611, eibSWITCH,	'11/1/6', "") // fan 2
	    case 137: EIBAdd(vdvEIB, 1711, eibSWITCH,	'11/1/10', "") // blue led 
	    case 138: EIBAdd(vdvEIB, 1811, eibSWITCH,	'11/1/11', "") // red 1
	    case 139: EIBAdd(vdvEIB, 1911, eibSWITCH,	'11/1/12', "") // red 2
	    case 140: EIBAdd(vdvEIB, 2011, eib2BYTE,	'11/1/20', "eibEIS5") // set_point to EIB
	    case 141: EIBAdd(vdvEIB, 2111, eib2BYTE,	'11/1/21', "eibEIS5, ',', eibPollStart") // temp from EIP panel
	    case 142: EIBAdd(vdvEIB, 2511, eib1BYTE,	'11/1/25', "") //init air icon
	    case 143: EIBAdd(vdvEIB, 2611, eib1BYTE,	'11/1/26', "") //init warm floor icon
	    case 144: EIBAdd(vdvEIB, 2711, eib1BYTE,	'11/1/27', "") //mode
	    case 145: EIBAdd(vdvEIB, 2811, eib1BYTE,	'11/1/28', "") //fan speed
	    //Овальная гостиная со стороны лифта 12/1/..
	    case 146: EIBAdd(vdvEIB, 1112, eibSWITCH,	'12/1/1', "") // set +
	    case 147: EIBAdd(vdvEIB, 1212, eibSWITCH,	'12/1/2', "") // set -
	    case 148: EIBAdd(vdvEIB, 1312, eibSWITCH,	'12/1/3', "") // AC on/off
	    case 149: EIBAdd(vdvEIB, 1412, eibSWITCH,	'12/1/4', "") // auto/manual
	    case 150: EIBAdd(vdvEIB, 1512, eibSWITCH,	'12/1/5', "") // fan 1
	    case 151: EIBAdd(vdvEIB, 1612, eibSWITCH,	'12/1/6', "") // fan 2
	    case 152: EIBAdd(vdvEIB, 1712, eibSWITCH,	'12/1/10', "") // blue led 
	    case 153: EIBAdd(vdvEIB, 1812, eibSWITCH,	'12/1/11', "") // red 1
	    case 154: EIBAdd(vdvEIB, 1912, eibSWITCH,	'12/1/12', "") // red 2
	    case 155: EIBAdd(vdvEIB, 2012, eib2BYTE,	'12/1/20', "eibEIS5") // set_point to EIB
	    case 156: EIBAdd(vdvEIB, 2112, eib2BYTE,	'12/1/21', "eibEIS5, ',', eibPollStart") // temp from EIP panel
	    case 157: EIBAdd(vdvEIB, 2512, eib1BYTE,	'12/1/25', "") //init air icon
	    case 158: EIBAdd(vdvEIB, 2612, eib1BYTE,	'12/1/26', "") //init warm floor icon
	    case 159: EIBAdd(vdvEIB, 2712, eib1BYTE,	'12/1/27', "") //mode
	    case 160: EIBAdd(vdvEIB, 2812, eib1BYTE,	'12/1/28', "") //fan speed
	    //Раздевалка бассейн     13/1/..          
	    case 161: EIBAdd(vdvEIB, 1113, eibSWITCH,	'13/1/1', "") // set +
	    case 162: EIBAdd(vdvEIB, 1213, eibSWITCH,	'13/1/2', "") // set -
	    case 163: EIBAdd(vdvEIB, 1313, eibSWITCH,	'13/1/3', "") // AC on/off
	    case 164: EIBAdd(vdvEIB, 1413, eibSWITCH,	'13/1/4', "") // auto/manual
	    case 165: EIBAdd(vdvEIB, 1513, eibSWITCH,	'13/1/5', "") // fan 1
	    case 166: EIBAdd(vdvEIB, 1613, eibSWITCH,	'13/1/6', "") // fan 2
	    case 167: EIBAdd(vdvEIB, 1713, eibSWITCH,	'13/1/10', "") // blue led 
	    case 168: EIBAdd(vdvEIB, 1813, eibSWITCH,	'13/1/11', "") // red 1
	    case 169: EIBAdd(vdvEIB, 1913, eibSWITCH,	'13/1/12', "") // red 2
	    case 170: EIBAdd(vdvEIB, 2013, eib2BYTE,	'13/1/20', "eibEIS5") // set_point to EIB
	    case 171: EIBAdd(vdvEIB, 2113, eib2BYTE,	'13/1/21', "eibEIS5, ',', eibPollStart") // temp from EIP panel
	    case 172: EIBAdd(vdvEIB, 2513, eib1BYTE,	'13/1/25', "") //init air icon
	    case 173: EIBAdd(vdvEIB, 2613, eib1BYTE,	'13/1/26', "") //init warm floor icon
	    case 174: EIBAdd(vdvEIB, 2713, eib1BYTE,	'13/1/27', "") //mode
	    case 175: EIBAdd(vdvEIB, 2813, eib1BYTE,	'13/1/28', "") //fan speed
	    //Сигарная 14/1/..       
	    case 176: EIBAdd(vdvEIB, 1114, eibSWITCH,	'14/1/1', "") // set +
	    case 177: EIBAdd(vdvEIB, 1214, eibSWITCH,	'14/1/2', "") // set -
	    case 178: EIBAdd(vdvEIB, 1314, eibSWITCH,	'14/1/3', "") // AC on/off
	    case 179: EIBAdd(vdvEIB, 1414, eibSWITCH,	'14/1/4', "") // auto/manual
	    case 180: EIBAdd(vdvEIB, 1514, eibSWITCH,	'14/1/5', "") // fan 1
	    case 181: EIBAdd(vdvEIB, 1614, eibSWITCH,	'14/1/6', "") // fan 2
	    case 182: EIBAdd(vdvEIB, 1714, eibSWITCH,	'14/1/10', "") // blue led 
	    case 183: EIBAdd(vdvEIB, 1814, eibSWITCH,	'14/1/11', "") // red 1
	    case 184: EIBAdd(vdvEIB, 1914, eibSWITCH,	'14/1/12', "") // red 2
	    case 185: EIBAdd(vdvEIB, 2014, eib2BYTE,	'14/1/20', "eibEIS5") // set_point to EIB
	    case 186: EIBAdd(vdvEIB, 2114, eib2BYTE,	'14/1/21', "eibEIS5, ',', eibPollStart") // temp from EIP panel
	    case 187: EIBAdd(vdvEIB, 2514, eib1BYTE,	'14/1/25', "") //init air icon
	    case 188: EIBAdd(vdvEIB, 2614, eib1BYTE,	'14/1/26', "") //init warm floor icon
	    case 189: EIBAdd(vdvEIB, 2714, eib1BYTE,	'14/1/27', "") //mode
	    case 190: EIBAdd(vdvEIB, 2814, eib1BYTE,	'14/1/28', "") //fan speed
	    //Pool panel 15/1/..     
	    case 201: EIBAdd(vdvEIB, 1115, eibSWITCH,	'15/1/1', "") // set +
	    case 202: EIBAdd(vdvEIB, 1215, eibSWITCH,	'15/1/2', "") // set -
	    case 203: EIBAdd(vdvEIB, 1315, eibSWITCH,	'15/1/3', "") // AC on/off
	    case 204: EIBAdd(vdvEIB, 1415, eibSWITCH,	'15/1/4', "") // auto/manual
	    case 205: EIBAdd(vdvEIB, 1515, eibSWITCH,	'15/1/5', "") // fan 1
	    case 206: EIBAdd(vdvEIB, 1615, eibSWITCH,	'15/1/6', "") // fan 2
	    case 207: EIBAdd(vdvEIB, 1715, eibSWITCH,	'15/1/10', "") // blue led 
	    case 208: EIBAdd(vdvEIB, 1815, eibSWITCH,	'15/1/11', "") // red 1
	    case 209: EIBAdd(vdvEIB, 1915, eibSWITCH,	'15/1/12', "") // red 2
	    case 210: EIBAdd(vdvEIB, 2015, eib2BYTE,	'15/1/20', "eibEIS5") // set_point to EIB
	    case 211: EIBAdd(vdvEIB, 2115, eib2BYTE,	'15/1/21', "eibEIS5, ',', eibPollStart") // temp from EIP panel
	    case 212: EIBAdd(vdvEIB, 2515, eib1BYTE,	'15/1/25', "") //init air icon
	    case 213: EIBAdd(vdvEIB, 2615, eib1BYTE,	'15/1/26', "") //init warm floor icon
	    case 214: EIBAdd(vdvEIB, 2715, eib1BYTE,	'15/1/27', "") //mode
	    case 215: EIBAdd(vdvEIB, 2815, eib1BYTE,	'15/1/28', "") //fan speed
	                           
	    //2-й Этаж
	    
	    //Гостевая 2 Ванная 1/2/..
	    case 216: EIBAdd(vdvEIB, 1116, eibSWITCH,	'1/2/1', "") // set +
	    case 217: EIBAdd(vdvEIB, 1216, eibSWITCH,	'1/2/2', "") // set -
	    case 218: EIBAdd(vdvEIB, 1316, eibSWITCH,	'1/2/3', "") // AC on/off
	    case 219: EIBAdd(vdvEIB, 1416, eibSWITCH,	'1/2/4', "") // auto/manual
	    case 220: EIBAdd(vdvEIB, 1516, eibSWITCH,	'1/2/5', "") // fan 1
	    case 221: EIBAdd(vdvEIB, 1616, eibSWITCH,	'1/2/6', "") // fan 2
	    case 222: EIBAdd(vdvEIB, 1716, eibSWITCH,	'1/2/10', "") // blue led 
	    case 223: EIBAdd(vdvEIB, 1816, eibSWITCH,	'1/2/11', "") // red 1
	    case 224: EIBAdd(vdvEIB, 1916, eibSWITCH,	'1/2/12', "") // red 2
	    case 225: EIBAdd(vdvEIB, 2016, eib2BYTE,	'1/2/20', "eibEIS5") // set_point to EIB
	    case 226: EIBAdd(vdvEIB, 2116, eib2BYTE,	'1/2/21', "eibEIS5, ',', eibPollStart") // temp from EIP panel
	    case 227: EIBAdd(vdvEIB, 2516, eib1BYTE,	'1/2/25', "") //init air icon
	    case 228: EIBAdd(vdvEIB, 2616, eib1BYTE,	'1/2/26', "") //init warm floor icon
	    case 229: EIBAdd(vdvEIB, 2716, eib1BYTE,	'1/2/27', "") //mode
	    case 230: EIBAdd(vdvEIB, 2816, eib1BYTE,	'1/2/28', "") //fan speed
	    //Гостевая 2    2/2/..          
	    case 231: EIBAdd(vdvEIB, 1117, eibSWITCH,	'2/2/1', "") // set +
	    case 232: EIBAdd(vdvEIB, 1217, eibSWITCH,	'2/2/2', "") // set -
	    case 233: EIBAdd(vdvEIB, 1317, eibSWITCH,	'2/2/3', "") // AC on/off
	    case 234: EIBAdd(vdvEIB, 1417, eibSWITCH,	'2/2/4', "") // auto/manual
	    case 235: EIBAdd(vdvEIB, 1517, eibSWITCH,	'2/2/5', "") // fan 1
	    case 236: EIBAdd(vdvEIB, 1617, eibSWITCH,	'2/2/6', "") // fan 2
	    case 237: EIBAdd(vdvEIB, 1717, eibSWITCH,	'2/2/10', "") // blue led 
	    case 238: EIBAdd(vdvEIB, 1817, eibSWITCH,	'2/2/11', "") // red 1
	    case 239: EIBAdd(vdvEIB, 1917, eibSWITCH,	'2/2/12', "") // red 2
	    case 240: EIBAdd(vdvEIB, 2017, eib2BYTE,	'2/2/20', "eibEIS5") // set_point to EIB
	    case 241: EIBAdd(vdvEIB, 2117, eib2BYTE,	'2/2/21', "eibEIS5, ',', eibPollStart") // temp from EIP panel
	    case 242: EIBAdd(vdvEIB, 2517, eib1BYTE,	'2/2/25', "") //init air icon
	    case 243: EIBAdd(vdvEIB, 2617, eib1BYTE,	'2/2/26', "") //init warm floor icon
	    case 244: EIBAdd(vdvEIB, 2717, eib1BYTE,	'2/2/27', "") //mode
	    case 245: EIBAdd(vdvEIB, 2817, eib1BYTE,	'2/2/28', "") //fan speed
	    //Гостевая 1 Ванная 3/2/..
	    case 246: EIBAdd(vdvEIB, 1118, eibSWITCH,	'3/2/1', "") // set +
	    case 247: EIBAdd(vdvEIB, 1218, eibSWITCH,	'3/2/2', "") // set -
	    case 248: EIBAdd(vdvEIB, 1318, eibSWITCH,	'3/2/3', "") // AC on/off
	    case 249: EIBAdd(vdvEIB, 1418, eibSWITCH,	'3/2/4', "") // auto/manual
	    case 250: EIBAdd(vdvEIB, 1518, eibSWITCH,	'3/2/5', "") // fan 1
	    case 251: EIBAdd(vdvEIB, 1618, eibSWITCH,	'3/2/6', "") // fan 2
	    case 252: EIBAdd(vdvEIB, 1718, eibSWITCH,	'3/2/10', "") // blue led 
	    case 253: EIBAdd(vdvEIB, 1818, eibSWITCH,	'3/2/11', "") // red 1
	    case 254: EIBAdd(vdvEIB, 1918, eibSWITCH,	'3/2/12', "") // red 2
	    case 255: EIBAdd(vdvEIB, 2018, eib2BYTE,	'3/2/20', "eibEIS5") // set_point to EIB
	    case 256: EIBAdd(vdvEIB, 2118, eib2BYTE,	'3/2/21', "eibEIS5, ',', eibPollStart") // temp from EIP panel
	    case 257: EIBAdd(vdvEIB, 2518, eib1BYTE,	'3/2/25', "") //init air icon
	    case 258: EIBAdd(vdvEIB, 2618, eib1BYTE,	'3/2/26', "") //init warm floor icon
	    case 259: EIBAdd(vdvEIB, 2718, eib1BYTE,	'3/2/27', "") //mode
	    case 260: EIBAdd(vdvEIB, 2818, eib1BYTE,	'3/2/28', "") //fan speed
	    //Гостевая 1     4/2/..          
	    case 261: EIBAdd(vdvEIB, 1119, eibSWITCH,	'4/2/1', "") // set +
	    case 262: EIBAdd(vdvEIB, 1219, eibSWITCH,	'4/2/2', "") // set -
	    case 263: EIBAdd(vdvEIB, 1319, eibSWITCH,	'4/2/3', "") // AC on/off
	    case 264: EIBAdd(vdvEIB, 1419, eibSWITCH,	'4/2/4', "") // auto/manual
	    case 265: EIBAdd(vdvEIB, 1519, eibSWITCH,	'4/2/5', "") // fan 1
	    case 266: EIBAdd(vdvEIB, 1619, eibSWITCH,	'4/2/6', "") // fan 2
	    case 267: EIBAdd(vdvEIB, 1719, eibSWITCH,	'4/2/10', "") // blue led 
	    case 268: EIBAdd(vdvEIB, 1819, eibSWITCH,	'4/2/11', "") // red 1
	    case 269: EIBAdd(vdvEIB, 1919, eibSWITCH,	'4/2/12', "") // red 2
	    case 270: EIBAdd(vdvEIB, 2019, eib2BYTE,	'4/2/20', "eibEIS5") // set_point to EIB
	    case 271: EIBAdd(vdvEIB, 2119, eib2BYTE,	'4/2/21', "eibEIS5, ',', eibPollStart") // temp from EIP panel
	    case 272: EIBAdd(vdvEIB, 2519, eib1BYTE,	'4/2/25', "") //init air icon
	    case 273: EIBAdd(vdvEIB, 2619, eib1BYTE,	'4/2/26', "") //init warm floor icon
	    case 274: EIBAdd(vdvEIB, 2719, eib1BYTE,	'4/2/27', "") //mode
	    case 275: EIBAdd(vdvEIB, 2819, eib1BYTE,	'4/2/28', "") //fan speed
	    //Анна Ванная 5/2/..     
	    case 276: EIBAdd(vdvEIB, 1120, eibSWITCH,	'5/2/1', "") // set +
	    case 277: EIBAdd(vdvEIB, 1220, eibSWITCH,	'5/2/2', "") // set -
	    case 278: EIBAdd(vdvEIB, 1320, eibSWITCH,	'5/2/3', "") // AC on/off
	    case 279: EIBAdd(vdvEIB, 1420, eibSWITCH,	'5/2/4', "") // auto/manual
	    case 280: EIBAdd(vdvEIB, 1520, eibSWITCH,	'5/2/5', "") // fan 1
	    case 281: EIBAdd(vdvEIB, 1620, eibSWITCH,	'5/2/6', "") // fan 2
	    case 282: EIBAdd(vdvEIB, 1720, eibSWITCH,	'5/2/10', "") // blue led 
	    case 283: EIBAdd(vdvEIB, 1820, eibSWITCH,	'5/2/11', "") // red 1
	    case 284: EIBAdd(vdvEIB, 1920, eibSWITCH,	'5/2/12', "") // red 2
	    case 285: EIBAdd(vdvEIB, 2020, eib2BYTE,	'5/2/20', "eibEIS5") // set_point to EIB
	    case 286: EIBAdd(vdvEIB, 2120, eib2BYTE,	'5/2/21', "eibEIS5, ',', eibPollStart") // temp from EIP panel
	    case 287: EIBAdd(vdvEIB, 2520, eib1BYTE,	'5/2/25', "") //init air icon
	    case 288: EIBAdd(vdvEIB, 2620, eib1BYTE,	'5/2/26', "") //init warm floor icon
	    case 289: EIBAdd(vdvEIB, 2720, eib1BYTE,	'5/2/27', "") //mode
	    case 290: EIBAdd(vdvEIB, 2820, eib1BYTE,	'5/2/28', "") //fan speed
	    //Анна Спальня 6/2/..    
	    case 301: EIBAdd(vdvEIB, 1121, eibSWITCH,	'6/2/1', "") // set +
	    case 302: EIBAdd(vdvEIB, 1221, eibSWITCH,	'6/2/2', "") // set -
	    case 303: EIBAdd(vdvEIB, 1321, eibSWITCH,	'6/2/3', "") // AC on/off
	    case 304: EIBAdd(vdvEIB, 1421, eibSWITCH,	'6/2/4', "") // auto/manual
	    case 305: EIBAdd(vdvEIB, 1521, eibSWITCH,	'6/2/5', "") // fan 1
	    case 306: EIBAdd(vdvEIB, 1621, eibSWITCH,	'6/2/6', "") // fan 2
	    case 307: EIBAdd(vdvEIB, 1721, eibSWITCH,	'6/2/10', "") // blue led 
	    case 308: EIBAdd(vdvEIB, 1821, eibSWITCH,	'6/2/11', "") // red 1
	    case 309: EIBAdd(vdvEIB, 1921, eibSWITCH,	'6/2/12', "") // red 2
	    case 310: EIBAdd(vdvEIB, 2021, eib2BYTE,	'6/2/20', "eibEIS5") // set_point to EIB
	    case 311: EIBAdd(vdvEIB, 2121, eib2BYTE,	'6/2/21', "eibEIS5, ',', eibPollStart") // temp from EIP panel
	    case 312: EIBAdd(vdvEIB, 2521, eib1BYTE,	'6/2/25', "") //init air icon
	    case 313: EIBAdd(vdvEIB, 2621, eib1BYTE,	'6/2/26', "") //init warm floor icon
	    case 314: EIBAdd(vdvEIB, 2721, eib1BYTE,	'6/2/27', "") //mode
	    case 315: EIBAdd(vdvEIB, 2821, eib1BYTE,	'6/2/28', "") //fan speed
	    //Анна Гостиная 7/2/..   
	    case 316: EIBAdd(vdvEIB, 1122, eibSWITCH,	'7/2/1', "") // set +
	    case 317: EIBAdd(vdvEIB, 1222, eibSWITCH,	'7/2/2', "") // set -
	    case 318: EIBAdd(vdvEIB, 1322, eibSWITCH,	'7/2/3', "") // AC on/off
	    case 319: EIBAdd(vdvEIB, 1422, eibSWITCH,	'7/2/4', "") // auto/manual
	    case 320: EIBAdd(vdvEIB, 1522, eibSWITCH,	'7/2/5', "") // fan 1
	    case 321: EIBAdd(vdvEIB, 1622, eibSWITCH,	'7/2/6', "") // fan 2
	    case 322: EIBAdd(vdvEIB, 1722, eibSWITCH,	'7/2/10', "") // blue led 
	    case 323: EIBAdd(vdvEIB, 1822, eibSWITCH,	'7/2/11', "") // red 1
	    case 324: EIBAdd(vdvEIB, 1922, eibSWITCH,	'7/2/12', "") // red 2
	    case 325: EIBAdd(vdvEIB, 2022, eib2BYTE,	'7/2/20', "eibEIS5") // set_point to EIB
	    case 326: EIBAdd(vdvEIB, 2122, eib2BYTE,	'7/2/21', "eibEIS5, ',', eibPollStart") // temp from EIP panel
	    case 327: EIBAdd(vdvEIB, 2522, eib1BYTE,	'7/2/25', "") //init air icon
	    case 328: EIBAdd(vdvEIB, 2622, eib1BYTE,	'7/2/26', "") //init warm floor icon
	    case 329: EIBAdd(vdvEIB, 2722, eib1BYTE,	'7/2/27', "") //mode
	    case 330: EIBAdd(vdvEIB, 2822, eib1BYTE,	'7/2/28', "") //fan speed
	    //Игровая     8/2/..          
	    case 331: EIBAdd(vdvEIB, 1123, eibSWITCH,	'8/2/1', "") // set +
	    case 332: EIBAdd(vdvEIB, 1223, eibSWITCH,	'8/2/2', "") // set -
	    case 333: EIBAdd(vdvEIB, 1323, eibSWITCH,	'8/2/3', "") // AC on/off
	    case 334: EIBAdd(vdvEIB, 1423, eibSWITCH,	'8/2/4', "") // auto/manual
	    case 335: EIBAdd(vdvEIB, 1523, eibSWITCH,	'8/2/5', "") // fan 1
	    case 336: EIBAdd(vdvEIB, 1623, eibSWITCH,	'8/2/6', "") // fan 2
	    case 337: EIBAdd(vdvEIB, 1723, eibSWITCH,	'8/2/10', "") // blue led 
	    case 338: EIBAdd(vdvEIB, 1823, eibSWITCH,	'8/2/11', "") // red 1
	    case 339: EIBAdd(vdvEIB, 1923, eibSWITCH,	'8/2/12', "") // red 2
	    case 340: EIBAdd(vdvEIB, 2023, eib2BYTE,	'8/2/20', "eibEIS5") // set_point to EIB
	    case 341: EIBAdd(vdvEIB, 2123, eib2BYTE,	'8/2/21', "eibEIS5, ',', eibPollStart") // temp from EIP panel
	    case 342: EIBAdd(vdvEIB, 2523, eib1BYTE,	'8/2/25', "") //init air icon
	    case 343: EIBAdd(vdvEIB, 2623, eib1BYTE,	'8/2/26', "") //init warm floor icon
	    case 344: EIBAdd(vdvEIB, 2723, eib1BYTE,	'8/2/27', "") //mode
	    case 345: EIBAdd(vdvEIB, 2823, eib1BYTE,	'8/2/28', "") //fan speed
	    //Гардероб ОЛьга     12/2/..          
	    case 91: EIBAdd(vdvEIB,  1127, eibSWITCH,	'12/2/1', "") // set +
	    case 92: EIBAdd(vdvEIB,  1227, eibSWITCH,	'12/2/2', "") // set -
	    case 93: EIBAdd(vdvEIB,  1327, eibSWITCH,	'12/2/3', "") // AC on/off
	    case 94: EIBAdd(vdvEIB,  1427, eibSWITCH,	'12/2/4', "") // auto/manual
	    case 95: EIBAdd(vdvEIB,  1527, eibSWITCH,	'12/2/5', "") // fan 1
	    case 96: EIBAdd(vdvEIB,  1627, eibSWITCH,	'12/2/6', "") // fan 2
	    case 97: EIBAdd(vdvEIB,  1727, eibSWITCH,	'12/2/10', "") // blue led 
	    case 98: EIBAdd(vdvEIB,  1827, eibSWITCH,	'12/2/11', "") // red 1
	    case 99: EIBAdd(vdvEIB,  1927, eibSWITCH,	'12/2/12', "") // red 2
	    case 100: EIBAdd(vdvEIB, 2027, eib2BYTE,	'12/2/20', "eibEIS5") // set_point to EIB
	    case 191: EIBAdd(vdvEIB, 2127, eib2BYTE,	'12/2/21', "eibEIS5, ',', eibPollStart") // temp from EIP panel
	    case 192: EIBAdd(vdvEIB, 2527, eib1BYTE,	'12/2/25', "") //init air icon
	    case 193: EIBAdd(vdvEIB, 2627, eib1BYTE,	'12/2/26', "") //init warm floor icon
	    case 194: EIBAdd(vdvEIB, 2727, eib1BYTE,	'12/2/27', "") //mode
	    case 195: EIBAdd(vdvEIB, 2827, eib1BYTE,	'12/2/28', "") //fan speed
	    //Робик Ванная 9/2/..    
	    case 346: EIBAdd(vdvEIB, 1124, eibSWITCH,	'9/2/1', "") // set +
	    case 347: EIBAdd(vdvEIB, 1224, eibSWITCH,	'9/2/2', "") // set -
	    case 348: EIBAdd(vdvEIB, 1324, eibSWITCH,	'9/2/3', "") // AC on/off
	    case 349: EIBAdd(vdvEIB, 1424, eibSWITCH,	'9/2/4', "") // auto/manual
	    case 350: EIBAdd(vdvEIB, 1524, eibSWITCH,	'9/2/5', "") // fan 1
	    case 351: EIBAdd(vdvEIB, 1624, eibSWITCH,	'9/2/6', "") // fan 2
	    case 352: EIBAdd(vdvEIB, 1724, eibSWITCH,	'9/2/10', "") // blue led 
	    case 353: EIBAdd(vdvEIB, 1824, eibSWITCH,	'9/2/11', "") // red 1
	    case 354: EIBAdd(vdvEIB, 1924, eibSWITCH,	'9/2/12', "") // red 2
	    case 355: EIBAdd(vdvEIB, 2024, eib2BYTE,	'9/2/20', "eibEIS5") // set_point to EIB
	    case 356: EIBAdd(vdvEIB, 2124, eib2BYTE,	'9/2/21', "eibEIS5, ',', eibPollStart") // temp from EIP panel
	    case 357: EIBAdd(vdvEIB, 2524, eib1BYTE,	'9/2/25', "") //init air icon
	    case 358: EIBAdd(vdvEIB, 2624, eib1BYTE,	'9/2/26', "") //init warm floor icon
	    case 359: EIBAdd(vdvEIB, 2724, eib1BYTE,	'9/2/27', "") //mode
	    case 360: EIBAdd(vdvEIB, 2824, eib1BYTE,	'9/2/28', "") //fan speed
	    //Робик Спальня     10/2/..          
	    case 361: EIBAdd(vdvEIB, 1125, eibSWITCH,	'10/2/1', "") // set +
	    case 362: EIBAdd(vdvEIB, 1225, eibSWITCH,	'10/2/2', "") // set -
	    case 363: EIBAdd(vdvEIB, 1325, eibSWITCH,	'10/2/3', "") // AC on/off
	    case 364: EIBAdd(vdvEIB, 1425, eibSWITCH,	'10/2/4', "") // auto/manual
	    case 365: EIBAdd(vdvEIB, 1525, eibSWITCH,	'10/2/5', "") // fan 1
	    case 366: EIBAdd(vdvEIB, 1625, eibSWITCH,	'10/2/6', "") // fan 2
	    case 367: EIBAdd(vdvEIB, 1725, eibSWITCH,	'10/2/10', "") // blue led 
	    case 368: EIBAdd(vdvEIB, 1825, eibSWITCH,	'10/2/11', "") // red 1
	    case 369: EIBAdd(vdvEIB, 1925, eibSWITCH,	'10/2/12', "") // red 2
	    case 370: EIBAdd(vdvEIB, 2025, eib2BYTE,	'10/2/20', "eibEIS5") // set_point to EIB
	    case 371: EIBAdd(vdvEIB, 2125, eib2BYTE,	'10/2/21', "eibEIS5, ',', eibPollStart") // temp from EIP panel
	    case 372: EIBAdd(vdvEIB, 2525, eib1BYTE,	'10/2/25', "") //init air icon
	    case 373: EIBAdd(vdvEIB, 2625, eib1BYTE,	'10/2/26', "") //init warm floor icon
	    case 374: EIBAdd(vdvEIB, 2725, eib1BYTE,	'10/2/27', "") //mode
	    case 375: EIBAdd(vdvEIB, 2825, eib1BYTE,	'10/2/28', "") //fan speed
	    //Гардероб Скигина 11/2/..
	    case 376: EIBAdd(vdvEIB, 1126, eibSWITCH,	'11/2/1', "") // set +
	    case 377: EIBAdd(vdvEIB, 1226, eibSWITCH,	'11/2/2', "") // set -
	    case 378: EIBAdd(vdvEIB, 1326, eibSWITCH,	'11/2/3', "") // AC on/off
	    case 379: EIBAdd(vdvEIB, 1426, eibSWITCH,	'11/2/4', "") // auto/manual
	    case 380: EIBAdd(vdvEIB, 1526, eibSWITCH,	'11/2/5', "") // fan 1
	    case 381: EIBAdd(vdvEIB, 1626, eibSWITCH,	'11/2/6', "") // fan 2
	    case 382: EIBAdd(vdvEIB, 1726, eibSWITCH,	'11/2/10', "") // blue led 
	    case 383: EIBAdd(vdvEIB, 1826, eibSWITCH,	'11/2/11', "") // red 1
	    case 384: EIBAdd(vdvEIB, 1926, eibSWITCH,	'11/2/12', "") // red 2
	    case 385: EIBAdd(vdvEIB, 2026, eib2BYTE,	'11/2/20', "eibEIS5") // set_point to EIB
	    case 386: EIBAdd(vdvEIB, 2126, eib2BYTE,	'11/2/21', "eibEIS5, ',', eibPollStart") // temp from EIP panel
	    case 387: EIBAdd(vdvEIB, 2526, eib1BYTE,	'11/2/25', "") //init air icon
	    case 388: EIBAdd(vdvEIB, 2626, eib1BYTE,	'11/2/26', "") //init warm floor icon
	    case 389: EIBAdd(vdvEIB, 2726, eib1BYTE,	'11/2/27', "") //mode
	    case 390: EIBAdd(vdvEIB, 2826, eib1BYTE,	'11/2/28', "") //fan speed
	    //Master Bathroom 13/2/..
	    case 196: EIBAdd(vdvEIB, 1128, eibSWITCH,	'13/2/1', "") // set +
	    case 197: EIBAdd(vdvEIB, 1228, eibSWITCH,	'13/2/2', "") // set -
	    case 198: EIBAdd(vdvEIB, 1328, eibSWITCH,	'13/2/3', "") // AC on/off
	    case 199: EIBAdd(vdvEIB, 1428, eibSWITCH,	'13/2/4', "") // auto/manual
	    case 200: EIBAdd(vdvEIB, 1528, eibSWITCH,	'13/2/5', "") // fan 1
	    case 291: EIBAdd(vdvEIB, 1628, eibSWITCH,	'13/2/6', "") // fan 2
	    case 292: EIBAdd(vdvEIB, 1728, eibSWITCH,	'13/2/10', "") // blue led 
	    case 293: EIBAdd(vdvEIB, 1828, eibSWITCH,	'13/2/11', "") // red 1
	    case 294: EIBAdd(vdvEIB, 1928, eibSWITCH,	'13/2/12', "") // red 2
	    case 295: EIBAdd(vdvEIB, 2028, eib2BYTE,	'13/2/20', "eibEIS5") // set_point to EIB
	    case 296: EIBAdd(vdvEIB, 2128, eib2BYTE,	'13/2/21', "eibEIS5, ',', eibPollStart") // temp from EIP panel
	    case 297: EIBAdd(vdvEIB, 2528, eib1BYTE,	'13/2/25', "") //init air icon
	    case 298: EIBAdd(vdvEIB, 2628, eib1BYTE,	'13/2/26', "") //init warm floor icon
	    case 299: EIBAdd(vdvEIB, 2728, eib1BYTE,	'13/2/27', "") //mode
	    case 300: EIBAdd(vdvEIB, 2828, eib1BYTE,	'13/2/28', "") //fan speed
	    //Master Bedroom     14/2/..          
	    case 391: EIBAdd(vdvEIB, 1129, eibSWITCH,	'14/2/1', "") // set +
	    case 392: EIBAdd(vdvEIB, 1229, eibSWITCH,	'14/2/2', "") // set -
	    case 393: EIBAdd(vdvEIB, 1329, eibSWITCH,	'14/2/3', "") // AC on/off
	    case 394: EIBAdd(vdvEIB, 1429, eibSWITCH,	'14/2/4', "") // auto/manual
	    case 395: EIBAdd(vdvEIB, 1529, eibSWITCH,	'14/2/5', "") // fan 1
	    case 396: EIBAdd(vdvEIB, 1629, eibSWITCH,	'14/2/6', "") // fan 2
	    case 397: EIBAdd(vdvEIB, 1729, eibSWITCH,	'14/2/10', "") // blue led 
	    case 398: EIBAdd(vdvEIB, 1829, eibSWITCH,	'14/2/11', "") // red 1
	    case 399: EIBAdd(vdvEIB, 1929, eibSWITCH,	'14/2/12', "") // red 2
	    case 400: EIBAdd(vdvEIB, 2029, eib2BYTE,	'14/2/20', "eibEIS5") // set_point to EIB
	    case 401: EIBAdd(vdvEIB, 2129, eib2BYTE,	'14/2/21', "eibEIS5, ',', eibPollStart") // temp from EIP panel
	    case 402: EIBAdd(vdvEIB, 2529, eib1BYTE,	'14/2/25', "") //init air icon
	    case 403: EIBAdd(vdvEIB, 2629, eib1BYTE,	'14/2/26', "") //init warm floor icon
	    case 404: EIBAdd(vdvEIB, 2729, eib1BYTE,	'14/2/27', "") //mode
	    case 405: EIBAdd(vdvEIB, 2829, eib1BYTE,	'14/2/28', "") //fan speed
	    //Hall 2nd Floor 12/2/.. 
	    case 406: EIBAdd(vdvEIB, 1130, eibSWITCH,	'15/2/1', "") // set +
	    case 407: EIBAdd(vdvEIB, 1230, eibSWITCH,	'15/2/2', "") // set -
	    case 408: EIBAdd(vdvEIB, 1330, eibSWITCH,	'15/2/3', "") // AC on/off
	    case 409: EIBAdd(vdvEIB, 1430, eibSWITCH,	'15/2/4', "") // auto/manual
	    case 410: EIBAdd(vdvEIB, 1530, eibSWITCH,	'15/2/5', "") // fan 1
	    case 411: EIBAdd(vdvEIB, 1630, eibSWITCH,	'15/2/6', "") // fan 2
	    case 412: EIBAdd(vdvEIB, 1730, eibSWITCH,	'15/2/10', "") // blue led 
	    case 413: EIBAdd(vdvEIB, 1830, eibSWITCH,	'15/2/11', "") // red 1
	    case 414: EIBAdd(vdvEIB, 1930, eibSWITCH,	'15/2/12', "") // red 2
	    case 415: EIBAdd(vdvEIB, 2030, eib2BYTE,	'15/2/20', "eibEIS5") // set_point to EIB
	    case 416: EIBAdd(vdvEIB, 2130, eib2BYTE,	'15/2/21', "eibEIS5, ',', eibPollStart") // temp from EIP panel
	    case 417: EIBAdd(vdvEIB, 2530, eib1BYTE,	'15/2/25', "") //init air icon
	    case 418: EIBAdd(vdvEIB, 2630, eib1BYTE,	'15/2/26', "") //init warm floor icon
	    case 419: EIBAdd(vdvEIB, 2730, eib1BYTE,	'15/2/27', "") //mode
	    case 420: EIBAdd(vdvEIB, 2830, eib1BYTE,	'15/2/28', "") //fan speed
	                           
	    //1st floor again
	    //Hall 1st floor on Main Entrance 1/1/..
	    case 421: EIBAdd(vdvEIB, 1101, eibSWITCH,	'1/1/1', "") // set +
	    case 422: EIBAdd(vdvEIB, 1201, eibSWITCH,	'1/1/2', "") // set -
	    case 423: EIBAdd(vdvEIB, 1301, eibSWITCH,	'1/1/3', "") // AC on/off
	    case 424: EIBAdd(vdvEIB, 1401, eibSWITCH,	'1/1/4', "") // auto/manual
	    case 425: EIBAdd(vdvEIB, 1501, eibSWITCH,	'1/1/5', "") // fan 1
	    case 426: EIBAdd(vdvEIB, 1601, eibSWITCH,	'1/1/6', "") // fan 2
	    case 427: EIBAdd(vdvEIB, 1701, eibSWITCH,	'1/1/10', "") // blue led 
	    case 428: EIBAdd(vdvEIB, 1801, eibSWITCH,	'1/1/11', "") // red 1
	    case 429: EIBAdd(vdvEIB, 1901, eibSWITCH,	'1/1/12', "") // red 2
	    case 430: EIBAdd(vdvEIB, 2001, eib2BYTE,	'1/1/20', "eibEIS5") // set_point to EIB
	    case 431: EIBAdd(vdvEIB, 2101, eib2BYTE,	'1/1/21', "eibEIS5, ',', eibPollStart") // temp from EIP panel
	    case 432: EIBAdd(vdvEIB, 2501, eib1BYTE,	'1/1/25', "") //init air icon
	    case 433: EIBAdd(vdvEIB, 2601, eib1BYTE,	'1/1/26', "") //init warm floor icon
	    case 434: EIBAdd(vdvEIB, 2701, eib1BYTE,	'1/1/27', "") //mode
	    case 435: EIBAdd(vdvEIB, 2801, eib1BYTE,	'1/1/28', "") //fan speed
	    
	    case 436: EIBAdd(vdvEIB, 2801, eib1BYTE,	'1/3/1', "") //set brightness on eib panel
	    //15
	    case 437: EIBAdd(vdvEIB, 01, eib1BYTE,	'1/1/30', "") //backlight
	    case 438: EIBAdd(vdvEIB, 02, eib1BYTE,	'2/1/30', "") //backlight
	    case 439: EIBAdd(vdvEIB, 03, eib1BYTE,	'3/1/30', "") //backlight
	    case 440: EIBAdd(vdvEIB, 04, eib1BYTE,	'4/1/30', "") //backlight
	    case 441: EIBAdd(vdvEIB, 05, eib1BYTE,	'5/1/30', "") //backlight
	    case 442: EIBAdd(vdvEIB, 06, eib1BYTE,	'6/1/30', "") //backlight
	    case 443: EIBAdd(vdvEIB, 07, eib1BYTE,	'7/1/30', "") //backlight
	    case 444: EIBAdd(vdvEIB, 08, eib1BYTE,	'8/1/30', "") //backlight
	    case 445: EIBAdd(vdvEIB, 09, eib1BYTE,	'9/1/30', "") //backlight
	    case 446: EIBAdd(vdvEIB, 10, eib1BYTE,	'10/1/30', "") //backlight
	    case 447: EIBAdd(vdvEIB, 11, eib1BYTE,	'11/1/30', "") //backlight
	    case 448: EIBAdd(vdvEIB, 12, eib1BYTE,	'12/1/30', "") //backlight
	    case 449: EIBAdd(vdvEIB, 13, eib1BYTE,	'13/1/30', "") //backlight
	    case 450: EIBAdd(vdvEIB, 14, eib1BYTE,	'14/1/30', "") //backlight
	    case 451: EIBAdd(vdvEIB, 15, eib1BYTE,	'15/1/30', "") //backlight
	    case 452: EIBAdd(vdvEIB, 16, eib1BYTE,	'1/2/30', "") //backlight
	    case 453: EIBAdd(vdvEIB, 17, eib1BYTE,	'2/2/30', "") //backlight
	    case 454: EIBAdd(vdvEIB, 18, eib1BYTE,	'3/2/30', "") //backlight
	    case 455: EIBAdd(vdvEIB, 19, eib1BYTE,	'4/2/30', "") //backlight
	    case 456: EIBAdd(vdvEIB, 20, eib1BYTE,	'5/2/30', "") //backlight
	    case 457: EIBAdd(vdvEIB, 21, eib1BYTE,	'6/2/30', "") //backlight
	    case 458: EIBAdd(vdvEIB, 22, eib1BYTE,	'7/2/30', "") //backlight
	    case 459: EIBAdd(vdvEIB, 23, eib1BYTE,	'8/2/30', "") //backlight
	    case 460: EIBAdd(vdvEIB, 24, eib1BYTE,	'9/2/30', "") //backlight
	    case 461: EIBAdd(vdvEIB, 25, eib1BYTE,	'10/2/30', "") //backlight
	    case 462: EIBAdd(vdvEIB, 26, eib1BYTE,	'11/2/30', "") //backlight
	    case 463: EIBAdd(vdvEIB, 27, eib1BYTE,	'12/2/30', "") //backlight
	    case 464: EIBAdd(vdvEIB, 28, eib1BYTE,	'13/2/30', "") //backlight
	    case 465: EIBAdd(vdvEIB, 29, eib1BYTE,	'14/2/30', "") //backlight
	    case 466: EIBAdd(vdvEIB, 30, eib1BYTE,	'15/2/30', "") //backlight
	    
	    default: nCounter = 0    
	}
	if(nCounter) nCounter++
    }
}

(***********************************************************)
(*                     END OF PROGRAM                      *)
(*        DO NOT PUT ANY CODE BELOW THIS COMMENT           *)
(***********************************************************)

