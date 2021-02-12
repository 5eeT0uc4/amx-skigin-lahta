MODULE_NAME='ATLONA_AT_PRO2HD1616' (dev vdvDevice, 
				    dev dvDevice,
				    dev vdvRS_Ports[],
				    char BaudParam[][])
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
DEFINE_DEVICE

(***********************************************************)
(*               CONSTANT DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_CONSTANT

TL_Ping = $D1
powerOnTime = 300
(***********************************************************)
(*              DATA TYPE DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_TYPE

(***********************************************************)
(*               VARIABLE DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_VARIABLE

volatile integer m_iState = 0
volatile integer _in = 0
volatile integer _out = 0
volatile long m_laPing[1] = {10000}
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

/**
    Получение набора параметров из строки
    на входе	:	in_caString	- указатель на строку откуда извлеч значения
			in_iaBuffer	- указатель на буфер куда нужно сложить значения
			in_caDel	- разделитель
    на выходе	:	количество параметров
*/
define_function integer fnGetArray(char in_caString[], integer in_iaBuffer[], char in_caDel[])
{
    stack_var integer l_iCount, i
    stack_var char l_bRun
    
    l_iCount = 0
    l_bRun = 1
    
    while(l_bRun)
    {
	l_iCount++
	
	in_iaBuffer[l_iCount] = TYPE_CAST(atoi(in_caString))
	
	if(find_string(in_caString, in_caDel, 1) != 0)
	    remove_string(in_caString, in_caDel, 1)
	else
	    l_bRun = 0
    }
	
    return l_iCount
}

define_function fnSend(char in_caData[])
{
    fnOnInit();
    send_string dvDevice, "in_caData, 13, 10"
}

define_function fnAtlona(integer in_iIn, integer in_iOut)
{
	fnSend( "'x', itoa(in_iIn), 'AVx', itoa(in_iOut)")
}

define_function fnRS232_Send(integer in_iPort, char in_caData[])
{
    //send string to destination port
    
}

define_function fnOnPing()
{
    fnSend('PWSTA')
}

define_function fnOnInit()
{/*
    if(timeline_active(TL_Ping)) {
	timeline_kill(TL_Ping)
	TIMELINE_CREATE(TL_Ping, m_laPing, 1, timeline_absolute, timeline_repeat)
    } else {
	TIMELINE_CREATE(TL_Ping, m_laPing, 1, timeline_absolute, timeline_repeat)
    }*/
}
define_function fnOnRecieve(char in_caData[])
{
    if(find_string(in_caData, 'PWOFF', 1) == 1) {
	m_iState = 0;
    } else
    if(find_string(in_caData, 'PWON', 1) == 1) {
	wait powerOnTime
	    m_iState = 1;
    } else
    if(find_string(in_caData, 'HDMI Matrix Switch', 1)) {
	//wait 50 'HDMI Matrix Switch'
	//fnOnPing()
    }
}
//Line    894 (17:55:02):: String From [5001:1:1]-[******$0D$0A  AT-PRO2HD1616 HDMI Matrix Switch$0D$0A  HDMI over Cat5e/6/]

(***********************************************************)
(*                STARTUP CODE GOES BELOW                  *)
(***********************************************************)
DEFINE_START

(***********************************************************)
(*                THE EVENTS GO BELOW                      *)
(***********************************************************)
DEFINE_EVENT

timeline_event[TL_Ping]
{
    fnOnPing();
}

data_event[dvDevice]
{
    online: 
    {	
	send_command dvDevice, "'SET BAUD 115200,N,8,1 485 DESABLE'"
	wait 5
	fnOnPing()
	wait 15 {
	    if(m_iState) {
		    fnSend("'RS232para10[', BaudParam[10], ']'")
		    wait 5
		    fnSend("'RS232para2[', BaudParam[2], ']'")
		    wait 10
		    fnSend("'RS232para11[', BaudParam[11], ']'")
	    } else {
		wait_until ([vdvDevice, 255]) 'powerOn' { 
		    fnSend("'RS232para10[', BaudParam[10], ']'")
		    wait 5
		    fnSend("'RS232para2[', BaudParam[2], ']'")
		    wait 10
		    fnSend("'RS232para11[', BaudParam[11], ']'")
		}
	    }
	}
    }
    string:
    {
	stack_var char l_caData[128]
	
	l_caData = data.text
	
	fnOnRecieve(l_caData)
    }
}

data_event[vdvDevice]
{
    command:
    {
	stack_var char l_caReadData[100], l_caTmp[100]
	stack_var integer l_iaBuffer[10], l_iCount
	
	l_caReadData = Data.Text
	
	select
	{
	    active(find_string(l_caReadData, 'START;', 1)):
	    {
		fnOnInit();
	    }
	    active(find_string(l_caReadData, 'SET_INPUT', 1)): //SET_INPUT <in>,<out>;
	    {
		l_iCount = fnGetArray(l_caReadData, l_iaBuffer, ',')
		
		_in = l_iaBuffer[1];
		_out = l_iaBuffer[2];
		
		if(m_iState) {
		    if(l_iCount == 2)
			fnAtlona(_in, _out)
		} else {
		    cancel_all_wait
		    cancel_all_wait_until
		    
		    fnSend('PWON');
		    
		    wait_until ([vdvDevice, 255]) 'wait_atlona' {
			send_command vdvDevice, "'SET_INPUT ',itoa(_in),',',itoa(_out),';'"
		    }
		}
	    }
	    active(find_string(l_caReadData, 'SET_POWER OFF;', 1)):
	    {
		fnSend('PWOFF');
	    }
	    active(find_string(l_caReadData, 'SET_POWER ON;', 1)):
	    {
		fnSend('PWON');
	    }
	}
    }
}

data_event[vdvRS_Ports]
{
    online:
    {
	
    }
    command:
    {
	
    }
    string:
    {
	stack_var
	    char l_caData[100]
	    integer l_iPort
	    
	l_caData = data.text
	
	l_iPort = get_last(vdvRS_Ports)
	
	fnSend("'RS232zone', ITOA(l_iPort), '[', l_caData,']'")
    }
}
(***********************************************************)
(*            THE ACTUAL PROGRAM GOES BELOW                *)
(***********************************************************)
DEFINE_PROGRAM

[vdvDevice, 255] = (m_iState == 1)

(***********************************************************)
(*                     END OF PROGRAM                      *)
(*        DO NOT PUT ANY CODE BELOW THIS COMMENT           *)
(***********************************************************)
