MODULE_NAME='Squeezebox_Comm' (	dev vdvDevice, 
				dev dvPhysicalDevice,
				dev dvPanels[],
				dev dvSearchPanels[],
				char caPlayerID[],
				char caHost[], 
				integer iPort, 
				integer iArtworkPort)
				//integer iSearchEncoding)


#include 'Strings.axi'		// работа со стрингами
#include 'URICodec.axi'		// Кодирование/декодирование URI

(***********************************************************)
(* REV HISTORY:                                            *)
(***********************************************************)
(*
    $History: $
    
    v2.0.0, 19.02.2013 	- 	начало переработки модуля под списки iRidiumMobile 2.0
				Теперь один модуль управляет одним устройством
				
				
*)
(***********************************************************)
(*          DEVICE NUMBER DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_DEVICE

dvDebug = 0:0:0
(***********************************************************)
(*               CONSTANT DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_CONSTANT

_debug 			= 1

_push 			= 1
_release 		= 0
_hold			= 2

MAX_PANELS 		= 16

m_iScrollPlaylistIndex 	= 1000														// Index for start Number of the Scroll List Lines
m_iScrollLibraryIndex 	= 2000														// Index for start Number of the Scroll List Lines

SEARCH_BY_ARTIST	= 1
SEARCH_BY_ALBUM		= 2
SEARCH_BY_TRACK		= 3
SEARCH_BY_GENRE		= 4
SEARCH_BY_RADIO		= 5

PLAYER_NAME		= 1
LIBRARY_TOTAL_COUNT	= 2
PLAYLIST_TOTAL_COUNT	= 3
DURATION		= 12
ARTIST			= 13
ALBUM			= 14
TRACK			= 15
CURRENT_TIME_OF_SONG	= 16
REPEAT_SATUS		= 17
SHUFFLE_STATUS		= 18
COVER_ART		= 25

// идентификаторы потоков
TL_PING_ID		= $A0	// идентификатор потока пинга
TL_UPDATE_ID		= $A1
TL_WORK_ID		= $A2
TL_WaitResponce      	= $A3
LONG lWaitResponce[] 	= {15000}

MAX_RESP_LEN		= 90000;		// Максимальная длинна ответа
LT[]			= { $0A };		// Конец строки
integer Queue_MaxCommand  = 16
integer Command_MaxLength = 128

MAX_ITEMS		= 2000;			// Максимальное количество элментов списка
MAX_PL_ITEMS		= 200;			// Максимальное количество элментов списка
MAX_STACK		= 12;			// Максимальная вложеность стека
MAX_REQUEST_LEN		= 128;			// Максимальная длинна запроса

RECEIVE_STATE_START		= 0;
RECEIVE_STATE_PLAYER_ID		= 1;
RECEIVE_STATE_STATUS		= 2;
RECEIVE_STATE_END		= 3;

ARTISTS_ROOT_INDEX		= 1;	// Artists
ALBUM_ROOT_INDEX		= 2;	// Albums
GENRES_ROOT_INDEX		= 3;	// Genres
RANDOM_MIX_ROOT_INDEX		= 4;	// призвольный микс (Songs, Artists, Albums)
FOLDER_MUSIC_ROOT_INDEX		= 5;	// Folder "Music" - навигация по папке музыка
//PLAYLISTS_ROOT_INDEX		= 6;	// Playlists - сохраненные плейлисты
FAVORITES_ROOT_INDEX		= 6;	// Favorites - сохраненные фавориты
INTERNET_RADIO_ROOT_INDEX	= 7;	// Internet Radio

ITEM_TYPE_NONE			= 0;	// Нет
ITEM_TYPE_TRACK			= 1;	// Трек
ITEM_TYPE_ALBUM			= 2;	// Альбом
ITEM_TYPE_ARTIST		= 3;	// Артист
ITEM_TYPE_GENRE			= 4;	// Жанр
ITEM_TYPE_PLAYLIST		= 5;	// Плейлист
ITEM_TYPE_RADIO			= 6;	// Радио
ITEM_TYPE_FOLDER		= 7;	// Директория
ITEM_TYPE_MIX			= 8;	// Микс
ITEM_TYPE_RANDOM		= 9;	// Рандомный выбор
ITEM_TYPE_FAVORITES		= 10;	// Фавориты
ITEM_TYPE_SEARCH_TRACK		= 11;	// Найденый трек
ITEM_TYPE_RADIO_FOLDER		= 12;	// Директория

PLAYER_STATUS_STOP		= 0;	// Плеер остановлен
PLAYER_STATUS_PLAY		= 1;	// Плеер воспроизводит
PLAYER_STATUS_PAUSE		= 2;	// Плеер в паузе

SubItem_0			= 0
SubItem_1			= 1
SubItem_2			= 2
SubItem_3			= 3
SubItem_4			= 4
SubItem_5			= 5
SubItem_6			= 6
SubItem_7			= 7
SubItem_8			= 8
SubItem_9			= 9
SubItem_10			= 10
SubItem_11			= 11
SubItem_12			= 12
SubItem_13			= 13
SubItem_14			= 14
SubItem_15			= 15

(***********************************************************)
(*              DATA TYPE DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_TYPE

// Структура запроса
structure request_s
{
    char m_szRequest[MAX_REQUEST_LEN];		// Запрос
    char m_szParam[32];				// Параметр запроса
}

structure PL_s
{
    char m_caTitle[50]
    char m_caArtist[50]
    char m_caGenre[20]
    char m_caAlbum[30]
    char m_caTime[20]
    char m_caDuration[20]
}
// Структура для описания элемента
structure item_s
{
    char	m_szName[100];		// Имя для списка
    char	m_cSelectable;			// Выбираемый
    char	m_cAddable;			// Добавляемый
    char	m_cType;			// Тип элементв
    char	m_szID[32];			// Идентификатор
    //char	m_cCoverArt[256]		// адрес ковера элемента
    request_s	m_sReq;				// Запрос
}

// Структура для возврата
structure stack_s
{
    integer   m_iStart;				// Номер первого элемента
    request_s m_sReq;				// Запрос
}

// Структрура плеера
structure player_s
{
    // Параметры
    //char	m_caPlayerName[32]
    integer	m_iPower
    char	m_caPlayerIP[15]
    integer	m_IsConnected
    integer	m_iPlayerIndex
    char      	m_caID[32];			// Идентификатор плеера
    char      	m_cUse;				// Количество ссылок на плеер
    integer	m_iState;			// Состояние плеера
    long      	m_lTime;			// Время текущего трека в секундах
    long      	m_lDuration;			// Длинна текущего трека
    integer   	m_iCurrent;			// Номер текущего трека в плей листе
    request_s 	m_sReq;				// Запрос
    // Плейлист
    //integer   	m_iPLStartView;			// Номер текущего видимого элемента
    integer   	m_iPLItems;			// Количество элементов в списке
    integer   	m_iPLOldItems;			// Количество элементов в списке
    PL_s     	m_aPL[MAX_PL_ITEMS];		// Имя для списка
    // Список
    integer   	m_iItems;				// Количество элементов в списке
    item_s    	m_aItems[MAX_ITEMS];		// Список элементов
    // Стек
    integer   	m_iStackIndex;			// Текущий индекс стека
    stack_s   	m_aStack[MAX_STACK];		// Стек для выполнение возврата
    //serverstatus
    //char	m_caLastScan[20]
    integer	m_iTotalArtists
    integer	m_iTotalAlbums
    integer	m_iTotalGenres
    integer	m_iTotalSongs
    //char	m_caServer[100]
    //char	m_caServerUrl[256]
    integer	m_iRepeat
    integer	m_iShuffle
}

structure level_s
{
    integer 	m_iLevel
    integer 	m_iValue
    integer 	m_iOnMove
}

structure button_s
{
    integer 	m_iInput
    integer 	m_iPushState
    integer 	m_iLongPush
    integer 	m_iHoldCount // измеряется в 0.1 сек
    long 	m_lHoldTime
}

structure panel_s
{
    integer 	m_iOnline
    button_s 	m_aBtn
    level_s	m_aLevel
}


(***********************************************************)
(*               VARIABLE DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_VARIABLE

#define CHECK_Player		if(m_aPlayer.m_IsConnected)
#define CHECK_Panel		if(m_aPanels[tp].m_iOnline)
#define THIS_Panel		dvPanels[tp]
#define THIS_PanelIsOnline 	m_aPanels[tp].m_iOnline
#define THIS_Btn		m_aPanels[tp].m_aBtn.m_iInput
#define THIS_Level		m_aPanels[tp].m_aLevel.m_iLevel
#define THIS_LevelValue		m_aPanels[tp].m_aLevel.m_iValue
#define THIS_LevelOnMove	m_aPanels[tp].m_aLevel.m_iOnMove
#define THIS_Push		m_aPanels[tp].m_aBtn.m_iPushState
#define THIS_LongPush		m_aPanels[tp].m_aBtn.m_iLongPush
#define THIS_HoldTime		m_aPanels[tp].m_aBtn.m_lHoldTime
#define THIS_HoldCount		m_aPanels[tp].m_aBtn.m_iHoldCount

#define Send_To_Panel		send_command dvPanels[tp]

volatile panel_s		m_aPanels[MAX_PANELS]

volatile integer 		iSearchEncoding		= 1 // 1 - Unicode, 0 - Win CP1251
volatile integer 		TP_PlayList		= 400												// List of Menu Lines
volatile integer 		TP_LibraryList	 	= 500												// List of Menu Lines
volatile integer		m_iLoadingLists		= 0

volatile integer TP_Btns[] =     												// Touchpanel iPod button mapping array
{
  1, 		//01 play
  2, 		//02 stop
  3, 		//03 pause
  4, 		//04 skip >>
  5, 		//05 skip <<
  6, 		//06 
  97, 		//07 volume up
  98, 		//08 volume down
  99, 		//09 mote on/off
  110, 		//10 Clear PlayList
  111, 		//11 Back Menu
  112, 		//12 Root Menu
  113,		//13 Show Music Library PopUp
  114, 		//14 Show Search PopUp
  115, 		//15 
  116, 		//16 
  117, 		//17 
  118, 		//18 
  119, 		//19 
  120, 		//20 
  121, 		//21 
  122, 		//22 
  123, 		//23 Repeat
  124, 		//24 Shuffle
  125, 		//25 
  126, 		//26 
  127, 		//27 
  128, 		//28 
  129, 		//29 
  130, 		//30 
  131, 		//31 
  132, 		//32 
  133, 		//33 
  140, 		//34
  141, 		//35 
  142, 		//36 On Page - used to track which panel is currently on the SB page to send vText
  143  		//37 Off Page - in order to reduce traffic when SB sends out strings - only sends it to panels on the page
}

// Кнопки выбора типа поиска
volatile integer m_iaSearchBtns[] = 
{
    51,52,53,54,55
}

volatile integer TXT_Fields[]=  												// Variable text buttons
{
  100, 		//01 Player Name
  101, 		//02 Library Total Count
  102, 		//03 Playlist Total Count
  103, 		//04 List 03
  104, 		//05 List 04
  105, 		//06 List 05
  106, 		//07 List 06
  107, 		//08 List 07
  108, 		//09 List 08
  109, 		//10 List 09
  110, 		//11 List 10
  111, 		//12 Playing x of y
  112, 		//13 Artist
  113, 		//14 Album
  114, 		//15 Track
  115, 		//16 Current Time of the Song
  116, 		//17 Repeat
  117, 		//18 Shuffle
  118, 		//19 Play Status
  119, 		//20 List x of y
  120, 		//21 Pathway
  121, 		//22 Total Time of the Song 
  122, 		//23 Current/Total Time
  123, 		//24 Name of TP or KP
  124		//25 Cover Art
}

volatile char		m_caRootMenu[4][20] 		= {'Artists','Albums','Genres','Random MIX'}
volatile char		m_caRootMenuRequests[4][20] 	= {'artists','albums','genres',''}
//volatile char		m_caRootMenu[6][20] 		= {'Artists','Albums','Genres','Random MIX','Favorites','Radio'}
//volatile char		m_caRootMenuRequests[6][20] 	= {'artists','albums','genres','','favorites items','radios'}
//volatile integer	m_iaRootMenuTypes[7]		= {}

volatile char m_caRepeat[3][10] = {'Off','Song','Playlist'}
volatile char m_caShuffle[3][6] = {'Off','Songs','Albums'}

char g_szHex[] = '0123456789ABCDEF';

// Связи между панелями и плеером
// массив содержит номер плеера который закреплен к панели
integer g_iaPlayerInUse[MAX_PANELS];		// С каких панелей управляется плеер 
integer g_iaOldPlayerInUse[MAX_PANELS];		// С каких панелей управляется плеер 

volatile integer TP_Levels[]=
{
    1, 		//List Bargraph
    2  		//Time progress bargraph
}


volatile integer 	m_iCurTID	= 0	// текущий идентификатр транзакции
volatile long 		m_laPing[1]	= 1000 	// промежуток времени через который производится пинг
volatile long 		m_laUpdate[1]	= 100	// промежуток времени через который производится запрос input
volatile long 		m_laWork[1]	= 500	// промежуток времени через который производится обработка состояние соединения

volatile integer	m_iIsConnect	= 0	// флаг соединения

volatile long		m_lCurTime	= 0
volatile long		m_lLastPingTime	= 0
volatile long		m_lStartWaitTime= 0

volatile integer	m_iHandle	= 0
volatile integer	m_iaIP[4]		// IP адрес

// Очередь
volatile char 		SlimServer_Buffer[MAX_RESP_LEN];	// Response buffer: SlimServer
volatile char 		sQueue[Queue_MaxCommand][MAX_REQUEST_LEN]									// Arrey for sending messages
volatile integer 	nQueue_InPointer												// Where we should to put message
volatile integer 	nQueue_OutPointer												// Where we should read message to be sent
volatile integer 	nQueue_Counter													// Flag for not empty Queue
volatile integer 	nDeviceBusy													// Flag for waiting replay
volatile char 		sLastCommand[MAX_REQUEST_LEN]
volatile char 		sCurrentCommand[MAX_REQUEST_LEN]

volatile integer	m_iPlayersOf;	// Количество плееров
volatile player_s	m_aPlayer;	//  плеер

volatile integer 	m_iSearchType;
volatile char 		m_cBusy = 0;
volatile char 		m_cOldBusy = 0;

(***********************************************************)
(*               LATCHING DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_LATCHING


DEFINE_START

create_buffer dvPhysicalDevice, SlimServer_Buffer;
clear_buffer SlimServer_Buffer
(***********************************************************)
(*       MUTUALLY EXCLUSIVE DEFINITIONS GO BELOW           *)
(***********************************************************)
DEFINE_MUTUALLY_EXCLUSIVE

//
define_function fnSelectPlayer(integer tp, integer in_iSelect)
{
    // Включение/ыключение прослушивания
    if(in_iSelect)
	fnCommandUse()
    else
	fnCommandUnuse()
	
    // Включение плеера
    g_iaPlayerInUse[tp] = in_iSelect;
}

/**
    Обновление параметров выбора типа поиска
    на входе	: *
    на выходе	: *
*/
define_function fnUpdateSearchParam(integer tp)
{
    stack_var integer i;
    
    if(m_iSearchType == 0)
	m_iSearchType = 1
    
    for(i = 1; i <= length_array(m_iaSearchBtns); i++) {
	[THIS_Panel, m_iaSearchBtns[i]] = (m_iSearchType == i)
    }
}


/**
    Конвертирование из UTF8 в UNI представление
*/
define_function char[256] ConvertUTF8ToUNI(char in_pszUTF8[])
{
    char	l_pszUNI[256];
    stack_var long l_iLen;
    stack_var long l_iIn;
    stack_var long l_iOut;
    stack_var long l_iCh;
    
    l_iIn	= 1;
    l_iOut	= 1;
    l_iCh	= 0;
    l_iLen	= length_string(in_pszUTF8);

    // $E2 $92 $84
    if(l_iLen > 0)
    {
	while(l_iIn <= l_iLen)
	{
	    if((in_pszUTF8[l_iIn] & $80) == 0)
	    {
		// 0x00000000 — 0x0000007F: 0xxxxxxx
		l_iCh = in_pszUTF8[l_iIn]
		l_iIn++
	    
	    } else
	    {
		if((in_pszUTF8[l_iIn] & $E0) == $C0)
		{
		    // 0x00000080 — 0x000007FF: 110xxxxx 10xxxxxx
		    l_iCh = ((in_pszUTF8[l_iIn] & $1F) << 6) | (in_pszUTF8[l_iIn + 1] & $3F)
		    l_iIn = l_iIn + 2
		} else
		{
		    if((in_pszUTF8[l_iIn] & $F0) == $E0)
		    {
			// 0x00000800 — 0x0000FFFF: 1110xxxx 10xxxxxx 10xxxxxx
			l_iCh = (((in_pszUTF8[l_iIn] & $0F) << 12) | ((in_pszUTF8[l_iIn + 1] & $3F) << 6) | (in_pszUTF8[l_iIn + 2] & $3F));
			l_iIn = l_iIn + 3

		    } else
		    {
			if((in_pszUTF8[l_iIn] & $F8) == $F0)
			{
			    // 0x00010000 — 0x001FFFFF: 11110xxx 10xxxxxx 10xxxxxx 10xxxxxx
			    l_iCh = (((in_pszUTF8[l_iIn] & $0F) << 18) | ((in_pszUTF8[l_iIn + 1] & $3F) << 12) | ((in_pszUTF8[l_iIn + 2] & $3F) << 6) | (in_pszUTF8[l_iIn + 3] & $3F));
			    l_iIn = l_iIn + 4
			} else
			{
			    l_iIn++;
			}
		    }
		}
	    }
		
	    // проверка на выход за пределы строки
	    if((256 - l_iOut) >= 4)
	    {
		// конвертирование символа в UNI символ
		l_pszUNI[l_iOut + 0] = g_szHex[((l_iCh >> 12) & $F) + 1];
		l_pszUNI[l_iOut + 1] = g_szHex[((l_iCh >> 8) & $F) + 1];
		l_pszUNI[l_iOut + 2] = g_szHex[((l_iCh >> 4) & $F) + 1];
		l_pszUNI[l_iOut + 3] = g_szHex[(l_iCh & $F) + 1];
		
		l_iOut = l_iOut + 4;
	    }
	}
	
	// установка длинны строки
	set_length_string(l_pszUNI, l_iOut - 1);
    }
    return l_pszUNI;
}

/**
    Конвертирование из UTF8 в CP1251 представление
*/
define_function char[256] ConvertUTF8ToCP1251(char in_pszUTF8[])
{
    char	l_pszUNI[256];
    stack_var long l_iLen;
    stack_var long l_iIn;
    stack_var long l_iOut;
    stack_var long l_iCh;
    
    l_iIn	= 1;
    l_iOut	= 1;
    l_iCh	= 0;
    l_iLen	= length_string(in_pszUTF8);

    // $E2 $92 $84
    if(l_iLen > 0)
    {
	while(l_iIn <= l_iLen)
	{
	    if((in_pszUTF8[l_iIn] & $80) == 0)
	    {
		// 0x00000000 — 0x0000007F: 0xxxxxxx
		l_iCh = in_pszUTF8[l_iIn]
		l_iIn++
	    
	    } else
	    {
		if((in_pszUTF8[l_iIn] & $E0) == $C0)
		{
		    // 0x00000080 — 0x000007FF: 110xxxxx 10xxxxxx
		    l_iCh = ((in_pszUTF8[l_iIn] & $1F) << 6) | (in_pszUTF8[l_iIn + 1] & $3F)
		    l_iIn = l_iIn + 2
		} else
		{
		    if((in_pszUTF8[l_iIn] & $F0) == $E0)
		    {
			// 0x00000800 — 0x0000FFFF: 1110xxxx 10xxxxxx 10xxxxxx
			l_iCh = (((in_pszUTF8[l_iIn] & $0F) << 12) | ((in_pszUTF8[l_iIn + 1] & $3F) << 6) | (in_pszUTF8[l_iIn + 2] & $3F));
			l_iIn = l_iIn + 3

		    } else
		    {
			if((in_pszUTF8[l_iIn] & $F8) == $F0)
			{
			    // 0x00010000 — 0x001FFFFF: 11110xxx 10xxxxxx 10xxxxxx 10xxxxxx
			    l_iCh = (((in_pszUTF8[l_iIn] & $0F) << 18) | ((in_pszUTF8[l_iIn + 1] & $3F) << 12) | ((in_pszUTF8[l_iIn + 2] & $3F) << 6) | (in_pszUTF8[l_iIn + 3] & $3F));
			    l_iIn = l_iIn + 4
			} else
			{
			    l_iIn++;
			}
		    }
		}
	    }
		
	    if(l_iCh >= $410 && l_iCh <= $4ff)
		l_iCh = l_iCh - $350;
	    
	    // проверка на выход за пределы строки
	    if((256 - l_iOut) >= 1)
	    {
		// конвертирование символа
		l_pszUNI[l_iOut] = l_iCh;
		l_iOut = l_iOut + 1;
	    }
	}
	
	// установка длинны строки
	set_length_string(l_pszUNI, l_iOut - 1);
    }
    return l_pszUNI;
}

/**
    Получение набора параметров из строки
    на входе	:	in_caString	- указатель на строку откуда извлеч значения
			in_iaBuffer	- указатель на буфер куда нужно сложить значения
			in_caDel	- разделитель
    на выходе	:	количество параметров
*/
/*
define_function integer fnGetArray(char in_caString[], integer in_iaBuffer[], char in_caDel[])
{
    stack_var integer l_iCount, i
    stack_var char l_bRun
    
    l_iCount = 0
    l_bRun = 1
    
    while(l_bRun)
    {
	l_iCount++
	
	in_iaBuffer[l_iCount] = TYPE_CAST(atoi(in_caString))
	
	if(find_string(in_caString, in_caDel, 1) != 0)
	    remove_string(in_caString, in_caDel, 1)
	else
	    l_bRun = 0
    }
	
    return l_iCount
}
*/

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
}

/**
    Отсоединение
    на входе	:	in_dvDevice - устройство
    на выходе	:	*
*/
define_function fnOnDisconnect(dev in_dvDevice)
{
    if(m_iIsConnect == 1)
    {
	ip_client_close(in_dvDevice.port)
	m_iIsConnect = 0;
    }
}

/**
    Отправка команды на верх
*/

/**
    Инициализация устройства
    на входе	:	*
    на выходе	:	*
*/
define_function fnOnInit()
{
    stack_var integer i
    stack_var IP_ADDRESS_STRUCT ip
    
    //GET_IP_ADDRESS(0:1:0, ip)
    //fnGetArray(ip.IPAddress, m_iaIP, '.')
	
    // создание таймера для поддержания соединения
    timeline_create(TL_PING_ID, m_laPing, 1, TIMELINE_ABSOLUTE, TIMELINE_REPEAT)
    
    // создание таймера для организации поддержания соединения
    timeline_create(TL_UPDATE_ID, m_laUpdate, 1, TIMELINE_ABSOLUTE, TIMELINE_REPEAT)
    
    m_lLastPingTime 	= m_lCurTime;
    m_lStartWaitTime	= m_lCurTime;
    
    // Подпишемся на события сервера
    QueueCommand("'serverstatus 0 ', itoa(MAX_PL_ITEMS),' subscribe:0'");
    
    // Запрос количества плееров
    QueueCommand("'player count ?'");
    
    //прдпись на события плеера
    fnRequestSubscribe(0);
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
    
    if(timeline_active(TL_UPDATE_ID))
	timeline_kill(TL_UPDATE_ID);
    
    m_lLastPingTime 	= m_lCurTime;
    m_lStartWaitTime	= m_lCurTime;
}

DEFINE_FUNCTION Send_TP_VText(integer tp, integer in_iCh, integer in_iSubItem, CHAR in_caData[]) 						//All variable text to panel is sent thru this function
{
    if(in_iCh > m_iScrollPlaylistIndex && in_iCh < m_iScrollLibraryIndex)
	Send_To_Panel,"'IRLB_ITEM_UNI-',itoa(TP_PlayList),',',itoa(in_iCh),',', itoa(in_iSubItem),',',ConvertUTF8ToUNI(in_caData)"
    else
    if(in_iCh > m_iScrollLibraryIndex)
	Send_To_Panel,"'IRLB_ITEM_UNI-',itoa(TP_LibraryList),',',itoa(in_iCh),',', itoa(in_iSubItem),',',ConvertUTF8ToUNI(in_caData)"
    else
	Send_To_Panel, "'^UNI-',itoa(in_iCh),',0,',ConvertUTF8ToUNI(in_caData)"   							//Unicode Modero Panels
}

DEFINE_FUNCTION char[7] Get_Time(long nTime_Tmp)
{
    stack_var char sTime_Tmp[7]
    
    if(nTime_Tmp/3600)
	sTime_Tmp = "itoa(nTime_Tmp/3600),':',format('%02d',(nTime_Tmp%3600)/60),':',format('%02d',(nTime_Tmp%3600)%60)"
    else
	sTime_Tmp = "itoa((nTime_Tmp%3600)/60),':',format('%02d',(nTime_Tmp%3600)%60)"
    return sTime_Tmp
} 

/**
    Пинг
    на входе	:	*
    на выходе	:	*
    примечание	: 	данная функция пердназначена для поддержания соединения
*/
define_function fnOnPing()
{
    stack_var 
	integer i,tp
	long l_iLevel
    
    m_lLastPingTime = m_lCurTime
    
    // Обработка плееров
    if(m_aPlayer.m_iState == PLAYER_STATUS_PLAY)
    {
	if(m_aPlayer.m_lTime < m_aPlayer.m_lDuration)
	    m_aPlayer.m_lTime++;
	else
	    m_aPlayer.m_lTime = 0
	
	for(tp = 1; tp <= MAX_PANELS; tp++) {
	    if(THIS_PanelIsOnline && g_iaPlayerInUse[tp]) {
		
		Send_TP_VText(tp, TXT_Fields[CURRENT_TIME_OF_SONG], 0, "Get_Time(m_aPlayer.m_lTime)")
		Send_TP_VText(tp, TXT_Fields[DURATION], 0, "Get_Time(m_aPlayer.m_lDuration)")
		
		if(m_aPlayer.m_lTime && m_aPlayer.m_lDuration)
		    l_iLevel = (m_aPlayer.m_lTime * 255) / m_aPlayer.m_lDuration;
		else
		    l_iLevel = 0;
		
		send_level dvPanels[tp], TP_Levels[2], l_iLevel
	    }
	}
    } else {
	for(tp = 1; tp <= MAX_PANELS; tp++) {
	    if(THIS_PanelIsOnline && g_iaPlayerInUse[tp]) {
		Send_TP_VText(tp, TXT_Fields[CURRENT_TIME_OF_SONG], 0, "'00:00'")
		Send_TP_VText(tp, TXT_Fields[DURATION], 0, "'00:00'")
		Send_TP_VText(tp, TXT_Fields[artist], 0, "''")
		Send_TP_VText(tp, TXT_Fields[album], 0, "''")
		Send_TP_VText(tp, TXT_Fields[track], 0, "''")
	    }
	}
    }
}


/**
   Запрос соединения
   на входе	:  *
   на выходе	:  *
*/
define_function fnOnConnectRequest()
{
    stack_var char packet[32]
    stack_var integer ID

    if(m_iIsConnect == 1)
    {
	// установка длинны пакета
	set_length_string(packet, 10)
    
	// отправка на устройство
	send_string dvPhysicalDevice, packet
    }
}

/**
    Обработка очереди сообщений
    на входе	:	*
    на выходе	:	*
*/
define_function ProcessQueue()
{
    if(nQueue_Counter > 0)
    {
	nQueue_Counter--
	
	if(nQueue_OutPointer = Queue_MaxCommand)
	    nQueue_OutPointer = 1
	else
	    nQueue_OutPointer ++
	
	nDeviceBusy = TRUE
	sLastCommand = sQueue[nQueue_OutPointer]
	
	send_string dvPhysicalDevice,"sLastCommand,LT"
	
	if(timeline_active(TL_WaitResponce)) {
	    timeline_kill(TL_WaitResponce)
	    timeline_create (TL_WaitResponce, lWaitResponce,1, timeline_absolute, timeline_once)
	} else {
	    timeline_create (TL_WaitResponce, lWaitResponce,1, timeline_absolute, timeline_once)
	}
	
	wait_until(!nDeviceBusy)
	{
	    ProcessQueue()
	}
    } 
}

/**
    Добавление команды в очередь
    на входе	:	CMD - команда
    на выходе	:	*
*/
define_function QueueCommand(char CMD[])
{
    if(nQueue_Counter < Queue_MaxCommand)											// we have empty position
    {
	nQueue_Counter ++
	if(nQueue_InPointer = Queue_MaxCommand)
	    nQueue_InPointer = 1
	else
	    nQueue_InPointer ++
	
	sQueue[nQueue_InPointer] = CMD
	
	wait_until(m_iIsConnect)
	    ProcessQueue()
    }
}

///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
//
//   Работа со стеком
//
///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
/**
    Очистка стека указаного плеера
    на входе	:	m_iPlayer - индекс плеера
    на выходе	:	*
*/
define_function fnClearStack()
{
    stack_var integer i;
    
    for(i = 1; i <= MAX_STACK; i++)
    {
	m_aPlayer.m_aStack[i].m_iStart = 0;
	clear_buffer m_aPlayer.m_aStack[i].m_sReq.m_szRequest;
	clear_buffer m_aPlayer.m_aStack[i].m_sReq.m_szParam;
    }
    m_aPlayer.m_iStackIndex = 0;
}

/**
    Затолкать в стрек указаного плеера
    на входе	:	*
    на выходе	:	*
*/
define_function fnPushStack()
{
    stack_var integer i;
	
    if(m_aPlayer.m_iStackIndex < MAX_STACK)
    {
	m_aPlayer.m_iStackIndex++;
	i = m_aPlayer.m_iStackIndex;
	m_aPlayer.m_aStack[i].m_iStart = 0;
	m_aPlayer.m_aStack[i].m_sReq.m_szRequest = m_aPlayer.m_sReq.m_szRequest;
	m_aPlayer.m_aStack[i].m_sReq.m_szParam = m_aPlayer.m_sReq.m_szParam;
    }
}

/**
    Вытащить из стрека указаного плеера
    на входе	:	m_iPlayer - индекс плеера
    на выходе	:	*
*/
define_function fnPopStack()
{
    stack_var integer i;
	
    if(m_aPlayer.m_iStackIndex > 0)
    {
	i = m_aPlayer.m_iStackIndex;
	
	//m_aPlayer.m_iStartView = m_aPlayer.m_aStack[i].m_iStart;
	m_aPlayer.m_sReq.m_szRequest = m_aPlayer.m_aStack[i].m_sReq.m_szRequest;
	m_aPlayer.m_sReq.m_szParam = m_aPlayer.m_aStack[i].m_sReq.m_szParam;
	
	m_aPlayer.m_aStack[i].m_iStart = 0;
	clear_buffer m_aPlayer.m_aStack[i].m_sReq.m_szRequest;
	clear_buffer m_aPlayer.m_aStack[i].m_sReq.m_szParam;
	
	m_aPlayer.m_iStackIndex--;
    }
}


/**
    Получение списка радиостанций
    на входе	:	in_pszData - указатель на полученные данные
			in_pszRequest - имя типа (local, worldи т.д.)
    на выходе	:	флаг продолжения парсинга
			true - рапсинг нужно продолжить
			false - парминг нужно прекратить
*/
define_function char fnReceiveRadioList(char in_pszData[], char in_pszRequest[])
{
    stack_var integer l_iIndex, n
    stack_var char l_bRun;
    char l_szToken[256];
    char l_szItem[256];
    char l_szTag[64]
	
    l_iIndex = 0;
    
    // Поиск первого токена
    l_szToken = remove_string(in_pszData, ' ', 1);
    while(length_array(l_szToken))
    {
	// Удаление пробела в конце строки
	set_length_array(l_szToken, length_array(l_szToken) - 1);
	
	// Поиск следующего токена
	l_szToken = URICodec_Decode(l_szToken);
	l_szTag = remove_string(l_szToken, ':', 1);
	
	if(length_array(l_szTag))
	{
	    set_length_array(l_szTag, length_array(l_szTag) - 1);
	    
	    select
	    {
		active(l_szTag == 'id'):
		{
		    l_iIndex++;
		    m_aPlayer.m_aItems[l_iIndex].m_sReq.m_szRequest = "in_pszRequest, ' items'";
		    m_aPlayer.m_aItems[l_iIndex].m_sReq.m_szParam = "'item_id:',l_szToken";
		    m_aPlayer.m_aItems[l_iIndex].m_cSelectable = 1;
		    m_aPlayer.m_aItems[l_iIndex].m_cAddable = 0;
		    m_aPlayer.m_aItems[l_iIndex].m_cType = ITEM_TYPE_RADIO;
		    m_aPlayer.m_aItems[l_iIndex].m_szID = "l_szToken";
		}
		active(l_szTag == 'hasitems'):
		{
		    n = atoi(l_szToken);
		    if(n == 0)
		    {
			m_aPlayer.m_aItems[l_iIndex].m_sReq.m_szRequest = "in_pszRequest, ' playlist play'";
			m_aPlayer.m_aItems[l_iIndex].m_cSelectable = 0;
			m_aPlayer.m_aItems[l_iIndex].m_cAddable = 1;
		    }
			
		}
		active(l_szTag == 'name'):
		    fnSendLibraryListToDevice(l_iIndex, SubItem_1, l_szToken)
		active(l_szTag == 'count'): {
		    if(m_aPlayer.m_iItems != atoi(l_szToken)) {
			fnClearLibraryList()
			m_aPlayer.m_iItems = atoi(l_szToken);
			fnInitLibraryList(m_aPlayer.m_iItems)
		    }
		}
	    }
	}
	
	// Проверка на конец строки
	l_szToken = remove_string(in_pszData, ' ', 1);
	if(!length_array(l_szToken))
	{
	    l_szToken = in_pszData;
	    set_length_array(in_pszData, 0);
	}
    }
    
    return false;
}

/**
    Получение списка жанров
    на входе	:	in_pszData - указатель на полученные данные
    на выходе	:	флаг продолжения парсинга
			true - рапсинг нужно продолжить
			false - парминг нужно прекратить
*/
define_function char fnReceiveGenres(char in_pszData[])
{
    stack_var integer l_iIndex
    stack_var char l_bRun;
    char l_szToken[256];
    char l_szTag[64]
	
    l_iIndex = 0;
    
    // Поиск первого токена
    l_szToken = remove_string(in_pszData, ' ', 1);
    while(length_array(l_szToken))
    {
	// Удаление пробела в конце строки
	set_length_array(l_szToken, length_array(l_szToken) - 1);
	
	// Поиск следующего токена
	l_szToken = URICodec_Decode(l_szToken);
	l_szTag = remove_string(l_szToken, ':', 1);
	
	if(length_array(l_szTag))
	{
	    set_length_array(l_szTag, length_array(l_szTag) - 1);
	    
	    select
	    {
		active(l_szTag == 'context') :{
		    // Подготовка плеера к получению данных
		    fnClearLibraryList();
		    fnInitLibraryList(m_aPlayer.m_iTotalGenres)
		}
		active(l_szTag == 'id'): {
		    l_iIndex++;
		    
		    m_aPlayer.m_aItems[l_iIndex].m_sReq.m_szRequest = "'artists'";
		    m_aPlayer.m_aItems[l_iIndex].m_sReq.m_szParam = "'genre_id:',l_szToken";
		    m_aPlayer.m_aItems[l_iIndex].m_cSelectable = 1;
		    m_aPlayer.m_aItems[l_iIndex].m_cAddable = 1;
		    m_aPlayer.m_aItems[l_iIndex].m_cType = ITEM_TYPE_GENRE;
		    m_aPlayer.m_aItems[l_iIndex].m_szID = "l_szToken";
		    
		}
		active(l_szTag == 'genre'):	fnSendLibraryListToDevice(l_iIndex, SubItem_1, l_szToken)
		active(l_szTag == 'count'): {
		    if(!m_aPlayer.m_iItems) {
			m_aPlayer.m_iItems = atoi(l_szToken)
		    m_aPlayer.m_aItems[l_iIndex].m_sReq.m_szRequest = "'artists'";
		    m_aPlayer.m_aItems[l_iIndex].m_sReq.m_szParam = "'genre_id:',l_szToken";
		    m_aPlayer.m_aItems[l_iIndex].m_szID = "l_szToken";
		    }
		    
		}
	    }
	}
	
	// Проверка на конец строки
	l_szToken = remove_string(in_pszData, ' ', 1);
	if(!length_array(l_szToken))
	{
	    l_szToken = in_pszData;
	    set_length_array(in_pszData, 0);
	}
    }
    
    return false;
}

/**
    Получение списка артистов
    на входе	:	in_pszData - указатель на полученные данные
    на выходе	:	флаг продолжения парсинга
			true - рапсинг нужно продолжить
			false - парминг нужно прекратить
*/
define_function char fnReceiveArtists(char in_pszData[])
{
    stack_var integer l_iIndex
    stack_var char l_bRun;
    char l_szToken[256];
    char l_szTag[64]
	
    l_iIndex = 0;
    
    // Поиск первого токена
    l_szToken = remove_string(in_pszData, ' ', 1);
    
    while(length_array(l_szToken))
    {
	// Удаление пробела в конце строки
	set_length_array(l_szToken, length_array(l_szToken) - 1);
	
	// Поиск следующего токена
	l_szToken = URICodec_Decode(l_szToken);
	l_szTag = remove_string(l_szToken, ':', 1);
	
	if(length_array(l_szTag))
	{
	    set_length_array(l_szTag, length_array(l_szTag) - 1);
	    
	    select
	    {
		active(l_szTag == 'id') :{
		    l_iIndex++;
		    
		    m_aPlayer.m_aItems[l_iIndex].m_sReq.m_szRequest = "'albums'";
		    m_aPlayer.m_aItems[l_iIndex].m_sReq.m_szParam = "'artist_id:',l_szToken";
		    m_aPlayer.m_aItems[l_iIndex].m_cSelectable = 1;
		    m_aPlayer.m_aItems[l_iIndex].m_cAddable = 1;
		    m_aPlayer.m_aItems[l_iIndex].m_cType = ITEM_TYPE_ARTIST;
		    m_aPlayer.m_aItems[l_iIndex].m_szID = "l_szToken";
		}
		active(l_szTag == 'artist'):	fnSendLibraryListToDevice(l_iIndex, SubItem_1, l_szToken)
		active(l_szTag == 'count'): {
			if(m_aPlayer.m_iItems != atoi(l_szToken)) {
			    fnClearLibraryList()
			    m_aPlayer.m_iItems = atoi(l_szToken);
			    fnInitLibraryList(m_aPlayer.m_iItems)
			}
		}
	    }
	}
	
	// Проверка на конец строки
	l_szToken = remove_string(in_pszData, ' ', 1);
	if(!length_array(l_szToken))
	{
	    l_szToken = in_pszData;
	    set_length_array(in_pszData, 0);
	}
    }
    
    return false;
}

/**
    Получение списка альбомов
    на входе	:	in_pszData - указатель на полученные данные
    на выходе	:	флаг продолжения парсинга
			true - рапсинг нужно продолжить
			false - парминг нужно прекратить
*/
define_function char fnReceiveAlbums(char in_pszData[])
{
    stack_var integer l_iIndex
    stack_var char l_bRun;
    char l_szToken[256];
    char l_szTag[64]
	
    l_iIndex = 0;
    
    // Поиск первого токена
    l_szToken = remove_string(in_pszData, ' ', 1);
    while(length_array(l_szToken))
    {
	// Удаление пробела в конце строки
	set_length_array(l_szToken, length_array(l_szToken) - 1);
	
	// Поиск следующего токена
	l_szToken = URICodec_Decode(l_szToken);
	l_szTag = remove_string(l_szToken, ':', 1);
	
	if(length_array(l_szTag))
	{
	    set_length_array(l_szTag, length_array(l_szTag) - 1);
	    
	    select
	    {
		active(l_szTag == 'id'): {
		    l_iIndex++;
		    
		    m_aPlayer.m_aItems[l_iIndex].m_sReq.m_szRequest = "'titles'";
		    m_aPlayer.m_aItems[l_iIndex].m_sReq.m_szParam = "'album_id:',l_szToken";
		    m_aPlayer.m_aItems[l_iIndex].m_cSelectable = 1;
		    m_aPlayer.m_aItems[l_iIndex].m_cAddable = 1;
		    m_aPlayer.m_aItems[l_iIndex].m_cType = ITEM_TYPE_ALBUM;
		    m_aPlayer.m_aItems[l_iIndex].m_szID = "l_szToken";
		}
		active(l_szTag == 'album'):	fnSendLibraryListToDevice(l_iIndex, SubItem_1, l_szToken)
		active(l_szTag == 'count'): {
			if(m_aPlayer.m_iItems != atoi(l_szToken)) {
			    fnClearLibraryList()
			    m_aPlayer.m_iItems = atoi(l_szToken);
			    fnInitLibraryList(m_aPlayer.m_iItems)
			}
		}
	    }
	}
	
	// Проверка на конец строки
	l_szToken = remove_string(in_pszData, ' ', 1);
	if(!length_array(l_szToken))
	{
	    l_szToken = in_pszData;
	    set_length_array(in_pszData, 0);
	}
    }
    
    return false;
}

/**
    Получение списка композиций
    на входе	:	in_pszData - указатель на полученные данные
    на выходе	:	флаг продолжения парсинга
			true - рапсинг нужно продолжить
			false - парминг нужно прекратить
*/
define_function char fnReceiveTitles(char in_pszData[])
{
    stack_var integer l_iIndex
    stack_var char l_bRun;
    char l_szToken[256];
    char l_szTag[64]
	
    l_iIndex = 0;
    
    // Поиск первого токена
    l_szToken = remove_string(in_pszData, ' ', 1);
    
    while(length_array(l_szToken))
    {
	// Удаление пробела в конце строки
	set_length_array(l_szToken, length_array(l_szToken) - 1);
	
	// Поиск следующего токена
	l_szToken = URICodec_Decode(l_szToken);
	l_szTag = remove_string(l_szToken, ':', 1);
	if(length_array(l_szTag))
	{
	    set_length_array(l_szTag, length_array(l_szTag) - 1);
	    
	    select
	    {
		active(l_szTag == 'id'): {
		    l_iIndex++;
		    
		    m_aPlayer.m_aItems[l_iIndex].m_sReq.m_szRequest = "'titles'";
		    m_aPlayer.m_aItems[l_iIndex].m_sReq.m_szParam = "'track_id:',l_szToken";
		    m_aPlayer.m_aItems[l_iIndex].m_cSelectable = 0;
		    m_aPlayer.m_aItems[l_iIndex].m_cAddable = 1;
		    m_aPlayer.m_aItems[l_iIndex].m_cType = ITEM_TYPE_TRACK;
		    m_aPlayer.m_aItems[l_iIndex].m_szID = "l_szToken";
		}
		active(l_szTag == 'title'): {
			fnSendLibraryListToDevice(l_iIndex, SubItem_1, l_szToken)
		}
		active(l_szTag == 'count'): {
			if(m_aPlayer.m_iItems != atoi(l_szToken)) {
			    fnClearLibraryList()
			    m_aPlayer.m_iItems = atoi(l_szToken);
			    fnInitLibraryList(m_aPlayer.m_iItems)
			}
		}
	    }
	}
	
	// Проверка на конец строки
	l_szToken = remove_string(in_pszData, ' ', 1);
	if(!length_array(l_szToken))
	{
	    l_szToken = in_pszData;
	    set_length_array(in_pszData, 0);
	}
    }
    
    // Отправка на устройство
    //fnSendLibraryListToDevice();
    
    return false;
}

/**
    Получение списка элементов
    на входе	:	in_pszData - указатель на полученные данные
    на выходе	:	флаг продолжения парсинга
			true - рапсинг нужно продолжить
			false - парминг нужно прекратить
*/
define_function char fnReceiveMusicfolder(char in_pszData[])
{
    stack_var integer l_iIndex
    stack_var char l_bRun;
    char l_szToken[256];
    char l_szTag[64]
	
    l_iIndex = 0;
    
    // Поиск первого токена
    l_szToken = remove_string(in_pszData, ' ', 1);
    while(length_array(l_szToken))
    {
	// Удаление пробела в конце строки
	set_length_array(l_szToken, length_array(l_szToken) - 1);
	
	// Поиск следующего токена
	l_szToken = URICodec_Decode(l_szToken);
	l_szTag = remove_string(l_szToken, ':', 1);
	
	if(length_array(l_szTag))
	{
	    set_length_array(l_szTag, length_array(l_szTag) - 1);
	    
	    select
	    {
		active(l_szTag == 'id'):
		{
		    l_iIndex++;
		    
		    m_aPlayer.m_aItems[l_iIndex].m_sReq.m_szRequest = "'musicfolder'";
		    m_aPlayer.m_aItems[l_iIndex].m_sReq.m_szParam = "'folder_id:',l_szToken";
		    m_aPlayer.m_aItems[l_iIndex].m_cSelectable = 0;
		    m_aPlayer.m_aItems[l_iIndex].m_cAddable = 0;
		    m_aPlayer.m_aItems[l_iIndex].m_cType = ITEM_TYPE_NONE;
		    m_aPlayer.m_aItems[l_iIndex].m_szID = "l_szToken";
		}
		active(l_szTag == 'filename'):
		{
		    //m_aPlayer.m_aItems[l_iIndex].m_szName = l_szToken;
		    fnSendLibraryListToDevice(l_iIndex, SubItem_1, l_szToken)
		}
		active(l_szTag == 'type'):
		{
		    select
		    {
			active(l_szToken == 'track'):
			{
			    m_aPlayer.m_aItems[l_iIndex].m_cType = ITEM_TYPE_TRACK;
			    m_aPlayer.m_aItems[l_iIndex].m_cSelectable = 0;
			    m_aPlayer.m_aItems[l_iIndex].m_cAddable = 1;
			}
			active(l_szToken == 'folder'):
			{
			    m_aPlayer.m_aItems[l_iIndex].m_cType = ITEM_TYPE_FOLDER;
			    m_aPlayer.m_aItems[l_iIndex].m_cSelectable = 1;
			    m_aPlayer.m_aItems[l_iIndex].m_cAddable = 1;
			}
			active(l_szToken == 'playlist'):
			{
			    m_aPlayer.m_aItems[l_iIndex].m_cType = ITEM_TYPE_PLAYLIST;
			    m_aPlayer.m_aItems[l_iIndex].m_cSelectable = 0;
			    m_aPlayer.m_aItems[l_iIndex].m_cAddable = 1;
			}
			active(l_szToken == 'unknown'):
			{
			    m_aPlayer.m_aItems[l_iIndex].m_cType = ITEM_TYPE_NONE;
			    m_aPlayer.m_aItems[l_iIndex].m_cSelectable = 0;
			    m_aPlayer.m_aItems[l_iIndex].m_cAddable = 0;
			}
		    }
		}
		active(l_szTag == 'count'):
		{
		    if(m_aPlayer.m_iItems != atoi(l_szToken)) {
			fnClearLibraryList()
			m_aPlayer.m_iItems = atoi(l_szToken);
			fnInitLibraryList(m_aPlayer.m_iItems)
		    }
		}
	    }
	}
	
	// Проверка на конец строки
	l_szToken = remove_string(in_pszData, ' ', 1);
	if(!length_array(l_szToken))
	{
	    l_szToken = in_pszData;
	    set_length_array(in_pszData, 0);
	}
    }
    
    return false;
}

/**
    Получение списка плейлистов
    на входе	:	in_pszData - указатель на полученные данные
    на выходе	:	флаг продолжения парсинга
			true - рапсинг нужно продолжить
			false - парминг нужно прекратить
*/
define_function char fnReceivePlaylists(char in_pszData[])
{
    stack_var integer l_iIndex
    stack_var char l_bRun;
    char l_szToken[256];
    char l_szTag[64]
	
    l_iIndex = 0;
    
    // Поиск первого токена
    l_szToken = remove_string(in_pszData, ' ', 1);
    while(length_array(l_szToken))
    {
	// Удаление пробела в конце строки
	set_length_array(l_szToken, length_array(l_szToken) - 1);
	
	// Поиск следующего токена
	l_szToken = URICodec_Decode(l_szToken);
	l_szTag = remove_string(l_szToken, ':', 1);
	
	if(length_array(l_szTag))
	{
	    set_length_array(l_szTag, length_array(l_szTag) - 1);
	    
	    select
	    {
		active(l_szTag == 'id'):
		{
		    l_iIndex++;
		    
		    m_aPlayer.m_aItems[l_iIndex].m_sReq.m_szRequest = "'playlists tracks'";
		    m_aPlayer.m_aItems[l_iIndex].m_sReq.m_szParam = "'playlist_id:',l_szToken";
		    m_aPlayer.m_aItems[l_iIndex].m_cSelectable = 0;
		    m_aPlayer.m_aItems[l_iIndex].m_cAddable = 1;
		    m_aPlayer.m_aItems[l_iIndex].m_cType = ITEM_TYPE_PLAYLIST;
		    m_aPlayer.m_aItems[l_iIndex].m_szID = "l_szToken";
		}
		active(l_szTag == 'playlist'):
		{
		    //m_aPlayer.m_aItems[l_iIndex].m_szName = l_szToken;
		    fnSendLibraryListToDevice(l_iIndex, SubItem_1, l_szToken)
		}
		active(l_szTag == 'count'):
		{
		    if(m_aPlayer.m_iItems != atoi(l_szToken)) {
			fnClearLibraryList()
			m_aPlayer.m_iItems = atoi(l_szToken);
			fnInitLibraryList(m_aPlayer.m_iItems)
		    }
		}
	    }
	}
	
	// Проверка на конец строки
	l_szToken = remove_string(in_pszData, ' ', 1);
	if(!length_array(l_szToken))
	{
	    l_szToken = in_pszData;
	    set_length_array(in_pszData, 0);
	}
    }
    
    return false;
}

/**
    Получение списка плейлистов
    на входе	:	in_pszData - указатель на полученные данные
    на выходе	:	флаг продолжения парсинга
			true - рапсинг нужно продолжить
			false - парминг нужно прекратить
*/
define_function char fnReceiveFavorites(char in_pszData[])
{
    stack_var integer l_iIndex, n
    stack_var char l_bRun;
    char l_szToken[256];
    char l_szTag[64]
	
    l_iIndex = 0;
    
    // Поиск первого токена
    l_szToken = remove_string(in_pszData, ' ', 1);
    while(length_array(l_szToken))
    {
	// Удаление пробела в конце строки
	set_length_array(l_szToken, length_array(l_szToken) - 1);
	
	// Поиск следующего токена
	l_szToken = URICodec_Decode(l_szToken);
	l_szTag = remove_string(l_szToken, ':', 1);
	
	if(length_array(l_szTag))
	{
	    set_length_array(l_szTag, length_array(l_szTag) - 1);
	    
	    select
	    {
		active(l_szTag == 'id'):
		{
		    l_iIndex++;
		    m_aPlayer.m_aItems[l_iIndex].m_sReq.m_szRequest = "'favorites items'";
		    m_aPlayer.m_aItems[l_iIndex].m_sReq.m_szParam = "'item_id:',l_szToken";
		    m_aPlayer.m_aItems[l_iIndex].m_cSelectable = 1;
		    m_aPlayer.m_aItems[l_iIndex].m_cAddable = 0;
		    m_aPlayer.m_aItems[l_iIndex].m_cType = ITEM_TYPE_FAVORITES;
		    m_aPlayer.m_aItems[l_iIndex].m_szID = "l_szToken";
		}
		active(l_szTag == 'hasitems'):
		{
		    n = atoi(l_szToken);
		    if(n == 0)
		    {
			m_aPlayer.m_aItems[l_iIndex].m_sReq.m_szRequest = "caPlayerID,' favorites playlist play'";
			m_aPlayer.m_aItems[l_iIndex].m_cSelectable = 0;
			m_aPlayer.m_aItems[l_iIndex].m_cAddable = 1;
		    }
		}
		active(l_szTag == 'name'):
		{
		    fnSendLibraryListToDevice(l_iIndex, SubItem_1, l_szToken)
		}
		active(l_szTag == 'count'):
		{
		    if(m_aPlayer.m_iItems != atoi(l_szToken)) {
			fnClearLibraryList()
			m_aPlayer.m_iItems = atoi(l_szToken);
			fnInitLibraryList(m_aPlayer.m_iItems)
		    } else {
			if(m_aPlayer.m_iItems)
			    fnInitLibraryList(m_aPlayer.m_iItems)
		    }
		}
	    }
	}
	
	// Проверка на конец строки
	l_szToken = remove_string(in_pszData, ' ', 1);
	if(!length_array(l_szToken))
	{
	    l_szToken = in_pszData;
	    set_length_array(in_pszData, 0);
	}
    }
    
    return false;
}

/**
    Получение списка типов радиостанций
    на входе	:	in_pszData - указатель на полученные данные
    на выходе	:	флаг продолжения парсинга
			true - рапсинг нужно продолжить
			false - парминг нужно прекратить
*/
define_function char fnReceiveRadios(char in_pszData[])
{
    stack_var integer l_iIndex
    char l_szToken[256];
    char l_szTag[64]
    char l_szItem[256];
    
    l_iIndex = 0;
	
    // Поиск первого токена
    l_szToken = remove_string(in_pszData, ' ', 1);
    while(length_array(l_szToken))
    {
	// Удаление пробела в конце строки
	set_length_array(l_szToken, length_array(l_szToken) - 1);
	
	// Поиск следующего токена
	l_szToken = URICodec_Decode(l_szToken);
	l_szTag = remove_string(l_szToken, ':', 1);
	
	if(length_array(l_szTag))
	{
	    set_length_array(l_szTag, length_array(l_szTag) - 1);
	    
	    select
	    {
		active(l_szTag == 'cmd'):
		{
		    l_iIndex++;
		    m_aPlayer.m_aItems[l_iIndex].m_sReq.m_szRequest = "l_szToken, ' items'";
		    m_aPlayer.m_aItems[l_iIndex].m_cSelectable = 1;
		    m_aPlayer.m_aItems[l_iIndex].m_cAddable = 0;
		    m_aPlayer.m_aItems[l_iIndex].m_cType = ITEM_TYPE_NONE;
		}
		active(l_szTag == 'name'):
		{
		    fnSendLibraryListToDevice(l_iIndex, SubItem_1, l_szToken)
		}
		active(l_szTag == 'count'):
		{
		    if(m_aPlayer.m_iItems != atoi(l_szToken)) {
			fnClearLibraryList()
			m_aPlayer.m_iItems = atoi(l_szToken);
			fnInitLibraryList(m_aPlayer.m_iItems)
		    }
		}
	    }
	}
	
	// Проверка на конец строки
	l_szToken = remove_string(in_pszData, ' ', 1);
	if(!length_array(l_szToken))
	{
	    l_szToken = in_pszData;
	    set_length_array(in_pszData, 0);
	}
    }
    
    return false;
}

/**
    Получение информации о статусе
    на входе	:	in_pszData - указатель на полученные данные
			m_iPlayer - индекс плеера
    на выходе	:	флаг продолжения парсинга
			true - рапсинг нужно продолжить
			false - парминг нужно прекратить
*/
define_function char fnReceivePlaylistList(char in_pszData[])
{
    stack_var integer l_iIndex
    stack_var char l_bRun;
    char l_szToken[256];
    char l_szTag[64]
	
    l_iIndex = 0;
    
    // Очистка списка воспроизведения
    fnClearPlaylistList();
    
    // Поиск первого токена
    l_szToken = remove_string(in_pszData, ' ', 1);
    while(length_array(l_szToken))
    {
	// Удаление пробела в конце строки
	set_length_array(l_szToken, length_array(l_szToken) - 1);
	
	// Поиск следующего токена
	l_szToken = URICodec_Decode(l_szToken);
	l_szTag = remove_string(l_szToken, ':', 1);
	
	if(length_array(l_szTag))
	{
	    set_length_array(l_szTag, length_array(l_szTag) - 1);
	    select
	    {
		active(l_szTag == 'title'): {			l_iIndex++;
								fnSendPlaylistListToDevice(l_iIndex, SubItem_2,l_szToken)
								m_aPlayer.m_aPL[l_iIndex].m_caTitle = l_szToken
		}
		active(l_szTag == 'artist'): {			//fnSendPlaylistListToDevice(l_iIndex, SubItem_3,l_szToken)
								//m_aPlayer.m_aPL[l_iIndex].m_caArtist = l_szToken
		}
		active(l_szTag == 'album'): {			//fnSendPlaylistListToDevice(l_iIndex, SubItem_4,l_szToken)
								//m_aPlayer.m_aPL[l_iIndex].m_caAlbum = l_szToken
		}
		active(l_szTag == 'duration'): {		fnSendPlaylistListToDevice(l_iIndex, SubItem_3,Get_Time(atoi(l_szToken)))
								m_aPlayer.m_aPL[l_iIndex].m_caDuration = Get_Time(atoi(l_szToken))
								//fnSendPlaylistListToDeviceOneCMD(l_iIndex)
		}
		active(l_szTag == 'playlist_tracks'): { 	m_aPlayer.m_iPLOldItems = m_aPlayer.m_iPLItems;
								m_aPlayer.m_iPLItems = atoi(l_szToken);
								fnInitPlayList(m_aPlayer.m_iPLItems)
		}
		active(true):	 				debug("'unk: ', l_szTag")
	    }
	}
	
	// Проверка на конец строки
	l_szToken = remove_string(in_pszData, ' ', 1);
	if(!length_array(l_szToken))
	{
	    l_szToken = in_pszData;
	    set_length_array(in_pszData, 0);
	}
    }
    
    return false;
}

/**
    Получение информации о статусе
    на входе	:	in_pszData - указатель на полученные данные
			m_iPlayer - индекс плеера
    на выходе	:	флаг продолжения парсинга
			true - рапсинг нужно продолжить
			false - парминг нужно прекратить
*/
define_function char fnReceiveStatus(char in_pszData[])
{
    stack_var char l_bRun;
    stack_var integer a1,tp;
    char l_szToken[256];
    char l_szTag[64]
    
    debug("'fnReceiveStatus - ', in_pszData");
    
    // Поиск первого токена
    l_szToken = remove_string(in_pszData, ' ', 1);
    
    while(length_array(l_szToken))
    {
	// Удаление пробела в конце строки
	set_length_array(l_szToken, length_array(l_szToken) - 1);
	
	// Поиск следующего токена
	l_szToken = URICodec_Decode(l_szToken);
	l_szTag = remove_string(l_szToken, ':', 1);
	
	if(length_array(l_szTag))
	{
	    set_length_array(l_szTag, length_array(l_szTag) - 1);
	    
	    select
	    {
		// режим работы
		active(l_szTag == 'mode'):
		{
		    select
		    {
			active(l_szToken == 'play'):
			    m_aPlayer.m_iState = PLAYER_STATUS_PLAY;
			active(l_szToken == 'stop'):
			    m_aPlayer.m_iState = PLAYER_STATUS_STOP;
			active(l_szToken == 'pause'):
			    m_aPlayer.m_iState = PLAYER_STATUS_PAUSE;
			active(true):
			    debug("'unk: ', l_szTag, ':',l_szToken");
		    }
		    
		    for(tp = 1; tp <= MAX_PANELS; tp++) {
			if(THIS_PanelIsOnline && g_iaPlayerInUse[tp]) {
			    
			    [This_Panel, TP_Btns[PLAYER_STATUS_PLAY]] 		= (m_aPlayer.m_iState == PLAYER_STATUS_PLAY)
			    [This_Panel, TP_Btns[PLAYER_STATUS_PAUSE+1]] 	= (m_aPlayer.m_iState == PLAYER_STATUS_PAUSE)
			    [This_Panel, TP_Btns[PLAYER_STATUS_STOP+2]]		= (m_aPlayer.m_iState == PLAYER_STATUS_STOP)
			}
		    }
			    
		}
		active(l_szTag == 'playlist repeat'):
		{
		    m_aPlayer.m_iRepeat = atoi(l_szToken)
		    for(tp = 1; tp <= MAX_PANELS; tp++)
			if(THIS_PanelIsOnline && g_iaPlayerInUse[tp])
			    Send_TP_VText(tp, TXT_Fields[REPEAT_SATUS], 0, "m_caRepeat[m_aPlayer.m_iRepeat + 1]")
		}
		active(l_szTag == 'playlist shuffle'):
		{
		    m_aPlayer.m_iShuffle = atoi(l_szToken)
		    for(tp = 1; tp <= MAX_PANELS; tp++)
			if(THIS_PanelIsOnline && g_iaPlayerInUse[tp])
			    Send_TP_VText(tp, TXT_Fields[SHUFFLE_STATUS], 0, "m_caShuffle[m_aPlayer.m_iShuffle + 1]")
		}
		active(l_szTag == 'title'):
		{
		    for(tp = 1; tp <= MAX_PANELS; tp++) {
			if(THIS_PanelIsOnline && g_iaPlayerInUse[tp]) {
			    Send_TP_VText(tp, TXT_Fields[TRACK], 0, "l_szToken")
			    Send_To_Panel, "'^BMF-', itoa(TXT_Fields[COVER_ART]),',0,%P'"
			    Send_To_Panel, "'^BBR-', itoa(TXT_Fields[COVER_ART]),',0,Squeeze_Cover_Art'"
			    Send_To_Panel, "'^RMF-Squeeze_Cover_Art,%P0%H',caHost,':', itoa(iArtworkPort), '%Amusic/current%Fcover.jpg?player=', caPlayerID"
			}
		    }
		}
		active(l_szTag == 'artist'): {			for(tp = 1; tp <= MAX_PANELS; tp++)
								    if(THIS_PanelIsOnline && g_iaPlayerInUse[tp])
									Send_TP_VText(tp, TXT_Fields[ARTIST], 0, "l_szToken") 
		}
		active(l_szTag == 'album'): {			for(tp = 1; tp <= MAX_PANELS; tp++)
								    if(THIS_PanelIsOnline && g_iaPlayerInUse[tp])
									Send_TP_VText(tp, TXT_Fields[ALBUM], 0, "l_szToken") 
		}
		active(l_szTag == 'time'):			m_aPlayer.m_lTime = atoi(l_szToken);
		active(l_szTag == 'duration'):			m_aPlayer.m_lDuration = atoi(l_szToken);
		active(l_szTag == 'playlist_cur_index'):	m_aPlayer.m_iCurrent = atoi(l_szToken);
		//active(l_szTag == 'player_name'):		m_aPlayer.m_caPlayerName = l_szToken;
		active(l_szTag == 'player_connected'):		m_aPlayer.m_IsConnected = atoi(l_szToken);
		active(l_szTag == 'player_ip'):			m_aPlayer.m_caPlayerIP = l_szToken;
		active(l_szTag == 'power'):			m_aPlayer.m_iPower = atoi(l_szToken);
		active(true):					debug("'unk: ', l_szTag, ':',l_szToken")
	    }
	}
	
	// Проверка на конец строки
	l_szToken = remove_string(in_pszData, ' ', 1);
	if(!length_array(l_szToken))
	{
	    l_szToken = in_pszData;
	    set_length_array(in_pszData, 0);
	}
    }
    
    return false;
}

/**
    Получение списка элементов
    на входе	: in_pszData - указатель на полученные данные
    на выходе	: флаг продолжения парсинга
		    true - рапсинг нужно продолжить
		    false - парминг нужно прекратить
*/
define_function char fnReceiveSearch(char in_pszData[])
{
    stack_var integer l_iIndex, count,n
    stack_var char l_bRun;
    char l_szToken[256];
    char l_szTag[64]
	
    l_iIndex = 0;
        
    // Поиск первого токена
    l_szToken = remove_string(in_pszData, ' ', 1);
    
    debug('RECEIVE SEARCH!!!')
    
    while(length_array(l_szToken))
    {
	// Удаление пробела в конце строки
	set_length_array(l_szToken, length_array(l_szToken) - 1);
	
	// Поиск следующего токена
	l_szToken = URICodec_Decode(l_szToken);
	l_szTag = remove_string(l_szToken, ':', 1);
	
	if(length_array(l_szTag))
	{
	    set_length_array(l_szTag, length_array(l_szTag) - 1);
	    
	    select
	    {
		active(l_szTag == 'count' && m_iSearchType != SEARCH_BY_RADIO):
		{
		    m_aPlayer.m_iItems = atoi(l_szToken)
		    
		    if(m_aPlayer.m_iItems == 0) {
			fnInitLibraryList(1)
			fnSendLibraryListToDevice(1, SubItem_1, m_aPlayer.m_aItems[1].m_szName)
		    }
		}
		active(l_szTag == 'context' && m_iSearchType != SEARCH_BY_RADIO):
		{
		    // Подготовка плеера к получению данных
		    fnClearLibraryList();
		    
		    m_aPlayer.m_iItems = 1;
		    m_aPlayer.m_aItems[1].m_szName = "'No results...'";
		    m_aPlayer.m_aItems[1].m_cSelectable = 0;
		    m_aPlayer.m_aItems[1].m_cAddable = 0;
		    m_aPlayer.m_aItems[1].m_cType = ITEM_TYPE_NONE;
		}
		// По трекам
		active(l_szTag == 'track_id' && m_iSearchType == SEARCH_BY_TRACK):
		{
		    l_iIndex++;
		    
		    m_aPlayer.m_aItems[l_iIndex].m_sReq.m_szRequest = "'titles'";
		    m_aPlayer.m_aItems[l_iIndex].m_sReq.m_szParam = "'track_id:',l_szToken";
		    m_aPlayer.m_aItems[l_iIndex].m_cSelectable = 0;
		    m_aPlayer.m_aItems[l_iIndex].m_cAddable = 1;
		    m_aPlayer.m_aItems[l_iIndex].m_cType = ITEM_TYPE_SEARCH_TRACK;
		    m_aPlayer.m_aItems[l_iIndex].m_szID = "l_szToken";
		}
		active(l_szTag == 'track' && m_iSearchType == SEARCH_BY_TRACK):
		{
		    fnSendLibraryListToDevice(l_iIndex, SubItem_1, l_szToken)
		}
		active(l_szTag == 'tracks_count' && m_iSearchType == SEARCH_BY_TRACK):
		{
		    m_aPlayer.m_iItems = atoi(l_szToken);
		    fnInitLibraryList(m_aPlayer.m_iItems)
		}
		// По артистам
		active(l_szTag == 'contributor_id' && m_iSearchType == SEARCH_BY_ARTIST):
		{
		    l_iIndex++;
		    
		    m_aPlayer.m_aItems[l_iIndex].m_sReq.m_szRequest = "'albums'";
		    m_aPlayer.m_aItems[l_iIndex].m_sReq.m_szParam = "'artist_id:',l_szToken";
		    m_aPlayer.m_aItems[l_iIndex].m_cSelectable = 1;
		    m_aPlayer.m_aItems[l_iIndex].m_cAddable = 1;
		    m_aPlayer.m_aItems[l_iIndex].m_cType = ITEM_TYPE_ARTIST;
		    m_aPlayer.m_aItems[l_iIndex].m_szID = "l_szToken";
		}
		active(l_szTag == 'contributor' && m_iSearchType == SEARCH_BY_ARTIST):
		{
		    fnSendLibraryListToDevice(l_iIndex, SubItem_1, l_szToken)
		}
		active(l_szTag == 'contributors_count' && m_iSearchType == SEARCH_BY_ARTIST):
		{
		    m_aPlayer.m_iItems = atoi(l_szToken);
		    fnInitLibraryList(m_aPlayer.m_iItems)
		}
		// По альбомам
		active(l_szTag == 'album_id' && m_iSearchType == SEARCH_BY_ALBUM):
		{
		    l_iIndex++;
		    
		    m_aPlayer.m_aItems[l_iIndex].m_sReq.m_szRequest = "'titles'";
		    m_aPlayer.m_aItems[l_iIndex].m_sReq.m_szParam = "'album_id:',l_szToken";
		    m_aPlayer.m_aItems[l_iIndex].m_cSelectable = 1;
		    m_aPlayer.m_aItems[l_iIndex].m_cAddable = 1;
		    m_aPlayer.m_aItems[l_iIndex].m_cType = ITEM_TYPE_ALBUM;
		    m_aPlayer.m_aItems[l_iIndex].m_szID = "l_szToken";
		}
		active(l_szTag == 'album' && m_iSearchType == SEARCH_BY_ALBUM):
		{
		    fnSendLibraryListToDevice(l_iIndex, SubItem_1, l_szToken)
		}
		active(l_szTag == 'albums_count' && m_iSearchType == SEARCH_BY_ALBUM):
		{
		    m_aPlayer.m_iItems = atoi(l_szToken);
		    fnInitLibraryList(m_aPlayer.m_iItems)
		}
		// По жанрам
		active(l_szTag == 'genre_id' && m_iSearchType == SEARCH_BY_GENRE):
		{
		    l_iIndex++;
		    
		    m_aPlayer.m_aItems[l_iIndex].m_sReq.m_szRequest = "'artists'";
		    m_aPlayer.m_aItems[l_iIndex].m_sReq.m_szParam = "'genre_id:',l_szToken";
		    m_aPlayer.m_aItems[l_iIndex].m_cSelectable = 1;
		    m_aPlayer.m_aItems[l_iIndex].m_cAddable = 1;
		    m_aPlayer.m_aItems[l_iIndex].m_cType = ITEM_TYPE_GENRE;
		    m_aPlayer.m_aItems[l_iIndex].m_szID = "l_szToken";
		}
		active(l_szTag == 'genre' && m_iSearchType == SEARCH_BY_GENRE):
		{
		    fnSendLibraryListToDevice(l_iIndex, SubItem_1, l_szToken)
		}
		active(l_szTag == 'genres_count' && m_iSearchType == SEARCH_BY_GENRE):
		{
		    m_aPlayer.m_iItems = atoi(l_szToken);
		    fnInitLibraryList(m_aPlayer.m_iItems)
		}
		//by radio
		/*
		fnGetPlayerID(l_iPlayer)
		
		search items 0 1 search:ibiza

		00:04:20:18:1d:e5 search items 0 1 
		search:ibiza 
		title:Search 
		Results: ibiza 
		id:2e80d717_ibiza.0 
		name:The Source Tribe (Recent Episodes) 
		type:link 
		image:http:%2F%2Fd1i6vahw24eb07.cloudfront.net%2Fp443630q.png 
		isaudio:0 
		hasitems:1 
		count:34
		
		active(l_szTag == 'context' && m_iSearchType != SEARCH_BY_RADIO):
		{
		    m_aPlayer.m_iItems = 1;
		    m_aPlayer.m_aItems[1].m_szName = "'No results...'";
		    m_aPlayer.m_aItems[1].m_cSelectable = 0;
		    m_aPlayer.m_aItems[1].m_cAddable = 0;
		    m_aPlayer.m_aItems[1].m_cType = ITEM_TYPE_NONE;
		}*/
		active(l_szTag == 'count' && m_iSearchType == SEARCH_BY_RADIO):
		{
		    if(m_aPlayer.m_iItems != atoi(l_szToken)) {
			fnClearLibraryList()
			m_aPlayer.m_iItems = atoi(l_szToken);
			fnInitLibraryList(m_aPlayer.m_iItems)
		    }
		}
		active(l_szTag == 'isaudio' && m_iSearchType == SEARCH_BY_RADIO):
		{
		    n = atoi(l_szToken);
		    if(n == 1)
		    {
			m_aPlayer.m_aItems[l_iIndex].m_sReq.m_szRequest = "'local playlist play'";
			m_aPlayer.m_aItems[l_iIndex].m_cSelectable = 0;
			m_aPlayer.m_aItems[l_iIndex].m_cAddable = 1;
		    } else {
			m_aPlayer.m_aItems[l_iIndex].m_cSelectable = 1;
			m_aPlayer.m_aItems[l_iIndex].m_cAddable = 0;
		    }
		}
		active(l_szTag == 'id' && m_iSearchType == SEARCH_BY_RADIO):
		{
		    l_iIndex++;
		    
		    m_aPlayer.m_aItems[l_iIndex].m_sReq.m_szRequest = "'local items'";
		    m_aPlayer.m_aItems[l_iIndex].m_sReq.m_szParam = "'item_id:',l_szToken";
		    m_aPlayer.m_aItems[l_iIndex].m_cSelectable = 1;
		    m_aPlayer.m_aItems[l_iIndex].m_cAddable = 1;
		    m_aPlayer.m_aItems[l_iIndex].m_cType = ITEM_TYPE_RADIO;
		    m_aPlayer.m_aItems[l_iIndex].m_szID = "l_szToken";
		}
		active(l_szTag == 'name' && m_iSearchType == SEARCH_BY_RADIO):
		{
		    fnSendLibraryListToDevice(l_iIndex, SubItem_1, l_szToken)
		}
		active(true):
		{
		    debug("'unknown string: ', l_szTag, ' : ', l_szToken");
		}
	    }
	}
	
	// Проверка на конец строки
	l_szToken = remove_string(in_pszData, ' ', 1);
	
	if(!length_array(l_szToken))
	{
	    l_szToken = in_pszData;
	    set_length_array(in_pszData, 0);
	}
    }
    
    return false;
}

/**
    Получение информации о статусе сервера
    на входе	:	in_pszData - указатель на полученные данные
			m_iPlayer - индекс плеера
    на выходе	:	флаг продолжения парсинга
			true - рапсинг нужно продолжить
			false - парминг нужно прекратить
*/
define_function char fnReceiveServerStatus(char in_pszData[])
{
    stack_var integer l_iIndex
    stack_var integer l_iPlayer
    stack_var char l_bRun;
    char l_szToken[256];
    char l_szTag[64]
    
	
    l_iIndex = 0;
    
    // Поиск первого токена
    l_szToken = remove_string(in_pszData, ' ', 1);
    
    while(length_array(l_szToken))
    {
	// Удаление пробела в конце строки
	set_length_array(l_szToken, length_array(l_szToken) - 1);
	
	// Поиск следующего токена
	l_szToken = URICodec_Decode(l_szToken);
	l_szTag = remove_string(l_szToken, ':', 1);
	
	if(length_array(l_szTag))
	{
	    set_length_array(l_szTag, length_array(l_szTag) - 1);
	    select
	    {
		active(l_szTag = 'connected'):		m_aPlayer.m_IsConnected = atoi(l_szToken)
		//active(l_szTag = 'lastscan'):		m_aPlayer.m_caLastScan = Get_Time(atoi(l_szToken));
		active(l_szTag = 'info total albums'):	m_aPlayer.m_iTotalAlbums = atoi(l_szToken);
		active(l_szTag = 'info total artists'):	m_aPlayer.m_iTotalArtists = atoi(l_szToken);
		active(l_szTag = 'info total genres'):	m_aPlayer.m_iTotalGenres = atoi(l_szToken);
		active(l_szTag = 'info total songs'):	m_aPlayer.m_iTotalSongs = atoi(l_szToken);
		//active(l_szTag = 'server'):		m_aPlayer.m_caServer = l_szToken;
		//active(l_szTag = 'serverurl'):		m_aPlayer.m_caServerURL = l_szToken;
		active(true):				debug("'unk: ', l_szTag")
	    }
	}
	// Проверка на конец строки
	l_szToken = remove_string(in_pszData, ' ', 1);
	if(!length_array(l_szToken))
	{
	    l_szToken = in_pszData;
	    set_length_array(in_pszData, 0);
	}
    }
    
    return false;
}

define_function char fnReceivePlayer(char in_pszData[])
{
    stack_var integer l_iPlayerIndex;
    
    char l_szToken[32];
    
    // Поиск первого токена
    l_szToken = remove_string(in_pszData, ' ', 1);
    if(length_array(l_szToken))
    {
	// Удаление пробела в конце строки
	set_length_array(l_szToken, length_array(l_szToken) - 1);
	
	select
	{
	    active(l_szToken == 'count'):
	    {
		m_iPlayersOf = atoi(in_pszData);
		for(l_iPlayerIndex = 0; l_iPlayerIndex < m_iPlayersOf; l_iPlayerIndex++)
		    QueueCommand("'player id ',itoa(l_iPlayerIndex), ' ?'");
	    }
	    active(l_szToken == 'id'):
	    {
		// Получение индекса и идентификатора плеера
		l_iPlayerIndex = atoi(in_pszData)
		remove_string(in_pszData, ' ', 1);
		l_szToken = in_pszData;
		set_length_array(l_szToken, length_array(l_szToken) - 1);
		
		if(URICodec_Decode(l_szToken) == caPlayerID) {
		    m_aPlayer.m_iPlayerIndex = l_iPlayerIndex
		    m_aPlayer.m_cUse = 0;
		}
	    }
	}
    }
    return false;
}

/**
    Обработка ответа
    на входе	:	in_sbBuffer - полученый пакет
    на выходе	:	true - команда обработана
			false - недостаточно данных
*/
define_function fnOnReceive(char in_pszData[])
{
    stack_var integer l_iPacketID, l_iHandle, i, v, l_iState, l_iCommand, l_iTokenNum, l_iPlayer
    stack_var char l_cTmp
    stack_var char l_caBuffer[512]
    stack_var char l_bRun;
    stack_var char l_caTmpString[MAX_REQUEST_LEN]
    stack_var char l_caDecodedString[MAX_REQUEST_LEN]
    stack_var char sStringToSwitch[128]
    
    char l_szToken[256];
    char l_szPrev[256];
        
    l_bRun = true;
    l_iState = RECEIVE_STATE_START;
    l_iTokenNum = 0;

    debug("'fnOnReceive - "', in_pszData,'"'")

    in_pszData[length_string(in_pszData)] = ' '
    l_caTmpString = remove_string(in_pszData,' ',1)
    l_caDecodedString = URICodec_Decode(l_caTmpString)
   
    l_szToken = l_caDecodedString
    
    debug("'Find Token -> "', l_szToken,'"'")
    
    if(length_string(sLastCommand) >= length_string(l_szToken) && left_string(sLastCommand,length_string(l_szToken)) == l_szToken) {
	nDeviceBusy = FALSE
	clear_buffer sLastCommand
    } else {
	
	if(find_string(l_szToken, caPlayerID, 1)) {
	    //l_iState = RECEIVE_STATE_PLAYER_ID
	    nDeviceBusy = FALSE
	} else {
	    debug("'::WARNING:: LastCommand - "', sLastCommand,'"'")
	    debug("'::WARNING:: NewCommand - "', l_szToken,' ', in_pszData,'"'")
	}
    }
    
    while(length_array(l_szToken) && l_bRun)
    {
	// Поиск следующего токена
	//l_szToken = URICodec_Decode(l_szToken);
	set_length_array(l_szToken, length_array(l_szToken) - 1);
	
	select
	{
	    // Первичная обработка
	    active(l_iState == RECEIVE_STATE_START):
	    {
		select
		{
		    active(l_szToken == 'player'):		l_bRun = fnReceivePlayer(in_pszData);
		    active(l_szToken == 'artists'):		l_bRun = fnReceiveArtists(in_pszData);
		    active(l_szToken == 'albums'):		l_bRun = fnReceiveAlbums(in_pszData);
		    active(l_szToken == 'genres'):		l_bRun = fnReceiveGenres(in_pszData);
		    active(l_szToken == 'titles'):		l_bRun = fnReceiveTitles(in_pszData);
		    active(l_szToken == 'musicfolder'):		l_bRun = fnReceiveMusicfolder(in_pszData);
		    active(l_szToken == 'playlists'):		l_bRun = fnReceivePlaylists(in_pszData);
		    active(l_szToken == 'favorites'):		l_bRun = fnReceiveFavorites(in_pszData);
		    active(l_szToken == 'radios'):		l_bRun = fnReceiveRadios(in_pszData);
		    active(l_szToken == 'search'):		l_bRun = fnReceiveSearch(in_pszData);
		    active(l_szToken == 'serverstatus'):	l_bRun = fnReceiveServerStatus(in_pszData);
		    active(true):
		    {
			// Если токен первый попробуем поискать номер плеера
			if(m_aPlayer.m_caID == l_szToken) {
			    l_iState = RECEIVE_STATE_PLAYER_ID;
			} else {
			    debug("'unknown tocken ', l_szToken");
			    l_bRun = false;
			}
		    }
		}
	    }
	    // Обработка команды с указанием плеера
	    active(l_iState == RECEIVE_STATE_PLAYER_ID):
	    {
		select
		{
		    active(l_szToken == 'local'):
			l_bRun = fnReceiveRadioList(in_pszData, 'local');
		    active(l_szToken == 'picks'):
			l_bRun = fnReceiveRadioList(in_pszData, 'picks');
		    active(l_szToken == 'world'):
			l_bRun = fnReceiveRadioList(in_pszData, 'world');
		    active(l_szToken == 'music'):
			l_bRun = fnReceiveRadioList(in_pszData, 'music');
		    active(l_szToken == 'search'): {
			l_bRun = fnReceiveSearch(in_pszData);
		    }
		    active(l_szToken == 'status'):
			l_iState = RECEIVE_STATE_STATUS;
		}
	    }
	    // Обработка состояния плейлиста
	    active(l_iState == RECEIVE_STATE_STATUS):
	    {
		select
		{
		    active(l_szToken == '-'): {
			l_bRun = fnReceiveStatus(in_pszData);
			nDeviceBusy = FALSE
			fnCommandInitPlaylist()
		    }
		    active(true):
			l_bRun = fnReceivePlaylistList(in_pszData);
		}
	    }
	    active(true):
	    {
		debug("'unknown token ', l_szToken");
	    }
	}
	
	l_iTokenNum++;
	
	// Проверка на конец строки
	l_szToken = remove_string(in_pszData, ' ', 1);
	if(!length_array(l_szToken))
	{
	    l_szToken = in_pszData;
	    set_length_array(in_pszData, 0);
	}
    }
}

/**
    Очистка списка
    на входе	:	m_iPlayer - номер плеера
    на выходе	:	*
*/
define_function fnClearLibraryList()
{
    stack_var integer i,tp
	
    // Обнуление количества элементов
    m_aPlayer.m_iItems = 0;
    
    for(tp = 1; tp <= MAX_PANELS; tp++) {
	if(THIS_PanelIsOnline && g_iaPlayerInUse[tp]) {
	    Send_To_Panel, "'IRLB_CLEAR-', itoa(TP_LibraryList)"
	}
    }

    // Особождение буферов
    for(i = 1; i <= MAX_ITEMS; i++)
    {
	clear_buffer m_aPlayer.m_aItems[i].m_szName
	clear_buffer m_aPlayer.m_aItems[i].m_sReq.m_szRequest
	clear_buffer m_aPlayer.m_aItems[i].m_sReq.m_szParam
	m_aPlayer.m_aItems[i].m_cSelectable = 0
	m_aPlayer.m_aItems[i].m_cAddable = 0
	m_aPlayer.m_aItems[i].m_cType = ITEM_TYPE_NONE;
	clear_buffer m_aPlayer.m_aItems[i].m_szID
    }
}

/**
    Очистка списка
    на входе	:	m_iPlayer - номер плеера
    на выходе	:	*
*/
define_function fnClearPlaylistList()
{
    stack_var integer i, tp
	
    // Обнуление количества элементов
    //m_aPlayer.m_iPLItems = 0;
    //m_aPlayer.m_iCurrent = $FFFF;

    for(tp = 1; tp <= MAX_PANELS; tp++) {
	if(THIS_PanelIsOnline && g_iaPlayerInUse[tp]) {
	    Send_To_Panel, "'IRLB_CLEAR-', itoa(TP_PlayList)"
	}
    }
    
    // Особождение буферов
    for(i = 1; i <= MAX_PL_ITEMS; i++) {
	clear_buffer m_aPlayer.m_aPL[i].m_caTitle
	clear_buffer m_aPlayer.m_aPL[i].m_caAlbum
	clear_buffer m_aPlayer.m_aPL[i].m_caArtist
	clear_buffer m_aPlayer.m_aPL[i].m_caGenre
	clear_buffer m_aPlayer.m_aPL[i].m_caTime
    }
}

define_function fnInitLibraryList(integer in_iListSize)
{
    stack_var 
	integer i,tp
    
    for(tp = 1; tp <= MAX_PANELS; tp++) {
	if(THIS_PanelIsOnline && g_iaPlayerInUse[tp]) {
	    Send_TP_VText(tp, TXT_Fields[LIBRARY_TOTAL_COUNT], 0, "'Total - ', itoa(m_aPlayer.m_iItems)")
	    Send_To_Panel, "'IRLB_ADD-',itoa(TP_LibraryList),',', itoa(in_iListSize),',',itoa(m_iScrollLibraryIndex + 1)"
	}
    }
}

/**
    Отправка списка на устройство
    на входе	:	m_iPlayer - номер плеера
    на выходе	:	*
    примечание	:	формат отправки
*/
define_function fnSendLibraryListToDevice(integer in_iIndex, integer in_iSubItem,char in_caData[])
{
    stack_var 
	integer i,tp
	char l_szBuf[MAX_REQUEST_LEN];
	
	for(tp = 1; tp <= MAX_PANELS; tp++) {
	    if(THIS_PanelIsOnline && g_iaPlayerInUse[tp]) {
		Send_TP_VText(tp, in_iIndex + m_iScrollLibraryIndex, in_iSubItem, in_caData)
	    }
	}
	/*
	for(tp = 1; tp <= MAX_PANELS; tp++) {
	    if(THIS_PanelIsOnline && g_iaPlayerInUse[tp]) {
		Send_To_Panel, "'IRLB_ITEM_UNI-',itoa(TP_LibraryList),',',itoa(in_iIndex + m_iScrollLibraryIndex),',', itoa(in_iSubItem),',',ConvertUTF8ToUNI(m_aPlayer.m_aPL[in_iIndex].m_caTitle),
				'IRLB_ITEM_TEXT-',itoa(TP_LibraryList),',',itoa(in_iIndex + m_iScrollLibraryIndex),',', itoa(in_iSubItem + 1),',+'"
	    }
	}*/
}

define_function fnInitPlayList(integer in_iListSize)
{
    stack_var 
	integer i,tp
    
    //if(m_aPlayer.m_iPLOldItems == m_aPlayer.m_iPLItems)
	//fnUpdatePlayList()
    //else
	for(tp = 1; tp <= MAX_PANELS; tp++) {
	    if(THIS_PanelIsOnline && g_iaPlayerInUse[tp]) {
		Send_TP_VText(tp, TXT_Fields[PLAYLIST_TOTAL_COUNT], 0, "'Total - ', itoa(m_aPlayer.m_iPLItems)")
		Send_To_Panel, "'IRLB_ADD-',itoa(TP_PlayList),',', itoa(in_iListSize),',',itoa(m_iScrollPlaylistIndex + 1)"
	    }
	}
}

define_function fnUpdatePlayList()
{
    stack_var integer in_iIndex, tp
    
    for(in_iIndex = 1; in_iIndex <= m_aPlayer.m_iPLItems; in_iIndex++) {
	for(tp = 1; tp <= MAX_PANELS; tp++) {
	    if(THIS_PanelIsOnline && g_iaPlayerInUse[tp]) {
		
		Send_TP_VText(tp, in_iIndex + m_iScrollPlaylistIndex, SubItem_2, m_aPlayer.m_aPL[in_iIndex].m_caTitle)
		Send_TP_VText(tp, in_iIndex + m_iScrollPlaylistIndex, SubItem_3, m_aPlayer.m_aPL[in_iIndex].m_caArtist)
		Send_TP_VText(tp, in_iIndex + m_iScrollPlaylistIndex, SubItem_4, m_aPlayer.m_aPL[in_iIndex].m_caAlbum)
		Send_TP_VText(tp, in_iIndex + m_iScrollPlaylistIndex, SubItem_5, m_aPlayer.m_aPL[in_iIndex].m_caTime)
		
		if(in_iIndex != (m_aPlayer.m_iCurrent + 1)) {//index of non playing song
		    Send_To_Panel, "'IRLB_ITEM_OPACITY-',itoa(TP_PlayList),',',itoa(m_iScrollPlaylistIndex + in_iIndex),',1,180'"
		    Send_To_Panel, "'IRLB_ITEM_COLOR-',itoa(TP_PlayList),',',itoa(m_iScrollPlaylistIndex + in_iIndex),',1,grey13'"
		} else {
		    Send_To_Panel, "'IRLB_ITEM_OPACITY-',itoa(TP_PlayList),',',itoa(m_iScrollPlaylistIndex + in_iIndex),',1,230'"
		    Send_To_Panel, "'IRLB_ITEM_COLOR-',itoa(TP_PlayList),',',itoa(m_iScrollPlaylistIndex + in_iIndex),',1,verylightaqua'"
		}
	    }
	}
    }
}
/**
    Отправка списка на устройство
    на входе	:	m_iPlayer - номер плеера
    на выходе	:	*
*/
define_function fnSendPlaylistListToDeviceOneCMD(integer in_iIndex)
{
    stack_var 
	integer tp

    for(tp = 1; tp <= MAX_PANELS; tp++) {
	if(THIS_PanelIsOnline && g_iaPlayerInUse[tp]) {
	    
	    //Send_TP_VText(tp, in_iIndex + m_iScrollPlaylistIndex, in_iSubItem, in_caData)
	    
	    if(in_iIndex != (m_aPlayer.m_iCurrent + 1)) {//index of non playing song
		
		Send_To_Panel, "
		'IRLB_ITEM_UNI-',itoa(TP_PlayList),',',itoa(in_iIndex + m_iScrollPlaylistIndex),',', itoa(SubItem_2),',',ConvertUTF8ToUNI(m_aPlayer.m_aPL[in_iIndex].m_caTitle),13,10,
		'IRLB_ITEM_UNI-',itoa(TP_PlayList),',',itoa(in_iIndex + m_iScrollPlaylistIndex),',', itoa(SubItem_3),',',ConvertUTF8ToUNI(m_aPlayer.m_aPL[in_iIndex].m_caArtist),13,10,
		'IRLB_ITEM_UNI-',itoa(TP_PlayList),',',itoa(in_iIndex + m_iScrollPlaylistIndex),',', itoa(SubItem_4),',',ConvertUTF8ToUNI(m_aPlayer.m_aPL[in_iIndex].m_caAlbum),13,10,
		'IRLB_ITEM_UNI-',itoa(TP_PlayList),',',itoa(in_iIndex + m_iScrollPlaylistIndex),',', itoa(SubItem_5),',',ConvertUTF8ToUNI(m_aPlayer.m_aPL[in_iIndex].m_caDuration),13,10,
		'IRLB_ITEM_OPACITY-',itoa(TP_PlayList),',',itoa(m_iScrollPlaylistIndex + in_iIndex),',1,180',13,10,
		'IRLB_ITEM_COLOR-',itoa(TP_PlayList),',',itoa(m_iScrollPlaylistIndex + in_iIndex),',1,grey13'"
	    } else {
		Send_To_Panel, "
		'IRLB_ITEM_UNI-',itoa(TP_PlayList),',',itoa(in_iIndex + m_iScrollPlaylistIndex),',', itoa(SubItem_2),',',ConvertUTF8ToUNI(m_aPlayer.m_aPL[in_iIndex].m_caTitle),13,10,
		'IRLB_ITEM_UNI-',itoa(TP_PlayList),',',itoa(in_iIndex + m_iScrollPlaylistIndex),',', itoa(SubItem_3),',',ConvertUTF8ToUNI(m_aPlayer.m_aPL[in_iIndex].m_caArtist),13,10,
		'IRLB_ITEM_UNI-',itoa(TP_PlayList),',',itoa(in_iIndex + m_iScrollPlaylistIndex),',', itoa(SubItem_4),',',ConvertUTF8ToUNI(m_aPlayer.m_aPL[in_iIndex].m_caAlbum),13,10,
		'IRLB_ITEM_UNI-',itoa(TP_PlayList),',',itoa(in_iIndex + m_iScrollPlaylistIndex),',', itoa(SubItem_5),',',ConvertUTF8ToUNI(m_aPlayer.m_aPL[in_iIndex].m_caDuration),13,10,
		'IRLB_ITEM_OPACITY-',itoa(TP_PlayList),',',itoa(m_iScrollPlaylistIndex + in_iIndex),',1,230',13,10,
		'IRLB_ITEM_COLOR-',itoa(TP_PlayList),',',itoa(m_iScrollPlaylistIndex + in_iIndex),',1,verylightaqua'"
	    }
	}
    }
}
/**
    Отправка списка на устройство
    на входе	:	m_iPlayer - номер плеера
    на выходе	:	*
*/
define_function fnSendPlaylistListToDevice(integer in_iIndex, integer in_iSubItem,char in_caData[])
{
    stack_var 
	integer tp

    for(tp = 1; tp <= MAX_PANELS; tp++) {
	if(THIS_PanelIsOnline && g_iaPlayerInUse[tp]) {
	    
	    Send_TP_VText(tp, in_iIndex + m_iScrollPlaylistIndex, in_iSubItem, in_caData)
	    
	    if(in_iIndex != (m_aPlayer.m_iCurrent + 1)) {//index of non playing song
		Send_To_Panel, "'IRLB_ITEM_OPACITY-',itoa(TP_PlayList),',',itoa(m_iScrollPlaylistIndex + in_iIndex),',1,180'"
		Send_To_Panel, "'IRLB_ITEM_COLOR-',itoa(TP_PlayList),',',itoa(m_iScrollPlaylistIndex + in_iIndex),',1,grey13'"
	    } else {
		Send_To_Panel, "'IRLB_ITEM_OPACITY-',itoa(TP_PlayList),',',itoa(m_iScrollPlaylistIndex + in_iIndex),',1,230'"
		Send_To_Panel, "'IRLB_ITEM_COLOR-',itoa(TP_PlayList),',',itoa(m_iScrollPlaylistIndex + in_iIndex),',1,verylightaqua'"
	    }
	}
    }
}

/**
    Запрос текщего списка воспроизведения
    на входе	:	m_iPlayer - номер плеера
    на выходе	:	*
*/
define_function fnRequestPlaylist()
{
    char l_szRequest[64];
    l_szRequest = "caPlayerID,' status 0 ', itoa(MAX_PL_ITEMS),' context:', itoa(m_aPlayer.m_iPlayerIndex)"
    QueueCommand(l_szRequest);
}

/**
    Запрос текущего состояния 
    на входе	: m_iPlayer - номер плеера
		  in_iPeriod - промежуток времени между вызовами
    на выходе	: *
*/
define_function fnRequestSubscribe(integer in_iPeriod)
{
    char l_szRequest[64];
    l_szRequest = "caPlayerID,' status - 1 subscribe:',itoa(in_iPeriod),' tag:gald'";
    QueueCommand(l_szRequest);
}

/**
    Переход в корневой список
    на входе	:	m_iPlayer - номер плеера
    на выходе	:	*
*/
define_function fnCommandInitPlaylist()
{
    // Очистка списка воспроизведения
    fnClearPlaylistList();
    // Запрос списка воспроизведения
    //m_aPlayer.m_iPLStartView = 0;
    //m_aPlayer.m_iCurrent = $FFFF;
    fnRequestPlaylist();
}

/**
    Переход в корневой список
    на входе	:	m_iPlayer - номер плеера
    на выходе	:	*
*/
define_function fnCommandInitMediaLibrary()
{
    stack_var integer i
    
    // Очистка списка
    fnClearLibraryList();
    
    m_aPlayer.m_iItems = length_array(m_caRootMenu)
    
    fnInitLibraryList(m_aPlayer.m_iItems)
    // Очистка стека
    fnClearStack();
    
    // Очистка текущего запроса
    //m_aPlayer.m_iStartView = 0
    clear_buffer m_aPlayer.m_sReq.m_szRequest
    clear_buffer m_aPlayer.m_sReq.m_szParam
        
    // Отправка списка на устройство
    for(i = 1; i <= m_aPlayer.m_iItems; i++) {
	
	m_aPlayer.m_aItems[i].m_sReq.m_szRequest = m_caRootMenuRequests[i];
	m_aPlayer.m_aItems[i].m_cAddable = 0;
	
	if(m_caRootMenuRequests[i] != '') {
	    m_aPlayer.m_aItems[i].m_cSelectable = 1;
	} else {
	    m_aPlayer.m_aItems[i].m_cSelectable = 0;
	    
	    if(m_caRootMenu[i] == 'Random MIX')
		m_aPlayer.m_aItems[i].m_cType = ITEM_TYPE_MIX
	}
	
	fnSendLibraryListToDevice(i, SubItem_1, m_caRootMenu[i])    // Заполнение списка
    }
}


/**
    Формирование строки запроса
    на входе	:	m_iPlayer - номер плеера
    на выходе	:	строка с параметрами
*/
define_function char[MAX_REQUEST_LEN] fnCreateRequest()
{
    stack_var 
	char l_szRequest[MAX_REQUEST_LEN]
	char l_szTempRequest[MAX_REQUEST_LEN]
	
    l_szRequest = "m_aPlayer.m_sReq.m_szRequest, ' 0 ', itoa(MAX_ITEMS)"
        
    if(length_array(m_aPlayer.m_sReq.m_szParam))
	if(m_aPlayer.m_sReq.m_szRequest == 'titles')
	    l_szRequest = "l_szRequest, ' sort:albumtrack ', m_aPlayer.m_sReq.m_szParam";
	else
	    l_szRequest = "l_szRequest, ' ', m_aPlayer.m_sReq.m_szParam";
    
    //
    if( m_aPlayer.m_sReq.m_szRequest == 'titles' ||
	m_aPlayer.m_sReq.m_szRequest == 'artists' ||
	m_aPlayer.m_sReq.m_szRequest == 'albums' ||
	m_aPlayer.m_sReq.m_szRequest == 'favorites items' ||
	m_aPlayer.m_sReq.m_szRequest == 'playlists' ||
	m_aPlayer.m_sReq.m_szRequest == 'musicfolder' ||
	m_aPlayer.m_sReq.m_szRequest == 'pick items' ||
	m_aPlayer.m_sReq.m_szRequest == 'local items' ||
	m_aPlayer.m_sReq.m_szRequest == 'music items' ||
	m_aPlayer.m_sReq.m_szRequest == 'world items' ||
	m_aPlayer.m_sReq.m_szRequest == 'search items')// ||
	//m_aPlayer.m_sReq.m_szRequest == 'search' )
    {
	l_szTempRequest = "m_aPlayer.m_sReq.m_szRequest, ' count 0 1 ', m_aPlayer.m_sReq.m_szParam, ' context:', itoa(m_aPlayer.m_iPlayerIndex), LT,
			    l_szRequest, ' context:', itoa(m_aPlayer.m_iPlayerIndex)"
	    
	l_szRequest = l_szTempRequest
    } else {
	l_szRequest = "l_szRequest, ' context:', itoa(m_aPlayer.m_iPlayerIndex)";
    }
    
    //для случая когда надо поставить в очередь одновременно 2 команды
    if(find_string(l_szRequest, LT, 1) > 0) {
	l_szTempRequest = remove_string(l_szRequest, "LT", 1)
	set_length_string(l_szTempRequest, length_string(l_szTempRequest) - 1)
	debug("'fnCreateRequest - ', l_szTempRequest")
	QueueCommand(l_szTempRequest)
	debug("'fnCreateRequest - ', l_szRequest")
	return l_szRequest
    } else {
	debug("'fnCreateRequest - ', l_szRequest")
	return l_szRequest
    }
}

/**
    Поиск среди альбомов, артистов и треков
    на входе	: m_iPlayer - номер плеера
		  in_iType - тип поиска
		  in_pszSearch - строка поиска
    на выходе	: строка с параметрами
*/
define_function fnSearch(integer tp, char in_pszSearch[])
{
    stack_var 
	char l_szRequest[MAX_REQUEST_LEN];
    	
    // Сохраним текущий запрос
    if(m_aPlayer.m_sReq.m_szRequest != 'search')
	fnPushStack();
    
    // Формирование запроса
    if(m_iSearchType < 5 ) {
	//m_aPlayer.m_iStartView = 0;
	m_aPlayer.m_sReq.m_szRequest = 'search';
	m_aPlayer.m_sReq.m_szParam = "'term:', in_pszSearch";
    } else {
	//m_aPlayer.m_iStartView = 0;
	m_aPlayer.m_sReq.m_szRequest = 'search items';
	m_aPlayer.m_sReq.m_szParam = "'search:', in_pszSearch";
    }
    
    debug("':: fnSearch :: Player ', itoa(m_aPlayer.m_iPlayerIndex),' :: Type ', itoa(m_iSearchType),' :: ',in_pszSearch")
    
    // Формирование запроса
    l_szRequest = fnCreateRequest();
    
    // Постановка в очередь
    QueueCommand(l_szRequest);
}

/**
    Выбор элемента списка
    на входе	:	m_iPlayer - номер плеера
			in_iSelect - номер выбранного элемента
    на выходе	:	*
*/
define_function fnCommandSelect(integer in_iSelect)
{
    char l_szRequest[MAX_REQUEST_LEN];
    integer i, tp
    
    // Проверка правильности выбора
    if(in_iSelect > 0 && in_iSelect <= MAX_ITEMS)
    {
	if(m_aPlayer.m_aItems[in_iSelect].m_cSelectable == 1)
	{
	    if(m_aPlayer.m_aItems[in_iSelect].m_sReq.m_szRequest == 'search items') {
		
		m_iSearchType = SEARCH_BY_RADIO
		
		for(tp = 1; tp <= MAX_PANELS; tp++) {
		    if(THIS_PanelIsOnline && g_iaPlayerInUse[tp]) {
			fnUpdateSearchParam(tp)
			Send_To_Panel, "'AKEYB-'"
			Send_To_Panel, "'@PPN-Squeeze_Search'"
		    }
		}
	    } else {
		// Сохраним текущий запрос
		fnPushStack();
		
		// Формирование запроса
		m_aPlayer.m_sReq.m_szRequest = "m_aPlayer.m_aItems[in_iSelect].m_sReq.m_szRequest"
		m_aPlayer.m_sReq.m_szParam = m_aPlayer.m_aItems[in_iSelect].m_sReq.m_szParam;
		
		l_szRequest = fnCreateRequest();
		
		// Постановка в очередь
		QueueCommand(l_szRequest);
	    }
	    
	} else {
	    if(	m_aPlayer.m_aItems[in_iSelect].m_cType == ITEM_TYPE_TRACK)
	    {
		QueueCommand("caPlayerID, ' playlistcontrol cmd:load ', 
				m_aPlayer.m_sReq.m_szParam, ' play_index:', 
				itoa(in_iSelect - 1)" )
		
		//запросим плейлист (лучше запрашивать по подписке на изменение плейлиста)
		fnRequestPlaylist()
	    } else
	    // Если перед нами плей лист или радио, запускаем воспроизведение
	    if(	m_aPlayer.m_aItems[in_iSelect].m_cType == ITEM_TYPE_SEARCH_TRACK ||
		m_aPlayer.m_aItems[in_iSelect].m_cType == ITEM_TYPE_PLAYLIST ||
		m_aPlayer.m_aItems[in_iSelect].m_cType == ITEM_TYPE_RADIO ||
		m_aPlayer.m_aItems[in_iSelect].m_cType == ITEM_TYPE_FAVORITES )
	    {
		fnCommandStart(in_iSelect);
	    } else
	    if(m_aPlayer.m_aItems[in_iSelect].m_cType == ITEM_TYPE_MIX)
	    {
		// Сохраним текущий запрос
		fnPushStack();
		
		// Очистка списка
		fnClearLibraryList();
		
		m_aPlayer.m_iItems = 4;
		
		fnInitLibraryList(m_aPlayer.m_iItems)
		
		// Заполнение списка		
		m_aPlayer.m_aItems[1].m_szName = 'РџСЂРѕРёР·РІРѕР»СЊРЅС‹Рµ РїРµСЃРЅРё';
		m_aPlayer.m_aItems[1].m_sReq.m_szRequest = "caPlayerID,' randomplay tracks'";
		m_aPlayer.m_aItems[1].m_cSelectable = 0;
		m_aPlayer.m_aItems[1].m_cAddable = 0;
		m_aPlayer.m_aItems[1].m_cType = ITEM_TYPE_RANDOM;
		
		m_aPlayer.m_aItems[2].m_szName = 'РџСЂРѕРёР·РІРѕР»СЊРЅС‹Рµ РёСЃРїРѕР»РЅРёС‚РµР»Рё';
		m_aPlayer.m_aItems[2].m_sReq.m_szRequest = "caPlayerID,' randomplay contributors'";
		m_aPlayer.m_aItems[2].m_cSelectable = 0;
		m_aPlayer.m_aItems[2].m_cAddable = 0;
		m_aPlayer.m_aItems[2].m_cType = ITEM_TYPE_RANDOM;

		m_aPlayer.m_aItems[3].m_szName = 'РџСЂРѕРёР·РІРѕР»СЊРЅС‹Рµ Р°Р»СЊР±РѕРјС‹';
		m_aPlayer.m_aItems[3].m_sReq.m_szRequest = "caPlayerID,' randomplay albums'";
		m_aPlayer.m_aItems[3].m_cSelectable = 0;
		m_aPlayer.m_aItems[3].m_cAddable = 0;
		m_aPlayer.m_aItems[3].m_cType = ITEM_TYPE_RANDOM;

		m_aPlayer.m_aItems[4].m_szName = 'РџСЂРѕРёР·РІРѕР»СЊРЅС‹Рµ РіРѕРґС‹';
		m_aPlayer.m_aItems[4].m_sReq.m_szRequest = "caPlayerID,' randomplay year'";
		m_aPlayer.m_aItems[4].m_cSelectable = 0;
		m_aPlayer.m_aItems[4].m_cAddable = 0;
		m_aPlayer.m_aItems[4].m_cType = ITEM_TYPE_RANDOM;
		
		fnSendLibraryListToDevice(1, SubItem_1, m_aPlayer.m_aItems[1].m_szName)
		fnSendLibraryListToDevice(2, SubItem_1, m_aPlayer.m_aItems[2].m_szName)
		fnSendLibraryListToDevice(3, SubItem_1, m_aPlayer.m_aItems[3].m_szName)
		fnSendLibraryListToDevice(4, SubItem_1, m_aPlayer.m_aItems[4].m_szName)
		
	    } else 
	    if(m_aPlayer.m_aItems[in_iSelect].m_cType == ITEM_TYPE_RANDOM)
	    {
		// Постановка в очередь
		QueueCommand(m_aPlayer.m_aItems[in_iSelect].m_sReq.m_szRequest);
		// Перечитаем плейлист
		fnRequestPlaylist()
	    }
	}
    }
}

/**
    Добавление элемента списка
    на входе	:	m_iPlayer - номер плеера
			in_iSelect - номер выбранного элемента
    на выходе	:	*
*/
define_function fnCommandAdd(integer in_iSelect)
{
    char l_szRequest[MAX_REQUEST_LEN];
    char l_szParam[64];
	
    // Проверка правильности выбора
    if(in_iSelect > 0 && in_iSelect <= MAX_ITEMS && m_aPlayer.m_aItems[in_iSelect].m_cAddable == 1)
    {
	if(m_aPlayer.m_aItems[in_iSelect].m_cAddable == 1)
	{
	    l_szRequest = "caPlayerID, ' playlistcontrol cmd:add '"
	    select
	    {
		active(m_aPlayer.m_aItems[in_iSelect].m_cType == ITEM_TYPE_TRACK):
		    l_szRequest = "l_szRequest, 'sort:lt track_id:', m_aPlayer.m_aItems[in_iSelect].m_szID"
		active(m_aPlayer.m_aItems[in_iSelect].m_cType == ITEM_TYPE_SEARCH_TRACK):
		    l_szRequest = "l_szRequest, 'track_id:', m_aPlayer.m_aItems[in_iSelect].m_szID"
		active(m_aPlayer.m_aItems[in_iSelect].m_cType == ITEM_TYPE_ALBUM):
		    l_szRequest = "l_szRequest, 'album_id:', m_aPlayer.m_aItems[in_iSelect].m_szID"
		active(m_aPlayer.m_aItems[in_iSelect].m_cType == ITEM_TYPE_ARTIST):
		    l_szRequest = "l_szRequest, 'artist_id:', m_aPlayer.m_aItems[in_iSelect].m_szID"
		active(m_aPlayer.m_aItems[in_iSelect].m_cType == ITEM_TYPE_GENRE):
		    l_szRequest = "l_szRequest, 'genre_id:', m_aPlayer.m_aItems[in_iSelect].m_szID"
		active(m_aPlayer.m_aItems[in_iSelect].m_cType == ITEM_TYPE_PLAYLIST):
		    l_szRequest = "l_szRequest, 'playlist_id:', m_aPlayer.m_aItems[in_iSelect].m_szID"
		active(m_aPlayer.m_aItems[in_iSelect].m_cType == ITEM_TYPE_RADIO):
		    l_szRequest = "caPlayerID, ' ', m_aPlayer.m_aItems[in_iSelect].m_sReq.m_szRequest,' item_id:', m_aPlayer.m_aItems[in_iSelect].m_szID"
		active(m_aPlayer.m_aItems[in_iSelect].m_cType == ITEM_TYPE_FAVORITES):
		    l_szRequest = "m_aPlayer.m_aItems[in_iSelect].m_sReq.m_szRequest,' item_id:', m_aPlayer.m_aItems[in_iSelect].m_szID"
		active(m_aPlayer.m_aItems[in_iSelect].m_cType == ITEM_TYPE_FOLDER):
		    l_szRequest = "l_szRequest, 'folder_id:', m_aPlayer.m_aItems[in_iSelect].m_szID"
		    
	    }
	}
	// Постановка в очередь
	QueueCommand(l_szRequest);
	debug("'::fnCommandAdd::', l_szRequest")
	// Перечитаем плейлист
	fnRequestPlaylist();
	
	// Если сейчас ничего не воспроизводится запустим воспроизведение
	if(m_aPlayer.m_iState != PLAYER_STATUS_PLAY)
	    fnCommandPlay();
    }
}

/**
    Добавление элемента списка в текущий плейлист (PlayNext)
    на входе	:	m_iPlayer - номер плеера
			in_iSelect - номер выбранного элемента
    на выходе	:	*
*/
define_function fnCommandInsert(integer in_iSelect)
{
    char l_szRequest[MAX_REQUEST_LEN];
    char l_szParam[64];
	
    // Проверка правильности выбора
    if(in_iSelect > 0 && in_iSelect <= MAX_ITEMS && m_aPlayer.m_aItems[in_iSelect].m_cAddable == 1)
    {
	if(m_aPlayer.m_aItems[in_iSelect].m_cAddable == 1)
	{
	    l_szRequest = "caPlayerID, ' playlistcontrol cmd:insert '"
	    select
	    {
		active(m_aPlayer.m_aItems[in_iSelect].m_cType == ITEM_TYPE_TRACK):
		    l_szRequest = "l_szRequest, 'track_id:', m_aPlayer.m_aItems[in_iSelect].m_szID"
		active(m_aPlayer.m_aItems[in_iSelect].m_cType == ITEM_TYPE_SEARCH_TRACK):
		    l_szRequest = "l_szRequest, 'track_id:', m_aPlayer.m_aItems[in_iSelect].m_szID"
		active(m_aPlayer.m_aItems[in_iSelect].m_cType == ITEM_TYPE_ALBUM):
		    l_szRequest = "l_szRequest, 'album_id:', m_aPlayer.m_aItems[in_iSelect].m_szID"
		active(m_aPlayer.m_aItems[in_iSelect].m_cType == ITEM_TYPE_ARTIST):
		    l_szRequest = "l_szRequest, 'artist_id:', m_aPlayer.m_aItems[in_iSelect].m_szID"
		active(m_aPlayer.m_aItems[in_iSelect].m_cType == ITEM_TYPE_GENRE):
		    l_szRequest = "l_szRequest, 'genre_id:', m_aPlayer.m_aItems[in_iSelect].m_szID"
		active(m_aPlayer.m_aItems[in_iSelect].m_cType == ITEM_TYPE_PLAYLIST):
		    l_szRequest = "l_szRequest, 'playlist_id:', m_aPlayer.m_aItems[in_iSelect].m_szID"
		active(m_aPlayer.m_aItems[in_iSelect].m_cType == ITEM_TYPE_RADIO):
		    l_szRequest = "caPlayerID, ' ', m_aPlayer.m_aItems[in_iSelect].m_sReq.m_szRequest,' item_id:', m_aPlayer.m_aItems[in_iSelect].m_szID"
		active(m_aPlayer.m_aItems[in_iSelect].m_cType == ITEM_TYPE_FAVORITES):
		    l_szRequest = "m_aPlayer.m_aItems[in_iSelect].m_sReq.m_szRequest,' item_id:', m_aPlayer.m_aItems[in_iSelect].m_szID"
		active(m_aPlayer.m_aItems[in_iSelect].m_cType == ITEM_TYPE_FOLDER):
		    l_szRequest = "l_szRequest, 'folder_id:', m_aPlayer.m_aItems[in_iSelect].m_szID"
		    
	    }
	}
	// Постановка в очередь
	QueueCommand(l_szRequest);
	// Перечитаем плейлист
	fnRequestPlaylist();
	
	// Если сейчас ничего не воспроизводится запустим воспроизведение
	if(m_aPlayer.m_iState != PLAYER_STATUS_PLAY)
	    fnCommandPlay();
    }
}

/**
    Запуск воспроизведения списка
    на входе	:	m_iPlayer - номер плеера
    на выходе	:	*
*/
define_function fnCommandPlay()
{
    QueueCommand("caPlayerID, ' play 2'")
}


define_function fnCommandRepeat()
{
    stack_var integer l_iRepeat
    
    l_iRepeat = m_aPlayer.m_iRepeat

    l_iRepeat++
    
    if(l_iRepeat >= 3)
	l_iRepeat = 0
    
    QueueCommand("m_aPlayer.m_caID, ' playlist repeat ', itoa(l_iRepeat)")
}

define_function fnCommandShuffle()
{
    stack_var integer l_iShuffle
    
    l_iShuffle = m_aPlayer.m_iShuffle

    l_iShuffle++
    
    if(l_iShuffle >= 3)
	l_iShuffle = 0
    
    QueueCommand("m_aPlayer.m_caID, ' playlist shuffle ', itoa(l_iShuffle)")
}
/**
    Очистка списка воспроизведения
    на входе	:	m_iPlayer - номер плеера
    на выходе	:	*
*/
define_function fnCommandClear()
{
    QueueCommand("caPlayerID, ' playlist clear'")
    fnClearPlaylistList();
    m_aPlayer.m_iCurrent = $FFFF;
    fnRequestPlaylist();
}

/**
    Добавление элемента списка
    на входе	:	m_iPlayer - номер плеера
			in_iSelect - номер выбранного элемента
    на выходе	:	*
*/
define_function fnCommandStart(integer in_iSelect)
{
    char l_szRequest[MAX_REQUEST_LEN];
	
    // Проверка правильности выбора
    if(in_iSelect > 0 && in_iSelect <= MAX_ITEMS && m_aPlayer.m_aItems[in_iSelect].m_cAddable == 1)
    {
	// Очистка списка
	fnCommandClear();
	fnCommandAdd(in_iSelect);
	fnCommandPlay();
    }
}


/**
    Переход назад
    на входе	:	m_iPlayer - номер плеера
    на выходе	:	*
*/
define_function fnCommandBack()
{
    char l_szRequest[MAX_REQUEST_LEN];
	
    // Получение предедущего запроса
    fnPopStack();
    
    if(length_array(m_aPlayer.m_sReq.m_szRequest))
    {
	// Формирование запроса и постановка в очередь
	l_szRequest = fnCreateRequest();
	QueueCommand(l_szRequest);
    } else {
	fnCommandInitMediaLibrary();
    }
}

/**
    Начало использования плеера
    на входе	: m_iPlayer - номер плеера
    на выходе	: *
*/
define_function fnCommandUse()
{
    // Проверка номера плеера
    CHECK_Player
    {
	m_aPlayer.m_cUse++;
	fnCommandInitPlaylist();
    }
}

/**
    Остановка использования плеера
    на входе	: m_iPlayer - номер плеера
    на выходе	: *
*/
define_function fnCommandUnuse()
{
    // Проверка номера плеера
    CHECK_Player
    {
	if(m_aPlayer.m_cUse)
	    m_aPlayer.m_cUse--;
    }
}

/**
    Выбор элемента в списке воспроизведения
    на входе	: m_iPlayer - номер плеера
    на выходе	: *
*/
define_function fnCommandList(integer in_iSelect)
{
    stack_var integer idx;
    
    // Проверка номера плеера
    CHECK_Player
    {
	// Вычисление индекса и отправка команды на устройство
	idx = in_iSelect;
	if(idx && idx <= m_aPlayer.m_iPLItems)
	    QueueCommand("caPlayerID, ' playlist index ', itoa(idx - 1)");
    }
}

/**
    Установка времени выбранного трека
    на входе	: m_iPlayer - номер плеера
		  in_iTime - уставка времени
    на выходе	: *
*/
define_function fnCommandSeek(integer in_iTime)
{
    QueueCommand("caPlayerID, ' time ', in_iTime");
}

/**
    Обработка команды приходящих на виртуальный порт
    на входе	: in_caCommand	- указатель на команду
    на выходе	: *
*/
define_function fnOnCommand(char in_caCommand[])
{
    stack_var 
     integer a, v, l_iCount
     char d, c, l_bRun
     integer l_iaTemp[256]
     integer l_iaValue[256]
     char l_caOut[MAX_CODEC_STRING]
     integer vol, a1, a2
    
    // проверка наличия команды соединения
    if(find_string(in_caCommand, 'CONNECT', 1) == 1)
    {
	//  запуск потока для поддержания соединения
	timeline_create(TL_WORK_ID, m_laWork, 1, TIMELINE_ABSOLUTE, TIMELINE_REPEAT)
	send_string vdvDevice, "'CONNECT'"
	
    } else if(find_string(in_caCommand, 'DISCONNECT', 1) == 1)
    {
	// остановка потока для поддержания соединения
	timeline_kill(TL_WORK_ID);
	fnOnDisconnect(dvPhysicalDevice)
	send_string vdvDevice, "'DISCONNECT'"
    
    // громкость звука
    } else if(find_string(in_caCommand, 'VOLUME=', 1) == 1)
    {
	remove_string(in_caCommand, '=', 1)
	select
	{
	    active(in_caCommand == '?'):
	    {
		QueueCommand("'mixer volume ?'");
	    }
	    active(in_caCommand == 'UP'):
	    {
	    }
	    active(in_caCommand == 'DOWN'):
	    {
	    }
	    active(1):
	    {
		vol = atoi(in_caCommand)
		if(vol > 100)
		    vol = 100
		QueueCommand("'mixer volume ',itoa(vol)");
	    }
	}
    } else
    {
	// Отладочная информация
	debug(in_caCommand)
	
	QueueCommand("in_caCommand");
    }
}

/**
    Обработка поддержания соединения с контроллером
    на входе	: *
    на выходе	: *
*/
define_function fnOnWork()
{
    stack_var long l_lTime
    
    if(m_iIsConnect == 0)
    {
	// обработка 
	l_lTime = m_lCurTime - m_lStartWaitTime
	if(l_lTime > 3000)
	{
	    send_command vdvDevice, "'fnOnConnect(', caHost, ',', itoa(iPort), ')'"
	    fnOnConnect(dvPhysicalDevice, caHost, iPort)
	    
	    m_iIsConnect = 2
	    m_lStartWaitTime = m_lCurTime
	}
    } else if(m_iIsConnect == 1)
    {
	l_lTime = m_lCurTime - m_lLastPingTime
	if(l_lTime > 8000)
	{
	    fnOnDisconnect(dvPhysicalDevice)
	    send_string vdvDevice, "'TIMEOUT'"
	}
    } else if(m_iIsConnect == 2)
    {
	// обработка 
	l_lTime = m_lCurTime - m_lStartWaitTime
	if(l_lTime > 5000)
	{
	    send_command vdvDevice, "'TIMEOUT WAIT CONNECT'"
	    m_iIsConnect = 0
	    m_lStartWaitTime = m_lCurTime
	}
    }
}


define_function fnProcessPanelButtonsControl(integer tp)
{
    
    if(THIS_Btn >= 1 && THIS_Btn <= 500) {
	
	switch(THIS_Push)
	{
	    case _push:		{
				    switch(THIS_Btn)
				    {
					case 1: fnCommandPlay()
					case 2: QueueCommand("caPlayerID, ' stop'")
					case 3: QueueCommand("m_aPlayer.m_caID, ' pause'")
					case 4: QueueCommand("m_aPlayer.m_caID, ' button jump_fwd'")
					case 5: QueueCommand("m_aPlayer.m_caID, ' button jump_rew'")
					case 51: 
					case 52: 
					case 53: 
					case 54: 
					case 55: {
					    m_iSearchType = THIS_Btn - 50
					    fnUpdateSearchParam(tp)
					}
					case 110: fnCommandClear() //Back
					case 111: fnCommandBack() //Back
					case 112: fnCommandInitMediaLibrary() // Root
					case 113: fnCommandInitMediaLibrary() // Show Music Library
					case 123: fnCommandRepeat() // 
					case 124: fnCommandShuffle() // 
					case 142: fnSelectPlayer(tp, 1)
					case 143: fnSelectPlayer(tp, 0)
				    }
				}
	    case _release:	{
				    switch(THIS_Btn)
				    {
					case 222: fnCommandAdd(THIS_LevelValue - m_iScrollLibraryIndex)//add
					case 223: fnCommandStart(THIS_LevelValue - m_iScrollLibraryIndex)//play now
					case 224: fnCommandInsert(THIS_LevelValue - m_iScrollLibraryIndex)//play next
				    }
				}
	    case _hold:		{
				
				}
	}
    } else
    if(THIS_Btn == 501) {
	if(_release) {
	
	}
    }
}

/*
    Вывод отладочной информации
*/
define_function debug(char in_caData[])
{
    if(_debug)
	send_string 0, in_caData
}
define_function vdebug(char in_caData[])
{
    if(_debug)
	send_string vdvDevice, in_caData
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
			send_string 0,"'Squeeze Debug: # ',mid_string(dbgmsg,pCursor,block)";
		    active((pCursor+block) <= lenpacket):
			send_string 0,"'               - ',mid_string(dbgmsg,pCursor,block)";
		    active((pCursor+block) > lenpacket):
		    {
			integer bytesleft;
			bytesleft = lenpacket-pCursor+1;
			send_string 0,"'       - ',right_string(dbgmsg,bytesleft)";
		    }
		}
	    }
	}
	else
	{
	    send_string 0,"'Squeeze Debug: ',dbgmsg";
	}
    }
}

(***********************************************************)
(*                STARTUP CODE GOES BELOW                  *)
(***********************************************************)
DEFINE_START

m_aPlayer.m_caID = caPlayerID
(***********************************************************)
(*                THE EVENTS GO BELOW                      *)
(***********************************************************)
DEFINE_EVENT

TIMELINE_EVENT [TL_WaitResponce]												// 
{
    nDeviceBusy = FALSE
}
/*
timeline_event[TL_Queue_ID]
{
    if(QueueHasItems) 
	QueueCounter++
    else
	QueueCounter = 0
    //timeout clear timer
    if(QueueCounter == 30) {
	OFF[QueueHasItems]
	QueueCounter = 0
    }
    
    if(length_string(Queue_Buffer))
    {
	stack_var char cmd[max_request_len]
	
	if(!QueueHasItems) {
	    cmd = remove_string(Queue_Buffer, LT, 1)
	    send_string dvPhysicalDevice, cmd
	    ON[QueueHasItems]
	}
    }
}
*/
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
DATA_EVENT[dvPhysicalDevice]
{
    // включение устройства
    ONLINE:
    {
	// Отладочная информация
	debug("'online'")
	
	// инициализация соединения
	fnOnInit()
	
	// соединение установлено
	m_iIsConnect = 1
	// отправим подтверждение отправки данных
	send_string vdvDevice, "'CONNECT'"
    }
    
    // отключение устройства
    OFFLINE:
    {
	// Отладочная информация
	debug("'offline'")
	
	// инициализация соединения
	fnOnDeInit()
	
	// соединение прервано
	m_iIsConnect = 0
	
	// отправим подтверждение отправки данных
	send_string vdvDevice, "'DISCONNECT'"
    }
    
    // Получение стринга
    STRING:
    {
	stack_var char sPacket[MAX_RESP_LEN];
    
	cancel_wait 'SlimServer_InputTimer';
    
	sPacket = remove_string(SlimServer_Buffer, LT, 1);
	
	while(length_array(sPacket))
	{
	    fnOnReceive(sPacket);
	    sPacket = remove_string(SlimServer_Buffer, LT, 1);
	}
    
	// Handle any "leftovers" in the buffer
	if(length_array(SlimServer_Buffer))
	{
	    Wait 5 'SlimServer_InputTimer'
	    {
		clear_buffer SlimServer_Buffer;
	    }
	}
    }
    
    // обработка ошибки
    ONERROR:
    {
	// Отладочная информация
	debug("'Squeeze physical port error'")
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
	stack_var char caCommand[256]
	
	// перевод в верхний регистр
	//fnStr_ToUpper(data.text)
	
	// отладочная информация
	debug(data.text)

	// выполнять пока есть команды
	while(fnStr_GetStringWhile(data.text, caCommand, $3B))
	{
	    // обработка команды
	    fnOnCommand(caCommand)
    
	    // удаление обработаной команды
	    remove_string(data.text, "$3B", 1)
	}
    }
}


/**
    Обработчик событий панели
*/
data_event[dvPanels]
{
    online:
    {
	stack_var integer tp
	
	tp = get_last(dvPanels)
	
	THIS_PanelIsOnline = 1
	
	// Востановление предедущего плеера
	fnSelectPlayer(tp, g_iaOldPlayerInUse[get_last(dvPanels)]);
	fnUpdateSearchParam(tp)
    }
    offline:
    {
	stack_var integer tp
	
	tp = get_last(dvPanels)
	
	THIS_PanelIsOnline = 0
	
	// Сохранение управлялся ли плеер
	g_iaOldPlayerInUse[tp] = g_iaPlayerInUse[tp];
	// Сброс плеера
	fnSelectPlayer(tp, 0);
    }
}

data_event[dvSearchPanels]
{
    string:
    {
	stack_var 
	    char l_caTempData[100]
	    char l_caSearch[100]
	    integer tp
	
	tp = get_last(dvSearchPanels)
	
	l_caSearch = data.text
	l_caTempData = remove_string(l_caSearch, 'Search-', 1)
	
	//Unicode Search
	if(iSearchEncoding)
	    fnSearch(tp, l_caSearch);
	
	//Win 1251 Search
	else
	    fnSearch(tp, ConvertUTF8ToCP1251(l_caSearch));
	
	
	Send_To_Panel, '@PPF-Squeeze_Search'
    }
}

button_event[dvPanels, 0]
{
    push:
    {
	stack_var integer tp
	
	tp = get_last(dvPanels)
	THIS_Btn 	= button.input.channel
	THIS_Push 	= _push
	THIS_HoldTime	= 0
	THIS_HoldCount 	= 0
	
	fnProcessPanelButtonsControl(tp)
    }
    release:
    {
	stack_var integer tp
	
	tp = get_last(dvPanels)
	THIS_Btn = button.input.channel
	THIS_Push = _release
	
	if(THIS_LongPush) {
	    THIS_LongPush = 0
	} 
	
	fnProcessPanelButtonsControl(tp)
    }
    hold[3, repeat]:
    {
	stack_var integer tp
	
	tp = get_last(dvPanels)
	
	THIS_Btn = button.input.channel
	
	//if(THIS_HoldCount == 3)
	    THIS_Push = _hold
	
	if(THIS_HoldCount >= 3)
	    THIS_LongPush = 1
	
	// if count >= 20 --> Mega_Hold :))
	
	THIS_HoldTime = button.holdtime
	THIS_HoldCount ++
	
	//fnProcessPanelButtonsControl(tp)
    }
}


level_event[dvPanels, TP_PlayList]
{
    stack_var long l_iLevel
    l_iLevel = level.value
    if(l_iLevel >= m_iScrollPlaylistIndex && l_iLevel <= (m_iScrollPlaylistIndex + MAX_PL_ITEMS)) {
	fnCommandList(level.value - m_iScrollPlaylistIndex)
    }

    send_level dvPanels[get_last(dvPanels)], TP_LibraryList, 65565
}


level_event[dvPanels, TP_LibraryList]
{
    stack_var
	integer l_iLevel, tp
	integer l_iValue
	
    l_iLevel = level.input.level
    l_iValue = level.value
    tp = get_last(dvPanels)
    
    if(l_iValue >  m_iScrollLibraryIndex && l_iValue < 10000) {
	THIS_Level = l_iLevel
	THIS_LevelValue = l_iValue
    }
    
    //if(l_iValue >= m_iScrollLibraryIndex && l_iLevel <= (m_iScrollLibraryIndex + MAX_ITEMS)) {
	//fnCommandSelect(level.value - m_iScrollLibraryIndex)
    //}

    //send_level dvPanels[get_last(dvPanels)], TP_LibraryList, 65565
}

level_event[dvPanels, TP_LibraryList + 1]
{
    stack_var
	integer l_iLevel, tp
	integer l_iValue
    
    l_iLevel = level.input.level
    l_iValue = level.value
    tp = get_last(dvPanels)
    
    select
    {
	active(l_iValue == 1):
	{
	    if(THIS_LevelValue >= m_iScrollLibraryIndex && THIS_LevelValue <= (m_iScrollLibraryIndex + MAX_ITEMS)) {
		fnCommandSelect(THIS_LevelValue - m_iScrollLibraryIndex)
	    }
	}
	active(l_iValue == 2):
	{
	    if(m_aPlayer.m_iStackIndex)
		Send_To_Panel, '@PPN-Squeeze_PlayOptions'
	    else
		if(THIS_LevelValue >= m_iScrollLibraryIndex && THIS_LevelValue <= (m_iScrollLibraryIndex + MAX_ITEMS))
		    fnCommandSelect(THIS_LevelValue - m_iScrollLibraryIndex)
	}
    }
    
    send_level dvPanels[get_last(dvPanels)], TP_LibraryList, 65565
    send_level dvPanels[get_last(dvPanels)], l_iLevel, 65565
}

channel_event[vdvDevice, 255]
{
    on:	{
	stack_var integer tp
	
	for(tp = 1; tp <= MAX_PANELS; tp++)
	    if(THIS_PanelIsOnline && g_iaPlayerInUse[tp])
		Send_To_Panel, "'^SHO-255,1'"
    }
    off: {
	stack_var integer tp
	
	for(tp = 1; tp <= MAX_PANELS; tp++)
	    if(THIS_PanelIsOnline && g_iaPlayerInUse[tp])
		Send_To_Panel, "'^SHO-255,0'"
    }
}

button_event[vdvDevice, 255]
{
    push:	{
	stack_var integer tp
	
	for(tp = 1; tp <= MAX_PANELS; tp++)
	    if(THIS_PanelIsOnline && g_iaPlayerInUse[tp])
		Send_To_Panel, "'^SHO-255,1'"
    }
    release: {
	stack_var integer tp
	
	for(tp = 1; tp <= MAX_PANELS; tp++)
	    if(THIS_PanelIsOnline && g_iaPlayerInUse[tp])
		Send_To_Panel, "'^SHO-255,0'"
    }
}

(***********************************************************)
(*            THE ACTUAL PROGRAM GOES BELOW                *)
(***********************************************************)
DEFINE_PROGRAM



m_cBusy = (nDeviceBusy || length_array(sLastCommand) <> 0);

if(m_cBusy != m_cOldBusy)
{
    if(m_cBusy == 0)
	off [vdvDevice, 255]
    else
	on  [vdvDevice, 255]
    
    m_cOldBusy = m_cBusy;
}

(***********************************************************)
(*                     END OF PROGRAM                      *)
(*        DO NOT PUT ANY CODE BELOW THIS COMMENT           *)
(***********************************************************)

