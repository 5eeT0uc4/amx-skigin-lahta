MODULE_NAME='SNMP_Module' (dev vdvDevice, dev dvDevice, char m_caHost[])

#include 'Strings.axi'

DEFINE_DEVICE

(***********************************************************)
(*               CONSTANT DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_CONSTANT

_debug = 0
m_iPort = 161

(***********************************************************)
(*              DATA TYPE DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_TYPE

(***********************************************************)
(*               VARIABLE DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_VARIABLE

volatile char		m_cIsConnect		= 0	// флаг соединения

/*
 19,20,21,22 - request id
 49 - outlet address
 52 - value
*/
volatile char m_caPacket[52]	=   {
				    $30,$32,$02,$01,$00,$04,
				    $06,$70,$75,$62,$6C,$69,$63,$A3,$25,$02,$04,$73,$DB,$72,$2D,$02, //22
				    $01,$00,$02,$01,$00,$30,$17,$30,$15,$06,$10,$2B,$06,$01,$04,$01, //38
				    $82,$3E,$01,$01,$0C,$03,$03,$01,$01,$04,$01,$02,$01,$01 // 52
				    }

(***********************************************************)
(*               LATCHING DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_LATCHING

(***********************************************************)
(*       MUTUALLY EXCLUSIVE DEFINITIONS GO BELOW           *)
(***********************************************************)
DEFINE_MUTUALLY_EXCLUSIVE


define_function fnSetOutletState(integer in_cOutlet, integer in_cState)
{
    local_var
	char packet[100]
	
    packet = m_caPacket
    
    packet[49] = in_cOutlet
    packet[52] = in_cState
    
    fnOnSend(packet)
}

define_function fnOnSend(char in_caData[])
{
    if(m_cIsConnect)	{
	//отправка данных
	send_string dvDevice, in_caData
	printf("'Send SNMP Packet - ', in_caData")
    } else {
	fnOnConnect(dvDevice, m_caHost, m_iPort)
	send_string dvDevice, in_caData
	printf("'Send SNMP Packet - ', in_caData")
    }
}

/**
    Подсоединение
    на входе	:	in_dvDevice - устройство
			in_cIPAddr  - IP адрес устройства к которому нужно присоеденится
			in_iPort    - порт к которому нужно присоеденится
    на выходе	:	*
*/
define_function fnOnConnect(dev in_dvDevice, char in_cIPAddr[], long in_iPort)
{
    ip_client_open(in_dvDevice.port, in_cIPAddr, in_iPort, IP_UDP_2WAY);
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
    }
}

define_function printf(char in_caData[])
{
    if(_debug)
	send_string 0, "in_caData"
}


DEFINE_START


(***********************************************************)
(*                THE EVENTS GO BELOW                      *)
(***********************************************************)
DEFINE_EVENT

data_event[vdvDevice]
{
    command:
    {
	local_var char l_caData[100]
	    local_var char l_caTemp[100]
	    local_var integer l_iaTemp[10]
	    local_var integer count
	
	l_caData = data.text
	
	if(find_string(l_caData, 'START;', 1) == 1) {
	    fnOnConnect(dvDevice, m_caHost, m_iPort)
	} else
	if(find_string(l_caData, 'STOP;', 1) == 1) {
	    fnOnDisconnect(dvDevice)
	} else
	if(find_string(l_caData, 'SET_OUTLET', 1) == 1) {
	    l_caTemp = remove_string(l_caData, 'SET_OUTLET ', 1)
	    count = fnGetArray(l_caData, l_iaTemp, ',')
	    
	    if(count == 2)
		fnSetOutletState( l_iaTemp[1], l_iaTemp[2])
	}
    }
}

data_event[dvDevice]
{
    online: 	
    {
	send_string 0, "'UDP Client ONLINE'"
	m_cIsConnect = 1
    }
    offline: 	
    {
	send_string 0, "'UDP Client OFFLINE'"
	m_cIsConnect = 0
    }
    string:
    {
	send_string 0, "'UDP Client String - ', data.text"
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
