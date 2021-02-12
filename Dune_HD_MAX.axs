MODULE_NAME='Dune_HD_MAX' (dev vdvDevice, dev dvDevice, char m_caIPAddress[15])

#include 'Strings.axi'

DEFINE_DEVICE


DEFINE_CONSTANT

_debug			= 0 //отладка
tl_ping_id 		= $A1 //идентификатор пинга
tl_close_socket_id	= $B1

TL_Wait_Drill		= $C1
TL_Drill_Down		= $C2

tcp			= 1
udp			= 0
true			= 1
false			= 0
m_lPort			= 80

DEFINE_TYPE

structure Dune_s
{
    integer m_iBtn
}

DEFINE_VARIABLE

volatile Dune_s		Dune

volatile integer 	m_iClientOnline			= 0 //сокет онлайн
volatile integer 	m_iClientKeepOpen 		= 1 //поддержание соединения
volatile slong 		m_iClientConnectResult 		= 0 //результат подключения
volatile long 		m_laTimeToClose[1]		= 10000
volatile integer 	m_iOnWork			= 0 //режим работы
volatile integer	m_iCount			= 0

volatile long		m_laWait_Drill[1]		= {500}
volatile long		m_laDrill_Down[1]		= {250}

volatile char packet[255]


volatile integer	m_iDunePowerState	= 0
volatile long 		m_laPing[1]		= 20000 	// промежуток времени через который производится пинг

volatile char 		m_caDuneCmd[][8] 	= {
'00BF48B7',//dune_play,	1	
'00BF19E6',//dune_stop,		
'00BF1EE1',//dune_pause,		
'00BF1DE2',//dune_next, //		
'00BF49B6',//dune_prev,		
'00BF1BE4',//dune_fwd,		
'00BF1CE3',//dune_rew,		
'00BF51AE',//dune_top_menu,		      
'00BF07F8',//dune_pop_up_menu, //	
'00BF0AF5',//dune_0,	//10	
'00BF0BF4',//dune_1,	//	
'00BF0CF3',//dune_2,		
'00BF0DF2',//dune_3,		
'00BF0EF1',//dune_4,		
'00BF0FF0',//dune_5,	//	
'00BF01FE',//dune_6,		
'00BF11EE',//dune_7,		
'00BF12ED',//dune_8,		
'00BF13EC',//dune_9,
'00BF02FD',//dune_zoom,		
'00BF4EB1',//dune_setup,		
'00BF4BB4',//dune_p_up, 22		
'00BF4CB3',//dune_p_dn,		
'00BF52AD',//dune_v_up,		
'00BF53AC',//dune_v_dn,		
'00BF46B9',//dune_mute,	26	  
'00BF5FA0', //power on 27
'00BF5EA1', //power off 28
'00BF10EF',//dune_eject,		
'00BF45BA',//dune_mode,		
'00BF43BC',//dune_power, 		  
'00BF15EA',//dune_up,	32	
'00BF16E9',//dune_down,		
'00BF17E8',//dune_left, //		
'00BF18E7',//dune_right,		
'00BF14EB',//dune_enter,		
'00BF04FB',//dune_return, 37
'00BF06F9',//dune_search,	//	   
'00BF50AF',//dune_info 39
'00BF05FA',//dune_clear,		
'00BF44BB',//dune_audio, 41		
'00BF54AB',//dune_subtitle 42	
'00BF40BF',//dune_a,	//	
'00BF1FE0',//dune_b,		
'00BF00FF',//dune_c,		
'00BF41BE',//dune_d,		
'00BF42BD',//dune_select, //	
'00BF1AE5',//dune_slow,		
'00BF4DB2',//dune_angle_rotate,	
'00BF4FB0',//dune_repeat,		
'00BF47B8',//dune_shuffle_pip,	
'00BF03FC'}//dune_url_2nd_audio } //


define_function fnOnDisconnect()
{
    if(m_iClientOnline)
	ip_client_close(dvDevice.port)
}
define_function fnOnConnect()
{
    if(!m_iClientOnline)
	ip_client_open(dvDevice.port, m_caIPAddress, m_lPort, tcp)
}

define_function fnOnSend(char in_caData[])
{
    local_var sinteger ip_stat
    
    printf("'Dune_HD.Port[', itoa(dvDevice.port),'] :: ~TxData*', in_caData")
    
    if(m_iClientOnline)	{
	send_string dvDevice, "in_caData"
    } else {
	ip_client_open(dvDevice.port, m_caIPAddress, m_lPort, tcp)
	send_string dvDevice, "in_caData"
    }
}

define_function fnReset_TL()
{   
    //запуск таймлайна на закрытие сокета по таймауту
    if(timeline_active(tl_ping_id)) { //проверка активности таймлайна
	timeline_kill(tl_ping_id) //перезапуск таймлайна
	timeline_create(tl_ping_id, m_laPing, 1, timeline_absolute, timeline_repeat)
    } else {
	timeline_create(tl_ping_id, m_laPing, 1, timeline_absolute, timeline_repeat)
    }
}

define_function fnDuneControl(integer nCmd)
{    
    fnReset_TL()
    fnOnSend("'GET /cgi-bin/do?cmd=ir_code&ir_code=', mid_string(m_caDuneCmd[nCmd],7,2), mid_string(m_caDuneCmd[nCmd],5,2),'BF00',packet")
}

//функция пинга
define_function fnGetStatus()
{
    fnOnSend("'GET /cgi-bin/do?cmd=status',packet")
}

define_function printf(char in_caData[])
{
    if(_debug)
	send_string 0, "in_caData"
}

DEFINE_START

packet = "' HTTP/1.1',13,10,'HOST: ', m_caIPAddress,13,10,'Connection: Keep-Alive',13,10,13,10"

DEFINE_EVENT

//запрос статуса
timeline_event[TL_PING_ID]
{
    if(timeline.sequence == 1)
	fnGetStatus()
}

//обработка физического порта
data_event[dvDevice]
{
    online:
    {
	m_iClientOnline = true
	//fnReset_TL()
	printf("'Dune_HD_MAX.Port[', itoa(dvDevice.port),'] :: Online!!!'")
    }
    offline:
    {
	m_iClientOnline = false
	//fnReset_TL()
	if(m_iClientKeepOpen)
	    fnOnConnect()
	printf("'Dune_HD_MAX.Port[', itoa(dvDevice.port),'] :: Offline!!!'")
    }
    string:
    {
	local_var char m_caReadData[256], m_caTmpData[256], l_caState[100]
	
	m_caReadData = data.text
	
	printf("'Dune_HD_MAX.Port[', itoa(dvDevice.port),'] :: ~RxData: * ', m_caReadData")
	//
	//fnReset_TL()
	//обратная связь пo питанию
	select
	{
	    active(find_string(m_caReadData, '<param name="player_state" value="', 1)):
	    {
		m_caTmpData = remove_string(m_caReadData, '<param name="player_state" value="', 1)
		
		fnStr_GetStringWhile(m_caReadData, l_caState, '"')
		
		if(l_caState == 'standby')
		{
		    m_iDunePowerState = 0
		    off[vdvDevice, 254]
		} else
		{
		    m_iDunePowerState = 1
		    on[vdvDevice, 254]
		}
		
		//отладка
		printf("'Dune_HD_MAX.Port[', itoa(dvDevice.port),'] :: ~Power Status: ', l_caState")
	    }
	}
    }
    onerror:
    {
	printf("'dvDune_HD_MAX.Port[', itoa(dvDevice.port),'] :: OnError(',itoa(data.number),')'")
	    
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
//обработка виртуального порта
data_event[vdvDevice]
{
    command:
    {
	local_var char l_caReadData[100]
	
	l_caReadData = Data.Text
	
	select
	{
	    active(find_string(l_caReadData, 'START;', 1)):
	    {
		fnGetStatus()
		m_iOnWork = 1
		timeline_create(tl_ping_id, m_laPing, 1, timeline_absolute, timeline_repeat)
	    }
	    active(find_string(l_caReadData, 'STOP;', 1)):
	    {
		fnGetStatus()
		m_iOnWork = 0
		if(timeline_active(tl_ping_id))
		    timeline_kill(tl_ping_id)
	    }
	    active(find_string(l_caReadData, 'MAIN_SCREEN;', 1)):
	    {
		fnOnSend("'GET /cgi-bin/do?cmd=main_screen',packet")
	    }
	    active(find_string(l_caReadData, 'SET_POWER ON;', 1)):
	    {
		cancel_wait 'dune off 1'
		//cancel_wait 'dune off 2'
		
		fnDuneControl(27)
		//if(m_iDunePowerState == 0)
		    //fnDuneControl(31)
	    }
	    active(find_string(l_caReadData, 'SET_POWER OFF;', 1)):
	    {
		cancel_wait 'dune off 1'
		//cancel_wait 'dune off 2'
		fnDuneControl(28)
		
		wait 100  'dune off 1' {
		if(m_iDunePowerState == 1)
		    fnDuneControl(28)
		}
	    }
	}
    }
}

channel_event[vdvDevice, 0]
{
    on:
    {
	local_var
	    integer l_iCh
	    
	l_iCh = channel.channel
	
	Dune.m_iBtn = l_iCh
	
	cancel_wait 'drill'
	fnDuneControl(l_iCh)
	wait 5 'drill'
	do_push_timed(vdvDevice, channel.channel, 100)
    }
    off:
    {
	cancel_wait 'drill'
	do_release(vdvDevice, channel.channel)
    }
}

button_event[vdvDevice, 0]
{
    hold[2, repeat]:
    {
	local_var integer btn
	btn = button.input.channel
	if(btn >= 32 && btn <= 35) {
	    fnDuneControl(btn)
	}
    }
}

DEFINE_PROGRAM
