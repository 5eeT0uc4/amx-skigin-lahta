MODULE_NAME='Yamaha_YNCA_IP' (dev vdvDevice, dev dvDevice, char in_caHost[])
(***********************************************************)
(***********************************************************)
(*  FILE_LAST_MODIFIED_ON: 04/04/2006  AT: 11:33:16        *)
(***********************************************************)
(* System Type : NetLinx                                   *)
(***********************************************************)
(* REV HISTORY:                                            *)
(***********************************************************)
(*
    $History: $
*)    
(***********************************************************)
(*          DEVICE NUMBER DEFINITIONS GO BELOW             *)
(***********************************************************)

#include 'Strings.axi'

DEFINE_DEVICE

dvDebug = 0:0:0
(***********************************************************)
(*               CONSTANT DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_CONSTANT

// идентификаторы потоков
TL_PING_ID		= $A0	// идентификатор потока пинга
TL_WORK_ID		= $A1
tcp			= 1
udp			= 2
true			= 1
false			= 0

MAX_RESP_LEN		= 1024;			// Максимальная длинна ответа

(***********************************************************)
(*              DATA TYPE DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_TYPE

structure _Receiver_s
{
    char m_caMainPower[10]
    char m_caSystemPower[10]
    char m_caSleep[10]
    char m_caInput[10]
    char m_caVolume[10]
    float m_fVolume
    char m_caMute[10]
    float m_fMute
    char m_caBass[10]
    char m_caTreble[10]
    char m_caSound[20]
    char m_caStraight[10]
    char m_caEnhancer[10]  
    float m_fStraight
    float m_fEnhancer
    char m_caExtraBass[10]
    char m_caSubTrim[10]

    char m_caPureDirectMode[10]
    char m_caDirect[10]
    char m_caYpaoVolume[10]
    char m_caAdaptiveDrc[10]
    char m_caDialogueLevel[10]
    char m_caAdaptiveDsp[10]
    char m_caDecoderSel[10]
    char m_ca3dCinema[10]
    char m_caExSurDecoder[10]
}

(***********************************************************)
(*               VARIABLE DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_VARIABLE

_debug			= 0 //отладка

volatile _Receiver_s	YamahaYNCA
volatile char		m_caBuffer[MAX_RESP_LEN]
volatile char		m_caDeviceName[20]	= 'Yamaha YNCA Driver'
volatile long 		m_laPing[1]		= {2000} 	// промежуток времени через который производится пинг
volatile long 		m_laWork[1]		= {500}	// промежуток времени через который производится обработка состояние соединения
volatile char		m_cIsConnect		= 0	// флаг соединения
volatile long		m_lCurTime		= 0
volatile long		m_lLastPingTime		= 0
volatile long		m_lStartWaitTime	= 0
volatile integer	m_iOnWork		= 0

volatile long 		m_lPort			= 50000 //порт подключения

volatile char		m_caInput[10]		= ''

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

define_function fnPowerOn()		
{ 
    cancel_wait 'check pwr'
    fnOnSend("'MAIN:PWR=On'") 
    wait 20 'check pwr' 
    if(YamahaYNCA.m_caMainPower == 'Standby')
	fnOnSend("'MAIN:PWR=On'")
}
define_function fnPowerOff()		
{ 
    cancel_wait 'check pwr'
    fnOnSend("'MAIN:PWR=Standby'") 
    wait 20 'check pwr' 
    if(YamahaYNCA.m_caMainPower == 'On')
	fnOnSend("'MAIN:PWR=Standby'")
}
define_function fnGetBasicStatus()	{ fnOnSend("'MAIN:BASIC=?'") }

//
define_function fnSetVolume(char in_caValue[])
{
    fnOnSend("'MAIN:VOL=', in_caValue") 
}

define_function fnSetVolUp()		{ fnOnSend("'MAIN:VOL=Up 1 dB'") }
define_function fnSetVolDown()		{ fnOnSend("'MAIN:VOL=Down 1 dB'") }
define_function fnSetVolMute()		{ fnOnSend("'MAIN:MUTE=On/Off'") }

define_function fnSetSoundProgram(char l_caProgram[]){
    fnOnSend("'MAIN:SOUNDPRG=', l_caProgram")
}
define_function fnSetInput()
{
    if(YamahaYNCA.m_caMainPower == 'On') {
	fnOnSend("'MAIN:INP=', m_caInput")
    } else {
	//cancel_wait 'Yamaha_power'
	fnPowerOn()
	//
	timed_wait_until (YamahaYNCA.m_caMainPower == 'On') 200 'Yamaha_power' {
	    wait 10 'Yamaha_power'
		fnSetInput()
	}
    }
}

define_function fnSetBass(char in_caData[])
{
    float value
    
    value = atof(YamahaYNCA.m_caBass) // -6.0 ... 6.0 dB
    
    switch(in_caData) {
	case '+': { value = value + 0.5 }
	case '-': { value = value - 0.5 }
    }
    
    if(value > 6) value = 6
    if(value < -6) value = -6
    
    fnOnSend("'MAIN:TONEBASS=', format('%1.1f', value)")
}
define_function fnSetTreble(char in_caData[])
{
    float value
    
    value = atof(YamahaYNCA.m_caTreble) // -6.0 ... 6.0 dB
    
    switch(in_caData) {
	case '+': { value = value + 0.5 }
	case '-': { value = value - 0.5 }
    }
    
    if(value > 6) value = 6
    if(value < -6) value = -6
    
    fnOnSend("'MAIN:TONETREBLE=', format('%1.1f', value)")
}
define_function fnSetSubTrim(char in_caData[])
{
    float value
    
    value = atof(YamahaYNCA.m_caSubTrim) // -6.0 ... 6.0 dB
    
    switch(in_caData) {
	case '+': { value = value + 0.5 }
	case '-': { value = value - 0.5 }
    }
    
    if(value > 6) value = 6
    if(value < -6) value = -6
    
    fnOnSend("'MAIN:SWFRTRIM=', format('%1.1f', value)")
}

define_function fnSetEnchancer()
{
    if(YamahaYNCA.m_caEnhancer == 'On')  fnOnSend("'MAIN:ENHANCER=Off'")
    if(YamahaYNCA.m_caEnhancer == 'Off') fnOnSend("'MAIN:ENHANCER=On'")
}
define_function fnSetStraight()
{
    if(YamahaYNCA.m_caStraight == 'On')  fnOnSend("'MAIN:STRAIGHT=Off'")
    if(YamahaYNCA.m_caStraight == 'Off') fnOnSend("'MAIN:STRAIGHT=On'")
}
define_function fnSetDIRMODE()
{
    if(YamahaYNCA.m_caDirect == 'On')  fnOnSend("'MAIN:DIRMODE=Off'")
    if(YamahaYNCA.m_caDirect == 'Off') fnOnSend("'MAIN:DIRMODE=On'")
}

define_function fnSetPUREDIRMODE()
{
    if(YamahaYNCA.m_caPureDirectMode == 'On')  fnOnSend("'MAIN:PUREDIRMODE=Off'")
    if(YamahaYNCA.m_caPureDirectMode == 'Off') fnOnSend("'MAIN:PUREDIRMODE=On'")
}
define_function fnSetYPAOVOL()
{
    if(YamahaYNCA.m_caYpaoVolume == 'Auto')  fnOnSend("'MAIN:YPAOVOL=Off'")
    if(YamahaYNCA.m_caYpaoVolume == 'Off') fnOnSend("'MAIN:YPAOVOL=Auto'")
}
define_function fnSetEXBASS()
{
    if(YamahaYNCA.m_caExtraBass == 'Auto')  fnOnSend("'MAIN:EXBASS=Off'")
    if(YamahaYNCA.m_caExtraBass == 'Off') fnOnSend("'MAIN:EXBASS=Auto'")
}
define_function fnSetADAPTIVEDRC()
{
    if(YamahaYNCA.m_caAdaptiveDrc == 'Auto')  fnOnSend("'MAIN:ADAPTIVEDRC=Off'")
    if(YamahaYNCA.m_caStraight == 'Off') fnOnSend("'MAIN:ADAPTIVEDRC=Auto'")
}
define_function fnSetDIALOGUELVL(char in_caData[])
{
    float value
    
    value = atof(YamahaYNCA.m_caDialogueLevel) // 0 .. 3
    
    switch(in_caData) {
	case '+': { value = value + 1 }
	case '-': { value = value - 1 }
    }
    
    if(value > 3) value = 3
    if(value < 0) value = 0
    
    fnOnSend("'MAIN:DIALOGUELVL=', ftoa(value)")
}

define_function fnSetADAPTIVEDSP()
{
    if(YamahaYNCA.m_caAdaptiveDsp == 'Auto')  fnOnSend("'MAIN:ADAPTIVEDSP=Off'")
    if(YamahaYNCA.m_caAdaptiveDsp == 'Off') fnOnSend("'MAIN:ADAPTIVEDSP=Auto'")
}
define_function fnSet3DCINEMA()
{
    if(YamahaYNCA.m_ca3dCinema == 'Auto')  fnOnSend("'MAIN:3DCINEMA=Off'")
    if(YamahaYNCA.m_ca3dCinema == 'Off') fnOnSend("'MAIN:3DCINEMA=Auto'")
}


define_function fnOnControl(integer in_iCh)
{
    switch(in_iCh)
    {
	case 01: { fnOnSend ('MAIN:PLAYBACK=Play') 	 }
	case 02: { fnOnSend ('MAIN:PLAYBACK=Stop') 	 }
	case 03: { fnOnSend ('MAIN:PLAYBACK=Pause') 	 }
	case 04: { fnOnSend ('MAIN:PLAYBACK=Skip Fvd') 	 }
	case 05: { fnOnSend ('MAIN:PLAYBACK=Skip Rev') 	 }
	case 06: { fnOnSend ('MAIN:CURSOR=Return') 	 }
	case 07: { fnOnSend ('MAIN:CURSOR=Return to Home') }
	case 08: { fnOnSend ('MAIN:MENU=Top Menu') 	}
	case 09: { fnOnSend ('MAIN:MENU=Menu') 	 	}
	case 10: { fnOnSend ('MAIN:MENU=Option') 	}
	case 11: { fnOnSend ('MAIN:MENU=On Screen')  	}
	case 12: { fnOnSend ('MAIN:MENU=Display')  	}

	case 13: { fnOnSend ('SYS:REMOTECODE=7A8558A7')  	} // Program UP
	case 14: { fnOnSend ('SYS:REMOTECODE=7A8559A6')  	} // Program Down

	case 32: { fnOnSend ('MAIN:CURSOR=Up') 	 	}
	case 33: { fnOnSend ('MAIN:CURSOR=Down') 	 }
	case 34: { fnOnSend ('MAIN:CURSOR=Left') 	 }
	case 35: { fnOnSend ('MAIN:CURSOR=Right') 	 }
	case 36: { fnOnSend ('MAIN:CURSOR=Sel') 	 }

	case 24:
	case 97: { fnSetVolUp() 	 }
	case 25:
	case 98: { fnSetVolDown() 	 }
	case 26:
	case 99: { fnSetVolMute() 	 }

	case 201: { fnSetSubTrim('+') 	}//sub +
	case 202: { fnSetSubTrim('-') 	}//sub -
	case 204: { fnSetEXBASS() 	 }
	case 205: { fnSetDIRMODE() 	 }
	case 206: { fnSetEnchancer() 	 }
	case 213: { fnOnSend ('SYS:REMOTECODE=7A8558A7')  	} // Program UP
	case 214: { fnOnSend ('SYS:REMOTECODE=7A8559A6')  	} // Program Down
	case 215: { fnSetTreble('+') 	}//treble +
	case 216: { fnSetTreble('-') 	}//treble -
	case 217: { fnSetBass('+') 	}//bass +
	case 218: { fnSetBass('-') 	}//bass -
	case 219: { fnSetPUREDIRMODE() 	 }
	case 220: { fnSetDIALOGUELVL('+') 	}//
	case 221: { fnSetDIALOGUELVL('-') 	}//
	case 222: { fnSetStraight() 	 }
	case 223: { fnSetYPAOVOL() 	 }
	
	case 234: { fnSetADAPTIVEDRC() 	 }
	case 235: { fnSetADAPTIVEDSP() 	 }
    }
}
/**
    Подсоединение
    на входе	:	in_dvDevice - устройство
			in_cIPAddr  - IP адрес устройства к которому нужно присоеденится
			in_m_lPort    - порт к которому нужно присоеденится
    на выходе	:	*
*/
define_function fnOnConnect(dev in_dvDevice, char in_cIPAddr[], long in_m_lPort)
{
    ip_client_open(in_dvDevice.port, in_cIPAddr, in_m_lPort, 1);
}

/**
    Отсоединение
    на входе	:	in_dvDevice - устройство
    на выходе	:	*
*/
define_function fnOnDisconnect(dev in_dvDevice)
{
    if(m_cIsConnect == 1)
    {
	ip_client_close(in_dvDevice.port)
	//m_cIsConnect = 0;
    }
}

/**
    Инициализация устройства
    на входе	:	*
    на выходе	:	*
*/
define_function fnOnInit()
{	
    fnGetBasicStatus()
    // создание таймера для поддержания соединения
    timeline_create(TL_PING_ID, m_laPing, 1, TIMELINE_ABSOLUTE, TIMELINE_REPEAT)
    
    m_lLastPingTime 	= m_lCurTime;
    m_lStartWaitTime	= m_lCurTime;
}

/**
    Деинициализация устройства
    на входе	:	*
    на выходе	:	*
*/
define_function fnOnDeInit()
{
    // остановка таймеров
    if(timeline_active(TL_PING_ID))
	timeline_kill(TL_PING_ID);
    
    m_lLastPingTime 	= m_lCurTime;
    m_lStartWaitTime	= m_lCurTime;
}

/**
    Пинг
    на входе	:	*
    на выходе	:	*
    примечание	: 	данная функция пердназначена для поддержания соединения
*/
define_function fnOnPing()
{
    if(m_cIsConnect == 1) {
	fnGetBasicStatus()
    }
}

define_function fnOnSend(char in_caData[])
{
    if(m_cIsConnect)	{
	//отправка данных
	send_string dvDevice, "'@',in_caData,13,10"
    }
}

define_function debug(char in_caData[])
{
    if(_debug)
	send_string 0, "in_caData"
}



define_function char[20] fnReturnDPS(dev in_dDevice)
{
    stack_var char dps[20]
    
    dps = "itoa(in_dDevice.number),':',itoa(in_dDevice.port),':', itoa(in_dDevice.system)"
    
    return dps
}

/**
    Обработка поддержания соединения с контроллером
    на входе	: *
    на выходе	: *
*/
define_function fnOnWork()
{
    stack_var long l_lTime
    
    if(m_cIsConnect == 0)
    {
	// обработка 
	l_lTime = m_lCurTime - m_lStartWaitTime
	if(l_lTime > 1000)
	{
	    send_string vdvDevice, "m_caDeviceName, ' [',fnReturnDPS(dvDevice),'] fnOnConnect(', in_caHost, ',', itoa(m_lPort), ')'"
	    fnOnConnect(dvDevice, in_caHost, m_lPort)
	    
	    m_cIsConnect = 2
	    m_lStartWaitTime = m_lCurTime
	}
    } else if(m_cIsConnect == 1)
    {
	l_lTime = m_lCurTime - m_lLastPingTime
	if(l_lTime > 6000)
	{
	    fnOnDisconnect(dvDevice)
	    send_string vdvDevice, "m_caDeviceName, ' [',fnReturnDPS(dvDevice),'] TIMEOUT!!!'"
	}
    } else if(m_cIsConnect == 2)
    {
	// обработка 
	l_lTime = m_lCurTime - m_lStartWaitTime
	if(l_lTime > 1000)
	{
	    send_string vdvDevice, "m_caDeviceName, ' [',fnReturnDPS(dvDevice),'] TIMEOUT, WAITING CONNECTION!!!'"
	    m_cIsConnect = 0
	    m_lStartWaitTime = m_lCurTime
	}
    }
}

define_function fnOnReceive(char in_caData[])
{
    //@MAIN:VOL=-31.0{0D}{0A}
    //@SYS:PWR=On @MAIN:PWR=Standby{0D}{0A}
    char l_caParam[20]
    char l_caValue[20]
    
    //убираем переаод строки
    set_length_string(in_caData, length_string(in_caData) - 2)
    
    if(find_string(in_caData, '@SYS:', 1)) {
	remove_string(in_caData, '@SYS:', 1)
	l_caParam = remove_string(in_caData, '=', 1)
	l_caValue = in_caData
	set_length_string(l_caParam, length_string(l_caParam) - 1)
	
	switch(l_caParam)
	{
	    case 'PWR': { YamahaYNCA.m_caSystemPower = l_caValue }
	}
    } else 
    if(find_string(in_caData, '@MAIN:', 1)) {
	remove_string(in_caData, '@MAIN:', 1)
	l_caParam = remove_string(in_caData, '=', 1)
	l_caValue = in_caData
	set_length_string(l_caParam, length_string(l_caParam) - 1)
	
	switch(l_caParam)
	{
	    case        'PWR': { YamahaYNCA.m_caMainPower = l_caValue }
	    case        'VOL': { 
				    if(YamahaYNCA.m_caVolume != l_caValue) {
					YamahaYNCA.m_caVolume = l_caValue
					YamahaYNCA.m_fVolume = atof(l_caValue) + 80.5
					send_level vdvDevice, 1, fnCONVERT(atof(YamahaYNCA.m_caVolume), -80, 10, 0, 255)
				    }
			       }
	    case       'MUTE': { 
				    YamahaYNCA.m_caMute = l_caValue 
				    YamahaYNCA.m_fMute = fnOnOffToValue(l_caValue) 
				    send_level vdvDevice, 2, YamahaYNCA.m_fMute
			       }
	    case   'STRAIGHT': { 
				    YamahaYNCA.m_caStraight = l_caValue 
				    YamahaYNCA.m_fStraight = fnOnOffToValue(l_caValue)
				    [vdvDevice, 122] = (l_caValue == 'On')
				}
	    case   'ENHANCER': { 
				    YamahaYNCA.m_caEnhancer = l_caValue 
				    YamahaYNCA.m_fEnhancer = fnOnOffToValue(l_caValue)
				    [vdvDevice, 106] = (l_caValue == 'On')
				}
	    case   'SOUNDPRG': { 
				    YamahaYNCA.m_caSound = l_caValue
				    send_string vdvDevice, "'SOUND_PROGRAM:', l_caValue"
				}
	    case   'TONEBASS': { 
				    YamahaYNCA.m_caBass = l_caValue
				    send_string vdvDevice, "'TONE_CONTROL_BASS:', l_caValue"
				}
	    case 'TONETREBLE': { 
				    YamahaYNCA.m_caTreble = l_caValue				    
				    send_string vdvDevice, "'TONE_CONTROL_TREBLE:', l_caValue"
				}
	    case   'SWFRTRIM': { 
				    YamahaYNCA.m_caSubTrim = l_caValue
				    //send_string vdvDevice, "'SUBWOOFER_VOLUME:', l_caValue"
				}
	    case'PUREDIRMODE': { 
				    YamahaYNCA.m_caPureDirectMode = l_caValue 
				    [vdvDevice, 119] = (l_caValue == 'On')
				}
	    case    'DIRMODE': { 
				    YamahaYNCA.m_caDirect = l_caValue 
				    [vdvDevice, 105] = (l_caValue == 'On')
				}
	    case    'YPAOVOL': { 
				    YamahaYNCA.m_caYpaoVolume = l_caValue
				    [vdvDevice, 123] = (l_caValue == 'Auto')
				}
	    case     'EXBASS': { 
				    YamahaYNCA.m_caExtraBass = l_caValue
				    [vdvDevice, 104] = (l_caValue == 'Auto')
				}
	    case'ADAPTIVEDRC': { 
				    YamahaYNCA.m_caAdaptiveDrc = l_caValue 
				    [vdvDevice, 125] = (l_caValue == 'Auto')
				    send_string vdvDevice, "'ADAPTIVE_DRC:', l_caValue"
				}
	    case'DIALOGUELVL': { 
				    YamahaYNCA.m_caDialogueLevel = l_caValue 
				    send_string vdvDevice, "'DIALOGUE_LEVEL:', l_caValue"
				}
	    case'ADAPTIVEDSP': { 
				    YamahaYNCA.m_caAdaptiveDsp = l_caValue 
				    [vdvDevice, 124] = (l_caValue == 'Auto')
				    send_string vdvDevice, "'ADAPTIVE_DSP:', l_caValue"
				}
	    case 'DECODERSEL': { 
				    YamahaYNCA.m_caDecoderSel = l_caValue 
				}
	    case   '3DCINEMA': { 
				    YamahaYNCA.m_ca3dCinema = l_caValue 
				    
				}
	    case'EXSURDECODER': { 
				    YamahaYNCA.m_caExSurDecoder = l_caValue 
				}
	}
    }
    fnCreateFb()
}

define_function integer fnOnOffToValue(char in_caValue[])
{
    if(in_caValue == 'On') return 1
    if(in_caValue == 'Off') return 0
}

define_function fnCreateFb()
{

}

DEFINE_FUNCTION float fnCONVERT(float oldNUM, float oldMIN, float oldMAX, float newMIN, float newMAX)
{
    float  oldSTEPS
    float  newSTEPS
    float  position1
    float  position2
    if(oldMIN<oldMAX && newMIN<newMAX && oldNUM>=oldMIN && oldNUM<=oldMAX) //  if everything is the way it should...
        {
            oldSTEPS=oldMAX-oldMIN // remember the number of steps in the old range
            newSTEPS=newMAX-newMIN // remember the number of steps in the new range
            position1=oldNUM-oldMIN  // get the position of the number in the old range
            position2=(position1*newSTEPS/oldSTEPS) // get the position of the number in the new range
            return (newMIN+position2)
       }
    else if(oldNUM<oldMIN)
       return newMIN
    else if(oldNUM>oldMAX)
       return newMAX
}

(***********************************************************)
(*                STARTUP CODE GOES BELOW                  *)
(***********************************************************)
DEFINE_START

create_buffer dvDevice, m_caBuffer
(***********************************************************)
(*                THE EVENTS GO BELOW                      *)
(***********************************************************)
DEFINE_EVENT

/**
    Обработчик таймера пинга
*/
TIMELINE_EVENT[TL_PING_ID]
{
    if(timeline.sequence == 1) {
	fnOnPing()
    }
}

/**
    Обработчик поддержания соединения
*/
TIMELINE_EVENT[TL_WORK_ID]
{
    if(timeline.sequence == 1) {
	m_lCurTime = m_lCurTime + m_laWork[1]
	fnOnWork()
    }
}

//обработка виртуального порта
data_event[vdvDevice]
{
    command:
    {
	stack_var 
	    char l_caReadData[MAX_RESP_LEN]
	    char l_caTemp[100]
	    char packet[MAX_RESP_LEN], l_caValue[10]
	    integer l_iRepeat, l_iChannel, l_iBuffer[2]
	    float l_fValue
	
	l_caReadData = Data.Text
	select
	{
	    active(find_string(l_caReadData, 'START;', 1) == 1):
	    {
		//  запуск потока для поддержания соединения
		if(m_cIsConnect == 0) 
		    fnOnConnect(dvDevice, in_caHost, m_lPort)
		
		timeline_create(TL_WORK_ID, m_laWork, 1, TIMELINE_ABSOLUTE, TIMELINE_REPEAT)
		send_string vdvDevice, "m_caDeviceName, ' [',fnReturnDPS(dvDevice),'] MODULE START'"
	    }
	    active(find_string(l_caReadData, 'STOP;', 1) == 1):
	    {
		fnOnDisconnect(dvDevice)
		// остановка потока для поддержания соединения
		timeline_kill(TL_WORK_ID)
		send_string vdvDevice, "m_caDeviceName, ' [',fnReturnDPS(dvDevice),'] MODULE STOP'"
	    }
	    active(find_string(l_caReadData, 'SET_POWER ON;', 1) == 1): 
	    { 
		fnPowerOn() 
	    }
	    active(find_string(l_caReadData, 'SET_POWER OFF;', 1) == 1):
	    {
		if(YamahaYNCA.m_caMainPower == 'On')
		    fnPowerOff()
	    }
	    active(find_string(l_caReadData, 'SET_INPUT', 1) == 1): //
	    {
		l_caTemp = remove_string(l_caReadData, 'SET_INPUT ', 1)
		//
		fnStr_GetStringWhile(l_caReadData, m_caInput, ';')
		
		fnSetInput()
	    }
	    active(find_string(l_caReadData, 'GET_STATUS;', 1) == 1): //
	    {
		fnGetBasicStatus()
		fnCreateFb()
	    }
	    active(find_string(l_caReadData, 'SET_VOLUME', 1) == 1): //
	    {
		remove_string(l_caReadData, 'SET_VOLUME ', 1)
		set_length_string(l_caReadData, length_string(l_caReadData) - 1)
		
		//conver range 0-255 to -80.5 - +16.5
		l_caValue = "format('%1.0f', fnCONVERT(atof(l_caReadData), 0, 255, -80, 10)),'.0'"
		
		if(YamahaYNCA.m_caVolume != l_caValue){
		    debug("'YNCA SET VOLUME:', l_caValue")
		    fnSetVolume(l_caValue)
		}
	    }
	    active(find_string(l_caReadData, 'SOUND_PROGRAM', 1)):
	    {
		remove_string(l_caReadData, 'SOUND_PROGRAM ', 1)
		fnOnSend("'MAIN:STRAIGHT=Off'")
		fnSetSoundProgram(l_caReadData)
	    }
	    active(find_string(l_caReadData, 'DEBUG ON;', 1)):
	    {
		_debug = 1
	    }
	    active(find_string(l_caReadData, 'DEBUG OFF;', 1)):
	    {
		_debug = 0
	    }
	}
    }
}
//обработка физического порта
data_event[dvDevice]
{
    online:
    {
	// инициализация соединения
	fnOnInit()
	//socket is online
	m_cIsConnect = 1
	//debug
	debug("m_caDeviceName, ' [', fnReturnDPS(dvDevice),'] :: Client is Online!!!'")
    }
    offline:
    {	    
	//отладка
	debug("m_caDeviceName, ' [', fnReturnDPS(dvDevice),'] :: Client is Offline!!!'")
	
	// инициализация соединения
	fnOnDeInit()
	
	// соединение прервано
	m_cIsConnect = 0
    }
    string:
    {
	stack_var char l_caData[MAX_RESP_LEN]
	// запомним время последнего пинга
	m_lLastPingTime = m_lCurTime
	//
	l_caData = remove_string(m_caBuffer, "13,10", 1)	
	
	while(length_string(l_caData))
	{
	    fnOnReceive(l_caData)
	    l_caData = remove_string(m_caBuffer, "13,10", 1)
	}
	
	// Handle any "leftovers" in the buffer
	if(length_array(m_caBuffer))
	    Wait 5 'wait_for_a_date'
		clear_buffer m_caBuffer;
    }
    onerror:
    {	
	debug("m_caDeviceName, ' [', fnReturnDPS(dvDevice),'] :: OnError(',itoa(data.number),')'")
	    
	switch(data.number)
	{
	    //две ошибки при которых не требуется переоткрытие сокета
	    case 9: // Socket closed in response to ip_client_close	
	    case 14: // Local port already used
	    {
	    }
	    default: //all others error. May want to re-try connection
	    {
	    
	    }
	}
    }
}


channel_event[vdvDevice, 0]
{
    on: 
    { 
	stack_var integer ch 
	
	ch = channel.channel
	
	cancel_wait 'drill'
	fnOnControl(ch)
	wait 5 'drill'
	do_push_timed(vdvDevice, channel.channel, 30)
    }
    off:
    {
	stack_var integer ch 
	
	ch = channel.channel

	cancel_wait 'drill'
	do_release(vdvDevice, ch)
    }
}

button_event[vdvDevice, 0]
{
    hold[1.2, repeat]:
    {
	stack_var integer ch	
	ch = button.input.channel
	
	fnOnControl(ch)
    }
    release:
    {
	stack_var integer ch	
	ch = button.input.channel
	
    }
}

(***********************************************************)
(*            THE ACTUAL PROGRAM GOES BELOW                *)
(***********************************************************)
DEFINE_PROGRAM

/*
TUNER
MULTI CH
PHONO
AV1
AV2
AV3
AV4
AV5
AV6
AV7
V-AUX
AUDIO1
AUDIO2
AUDIO3
AUDIO4
NET
Napster
SERVER
NET RADIO
USB
iPod (USB)
AirPlay
*/

(***********************************************************)
(*                     END OF PROGRAM                      *)
(*        DO NOT PUT ANY CODE BELOW THIS COMMENT           *)
(***********************************************************)
