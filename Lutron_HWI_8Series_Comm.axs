MODULE_NAME='Lutron_HWI_8Series_Comm' (dev vdvDevice, dev dvDevice, char caHost[], char caLogin[], dev vdvaKeypads[])
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
#include 'htoi.axi'		// работа со стрингами
#include 'Strings.axi'		// работа со стрингами
#include 'StreamBuffer.axi'	// потоковый буфер

//#define _debug_flag

DEFINE_DEVICE

(***********************************************************)
(*               CONSTANT DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_CONSTANT

_debug = 0

_KBP = 1
_KBR = 0
_KBH = 2
_KBDT = 3

MAX_LINKS = 2

CR[] = {$0D,$0A}
iPort = 23
// идентификаторы потоков
TL_PING_ID		= $A0	// идентификатор потока пинга
TL_UPDATE_ID		= $A1
TL_WORK_ID		= $A2

MAX_RESP_LEN		= 382;			// Максимальная длинна ответа

MAX_QED_SHADES		= 29;
//// Types
#define vinteger volatile integer
#define vlong volatile long
#define vchar volatile char
#define Send_String_Module send_string vdvDevice
#define Send_Command_Module send_command vdvDevice
#define Send_String_Device send_string dvDevice
#define Send_Command_Device send_command dvDevice
                 

DEFINE_TYPE

//structures...


structure shades_s
{
    integer m_iLevel
    char m_caLevel
}

structure leds_s
{
    integer m_iState
}

structure keypad_s
{
    //leds_s m_sLeds[24]
    char m_caLeds[24]
}

structure link_s
{
    keypad_s m_sKeypad[32]
}

structure processor_s
{
    link_s	m_sLink[MAX_LINKS]
}


(***********************************************************)
(*               VARIABLE DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_VARIABLE

volatile processor_s	m_aProc[2]
volatile shades_s	QED[MAX_QED_SHADES]

vinteger		m_iOnWork = 0

volatile long 		m_laPing[1]	= 5000 	// промежуток времени через который производится пинг
volatile long 		m_laWork[1]	= 500	// промежуток времени через который производится обработка состояние соединения

vchar			m_cIsConnect	= 0	// флаг соединения

volatile long		m_lCurTime	= 0
volatile long		m_lLastPingTime	= 0
volatile long		m_lStartWaitTime= 0


// Очередь
vchar 		Lutron_Buffer[MAX_RESP_LEN];	// Response buffer: Lutron

i=0
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
    Подсоединение
    на входе	:	in_dvDevice - устройство
			in_cIPAddr  - IP адрес устройства к которому нужно присоеденится
			in_iPort    - порт к которому нужно присоеденится
    на выходе	:	*
*/
define_function fnOnConnect(dev in_dvDevice, char in_cIPAddr[], integer in_iPort)
{
    ip_client_open(in_dvDevice.port, in_cIPAddr, in_iPort, 1);
    Send_String_Module, "'Lutron fnOnConnect!!!'"
}

/**
    Отсоединение
    на входе	:	in_dvDevice - устройство
    на выходе	:	*
*/
define_function fnOnDisconnect(dev in_dvDevice)
{
    if(m_cIsConnect == 1) {
	ip_client_close(in_dvDevice.port)
	m_cIsConnect = 0;
    }
    Send_String_Module, "'Lutron fnOnDisconnect!!'"
}

/**
    Отправка команды наверх
*/
define_function fnSend(char in_pszCommand[])
{
    send_string vdvDevice, "in_pszCommand,$0D,$0A"
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
    m_iOnWork = 0
    // остановка таймеров
    if(timeline_active(TL_PING_ID))
	timeline_kill(TL_PING_ID);
    
    if(timeline_active(TL_UPDATE_ID))
	timeline_kill(TL_UPDATE_ID);
    
    m_lLastPingTime 	= m_lCurTime;
    m_lStartWaitTime	= m_lCurTime;
}


define_function fnGetQED_Status()
{
    local_var integer Qn
    for(Qn = 1; Qn <= MAX_QED_SHADES; Qn++)
    {
	fnSend("'RDL, [2:8:1:', itoa(Qn),']'")
    }
}
/**
    Обработка ответа
    на входе	:	in_sbBuffer - полученый пакет
    на выходе	:	true - команда обработана
			false - недостаточно данных
*/
define_function fnOnReceive(char in_pszData[])
{
    stack_var char l_caTmp[100]
    stack_var char l_caAddr[20]
    stack_var integer l_iaAddr[10]
    stack_var integer l_iAddrCount
    stack_var integer l_iBtn
    stack_var integer l_iLevel
    stack_var char l_caLeds[24]
    stack_var dev l_vdvKeypad
    
    //debug("'Lutron Data = ', in_pszData")
    
    //запрос логина
    if(find_string(in_pszData, 'login successful', 1) == 1) {
	m_iOnWork = 1
	
	wait 3 'get_time'
	fnOnPing();
	//fnGetQED_Status()
	sendStr(dvDevice, "'DLMON',$0D,$0A")
	sendStr(dvDevice, "'KBMON',$0D,$0A")
	sendStr(dvDevice, "'KLMON',$0D,$0A")
	sendStr(dvDevice, "'GSMOFF',$0D,$0A")
	sendStr(dvDevice, "'TEMOFF',$0D,$0A")
	
    // keypad button press event :: KBP, [02:05:10],  1$0D$0A
    } else if(find_string(in_pszData, 'KBP,', 1) == 1)
    {
	l_caTmp = remove_string(in_pszData, "'['", 1)
	fnStr_GetStringWhile(in_pszData, l_caAddr, ']')
	//m_aProc[l_iaAddr[1]].m_iLink[l_iaAddr[2]].m_sKeypad[l_iaAddr[3]].m_caAddr 		= l_caAddr
	//set_length_string(l_caAddr, 8)
	l_caTmp = remove_string(in_pszData, "'],'", 1)
	fnGetArray(l_caAddr, l_iaAddr, ':')
	l_iBtn = atoi(in_pszData)
	
	//debug("'Proc = ', itoa(l_iaAddr[1])")
	//debug("'Link = ', itoa(l_iaAddr[2])")
	//debug("'Keypad = ', itoa(l_iaAddr[3])")
	//debug("'Button = ', itoa(l_iBtn)")
	
	//m_aProc[l_iaAddr[1]].m_iLink[l_iaAddr[2]].m_sKeypad[l_iaAddr[3]].m_iBtn.m_iInput 	= l_iBtn
	//m_aProc[l_iaAddr[1]].m_iLink[l_iaAddr[2]].m_sKeypad[l_iaAddr[3]].m_iBtn.m_iPushState 	= _KBP
	
	l_vdvKeypad.NUMBER 	= 38000 + l_iaAddr[1]*100 + l_iaAddr[3]
	l_vdvKeypad.PORT 	= l_iaAddr[2]
	l_vdvKeypad.SYSTEM 	= 0
	
	do_push_timed(l_vdvKeypad, l_iBtn, do_push_timed_infinite)
	
    // keypad button release event :: KBR, [02:05:10],  1$0D$0A
    } else if(find_string(in_pszData, 'KBR,', 1) == 1)
    {
	l_caTmp = remove_string(in_pszData, "'['", 1)
	fnStr_GetStringWhile(in_pszData, l_caAddr, ']')
	l_caTmp = remove_string(in_pszData, "'],'", 1)
	fnGetArray(l_caAddr, l_iaAddr, ':')
	l_iBtn = atoi(in_pszData)
	
	//m_aProc[l_iaAddr[1]].m_iLink[l_iaAddr[2]].m_sKeypad[l_iaAddr[3]].m_iBtn.m_iInput 	= l_iBtn
	//m_aProc[l_iaAddr[1]].m_iLink[l_iaAddr[2]].m_sKeypad[l_iaAddr[3]].m_iBtn.m_iPushState 	= _KBR
	
	l_vdvKeypad.NUMBER 	= 38000 + l_iaAddr[1]*100 + l_iaAddr[3]
	l_vdvKeypad.PORT 	= l_iaAddr[2]
	l_vdvKeypad.SYSTEM 	= 0
	
	do_release(l_vdvKeypad, l_iBtn)
	
    // keypad button hold event :: KBH, [02:05:10],  1$0D$0A
    } else if(find_string(in_pszData, 'KBH,', 1) == 1)
    {
	l_caTmp = remove_string(in_pszData, "'['", 1)
	fnStr_GetStringWhile(in_pszData, l_caAddr, ']')
	l_caTmp = remove_string(in_pszData, "'],'", 1)
	fnGetArray(l_caAddr, l_iaAddr, ':')
	l_iBtn = atoi(in_pszData)
	
	//m_aProc[l_iaAddr[1]].m_iLink[l_iaAddr[2]].m_sKeypad[l_iaAddr[3]].m_iBtn.m_iInput 	= l_iBtn
	//m_aProc[l_iaAddr[1]].m_iLink[l_iaAddr[2]].m_sKeypad[l_iaAddr[3]].m_iBtn.m_iPushState 	= _KBH
	
    // keypad button double tap event :: KBDT, [02:05:10],  1$0D$0A
    } else if(find_string(in_pszData, 'KBDT,', 1) == 1)
    {
	l_caTmp = remove_string(in_pszData, "'['", 1)
	fnStr_GetStringWhile(in_pszData, l_caAddr, ']')
	l_caTmp = remove_string(in_pszData, "'],'", 1)
	fnGetArray(l_caAddr, l_iaAddr, ':')
	l_iBtn = atoi(in_pszData)
	
	//m_aProc[l_iaAddr[1]].m_iLink[l_iaAddr[2]].m_sKeypad[l_iaAddr[3]].m_iBtn.m_iInput 	= l_iBtn
	//m_aProc[l_iaAddr[1]].m_iLink[l_iaAddr[2]].m_sKeypad[l_iaAddr[3]].m_iBtn.m_iPushState 	= _KBDT
	
    // keypad leds
    } else if(find_string(in_pszData, 'KLS, ', 1) == 1)
    {
	stack_var integer i
	
	l_caTmp = remove_string(in_pszData, "'['", 1)
	fnStr_GetStringWhile(in_pszData, l_caAddr, ']')
	send_string 0, "'Panel Addr :: ', l_caAddr"
	l_caTmp = remove_string(in_pszData, "'], '", 1)
	fnGetArray(l_caAddr, l_iaAddr, ':')
	l_caLeds = in_pszData
	
	send_string 0, "'Panel Address Length = ', itoa(length_array(l_caAddr))"
	for(i = 1; i <= length_array(l_iaAddr); i++) {
	    send_string 0, "l_iaAddr[i]"
	}
	send_string 0, "'LEDS :: ', l_caLeds"
	/*
	    Line      1 (15:10:15)::  Panel Addr :: 02:05:21
	    Line      2 (15:10:15)::  Panel Address Length = 2
	    Line      3 (15:10:15)::  LEDS :: 110000000000000000000000
	    Line      4 (15:10:15)::  Panel Addr :: 02:05:19
	    Line      5 (15:10:15)::  Panel Address Length = 2
	    Line      6 (15:10:15)::  LEDS :: 100000000000000000000000
	    Line      7 (15:10:15)::  Panel Addr :: 02:05:21
	    Line      8 (15:10:15)::  Panel Address Length = 2
	    Line      9 (15:10:15)::  LEDS :: 010000000000000000000000
	*/
	//for(i = 1; i <= 24; i++) {
	    //m_aProc[l_iaAddr[1]].m_sLink[l_iaAddr[2]].m_sKeypad[l_iaAddr[3]].m_sLeds[i].m_iState = atoi(l_caLeds[i])
	//}
	
    // 
    } else if(find_string(in_pszData, 'DL, ', 1) == 1)
    {
	local_var integer adr
	
	l_caTmp = remove_string(in_pszData, "'['", 1)
	fnStr_GetStringWhile(in_pszData, l_caAddr, ']')
	
	debug("'Lutron Address = ',  l_caAddr")
	
	l_caTmp = remove_string(in_pszData, "'], '", 1)
	//l_caAddr = "'[', l_caAddr,']'"
	l_iAddrCount = fnGetArray(l_caAddr, l_iaAddr, ':')
	
	l_iLevel = atoi(in_pszData)
	
	debug("'Lutron Address COUNT = ',  itoa(l_iAddrCount)")
	
	for(adr = 1; adr <= l_iAddrCount; adr++)
	    debug("'Addr ',itoa(adr),' = ', itoa(l_iaAddr[adr])")
	
	debug("'Dimmer Level [', itoa(l_iaAddr[1]),':',itoa(l_iaAddr[2]),':',itoa(l_iaAddr[3]),':',itoa(l_iaAddr[4]),'] = ', itoa(l_iLevel)")
	
	if(l_iaAddr[2] == 8) {
	    Qed[l_iaAddr[4]].m_iLevel = l_iLevel
	}
    // Processor Time
    } else if(find_string(in_pszData, 'Processor Time: ', 1) == 1)
    {
	// set processor time if another than AMX\
    //
    }
}



/**
    Обработка команды приходящих на виртуальный порт
    на входе	: in_caCommand	- указатель на команду
    на выходе	: *
*/
define_function fnOnCommand(char in_caCommand[])
{
    local_var
	char l_caTemp[100]
	integer l_iaKeypad[20]
	char l_caAddr[20]
	
    debug("'LUTRON COMMAND :: ', in_caCommand")
    // проверка наличия команды соединения
    if(find_string(in_caCommand, 'CONNECT;', 1) == 1)
    {
	//  запуск потока для поддержания соединения
	timeline_create(TL_WORK_ID, m_laWork, 1, TIMELINE_ABSOLUTE, TIMELINE_REPEAT)
	send_string vdvDevice, "'CONNECT;'"
	
    } else if(find_string(in_caCommand, 'DISCONNECT;', 1) == 1)
    {
	// остановка потока для поддержания соединения
	timeline_kill(TL_WORK_ID);
	fnOnDisconnect(dvDevice)
	send_string vdvDevice, "'DISCONNECT;'"
    
    } else if(find_string(in_caCommand, 'PASSTHRU-', 1) == 1)
    {
	l_caTemp = remove_string(in_caCommand, "'PASSTHRU-'", 1)
	sendStr(dvDevice, in_caCommand)
    
    //SETLED, [2:5:1], 1, 1
    } else if(find_string(in_caCommand, 'SETLED,', 1) == 1)
    {
	l_caTemp = remove_string(in_caCommand, 'SETLED, ', 1)
	l_caAddr = remove_string(in_caCommand, '],', 1)
	//set_length_string(l_caAddr, 10)
	fnGetArray(in_caCommand,l_iaKeypad, ',')
	
	sendStr(dvDevice, "'SETLED, ', l_caAddr, l_iaKeypad[1],', ',l_iaKeypad[2],$0D,$0A")
	sendStr(0, "'SETLED, ', l_caAddr, l_iaKeypad[1],', ',l_iaKeypad[2],13,10")

    // SETLEDS, [addr], xx0xx1xx2
    } else if(find_string(in_caCommand, 'SETLEDS,', 1) == 1)
    {
	l_caTemp = remove_string(in_caCommand, 'SETLEDS, ', 1)
	l_caAddr = remove_string(in_caCommand, '], ', 1)
	//set_length_string(l_caAddr, 10)
	//fnGetArray(in_caCommand,l_iaKeypad, ',')
	
	sendStr(dvDevice, "'SETLEDS, ', l_caAddr, in_caCommand,CR")
	debug("'SETLEDS, ', l_caAddr, in_caCommand,CR")
	
    } else
    {
	// Отладочная информация
	debug("'LUTRON BAD COMMAND - ',in_caCommand")
	
    }
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
	if(l_lTime > 2000)
	{
	    send_command vdvDevice, "'Lutron fnOnConnect(', caHost, ',', itoa(iPort), ') - [',fnReturnDPS(dvDevice),']'"
	    fnOnConnect(dvDevice, caHost, iPort)
	    
	    m_cIsConnect = 2
	    m_lStartWaitTime = m_lCurTime
	}
    } else if(m_cIsConnect == 1)
    {
	l_lTime = m_lCurTime - m_lLastPingTime
	if(l_lTime > 20000)
	{
	    fnOnDisconnect(dvDevice)
	    send_string vdvDevice, "'Lutron TIMEOUT - [',fnReturnDPS(dvDevice),']'"
	}
    } else if(m_cIsConnect == 2)
    {
	// обработка 
	l_lTime = m_lCurTime - m_lStartWaitTime
	if(l_lTime > 3000)
	{
	    send_command vdvDevice, "'Lutron TIMEOUT WAIT CONNECT - [',fnReturnDPS(dvDevice),']'"
	    m_cIsConnect = 0
	    m_lStartWaitTime = m_lCurTime
	}
    }
}

/**
    Пинг
    на входе	:	*
    на выходе	:	*
    примечание	: 	данная функция пердназначена для поддержания соединения
*/
define_function fnOnPing()
{
    if(m_iOnWork)
	sendStr(dvDevice, "'RST', CR")
}
/*
    Вывод отладочной информации
*/
define_function debug(char in_caData[])
{
   if(_debug)
	send_string 0, in_caData
}

define_function sendStr(dev in_dDevice, char in_caData[])
{
    if(m_cIsConnect) {
	send_string in_dDevice, in_caData
	debug("'Lutron Data - ', in_caData")
    }
}

define_function sendCmd(dev in_dDevice, char in_caData[])
{
    send_command in_dDevice, in_caData
}

define_function char[8] fnGetKeypadAddress(dev in_dvKeypad)
{
    local_var
	integer l_iProc
	integer l_iLink
	integer l_iKeypad
	char l_caAddr[8]
	
    l_iProc	= atoi(mid_string(itoa(in_dvKeypad.number), 3, 1))
    l_iLink 	= in_dvKeypad.port
    l_iKeypad 	= atoi(mid_string(itoa(in_dvKeypad.number), 4, 2))
    
    l_caAddr = "fnStr_IntegerToString(2, l_iProc), ':',
		fnStr_IntegerToString(2, l_iLink), ':',
		fnStr_IntegerToString(2, l_iKeypad)"
    
    set_length_string(l_caAddr, 8)
    
    return l_caAddr
}


define_function char[20] fnReturnDPS(dev in_dDevice)
{
    local_var char dps[20]
    
    dps = "itoa(in_dDevice.number),':',itoa(in_dDevice.port),':', itoa(in_dDevice.system)"
    
    return dps
}

(***********************************************************)
(*                STARTUP CODE GOES BELOW                  *)
(***********************************************************)
DEFINE_START


create_buffer dvDevice, Lutron_Buffer
(***********************************************************)
(*                THE EVENTS GO BELOW                      *)
(***********************************************************)
DEFINE_EVENT

/**
    Обработчик таймера пинга
*/
TIMELINE_EVENT[TL_PING_ID]
{
    if(timeline.sequence == 1)
	fnOnPing()
}

/**
    Обработчик поддержания соединения
*/
TIMELINE_EVENT[TL_WORK_ID]
{
    if(timeline.sequence == 1)
    {
	m_lCurTime = m_lCurTime + m_laWork[1]
	fnOnWork()
    }
}

/**
    Обработчик физического порта
*/
DATA_EVENT[dvDevice]
{
    // включение устройства
    ONLINE:
    {
	// Отладочная информация
	debug("'online'")
	
	// инициализация соединения
	fnOnInit()
	
	// соединение установлено
	m_cIsConnect = 1
	
	cancel_wait 'online'
	wait 20 'online' on[vdvDevice, 255]
	
	// отправим подтверждение отправки данных
	send_string vdvDevice, "'CONNECT TO LUTRON - [',fnReturnDPS(dvDevice),']'"
    }
    
    // отключение устройства
    OFFLINE:
    {
	// Отладочная информация
	debug("'offline'")
	
	// инициализация соединения
	fnOnDeInit()
	
	// соединение прервано
	m_cIsConnect = 0
	
	cancel_wait 'online'
	off[vdvDevice, 255]
	
	// отправим подтверждение отправки данных
	send_string vdvDevice, "'DISCONNECT FROM LUTRON - [',fnReturnDPS(dvDevice),']'"
    }
    
    // Получение стринга
    STRING:
    {
	local_var sPacket[MAX_RESP_LEN];
	
	// запомним время последнего пинга или прихода данных
	m_lLastPingTime = m_lCurTime
	
	cancel_wait 'Lutron_InputTimer';
    
	if(find_string(Lutron_Buffer, 'LOGIN:', 1) == 1) {
	    sendStr(dvDevice, "caLogin, CR")
	    clear_buffer Lutron_Buffer
	} else {
	    sPacket = remove_string(Lutron_Buffer, CR, 1);
	    while(length_array(sPacket))
	    {
		fnOnReceive(sPacket);
		debug("'Lutron sPacket :: ', sPacket")
		sPacket = remove_string(Lutron_Buffer, CR, 1);
	    }
	}
	
	// Handle any "leftovers" in the buffer
	if(length_array(Lutron_Buffer))
	{
	    Wait 10 'Lutron_InputTimer'
	    {
		clear_buffer Lutron_Buffer;
	    }
	}
    }
    
    // обработка ошибки
    ONERROR:
    {
	// Отладочная информация
	debug("'Lutron physical port error'")
	debug(DATA.TEXT)
	
	send_string vdvDevice, DATA.TEXT
    }
}

/**
    Обработчик виртуального порта
*/
DATA_EVENT[vdvDevice]
{
    COMMAND:
    {
	local_var char caCommand[256]
	
	// перевод в верхний регистр
	//fnStr_ToUpper(data.text)
	caCommand = data.text
	fnOnCommand(caCommand)
	/*
	// выполнять пока есть команды
	while(fnStr_GetStringWhile(data.text, caCommand, $3B))
	{
	    // обработка команды
	    fnOnCommand(caCommand)
    
	    // удаление обработаной команды
	    remove_string(data.text, "$3B", 1)
	}
	*/
    }
}

channel_event[vdvaKeypads, 0]
{
    on: {
	local_var integer l_iBtn
	l_iBtn = channel.channel
	
	sendStr(dvDevice, "'KBP, [', fnGetKeypadAddress(vdvaKeypads[get_last(vdvaKeypads)]),'], ', itoa(l_iBtn),$0D,$0A")
    }
    
    off: {
	local_var integer l_iBtn
	l_iBtn = channel.channel
	
	sendStr(dvDevice, "'KBR, [', fnGetKeypadAddress(vdvaKeypads[get_last(vdvaKeypads)]),'], ', itoa(l_iBtn),$0D,$0A")
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
