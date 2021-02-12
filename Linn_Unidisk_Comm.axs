MODULE_NAME='Linn_Unidisk_Comm' (dev vdvDevice, dev dvDevice)
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
#include 'StreamBuffer.axi'	// потоковый буфер

DEFINE_DEVICE


(***********************************************************)
(*               CONSTANT DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_CONSTANT

_debug = 0

tl_ping_id 		= $A1 //идентификатор пинга
tl_volume_id		= $A2
tl_init_id		= $A3
tl_source_id		= $A4

true			= 1
false			= 0

(***********************************************************)
(*              DATA TYPE DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_TYPE

(***********************************************************)
(*               VARIABLE DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_VARIABLE

volatile StreamBuffer 	m_sbInputBuffer		// промежуточный входящий буфер

volatile integer	m_iPower_State 		= 0
volatile char		m_caInput[10] 		= ''

volatile integer 	m_iVolume		= 0
volatile integer	m_iMute			= 0
volatile char		m_caVolume[10]		= ''
volatile char		m_caVolume_Control[10]	= ''

volatile long 		m_laPing[2]		= { 4000, 4700 } 	// промежуток времени через который производится пинг
volatile long 		m_laVolumeTL[]		= { 300 }
volatile long		m_laInitTL[4]		= { 1000, 1500, 2000, 2500 }
volatile long		m_laSourceTL[3]		= { 1, 1000, 4000 }

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

//отдадка
/**

*/
define_function printf(char in_caData[])
{
    if(_debug) send_string 0, "in_caData"
}

define_function fnOpen()		{ send_string dvDevice, "'$OPEN$', $0D,$0A"		}
define_function fnClose()		{ send_string dvDevice, "'$CLOSE$', $0D,$0A"		}
define_function fnPlay()		{ send_string dvDevice, "'$PLAY$', $0D,$0A"		}
define_function fnStop()		{ send_string dvDevice, "'$STOP$', $0D,$0A"		}
define_function fnPause()		{ send_string dvDevice, "'$PAUSE$', $0D,$0A"		}
define_function fnTrack_Plus()		{ send_string dvDevice, "'$TRACK +$', $0D,$0A"		}
define_function fnTrack_Minus()		{ send_string dvDevice, "'$TRACK -$', $0D,$0A"		}
define_function fnChapter_Plus()	{ send_string dvDevice, "'$CHAPTER +$', $0D,$0A"	}
define_function fnChapter_Minus()	{ send_string dvDevice, "'$CHAPTER -$', $0D,$0A"	}
define_function fnSearch_2x_ff()	{ send_string dvDevice, "'$SEARCH > 2X$', $0D,$0A"	}
define_function fnSearch_4x_ff()	{ send_string dvDevice, "'$SEARCH > 4X$', $0D,$0A"	}
define_function fnSearch_6x_ff()	{ send_string dvDevice, "'$SEARCH > 6X$', $0D,$0A"	}
define_function fnSearch_8x_ff()	{ send_string dvDevice, "'$SEARCH > 8X$', $0D,$0A"	}
define_function fnSearch_2x_rw()	{ send_string dvDevice, "'$SEARCH < 2X$', $0D,$0A"	}
define_function fnSearch_4x_rw()	{ send_string dvDevice, "'$SEARCH < 4X$', $0D,$0A"	}
define_function fnSearch_6x_rw()	{ send_string dvDevice, "'$SEARCH < 6X$', $0D,$0A"	}
define_function fnSearch_8x_rw()	{ send_string dvDevice, "'$SEARCH < 8X$', $0D,$0A"	}
define_function fnSkip_Plus()		{ send_string dvDevice, "'$SKIP +$', $0D,$0A"		}
define_function fnSkip_Minus()		{ send_string dvDevice, "'$SKIP -$', $0D,$0A"		}
define_function fnUP()			{ send_string dvDevice, "'$KEY UP$', $0D,$0A"		}
define_function fnDown()		{ send_string dvDevice, "'$KEY DOWN$', $0D,$0A"		}
define_function fnLeft()		{ send_string dvDevice, "'$KEY LEFT$', $0D,$0A"		}
define_function fnRight()		{ send_string dvDevice, "'$KEY RIGHT$', $0D,$0A"	}
define_function fnEnter()		{ send_string dvDevice, "'$KEY ENTER$', $0D,$0A"	}
define_function fnAudio()		{ send_string dvDevice, "'$KEY AUDIO$', $0D,$0A"	}
define_function fnSubtitle()		{ send_string dvDevice, "'$KEY SUBTITLE$', $0D,$0A"	}
define_function fnTitle()		{ send_string dvDevice, "'$MENU TITLE$', $0D,$0A"	}
define_function fnMenu_DVD()		{ send_string dvDevice, "'$MENU DVD$', $0D,$0A"		}
define_function fnPower_Off()		{ send_string dvDevice, "'$STANDBY ON$', $0D,$0A"	}
define_function fnPower_On()		{ send_string dvDevice, "'$STANDBY OFF$', $0D,$0A"	} 
define_function fnGetPower()		{ send_string dvDevice, "'$STANDBY ?$', $0D,$0A"	}
//
define_function fnListen(char in_caInput[])	
{ 
    send_string dvDevice, "'$LISTEN ', in_caInput,'$', $0D,$0A"
}

define_function fnListen_Disc()				{ send_string dvDevice, "'$LISTEN DISC$', $0D,$0A"	}
define_function fnListen_Dig1()				{ send_string dvDevice, "'$LISTEN DIG1$', $0D,$0A"	}
define_function fnListen_Dig2()				{ send_string dvDevice, "'$LISTEN DIG2$', $0D,$0A"	}
define_function fnListen_Dig3()				{ send_string dvDevice, "'$LISTEN DIG3$', $0D,$0A"	}
define_function fnListen_Dig4()				{ send_string dvDevice, "'$LISTEN DIG4$', $0D,$0A"	}
define_function fnListen_AUX1()				{ send_string dvDevice, "'$LISTEN AUX1$', $0D,$0A"	}
define_function fnListen_AUX2()				{ send_string dvDevice, "'$LISTEN AUX2$', $0D,$0A"	}
define_function fnListen_TV()				{ send_string dvDevice, "'$LISTEN TV$', $0D,$0A"	}
define_function fnListen_VCR()				{ send_string dvDevice, "'$LISTEN VCR$', $0D,$0A"	}
define_function fnList_Main()				{ send_string dvDevice, "'$LISTEN MAIN$', $0D,$0A"	}
define_function fnGetListen()				{ send_string dvDevice, "'$LISTEN ?$', $0D,$0A"		}
define_function fnMute_On()				{ send_string dvDevice, "'$MUTE ON$', $0D,$0A"		}
define_function fnMute_Off()				{ send_string dvDevice, "'$MUTE OFF$', $0D,$0A"		}
define_function fnGetMute()				{ send_string dvDevice, "'$MUTE ?$', $0D,$0A"		}
define_function fnGetVolume()				{ send_string dvDevice, "'$VOLUME ?$', $0D,$0A"		}
define_function fnVolume_Plus()				{ send_string dvDevice, "'$VOLUME +3$', $0D,$0A"			}
define_function fnVolume_Minus()			{ send_string dvDevice, "'$VOLUME -3$', $0D,$0A"			}
define_function fnVolume(integer in_iVal)		{ send_string dvDevice, "'$VOLUME =', itoa(in_iVal),'$', $0D,$0A"		}
define_function fnVolume_Plus_V(integer in_iVal)	{ send_string dvDevice, "'$VOLUME -', itoa(in_iVal),'$', $0D,$0A"		}
define_function fnVolume_Minus_V(integer in_iVal)	{ send_string dvDevice, "'$VOLUME +', itoa(in_iVal),'$', $0D,$0A"	}

define_function fnSurround(char in_caData[])
{
    send_string dvDevice, "'$SURROUND ', in_caData,'$', $0D,$0A"
}
define_function fnPLII(char in_caData[])
{
    send_string dvDevice, "'$PROLOGICII ', in_caData,'$', $0D,$0A"
}

define_function fnSURR_Plus()				{ send_string dvDevice, "'$SURROUND +$', $0D,$0A"		}
define_function fnSURR_Minus()				{ send_string dvDevice, "'$SURROUND -$', $0D,$0A"		}
define_function fnSURR_Stereo()				{ send_string dvDevice, "'$SURROUND STEREO$', $0D,$0A"		}
define_function fnSURR_StereoSub()			{ send_string dvDevice, "'$SURROUND STEREOSUB$', $0D,$0A"	}
define_function fnSURR_3Stereo()			{ send_string dvDevice, "'$SURROUND 3STEREO$', $0D,$0A"		}
define_function fnSURR_Phantom()			{ send_string dvDevice, "'$SURROUND PHANTOM$', $0D,$0A"		}
define_function fnSURR_ASMIX()				{ send_string dvDevice, "'$SURROUND ASMIX$', $0D,$0A"		}
define_function fnSURR_DTS()				{ send_string dvDevice, "'$SURROUND DTSFULL$', $0D,$0A"		}
define_function fnPLII_Minus()				{ send_string dvDevice, "'$PROLOGICII -$', $0D,$0A"		}
define_function fnPLII_Plus()				{ send_string dvDevice, "'$PROLOGICII +$', $0D,$0A"		}
define_function fnPLII_PL()				{ send_string dvDevice, "'$PROLOGICII PROLOGIC$', $0D,$0A"	}
define_function fnPLII_Music()				{ send_string dvDevice, "'$PROLOGICII MUSIC$', $0D,$0A"		}
define_function fnPLII_Movie()				{ send_string dvDevice, "'$PROLOGICII MOVIE$', $0D,$0A"		}
define_function fnPLII_Matrix()				{ send_string dvDevice, "'$PROLOGICII MATRIX$', $0D,$0A"	}

define_function fnOnInit()
{
    if(timeline_active(tl_init_id)) {
	timeline_kill(tl_init_id)
	timeline_create(tl_init_id, m_laInitTL, 4, timeline_absolute, timeline_once)
    } else {
	timeline_create(tl_init_id, m_laInitTL, 4, timeline_absolute, timeline_once)
    }
}

define_function fnSetBaud()
{
    send_command dvDevice, "'SET BAUD 9600,E,7,1 485 DISABLE'"
}

define_function fnSetRS232_Event_On()
{
    send_string dvDevice, "'$OPTION RS232_EVENTS ON$', $0D,$0A"
}

define_function fnSetRS232_Start_Up_Mesage()
{
    send_string dvDevice, "'$OPTION RS232_STARTUP_MESSAGE ON$', $0D,$0A"
}

define_function fnOnPing()
{
    if(timeline_active(tl_ping_id)) {
	timeline_kill(tl_ping_id)
	timeline_create(tl_ping_id, m_laPing, 2, timeline_absolute, timeline_repeat)
    } else {
	timeline_create(tl_ping_id, m_laPing, 2, timeline_absolute, timeline_repeat)
    }
}

define_function fnSelectSource(char in_iSource[])
{
    if(timeline_active(tl_source_id)) {
	timeline_kill(tl_source_id)
	timeline_create(tl_source_id, m_laSourceTL, 3, timeline_absolute, timeline_once)
    } else {
	timeline_create(tl_source_id, m_laSourceTL, 3, timeline_absolute, timeline_once)
    }
}
/**

*/

define_function fnOnCommand(char in_caCommand[])
{
    stack_var char packet[16], l_caInput[16], l_caTemp[16], l_caVolume[16]
    //отдадка
    printf("'Unidisk_SC onCommand :: ', in_caCommand")
    
    if(find_string(in_caCommand, 'START;', 1) == 1)
    {	
	fnOnInit()
	
	printf('Unidisk_SC Communication START!!!')
    } else
    if(find_string(in_caCommand, 'STOP;', 1) == 1)
    {
	if(timeline_active(tl_ping_id))
	    timeline_kill(tl_ping_id)
	    
	printf('Unidisk_SC Communication STOP!!!')
    } else
    if(find_string(in_caCommand, 'SET_POWER ON;', 1) == 1)
    {
	fnPower_On()
    } else
    if(find_string(in_caCommand, 'SET_POWER OFF;', 1) == 1)
    {
	fnPower_Off()
    } else
    if(find_string(in_caCommand, 'SET_INPUT', 1) == 1)
    {
	l_caTemp = remove_string(in_caCommand, 'SET_INPUT ', 1)
	    
	fnStr_GetStringWhile(in_caCommand, m_caInput, ';')
	
	//if(m_iPower_State) {
	    //fnListen(m_caInput)
	//} else {
	    fnSelectSource(m_caInput)
	//}
    } else
    if(find_string(in_caCommand, 'SET_VOLUME', 1) == 1)
    {
	//
	l_caTemp = remove_string(in_caCommand, 'SET_VOLUME ', 1)
	
	fnStr_GetStringWhile(in_caCommand, l_caVolume, ';')
	//
	if( l_caVolume == 'UP')
	{
	    m_caVolume_Control = l_caVolume
	    
	    if(timeline_active(tl_volume_id)) {
		timeline_kill(tl_volume_id)
		timeline_create(tl_volume_id, m_laVolumeTL, 1, timeline_absolute, timeline_repeat)
	    } else {
		timeline_create(tl_volume_id, m_laVolumeTL, 1, timeline_absolute, timeline_repeat)
	    }
	} else
	if( l_caVolume == 'DOWN') {
	    
	    m_caVolume_Control = l_caVolume
	    
	    if(timeline_active(tl_volume_id)) {
		timeline_kill(tl_volume_id)
		timeline_create(tl_volume_id, m_laVolumeTL, 1, timeline_absolute, timeline_repeat)
	    } else {
		timeline_create(tl_volume_id, m_laVolumeTL, 1, timeline_absolute, timeline_repeat)
	    }
	} else
	if( l_caVolume == 'STOP') {
	    
	    m_caVolume_Control = l_caVolume
	    
	    if(timeline_active(tl_volume_id)) {
		timeline_kill(tl_volume_id)
	    }
	}
    } else
    if(find_string(in_caCommand, 'SET_MUTE', 1) == 1)
    {
	//
	l_caTemp = remove_string(in_caCommand, 'SET_MUTE ', 1)
	
	fnStr_GetStringWhile(in_caCommand, l_caVolume, ';')
	//
	if( l_caVolume == 'ON')
	{
	    fnMute_On()
	}
	if( l_caVolume == 'OFF')
	{
	    fnMute_Off()
	}
	if( l_caVolume == 'TOGGLE')
	{
	    if(m_iMute)
		fnMute_Off()
	    else
		fnMute_On()
	}
    } else
    if(find_string(in_caCommand, 'SET_SURROUND', 1) == 1)
    {
	l_caTemp = remove_string(in_caCommand, 'SET_SURROUND ', 1)
	    
	fnStr_GetStringWhile(in_caCommand, l_caInput, ';')
	
	fnSurround(l_caInput)
    } else
    if(find_string(in_caCommand, 'SET_PROLOGIC', 1) == 1)
    {
	l_caTemp = remove_string(in_caCommand, 'SET_PROLOGIC ', 1)
	    
	fnStr_GetStringWhile(in_caCommand, l_caInput, ';')
	
	fnPLII(m_caInput)
    } else
    if(find_string(in_caCommand,'~RxData: *', 1) == 1){
	//
	l_caTemp = remove_string(in_caCommand, '~RxData: *', 1)
	
	if(fnSB_Add(m_sbInputBuffer, in_caCommand))
	{
	    // обработка полученых данных
	    while(1)
	    {
		if(fnOnReceive(m_sbInputBuffer) == false)
		    break
	    }
	} else
	{
	    // переполнение буфера
	    send_string vdvDevice, "'Buffer overflow!'"

	    // сброс данных буфера
	    fnSB_Reset(m_sbInputBuffer)
	}
    }
}

define_function char fnOnReceive(StreamBuffer in_sbBuffer)
{
    stack_var char l_caTemp[128]
    
    fnSB_Find(in_sbBuffer, '!$', true)
    
    fnSB_GetStringWhile(in_sbBuffer, l_caTemp, $0A)
    
    printf("'in_sbBuffer :: > ', l_caTemp")
    /*
    if(find_string(l_caTemp, 'STANBY ON', 1) == 1) {
	//
	m_iPower_State = 0
	// сдвиг буфера
	fnSB_Shift(in_sbBuffer)
	//
	return true
    } else
    if(l_caTemp == 'STANBY OFF') {
	//
	m_iPower_State = 1
	// сдвиг буфера
	fnSB_Shift(in_sbBuffer)
	//
	return true
    }
    */
}

define_function fnOnData(char in_caData[])
{
    stack_var char l_caTemp[128]

    select
    {
	active(find_string(in_caData, '!$STANBY ON$', 1) == 1):		{ m_iPower_State = 0 }
	active(find_string(in_caData, '!$STANBY OFF$', 1) == 1):	{ m_iPower_State = 1 }
	active(find_string(in_caData, '!$VOLUME', 1) == 1):	
	{
	    l_caTemp = remove_string(in_caData, '!$VOLUME ', 1)
	    
	    fnStr_GetStringWhile(in_caData, m_caVolume, '$')
	    
	    m_iVolume = atoi(m_caVolume)
	}
	active(find_string(in_caData, '!$MUTE ON$', 1) == 1):		{ m_iMute = 1 }
	active(find_string(in_caData, '!$MUTE OFF$', 1) == 1):		{ m_iMute = 0 }
    }
}

(***********************************************************)
(*                STARTUP CODE GOES BELOW                  *)
(***********************************************************)
DEFINE_START

// Инициализация потокового буфера
fnSB_Reset(m_sbInputBuffer)

(***********************************************************)
(*                THE EVENTS GO BELOW                      *)
(***********************************************************)
DEFINE_EVENT

timeline_event[tl_ping_id]
{
    switch(timeline.sequence)
    {
	case 1:	{ fnGetPower() }
	case 2: { if(m_iPower_State) fnGetVolume() }
    }
}

timeline_event[tl_source_id]
{
    switch(timeline.sequence)
    {
	case 1: fnListen(m_caInput)	break;
	case 2: fnPower_On()		break;
	case 3: fnListen(m_caInput)	break;
    }
/*
    if(timeline.sequence == 1)
    {
	if(m_iPower_State)
	    fnListen(m_caInput)
	else
	    fnPower_On()
    }
    if(timeline.sequence == 2)
    {
	if(m_iPower_State)
	    fnListen(m_caInput)
	else
	    fnSelectSource(m_caInput)
    }
*/
}

timeline_event[tl_init_id]
{
    switch(timeline.sequence)
    {
	case 1: fnSetBaud()
	case 2: fnSetRS232_Start_Up_Mesage()
	case 3: fnSetRS232_Event_On()
	case 4: fnOnPing()
    }
}

timeline_event[tl_volume_id]
{
    switch(timeline.sequence)
    {
	case 1: //
	{
	    switch(m_caVolume_Control)
	    {
		case 'UP':	fnVolume_Plus()			break;
		case 'DOWN':	fnVolume_Minus()		break;
		case 'STOP': 	timeline_kill(tl_volume_id)	break;
	    }
	}
	/*
	case 2: //
	{
	    switch(m_caVolume_Control)
	    {
		case 'UP': 	fnVolume_Plus()			break;
		case 'DOWN': 	fnVolume_Minus()		break;
		case 'STOP': 	timeline_kill(tl_volume_id)	break;
	    }
	}
	case 3: //
	{
	    switch(m_caVolume_Control)
	    {
		case 'UP': 	fnVolume_Plus()			break;
		case 'DOWN': 	fnVolume_Minus()		break;
		case 'STOP': 	timeline_kill(tl_volume_id)	break;
	    }
	}
	case 4: //
	{
	    switch(m_caVolume_Control)
	    {
		case 'UP': 	fnVolume_Plus()			break;
		case 'DOWN': 	fnVolume_Minus()		break;
		case 'STOP': 	timeline_kill(tl_volume_id)	break;
	    }
	}
	case 5: //
	{
	    switch(m_caVolume_Control)
	    {
		case 'UP': 	fnVolume_Plus()			break;
		case 'DOWN': 	fnVolume_Minus()		break;
		case 'STOP': 	timeline_kill(tl_volume_id)	break;
	    }
	}
	case 6: //
	{
	    switch(m_caVolume_Control)
	    {
		case 'UP': 	fnVolume_Plus()			break;
		case 'DOWN': 	fnVolume_Minus()		break;
		case 'STOP': 	timeline_kill(tl_volume_id)	break;
	    }
	}
	case 7:
	{
	    //возврвщаемся назад
	    timeline_pause(tl_volume_id)
	    timeline_set(tl_volume_id, m_laVolumeTL[6] - 1)
	    timeline_restart(tl_volume_id)
	}
	*/
    }
}

data_event[dvDevice]
{
    online:
    {
	send_command dvDevice, "'SET BAUD 9600,E,7,1 485 DISABLE'"
    }
    string:
    {
	stack_var char l_caReadData[128]
	
	l_caReadData = data.text
	/*
	// добавление полученых данных в буфер
	if(fnSB_Add(m_sbInputBuffer, data.text))
	{
	    // обработка полученых данных
	    while(1)
	    {
		if(fnOnData(m_sbInputBuffer) == false)
		    break
	    }
	} else
	{
	    // переполнение буфера
	    send_string vdvDevice, "'Buffer overflow!'"

	    // сброс данных буфера
	    fnSB_Reset(m_sbInputBuffer)
	}
	*/
	//fnOnData(l_caReadData)
    }
    command:
    {
	
    }
}
data_event[vdvDevice]
{
    command:
    {
	stack_var char l_caReadData[128]
	
	l_caReadData = data.text
	
	fnOnCommand(l_caReadData)
    }
}

channel_event[vdvDevice, 0]
{
    on:
    {
	stack_var integer l_iChannel
	
	l_iChannel = channel.channel
	
	switch(l_iChannel)
	{
	    case 1: fnPlay()
	    case 2: fnStop()
	    case 3: fnPause()
	    case 4: fnSkip_Plus()
	    case 5: fnSkip_Minus()
	    case 6: fnSearch_4x_ff()
	    case 7: fnSearch_4x_rw()
	    case 8: fnMenu_DVD()
	    case 9: fnTitle()
	    case 32: fnUP()
	    case 33: fnDown()
	    case 34: fnLeft()
	    case 35: fnRight()
	    case 36: fnEnter()
	    case 41: fnAudio()
	    case 42: fnSubtitle()
	    case 97: {
		fnVolume_Plus() 
		send_command vdvDevice, 'SET_VOLUME UP;'
	    }
	    case 98: {
		fnVolume_Minus()
		send_command vdvDevice, 'SET_VOLUME DOWN;'
	    }
	    case 99: send_command vdvDevice, 'SET_MUTE TOGGLE;'
	    case 101: fnSURR_Stereo()
	    case 102: fnSURR_StereoSub()
	    case 103: fnSURR_3Stereo()
	    case 104: fnSURR_ASMIX()
	    case 105: fnSURR_DTS()
	    case 106: fnSURR_Phantom()
	}
    }
    off:
    {
	stack_var integer l_iChannel
	
	l_iChannel = channel.channel
	
	switch(l_iChannel)
	{
	    case 97:
	    case 98:
		send_command vdvDevice, 'SET_VOLUME STOP;'
	}
    }
}

(***********************************************************)
(*            THE ACTUAL PROGRAM GOES BELOW                *)
(***********************************************************)
DEFINE_PROGRAM

(***********************************************************)
(*                     END OF PROGRAM                      *)
(*        DO NOT PUT ANY CODE BELOW THIS COMMENT           *)
(***********************************************************)
