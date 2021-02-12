MODULE_NAME='Moxa_nPort5210_Comm' (dev vdvPort, dev dvDevice, char m_caIPAddress[], integer m_iPort)

DEFINE_DEVICE

DEFINE_CONSTANT
// ID номер пинга
//tl_ping_id	= $A1
_debug		= 0 //отладка
tl_ping_id 	= $A1 //идентификатор пинга
tl_close_socket_id	= $A2
tcp		= 1
udp		= 0
true		= 1
false		= 0
m_iRetryTime	= 30 //таймаут подключения
m_iTimeOut	= 10000

DEFINE_TYPE

DEFINE_VARIABLE
//масив таймера пинга
volatile long m_laPing[][5]		= { 100 ,1000, 2000, 3000, 4000, 30000 }
volatile long m_laTimeToClose[1]	= m_iTimeOut
//массив портов подключения к устройству
volatile integer m_iClientOnline	= 0 //сокет онлайн
volatile integer m_iClientKeepOpen 	= 0 //поддержание соединения
volatile slong 	m_iClientConnectResult 	= 0 //результат подключения
volatile integer m_iOnWork		= 0 //режим работы
volatile integer m_iCount		= 0

volatile long 		m_laPort[4]		= { 4001, 4002, 4003, 4004 }

volatile char		m_cavdvReadData[100]
volatile char		m_cadvReadData[100]

//закрытие соединения
define_function fnOnDisconect()
{
    //если сокет открыт
    if(m_iClientOnline == true)	{
	//закрываем сокет
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
	//отправка данных
	send_string dvDevice, in_caData
    } else {
	//
	fn_TL_CloseSocket()
	//открываем подключение
	ip_client_open(dvDevice.port, m_caIPAddress, m_laPort[m_iPort], tcp)
	//отправка данных
	send_string dvDevice, in_caData
    }
}

define_function fnOnReceive(char in_caData[])
{
    //
    fn_TL_CloseSocket()
    //отправка данных на виртуальное устройство
    send_command vdvPort, "'~RxData: *', in_caData"
}

define_function fn_TL_CloseSocket()
{
    //запуск таймлайна на закрытие сокета по таймауту
    if(timeline_active(tl_close_socket_id)) { //проверка активности таймлайна
	timeline_kill(tl_close_socket_id) //перезапуск таймлайна
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
	//отладка
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
	//отладка
	printf("'dvMOXA_nPort5210.Port[', itoa(dvDevice.port),'] :: Offline'")
    }
    string:
    {
	local_var char l_caReadData[1024]
	
	l_caReadData = data.text
	
	//fnOnSend(l_caReadData)
	send_command vdvPort, "'~RxData: *', l_caReadData"
	//отладка
	printf("'dvMOXA_nPort5210.Port[', itoa(dvDevice.port),'] ~RxData: *', l_caReadData")
    }
    onerror:
    {
	//отладка
	printf("'dvMOXA_nPort5210.Port[', itoa(dvDevice.port),'] :: OnError(',itoa(data.number),')'")

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
	//отладка
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
		//включаем режим работы
		m_iOnWork = 1
		//
		fn_TL_CloseSocket()
	    }
	    active(find_string(l_caReadData, 'STOP;', 1)):
	    {
		//выключение режима работы
		m_iOnWork = 0
		
		//проверка таймлайн пинга на активность		    
		if(timeline_active(tl_close_socket_id))
		    timeline_kill(tl_close_socket_id)
		
		//закрытие сокета
		fnOnDisconect()
	    }
	}
    }
}


DEFINE_PROGRAM

