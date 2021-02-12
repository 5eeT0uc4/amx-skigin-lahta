MODULE_NAME='Moxa_nPort5210_Comm' (dev vdvPort, dev dvDevice, char m_caIPAddress[], integer m_iPort)

DEFINE_DEVICE

DEFINE_CONSTANT
// ID ����� �����
//tl_ping_id	= $A1
_debug		= 0 //�������
tl_ping_id 	= $A1 //������������� �����
tl_close_socket_id	= $A2
tcp		= 1
udp		= 0
true		= 1
false		= 0
m_iRetryTime	= 30 //������� �����������
m_iTimeOut	= 10000

DEFINE_TYPE

DEFINE_VARIABLE
//����� ������� �����
volatile long m_laPing[][5]		= { 100 ,1000, 2000, 3000, 4000, 30000 }
volatile long m_laTimeToClose[1]	= m_iTimeOut
//������ ������ ����������� � ����������
volatile integer m_iClientOnline	= 0 //����� ������
volatile integer m_iClientKeepOpen 	= 0 //����������� ����������
volatile slong 	m_iClientConnectResult 	= 0 //��������� �����������
volatile integer m_iOnWork		= 0 //����� ������
volatile integer m_iCount		= 0

volatile long 		m_laPort[4]		= { 4001, 4002, 4003, 4004 }

volatile char		m_cavdvReadData[100]
volatile char		m_cadvReadData[100]

//�������� ����������
define_function fnOnDisconect()
{
    //���� ����� ������
    if(m_iClientOnline == true)	{
	//��������� �����
	ip_client_close(dvDevice.port)
    }
}
define_function fnOnReconnect()
{
    if(m_iClientOnline)
    {
	ip_client_close(dvDevice.port)
	ip_client_open(dvDevice.port, m_caIPAddress, m_laPort[m_iPort], tcp)
	fn_TL_CloseSocket()
    }
    else
    {
	ip_client_open(dvDevice.port, m_caIPAddress, m_laPort[m_iPort], tcp)
	fn_TL_CloseSocket()    
    }
}

define_function fnOnSend(char in_caData[])
{
    if(m_iClientOnline)	{
	//
	fn_TL_CloseSocket()
	//�������� ������
	send_string dvDevice, in_caData
    } else {
	//
	fn_TL_CloseSocket()
	//��������� �����������
	ip_client_open(dvDevice.port, m_caIPAddress, m_laPort[m_iPort], tcp)
	//�������� ������
	send_string dvDevice, in_caData
    }
}

define_function fnOnReceive(char in_caData[])
{
    //
    fn_TL_CloseSocket()
    //�������� ������ �� ����������� ����������
    send_command vdvPort, "'~RxData: *', in_caData"
}

define_function fn_TL_CloseSocket()
{
    //������ ��������� �� �������� ������ �� ��������
    if(timeline_active(tl_close_socket_id)) { //�������� ���������� ���������
	timeline_kill(tl_close_socket_id) //���������� ���������
	timeline_create(tl_close_socket_id, m_laTimeToClose, 1, timeline_absolute, timeline_repeat)
    } else {
	timeline_create(tl_close_socket_id, m_laTimeToClose, 1, timeline_absolute, timeline_repeat)
    }
}

define_function printf(char in_caData[])
{
    if(_debug)
	send_string 0, "in_caData"
}

DEFINE_START

DEFINE_EVENT

timeline_event[tl_close_socket_id]
{
    if(timeline.sequence == 1)
	fnOnReconnect()
}

data_event[dvDevice]
{
    online:
    {
	//socket is online
	m_iClientOnline = true
	//�������
	printf("'dvMOXA_nPort5210.Port[', itoa(dvDevice.port),'] :: Online!!!'")
    }
    offline:
    {
	//socket is offline
	m_iClientOnline = false
	//
	fn_TL_CloseSocket()
	//
	fnOnReconnect()
	//�������
	printf("'dvMOXA_nPort5210.Port[', itoa(dvDevice.port),'] :: Offline'")
    }
    string:
    {
	local_var char l_caReadData[1024]
	
	l_caReadData = data.text
	
	//fnOnSend(l_caReadData)
	send_command vdvPort, "'~RxData: *', l_caReadData"
	//�������
	printf("'dvMOXA_nPort5210.Port[', itoa(dvDevice.port),'] ~RxData: *', l_caReadData")
    }
    onerror:
    {
	//�������
	printf("'dvMOXA_nPort5210.Port[', itoa(dvDevice.port),'] :: OnError(',itoa(data.number),')'")

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

data_event[vdvPort]
{
    online:	{}
    offline:	{}
    string:
    {
	local_var char l_caReadData[1024]
	//
	l_caReadData = data.text
	//
	fnOnSend(l_caReadData)
	//�������
	printf("'dvMOXA_nPort5210.Port[', itoa(dvDevice.port),'] ~TxData: *', l_caReadData")
    }
    command:
    {
	local_var char l_caReadData[100]
	
	l_caReadData = Data.Text
	
	select
	{
	    active(find_string(l_caReadData, 'START;', 1)):
	    {
		//�������� ����� ������
		m_iOnWork = 1
		//
		fn_TL_CloseSocket()
	    }
	    active(find_string(l_caReadData, 'STOP;', 1)):
	    {
		//���������� ������ ������
		m_iOnWork = 0
		
		//�������� �������� ����� �� ����������		    
		if(timeline_active(tl_close_socket_id))
		    timeline_kill(tl_close_socket_id)
		
		//�������� ������
		fnOnDisconect()
	    }
	}
    }
}


DEFINE_PROGRAM

