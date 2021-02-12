MODULE_NAME='Yamaha_RX-A2010_Comm' (dev vdvDevice, dev dvDevice, char caHost[], dev dvPanels[])

#include 'Strings.axi'

DEFINE_DEVICE

dvDebug = 0:0:0

DEFINE_CONSTANT


// идентификаторы потоков
TL_PING_ID				= $A0	// идентификатор потока пинга
TL_WORK_ID				= $A1
TL_VOL_ID				= $A2
TL_SENDSTR_QUEUE			= $A3
TL_Surr					= $A4
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

structure _Receiver_s
{
    char m_caPower[10]
    char m_caSleep[10]
    char m_caInput[10]
    char m_caVolume[10]
    char m_caMute[10]
    char m_caBass[10]
    char m_caTreble[10]
    char m_caSound[100]
    char m_caStraight[20]
    char m_caEnhancer[20]  
    char m_caExtraBass[20]
    _sp_preout	SpeakerPreout
}

struct _TX_QUEUEITEM
{
    integer occupied;
    char txdata[MAX_RESP_LEN];
}

struct _TX_QUEUE
{
    integer head;
    integer tail;	
    _TX_QUEUEITEM items[MAX_TX_QUEUE];
}


DEFINE_VARIABLE

_debug			= 0 //отладка

//volatile _TX_QUEUE  	sendstr_queue;			// Send String queue
//volatile long 		TLI_SENDSTR_QUEUE[2] = { 100, 100 }; // Send_Command Queue 100ms

volatile _Receiver_s	Yamaha
volatile char		m_caSurrValue[10]
volatile integer	PanelIsOnline[length_array(dvPanels)]
volatile char		m_caDeviceName[20]	= 'Yamaha RX-A2010'
volatile long 		m_laPing[1]		= {2000} 	// промежуток времени через который производится пинг
volatile long 		m_laWork[1]		= {500}	// промежуток времени через который производится обработка состояние соединения
volatile long 		m_laVolume[1]		= {200}	// промежуток времени через который производится обработка состояние соединения
volatile long		m_laSurr[2]		= {100,100}
volatile char		m_cIsConnect		= 0	// флаг соединения
volatile long		m_lCurTime		= 0
volatile long		m_lLastPingTime		= 0
volatile long		m_lStartWaitTime	= 0
volatile integer	m_iOnWork		= 0

volatile long 		iPort			= 80 //порт подключения
volatile long 		UDP_Port		= 1900 //порт подключения

volatile char		m_caREQ_Basic_Status[]	= '<?xml version="1.0" encoding="utf-8"?><YAMAHA_AV cmd="GET"><Main_Zone><Basic_Status>GetParam</Basic_Status></Main_Zone></YAMAHA_AV>'
volatile char		m_caInput[10]		= ''

volatile char		m_caVolume[4]		= ''

volatile char		m_caPresets[14][40]	= { 
						    'Sports',
						    'Action Game',
						    'Roleplaying Game',
						    'Music Video',
						    'Recital/Opera',
						    'Standard',
						    'Spectacle',
						    'Sci-Fi',
						    'Adventure',
						    'Drama',
						    'Mono Movie',
						    '2ch Stereo',
						    '9ch Stereo',
						    'Surround Decoder'
						    }

DEFINE_LATCHING

DEFINE_MUTUALLY_EXCLUSIVE

Define_Function fnSendStrQ_EnqueueCommand(_TX_QUEUE queue, char txdata[], char overwriteid[])
{
    //     -> [1][2][3][4][5][6][7] ->
    //	       ^                 ^
    //         H                 T
    
    integer qlength;
    integer head;
    integer tail;
    integer insert_index;
    integer qLeft;
    integer qRight;
    qLeft = 1;	
    qRight = Max_Length_Array(queue.items);
    qLength = fnSendStrQ_GetLength(queue);	
    head = queue.head;
    tail = queue.tail;
    
    // Check if this is an update and we need to overwrite an existing queue item
    if(overwriteid != "")
    {		
	integer i;
	//fnSendDebugMsg("'SendCMD Queue: Searching for item with id [',overwriteid,'] to update...'");
	for(i=1; i <= Max_Length_Array(queue.items); i++)
	{
	    if(queue.items[i].occupied == TRUE)
	    //if(queue.items[i].dvDevice == dvDevice)
	    //if(queue.items[i].overwriteid == overwriteid) 
	    {
		insert_index = i;
		//fnSendDebugMsg("'SendCMD Queue: Found [',overwriteid,'] at position ',itoa(i),'. Updating.'");
		break;
	    }
	}
    }
    
    if(insert_index == FALSE)
    {
	// Going to add an item
	tail++;
	if(tail > qRight) tail = qLeft;
	
	insert_index = tail;
    }
    
    // Check for full queue
    if(insert_index == FALSE and queue.items[tail].occupied == TRUE)
    {
	//fnSendDebugMsg("'SendCMD Queue is full (',itoa(queue),' items), tx data will be lost. Sorry! Try making the queue longer! MAX_SENDCMD_QLENGTH=',itoa(MAX_SENDCMD_QLENGTH)");
	return;
    }

    //queue.items[insert_index].dvDevice = dvDevice;
    queue.items[insert_index].occupied = TRUE;
    queue.items[insert_index].txdata = txdata;
    //queue.items[insert_index].overwriteid = overwriteid;
    
    
    // Copy the queue stats back
    queue.head = head;
    queue.tail = tail;
    
    //fnSendDebugMsg("'SendCMD Queue: EN-QUEUED item at pos ',itoa(tail),'. Queue now contains ',itoa(fnDeviceSendCmdQ_GetLength(queue)),' items.'");
    Timeline_Restart(TL_SENDSTR_QUEUE);
}

Define_Function fnSendStrQ_DeQueueCommand(_TX_QUEUE queue)
{
    integer head;
    integer tail;
    integer qLeft;
    integer qRight;
    qLeft = 1;
    qRight = Max_Length_Array(queue.items);
    
    head = queue.head;
    tail = queue.tail;
    
    head++;
    if(head > qRight) head = qLeft;
    
    // Check for empty queue
    if(queue.items[head].occupied == FALSE)
    {
	//fnSendDebugMsg("'SendCMD Queue is Empty now.'");
	Timeline_Pause(TL_SENDSTR_QUEUE);
	return;
    }
    
    // Transmit the packet
    Send_String dvDevice, queue.items[head].txdata;
    queue.items[head].occupied = FALSE;
        
    // Copy the stats back
    queue.head = head;
    queue.tail = tail;
}

Define_Function integer fnSendStrQ_GetLength(_TX_QUEUE queue)
{
    integer qSize; 
    integer items;
    integer i;
    
    qSize = Max_Length_Array(queue.items);
    for(i=1; i <= qSize; i++)
    {
	if(queue.items[i].occupied) items++;
    }
    
    return items;
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
	fnOnSend(" fnURI_Header(m_caREQ_Basic_Status) ")
	//Body
	fnOnSend(" m_caREQ_Basic_Status, 13, 10 ")
	
	//fnURI_GET_SPLevels()
	
    }
}

define_function char[10] fnReturnValue(char in_caValue[])
{
    local_var
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
    local_var char packet[MAX_RESP_LEN]
    
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

//Up, Down
define_function fnURI_PUT_Volume(char in_caVolume[])
{
    local_var 
	char packet[MAX_RESP_LEN]
	
    packet = "'<?xml version="1.0" encoding="utf-8"?><YAMAHA_AV cmd="PUT"><Main_Zone><Volume><Lvl><Val>', in_caVolume,' 1 dB</Val><Exp></Exp><Unit></Unit></Lvl></Volume></Main_Zone></YAMAHA_AV>'"
    
    fnOnSend(" fnURI_Header(packet) ")
    fnOnSend(" packet ")
}
//On, Off, On/Off
define_function fnURI_PUT_Mute(char in_caMute[])
{
    local_var 
	char packet[MAX_RESP_LEN]
	
    packet = "'<?xml version="1.0" encoding="utf-8"?><YAMAHA_AV cmd="PUT"><Main_Zone><Volume><Mute>', in_caMute,'</Mute></Volume></Main_Zone></YAMAHA_AV>'"
    
    fnOnSend(" fnURI_Header(packet) ")
    fnOnSend(" packet ")
}

//On, Standby
define_function fnURI_PUT_Power(char in_caPower[])
{
    local_var 
	char packet[MAX_RESP_LEN]
	
    packet = "'<?xml version="1.0" encoding="utf-8"?><YAMAHA_AV cmd="PUT"><Main_Zone><Power_Control><Power>', in_caPower,'</Power></Power_Control></Main_Zone></YAMAHA_AV>'"
    
    fnOnSend(" fnURI_Header(packet) ")
    fnOnSend(" packet ")
}
//AV1 - ...
define_function fnURI_PUT_Input(char in_caInput[])
{
    local_var 
	char packet[MAX_RESP_LEN]
	
    packet = "'<?xml version="1.0" encoding="utf-8"?><YAMAHA_AV cmd="PUT"><Main_Zone><Input><Input_Sel>', in_caInput,'</Input_Sel></Input></Main_Zone></YAMAHA_AV>'"
    
    fnOnSend(" fnURI_Header(packet) ")
    fnOnSend(" packet ")
}

define_function fnURI_PUT_SurroundMode(integer in_iPreset)
{
    local_var 
	char packet[MAX_RESP_LEN]
	
    packet = "'<?xml version="1.0" encoding="utf-8"?><YAMAHA_AV cmd="PUT"><Main_Zone><Surround><Program_Sel><Current><Sound_Program>', m_caPresets[in_iPreset],'</Sound_Program></Current></Program_Sel></Surround></Main_Zone></YAMAHA_AV>'"
    
    fnOnSend(" fnURI_Header(packet) ")
    fnOnSend(" packet ")
}

define_function fnURI_PUT_Center(char in_caValue[])
{
    local_var 
	char packet[MAX_RESP_LEN]
	float l_fValue
	char l_caValue[10]
	
    l_fValue = atof(Yamaha.SpeakerPreout.Center)
    
    switch(in_caValue)
    {
	case '+': l_caValue = fnReturnValue(ftoa(l_fValue + 10))
	case '-': l_caValue = fnReturnValue(ftoa(l_fValue - 10))
	default: l_caValue = fnReturnValue(in_caValue)
    }
    
    packet = "'<?xml version="1.0" encoding="utf-8"?><YAMAHA_AV cmd="PUT"><System><Speaker_Preout><Pattern_1><Lvl><Center><Val>', l_caValue,'</Val><Exp>1</Exp><Unit>dB</Unit></Center></Lvl></Pattern_1></Speaker_Preout></System></YAMAHA_AV>'"
    
    fnOnSend(" fnURI_Header(packet) ")
    fnOnSend(" packet ")
}

define_function fnURI_PUT_Sub(char in_caValue[])
{
    local_var 
	char packet[MAX_RESP_LEN]
	float l_fValue
	char l_caValue[10]
	
    l_fValue = atof(Yamaha.SpeakerPreout.Subwoofer_1)
    
    switch(in_caValue)
    {
	case '+': l_caValue = fnReturnValue(ftoa(l_fValue + 10))
	case '-': l_caValue = fnReturnValue(ftoa(l_fValue - 10))
	default: l_caValue = fnReturnValue(in_caValue)
    }
    
    
    packet = "'<?xml version="1.0" encoding="utf-8"?><YAMAHA_AV cmd="PUT"><System><Speaker_Preout><Pattern_1><Lvl><Subwoofer_1><Val>', l_caValue,'</Val><Exp>1</Exp><Unit>dB</Unit></Subwoofer_1></Lvl></Pattern_1></Speaker_Preout></System></YAMAHA_AV>'"
    fnSendLongDebugMsg(packet)
    fnOnSend(" fnURI_Header(packet) ")
    fnOnSend(" packet ")

    packet = "'<?xml version="1.0" encoding="utf-8"?><YAMAHA_AV cmd="PUT"><System><Speaker_Preout><Pattern_1><Lvl><Subwoofer_2><Val>', l_caValue,'</Val><Exp>1</Exp><Unit>dB</Unit></Subwoofer_2></Lvl></Pattern_1></Speaker_Preout></System></YAMAHA_AV>'"
    fnSendLongDebugMsg(packet)
    fnOnSend(" fnURI_Header(packet) ")
    fnOnSend(" packet ")
    
}

define_function fnURI_PUT_Surr(char in_caValue[])
{
    local_var 
	char packet[MAX_RESP_LEN]
	float l_fValue
	char l_caValue[10]
	
    l_fValue = atof(Yamaha.SpeakerPreout.Sur_L)
    
    switch(in_caValue)
    {
	case '+': l_caValue = fnReturnValue(ftoa(l_fValue + 10))
	case '-': l_caValue = fnReturnValue(ftoa(l_fValue - 10))
	default: l_caValue = fnReturnValue(in_caValue)
    }
    
    m_caSurrValue = l_caValue
    
    /*
    if(timeline_active(TL_Surr)) {
	timeline_kill(TL_Surr)
	timeline_create(TL_Surr, m_laSurr, length_array(m_laSurr), timeline_relative, timeline_once)
    } else {
	timeline_create(TL_Surr, m_laSurr, length_array(m_laSurr), timeline_relative, timeline_once)
    }*/
    
    //Surr R
    packet = "'<?xml version="1.0" encoding="utf-8"?><YAMAHA_AV cmd="PUT"><System><Speaker_Preout><Pattern_1><Lvl><Sur_R><Val>', l_caValue,'</Val><Exp>1</Exp><Unit>dB</Unit></Sur_R></Lvl></Pattern_1></Speaker_Preout></System></YAMAHA_AV>'"
    fnSendLongDebugMsg(packet)
    fnOnSend(" fnURI_Header(packet) ")
    fnOnSend(" packet ")
    
    //Surr L
    packet = "'<?xml version="1.0" encoding="utf-8"?><YAMAHA_AV cmd="PUT"><System><Speaker_Preout><Pattern_1><Lvl><Sur_L><Val>', l_caValue,'</Val><Exp>1</Exp><Unit>dB</Unit></Sur_L></Lvl></Pattern_1></Speaker_Preout></System></YAMAHA_AV>'"
    fnSendLongDebugMsg(packet)
    fnOnSend(" fnURI_Header(packet) ")
    fnOnSend(" packet ")
}


define_function fnURI_PUT_SurrBack(char in_caValue[])
{
    local_var 
	char packet[MAX_RESP_LEN]
	float l_fValue
	char l_caValue[10]
	
    l_fValue = atof(Yamaha.SpeakerPreout.Sur_Back_L)
    
    switch(in_caValue)
    {
	case '+': l_caValue = fnReturnValue(ftoa(l_fValue + 10))
	case '-': l_caValue = fnReturnValue(ftoa(l_fValue - 10))
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

define_function fnURI_PUT_Bass(char in_caValue[])
{
    local_var 
	char packet[MAX_RESP_LEN]
	float l_fValue
	char l_caValue[10]
	
    l_fValue = atof(Yamaha.m_caBass)
    
    switch(in_caValue)
    {
	case '+': l_caValue = fnReturnValue(ftoa(l_fValue + 10))
	case '-': l_caValue = fnReturnValue(ftoa(l_fValue - 10))
	default: l_caValue = fnReturnValue(in_caValue)
    }
	
    packet = "'<?xml version="1.0" encoding="utf-8"?><YAMAHA_AV cmd="PUT"><Main_Zone><Sound_Video><Tone><Bass><Val>', l_caValue,'</Val><Exp>1</Exp><Unit>dB</Unit></Bass></Tone></Sound_Video></Main_Zone></YAMAHA_AV>'"
    
    fnOnSend(" fnURI_Header(packet) ")
    fnOnSend(" packet ")
}
define_function fnURI_PUT_Treble(char in_caValue[])
{
    local_var 
	char packet[MAX_RESP_LEN]
	float l_fValue
	char l_caValue[10]
	
    l_fValue = atof(Yamaha.m_caTreble)
    
    switch(in_caValue)
    {
	case '+': l_caValue = fnReturnValue(ftoa(l_fValue + 10))
	case '-': l_caValue = fnReturnValue(ftoa(l_fValue - 10))
	default: l_caValue = fnReturnValue(in_caValue)
    }
	
    packet = "'<?xml version="1.0" encoding="utf-8"?><YAMAHA_AV cmd="PUT"><Main_Zone><Sound_Video><Tone><Treble><Val>', l_caValue,'</Val><Exp>1</Exp><Unit>dB</Unit></Treble></Tone></Sound_Video></Main_Zone></YAMAHA_AV>'"
    
    fnOnSend(" fnURI_Header(packet) ")
    fnOnSend(" packet ")
}

define_function fnURI_PUT_ExtraBass(char in_caValue[])
{
    local_var 
	char packet[MAX_RESP_LEN]
	
    packet = "'<?xml version="1.0" encoding="utf-8"?><YAMAHA_AV cmd="PUT"><System><Speaker_Preout><Pattern_1><Config><Subwoofer><Extra_Bass>', in_caValue,'</Extra_Bass></Subwoofer></Config></Pattern_1></Speaker_Preout></System></YAMAHA_AV>'"
    
    fnOnSend(" fnURI_Header(packet) ")
    fnOnSend(" packet ")
}
define_function fnURI_PUT_Enhancer(char in_caValue[])
{
    local_var 
	char packet[MAX_RESP_LEN]
	
    packet = "'<?xml version="1.0" encoding="utf-8"?><YAMAHA_AV cmd="PUT"><Main_Zone><Surround><Program_Sel><Current><Enhancer>', in_caValue,'</Enhancer></Current></Program_Sel></Surround></Main_Zone></YAMAHA_AV>'"
    
    fnOnSend(" fnURI_Header(packet) ")
    fnOnSend(" packet ")
}
define_function fnURI_PUT_Straight(char in_caValue[])
{
    local_var 
	char packet[MAX_RESP_LEN]
	
    packet = "'<?xml version="1.0" encoding="utf-8"?><YAMAHA_AV cmd="PUT"><Main_Zone><Surround><Program_Sel><Current><Straight>', in_caValue,'</Straight></Current></Program_Sel></Surround></Main_Zone></YAMAHA_AV>'"
    
    fnOnSend(" fnURI_Header(packet) ")
    fnOnSend(" packet ")
}

define_function fnURI_GET_Volume()
{
    local_var char packet[MAX_RESP_LEN]
    
    packet = '<?xml version="1.0" encoding="utf-8"?><YAMAHA_AV cmd="GET"><Main_Zone><Volume><Lvl>GetParam</Lvl></Volume></Main_Zone></YAMAHA_AV>'
    
    fnOnSend(" fnURI_Header(packet) ")
    fnOnSend(" packet ")
}

define_function fnURI_GET_Mute()
{
    local_var char packet[MAX_RESP_LEN]
    
    packet = '<?xml version="1.0" encoding="utf-8"?><YAMAHA_AV cmd="GET"><Main_Zone><Volume><Mute>GetParam</Mute></Volume></Main_Zone></YAMAHA_AV>'

    fnOnSend(" fnURI_Header(packet) ")
    fnOnSend(" packet ")
}

define_function fnURI_GET_Center()
{
    local_var char packet[MAX_RESP_LEN]
    
    packet = '<?xml version="1.0" encoding="utf-8"?><YAMAHA_AV cmd="GET"><System><Speaker_Preout><Pattern_1><Config><Center>GetParam</Center></Config></Pattern_1></Speaker_Preout></System></YAMAHA_AV>'

    fnOnSend(" fnURI_Header(packet) ")
    fnOnSend(" packet ")
}

define_function fnURI_GET_SPLevels()
{
    local_var char packet[MAX_RESP_LEN]
    
    packet = '<?xml version="1.0" encoding="utf-8"?><YAMAHA_AV cmd="GET"><System><Speaker_Preout><Pattern_1><Lvl>GetParam</Lvl></Pattern_1></Speaker_Preout></System></YAMAHA_AV>'

    fnOnSend(" fnURI_Header(packet) ")
    fnOnSend(" packet ")
}


define_function fnURI_GET_Preamp_Config()
{
    local_var char packet[MAX_RESP_LEN]
    
    packet = '<?xml version="1.0" encoding="utf-8"?><YAMAHA_AV cmd="GET"><System><Speaker_Preout><Pattern_1><Lvl>GetParam</Lvl></Pattern_1></Speaker_Preout></System></YAMAHA_AV>

'

    fnOnSend(" fnURI_Header(packet) ")
    fnOnSend(" packet ")
}
define_function fnURI_GET_Preamp(integer in_iPattern)
{
    local_var char packet[MAX_RESP_LEN]
    
    packet = "'<?xml version="1.0" encoding="utf-8"?><YAMAHA_AV cmd="GET"><System><Speaker_Preout><Pattern_',itoa(in_iPattern),'>GetParam</Pattern_',itoa(in_iPattern),'></Speaker_Preout></System></YAMAHA_AV>'"

    fnOnSend(" fnURI_Header(packet) ")
    fnOnSend(" packet ")
}

define_function fnURI_TestCmd(char in_caData[])
{
    local_var char packet[MAX_RESP_LEN]
    
    packet = in_caData

    fnOnSend(" fnURI_Header(packet) ")
    fnOnSend(" packet ")
}

define_function fnOnSend(char in_caData[])
{
    if(m_cIsConnect)	{
	//отправка данных
	send_string dvDevice, in_caData
	//fnSendStrQ_EnqueueCommand(sendstr_queue, in_caData, 'Update')
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
    local_var 
	char l_caTmp[100]
	integer i
    
    printf("m_caDeviceName, ' - fnOnReceive = ', in_caData")
    
    if(find_string(in_caData, '<YAMAHA_AV rsp="GET" RC="0"><Main_Zone><Basic_Status>', 1)) {
    
	Yamaha.m_caPower 	= fnURI_GetParam(in_caData, 'Power')
	Yamaha.m_caSleep 	= fnURI_GetParam(in_caData, 'Sleep')
	Yamaha.m_caInput 	= fnURI_GetParam(in_caData, 'Input_Sel')
	Yamaha.m_caVolume 	= fnURI_GetParam(fnURI_GetParam(fnURI_GetParam(in_caData, 'Volume'), 'Lvl'), 'Val')
	Yamaha.m_caMute 	= fnURI_GetParam(in_caData, 'Mute')
	Yamaha.m_caSound 	= fnURI_GetParam(in_caData, 'Sound_Program')
	Yamaha.m_caStraight 	= fnURI_GetParam(in_caData, 'Straight')
	Yamaha.m_caEnhancer 	= fnURI_GetParam(in_caData, 'Enhancer')
	Yamaha.m_caBass 	= fnURI_GetParam(fnURI_GetParam(in_caData, 'Bass'), 'Val')
	Yamaha.m_caTreble 	= fnURI_GetParam(fnURI_GetParam(in_caData, 'Treble'), 'Val')
	
	for(i = 1; i <= length_array(dvPanels); i++) {
	    fnPanelUpdate(i)
	}
    } else
    if(find_string(in_caData, '<YAMAHA_AV rsp="GET" RC="0"><System><Speaker_Preout>', 1)) {
	
	Yamaha.SpeakerPreout.Front_L 		= fnURI_GetParam(fnURI_GetParam(in_caData, 'Front_L'), 'Val')
	Yamaha.SpeakerPreout.Front_R 		= fnURI_GetParam(fnURI_GetParam(in_caData, 'Front_R'), 'Val')
	Yamaha.SpeakerPreout.Center 		= fnURI_GetParam(fnURI_GetParam(in_caData, 'Center'), 'Val')
	Yamaha.SpeakerPreout.Sur_L 		= fnURI_GetParam(fnURI_GetParam(in_caData, 'Sur_L'), 'Val')
	Yamaha.SpeakerPreout.Sur_R 		= fnURI_GetParam(fnURI_GetParam(in_caData, 'Sur_R'), 'Val')
	Yamaha.SpeakerPreout.Sur_Back_L 	= fnURI_GetParam(fnURI_GetParam(in_caData, 'Sur_Back_L'), 'Val')
	Yamaha.SpeakerPreout.Sur_Back_R 	= fnURI_GetParam(fnURI_GetParam(in_caData, 'Sur_Back_R'), 'Val')
	Yamaha.SpeakerPreout.Front_Presence_L 	= fnURI_GetParam(fnURI_GetParam(in_caData, 'Front_Presence_L'), 'Val')
	Yamaha.SpeakerPreout.Front_Presence_R 	= fnURI_GetParam(fnURI_GetParam(in_caData, 'Front_Presence_R'), 'Val')
	Yamaha.SpeakerPreout.Rear_Presence_L 	= fnURI_GetParam(fnURI_GetParam(in_caData, 'Rear_Presence_L'), 'Val')
	Yamaha.SpeakerPreout.Rear_Presence_R 	= fnURI_GetParam(fnURI_GetParam(in_caData, 'Rear_Presence_R'), 'Val')
	Yamaha.SpeakerPreout.Subwoofer_1 	= fnURI_GetParam(fnURI_GetParam(in_caData, 'Subwoofer_1'), 'Val')
	Yamaha.SpeakerPreout.Subwoofer_2 	= fnURI_GetParam(fnURI_GetParam(in_caData, 'Subwoofer_2'), 'Val')

	for(i = 1; i <= length_array(dvPanels); i++) {
	    fnPanelUpdate(i)
	}
    }
}

define_function fnPanelUpdate(integer in_iPanel)
{
    local_var integer y
    
    if(Yamaha.m_caPower == 'On') {
	for(y = 1; y <= length_array(m_caPresets); y++) {
	    [dvPanels[in_iPanel], 100 + y] = (m_caPresets[y] == Yamaha.m_caSound)
	    send_command dvPanels[in_iPanel], "'^TXT-', itoa(100 + y),',0,', m_caPresets[y]"
	}
	
	//send_level dvPanels[in_iPanel], 1, atof(Yamaha.SpeakerPreout.Center)/10
	//send_level dvPanels[in_iPanel], 2, atof(Yamaha.SpeakerPreout.Subwoofer_1)/10
	//send_level dvPanels[in_iPanel], 3, atof(Yamaha.m_caBass)/10
	//send_level dvPanels[in_iPanel], 4, atof(Yamaha.m_caTreble)/10
	send_command dvPanels[in_iPanel], "'^TXT-11,0,',ftoa(atof(Yamaha.SpeakerPreout.Center)/10),' dB'"
	send_command dvPanels[in_iPanel], "'^TXT-12,0,',ftoa(atof(Yamaha.SpeakerPreout.Subwoofer_1)/10),' dB'"
	send_command dvPanels[in_iPanel], "'^TXT-13,0,',ftoa(atof(Yamaha.m_caBass)/10),' dB'"
	send_command dvPanels[in_iPanel], "'^TXT-14,0,',ftoa(atof(Yamaha.m_caTreble)/10),' dB'"
	send_command dvPanels[in_iPanel], "'^TXT-15,0,',ftoa(atof(Yamaha.SpeakerPreout.Sur_L)/10),' dB'"
	send_command dvPanels[in_iPanel], "'^TXT-16,0,',ftoa(atof(Yamaha.SpeakerPreout.Sur_Back_L)/10),' dB'"
	
	[dvPanels[in_iPanel], 191] = (Yamaha.m_caEnhancer == 'On')
	[dvPanels[in_iPanel], 192] = (Yamaha.m_caStraight == 'On')
	
	
	send_command dvPanels[in_iPanel], "'^TXT-1,0,', Yamaha.m_caSound"
	send_command dvPanels[in_iPanel], "'^TXT-2,0,Volume ', ftoa(atof(Yamaha.m_caVolume)/10), ' dB'"
    } else {
	//send_command dvPanels[in_iPanel], "'^TXT-2,0, '"
    }
}

define_function char[100] fnURI_GetParam(char in_caData[], char in_iParam[])
{
    local_var 
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

define_function fnVolume(char in_caCommand[])
{
    m_caVolume = in_caCommand
    
    if(in_caCommand == 'Stop') {
	timeline_kill(TL_VOL_ID)
    } else {
	if(timeline_active(TL_VOL_ID)) {
	    timeline_kill(TL_VOL_ID)
	    timeline_create(TL_VOL_ID, m_laVolume, 1, timeline_absolute, timeline_repeat)
	} else {
	    timeline_create(TL_VOL_ID, m_laVolume, 1, timeline_absolute, timeline_repeat)
	}
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

DEFINE_START



DEFINE_EVENT

timeline_event[TL_Surr]
{
    local_var char packet[MAX_RESP_LEN]
    
    switch(timeline.sequence)
    {
	case 1:
	{
	    //Surr R
	    packet = "'<?xml version="1.0" encoding="utf-8"?><YAMAHA_AV cmd="PUT"><System><Speaker_Preout><Pattern_1><Lvl><Sur_R><Val>', m_caSurrValue,'</Val><Exp>1</Exp><Unit>dB</Unit></Sur_R></Lvl></Pattern_1></Speaker_Preout></System></YAMAHA_AV>'"
	    //fnSendLongDebugMsg(packet)
	    fnOnSend(" fnURI_Header(packet) ")
	    fnOnSend(" packet ")
	    
	    //Surr L
	    packet = "'<?xml version="1.0" encoding="utf-8"?><YAMAHA_AV cmd="PUT"><System><Speaker_Preout><Pattern_1><Lvl><Sur_L><Val>', m_caSurrValue,'</Val><Exp>1</Exp><Unit>dB</Unit></Sur_L></Lvl></Pattern_1></Speaker_Preout></System></YAMAHA_AV>'"
	    //fnSendLongDebugMsg(packet)
	    fnOnSend(" fnURI_Header(packet) ")
	    fnOnSend(" packet ")
	}
	case 2:
	{
	    //Surr Back R
	    packet = "'<?xml version="1.0" encoding="utf-8"?><YAMAHA_AV cmd="PUT"><System><Speaker_Preout><Pattern_1><Lvl><Sur_Back_R><Val>', m_caSurrValue,'</Val><Exp>1</Exp><Unit>dB</Unit></Sur_Back_R></Lvl></Pattern_1></Speaker_Preout></System></YAMAHA_AV>'"
	    //fnSendLongDebugMsg(packet)
	    fnOnSend(" fnURI_Header(packet) ")
	    fnOnSend(" packet ")
	    
	    //Surr Back L
	    packet = "'<?xml version="1.0" encoding="utf-8"?><YAMAHA_AV cmd="PUT"><System><Speaker_Preout><Pattern_1><Lvl><Sur_Back_L><Val>', m_caSurrValue,'</Val><Exp>1</Exp><Unit>dB</Unit></Sur_Back_L></Lvl></Pattern_1></Speaker_Preout></System></YAMAHA_AV>'"
	    //fnSendLongDebugMsg(packet)
	    fnOnSend(" fnURI_Header(packet) ")
	    fnOnSend(" packet ")
	}
    }
}


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

timeline_event[TL_VOL_ID]
{
    if(timeline.sequence == 1) {
	switch(m_caVolume)
	{
	    case 'Up':
	    case 'Down':
		fnURI_PUT_Volume(m_caVolume)
	    case 'Stop':
		timeline_kill(TL_VOL_ID)
	}
    }
}

data_event[dvPanels]
{
    online:
    {
	fnURI_GET_SPLevels()
	fnPanelUpdate(get_last(dvPanels))
    }
    offline:
    {
    }
    string:
    {
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
	local_var 
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
		    fnOnConnect(dvDevice, caHost, iPort)
		
		timeline_create(TL_WORK_ID, m_laWork, 1, TIMELINE_ABSOLUTE, TIMELINE_REPEAT)
		
		send_string vdvDevice, "m_caDeviceName, ' [',fnReturnDPS(dvDevice),'] MODULE START'"
	    }
	    active(find_string(l_caReadData, 'STOP;', 1) == 1):
	    {
		fnOnDisconnect(dvDevice)
		// остановка потока для поддержания соединения
		timeline_kill(TL_WORK_ID);
		
		send_string vdvDevice, "m_caDeviceName, ' [',fnReturnDPS(dvDevice),'] MODULE STOP'"
	    }
	    active(find_string(l_caReadData, 'SET_POWER ON;', 1) == 1):
	    {
		fnURI_PUT_Power('On')
	    }
	    active(find_string(l_caReadData, 'SET_POWER OFF;', 1) == 1):
	    {
		if(Yamaha.m_caPower == 'On')
		    fnURI_PUT_Power('Standby')
	    }
	    active(find_string(l_caReadData, 'SET_INPUT', 1) == 1): //
	    {
		l_caTemp = remove_string(l_caReadData, 'SET_INPUT ', 1)
		//
		fnStr_GetStringWhile(l_caReadData, m_caInput, ';')
		
		if(Yamaha.m_caPower == 'On') {
		    fnURI_PUT_Input(m_caInput)
		} else {
		    //cancel_wait 'Yamaha_power'
		    fnURI_PUT_Power('On')
		    //wait 20 'Yamaha_power'
		    timed_wait_until ([vdvDevice, 255]) 100 'Yamaha_power' {
			fnURI_PUT_Input(m_caInput)
		    }
		}
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
	fnSendLongDebugMsg(l_caReadData)
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

button_event[dvPanels, 0]
{
    push:
    {
	local_var 
	    integer l_iBtn
	    integer l_iPanel
	
	l_iPanel = get_last(dvPanels)
	l_iBtn = button.input.channel
	
	//to[dvPanels[l_iPanel], l_iBtn]
	fnResetPing()
	
	if(l_iBtn == 99) {
	    fnURI_GET_SPLevels()
	    fnPanelUpdate(get_last(dvPanels))
	} else
	if(l_iBtn >= 101 && l_iBtn <= 125) {
	    fnURI_PUT_SurroundMode(l_iBtn - 100)
	} else
	if(l_iBtn == 191) {
	    if(Yamaha.m_caEnhancer == 'On')
		fnURI_PUT_Enhancer('Off')
	    else
		fnURI_PUT_Enhancer('On')
	} else
	if(l_iBtn == 192) {
	    if(Yamaha.m_caStraight == 'On')
		fnURI_PUT_Straight('Off')
	    else
		fnURI_PUT_Straight('On')
	} else
	if(l_iBtn == 193) {
	    if(Yamaha.m_caExtraBass == 'On')
		fnURI_PUT_ExtraBass('Off')
	    else
		fnURI_PUT_ExtraBass('On')
	} else
	if(l_iBtn >= 201 && l_iBtn <= 240) {
	    
	    switch(l_iBtn)
	    {
		case 201: fnURI_PUT_Center('+')//center +
		case 202: fnURI_PUT_Center('-')//center -
		case 203: fnURI_PUT_Sub('+')//sub +
		case 204: fnURI_PUT_Sub('-')//sub -
		case 205: fnURI_PUT_Bass('+')//bass +
		case 206: fnURI_PUT_Bass('-')//bass -
		case 207: fnURI_PUT_Treble('+')//treble +
		case 208: fnURI_PUT_Treble('-')//treble -
		case 209: fnURI_PUT_Surr('+')//surr +
		case 210: fnURI_PUT_Surr('-')//surr -
		case 211: fnURI_PUT_SurrBack('+')//surr +
		case 212: fnURI_PUT_SurrBack('-')//surr -
		
		case 221: fnURI_PUT_Center('0')
		case 222: fnURI_PUT_Sub('0')
		case 223: fnURI_PUT_Bass('0')
		case 224: fnURI_PUT_Treble('0')
		case 225: fnURI_PUT_Surr('0')
		case 226: fnURI_PUT_SurrBack('0')
	    }
	}
    }
    release:
    {
	local_var 
	    integer l_iBtn
	    integer l_iPanel
	
	l_iPanel = get_last(dvPanels)
	l_iBtn = button.input.channel
	
	if((l_iBtn >= 101 && l_iBtn <= 125) || l_iBtn == 191 || l_iBtn == 192 || (l_iBtn >= 205 && l_iBtn <= 208) || l_iBtn == 223 || l_iBtn == 224) {
	    //fnResetPing()
	    fnOnPing()
	} else {
	    //fnResetPing()
	    fnURI_GET_SPLevels()
	}
	//fnPanelUpdate(get_last(dvPanels))
    }
    hold[5, repeat]:
    {
	
    }
}
/*
level_event[dvPanels, 0]
{
    local_var 
	integer l_iLevel
	float l_fValue
    
    l_iLevel = level.input.level
    l_fValue = level.value
    
    //send_command 0, "m_caDeviceName, ' TP Level_', itoa(level.input.level),' ; Value = ', ftoa(level.value)"
    
    switch(l_iLevel)
    {
	case 1: fnURI_PUT_Center(ftoa(l_fValue*10))//center
	case 2: fnURI_PUT_Sub(ftoa(l_fValue*10))//sub
	case 3: fnURI_PUT_Bass(ftoa(l_fValue*10))//bass
	case 4: fnURI_PUT_Treble(ftoa(l_fValue*10))//treble
    }
    
    fnURI_GET_SPLevels()

}
*/
channel_event[vdvDevice, 0]
{
    on:	{
	local_var integer l_iCh
	
	cancel_wait 'vol'
	
	l_iCh = channel.channel
	
	if(l_iCh == 97)	{ 
			    fnURI_PUT_Volume('Up')
			    fnVolume('Up')
	}
	if(l_iCh == 98)	{ 
			    fnURI_PUT_Volume('Down')
			    fnVolume('Down')
	}
	if(l_iCh == 99)	{ 
			    fnURI_PUT_Mute('On/Off')
	}
    }
    off:{
	fnVolume('Stop')
	
	wait 1 'vol'
	fnOnPing()
    }
}
(***********************************************************)
(*            THE ACTUAL PROGRAM GOES BELOW                *)
(***********************************************************)
DEFINE_PROGRAM

//[vdvDevice, 255] = (Yamaha.m_caPower == 'On')
(***********************************************************)
(*                     END OF PROGRAM                      *)
(*        DO NOT PUT ANY CODE BELOW THIS COMMENT           *)
(***********************************************************)

/*
<?xml version="1.0" encoding="utf-8"?><YAMAHA_AV cmd="PUT"><System><Misc><Event><Notice>On</Notice></Event></Misc></System></YAMAHA_AV>
<?xml version="1.0" encoding="utf-8"?><YAMAHA_AV cmd="PUT"><Main_Zone><Power_Control><Power>Standby</Power></Power_Control></Main_Zone></YAMAHA_AV>
<?xml version="1.0" encoding="utf-8"?><YAMAHA_AV cmd="PUT"><Main_Zone><Power_Control><Power>On</Power></Power_Control></Main_Zone></YAMAHA_AV>
<?xml version="1.0" encoding="utf-8"?><YAMAHA_AV cmd="PUT"><Main_Zone><Power_Control><Power>On/Standby</Power></Power_Control></Main_Zone></YAMAHA_AV>
<?xml version="1.0" encoding="utf-8"?><YAMAHA_AV cmd="PUT"><Main_Zone><Power_Control><Sleep>Off</Sleep></Power_Control></Main_Zone></YAMAHA_AV>
<?xml version="1.0" encoding="utf-8"?><YAMAHA_AV cmd="PUT"><Main_Zone><Power_Control><Sleep>30 min</Sleep></Power_Control></Main_Zone></YAMAHA_AV>
<?xml version="1.0" encoding="utf-8"?><YAMAHA_AV cmd="PUT"><Main_Zone><Power_Control><Sleep>60 min</Sleep></Power_Control></Main_Zone></YAMAHA_AV>
<?xml version="1.0" encoding="utf-8"?><YAMAHA_AV cmd="PUT"><Main_Zone><Power_Control><Sleep>90 min</Sleep></Power_Control></Main_Zone></YAMAHA_AV>
<?xml version="1.0" encoding="utf-8"?><YAMAHA_AV cmd="PUT"><Main_Zone><Power_Control><Sleep>120 min</Sleep></Power_Control></Main_Zone></YAMAHA_AV>
<?xml version="1.0" encoding="utf-8"?><YAMAHA_AV cmd="PUT"><Main_Zone><Power_Control><Sleep>Last</Sleep></Power_Control></Main_Zone></YAMAHA_AV>
<?xml version="1.0" encoding="utf-8"?><YAMAHA_AV cmd="PUT"><Main_Zone><Volume><Lvl><Val>Down</Val><Exp></Exp><Unit></Unit></Lvl></Volume></Main_Zone></YAMAHA_AV>
<?xml version="1.0" encoding="utf-8"?><YAMAHA_AV cmd="PUT"><Main_Zone><Volume><Lvl><Val>Up</Val><Exp></Exp><Unit></Unit></Lvl></Volume></Main_Zone></YAMAHA_AV>
<?xml version="1.0" encoding="utf-8"?><YAMAHA_AV cmd="PUT"><Main_Zone><Volume><Lvl><Val>Down 1 dB</Val><Exp></Exp><Unit></Unit></Lvl></Volume></Main_Zone></YAMAHA_AV>
<?xml version="1.0" encoding="utf-8"?><YAMAHA_AV cmd="PUT"><Main_Zone><Volume><Lvl><Val>Up 1 dB</Val><Exp></Exp><Unit></Unit></Lvl></Volume></Main_Zone></YAMAHA_AV>
<?xml version="1.0" encoding="utf-8"?><YAMAHA_AV cmd="PUT"><Main_Zone><Volume><Lvl><Val>Down 2 dB</Val><Exp></Exp><Unit></Unit></Lvl></Volume></Main_Zone></YAMAHA_AV>
<?xml version="1.0" encoding="utf-8"?><YAMAHA_AV cmd="PUT"><Main_Zone><Volume><Lvl><Val>Up 2 dB</Val><Exp></Exp><Unit></Unit></Lvl></Volume></Main_Zone></YAMAHA_AV>
<?xml version="1.0" encoding="utf-8"?><YAMAHA_AV cmd="PUT"><Main_Zone><Volume><Lvl><Val>Down 5 dB</Val><Exp></Exp><Unit></Unit></Lvl></Volume></Main_Zone></YAMAHA_AV>
<?xml version="1.0" encoding="utf-8"?><YAMAHA_AV cmd="PUT"><Main_Zone><Volume><Lvl><Val>Up 5 dB</Val><Exp></Exp><Unit></Unit></Lvl></Volume></Main_Zone></YAMAHA_AV>
<?xml version="1.0" encoding="utf-8"?><YAMAHA_AV cmd="PUT"><Main_Zone><Volume><Lvl><Val>-805</Val><Exp></Exp><Unit></Unit></Lvl></Volume></Main_Zone></YAMAHA_AV>
<?xml version="1.0" encoding="utf-8"?><YAMAHA_AV cmd="PUT"><Main_Zone><Volume><Lvl><Val>-800</Val><Exp></Exp><Unit></Unit></Lvl></Volume></Main_Zone></YAMAHA_AV>
<?xml version="1.0" encoding="utf-8"?><YAMAHA_AV cmd="PUT"><Main_Zone><Volume><Lvl><Val>-795</Val><Exp></Exp><Unit></Unit></Lvl></Volume></Main_Zone></YAMAHA_AV>
<?xml version="1.0" encoding="utf-8"?><YAMAHA_AV cmd="PUT"><Main_Zone><Volume><Lvl><Val>155</Val><Exp></Exp><Unit></Unit></Lvl></Volume></Main_Zone></YAMAHA_AV>
<?xml version="1.0" encoding="utf-8"?><YAMAHA_AV cmd="PUT"><Main_Zone><Volume><Lvl><Val>160</Val><Exp></Exp><Unit></Unit></Lvl></Volume></Main_Zone></YAMAHA_AV>
<?xml version="1.0" encoding="utf-8"?><YAMAHA_AV cmd="PUT"><Main_Zone><Volume><Lvl><Val>165</Val><Exp></Exp><Unit></Unit></Lvl></Volume></Main_Zone></YAMAHA_AV>
<?xml version="1.0" encoding="utf-8"?><YAMAHA_AV cmd="PUT"><Main_Zone><Volume><Mute>Off</Mute></Volume></Main_Zone></YAMAHA_AV>
<?xml version="1.0" encoding="utf-8"?><YAMAHA_AV cmd="PUT"><Main_Zone><Volume><Mute>Att -40 dB</Mute></Volume></Main_Zone></YAMAHA_AV>
<?xml version="1.0" encoding="utf-8"?><YAMAHA_AV cmd="PUT"><Main_Zone><Volume><Mute>Att -20 dB</Mute></Volume></Main_Zone></YAMAHA_AV>
<?xml version="1.0" encoding="utf-8"?><YAMAHA_AV cmd="PUT"><Main_Zone><Volume><Mute>On</Mute></Volume></Main_Zone></YAMAHA_AV>
<?xml version="1.0" encoding="utf-8"?><YAMAHA_AV cmd="PUT"><Main_Zone><Volume><Mute>On/Off</Mute></Volume></Main_Zone></YAMAHA_AV>
<?xml version="1.0" encoding="utf-8"?><YAMAHA_AV cmd="PUT"><Main_Zone><Volume><Max_Lvl><Val>-300</Val><Exp>1</Exp><Unit>dB</Unit></Max_Lvl></Volume></Main_Zone></YAMAHA_AV>
<?xml version="1.0" encoding="utf-8"?><YAMAHA_AV cmd="PUT"><Main_Zone><Volume><Max_Lvl><Val>-250</Val><Exp>1</Exp><Unit>dB</Unit></Max_Lvl></Volume></Main_Zone></YAMAHA_AV>
<?xml version="1.0" encoding="utf-8"?><YAMAHA_AV cmd="PUT"><Main_Zone><Volume><Max_Lvl><Val>-200</Val><Exp>1</Exp><Unit>dB</Unit></Max_Lvl></Volume></Main_Zone></YAMAHA_AV>
<?xml version="1.0" encoding="utf-8"?><YAMAHA_AV cmd="PUT"><Main_Zone><Volume><Max_Lvl><Val>50</Val><Exp>1</Exp><Unit>dB</Unit></Max_Lvl></Volume></Main_Zone></YAMAHA_AV>
<?xml version="1.0" encoding="utf-8"?><YAMAHA_AV cmd="PUT"><Main_Zone><Volume><Max_Lvl><Val>100</Val><Exp>1</Exp><Unit>dB</Unit></Max_Lvl></Volume></Main_Zone></YAMAHA_AV>
<?xml version="1.0" encoding="utf-8"?><YAMAHA_AV cmd="PUT"><Main_Zone><Volume><Max_Lvl><Val>150</Val><Exp>1</Exp><Unit>dB</Unit></Max_Lvl></Volume></Main_Zone></YAMAHA_AV>
<?xml version="1.0" encoding="utf-8"?><YAMAHA_AV cmd="PUT"><Main_Zone><Volume><Max_Lvl><Val>165</Val><Exp>1</Exp><Unit>dB</Unit></Max_Lvl></Volume></Main_Zone></YAMAHA_AV>
<?xml version="1.0" encoding="utf-8"?><YAMAHA_AV cmd="PUT"><Main_Zone><Volume><Init_Lvl><Mode>Off</Mode></Init_Lvl></Volume></Main_Zone></YAMAHA_AV>
<?xml version="1.0" encoding="utf-8"?><YAMAHA_AV cmd="PUT"><Main_Zone><Volume><Init_Lvl><Mode>On</Mode></Init_Lvl></Volume></Main_Zone></YAMAHA_AV>
<?xml version="1.0" encoding="utf-8"?><YAMAHA_AV cmd="PUT"><Main_Zone><Volume><Init_Lvl><Lvl><Val>Mute</Val><Exp></Exp><Unit></Unit></Lvl></Init_Lvl></Volume></Main_Zone></YAMAHA_AV>
<?xml version="1.0" encoding="utf-8"?><YAMAHA_AV cmd="PUT"><Main_Zone><Volume><Init_Lvl><Lvl><Val>-800</Val><Exp></Exp><Unit></Unit></Lvl></Init_Lvl></Volume></Main_Zone></YAMAHA_AV>
<?xml version="1.0" encoding="utf-8"?><YAMAHA_AV cmd="PUT"><Main_Zone><Volume><Init_Lvl><Lvl><Val>-795</Val><Exp></Exp><Unit></Unit></Lvl></Init_Lvl></Volume></Main_Zone></YAMAHA_AV>
<?xml version="1.0" encoding="utf-8"?><YAMAHA_AV cmd="PUT"><Main_Zone><Volume><Init_Lvl><Lvl><Val>-790</Val><Exp></Exp><Unit></Unit></Lvl></Init_Lvl></Volume></Main_Zone></YAMAHA_AV>
<?xml version="1.0" encoding="utf-8"?><YAMAHA_AV cmd="PUT"><Main_Zone><Volume><Init_Lvl><Lvl><Val>155</Val><Exp></Exp><Unit></Unit></Lvl></Init_Lvl></Volume></Main_Zone></YAMAHA_AV>
<?xml version="1.0" encoding="utf-8"?><YAMAHA_AV cmd="PUT"><Main_Zone><Volume><Init_Lvl><Lvl><Val>160</Val><Exp></Exp><Unit></Unit></Lvl></Init_Lvl></Volume></Main_Zone></YAMAHA_AV>
<?xml version="1.0" encoding="utf-8"?><YAMAHA_AV cmd="PUT"><Main_Zone><Volume><Init_Lvl><Lvl><Val>165</Val><Exp>1</Exp><Unit>dB</Unit></Lvl></Init_Lvl></Volume></Main_Zone></YAMAHA_AV>
<?xml version="1.0" encoding="utf-8"?><YAMAHA_AV cmd="PUT"><Main_Zone><Input><Input_Sel>TUNER</Input_Sel></Input></Main_Zone></YAMAHA_AV>
<?xml version="1.0" encoding="utf-8"?><YAMAHA_AV cmd="PUT"><Main_Zone><Input><Input_Sel>MULTI CH</Input_Sel></Input></Main_Zone></YAMAHA_AV>
<?xml version="1.0" encoding="utf-8"?><YAMAHA_AV cmd="PUT"><Main_Zone><Input><Input_Sel>PHONO</Input_Sel></Input></Main_Zone></YAMAHA_AV>
<?xml version="1.0" encoding="utf-8"?><YAMAHA_AV cmd="PUT"><Main_Zone><Input><Input_Sel>AV1</Input_Sel></Input></Main_Zone></YAMAHA_AV>
<?xml version="1.0" encoding="utf-8"?><YAMAHA_AV cmd="PUT"><Main_Zone><Input><Input_Sel>AV2</Input_Sel></Input></Main_Zone></YAMAHA_AV>
<?xml version="1.0" encoding="utf-8"?><YAMAHA_AV cmd="PUT"><Main_Zone><Input><Input_Sel>AV3</Input_Sel></Input></Main_Zone></YAMAHA_AV>
<?xml version="1.0" encoding="utf-8"?><YAMAHA_AV cmd="PUT"><Main_Zone><Input><Input_Sel>AV4</Input_Sel></Input></Main_Zone></YAMAHA_AV>
<?xml version="1.0" encoding="utf-8"?><YAMAHA_AV cmd="PUT"><Main_Zone><Input><Input_Sel>AV5</Input_Sel></Input></Main_Zone></YAMAHA_AV>
<?xml version="1.0" encoding="utf-8"?><YAMAHA_AV cmd="PUT"><Main_Zone><Input><Input_Sel>AV6</Input_Sel></Input></Main_Zone></YAMAHA_AV>
<?xml version="1.0" encoding="utf-8"?><YAMAHA_AV cmd="PUT"><Main_Zone><Input><Input_Sel>AV7</Input_Sel></Input></Main_Zone></YAMAHA_AV>
<?xml version="1.0" encoding="utf-8"?><YAMAHA_AV cmd="PUT"><Main_Zone><Input><Input_Sel>V-AUX</Input_Sel></Input></Main_Zone></YAMAHA_AV>
<?xml version="1.0" encoding="utf-8"?><YAMAHA_AV cmd="PUT"><Main_Zone><Input><Input_Sel>AUDIO1</Input_Sel></Input></Main_Zone></YAMAHA_AV>
<?xml version="1.0" encoding="utf-8"?><YAMAHA_AV cmd="PUT"><Main_Zone><Input><Input_Sel>AUDIO2</Input_Sel></Input></Main_Zone></YAMAHA_AV>
<?xml version="1.0" encoding="utf-8"?><YAMAHA_AV cmd="PUT"><Main_Zone><Input><Input_Sel>AUDIO3</Input_Sel></Input></Main_Zone></YAMAHA_AV>
<?xml version="1.0" encoding="utf-8"?><YAMAHA_AV cmd="PUT"><Main_Zone><Input><Input_Sel>AUDIO4</Input_Sel></Input></Main_Zone></YAMAHA_AV>
<?xml version="1.0" encoding="utf-8"?><YAMAHA_AV cmd="PUT"><Main_Zone><Input><Input_Sel>DOCK</Input_Sel></Input></Main_Zone></YAMAHA_AV>
<?xml version="1.0" encoding="utf-8"?><YAMAHA_AV cmd="PUT"><Main_Zone><Input><Input_Sel>iPod</Input_Sel></Input></Main_Zone></YAMAHA_AV>
<?xml version="1.0" encoding="utf-8"?><YAMAHA_AV cmd="PUT"><Main_Zone><Input><Input_Sel>Bluetooth</Input_Sel></Input></Main_Zone></YAMAHA_AV>
<?xml version="1.0" encoding="utf-8"?><YAMAHA_AV cmd="PUT"><Main_Zone><Input><Input_Sel>UAW</Input_Sel></Input></Main_Zone></YAMAHA_AV>
<?xml version="1.0" encoding="utf-8"?><YAMAHA_AV cmd="PUT"><Main_Zone><Input><Input_Sel>NET</Input_Sel></Input></Main_Zone></YAMAHA_AV>
<?xml version="1.0" encoding="utf-8"?><YAMAHA_AV cmd="PUT"><Main_Zone><Input><Input_Sel>PC</Input_Sel></Input></Main_Zone></YAMAHA_AV>
<?xml version="1.0" encoding="utf-8"?><YAMAHA_AV cmd="PUT"><Main_Zone><Input><Input_Sel>NET RADIO</Input_Sel></Input></Main_Zone></YAMAHA_AV>
<?xml version="1.0" encoding="utf-8"?><YAMAHA_AV cmd="PUT"><Main_Zone><Input><Input_Sel>USB</Input_Sel></Input></Main_Zone></YAMAHA_AV>
<?xml version="1.0" encoding="utf-8"?><YAMAHA_AV cmd="PUT"><Main_Zone><Input><Input_Sel>iPod (USB)</Input_Sel></Input></Main_Zone></YAMAHA_AV>

<?xml version="1.0" encoding="utf-8"?><YAMAHA_AV cmd="PUT"><Main_Zone><Surround><Program_Sel><Current><Straight>Off</Straight></Current></Program_Sel></Surround></Main_Zone></YAMAHA_AV>
<?xml version="1.0" encoding="utf-8"?><YAMAHA_AV cmd="PUT"><Main_Zone><Surround><Program_Sel><Current><Straight>On</Straight></Current></Program_Sel></Surround></Main_Zone></YAMAHA_AV>
<?xml version="1.0" encoding="utf-8"?><YAMAHA_AV cmd="PUT"><Main_Zone><Surround><Program_Sel><Current><Enhancer>Off</Enhancer></Current></Program_Sel></Surround></Main_Zone></YAMAHA_AV>
<?xml version="1.0" encoding="utf-8"?><YAMAHA_AV cmd="PUT"><Main_Zone><Surround><Program_Sel><Current><Enhancer>On</Enhancer></Current></Program_Sel></Surround></Main_Zone></YAMAHA_AV>
<?xml version="1.0" encoding="utf-8"?><YAMAHA_AV cmd="PUT"><Main_Zone><Surround><Program_Sel><Current><Sound_Program>Hall in Munich</Sound_Program></Current></Program_Sel></Surround></Main_Zone></YAMAHA_AV>
<?xml version="1.0" encoding="utf-8"?><YAMAHA_AV cmd="PUT"><Main_Zone><Surround><Program_Sel><Current><Sound_Program>Hall in Vienna</Sound_Program></Current></Program_Sel></Surround></Main_Zone></YAMAHA_AV>
<?xml version="1.0" encoding="utf-8"?><YAMAHA_AV cmd="PUT"><Main_Zone><Surround><Program_Sel><Current><Sound_Program>Hall in Amsterdam</Sound_Program></Current></Program_Sel></Surround></Main_Zone></YAMAHA_AV>
<?xml version="1.0" encoding="utf-8"?><YAMAHA_AV cmd="PUT"><Main_Zone><Surround><Program_Sel><Current><Sound_Program>Church in Freiburg</Sound_Program></Current></Program_Sel></Surround></Main_Zone></YAMAHA_AV>
<?xml version="1.0" encoding="utf-8"?><YAMAHA_AV cmd="PUT"><Main_Zone><Surround><Program_Sel><Current><Sound_Program>Church in Royaumont</Sound_Program></Current></Program_Sel></Surround></Main_Zone></YAMAHA_AV>
<?xml version="1.0" encoding="utf-8"?><YAMAHA_AV cmd="PUT"><Main_Zone><Surround><Program_Sel><Current><Sound_Program>Chamber</Sound_Program></Current></Program_Sel></Surround></Main_Zone></YAMAHA_AV>
<?xml version="1.0" encoding="utf-8"?><YAMAHA_AV cmd="PUT"><Main_Zone><Surround><Program_Sel><Current><Sound_Program>Village Vanguard</Sound_Program></Current></Program_Sel></Surround></Main_Zone></YAMAHA_AV>
<?xml version="1.0" encoding="utf-8"?><YAMAHA_AV cmd="PUT"><Main_Zone><Surround><Program_Sel><Current><Sound_Program>Warehouse Loft</Sound_Program></Current></Program_Sel></Surround></Main_Zone></YAMAHA_AV>
<?xml version="1.0" encoding="utf-8"?><YAMAHA_AV cmd="PUT"><Main_Zone><Surround><Program_Sel><Current><Sound_Program>Cellar Club</Sound_Program></Current></Program_Sel></Surround></Main_Zone></YAMAHA_AV>
<?xml version="1.0" encoding="utf-8"?><YAMAHA_AV cmd="PUT"><Main_Zone><Surround><Program_Sel><Current><Sound_Program>The Roxy Theatre</Sound_Program></Current></Program_Sel></Surround></Main_Zone></YAMAHA_AV>
<?xml version="1.0" encoding="utf-8"?><YAMAHA_AV cmd="PUT"><Main_Zone><Surround><Program_Sel><Current><Sound_Program>The Bottom Line</Sound_Program></Current></Program_Sel></Surround></Main_Zone></YAMAHA_AV>
<?xml version="1.0" encoding="utf-8"?><YAMAHA_AV cmd="PUT"><Main_Zone><Surround><Program_Sel><Current><Sound_Program>Sports</Sound_Program></Current></Program_Sel></Surround></Main_Zone></YAMAHA_AV>
<?xml version="1.0" encoding="utf-8"?><YAMAHA_AV cmd="PUT"><Main_Zone><Surround><Program_Sel><Current><Sound_Program>Action Game</Sound_Program></Current></Program_Sel></Surround></Main_Zone></YAMAHA_AV>
<?xml version="1.0" encoding="utf-8"?><YAMAHA_AV cmd="PUT"><Main_Zone><Surround><Program_Sel><Current><Sound_Program>Roleplaying Game</Sound_Program></Current></Program_Sel></Surround></Main_Zone></YAMAHA_AV>
<?xml version="1.0" encoding="utf-8"?><YAMAHA_AV cmd="PUT"><Main_Zone><Surround><Program_Sel><Current><Sound_Program>Music Video</Sound_Program></Current></Program_Sel></Surround></Main_Zone></YAMAHA_AV>
<?xml version="1.0" encoding="utf-8"?><YAMAHA_AV cmd="PUT"><Main_Zone><Surround><Program_Sel><Current><Sound_Program>Recital/Opera</Sound_Program></Current></Program_Sel></Surround></Main_Zone></YAMAHA_AV>
<?xml version="1.0" encoding="utf-8"?><YAMAHA_AV cmd="PUT"><Main_Zone><Surround><Program_Sel><Current><Sound_Program>Standard</Sound_Program></Current></Program_Sel></Surround></Main_Zone></YAMAHA_AV>
<?xml version="1.0" encoding="utf-8"?><YAMAHA_AV cmd="PUT"><Main_Zone><Surround><Program_Sel><Current><Sound_Program>Spectacle</Sound_Program></Current></Program_Sel></Surround></Main_Zone></YAMAHA_AV>
<?xml version="1.0" encoding="utf-8"?><YAMAHA_AV cmd="PUT"><Main_Zone><Surround><Program_Sel><Current><Sound_Program>Sci-Fi</Sound_Program></Current></Program_Sel></Surround></Main_Zone></YAMAHA_AV>
<?xml version="1.0" encoding="utf-8"?><YAMAHA_AV cmd="PUT"><Main_Zone><Surround><Program_Sel><Current><Sound_Program>Adventure</Sound_Program></Current></Program_Sel></Surround></Main_Zone></YAMAHA_AV>
<?xml version="1.0" encoding="utf-8"?><YAMAHA_AV cmd="PUT"><Main_Zone><Surround><Program_Sel><Current><Sound_Program>Drama</Sound_Program></Current></Program_Sel></Surround></Main_Zone></YAMAHA_AV>
<?xml version="1.0" encoding="utf-8"?><YAMAHA_AV cmd="PUT"><Main_Zone><Surround><Program_Sel><Current><Sound_Program>Mono Movie</Sound_Program></Current></Program_Sel></Surround></Main_Zone></YAMAHA_AV>
<?xml version="1.0" encoding="utf-8"?><YAMAHA_AV cmd="PUT"><Main_Zone><Surround><Program_Sel><Current><Sound_Program>2ch Stereo</Sound_Program></Current></Program_Sel></Surround></Main_Zone></YAMAHA_AV>
<?xml version="1.0" encoding="utf-8"?><YAMAHA_AV cmd="PUT"><Main_Zone><Surround><Program_Sel><Current><Sound_Program>9ch Stereo</Sound_Program></Current></Program_Sel></Surround></Main_Zone></YAMAHA_AV>
<?xml version="1.0" encoding="utf-8"?><YAMAHA_AV cmd="PUT"><Main_Zone><Surround><Program_Sel><Current><Sound_Program>Surround Decoder</Sound_Program></Current></Program_Sel></Surround></Main_Zone></YAMAHA_AV>


<?xml version="1.0" encoding="utf-8"?><YAMAHA_AV cmd="GET"><Main_Zone><Config>GetParam</Config></Main_Zone></YAMAHA_AV>
<?xml version="1.0" encoding="utf-8"?><YAMAHA_AV cmd="GET"><Main_Zone><Basic_Status>GetParam</Basic_Status></Main_Zone></YAMAHA_AV>
<?xml version="1.0" encoding="utf-8"?><YAMAHA_AV cmd="GET"><Main_Zone><Power_Control><Power>GetParam</Power></Power_Control></Main_Zone></YAMAHA_AV>
<?xml version="1.0" encoding="utf-8"?><YAMAHA_AV cmd="GET"><Main_Zone><Power_Control><Sleep>GetParam</Sleep></Power_Control></Main_Zone></YAMAHA_AV>
<?xml version="1.0" encoding="utf-8"?><YAMAHA_AV cmd="GET"><Main_Zone><Volume><Lvl>GetParam</Lvl></Volume></Main_Zone></YAMAHA_AV>
<?xml version="1.0" encoding="utf-8"?><YAMAHA_AV cmd="GET"><Main_Zone><Volume><Mute>GetParam</Mute></Volume></Main_Zone></YAMAHA_AV>
<?xml version="1.0" encoding="utf-8"?><YAMAHA_AV cmd="GET"><Main_Zone><Volume><Max_Lvl>GetParam</Max_Lvl></Volume></Main_Zone></YAMAHA_AV>
<?xml version="1.0" encoding="utf-8"?><YAMAHA_AV cmd="GET"><Main_Zone><Volume><Init_Lvl>GetParam</Init_Lvl></Volume></Main_Zone></YAMAHA_AV>

<?xml version="1.0" encoding="utf-8"?><YAMAHA_AV cmd="PUT"><System><Speaker_Preout><Pattern_1><Lvl><Center><Val>-100</Val><Exp>1</Exp><Unit>dB</Unit></Center></Lvl></Pattern_1></Speaker_Preout></System></YAMAHA_AV>

<?xml version="1.0" encoding="utf-8"?><YAMAHA_AV cmd="PUT"><System><Speaker_Preout><Pattern_1><Lvl><Subwoofer_1><Val>-100</Val><Exp>1</Exp><Unit>dB</Unit></Subwoofer_1></Lvl></Pattern_1></Speaker_Preout></System></YAMAHA_AV>

<?xml version="1.0" encoding="utf-8"?><YAMAHA_AV cmd="PUT"><System><Speaker_Preout><Pattern_1><Config><Subwoofer><Extra_Bass>On</Extra_Bass></Subwoofer></Config></Pattern_1></Speaker_Preout></System></YAMAHA_AV>

<?xml version="1.0" encoding="utf-8"?><YAMAHA_AV cmd="PUT"><Main_Zone><Sound_Video><Tone><Bass><Val>-60</Val><Exp>1</Exp><Unit>dB</Unit></Bass></Tone></Sound_Video></Main_Zone></YAMAHA_AV>



*/