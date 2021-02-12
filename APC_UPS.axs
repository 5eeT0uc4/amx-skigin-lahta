MODULE_NAME='APC_UPS' (dev vdvDevice, dev dvDevice, char caHost[])

#include 'Strings.axi'

DEFINE_DEVICE

DEFINE_CONSTANT

_debug			= 0 //отладка

// идентификаторы потоков
TL_PING_ID				= $A0	// идентификатор потока пинга
TL_WORK_ID				= $A1

tcp			= 1
udp			= 2
true			= 1
false			= 0

MAX_RESP_LEN		= 4096;			// Максимальная длинна ответа

DEFINE_TYPE

structure s_UPS
{
    char m_caUptime[30]
}


DEFINE_VARIABLE

volatile s_UPS		UPS

volatile char		m_caDeviceName[30]	= 'APC Smart-UPS 3000 XLM'
volatile long 		m_laPing[1]		= {2000} 	// промежуток времени через который производится пинг
volatile long 		m_laWork[1]		= {500}	// промежуток времени через который производится обработка состояние соединения
volatile char		m_cIsConnect		= 0	// флаг соединения
volatile long		m_lCurTime		= 0
volatile long		m_lLastPingTime		= 0
volatile long		m_lStartWaitTime	= 0
volatile integer	m_iOnWork		= 0

volatile long 		iPort			= 23 //порт подключения


DEFINE_LATCHING

DEFINE_MUTUALLY_EXCLUSIVE

/**
    Подсоединение
    на входе	:	in_dvDevice - устройство
			in_cIPAddr  - IP адрес устройства к которому нужно присоеденится
			in_iPort    - порт к которому нужно присоеденится
    на выходе	:	*
*/
define_function fnOnConnect(dev in_dvDevice, char in_cIPAddr[], long in_iPort)
{
    ip_client_open(in_dvDevice.port, in_cIPAddr, in_iPort, 1);
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
	fnOnSend(" 'about', $0D, $0A ")
    }
}



define_function fnOnSend(char in_caData[])
{
    if(m_cIsConnect)	{
	//отправка данных
	send_string dvDevice, in_caData
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
    Обработка поддержания соединения с контроллером
    на входе	: *
    на выходе	: *
*/
define_function fnOnWork()
{
    local_var long l_lTime
    
    if(m_cIsConnect == 0)
    {
	// обработка 
	l_lTime = m_lCurTime - m_lStartWaitTime
	if(l_lTime > 1000)
	{
	    send_string vdvDevice, "m_caDeviceName, ' [',fnReturnDPS(dvDevice),'] fnOnConnect(', caHost, ',', itoa(iPort), ')'"
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
    local_var char l_caTmp[100]
    
    printf("m_caDeviceName, ' - fnOnReceive = ', in_caData")
    
    if(find_string(in_caData, 'User Name', 1)) {
	fnOnSend("'apc',$0D,$0A")
    } else
    if(find_string(in_caData, 'Password', 1)) {
	fnOnSend("'apc',$0D,$0A")
    } else
    if(find_string(in_caData, 'apc>', 1)) {
	m_iOnWork = 1
    } else
    if(find_string(in_caData, 'Management Uptime:', 1)) {
	l_caTmp = remove_string(in_caData, 'Management Uptime:', 1)
	fnStr_GetStringWhile(in_caData, UPS.m_caUptime, $0D)
    }
}



DEFINE_START



DEFINE_EVENT

/**
    Обработчик таймера пинга
*/
TIMELINE_EVENT[TL_PING_ID]
{
    if(timeline.sequence == 1) {
	if(m_iOnWork)
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
	local_var 
	    char l_caReadData[100]
	    char l_caTemp[100]
	    char packet[100]
	    integer l_iRepeat, l_iChannel, l_iBuffer[2]
	
	l_caReadData = Data.Text
	
	select
	{
	    active(find_string(l_caReadData, 'START;', 1) == 1):
	    {
		//  запуск потока для поддержания соединения
		if(m_cIsConnect == 0) 
		    fnOnConnect(dvDevice, caHost, iPort)
		    
		timeline_create(TL_WORK_ID, m_laWork, 1, TIMELINE_ABSOLUTE, TIMELINE_REPEAT)
		
		send_string vdvDevice, "m_caDeviceName, ' [',fnReturnDPS(vdvDevice),'] MODULE START'"
	    }
	    active(find_string(l_caReadData, 'STOP;', 1) == 1):
	    {
		fnOnDisconnect(dvDevice)
		// остановка потока для поддержания соединения
		timeline_kill(TL_WORK_ID);
		
		send_string vdvDevice, "m_caDeviceName, ' [',fnReturnDPS(vdvDevice),'] MODULE STOP'"
	    }
	    active(find_string(l_caReadData, 'RESET_OUTLET 1;', 1) == 1):
	    {
		fnOnSend("'ups -o 1 Reboot',$0D,$0A")
	    }
	    active(find_string(l_caReadData, 'RESET_OUTLET 3;', 1) == 1):
	    {
		fnOnSend("'ups -o 3 Reboot',$0D,$0A")
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
	printf("m_caDeviceName, ' [', fnReturnDPS(dvDevice),'] :: Client is Online!!!'")
    }
    offline:
    {	    
	//отладка
	printf("m_caDeviceName, ' [', fnReturnDPS(dvDevice),'] :: Client is Offline!!!'")
	
	// инициализация соединения
	fnOnDeInit()
	
	// соединение прервано
	m_iOnWork = 0
	m_cIsConnect = 0
    }
    string:
    {
	local_var char l_caReadData[1024]
	// запомним время последнего пинга
	m_lLastPingTime = m_lCurTime
	//
	l_caReadData = data.text
	//
	fnOnReceive(l_caReadData)
	//отладка
	//printf("m_caDeviceName, ' [', fnReturnDPS(dvDevice),'] ~Rx* :: ', l_caReadData")
    }
    onerror:
    {	
	printf("m_caDeviceName, ' [', fnReturnDPS(dvDevice),'] :: OnError(',itoa(data.number),')'")
	    
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

(***********************************************************)
(*            THE ACTUAL PROGRAM GOES BELOW                *)
(***********************************************************)
DEFINE_PROGRAM

