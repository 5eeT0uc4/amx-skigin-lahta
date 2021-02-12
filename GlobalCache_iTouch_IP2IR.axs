MODULE_NAME='GlobalCache_iTouch_IP2IR' (dev vdvDevice[],
					dev dvDevice, 
					char caHost[], integer in_iShift[])
/*
������ ���������� GlobalCache IP2IR ����� iTouch
    
    �� ���� ���������� ���������� �������������� ���������� ������
    1-� ���� 
    2-� ���� 
    3-� ���� 
    
    1. ���������� ������ define_module 'module name' (<p1>,<p2>,<p3>)
	p1 - ����������� ����� ����������
	p2 - ���������� ����� ����������
	p3 - IP ����� ����������
	// p4 - MAC address
    2. ������� ���� ��-������ ��������� � ����� GC_Command_db.
	�������� ��������� � ���� ������� �� 998 ��������� (������). ������ �� c����� �����������, �� �������
	�������� �������� � ��������.
    3. ���������� ��������:
	pulse[vdvDevice, 1001]




*/
#include 'Strings.axi'

DEFINE_DEVICE

DEFINE_CONSTANT

_debug			= 0 //�������

// �������������� �������
TL_PING_ID				= $A0	// ������������� ������ �����
TL_WORK_ID				= $A1


tcp			= 1
udp			= 0
true			= 1
false			= 0

DEFINE_TYPE

DEFINE_VARIABLE

volatile long 		m_laPing[1]		= {5000} 	// ���������� ������� ����� ������� ������������ ����
volatile long 		m_laWork[1]		= {500}	// ���������� ������� ����� ������� ������������ ��������� ��������� ����������
volatile char		m_cIsConnect		= 0	// ���� ����������
volatile long		m_lCurTime		= 0
volatile long		m_lLastPingTime		= 0
volatile long		m_lStartWaitTime	= 0

volatile long 		iPort			= 4998 //���� �����������
volatile char 		m_caPort[3][3]		= { '1:1', '1:2', '1:3' } //������ ��-������
volatile integer 	m_iRepeat		= 0 //������ ��-�������, ���� 0 - ��������� ���� �� ������� ����
volatile integer 	m_iOnWork		= 0 //����� ������
volatile integer	m_iCount		= 0
volatile integer	m_iChannel = 0
#include 'gc_ir_db.axi'

DEFINE_LATCHING

DEFINE_MUTUALLY_EXCLUSIVE

/**
    �������������
    �� �����	:	in_dvDevice - ����������
			in_cIPAddr  - IP ����� ���������� � �������� ����� �������������
			in_iPort    - ���� � �������� ����� �������������
    �� ������	:	*
*/
define_function fnOnConnect(dev in_dvDevice, char in_cIPAddr[], long in_iPort)
{
    ip_client_open(in_dvDevice.port, in_cIPAddr, in_iPort, 1);
}

/**
    ������������
    �� �����	:	in_dvDevice - ����������
    �� ������	:	*
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
    ������������� ����������
    �� �����	:	*
    �� ������	:	*
*/
define_function fnOnInit()
{	
    // �������� ������� ��� ����������� ����������
    timeline_create(TL_PING_ID, m_laPing, 1, TIMELINE_ABSOLUTE, TIMELINE_REPEAT)
    
    m_lLastPingTime 	= m_lCurTime;
    m_lStartWaitTime	= m_lCurTime;
}


/**
    ��������������� ����������
    �� �����	:	*
    �� ������	:	*
*/
define_function fnOnDeInit()
{
    // ��������� ��������
    if(timeline_active(TL_PING_ID))
	timeline_kill(TL_PING_ID);
    
    m_lLastPingTime 	= m_lCurTime;
    m_lStartWaitTime	= m_lCurTime;
}

/**
    ����
    �� �����	:	*
    �� ������	:	*
    ����������	: 	������ ������� ������������� ��� ����������� ����������
*/
define_function fnOnPing()
{
    if(m_cIsConnect == 1) {
	send_string dvDevice, "'get_NET,0:1',$0D,$0A"
    }
}







define_function fnOnSend(char in_caData[])
{
    if(m_cIsConnect)	{
	//�������� ������
	send_string dvDevice, "in_caData"
	printf("'GC-IP2IR [', fnReturnDPS(dvDevice),'] ~Tx* :: ', in_caData")
    }
}


define_function printf(char in_caData[])
{
    if(_debug)
	send_string 0, "in_caData"
}

define_function fnSendGCIr( char in_caPort[], integer in_iRepeat, char in_caCommand[]) // Port,Repeat,Command
{
    local_var
    char l_caTmpString[400]
    char l_caSendIR[7]
    char l_caIRPort[4]
    char l_caCount[2]
    char l_caCarrier[7]
    char l_caRepeat[2]
    char l_caOffset[2]
    
    l_caTmpString = in_caCommand
    
    l_caSendIR 	= remove_string(l_caTmpString, ',',1) // 'sendir,'
    l_caIRPort 	= remove_string(l_caTmpString, ',',1) // 'port,'
    l_caCount 	= remove_string(l_caTmpString, ',',1) // 'count,'
    l_caCarrier = remove_string(l_caTmpString, ',',1) // 'carrier,'
    l_caRepeat 	= remove_string(l_caTmpString, ',',1) // 'repeat,'
    l_caOffset 	= remove_string(l_caTmpString, ',',1) // 'offset,'
    
    fnOnSend("'sendir,', in_caPort,',1,', l_caCarrier, itoa(in_iRepeat),',1,',l_caTmpString,$0D,$0A")
    /*
    if(in_iShift == 200 && m_iChannel > 1 && m_iChannel < 27 && m_iChannel > 28 && m_iChannel < 60)
    {
	fnOnSend("'sendir,', in_caPort,',1,', l_caCarrier,',1,1,',l_caTmpString,$0D,$0A")
    }
    else
    {
	fnOnSend("'sendir,', in_caPort,',1,', l_caCarrier, itoa(in_iRepeat),',1,',l_caTmpString,$0D,$0A")
    }
    */
}

define_function fnStopIR(char in_caPort[])
{
    fnOnSend("'stopir,', in_caPort, $0D, $0A")
}

define_function char[20] fnReturnDPS(dev in_dDevice)
{
    local_var char dps[20]
    
    dps = "itoa(in_dDevice.number),':',itoa(in_dDevice.port),':', itoa(in_dDevice.system)"
    
    return dps
}

/**
    ��������� ����������� ���������� � ������������
    �� �����	: *
    �� ������	: *
*/
define_function fnOnWork()
{
    local_var long l_lTime
    
    if(m_cIsConnect == 0)
    {
	// ��������� 
	l_lTime = m_lCurTime - m_lStartWaitTime
	if(l_lTime > 1000)
	{
	    send_string vdvDevice[1], "'GC-IP2IR [',fnReturnDPS(dvDevice),'] fnOnConnect(', caHost, ',', itoa(iPort), ')'"
	    fnOnConnect(dvDevice, caHost, iPort)
	    
	    m_cIsConnect = 2
	    m_lStartWaitTime = m_lCurTime
	}
    } else if(m_cIsConnect == 1)
    {
	l_lTime = m_lCurTime - m_lLastPingTime
	if(l_lTime > 6000)
	{
	    fnOnDisconnect(dvDevice)
	    send_string vdvDevice[1], "'GC-IP2IR [',fnReturnDPS(dvDevice),'] TIMEOUT!!!'"
	}
    } else if(m_cIsConnect == 2)
    {
	// ��������� 
	l_lTime = m_lCurTime - m_lStartWaitTime
	if(l_lTime > 1000)
	{
	    send_string vdvDevice[1], "'GC-IP2IR [',fnReturnDPS(dvDevice),'] TIMEOUT, WAITING CONNECTION!!!'"
	    m_cIsConnect = 0
	    m_lStartWaitTime = m_lCurTime
	}
    }
}

DEFINE_START



DEFINE_EVENT

/**
    ���������� ������� �����
*/
TIMELINE_EVENT[TL_PING_ID]
{
    if(timeline.sequence == 1) {
	fnOnPing()
    }
}

/**
    ���������� ����������� ����������
*/
TIMELINE_EVENT[TL_WORK_ID]
{
    if(timeline.sequence == 1) {
	m_lCurTime = m_lCurTime + m_laWork[1]
	fnOnWork()
    }
}




//��������� ������������ �����
data_event[vdvDevice]
{
    command:
    {
	local_var char l_caReadData[100]
	local_var char l_caTempData[100]
	local_var integer l_iRepeat, l_iChannel, l_iBuffer[2]
	
	l_caReadData = Data.Text
	
	select
	{
	    active(find_string(l_caReadData, 'START;', 1) == 1):
	    {
		//  ������ ������ ��� ����������� ����������
		if(m_cIsConnect == 0) 
		    fnOnConnect(dvDevice, caHost, iPort)
		timeline_create(TL_WORK_ID, m_laWork, 1, TIMELINE_ABSOLUTE, TIMELINE_REPEAT)
		
		send_string vdvDevice[1], "'GC-IP2IR [',fnReturnDPS(dvDevice),'] MODULE START'"
	    }
	    active(find_string(l_caReadData, 'STOP;', 1) == 1):
	    {
		fnOnDisconnect(dvDevice)
		// ��������� ������ ��� ����������� ����������
		timeline_kill(TL_WORK_ID);
		
		send_string vdvDevice[1], "'STOP'"
	    }
	    active(find_string(l_caReadData, 'SEND_IR', 1) == 1):
	    {
		l_caTempData = remove_string(l_caReadData, 'SEND_IR', 1)
		fnGetArray(l_caReadData, l_iBuffer, ',')
		fnSendGCIr(m_caPort[get_last(vdvDevice)], l_iBuffer[2], m_caIRDB[l_iBuffer[1]]) //port, repeat, command
	    }
	}
    }
}
//��������� ����������� �����
data_event[dvDevice]
{
    online:
    {
	// ������������� ����������
	fnOnInit()
	//socket is online
	m_cIsConnect = 1
	//debug
	printf("'GC-IP2IR [', fnReturnDPS(dvDevice),'] :: Client is Online!!!'")
    }
    offline:
    {	    
	//�������
	printf("'GC-IP2IR [', fnReturnDPS(dvDevice),'] :: Client is Offline!!!'")
	
	// ������������� ����������
	fnOnDeInit()
	
	// ���������� ��������
	m_cIsConnect = 0
    }
    string:
    {
	local_var char l_caReadData[100]
	// �������� ����� ���������� �����
	m_lLastPingTime = m_lCurTime
	//
	l_caReadData = data.text
	//�������
	printf("'GC-IP2IR [', fnReturnDPS(dvDevice),'] ~Rx* :: ', l_caReadData")
	
    }
    onerror:
    {	
	printf("'GC-IP2IR [', fnReturnDPS(dvDevice),'] :: OnError(',itoa(data.number),')'")
	    
	switch(data.number)
	{
	    //��� ������ ��� ������� �� ��������� ������������ ������
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
	m_iChannel = channel.channel
	fnSendGCIr(m_caPort[get_last(vdvDevice)], m_iRepeat, m_caIRDB[channel.channel + in_iShift[get_last(vdvDevice)]]) //port, repeat, command
    }
    off:
    {
	fnStopIR(m_caPort[get_last(vdvDevice)])
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
