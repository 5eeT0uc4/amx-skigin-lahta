MODULE_NAME='Yamaha_YNC_IP' (dev vdvDevice, dev dvDevice, char caHost[])

#include 'Strings.axi'

DEFINE_DEVICE

dvDebug = 0:0:0

DEFINE_CONSTANT


// идентификаторы потоков
TL_PING_ID				= $A0	// идентификатор потока пинга
TL_WORK_ID				= $A1
tcp			= 1
udp			= 2
true			= 1
false			= 0

MAX_RESP_LEN		= 1024;			// Максимальная длинна ответа
MAX_TX_QUEUE		= 32

DEFINE_TYPE

structure _sp_preout
{
    char Front_L[10]
    char Front_R[10]
    char Center[10]
    char Sur_L[10]
    char Sur_R[10]
    char Sur_Back_L[10]
    char Sur_Back_R[10]
    char Front_Presence_R[10]
    char Front_Presence_L[10]
    char Rear_Presence_R[10]
    char Rear_Presence_L[10]
    char Subwoofer_1[10]
    char Subwoofer_2[10]
}


DEFINE_VARIABLE

_debug			= 0 //отладка

volatile _sp_preout 	Preout
volatile char		m_caDeviceName[30]	= 'Yamaha YNC Protocol'
volatile long 		m_laPing[1]		= {2000} 	// промежуток времени через который производится пинг
volatile long 		m_laWork[1]		= {500}	// промежуток времени через который производится обработка состояние соединения
volatile char		m_cIsConnect		= 0	// флаг соединения
volatile long		m_lCurTime		= 0
volatile long		m_lLastPingTime		= 0
volatile long		m_lStartWaitTime	= 0
volatile integer	m_iOnWork		= 0

volatile long 		iPort			= 80 //порт подключения
//volatile long 		UDP_Port		= 1900 //порт подключения

volatile char		m_caREQ_Basic_Status[]	= '<?xml version="1.0" encoding="utf-8"?><YAMAHA_AV cmd="GET"><Main_Zone><Basic_Status>GetParam</Basic_Status></Main_Zone></YAMAHA_AV>'

DEFINE_LATCHING

DEFINE_MUTUALLY_EXCLUSIVE


/**
    Подсоединение
    на входе	:	in_dvDevice - устройство
			in_cIPAddr  - IP адрес устройства к которому нужно присоеденится
			in_iPort    - порт к которому нужно присоеденится
    на выходе	:	*
*/
define_function fnOnConnect()
{
    ip_client_open(dvDevice.port, caHost, iPort, 1);
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
    fnURI_GET_SPLevels()
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
	//Header
	//fnOnSend(" fnURI_Header(m_caREQ_Basic_Status) ")
	//Body
	//fnOnSend(" m_caREQ_Basic_Status, 13, 10 ")
	//fnURI_GET_SPLevels()
    }
}

define_function char[10] fnReturnValue(char in_caValue[])
{
    stack_var
	float l_fValue
	char l_caValue[10]
	
    l_fValue = atof(in_caValue)
    
    send_string 0, "'Yamaha Control Value :: l_fValue = ', ftoa(l_fValue),'; in_caValue = ', in_caValue"
    
    if(l_fValue > -100 && l_fValue < 100) {
	l_caValue = in_caValue
    } else 
    if(l_fValue <= -100) {
	l_caValue = '-100'
    } else
    if(l_fValue >= 100) {
	l_caValue = '100'
    }
    
    send_string 0, "'Yamaha Return Control Value :: l_caValue = ', l_caValue"
    return l_caValue    
}


define_function char[MAX_RESP_LEN] fnURI_Header(char in_iBody[])
{
    stack_var char packet[MAX_RESP_LEN]
    
    packet = "  'POST /YamahaRemoteControl/ctrl HTTP/1.1',13,10,
		'Host: ', caHost,':', itoa(iPort),13,10,
		'Accept-Encoding: gzip, deflate',13,10,
		'Content-Type: text/xml; charset=UTF-8',13,10,
		'Content-Length: ',itoa(length_string(in_iBody)),13,10,
		'Accept-Language: ru',13,10,
		'Accept: */*',13,10,
		'Connection: keep-alive',13,10,
		'User-Agent: AVcontrol/3.40 CFNetwork/609 Darwin/13.0.0',13,10,13,10 "
    
    return packet
}


define_function fnURI_PUT_Center(char in_caValue[])
{
    stack_var 
	char packet[MAX_RESP_LEN]
	float l_fValue
	char l_caValue[10]
	
    l_fValue = atof(Preout.Center)
    
    switch(in_caValue)
    {
	case '+': l_caValue = fnReturnValue(ftoa(l_fValue + 5))
	case '-': l_caValue = fnReturnValue(ftoa(l_fValue - 5))
	default: l_caValue = fnReturnValue(in_caValue)
    }
    Preout.Center = l_caValue;
    fnCreateFb()
    
    packet = "'<?xml version="1.0" encoding="utf-8"?><YAMAHA_AV cmd="PUT"><System><Speaker_Preout><Pattern_1><Lvl><Center><Val>', l_caValue,'</Val><Exp>1</Exp><Unit>dB</Unit></Center></Lvl></Pattern_1></Speaker_Preout></System></YAMAHA_AV>'"
    fnOnSend(" fnURI_Header(packet) ")
    fnOnSend(" packet ")
}

define_function fnURI_PUT_Front_L(char in_caValue[])
{
    stack_var 
	char packet[MAX_RESP_LEN]
	float l_fValue
	char l_caValue[10]
	
    l_fValue = atof(Preout.Front_L)
    
    switch(in_caValue)
    {
	case '+': l_caValue = fnReturnValue(ftoa(l_fValue + 5))
	case '-': l_caValue = fnReturnValue(ftoa(l_fValue - 5))
	default: l_caValue = fnReturnValue(in_caValue)
    }
    Preout.Front_L = l_caValue;
    fnCreateFb()
    
    packet = "'<?xml version="1.0" encoding="utf-8"?><YAMAHA_AV cmd="PUT"><System><Speaker_Preout><Pattern_1><Lvl><Front_L><Val>', l_caValue,'</Val><Exp>1</Exp><Unit>dB</Unit></Front_L></Lvl></Pattern_1></Speaker_Preout></System></YAMAHA_AV>'"
    fnOnSend(" fnURI_Header(packet) ")
    fnOnSend(" packet ")
}

define_function fnURI_PUT_Front_R(char in_caValue[])
{
    stack_var 
	char packet[MAX_RESP_LEN]
	float l_fValue
	char l_caValue[10]
	
    l_fValue = atof(Preout.Front_R)
    
    switch(in_caValue)
    {
	case '+': l_caValue = fnReturnValue(ftoa(l_fValue + 5))
	case '-': l_caValue = fnReturnValue(ftoa(l_fValue - 5))
	default: l_caValue = fnReturnValue(in_caValue)
    }
    Preout.Front_R = l_caValue;
    fnCreateFb()
    
    packet = "'<?xml version="1.0" encoding="utf-8"?><YAMAHA_AV cmd="PUT"><System><Speaker_Preout><Pattern_1><Lvl><Front_R><Val>', l_caValue,'</Val><Exp>1</Exp><Unit>dB</Unit></Front_R></Lvl></Pattern_1></Speaker_Preout></System></YAMAHA_AV>'"
    fnOnSend(" fnURI_Header(packet) ")
    fnOnSend(" packet ")
}

define_function fnURI_PUT_Front(char in_caValue[])
{
    local_var char packet[MAX_RESP_LEN]
    local_var float l_fValue
    local_var char l_caValue[10]
	
    l_fValue = atof(Preout.Front_L)
    
    switch(in_caValue)
    {
	case '+': { l_caValue = fnReturnValue(ftoa(l_fValue + 5)) }
	case '-': { l_caValue = fnReturnValue(ftoa(l_fValue - 5)) }
	default:  { l_caValue = fnReturnValue(in_caValue) }
    }
        
    //Front L
    packet = "'<?xml version="1.0" encoding="utf-8"?><YAMAHA_AV cmd="PUT"><System><Speaker_Preout><Pattern_1><Lvl><Front_L><Val>', l_caValue,'</Val><Exp>1</Exp><Unit>dB</Unit></Front_L></Lvl></Pattern_1></Speaker_Preout></System></YAMAHA_AV>'"
    //fnSendLongDebugMsg(packet)
    Preout.Front_L = l_caValue;
    Preout.Front_R = l_caValue;
    fnCreateFb()
    fnOnSend(" fnURI_Header(packet) ")
    fnOnSend(" packet ")

    //Surr R
    wait 3 'surr'
    {
	packet = "'<?xml version="1.0" encoding="utf-8"?><YAMAHA_AV cmd="PUT"><System><Speaker_Preout><Pattern_1><Lvl><Front_R><Val>', l_caValue,'</Val><Exp>1</Exp><Unit>dB</Unit></Front_R></Lvl></Pattern_1></Speaker_Preout></System></YAMAHA_AV>'"
	//fnSendLongDebugMsg(packet)
	fnOnSend(" fnURI_Header(packet) ")
	fnOnSend(" packet ")
    }
}

define_function fnURI_PUT_Sub_1(char in_caValue[])
{
    stack_var 
	char packet[MAX_RESP_LEN]
	float l_fValue
	char l_caValue[10]
	
    l_fValue = atof(Preout.Subwoofer_1)
    
    switch(in_caValue)
    {
	case '+': l_caValue = fnReturnValue(ftoa(l_fValue + 5))
	case '-': l_caValue = fnReturnValue(ftoa(l_fValue - 5))
	default: l_caValue = fnReturnValue(in_caValue)
    }
    
    packet = "'<?xml version="1.0" encoding="utf-8"?><YAMAHA_AV cmd="PUT"><System><Speaker_Preout><Pattern_1><Lvl><Subwoofer_1><Val>', l_caValue,'</Val><Exp>1</Exp><Unit>dB</Unit></Subwoofer_1></Lvl></Pattern_1></Speaker_Preout></System></YAMAHA_AV>'"
    Preout.Subwoofer_1 = l_caValue;
    fnCreateFb()
    fnOnSend(" fnURI_Header(packet) ")
    fnOnSend(" packet ")
}

define_function fnURI_PUT_Sub_2(char in_caValue[])
{
    stack_var 
	char packet[MAX_RESP_LEN]
	float l_fValue
	char l_caValue[10]
	
    l_fValue = atof(Preout.Subwoofer_2)
    
    switch(in_caValue)
    {
	case '+': l_caValue = fnReturnValue(ftoa(l_fValue + 5))
	case '-': l_caValue = fnReturnValue(ftoa(l_fValue - 5))
	default: l_caValue = fnReturnValue(in_caValue)
    }
    
    packet = "'<?xml version="1.0" encoding="utf-8"?><YAMAHA_AV cmd="PUT"><System><Speaker_Preout><Pattern_1><Lvl><Subwoofer_2><Val>', l_caValue,'</Val><Exp>1</Exp><Unit>dB</Unit></Subwoofer_2></Lvl></Pattern_1></Speaker_Preout></System></YAMAHA_AV>'"
    Preout.Subwoofer_2 = l_caValue;
    fnCreateFb()
    fnOnSend(" fnURI_Header(packet) ")
    fnOnSend(" packet ")
}

define_function fnURI_PUT_Surr(char in_caValue[])
{
    local_var char packet[MAX_RESP_LEN]
    local_var float l_fValue
    local_var char l_caValue[10]
	
    l_fValue = atof(Preout.Sur_L)
    
    switch(in_caValue)
    {
	case '+': { l_caValue = fnReturnValue(ftoa(l_fValue + 5)) }
	case '-': { l_caValue = fnReturnValue(ftoa(l_fValue - 5)) }
	default:  { l_caValue = fnReturnValue(in_caValue) }
    }
        
    //Surr L
    packet = "'<?xml version="1.0" encoding="utf-8"?><YAMAHA_AV cmd="PUT"><System><Speaker_Preout><Pattern_1><Lvl><Sur_L><Val>', l_caValue,'</Val><Exp>1</Exp><Unit>dB</Unit></Sur_L></Lvl></Pattern_1></Speaker_Preout></System></YAMAHA_AV>'"
    //fnSendLongDebugMsg(packet)
    Preout.Sur_L = l_caValue;
    Preout.Sur_R = l_caValue;
    fnCreateFb()
    fnOnSend(" fnURI_Header(packet) ")
    fnOnSend(" packet ")

    //Surr R
    wait 3 'surr'
    {
	packet = "'<?xml version="1.0" encoding="utf-8"?><YAMAHA_AV cmd="PUT"><System><Speaker_Preout><Pattern_1><Lvl><Sur_R><Val>', l_caValue,'</Val><Exp>1</Exp><Unit>dB</Unit></Sur_R></Lvl></Pattern_1></Speaker_Preout></System></YAMAHA_AV>'"
	//fnSendLongDebugMsg(packet)
	fnOnSend(" fnURI_Header(packet) ")
	fnOnSend(" packet ")
    }
}


define_function fnURI_PUT_SurrBack(char in_caValue[])
{
    stack_var 
	char packet[MAX_RESP_LEN]
	float l_fValue
	char l_caValue[10]
	
    l_fValue = atof(Preout.Sur_Back_L)
    
    switch(in_caValue)
    {
	case '+': l_caValue = fnReturnValue(ftoa(l_fValue + 5))
	case '-': l_caValue = fnReturnValue(ftoa(l_fValue - 5))
	default: l_caValue = fnReturnValue(in_caValue)
    }

    //Surr Back R
    packet = "'<?xml version="1.0" encoding="utf-8"?><YAMAHA_AV cmd="PUT"><System><Speaker_Preout><Pattern_1><Lvl><Sur_Back_R><Val>', l_caValue,'</Val><Exp>1</Exp><Unit>dB</Unit></Sur_Back_R></Lvl></Pattern_1></Speaker_Preout></System></YAMAHA_AV>'"
    fnSendLongDebugMsg(packet)
    fnOnSend(" fnURI_Header(packet) ")
    fnOnSend(" packet ")

    //Surr Back L
    packet = "'<?xml version="1.0" encoding="utf-8"?><YAMAHA_AV cmd="PUT"><System><Speaker_Preout><Pattern_1><Lvl><Sur_Back_L><Val>', l_caValue,'</Val><Exp>1</Exp><Unit>dB</Unit></Sur_Back_L></Lvl></Pattern_1></Speaker_Preout></System></YAMAHA_AV>'"
    fnSendLongDebugMsg(packet)
    fnOnSend(" fnURI_Header(packet) ")
    fnOnSend(" packet ")
}


define_function fnURI_PUT_ExtraBass(char in_caValue[])
{
    stack_var 
	char packet[MAX_RESP_LEN]
	
    packet = "'<?xml version="1.0" encoding="utf-8"?><YAMAHA_AV cmd="PUT"><System><Speaker_Preout><Pattern_1><Config><Subwoofer><Extra_Bass>', in_caValue,'</Extra_Bass></Subwoofer></Config></Pattern_1></Speaker_Preout></System></YAMAHA_AV>'"
    
    fnOnSend(" fnURI_Header(packet) ")
    fnOnSend(" packet ")
}

define_function fnURI_GET_Center()
{
    stack_var char packet[MAX_RESP_LEN]
    
    packet = '<?xml version="1.0" encoding="utf-8"?><YAMAHA_AV cmd="GET"><System><Speaker_Preout><Pattern_1><Config><Center>GetParam</Center></Config></Pattern_1></Speaker_Preout></System></YAMAHA_AV>'

    fnOnSend(" fnURI_Header(packet) ")
    fnOnSend(" packet ")
}
define_function fnURI_GET_Sur()
{
    stack_var char packet[MAX_RESP_LEN]
    
    packet = '<?xml version="1.0" encoding="utf-8"?><YAMAHA_AV cmd="GET"><System><Speaker_Preout><Pattern_1><Config><Sur>GetParam</Sur></Config></Pattern_1></Speaker_Preout></System></YAMAHA_AV>'

    fnOnSend(" fnURI_Header(packet) ")
    fnOnSend(" packet ")
}

define_function fnURI_GET_SPLevels()
{
    stack_var char packet[MAX_RESP_LEN]
    
    packet = '<?xml version="1.0" encoding="utf-8"?><YAMAHA_AV cmd="GET"><System><Speaker_Preout><Pattern_1><Lvl>GetParam</Lvl></Pattern_1></Speaker_Preout></System></YAMAHA_AV>'

    fnOnSend(" fnURI_Header(packet) ")
    fnOnSend(" packet ")
}


define_function fnURI_GET_Preamp_Config()
{
    stack_var char packet[MAX_RESP_LEN]
    
    packet = '<?xml version="1.0" encoding="utf-8"?><YAMAHA_AV cmd="GET"><System><Speaker_Preout><Pattern_1><Lvl>GetParam</Lvl></Pattern_1></Speaker_Preout></System></YAMAHA_AV>'

    fnOnSend(" fnURI_Header(packet) ")
    fnOnSend(" packet ")
}
define_function fnURI_GET_Preamp(integer in_iPattern)
{
    stack_var char packet[MAX_RESP_LEN]
    
    packet = "'<?xml version="1.0" encoding="utf-8"?><YAMAHA_AV cmd="GET"><System><Speaker_Preout><Pattern_',itoa(in_iPattern),'>GetParam</Pattern_',itoa(in_iPattern),'></Speaker_Preout></System></YAMAHA_AV>'"

    fnOnSend(" fnURI_Header(packet) ")
    fnOnSend(" packet ")
}

define_function fnURI_TestCmd(char in_caData[])
{
    stack_var char packet[MAX_RESP_LEN]
    
    packet = in_caData

    fnOnSend(" fnURI_Header(packet) ")
    fnOnSend(" packet ")
}

define_function fnOnSend(char in_caData[])
{
    if(m_cIsConnect)	{
	//отправка данных
	send_string dvDevice, in_caData
    } else {
	fnOnConnect()
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
	if(l_lTime > 5000)
	{
	    send_string vdvDevice, "m_caDeviceName, ' [',fnReturnDPS(dvDevice),'] fnOnConnect(', caHost, ',', itoa(iPort), ')'"
	    fnOnConnect()
	    
	    m_cIsConnect = 2
	    m_lStartWaitTime = m_lCurTime
	}
    } else if(m_cIsConnect == 1)
    {
	l_lTime = m_lCurTime - m_lLastPingTime
	if(l_lTime > 30000)
	{
	    fnOnDisconnect(dvDevice)
	    send_string vdvDevice, "m_caDeviceName, ' [',fnReturnDPS(dvDevice),'] TIMEOUT!!!'"
	}
    } else if(m_cIsConnect == 2)
    {
	// обработка 
	l_lTime = m_lCurTime - m_lStartWaitTime
	if(l_lTime > 5000)
	{
	    send_string vdvDevice, "m_caDeviceName, ' [',fnReturnDPS(dvDevice),'] TIMEOUT, WAITING CONNECTION!!!'"
	    m_cIsConnect = 0
	    m_lStartWaitTime = m_lCurTime
	}
    }
}

define_function fnCreateFb()
{
    // Center Level
    //send_level vdvDevice, 5, atof(Preout.Center)/10
    // Surround Level
    //send_level vdvDevice, 7, atof(Preout.Sur_L)/10
    send_string vdvDevice, "'CENTER_VOLUME:', ftoa(atof(Preout.Center)/10)"
    send_string vdvDevice, "'SURROUND_VOLUME:', ftoa(atof(Preout.Sur_L)/10)"
    send_string vdvDevice, "'FRONT_VOLUME:', ftoa(atof(Preout.Front_L)/10)"
    send_string vdvDevice, "'SUBWOOFER_VOLUME:', ftoa(atof(Preout.Subwoofer_1)/10)"
}

define_function fnOnReceive(char in_caData[])
{
    stack_var 
	char l_caTmp[100]
	integer i
    
    if(find_string(in_caData, '<YAMAHA_AV rsp="GET" RC="0"><System><Speaker_Preout>', 1)) {
	
	   Preout.Front_L 		= fnURI_GetParam(fnURI_GetParam(in_caData, 'Front_L'), 'Val')
	   Preout.Front_R 		= fnURI_GetParam(fnURI_GetParam(in_caData, 'Front_R'), 'Val')
	   Preout.Center 		= fnURI_GetParam(fnURI_GetParam(in_caData, 'Center'), 'Val')
	   Preout.Sur_L 		= fnURI_GetParam(fnURI_GetParam(in_caData, 'Sur_L'), 'Val')
	   Preout.Sur_R 		= fnURI_GetParam(fnURI_GetParam(in_caData, 'Sur_R'), 'Val')
	   Preout.Sur_Back_L 		= fnURI_GetParam(fnURI_GetParam(in_caData, 'Sur_Back_L'), 'Val')
	   Preout.Sur_Back_R		= fnURI_GetParam(fnURI_GetParam(in_caData, 'Sur_Back_R'), 'Val')
	   Preout.Front_Presence_L 	= fnURI_GetParam(fnURI_GetParam(in_caData, 'Front_Presence_L'), 'Val')
	   Preout.Front_Presence_R 	= fnURI_GetParam(fnURI_GetParam(in_caData, 'Front_Presence_R'), 'Val')
	   Preout.Rear_Presence_L 	= fnURI_GetParam(fnURI_GetParam(in_caData, 'Rear_Presence_L'), 'Val')
	   Preout.Rear_Presence_R 	= fnURI_GetParam(fnURI_GetParam(in_caData, 'Rear_Presence_R'), 'Val')
	   Preout.Subwoofer_1 		= fnURI_GetParam(fnURI_GetParam(in_caData, 'Subwoofer_1'), 'Val')
	   Preout.Subwoofer_2 		= fnURI_GetParam(fnURI_GetParam(in_caData, 'Subwoofer_2'), 'Val')
    }
    
    fnCreateFb()
}


define_function char[100] fnURI_GetParam(char in_caData[], char in_iParam[])
{
    stack_var 
	char param[100]
	integer start_pos
	integer end_pos
	integer param_len
    
    start_pos = find_string(in_caData, "'<',in_iParam,'>'", 1)
    end_pos = find_string(in_caData, "'</',in_iParam,'>'", 1)
    
    if(end_pos > start_pos)
    {
	start_pos = start_pos + length_string(in_iParam) + 2	
	param_len = end_pos - start_pos	
	param = mid_string(in_caData, start_pos, param_len)	
	return param
    } else {
	//return 'Bad_Param!!!'
    }
}

Define_Function fnSendLongDebugMsg(char dbgmsg[])
{
    if(_debug)
    {
	integer lenpacket, block;
	lenpacket = Length_String(dbgmsg);

	block = 120;
	// packets greater than 
	if(lenpacket > block)
	{
	    integer pCursor;
	    
	    for(pCursor=1; pCursor <= lenpacket; pCursor = pCursor+block)
	    {
		select
		{
		    active(pCursor==1): 				
			send_string dvDebug,"'Yamaha: # ',mid_string(dbgmsg,pCursor,block)";
		    active((pCursor+block) <= lenpacket):
			send_string dvDebug,"'        - ',mid_string(dbgmsg,pCursor,block)";
		    active((pCursor+block) > lenpacket):
		    {
			integer bytesleft;
			bytesleft = lenpacket-pCursor+1;
			send_string dvDebug,"'        - ',right_string(dbgmsg,bytesleft)";
		    }
		}
	    }
	}
	else
	{
	    send_string 0,"'Yamaha: ', dbgmsg";
	}
    }
}

define_function fnResetPing()
{
    if(timeline_active(TL_PING_ID)) {
	timeline_kill(TL_PING_ID)
	timeline_create(TL_PING_ID, m_laPing, 1, TIMELINE_ABSOLUTE, TIMELINE_REPEAT)
    } else {
	timeline_create(TL_PING_ID, m_laPing, 1, TIMELINE_ABSOLUTE, TIMELINE_REPEAT)
    }
}

define_function fnOnControl(integer in_iCh)
{

	if(in_iCh >= 201 && in_iCh <= 240) {
	    
	    switch(in_iCh)
	    {/*
		case 201: { fnURI_PUT_Center('+') 	}//center +
		case 202: { fnURI_PUT_Center('-') 	}//center -
		case 209: { fnURI_PUT_Surr('+') 	}//surr +
		case 210: { fnURI_PUT_Surr('-') 	}//surr -
		*/
		case 225: { fnURI_PUT_Center('+') 	}//center +
		case 224: { fnURI_PUT_Center('-') 	}//center -

		case 227: { fnURI_PUT_Front('+') 	}//center +
		case 226: { fnURI_PUT_Front('-') 	}//center -
		
		case 231: { fnURI_PUT_Surr('+') 	}//surr +
		case 230: { fnURI_PUT_Surr('-') 	}//surr -
		case 233: { fnURI_PUT_Sub_1('+') 	}//surr +
		case 232: { fnURI_PUT_Sub_1('-') 	}//surr -
	    }
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
	   fnURI_GET_SPLevels()
    }
}

//обработка виртуального порта
data_event[vdvDevice]
{
    online:
    {
	
    }
    command:
    {
	stack_var 
	    char l_caReadData[MAX_RESP_LEN]
	    char l_caTemp[100]
	    char packet[MAX_RESP_LEN]
	    integer l_iRepeat, l_iChannel, l_iBuffer[2]
	
	l_caReadData = Data.Text
	
	select
	{
	    active(find_string(l_caReadData, 'START;', 1) == 1):
	    {
		//  запуск потока для поддержания соединения
		if(m_cIsConnect == 0) 
		    fnOnConnect()
		
		timeline_create(TL_WORK_ID, m_laWork, 1, TIMELINE_ABSOLUTE, TIMELINE_REPEAT)
		
		send_string vdvDevice, "m_caDeviceName, ' [',fnReturnDPS(dvDevice),'] MODULE START'"
		
		fnURI_GET_SPLevels()
	    }
	    active(find_string(l_caReadData, 'STOP;', 1) == 1):
	    {
		fnOnDisconnect(dvDevice)
		// остановка потока для поддержания соединения
		timeline_kill(TL_WORK_ID);
		
		send_string vdvDevice, "m_caDeviceName, ' [',fnReturnDPS(dvDevice),'] MODULE STOP'"
	    }
	    active(find_string(l_caReadData, 'GET_CENTER;', 1) == 1):
	    {
		fnURI_GET_Center()
	    }
	    active(find_string(l_caReadData, 'GET_SPLEVEL;', 1) == 1):
	    {
		fnURI_GET_SPLevels()
	    }
	}
    }
}
//обработка физического порта
data_event[dvDevice]
{
    online:
    {
	//socket is online
	m_cIsConnect = 1
	// инициализация соединения
	fnOnInit()	
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
	m_cIsConnect = 0
    }
    string:
    {
	stack_var char l_caReadData[MAX_RESP_LEN]
	// запомним время последнего пинга
	m_lLastPingTime = m_lCurTime
	//
	l_caReadData = data.text
	//
	fnOnReceive(l_caReadData)
	//отладка
	fnSendLongDebugMsg(l_caReadData)
	printf("m_caDeviceName, ' [', fnReturnDPS(dvDevice),'] ~Rx* :: ', l_caReadData")
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

channel_event[vdvDevice, 0]
{
    on:	{
	stack_var integer l_iCh
	l_iCh = channel.channel
	
	fnOnControl(l_iCh)
    }
    off:{
	stack_var integer l_iCh
	l_iCh = channel.channel
	
	fnURI_GET_SPLevels()
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
