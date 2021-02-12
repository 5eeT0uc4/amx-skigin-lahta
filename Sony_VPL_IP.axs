MODULE_NAME='Sony_VPL_IP' ( dev vdvDevice,
			    dev dvDevice, 
			    char caHost[] )
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
#include 'StreamBuffer.axi'	// ��������� �����

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

volatile long 		iPort			= 53484 //���� �����������
volatile integer 	m_iOnWork		= 0 //����� ������
volatile integer	m_iCount		= 0

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
	send_string dvDevice, "$02,$0A,$53,$4F,$4E,$59,$01,$00,$02,$02,$01,$02"
    }
}

define_function fnOnSend(char in_caData[])
{
    if(m_cIsConnect)	{
	//�������� ������
	send_string dvDevice, "in_caData"
	printf("'Sony VPL ~Tx* :: ', in_caData")
    }
}

define_function printf(char in_caData[])
{
    if(_debug)
	send_string 0, "in_caData"
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
	    send_string vdvDevice, "'Sony VPL fnOnConnect(', caHost, ',', itoa(iPort), ')'"
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
	    send_string vdvDevice, "'Sony VPL TIMEOUT!!!'"
	}
    } else if(m_cIsConnect == 2)
    {
	// ��������� 
	l_lTime = m_lCurTime - m_lStartWaitTime
	if(l_lTime > 1000)
	{
	    send_string vdvDevice, "'Sony VPL TIMEOUT, WAITING CONNECTION!!!'"
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
		
		send_string vdvDevice, "'Sony VPL MODULE START'"
	    }
	    active(find_string(l_caReadData, 'STOP;', 1) == 1):
	    {
		fnOnDisconnect(dvDevice)
		// ��������� ������ ��� ����������� ����������
		timeline_kill(TL_WORK_ID);
		
		send_string vdvDevice, "'Sony VPL MODULE STOP'"
	    }
	    active(find_string(l_caReadData, 'SET_POWER ON;', 1) == 1):
	    {
		fnOnSend("$02,$0A,$53,$4F,$4E,$59,$00,$17,$2E,$02,$00,$00")
	    }
	    active(find_string(l_caReadData, 'SET_POWER OFF;', 1) == 1):
	    {
		fnOnSend("$02,$0A,$53,$4F,$4E,$59,$00,$17,$2F,$02,$00,$00")
	    }
	    active(find_string(l_caReadData, 'SET_INPUT HDMI1;', 1) == 1):
	    {
		fnOnSend("$02,$0A,$53,$4F,$4E,$59,$00,$00,$01,$02,$00,$02")
	    }
	    active(find_string(l_caReadData, 'SET_INPUT HDMI2;', 1) == 1):
	    {
		fnOnSend("$02,$0A,$53,$4F,$4E,$59,$00,$00,$01,$02,$00,$03")
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
	printf("'Sony VPL :: Client is Online!!!'")
    }
    offline:
    {	    
	//�������
	printf("'Sony VPL :: Client is Offline!!!'")
	
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
	printf("'Sony VPL ~Rx* :: ', l_caReadData")
	
    }
    onerror:
    {	
	printf("'Sony VPL :: OnError(',itoa(data.number),')'")
	    
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

(***********************************************************)
(*            THE ACTUAL PROGRAM GOES BELOW                *)
(***********************************************************)
DEFINE_PROGRAM

(***********************************************************)
(*                     END OF PROGRAM                      *)
(*        DO NOT PUT ANY CODE BELOW THIS COMMENT           *)
(***********************************************************)
