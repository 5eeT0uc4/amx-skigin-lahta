PROGRAM_NAME='Lahta_1'

(***********************************************************)
(*
	79.134.195.218
	79.134.195.218
	NX-1200
	administrator
	password
	
	Atlona
	    OUT:					IN:
	    1 - Oriental Sigar (TV Control IR)		1 - DF1
	    2 - Bedroom (TV Control IR, RS-232 Linn)	2 - DF2
	    3 - Bathroom (TV Control IR)		3 - DF3
	    4 - Guest 1 (TV Control IR)		        4 - Sonix 1
	    5 - Guest 2 (TV Control IR)		        5 - Sonix 2
	    6 - Playroom 				6 - Sonix 3
	    7 - Kitchen (TV Control IR)			7 - Dune 1
	    8 - Anna Living (TV Control IR)		8 - Dune 2
	    9 - Cinema					9 - Dune 3
	    10 - Dining (TV Control IR) 		10 - Apple TV 2
	    11 - Salon 					11 - Apple TV
	    12 - Billiards (TV Control IR)		12 - 
	    13 - Fitness (TV Control IR)		13 - 
	    14 - Gena House				14 - Remote Server
	    15 - 					15 - SAT 1
	    16 - Server PC				16 - SAT 2
	    
	    //вход на Атлоне в зависимости от выбранного источника
	    persistent char	g_caAtlonaInputs[MAX_SOURCES][2] = {'','15','16','7','8','9','10','1','2','3','','','','','','','','','',''/*20*/,'','','','','','','','','','','','','','','','','','','','11'}

	    volatile char		g_caAtlonaZones[][2]	= { '7','10','','','9',
						    '11','1','14','13','',
						    '','2','3','','6',
						    '8','','4','5','12','' }
						    
	    TO DO
	    1. Кнопка управления подсветкой в курительной + RGB
	    2. Управление с кнопок Лутрон
	    3. Медиасервера
	    4. Управление Madboy
	    5. Анина комната
	    6. Salon
	    7. Перераспределить радио тюнеры
	    
	Распределение потоков аудио-сервера (источники с 11 по 19)
	1 \
	2 --> Холл, кухня, столовая, гостиная, бассейн, трен. зал, массажная, восточная, бильярд, кабинет 
	3 /
	4 -> Кинозал
	5 -> Спальня, Ванная
	6 -> Аня
	7 -> Робик + игровая
	8 -> Гостевая 1
	9 -> Гостевая 2
	
	Распределение Радио тюнеров (источники с 20 по 25)
	1 -> Спальня, Ванная
	2 -> Кино, кабинет
	3 -> Аня, Бильярдная, 
	4 -> Бассейн, Трен зал, Массаж, Восточная
	5 -> Гостева 1,2
	6 -> Кухня, Холл, Столов, Ярд
	
	

*)
(***********************************************************)

/*

level_event[<device>,<level>]
{
if (device_id(level.input.device)) // only if the device is online
{
// do stuff
}
}
CREATE_LEVEL
DEFINE_CONNECT_LEVEL
COMBINE_LEVELS

*/
//custom_event

//#include 'UnicodeLib.axi'
#include 'Strings.axi'
#include 'gc_ir_db.axi'
//#include 'ConvertUTF8.axi'
#include 'cp1251.axi'
//#include 'SqueezeBox.axi'
//#include 'iPort_Variables.axi'

DEFINE_DEVICE

dvDebug				= 0:0:0

//Panels
dvPanel_1			= 10001:1:1 // iPad Hall 1-st Floor
dvPanel_2			= 10002:1:1 // iPad Hall 2-nd Floor
dvPanel_3			= 10003:1:1 // Skigin iPhone6 1
dvPanel_4			= 10004:1:1 // Skigin iPhone6 2
dvPanel_5			= 10005:1:1 // 
dvPanel_6			= 10006:1:1 // 
dvPanel_7			= 10007:1:1 // Gena iPhone
dvPanel_8			= 10008:1:1 // Gena iPad
dvPanel_9			= 10009:1:1 // 
dvPanel_10			= 10010:1:1 // 
dvPanel_11			= 10011:1:1 // 
dvPanel_12			= 10012:1:1 // iPad Mini Black
dvPanel_13			= 10013:1:1 // 
dvPanel_14			= 10014:1:1 // iPad2 Home White 
dvPanel_15			= 10015:1:1 // iPad Mini 1
dvPanel_16			= 10016:1:1 // iPad Mini 2
dvPanel_17			= 10017:1:1 // iPhone6+ Janna
dvPanel_18			= 10018:1:1 // iPhone6s+ iRina
dvPanel_19			= 10019:1:1 // 
dvPanel_20			= 10020:1:1 // 

//Mixer Yamaha Panels


//
/*
dvYamhaRcv_Panel_1		= 10001:3:1
dvYamhaRcv_Panel_2		= 10002:3:1
dvYamhaRcv_Panel_3		= 10003:3:1
dvYamhaRcv_Panel_4		= 10004:3:1
dvYamhaRcv_Panel_5		= 10005:3:1
dvYamhaRcv_Panel_6		= 10006:3:1
dvYamhaRcv_Panel_7		= 10007:3:1
dvYamhaRcv_Panel_8		= 10008:3:1
dvYamhaRcv_Panel_9		= 10009:3:1
dvYamhaRcv_Panel_10		= 10010:3:1
dvYamhaRcv_Panel_11		= 10011:3:1
dvYamhaRcv_Panel_12		= 10012:3:1
dvYamhaRcv_Panel_13		= 10013:3:1
dvYamhaRcv_Panel_14		= 10014:3:1
dvYamhaRcv_Panel_15		= 10015:3:1
dvYamhaRcv_Panel_16		= 10016:3:1
dvYamhaRcv_Panel_17		= 10017:3:1
dvYamhaRcv_Panel_18		= 10018:3:1
dvYamhaRcv_Panel_19		= 10019:3:1
dvYamhaRcv_Panel_20		= 10020:3:1
*/
//Lutron Processors 8-Series
dvLutron_H8P5_1			= 0:3:0 //пока не работает
dvLutron_H8P5_2			= 0:4:0 //коммуникация

//DH Multiroom Controller
dvMultiroom			= 0:5:0

//Dune Devices
dvDuneHD_1			= 0:6:0
dvDuneHD_2			= 0:7:0
dvDuneHD_3			= 0:8:0
dvDuneHD_4			= 0:9:0

//GlobalCache Devices
dvGC_IP2IR_1			= 0:10:0
dvGC_IP2IR_2			= 0:11:0
dvGC_IP2IR_3			= 0:12:0
dvGC_IP2IR_4			= 0:13:0
dvGC_IP2IR_5			= 0:14:0
dvGC_IP2IR_6			= 0:15:0
dvGC_IP2IR_7			= 0:16:0
dvGC_IP2IR_8			= 0:17:0
dvGC_IP2IR_9			= 0:18:0
dvGC_IP2IR_10			= 0:19:0
dvGC_IP2IR_11			= 0:20:0
dvGC_IP2IR_12			= 0:21:0

//Moxa n-Port Devices
//dvMoxa_nPort5210_1_1		= 0:28:0
//dvMoxa_nPort5210_2_1		= 0:29:0
//dvMoxa_nPort5210_3_1		= 0:30:0
//dvMoxa_nPort5210_4_1		= 0:31:0
//dvMoxa_nPort5210_5_1		= 0:32:0
dvMoxa_nPort5210_6_1		= 0:22:0
//dvMoxa_nPort5210_7_1		= 0:34:0
//dvMoxa_nPort5210_8_1		= 0:35:0

//UDP Test
dvUDP				= 0:23:0
//
/*
dvMoxa_nPort5210_1_2		= 0:42:0
dvMoxa_nPort5210_2_2		= 0:43:0
dvMoxa_nPort5210_3_2		= 0:44:0
dvMoxa_nPort5210_4_2		= 0:45:0
dvMoxa_nPort5210_5_2		= 0:46:0
dvMoxa_nPort5210_6_2		= 0:47:0
dvMoxa_nPort5210_7_2		= 0:48:0
dvMoxa_nPort5210_8_2		= 0:49:0
*/
//
dvProjector			= 0:24:0
dvYamaha_Cinema			= 0:25:0
dvYamaha_Oriental		= 0:26:0
//
dvUPS_Server			= 0:27:0
dvAPC_Karaoke			= 0:28:0
//
SNMP_UDP			= 0:29:0
dvYamaha_Master			= 0:76:0

dvYamaha_Bathroom		= 0:77:0
dvYamaha_Hall			= 0:78:0
dvYamaha_Pool			= 0:79:0
dvYamaha_Fitness		= 0:80:0
dvYamaha_Kitchen		= 0:81:0
dvYamaha_Cinema_2			= 0:82:0
dvYamaha_Yard			= 0:83:0

// next 0:83:0
 

//Master Controllers
dvM1_IR_1			= 5001:11:1 // SAT 1
dvM1_IR_2			= 5001:12:1 // Apple TV

dvM1_RS_1			= 5001:2:1 // Atlona AT-PRO2HD1616
//dvM1_RS_2			= 5001:2:3 // 

dvM2_IR_1			= 5001:3:2 // SAT 2
//dvM2_RS_1			= 5001:1:2 // Daikin
//dvM2_RS_2			= 5001:2:2 // Xenta

(***VIRTUAL****)
#if_not_defined vdvLutron_1    vdvLutron_1			= 33001:1:1 #end_if// Doesnt work, LAN broken
#if_not_defined vdvLutron_2    vdvLutron_2			= 33002:1:1 #end_if// Main Commenication

//DH Multiroom
vdvMultiroom			= 33003:1:1


//Dune HDTV-301
vdvDune_1			= 33004:1:1
vdvDune_2			= 33005:1:1
vdvDune_3			= 33006:1:1
vdvDune_4			= 33007:1:1

//Satellite
vdvSAT_1			= 33008:1:1
vdvSAT_2			= 33009:1:1

//Linn Unidisk + Classik Movie


//GlobalCache
vdvGC_1_1			= 33010:1:1
vdvGC_1_2			= 33010:2:1
vdvGC_1_3			= 33010:3:1

vdvGC_2_1			= 33011:1:1
vdvGC_2_2			= 33011:2:1
vdvGC_2_3			= 33011:3:1

vdvGC_3_1			= 33012:1:1
vdvGC_3_2			= 33012:2:1
vdvGC_3_3			= 33012:3:1

vdvGC_4_1			= 33013:1:1
vdvGC_4_2			= 33013:2:1
vdvGC_4_3			= 33013:3:1

vdvGC_5_1			= 33014:1:1
vdvGC_5_2			= 33014:2:1
vdvGC_5_3			= 33014:3:1

vdvGC_6_1			= 33015:1:1
vdvGC_6_2			= 33015:2:1
vdvGC_6_3			= 33015:3:1

vdvGC_7_1			= 33016:1:1
vdvGC_7_2			= 33016:2:1
vdvGC_7_3			= 33016:3:1

vdvGC_8_1			= 33017:1:1
vdvGC_8_2			= 33017:2:1
vdvGC_8_3			= 33017:3:1

vdvGC_9_1			= 33018:1:1
vdvGC_9_2			= 33018:2:1
vdvGC_9_3			= 33018:3:1

vdvGC_10_1			= 33019:1:1
vdvGC_10_2			= 33019:2:1
vdvGC_10_3			= 33019:3:1

//Projector
vdvProjector			= 33020:1:1

//TV Sony
vdvTV_Cinema			= 33021:1:1
vdvTV_Kitchen			= 33022:1:1
vdvTV_Dining			= 33023:1:1
vdvTV_Lounge			= 33024:1:1
vdvTV_Sigar			= 33025:1:1
vdvTV_Gym			= 33026:1:1
vdvTV_Pool			= 33027:1:1
vdvTV_Master_Bedroom		= 33028:1:1
vdvTV_Master_Bathroom		= 33029:1:1
vdvTV_Playroom			= 33030:1:1
vdvTV_Anna_Living		= 33031:1:1
vdvTV_Guest_1			= 33032:1:1
vdvTV_Guest_2			= 33033:1:1
vdvTV_Billiard			= 33045:1:1

//BluRay Players
vdvBD_Cinema			= 33034:1:1
vdvBD_Lounge			= 33035:1:1
vdvBD_Sigar			= 33036:1:1

//Karaoke
vdvKaraoke_MadBoy		= 33037:1:1
vdvKaraoke_2			= 33038:1:1

//MIXER Yamaha
vdvYamaha_Oriental		= 33039:1:1

//33045 - use, next 33046

//vdvMoxa
vdvMoxa_1_1			= 33046:1:1 // Стойка Ми
vdvMoxa_1_2			= 33046:2:1 
vdvMoxa_2_1			= 33047:1:1 // Стойка Валера
vdvMoxa_2_2			= 33047:2:1
vdvMoxa_3_1			= 33048:1:1 // Кинотеатр
vdvMoxa_3_2			= 33048:2:1
vdvMoxa_4_1			= 33049:1:1 // Сигарная
vdvMoxa_4_2			= 33049:2:1
vdvMoxa_5_1			= 33050:1:1 // 
vdvMoxa_5_2			= 33050:2:1
vdvMoxa_6_1			= 33051:1:1 // Анна Гостевая
vdvMoxa_6_2			= 33051:2:1
vdvMoxa_7_1			= 33052:1:1 //
vdvMoxa_7_2			= 33052:2:1
vdvMoxa_8_1			= 33053:1:1 //
vdvMoxa_8_2			= 33053:2:1

//GC
vdvGC_11_1			= 33054:1:1
vdvGC_11_2			= 33054:2:1
vdvGC_11_3			= 33054:3:1

vdvAtlona_16x16			= 33055:1:1
vdvAtlona_16x16_Port_1		= 33055:2:1
vdvAtlona_16x16_Port_2		= 33055:3:1
vdvAtlona_16x16_Port_3		= 33055:4:1
vdvAtlona_16x16_Port_4		= 33055:5:1
vdvAtlona_16x16_Port_5		= 33055:6:1
vdvAtlona_16x16_Port_6		= 33055:7:1
vdvAtlona_16x16_Port_7		= 33055:8:1
vdvAtlona_16x16_Port_8		= 33055:9:1
vdvAtlona_16x16_Port_9		= 33055:10:1
vdvAtlona_16x16_Port_10		= 33055:11:1
vdvAtlona_16x16_Port_11		= 33055:12:1
vdvAtlona_16x16_Port_12		= 33055:13:1
vdvAtlona_16x16_Port_13		= 33055:14:1
vdvAtlona_16x16_Port_14		= 33055:15:1
vdvAtlona_16x16_Port_15		= 33055:16:1
vdvAtlona_16x16_Port_16		= 33055:17:1

vdvMR_Zone_Control		= 33056:1:1

vdvUnidisk_Dining		= 33057:1:1
vdvUnidisk_Cinema		= 33058:1:1
vdvUnidisk_Salon		= 33059:1:1
vdvYamaha_Master		= 33060:1:1
vdvUnidisk_Anna_Living		= 33061:1:1
vdvUnidisk_Sigar		= 33062:1:1

vdvYamaha_Cinema		= 33063:1:1

vdvUPS_Server			= 33064:1:1
vdvAPC_Karaoke			= 33065:1:1

vdvSNMP_UDP			= 33066:1:1

vdvAtlona_Salon_Left		= 33067:1:1
vdvAtlona_Karaoke_Right		= 33068:1:1

// next 33082:1:1
vdvAppleTV			= 33082:1:1
vdvAppleTV_2			= 33083:1:1
vdvAppleTV4KCinema		= 33084:1:1

vdvYamaha_Bathroom		= 33085:1:0
vdvYamaha_Hall			= 33086:1:0
vdvYamaha_Pool			= 33087:1:0
vdvYamaha_Fitness		= 33088:1:0
vdvYamaha_Kitchen		= 33089:1:0

vdvAppleTV_Master		= 33090:1:1

vdvYamaha_Yard			= 33091:1:1
(***********************************************************)
(*               CONSTANT DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_CONSTANT

_debug 					= 0
_push 					= 1
_release 				= 0
_hold					= 2
_up					= 97
_down					= 98
_mute					= 99
_on_tv 					= 1
_on_proj				= 2

#if_not_defined MAX_PANELS	MAX_PANELS	= 20 #end_if
#if_not_defined MAX_ZONES	MAX_ZONES	= 21 #end_if
#if_not_defined MAX_SOURCES	MAX_SOURCES	= 41 #end_if

tl_panels_update			= $F1
tl_master_off				= $F2
TL_Atlona_Check				= $F3

//зоны управления
//underground
volatile integer iZone_Billiard		= 20
//1st floor
volatile integer iZone_Kitchen		= 1 // 
volatile integer iZone_Dining		= 2
volatile integer iZone_Dining_Relax	= 3
volatile integer iZone_Cabinet		= 4
volatile integer iZone_Cinema		= 5
volatile integer iZone_Lounge		= 6
volatile integer iZone_Sigar		= 7
volatile integer iZone_Pool		= 8
volatile integer iZone_Gym		= 9
volatile integer iZone_Massage		= 10
volatile integer iZone_Foyer		= 11 //Hall
volatile integer iZone_Yard		= 21
//2nd floor
volatile integer iZone_Bedroom		= 12
volatile integer iZone_Bathroom		= 13
volatile integer iZone_Robik		= 14
volatile integer iZone_Playroom		= 15
volatile integer iZone_Anna_Living	= 16
volatile integer iZone_Anna_Bedroom	= 17
volatile integer iZone_Guest_1		= 18
volatile integer iZone_Guest_2		= 19


//источники мультирум
volatile integer iZone_Off		= 0
volatile integer iSrc_TV		= 1
volatile integer iSrc_Sat_1		= 2
volatile integer iSrc_Sat_2		= 3
volatile integer iSrc_Dune_1		= 4
volatile integer iSrc_Dune_2		= 5
volatile integer iSrc_Dune_3		= 6
volatile integer iSrc_AppleTV_2		= 7
volatile integer iSrc_ATV_Local		= 8
volatile integer iSrc_Base_2		= 9
volatile integer iSrc_Base_3		= 10
volatile integer iSrc_Sonix_1_1		= 11
volatile integer iSrc_Sonix_1_2		= 12
volatile integer iSrc_Sonix_1_3		= 13
volatile integer iSrc_Sonix_2_1		= 14
volatile integer iSrc_Sonix_2_2		= 15
volatile integer iSrc_Sonix_2_3		= 16
volatile integer iSrc_Sonix_3_1		= 17
volatile integer iSrc_Sonix_3_2		= 18
volatile integer iSrc_Sonix_3_3		= 19
volatile integer iSrc_Radio_1		= 20
volatile integer iSrc_Radio_2		= 21
volatile integer iSrc_Radio_3		= 22
volatile integer iSrc_Radio_4		= 23
volatile integer iSrc_Radio_5		= 24
volatile integer iSrc_Radio_6		= 25
volatile integer iSrc_iPort_Dining	= 26
volatile integer iSrc_iPort_Lounge	= 27
volatile integer iSrc_iPort_Sigar	= 28
volatile integer iSrc_iPort_Massage	= 29 // Airplay
volatile integer iSrc_iPort_Anna	= 30
volatile integer iSrc_Unidisk		= 31
volatile integer iSrc_Linn_DS		= 32
volatile integer iSrc_BluRay		= 33
volatile integer iSrc_Karaoke_1		= 34
volatile integer iSrc_Karaoke_2		= 35
volatile integer iSrc_Sony_PS3		= 36
volatile integer iSrc_DME_Music		= 37
volatile integer iSrc_DME_iPod		= 38
volatile integer iSrc_DME_TV		= 39
volatile integer iSrc_AppleTV		= 40
volatile integer iSrc_AppleTV4KCinema	= 41

_SoundFrom_TV = 0
_SoundFrom_Sp = 1
_SoundFrom_MR = 2

(***********************************************************)
(*              DATA TYPE DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_TYPE

structure eq_s
{
    char m_caMode[10]
    char m_caLow[10]
    char m_caMid[10]
    char m_caHigh[10]
    char m_caBalance[10]
    
    float m_fLow
    float m_fMid
    float m_fHigh
    float m_fBalance
}

structure tone_s
{
    char m_caMode[10]
    char m_caBass[10]
    char m_caTreble[10]
}

structure button_s
{
    integer 	m_iInput
    integer 	m_iPushState
    integer 	m_iLongPush
    integer 	m_iHoldCount // измеряется в 0.3 сек
    long 	m_lHoldTime
}

structure source_s
{
    char 	m_cName[30] //source name
    //char 	m_csName[30] //short source name
    integer 	m_iSelected // source is used un one of zone
    char 	m_caInUse[30] // в какой зоне используется источник '1,2,12'
}

structure panel_s
{
    integer 	m_iOnline //online offline
    char	m_caIP_address[15]
    char	m_caPanelID[5]
    char	m_caUDID[100]
    integer 	m_iOrientation
    integer 	m_iReserved
    
    integer 	m_iZoneFb
    integer 	m_iDistribToZone //перевод источника в другую зону с вопросом о выключении
			     //если 1, то переключаем источник в выбранную зону
    //char 	m_sTime[] //
    //char 	m_sTime_Usage[] //
    button_s 	m_sBtn
    integer	m_lLastSelectedLight
    integer	m_lLastSelectedHVAC
    integer	m_lLastSelectedGRF //GardinenRolladenFenster
    integer	m_iCount1
    integer	m_iCount2
    integer	m_iCount3
    integer	m_iCount4
    integer	m_iCount5 // count for Radio Presets
    integer	m_iCount6 // count for Update Radio Presets
    integer	m_iCount7 // count for update Source Zone Fb on Main Page
    integer	m_iCount8
    integer	m_iCount9
    integer	m_iCount10
}

structure Sound_s
{
    float m_fVol
    float m_fMute
    float m_fBass
    float m_fTreble
    float m_fCenterLvl
    float m_fSubLvl
    float m_fSurrLvl
    float m_fFrontLvl
    float m_fEnhancer
    float m_fStraight
    float m_fDialogueLevel
 
    integer m_iEnhancer
    integer m_iStraight
    integer m_iDirect
    integer m_iPureDirect
    integer m_iClearVoice
    integer m_iBassExtension
    integer m_iYpaoVolume
    integer m_iAdaptiveDRC
    integer m_iAdaptiveDSP
 
    char m_caSoundProgram[30]
    char m_caSurroundDecoder[30]
    char m_caDSP_Preset[30]
    char m_caSurrDecoder[30]
    char m_caBeamMode[30]
}


structure zone_s
{
    char 	m_cName[20]
    dev		audioSource[2]
    integer	activeAudioSource
    integer 	m_iSourceFb
    integer 	m_iOldSource
    integer 	m_iVolume
    integer 	m_iMute
    integer	m_iInitalVolume
    integer 	m_iTypeOfAudio // переключение ТВ/акустические системы/мультирум/DME_Controller
    integer	m_iSoundFrom // 0 - Громкость телевизора
			     // 1 - Громкость Линн
			     // 2 - Громкость Мультирум
    char 	m_caTimeOfUsage[10]
    
    Sound_s 	m_sSoundSystem
    //dgx_s	m_sDGX
    eq_s	m_sEqualizer
    tone_s	m_ToneControl
    
}


(***********************************************************)
(*               VARIABLE DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_VARIABLE

i=0
volatile integer p = 0
volatile integer _false = 0
volatile integer _true = 1
volatile integer _plus100 = 100

volatile integer _master_av = 0

volatile integer g_iCinema	= 0 // 1 - на ТВ, 2 - на проектор, (3 - музыка?)

volatile zone_s		m_aZones[MAX_ZONES]
volatile panel_s	m_aPanels[MAX_PANELS]
volatile source_s	m_aSource[MAX_SOURCES]

volatile long		m_laTL_Master[MAX_ZONES]	= { 500, 500, 500, 500, 500, 500, 500, 500, 500, 500,
							    500, 500, 500, 500, 500, 500, 500, 500, 500, 500, 500}

volatile long		m_laTL_Atlona[1]		= { 3600000 }
volatile long		m_laTL_PanelUpdate[1]		= 1000

#define THIS_Panel		g_dvaPanels[tp]
#define Panel_Count_1		m_aPanels[tp].m_iCount1
#define Panel_Count_2		m_aPanels[tp].m_iCount2
#define Panel_Count_3		m_aPanels[tp].m_iCount3
#define Panel_Count_4		m_aPanels[tp].m_iCount4
#define Panel_Count_7		m_aPanels[tp].m_iCount7
#define Panel_Preset_Count	m_aPanels[tp].m_iCount5
#define Panel_Update_Preset	m_aPanels[tp].m_iCount6
#define THIS_PanelIsOnline 	m_aPanels[tp].m_iOnline
#define THIS_Btn		m_aPanels[tp].m_sBtn.m_iInput
#define THIS_Room		m_aPanels[tp].m_iZoneFb
#define THIS_Source		m_aZones[m_aPanels[tp].m_iZoneFb].m_iSourceFb
#define THIS_Push		m_aPanels[tp].m_sBtn.m_iPushState
#define THIS_LongPush		m_aPanels[tp].m_sBtn.m_iLongPush
#define THIS_HoldTime		m_aPanels[tp].m_sBtn.m_lHoldTime
#define THIS_HoldCount		m_aPanels[tp].m_sBtn.m_iHoldCount
#define CHECK_MR		if(g_iaZoneMRoomInputs[in_iRoom][in_iSource])
#define CHECK_Panel		if(tp && m_aPanels[tp].m_iOnline && m_aPanels[tp].m_iOnline > 0)
#define CHECK_Room		if(tp && m_aPanels[tp].m_iZoneFb && m_aPanels[tp].m_iZoneFb > 0)
#define CHECK_Source		if(tp && m_aZones[m_aPanels[tp].m_iZoneFb].m_iSourceFb && m_aZones[m_aPanels[tp].m_iZoneFb].m_iSourceFb > 0)
#define Send_To_Panel		send_command g_dvaPanels[tp]

volatile dev		g_dvaPanels[MAX_PANELS]		= { dvPanel_1, dvPanel_2, dvPanel_3, dvPanel_4, dvPanel_5,
							    dvPanel_6, dvPanel_7, dvPanel_8, dvPanel_9, dvPanel_10,
							    dvPanel_11, dvPanel_12, dvPanel_13, dvPanel_14, dvPanel_15,
							    dvPanel_16, dvPanel_17, dvPanel_18, dvPanel_19, dvPanel_20}

/*
volatile dev		g_dvaYamhaRcv_Panels[MAX_PANELS]= { dvYamhaRcv_Panel_1, dvYamhaRcv_Panel_2, dvYamhaRcv_Panel_3, dvYamhaRcv_Panel_4, dvYamhaRcv_Panel_5,
							    dvYamhaRcv_Panel_6, dvYamhaRcv_Panel_7, dvYamhaRcv_Panel_8, dvYamhaRcv_Panel_9, dvYamhaRcv_Panel_10,
							    dvYamhaRcv_Panel_11, dvYamhaRcv_Panel_12, dvYamhaRcv_Panel_13, dvYamhaRcv_Panel_14, dvYamhaRcv_Panel_15,
							    dvYamhaRcv_Panel_16, dvYamhaRcv_Panel_17, dvYamhaRcv_Panel_18, dvYamhaRcv_Panel_19, dvYamhaRcv_Panel_20 }
*/
volatile char		g_caZone_Names[][20]		= { '1_Kitchen',
							    '2_Dining',
							    '3_',
							    '4_Cabinet',
							    '5_Cinema',
							    '6_Lounge',
							    '7_Sigar',
							    '8_Pool',
							    '9_Gym',
							    '10_Massage',
							    '11_Hall',
							    '12_Bedroom',
							    '13_Bathroom',
							    '14_Robik',
							    '15_Playroom',
							    '16_Anna_Living',
							    '17_Anna_Bedroom',
							    '18_Guest1',
							    '19_Guest2',
							    '20_Billiard',
							    '21_Yard' }
volatile char		g_caSource_Names[][20]		= { 'TV',
							    'SAT',
							    'SAT',
							    'Dune',
							    'Dune',
							    'Dune',
							    'AppleTV', // new
							    'AppleTV', // Master
							    '',
							    '', //10
							    '',
							    '',
							    '',
							    '',
							    '',
							    '',
							    '',
							    '',
							    '',
							    '',//
							    '',
							    '',
							    '',
							    '',
							    '',
							    '',
							    '',
							    '',
							    '',
							    '',//
							    '',
							    '',
							    '',
							    '',
							    '',
							    '',
							    '',
							    '',
							    '',
							    'AppleTV'//
							     }	

volatile dev		g_vdvaTV[]	= { vdvTV_Kitchen,
					    vdvTV_Dining,
					    0,
					    0,
					    vdvTV_Cinema,
					    vdvTV_Lounge,
					    vdvTV_Sigar,
					    vdvTV_Pool,
					    vdvTV_Gym,
					    0,
					    0,
					    vdvTV_Master_Bedroom,
					    vdvTV_Master_Bathroom,
					    0,
					    vdvTV_Playroom,
					    vdvTV_Anna_Living,
					    0,
					    vdvTV_Guest_1,
					    vdvTV_Guest_2,
					    vdvTV_Billiard,
					    0
					    }

volatile dev		g_vdvaSources[MAX_SOURCES]	= { 
					    0,
					    vdvSAT_1,
					    vdvSAT_2,
					    vdvDune_1,
					    vdvDune_2,
					    vdvDune_3,
					    vdvAppleTV_2,
					    vdvAppleTV_Master,
					    0,0,0,0,0,//13
					    0,0,0,0,0,0,//19
					    0,0,0,0,0,0,//25
					    0,0,0,0,0,0,//31
					    0,0,0,0,0,0,0,0,
					    vdvAppleTV,
					    vdvAppleTV4KCinema
					    }

volatile dev		g_vdvaDVD_Players[]	= { 0,
						    vdvUnidisk_Dining,
						    0,
						    0,
						    vdvBD_Cinema,
						    vdvBD_Lounge,
						    vdvBD_Sigar,
						    0,
						    0,
						    0,
						    0,
						    vdvYamaha_Master,
						    0,
						    0,
						    0,
						    vdvUnidisk_Anna_Living,
						    0,
						    0,
						    0,
						    0 }

volatile dev		g_vdvaAudio[]		= { vdvYamaha_Kitchen,
						    vdvUnidisk_Dining,
						    0,
						    0,
						    vdvYamaha_Cinema,
						    0,
						    vdvYamaha_Oriental,
						    vdvYamaha_Pool,
						    vdvYamaha_Fitness,
						    0,
						    vdvYamaha_Hall,
						    vdvYamaha_Master,
						    vdvYamaha_Bathroom,
						    0,
						    0,
						    vdvUnidisk_Anna_Living,
						    0,
						    0,
						    0,
						    0,
						    vdvYamaha_Yard
						    }

volatile integer	m_iPort			= 502			// порт подключеня
volatile integer	m_iInputCoil		= 1			// индекс первого канала для входящих дискретных каналов
volatile integer	m_iOutputCoil		= 256			// индекс первого канала для исходящих дискретных выходов


volatile char		g_caAtlonaZones[][2]	= { '7','10','','','9',
						    '11','1','14','13','',
						    '','2','3','','6',
						    '8','','4','5','12','' }

volatile dev		g_vdvaDune[]	= { vdvDune_1, vdvDune_2, vdvDune_3 }
volatile dev		g_vdvaSat[]	= { vdvSAT_1, vdvSAT_2 }
volatile dev		g_vdvaAppleTV[]	= { vdvAppleTV, vdvAppleTV_2}

volatile dev		g_vdvaGC_1[]	= { vdvGC_1_1, vdvGC_1_2, vdvGC_1_3 }
volatile dev		g_vdvaGC_2[]	= { vdvGC_2_1, vdvGC_2_2, vdvGC_2_3 }
volatile dev		g_vdvaGC_3[]	= { vdvGC_3_1, vdvGC_3_2, vdvGC_3_3 }
volatile dev		g_vdvaGC_4[]	= { vdvGC_4_1, vdvGC_4_2, vdvGC_4_3 }
volatile dev		g_vdvaGC_5[]	= { vdvGC_5_1, vdvGC_5_2, vdvGC_5_3 }
volatile dev		g_vdvaGC_6[]	= { vdvGC_6_1, vdvGC_6_2, vdvGC_6_3 }
volatile dev		g_vdvaGC_7[]	= { vdvGC_7_1, vdvGC_7_2, vdvGC_7_3 }
volatile dev		g_vdvaGC_8[]	= { vdvGC_8_1, vdvGC_8_2, vdvGC_8_3 }
volatile dev		g_vdvaGC_9[]	= { vdvGC_9_1, vdvGC_9_2, vdvGC_9_3 }
volatile dev		g_vdvaGC_10[]	= { vdvGC_10_1, vdvGC_10_2, vdvGC_10_3 }
volatile dev		g_vdvaGC_11[]	= { vdvGC_11_1, vdvGC_11_2, vdvGC_11_3 }

volatile dev		g_vdvaAtlonaPorts[16]	= {
						    vdvAtlona_16x16_Port_1,	
						    vdvAtlona_16x16_Port_2,	
						    vdvAtlona_16x16_Port_3,	
						    vdvAtlona_16x16_Port_4,	
						    vdvAtlona_16x16_Port_5,	
						    vdvAtlona_16x16_Port_6,	
						    vdvAtlona_16x16_Port_7,	
						    vdvAtlona_16x16_Port_8,	
						    vdvAtlona_16x16_Port_9,	
						    vdvAtlona_16x16_Port_10,
						    vdvAtlona_16x16_Port_11,
						    vdvAtlona_16x16_Port_12,
						    vdvAtlona_16x16_Port_13,
						    vdvAtlona_16x16_Port_14,
						    vdvAtlona_16x16_Port_15,
						    vdvAtlona_16x16_Port_16
						    }

// <baud>,<data length 7,8>,<parity 0 - none,1 - odd,2 - even>,<stop bit 0,1>
volatile char		g_caAtlonaPortBaud[16][20] = {  '19200,8,0,1', // 1
							'9600,7,2,1', // 2 - Bedroom Linn Classik Movie
							'19200,8,0,1', // 3
							'19200,8,0,1', // 4
							'19200,8,0,1', // 5
							'19200,8,0,1', // 6
							'9600,7,2,1', // 7
							'19200,8,0,1', // 8
							'19200,8,0,1', // 9
							'9600,7,2,1', // 10 - Linn Classik Movie Dining
							'9600,8,0,1', // 11  - Salon Right Rack
							'19200,8,0,1', // 12
							'19200,8,0,1', // 13
							'19200,8,0,1', // 14
							'19200,8,0,1', // 15
							'19200,8,0,1' }// 16

//Moxa port
volatile integer 	g_iaMoxaPort[2]		= { 1, 2 }

volatile char		g_caHost_Yamaha_Master[]	= '10.98.253.49' // mac

volatile char		g_caHost_Lutron_2[]		= '10.98.253.54' // mac
volatile char		g_caHost_Dune_1[]		= '10.98.253.55' // mac 00:16:E8:63:9B:2D
volatile char		g_caHost_Dune_2[]		= '10.98.253.56' // mac 00:16:E8:F9:DD:38
volatile char		g_caHost_Dune_3[]		= '10.98.253.57' // mac 00:16:E8:33:50:A8
volatile char		g_caHost_Dune_4[]		= '10.98.253.58' // mac 00:16:E8:69:14:FC
volatile char		g_caHost_KNX_EIB[]		= '10.98.253.59' // mac

volatile char		m_caHost_MR[]			= '10.98.253.67'	// ip-адрес устройства мультирум
volatile char		g_caHost_GC_IP2IR_1[]		= '10.98.253.68' // mac 00 0C 1E 02 3E A5 - Server #1 (Guest1 TV,Guest2 TV,Kitchen TV)
volatile char		g_caHost_GC_IP2IR_2[]		= '10.98.253.69' // mac 00 0C 1E 02 3E 94 - Server #2 (Ann Liv TV,Dining TV,Billiards TV)
volatile char		g_caHost_GC_IP2IR_3[]		= '10.98.253.70' // mac 00 0C 1E 02 3E 92 - Server #3 (Gym TV,Salon TV,AppleTV)
volatile char		g_caHost_GC_IP2IR_4[]		= '10.98.253.71' // mac 00 0C 1E 02 3E 98 - Server #4 (SAT1,SAT2, )
volatile char		g_caHost_GC_IP2IR_5[]		= '10.98.253.72' // mac 00 0C 1E 02 3E AC - Cinema (TV,BD Sony,)
volatile char		g_caHost_GC_IP2IR_6[]		= '10.98.253.73' // mac 00 0C 1E 02 00 00 - 
volatile char		g_caHost_GC_IP2IR_7[]		= '10.98.253.74' // mac 00 0C 1E 02 3E 91 - Salon Left (Salon TV,BD Sony,)
volatile char		g_caHost_GC_IP2IR_8[]		= '10.98.253.75' // mac 00 0C 1E 02 2A 8B - Playroom (Playroom TV,,)
volatile char		g_caHost_GC_IP2IR_9[]		= '10.98.253.76' // mac 00 0C 1E 02 26 9C - Server #5 (Sigar,Bedroom,Bathroom)
volatile char		g_caHost_GC_IP2IR_10[]		= '10.98.253.77' // mac 00 0C 1E 05 49 86 - Master Bedroom (Apple TV,,)

volatile char		g_caHost_Moxa_nPort_1[]		= '10.98.253.78' // mac Salon Rack Left
volatile char		g_caHost_Moxa_nPort_2[]		= '10.98.253.79' // mac Salon Rack Right Karaoke
volatile char		g_caHost_Moxa_nPort_3[]		= '10.98.253.80' // mac 
volatile char		g_caHost_Moxa_nPort_4[]		= '10.98.253.81' // mac 
volatile char		g_caHost_Moxa_nPort_5[]		= '10.98.253.82' // mac 
volatile char		g_caHost_Moxa_nPort_6[]		= '10.98.253.83' // mac Anna Living
volatile char		g_caHost_Moxa_nPort_7[]		= '10.98.253.84' // mac 
volatile char		g_caHost_Moxa_nPort_8[]		= '10.98.253.85' // mac 

volatile char		g_caHost_Lutron_1[]		= '10.98.253.90' // mac
volatile char		g_caHost_GC_IP2IR_11[]		= '10.98.253.92' // mac 00 0C 1E 02 3E 96 - Sigar room (,BD,)
volatile char		g_caHost_UPS_Server[]		= '10.98.253.93' // mac
volatile char		g_caHost_APC_Karaoke[]		= '10.98.253.94' // mac

volatile char		g_caHost_Projector[]		= '10.98.253.97' // mac
volatile char		g_caHost_Yamaha_Cinema[]	= '10.98.253.98' // mac Cinema
volatile char		g_caHost_Yamaha_Oriental[]	= '10.98.253.99' // mac

volatile char		g_caLogin[]			= 'amx'

volatile char		g_caHost_Yamaha_Bathroom[]	= '10.98.253.110' // mac
volatile char		g_caHost_Yamaha_Kitchen[]	= '10.98.253.111' // mac
volatile char		g_caHost_Yamaha_Fitness[]	= '10.98.253.112' // mac
volatile char		g_caHost_Yamaha_Hall[]		= '10.98.253.113' // mac
volatile char		g_caHost_Yamaha_Pool[]		= '10.98.253.114' // mac
volatile char		g_caHost_Yamaha_Yard[]		= '10.98.253.115' // mac

volatile integer	m_iaGC_Shift_1[3]	= { 1400, 1400, 900 } //
volatile integer	m_iaGC_Shift_2[3]	= { 1400, 900, 1400 } //
volatile integer	m_iaGC_Shift_3[3]	= { 0, 1400, 1100 } //
volatile integer	m_iaGC_Shift_4[3]	= { 800, 800, 0 }
volatile integer	m_iaGC_Shift_5[3]	= { 1400, 700, 1100 }
volatile integer	m_iaGC_Shift_6[3]	= { 0, 0, 0 }
volatile integer	m_iaGC_Shift_7[3]	= { 1400, 700, 0 }
volatile integer	m_iaGC_Shift_8[3]	= { 1400, 0, 0 }
volatile integer	m_iaGC_Shift_9[3]	= { 1400, 1400, 0 } //
volatile integer	m_iaGC_Shift_10[3]	= { 1100, 0, 0 }
volatile integer	m_iaGC_Shift_11[3]	= { 0, 700, 0 }

volatile char		g_caZoneTVInputs[MAX_ZONES][MAX_SOURCES][10] = {
(*Source №	   1	2	3	4	5	6	7	8	9	10	11	12	13	14	15    16     17     18     19     20     21     22     23     24     25     26     27     28     29     30     31     32     33     34     35     36     37     38     39     40*)
(*Kitchen*)    	{'TV','HDMI1','HDMI1','HDMI1','HDMI1','HDMI1','HDMI1','HDMI1','HDMI1','HDMI1','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','HDMI1',''}, 
(*Dining*)    	{'TV','HDMI1','HDMI1','HDMI1','HDMI1','HDMI1','HDMI1','HDMI1','HDMI1','HDMI1','','','','','','','','','','','','','','','','','','','','','AV1','','','','','','','','','HDMI1',''},
(*Dining_Relax*){'','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','',''},
(*Cabinet*)    	{'','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','',''},
(*Cinema*)    	{'TV','HDMI2','HDMI2','HDMI2','HDMI2','HDMI2','HDMI2','HDMI2','HDMI2','HDMI2','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','HDMI2',''},
(*Lounge*)    	{'TV','HDMI1','HDMI1','HDMI1','HDMI1','HDMI1','HDMI1','HDMI1','HDMI1','HDMI1','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','HDMI1',''},
(*Sigar*)    	{'TV','HDMI2','HDMI2','HDMI2','HDMI2','HDMI2','HDMI2','HDMI2','HDMI2','HDMI2','','','','','','','','','','','','','','','','','','','','','','','HDMI2','','','','','','','HDMI2',''},
(*Pool*)   	{'','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','',''},
(*Gym*)    	{'TV','HDMI3','HDMI3','HDMI3','HDMI3','HDMI3','HDMI3','HDMI3','HDMI3','HDMI3','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','HDMI3',''},
(*Massage*)  	{'','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','',''},
(*Foyer*)    	{'','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','',''},
(*Bedroom*)    	{'TV','HDMI1','HDMI1','HDMI1','HDMI1','HDMI1','HDMI1','HDMI2','HDMI1','HDMI1','','','','','','','','','','','','','','','','','','','','','AV1','','','','','','','','','HDMI1',''},
(*Bathroom*)    {'TV','HDMI1','HDMI1','HDMI1','HDMI1','HDMI1','HDMI1','HDMI1','HDMI1','HDMI1','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','HDMI1',''},
(*Robik*)    	{'','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','',''},
(*PlayRoom*)    {'TV','HDMI1','HDMI1','HDMI1','HDMI1','HDMI1','HDMI1','HDMI1','HDMI1','HDMI1','','','','','','','','','','','','','','','','','','','','','','','','','','HDMI4','','','','HDMI1',''},
(*Anna_Living*) {'TV','HDMI1','HDMI1','HDMI1','HDMI1','HDMI1','HDMI1','HDMI1','HDMI1','HDMI1','','','','','','','','','','','','','','','','','','','','','AV1','','','','','','','','','HDMI1',''},
(*Anna_Bedroom*){'','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','',''},
(*Guest_1*)    	{'TV','HDMI1','HDMI1','HDMI1','HDMI1','HDMI1','HDMI1','HDMI1','HDMI1','HDMI1','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','HDMI1',''},
(*Guest_2*)    	{'TV','HDMI1','HDMI1','HDMI1','HDMI1','HDMI1','HDMI1','HDMI1','HDMI1','HDMI1','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','HDMI1',''},
(*Billiard*)    {'TV','HDMI1','HDMI1','HDMI1','HDMI1','HDMI1','HDMI1','HDMI1','HDMI1','HDMI1','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','HDMI1',''},
(*Yard*)    	{'','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','',''} }

//вход на Атлоне в зависимости от выбранного источника
persistent char	g_caAtlonaInputs[MAX_SOURCES][2] = {'','15','16','7','8','9','10','1','2','3','','','','','','','','','',''/*20*/,'','','','','','','','','','','','','','','','','','','','11'}


volatile integer	g_iaZoneMRoomOutputs[24] = {/*19*/0,7,23,20,9,12,8,/*3*/0,
						    /*24*/0,13,/*4*/0,/*2*/0,/*21*/0,22,14,1,
						    18,16,17,15,5,0,0,0 }

volatile integer	g_iaZoneMRoomInputs[MAX_ZONES][MAX_SOURCES] = {
(*Kitchen*)    	{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}, 
(*Dining*)    	{0,0,0,0,0,0,0,0,0,0,17,18,19,20,21,22,23,24,10,1,2,3,4,5,6,7,16,11,11,0,0,0,0,0,0,0,0,0,0,0},
(*Dining_Relax*){0,0,0,0,0,0,0,0,0,0,17,18,19,20,21,22,23,24,10,1,2,3,4,5,6,7,16,11,11,0,0,0,0,0,0,0,0,0,0,0},
(*Cabinet*)    	{0,0,0,0,0,0,0,0,0,0,17,18,19,20,21,22,23,24,10,1,2,3,4,5,6,7,16,11,11,0,0,0,0,0,0,0,0,0,0,0},
(*Cinema*)    	{0,0,0,0,0,0,0,0,0,0,17,18,19,20,21,22,23,24,10,1,2,3,4,5,6,7,16,11,11,0,0,0,0,0,0,0,0,0,0,0},
(*Lounge*)    	{8,0,0,0,0,0,0,0,0,0,17,18,19,20,21,22,23,24,10,1,2,3,4,5,6,7,16,11,11,9,0,0,0,0,0,0,0,0,0,0},
(*Sigar*)    	{0,0,0,0,0,0,0,0,0,0,17,18,19,20,21,22,23,24,10,1,2,3,4,5,6,7,16,11,11,0,0,0,0,0,0,0,0,0,0,0},
(*Pool*)   	{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
(*Gym*)    	{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
(*Massage*)  	{0,0,0,0,0,0,0,0,0,0,17,18,19,20,21,22,23,24,10,1,2,3,4,5,6,7,16,11,11,0,0,0,0,0,0,0,0,0,0,0},
(*Foyer*)    	{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
(*Bedroom*)    	{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
(*Bathroom*)    {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
(*Robik*)    	{0,0,0,0,0,0,0,0,0,0,17,18,19,20,21,22,23,24,10,1,2,3,4,5,6,7,16,11,11,0,0,0,0,0,0,0,0,0,0,0},
(*PlayRoom*)    {0,0,0,0,0,0,0,0,0,0,17,18,19,20,21,22,23,24,10,1,2,3,4,5,6,7,16,11,11,0,0,0,0,0,0,0,0,0,0,0},
(*Anna_Living*) {0,0,0,0,0,0,0,0,0,0,17,18,19,20,21,22,23,24,10,1,2,3,4,5,6,7,16,11,11,0,0,0,0,0,0,0,0,0,0,0},
(*Anna_Bedroom*){0,0,0,0,0,0,0,0,0,0,17,18,19,20,21,22,23,24,10,1,2,3,4,5,6,7,16,11,11,0,0,0,0,0,0,0,0,0,0,0},
(*Guest_1*)    	{0,0,0,0,0,0,0,0,0,0,17,18,19,20,21,22,23,24,10,1,2,3,4,5,6,7,16,11,11,0,0,0,0,0,0,0,0,0,0,0},
(*Guest_2*)    	{0,0,0,0,0,0,0,0,0,0,17,18,19,20,21,22,23,24,10,1,2,3,4,5,6,7,16,11,11,0,0,0,0,0,0,0,0,0,0,0},
(*Billiard*)    {0,0,0,0,0,0,0,0,0,0,17,18,19,20,21,22,23,24,10,1,2,3,4,5,6,7,16,11,11,0,0,0,0,0,0,0,0,0,0,0},
(*Yard*)    	{0,0,0,0,0,0,0,0,0,0,17,18,19,20,21,22,23,24,10,1,2,3,4,5,6,7,16,11,11,0,0,0,0,0,0,0,0,0,0,0} }


volatile char		g_caZoneLinnInputs[MAX_ZONES][MAX_SOURCES][10] = {
(*Kitchen*)    	{'','','','','','','','','','','SERVER','SERVER','SERVER','SERVER','SERVER','SERVER','SERVER','SERVER','SERVER','NET RADIO','NET RADIO','NET RADIO','NET RADIO','NET RADIO','NET RADIO','','','','AirPlay','','','','','','','','','','','',''}, 
(*>Dining*)    	{'DIG2','DIG2','DIG2','DIG2','DIG2','DIG2','DIG2','DIG2','DIG2','DIG2','AUX1','AUX1','AUX1','AUX1','AUX1','AUX1','AUX1','AUX1','AUX1','AUX1','AUX1','AUX1','AUX1','AUX1','AUX1','AUX1','','','AUX1','','DISC','','','','','','','','','DIG2',''},
(*Dining_Relax*){'','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','',''},
(*Cabinet*)    	{'','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','',''},
(*>Cinema*)    	{'','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','',''},
(*>Lounge*)    	{'','DIG1','DIG1','DIG1','DIG1','DIG1','DIG1','DIG1','DIG1','DIG1','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','DIG1',''},
(*>Sigar*)    	{'AUDIO1','AUDIO1','AUDIO1','AUDIO1','AUDIO1','AUDIO1','AUDIO1','AUDIO1','AUDIO1','AUDIO1','AUDIO3','AUDIO3','AUDIO3','AUDIO3','AUDIO3','AUDIO3','AUDIO3','AUDIO3','AUDIO3','AUDIO3','AUDIO3','AUDIO3','AUDIO3','AUDIO3','AUDIO3','','','','AirPlay',''/*30*/,'','','AUDIO1','','','','','','','AUDIO1',''},
(*Pool*)   	{'','','','','','','','','','','SERVER','SERVER','SERVER','SERVER','SERVER','SERVER','SERVER','SERVER','SERVER','NET RADIO','NET RADIO','NET RADIO','NET RADIO','NET RADIO','NET RADIO','','','','AirPlay','','','','','','','','','','','',''},
(*Gym*)    	{'Optical','Optical','Optical','Optical','Optical','Optical','Optical','Optical','Optical','Optical','SERVER','SERVER','SERVER','SERVER','SERVER','SERVER','SERVER','SERVER','SERVER','NET RADIO','NET RADIO','NET RADIO','NET RADIO','NET RADIO','NET RADIO','','','','AirPlay','','','','','','','','','','','',''},
(*Massage*)  	{'','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','',''},
(*Foyer*)    	{'','','','','','','','','','','SERVER','SERVER','SERVER','SERVER','SERVER','SERVER','SERVER','SERVER','SERVER','NET RADIO','NET RADIO','NET RADIO','NET RADIO','NET RADIO','NET RADIO','','','','AirPlay','','','','','','','','','','','',''},
(*>Bedroom*)    {'Optical','Optical','Optical','Optical','Optical','Optical','Optical','Optical','Optical','Optical','SERVER','SERVER','SERVER','SERVER','SERVER','SERVER','SERVER','SERVER','SERVER','NET RADIO','NET RADIO','NET RADIO','NET RADIO','NET RADIO','NET RADIO','','','','AirPlay','','','','','','','','','','','Optical',''},
(*Bathroom*)    {'','','','','','','','','','','SERVER','SERVER','SERVER','SERVER','SERVER','SERVER','SERVER','SERVER','SERVER','NET RADIO','NET RADIO','NET RADIO','NET RADIO','NET RADIO','NET RADIO','','','','AirPlay','','','','','','','','','','','',''},
(*Robik*)    	{'','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','',''},
(*PlayRoom*)    {'','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','',''},
(*>Anna_Living*){'AUX1','AUX1','AUX1','AUX1','AUX1','AUX1','AUX1','AUX1','AUX1','AUX1','AUX2','AUX2','AUX2','AUX2','AUX2','AUX2','AUX2','AUX2','AUX2','AUX2','AUX2','AUX2','AUX2','AUX2','AUX2','','','','AUX2','','DISC','','','','','','','','','AUX1',''},
(*Anna_Bedroom*){'','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','',''},
(*Guest_1*)    	{'','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','',''},
(*Guest_2*)    	{'','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','',''},
(*Billiard*)    {'','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','',''},
(*Yard*) 	{'','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','',''} }

volatile integer g_iAtlonaOnStart = 0
//zone name array

//source name array

#include 'Lutron_Vars.axi'

#include 'Multiroom.axi'
#include 'Cinema.axi'
#include 'Salon_Karaoke.axi'
#include 'Panels_Main_Include'

DEFINE_LATCHING

DEFINE_MUTUALLY_EXCLUSIVE


define_function fnSend(integer tp, char in_caCommand[])
{
    if(m_aPanels[tp].m_iOnline)
	send_command g_dvaPanels[tp], in_caCommand
}

define_function fnCmd(dev dvDevice, char in_caData[])
{
    send_command dvDevice, in_caData
}
define_function fnStr(dev dvDevice, char in_caData[])
{
    send_string dvDevice, in_caData
}

define_function fnProcessPanelUpdate(integer tp)
{
    
    CHECK_Panel
    {	
	if(THIS_Room == 0) {
	    //fnCmd(THIS_Panel, '@PPX')
	    fnCmd(THIS_Panel, 'PAGE-Main')
	    fnCmd(THIS_Panel, '@PPN-Main_Page;Main')	    
	}
	
	if(!g_iAtlonaOnStart)
	    send_command THIS_Panel, '@PPF-_ZoneMsg_PleaseWait'
	//send_string 0, "'CHEK PANEL FOR UPDATE & UPDATE = ', itoa(tp)"
	
	//update active room fb
	for(Panel_Count_1 = 1; Panel_Count_1 <= MAX_ZONES; Panel_Count_1++) {
	    [THIS_Panel, 1000 + Panel_Count_1] = (m_aZones[Panel_Count_1].m_iSourceFb > 0)
	    
	    if(m_aZones[Panel_Count_1].m_iSourceFb)
		fnCmd(THIS_Panel, "'^TXT-', itoa(300 + Panel_Count_1),',0,', m_aSource[m_aZones[Panel_Count_1].m_iSourceFb].m_cName")
	    else
		fnCmd(THIS_Panel, "'^TXT-', itoa(300 + Panel_Count_1),',0, '")
	}
	//
	CHECK_Room
	{
	    // обновление активного источника
	    [g_dvaPanels[tp], 951] = (THIS_Source >= iSrc_Dune_1 && THIS_Source <= iSrc_Dune_3)
	    [g_dvaPanels[tp], 952] = (THIS_Source == iSrc_Sat_1 || THIS_Source == iSrc_Sat_2)
	    [g_dvaPanels[tp], 953] = (THIS_Source == iSrc_AppleTV || THIS_Source == iSrc_AppleTV_2)
	    
	    for(Panel_Count_2 = 0; Panel_Count_2 <= MAX_SOURCES; Panel_Count_2++) {
		[g_dvaPanels[tp], 1100 + Panel_Count_2] = (THIS_Source == Panel_Count_2)
	    }
	    
	    //
	    if(THIS_Source > 0) {
		//show volume control
		if(THIS_Room == iZone_Cinema) {
		    [THIS_Panel, 912] = (g_iCinema == 2)
		    [THIS_Panel, 913] = (g_iCinema == 1)
		    [THIS_Panel, 914] = (g_iCinema == 2)
		    [THIS_Panel, 917] = (g_iCinema == 2)
		    //
		    if(g_iCinema == 0) {
			fnCmd(THIS_Panel,'^SHO-917&930,0') 
			//fnCmd(THIS_Panel,'^SHO-930,0') 
		    }
		    if(g_iCinema > 0) {
			fnCmd(THIS_Panel,'^SHO-917,1')
			fnCmd(THIS_Panel,'^SHO-930,0')
		    }
		    
		    if(THIS_Source == 1 || (THIS_Source >= 11 && THIS_Source <= 30)) {
			fnCmd(THIS_Panel,'^SHO-97.99,1') 
			fnCmd(THIS_Panel,'^SHO-912&930,0')
			//fnCmd(THIS_Panel,'^SHO-930,0')
		    } else
		    if((THIS_Source > 1 && THIS_Source <= 10) || THIS_Source == 33 || THIS_Source == 40 || THIS_Source == 41) {
			fnCmd(THIS_Panel,'^SHO-97.99&912,1')
			fnCmd(THIS_Panel,'^SHO-930,0')
		    } else {
			fnCmd(THIS_Panel,'^SHO-912&930,0') 
			//fnCmd(THIS_Panel,'^SHO-930,0')
		    }
		} else
		if( THIS_Room == iZone_Dining ||
		    THIS_Room == iZone_Bedroom ||
		    //THIS_Room == iZone_Sigar ||
		    THIS_Room == iZone_Anna_Living) {
				    fnCmd( THIS_Panel,'^SHO-97.99&930,1' )
				    //fnCmd(THIS_Panel,'^SHO-930,1')
				    fnCmd( THIS_Panel,'^SHO-912,0' )
		} else {
		    fnCmd( THIS_Panel,'^SHO-97.99,1' )
		    fnCmd( THIS_Panel,'^SHO-930&912,0' )
		}
		//Send Text for Zone On - on name source
		fnCmd( THIS_Panel, "'^TXT-1,0,', m_aZones[THIS_Room].m_cName,' / ', m_aSource[THIS_Source].m_cName" )
		fnCmd( THIS_Panel, "'^TXT-2,0,', m_aZones[THIS_Room].m_cName" )
		//update sources fb
	    } else {
		//hide volume control
		fnCmd( THIS_Panel,'^SHO-97.99&912,0' )
		fnCmd( THIS_Panel,'^SHO-930,0' )
		//send text for Zone Off
		fnCmd( THIS_Panel, "'^TXT-1,0,', m_aZones[THIS_Room].m_cName,' / ', 'Zone Is Off...'")
		fnCmd( THIS_Panel, "'^TXT-2,0,', m_aZones[THIS_Room].m_cName" )
	    }
	}
    }
}

define_function fnSourceControl(integer tp)
{
    //send_string 0, "'SOURCE CONTROL TP=',itoa(tp),', SOURCE=',itoa(THIS_Source),', BTN=',itoa(THIS_Btn),', PUSH=',itoa(THIS_Push)"
    
    switch(THIS_Push)
    {
	case _push:
	{
	    if(THIS_Source == iSrc_Sat_1 || THIS_Source == iSrc_Sat_2) {
		pulse[g_vdvaSources[THIS_Source], THIS_Btn]
	    } else 
	    if( (THIS_Source >= iSrc_Dune_1 && THIS_Source <= iSrc_ATV_Local) || THIS_Source == iSrc_AppleTV || THIS_Source == iSrc_AppleTV4KCinema) {
		    on[g_vdvaSources[THIS_Source], THIS_Btn]
		    //send_string 0, "'SOURCE ON'"
	    } else 
	    if(THIS_Source == iSrc_TV) {
		if(g_vdvaTV[THIS_Room] != 0)
		    pulse[g_vdvaTV[THIS_Room], THIS_Btn]
	    } else 
	    if(THIS_Source == iSrc_Unidisk || THIS_Source == iSrc_BluRay) {
		if(g_vdvaDVD_Players[THIS_Room] != 0)
		    pulse[g_vdvaDVD_Players[THIS_Room], THIS_Btn]
	    }
	}
	case _release: 
	{
	    if((THIS_Source >= iSrc_Dune_1 && THIS_Source <= iSrc_ATV_Local) || THIS_Source == iSrc_AppleTV || THIS_Source == iSrc_AppleTV4KCinema) {
		off[g_vdvaSources[THIS_Source], THIS_Btn]
		//send_string 0, "'SOURCE OFF'"
	    }
	}
    }
}

define_function fnBackButton(integer tp)
{
    fnCmd(THIS_Panel, "'@PPX'")
    
    if(length_string(g_caZone_Names[m_aPanels[tp].m_iZoneFb]) > 0) {
    //if(THIS_Room)
	fnCmd(THIS_Panel, 'PAGE-Main_Source')
	fnCmd(THIS_Panel, "'@PPN-', g_caZone_Names[THIS_Room], '_Main;Main_Source'")
	fnCmd(THIS_Panel, "'@PPN-Volume_Footer;Main_Source'")
	fnCmd(THIS_Panel, "'@PPN-Popup_Home;Main_Source'")
	//вызвать панель управления зоной (свет, шторы, климат)
	fnCmd(THIS_Panel, "'@PPN-', g_caZone_Names[THIS_Room], '_Control;Main_Source'")
    } else {
	fnCmd(THIS_Panel, 'PAGE-Main')
	fnCmd(THIS_Panel, '@PPN-Main_Page;Main')
    }
        
    fnProcessPanelUpdate(tp)
}

define_function fnRoomControlPopups(integer tp)
{
    switch(THIS_Btn)
    {
	case 901: fnCmd(THIS_Panel, "'@PPG-', g_caZone_Names[m_aPanels[tp].m_iZoneFb], '_Light'")
	case 902: fnCmd(THIS_Panel, "'@PPG-', g_caZone_Names[m_aPanels[tp].m_iZoneFb], '_Climate'")
	case 903: fnCmd(THIS_Panel, "'@PPG-', g_caZone_Names[m_aPanels[tp].m_iZoneFb], '_Shades'")
	case 904: fnCmd(THIS_Panel, "'@PPG-Cameras'")
	case 910: {//fnCmd(g_dvaPanels[tp], "'@CPG-Room_Control_Popups'") //close popup group
	    fnCmd(THIS_Panel, "'@PPF-', g_caZone_Names[m_aPanels[tp].m_iZoneFb], '_Light'")
	    fnCmd(THIS_Panel, "'@PPF-', g_caZone_Names[m_aPanels[tp].m_iZoneFb], '_Climate'")
	    fnCmd(THIS_Panel, "'@PPF-', g_caZone_Names[m_aPanels[tp].m_iZoneFb], '_Shades'")
	    fnCmd(THIS_Panel, "'@PPF-Cameras'")
	}   
    }
}

define_function fnVolumeControl(integer tp)
{
    local_var
	integer l_iBtn
	integer l_iPulse //if need pulse[dv,command]
	dev l_Device
    
    CHECK_Room
    {
	switch(THIS_Room)
	{
	    //Зоны где управляется громкость ТВ и Мультирум
	    case iZone_Gym: 
	    {
		l_Device = vdvYamaha_Fitness
		l_iBtn = THIS_Btn
	    }
	    case iZone_Foyer:
	    case iZone_Pool:
	    case iZone_Bathroom:
	    case iZone_Kitchen: { 
		//управление громкостью ТВ
		if(THIS_Source >= iSrc_TV && THIS_Source <= iSrc_Base_3 || This_Source == iSrc_AppleTV) {
		    l_Device = g_vdvaTV[THIS_Room] 
		    l_iBtn = THIS_Btn - 75
		//управление громкостью мультирум
		} else
		if(THIS_Source >= iSrc_Sonix_1_1 && THIS_Source <= iSrc_iPort_Anna) {
		    l_Device = g_vdvaAudio[THIS_Room]
		    l_iBtn = THIS_Btn
		}
	    }
	    case iZone_Guest_1:
	    case iZone_Guest_2:
	    case iZone_Playroom:
	    case iZone_Robik:
	    case iZone_Anna_Bedroom:
	    case iZone_Billiard:
	    {
		//управление громкостью ТВ
		if(THIS_Source >= iSrc_TV && THIS_Source <= iSrc_Base_3 || This_Source == iSrc_AppleTV) {
		    l_Device = g_vdvaTV[THIS_Room] 
		    l_iBtn = THIS_Btn - 75
		
		//управление громкостью мультирум
		} else
		if(THIS_Source >= iSrc_Sonix_1_1 && THIS_Source <= iSrc_iPort_Anna) {
		    l_Device = vdvMultiroom
		    l_iBtn = THIS_Btn
		}
	    }
	    case iZone_Bedroom:
	    {
		l_Device = g_vdvaAudio[THIS_Room]
		l_iBtn = THIS_Btn
	    }
	    //Зоны где управляется громкость ТВ и Линн Юнидиск
	    case iZone_Dining:
	    case iZone_Sigar:
	    case iZone_Anna_Living:
	    {
		l_Device = g_vdvaAudio[THIS_Room]
		l_iBtn = THIS_Btn
	    }
	    //зоны только мультирум
	    case iZone_Cabinet:
	    case iZone_Massage:
	    case iZone_Yard:
	    {
		if(THIS_Source >= iSrc_Sonix_1_1 && THIS_Source <= iSrc_iPort_Anna) {
		    l_Device = vdvMultiroom
		    l_iBtn = THIS_Btn
		}
	    }
	    case iZone_Cinema:
	    {
		l_Device = vdvYamaha_Cinema
		l_iBtn = THIS_Btn
	    }
	    case iZone_Lounge:
	    {
		if(THIS_Source >= 1 && THIS_Source <= 10 || This_Source == iSrc_AppleTV) {
		    l_Device = vdvTV_Lounge
		    l_iBtn = THIS_Btn - 75
		} else {
		    l_device = vdvMultiroom
		    l_iBtn = THIS_Btn
		}
	    }
	}
	
	if(l_iPulse) {
	    if(l_Device != vdvMultiroom)
		pulse[l_Device, l_iBtn]
	    l_iPulse = 0
	} else {
	    switch(THIS_Push) {
		case _push: 	{ 
			    if(l_Device != vdvMultiroom) {
				on[l_Device, l_iBtn] 
			    } else {
				if(l_iBtn == 97) send_command vdvMultiroom, "'VOLUME_UP ', itoa(g_iaZoneMRoomOutputs[THIS_Room]),';'"
				if(l_iBtn == 98) send_command vdvMultiroom, "'VOLUME_DOWN ', itoa(g_iaZoneMRoomOutputs[THIS_Room]),';'"
				if(l_iBtn == 99) send_command vdvMultiroom, "'MUTE ', itoa(g_iaZoneMRoomOutputs[THIS_Room]),';'"
			    }
		}
		case _release: 	{ 
			    if(l_Device != vdvMultiroom) {
				off[l_Device, l_iBtn]
			    } else {
				if(l_iBtn == 97) send_command vdvMultiroom, "'VOLUME_STOP ', itoa(g_iaZoneMRoomOutputs[THIS_Room]),';'"
				if(l_iBtn == 98) send_command vdvMultiroom, "'VOLUME_STOP ', itoa(g_iaZoneMRoomOutputs[THIS_Room]),';'"
			    }
		}
	    }
	}
    }
}

define_function fnZoneOff(integer in_iRoom)
{    
    local_var integer src_sum;
    
    // обновим панель Lutron
    if(in_iRoom == 2) {
	fnLutronKeypadsFb(2, 0)
	fnLutronKeypadsFb(3, 0)
    } else {
	fnLutronKeypadsFb(in_iRoom, 0)
    }

    src_sum = 0;
    //выключение ТВ
    if(g_vdvaTV[in_iRoom] != 0)
	fnCmd(g_vdvaTV[in_iRoom], 'SET_POWER OFF;')
    
    //выключение зоны мультирум
    if(g_iaZoneMRoomOutputs[in_iRoom] > 0)
	fnMultiRoom(g_iaZoneMRoomOutputs[in_iRoom], 0)
    //выключение Linn устройств
    if(g_vdvaAudio[in_iRoom])
	send_command g_vdvaAudio[in_iRoom], 'SET_POWER OFF;'
    //выключение источника если он нигде не выбран
    
    //Atlona Check
    for(i = 1; i <= MAX_ZONES; i++)
	src_sum = src_sum + m_aZones[i].m_iSourceFb;
	
    if(src_sum == 0) {
	fnAtlonaControl('OFF;')
	_master_av = 0;
    }
}

define_function fnProcessSourceSelect(integer in_iRoom, integer in_iSource, integer tp)
{
    local_var integer l_iOldSource, use
    local_var char l_caTV_Input[10], l_caAtlona_In[2], l_caAtlona_Out[2]
 
				    //if((src >= 11 && src <= 30) || src == 0) {
					//fnProcessSourceSelect(THIS_Room, src, tp)
				    //} else {


    fnStr(0, "'fnProcessSourceSelect'")
    fnStr(0, "'in_iRoom - ', itoa(in_iRoom)")
    fnStr(0, "'in_iSource - ', itoa(in_iSource)")
    
    if(![vdvAtlona_16x16, 255] && ( ( (in_iSource > 0 && in_iSource <= 10) || in_iSource == iSrc_AppleTV ) || ( (in_iRoom == iZone_Dining || in_iRoom == iZone_Bedroom) && ((in_iSource >= 11 && in_iSource <= 30) ||  in_iSource == iSrc_AppleTV)  ))) {
	fnStr(0, "'ATLONA OFF'")
	g_iAtlonaOnStart = 1
	// обновим панель Lutron
	if(in_iRoom == 2) {
	    fnLutronKeypadsFb(2, 1)
	    fnLutronKeypadsFb(3, 1)
	} else {
	    fnLutronKeypadsFb(in_iRoom, 1)
	}
	//fnLutronKeypadsFb(in_iRoom, 1)
	
	send_command g_dvaPanels, '@PPN-_ZoneMsg_PleaseWait'
	
	fnAtlonaControl('SET_POWER ON;')
	
	wait_until ([vdvAtlona_16x16, 255]) 'src_select' {
	    wait 50 'waiting_for_a_while' {
		fnProcessSourceSelect(in_iRoom, in_iSource, tp)
		
		// обновим панель Lutron
		if(in_iRoom == 2) {
		    fnLutronKeypadsFb(2, 0)
		    fnLutronKeypadsFb(3, 0)
		} else {
		    fnLutronKeypadsFb(in_iRoom, 0)
		}
		//fnLutronKeypadsFb(in_iRoom, 0)
		g_iAtlonaOnStart = 0
		send_command g_dvaPanels, '@PPF-_ZoneMsg_PleaseWait'
	    }
	}
    } else {
	
	send_command g_dvaPanels, '@PPF-_ZoneMsg_PleaseWait'
	g_iAtlonaOnStart = 0
	fnStr(0, "'ATLONA ON'")
	fnStr(0, "'in_iRoom - ', itoa(in_iRoom)")
	fnStr(0, "'in_iSource - ', itoa(in_iSource)")
	fnStr(0, "'in_iOldSource - ', itoa(m_aZones[in_iRoom].m_iOldSource)")
 
	m_aZones[in_iRoom].m_iOldSource = m_aZones[in_iRoom].m_iSourceFb
	m_aZones[in_iRoom].m_iSourceFb = in_iSource

	fnStr(0, "'--in_iRoom - ', itoa(in_iRoom)")
	fnStr(0, "'--in_iSource - ', itoa(in_iSource)")
	fnStr(0, "'--in_iOldSource - ', itoa(m_aZones[in_iRoom].m_iOldSource)")
	
	l_iOldSource = m_aZones[in_iRoom].m_iOldSource
	fnStr(0, "'---in_iOldSource - ', itoa(l_iOldSource)")
	
	// обновим панель Lutron
	if(in_iRoom == 2) {
	   fnLutronKeypadsFb(2, 0)
	   fnLutronKeypadsFb(3, 0)
	} else {
	    fnLutronKeypadsFb(in_iRoom, 0)
	}
	
	if(in_iSource > 0)
	{
	    _master_av = 1;
	    
	    Send_To_Panel, "'@PPF-_ZoneMsg-ShowDuneSources'"
	    Send_To_Panel, "'@PPF-_ZoneMsg-ShowSatSources'"
	    Send_To_Panel, "'@PPF-_ZoneMsg-ShowAppleTVSources'"
	    
	    l_caAtlona_In = g_caAtlonaInputs[in_iSource]
	    l_caAtlona_Out = g_caAtlonaZones[in_iRoom]
	    
	    if(l_iOldSource && l_iOldSource != in_iSource) {
	    fnStr(0, "'fnRemoveSourceFromZoneUsage'")
		use = fnRemoveSourceFromZoneUsage(in_iRoom, l_iOldSource)
		//if(!use)
		    //fnCmd( g_vdvaSources[l_iOldSource], 'SET_POWER OFF;' )
	    }
	    
	    // пометим как используемый в данной зоне
	    fnStr(0, "'fnAddZoneToSourceUsage'")
	    fnAddZoneToSourceUsage(in_iRoom, in_iSource)

	    //переключение входов Атлоны
	    if(l_caAtlona_In != '')// && l_caAtlona_Out != '' && l_caAtlona_Out != 'none' )
		fnAtlonaControl("'SET_INPUT ', l_caAtlona_In, ',', l_caAtlona_Out, ';'")
		//fnCmd(vdvAtlona_16x16, "'SET_INPUT ', l_caAtlona_In, ',', l_caAtlona_Out, ';'")
		
	    //включение спутникового ресивера
	    if(in_iSource == iSrc_Sat_1 || in_iSource == iSrc_Sat_2)
		fnCmd( g_vdvaSources[in_iSource], 'SET_POWER ON;' )
		
	    //включение/выключение системы мультирум
	    if(g_iaZoneMRoomOutputs[in_iRoom] > 0)
		fnMultiRoom(g_iaZoneMRoomOutputs[in_iRoom], g_iaZoneMRoomInputs[in_iRoom][in_iSource])
	    
	    //
	    if(in_iRoom == iZone_Cinema) {
		fnCinemaSourceSelect(in_iSource, tp)
	    } else
	    if(in_iRoom == iZone_Lounge) {
		//
		fnSalonSourceSelect(in_iSource, tp)
		
	    } else {		
		if( length_string(g_caSource_Names[in_iSource]) > 0 ) {
		    Send_To_Panel, "'@PPN-Source_', g_caSource_Names[in_iSource],'_Control;Main_Source'"
		    Send_To_Panel, "'@PPN-Popup_Back;Main_Source'"
		}
		
		l_caTV_Input = g_caZoneTVInputs[in_iRoom][in_iSource]
		//включение/выключение телевизора на выбранный режим
		if(l_caTV_Input != '' && l_caTV_Input != 'none')
		    fnCmd(g_vdvaTV[in_iRoom], "'SET_INPUT ', l_caTV_Input, ';'")
		else
		    fnCmd(g_vdvaTV[in_iRoom], 'SET_POWER OFF;')
		
		//включение/выключение устройств Linn Unidisk/ClassikMovie
		if(g_caZoneLinnInputs[in_iRoom][in_iSource] != '') {
		    if(g_vdvaAudio[in_iRoom])
			fnCmd( g_vdvaAudio[in_iRoom], "'SET_INPUT ', g_caZoneLinnInputs[in_iRoom][in_iSource],';'" )
		} else {
		    if(g_vdvaAudio[in_iRoom])
			fnCmd( g_vdvaAudio[in_iRoom], 'SET_POWER OFF;' )
		}
		
		if(in_iRoom == iZone_Sigar && in_iSource == iSrc_BluRay)
		    fnCmd( vdvBD_Sigar, 'SET_POWER ON;' )
	    }
	    //включение выбранного источника + добавление статуса "Используется"
	    
	    //выключение предыдущего источника если он не используется
	    
	    //Update Tuner Presets
	    if(in_iSource >= 20 && in_iSource <= 25)
		if(tp) fnUpdatePreset(tp)
		
	    //Panels Update
	    if(tp)
		for(Panel_Count_3 = 1; Panel_Count_3 <= MAX_PANELS; Panel_Count_3++) {
		    fnProcessPanelUpdate(Panel_Count_3)
	    }
	} else {
	    //check if any panel control this Room, go to Room Main Page
	    if(tp)
		for(Panel_Count_4 = 1; Panel_Count_4 <= MAX_PANELS; Panel_Count_4++) {
		    //send_string 0, "'CHEK PANEL FOR UPDATE (OFF) = ', itoa(Panel_Count_4)"
		    //send_string 0, "'PANEL OK! ROOM OFF = ', itoa(THIS_Room)"
		    if(m_aPanels[Panel_Count_4].m_iZoneFb == THIS_Room) {
			if(THIS_Btn != 1199) {
			    fnBackButton(Panel_Count_4)
			} else {
			    fnCmd(THIS_Panel, "'@PPF-_Zone_Off_fromMain'")
			    fnProcessPanelUpdate(Panel_Count_4)
			}
		    }
		    if(m_aPanels[Panel_Count_4].m_iZoneFb != THIS_Room) {
			fnProcessPanelUpdate(Panel_Count_4)
		    }
		}
	    
	    //off old source if not use in another Room
	    if(m_aZones[in_iRoom].m_iOldSource) {
		use = fnRemoveSourceFromZoneUsage(in_iRoom, m_aZones[in_iRoom].m_iOldSource)
		//if(!use)
		    //send_command g_vdvaSources[m_aZones[in_iRoom].m_iOldSource], 'SET_POWER OFF;'
	    }
	    //
	    if(in_iRoom == iZone_Cinema) {
		fnCinemaSourceSelect(0, tp)
	    } else
	    if(in_iRoom == iZone_Lounge) {
		fnSalonSourceSelect(0, tp)
	    } else {
		//zone off
		fnZoneOff(in_iRoom)
	    }
	}
    }
}
define_function fnProcessPanelControl(integer tp)
{
    local_var src

	fnStr(0, "'fnProcessPanelControl(', itoa(tp),'), This_Btn - ', itoa(THIS_Btn),', PUSH - ', itoa(THIS_Push)")
    
    if(THIS_Btn == 1000) {
	if(THIS_Push == _release) {
	    THIS_Room = 0
	    fnProcessPanelUpdate(tp)
	}
    } else
    //кнопки выбора зоны 1001 - 1030
    if(THIS_Btn >= 1001 && THIS_Btn <= 1030) {
	switch(THIS_Push)
	{
	    case _push:		{
				    //to[THIS_Panel, THIS_Btn]
				    THIS_Room = THIS_Btn - 1000
				 break;
				 }
	    case _release:	{
				    if(!THIS_LongPush) {
					
					fnCmd(THIS_Panel, "'@PPA-Main_Source'")
					fnCmd(THIS_Panel, "'PAGE-Main_Source'")
					fnCmd(THIS_Panel, "'@PPN-', g_caZone_Names[THIS_Room], '_Main;Main_Source'")
					fnCmd(THIS_Panel, "'@PPN-', g_caZone_Names[THIS_Room], '_Control;Main_Source'")
					fnCmd(THIS_Panel, "'@PPN-Volume_Footer;Main_Source'")
					fnCmd(THIS_Panel, "'@PPN-Popup_Home;Main_Source'")
					
					fnProcessPanelUpdate(tp)
				    }
				 break;
				 }
	    case _hold:		{
				    if(THIS_HoldCount == 2) {
					Send_To_Panel, "'^TXT-2,0,', m_aZones[THIS_Room].m_cName"
					Send_To_Panel, "'@PPN-_Zone_Off_fromMain'"
				    }
				 break;
				 }
	}
    } else
    //кнопки выбора источника
    if(THIS_Btn >= 1100 && THIS_Btn <= (1100 + MAX_SOURCES)) {
	switch(THIS_Push)
	{
	    case _push:		{
				 break;
				}
	    case _release:	{
				    src = THIS_Btn - 1100
				    fnProcessSourceSelect(THIS_Room, src, tp)
				 break;
				}
	    case _hold:		{
				 break;
				}
	}
    } else
    //кнопки управления выбранным источником 1 - 80
    if(THIS_Btn >= 1 && THIS_Btn <= 80) {
	fnSourceControl(tp)
    } else
    //кнопки управления громкостью
    if(THIS_Btn >= 97 && THIS_Btn <= 99) {
	fnVolumeControl(tp)
    } else
    // Sound System DSP control
    if(THIS_Btn >= 190 && THIS_Btn <= 240) {
	if(THIS_Push == _push)
	    on [g_vdvaAudio[THIS_Room], THIS_Btn]
	if(THIS_Push == _release)
	    off[g_vdvaAudio[THIS_Room], THIS_Btn]
    } else
    //zone control buttons (light climat etc)
    if(THIS_Btn >= 901 && THIS_Btn <= 910) {
	if(THIS_Push == _release)
	    fnRoomControlPopups(tp)
    } else
    //tv projector select
    if(THIS_Btn >= 912 && THIS_Btn <= 918) {
	//
	if(THIS_Push == _release)
	    fnCinemaSourceSelect(THIS_Source, tp)
    } else
    //SAT Reset
    if(THIS_Btn == 920) {
	//
	if(THIS_Push == _release)
	    fnCmd(vdvUPS_Server, 'RESET_OUTLET 3;')
    } else
    //Linn Surround Control
    if(THIS_Btn >= 921 && THIS_Btn <= 930) {
	if(THIS_Push == _release)
	    fnLinnSurroundControl(tp)
    } else
    //Projector Video Format Control
    if(THIS_Btn >= 931 && THIS_Btn <= 940) {
	if(THIS_Push == _release)
	    switch(This_Btn - 930)
	    {
		case 1: send_command vdvProjector, 'SET_VIDEO ANIME;' break;
		case 2: send_command vdvProjector, 'SET_VIDEO STAGE;' break;
		case 3: send_command vdvProjector, 'SET_VIDEO CINEMA;' break;
		case 4: send_command vdvProjector, 'SET_VIDEO FILM;' break;
		case 5: send_command vdvProjector, 'SET_VIDEO NATURAL;' break;
		case 6: send_command vdvProjector, 'SET_VIDEO THX;' break;
		case 7: send_command vdvProjector, 'SET_VIDEO USER;' break;
	    }
    } else
    //Master Light + AV
    if(THIS_Btn == 941) {
	if(THIS_Push == _push)
	    fnMASTER_Off()
	
    } else
    //Master Light
    if(THIS_Btn == 942) {
	if(THIS_Push == _push)
	    fnMASTER_Light()
	
    } else
    //Master AV
    if(THIS_Btn == 943) {
	if(THIS_Push == _push)
	    fnMASTER_AV()
	
    } else
    // Show/Hide audioSettings
    if(THIS_Btn == 944) {
	if(THIS_Push == _push) {
	    if(THIS_Room == iZone_Cinema){
		pulse[THIS_Panel, 2003]
	    } else
	    if(
		THIS_Room == iZone_Kitchen ||
		THIS_Room == iZone_Pool ||
		THIS_Room == iZone_Gym ||
		THIS_Room == iZone_Bedroom ||
		THIS_Room == iZone_Bathroom ||
		THIS_Room == iZone_Foyer
	    ){
		pulse[THIS_Panel, 2001]
	    }
	    
	    fnUpdateAudioSettings(tp)
	}
    } else
    // кнопки выбора источников с приоритетом
    if(THIS_Btn >= 951 && THIS_Btn <= 960) {
	if(THIS_Push == _release && !THIS_LongPush) {
	    switch(THIS_Btn - 950)
	    {
		case 1: {// select Dune
		    fnSelect_DuneHD_to_Zone(tp, THIS_Room)
		break;
		}
		case 2: {// select SAT
		    fnSelect_SAT_to_Zone(tp, THIS_Room)
		break;
		}
		case 3: {// select Apple TV
		    fnStr(0, "'fnSelect_AppleTV_to_Zone(', itoa(tp),',', itoa(THIS_Room),')'")
		    fnSelect_AppleTV_to_Zone(tp, THIS_Room)
		break;
		}
	    }
	} else
	if(THIS_HoldCount == 2) {
	    switch(THIS_Btn - 950)
	    {
		case 1: {// select Dune
		    Send_To_Panel, '@PPN-_ZoneMsg-ShowDuneSources'
		    //обновим занятость источников
		    for(i = iSrc_Dune_1; i <= iSrc_Dune_3; i++) {
			fnSendSourceUsageToPanel(tp, i)
		    }
		break;
		}
		case 2: {// select SAT
		    Send_To_Panel, '@PPN-_ZoneMsg-ShowSatSources'
		    //обновим занятость источников
		    for(i = iSrc_Sat_1; i <= iSrc_Sat_2; i++) {
			fnSendSourceUsageToPanel(tp, i)
		    }
		break;
		}
		case 3: {// select Apple TV
		    Send_To_Panel, '@PPN-_ZoneMsg-ShowAppleTVSources'
		    //обновим занятость источников
		    fnSendSourceUsageToPanel(tp, iSrc_AppleTV)
		    fnSendSourceUsageToPanel(tp, iSrc_AppleTV_2)
		    
		break;
		}
		    
	    }
	}
    } else
    //кнопка Back...
    if(THIS_Btn == 999) {
	if(THIS_Push == _release)
	    fnBackButton(tp)
    } else
    //
    if(THIS_Btn == 1199) {
	if(THIS_Push == _release) {
	    fnProcessSourceSelect(THIS_Room, 0, tp)
	}
    }
}

define_function fnMASTER_Off()
{
    fnMASTER_AV()
    fnMASTER_Light()
}

define_function fnMASTER_Light()
{
    send_command vdvLutron_2, "'PASSTHRU-KBDT,[02:05:12],6',13,10"
}

define_function fnMASTER_AV()
{
    if(timeline_active(tl_master_off)) {
	timeline_kill(tl_master_off)
	timeline_create(tl_master_off, m_laTL_Master, length_array(m_laTL_Master), timeline_relative, timeline_once)
    } else {
	timeline_create(tl_master_off, m_laTL_Master, length_array(m_laTL_Master), timeline_relative, timeline_once)
    }
}


define_function fnLinnSurroundControl(integer tp)
{
    local_var
	integer l_iBtn
	integer l_iPulse //if need pulse[dv,command]
	dev l_Device
    
    CHECK_Room
    {
	l_Device = g_vdvaAudio[THIS_Room]
	
	if(l_Device != 0)
	    pulse[l_Device, THIS_Btn - 820]
    }
    /*
	    case 101: fnSURR_Stereo()
	    case 102: fnSURR_StereoSub()
	    case 103: fnSURR_3Stereo()
	    case 104: fnSURR_ASMIX()
	    case 105: fnSURR_DTS()
	    case 106: fnSURR_Phantom()
    */
}
// THIS FUNCTION CONVERTS A NUMBER IN AN OLD RANGE TO A NUMBER IN A NEW RANGE. IT TAKES
// AS PARAMETERS THE NUMBER WE WANT TO CONVERT, THE OLD RANGE OF THIS NUMBER, AND 
// THE NEW RANGE WE WANT THE NEW NUMBER (CONVERTED) TO BE IN. THE FUNCTION RETURNS THE NEW NUMBER or
// IF INCORRECT VALUES ARE ENTERED THE FUNCTION RETURNS THE NEW MAX OR NEW MIN DEPENDING ON THE VALUE PASSED
DEFINE_FUNCTION integer fnCONVERT(integer oldNUM, integer oldMIN, integer oldMAX, integer newMIN, integer newMAX)
{
    integer  oldSTEPS
    integer  newSTEPS
    integer  position1
    integer  position2
    if(oldMIN<oldMAX && newMIN<newMAX && oldNUM>=oldMIN && oldNUM<=oldMAX) //  if everything is the way it should...
        {
            oldSTEPS=oldMAX-oldMIN // remember the number of steps in the old range
            newSTEPS=newMAX-newMIN // remember the number of steps in the new range
            position1=oldNUM-oldMIN  // get the position of the number in the old range
            position2=(position1*newSTEPS/oldSTEPS) // get the position of the number in the new range
            return (newMIN+position2)
       }
    else if(oldNUM<oldMIN)
       return newMIN
    else if(oldNUM>oldMAX)
       return newMAX
}

(***********************************************************)
(*                STARTUP CODE GOES BELOW                  *)
(***********************************************************)

define_function integer fnCheckSourceUsage(integer in_iRoom, integer in_iSource)
{
    if(m_aSource[in_iSource].m_iSelected)
	return true
    else
	return false
}

define_function fnAddZoneToSourceUsage(integer in_iZone, integer in_iSource)
{
    local_var
	char l_caUsageArray[100][10]
	integer l_iZoneCount, i, zone, count
	char l_caSourceInUse[100]
	char l_caZone_Name[20]
	char l_caSource_Name[20]
    
    zone = false
    
    l_caZone_Name = m_aZones[in_iZone].m_cName
    l_caSource_Name = m_aSource[in_iSource].m_cName
    
    l_caSourceInUse = m_aSource[in_iSource].m_caInUse
    
    if(length_string(l_caSourceInUse)) {
	// <1><2><3><4><5>	
	while(length_string(l_caSourceInUse))
	{
	    if(find_string(l_caSourceInUse, '>', 1)) {
		count++
		l_caUsageArray[count] = remove_string(l_caSourceInUse, '>', 1)
	    }
	}
	
	debug("'Zone Count = ', itoa(count)")
	
	for(i = 1; i <= count; i++) {
	    debug("'Use[', itoa(i),'] - ', l_caUsageArray[count]")
	    if(l_caUsageArray[count] == "'<',itoa(in_iZone),'>'")
		zone = true
	}
	
	if(zone) {   
	    //source alredy in use
	    debug("'Source ', l_caSource_Name,' Alredy In Use - In Zone ', l_caZone_Name")
	} else {
	    m_aSource[in_iSource].m_caInUse = "m_aSource[in_iSource].m_caInUse,'<',itoa(in_iZone),'>'"
	    m_aSource[in_iSource].m_iSelected = 1
	    debug("'Add Source ', l_caSource_Name,' to Zone ', l_caZone_Name")
	}
    } else {
	m_aSource[in_iSource].m_caInUse = "'<',itoa(in_iZone),'>'"
	m_aSource[in_iSource].m_iSelected = 1
    }
}

define_function integer fnRemoveSourceFromZoneUsage(integer in_iZone, integer in_iSource)
{
    local_var
	integer l_iaUsageArray[20]
	integer l_iZoneCount, i, pos
    
    if(length_string(m_aSource[in_iSource].m_caInUse)) {
	
	pos = find_string(m_aSource[in_iSource].m_caInUse, "'<',itoa(in_iZone),'>'", 1)
	
	if(pos) {
	    remove_string(m_aSource[in_iSource].m_caInUse, "'<',itoa(in_iZone),'>'", pos)
	    
	    if(length_string(m_aSource[in_iSource].m_caInUse) == 0) {
		m_aSource[in_iSource].m_iSelected = 0
		return false
	    } else {
		return true
	    }
	}
    } else {
	m_aSource[in_iSource].m_iSelected = 0
	return false
    }
}

// char <12> = integer 12
define_function integer fnGetZoneNum(char in_caZone[])
{
    remove_string(in_caZone, '<',1)
    set_length_string(in_caZone, length_string(in_caZone) - 1)
    debug("'fnGetZoneNum = ', in_caZone")
    return atoi(in_caZone)
}

define_function integer fnSendSourceUsageToPanel(integer tp, integer in_iSource)
{
    local_var
	char l_caUsageArray[12][10]
	integer l_iZoneCount, i, zone, count, n
	char l_caSourceInUse[100]
	char sPacket[256]
    
    zone = false
    
    l_caSourceInUse = m_aSource[in_iSource].m_caInUse
	
    if(length_string(m_aSource[in_iSource].m_caInUse)) {
	// <1><2><3><4><5>	
	while(length_string(l_caSourceInUse))
	{
	    if(find_string(l_caSourceInUse, '>', 1)) {
		count++
		l_caUsageArray[count] = remove_string(l_caSourceInUse, '>', 1)
	    }
	}
		
	for(i = 1; i <= count; i++) {
	    sPacket = "sPacket, m_aZones[fnGetZoneNum(l_caUsageArray[i])].m_cName, $0A"
	}
	
	//Send_To_Panel, "'^TXT-', itoa(100 + in_iSource), ',0,', sPacket"
	Send_To_Panel, "'^TXT-', itoa(100 + in_iSource), ',0, '"
    } else {
	//Send_To_Panel, "'^TXT-', itoa(100 + in_iSource), ',0,...'"
	Send_To_Panel, "'^TXT-', itoa(100 + in_iSource), ',0, '"
	return false
    }
}


define_function fnSelect_DuneHD_to_Zone(integer tp, integer in_iZone)
{
    local_var 
	integer l_iaSrcArray[3], i, l_bRun, count, l_iMaxSources
	integer l_iSource
	integer l_iOldSource
    
    l_bRun = 1
    l_iMaxSources = 3
    
    l_iaSrcArray[1] = iSrc_Dune_1
    l_iaSrcArray[2] = iSrc_Dune_2
    l_iaSrcArray[3] = iSrc_Dune_3
    
    l_iSource = m_aZones[in_iZone].m_iSourceFb
    
    if( fnCheckSourceUsage(in_iZone, l_iaSrcArray[1]) &&
	fnCheckSourceUsage(in_iZone, l_iaSrcArray[2]) &&
	fnCheckSourceUsage(in_iZone, l_iaSrcArray[3]) ) {

	if( l_iSource == l_iaSrcArray[1] ||
	    l_iSource == l_iaSrcArray[2] ||
	    l_iSource == l_iaSrcArray[3] ) {
	    
	    fnProcessSourceSelect(THIS_Room, l_iSource, tp)
	} else {
	    fnSend(tp, '@PPN-_ZoneMsg-ShowDuneSources')
	    
	    for(i = 1; i <= l_iMaxSources; i++) {
		fnSendSourceUsageToPanel(tp, l_iaSrcArray[i])
	    }
	}
    } else {
	if( l_iSource == l_iaSrcArray[1] ||
	    l_iSource == l_iaSrcArray[2] ||
	    l_iSource == l_iaSrcArray[3] ) {
	    
	    fnProcessSourceSelect(THIS_Room, l_iSource, tp)
	} else {
	    while(l_bRun)
	    {
		count++
		if(count == (l_iMaxSources + 1)) count = 1
	    
		if(m_aSource[l_iaSrcArray[count]].m_iSelected == 0) {
		    fnProcessSourceSelect(THIS_Room, iSrc_Dune_1 - 1 + count, tp)
		    l_bRun = 0
		    break
		}
	    }
	}
    }
}
define_function fnSelect_SAT_to_Zone(integer tp, integer in_iZone)
{
    local_var 
	integer l_iaSrcArray[2], i, l_bRun, count, l_iMaxSources
	integer l_iSource
	integer l_iOldSource
    
    l_bRun = 1
    l_iMaxSources = 2
        
    l_iaSrcArray[1] = iSrc_Sat_1
    l_iaSrcArray[2] = iSrc_Sat_2
    
    l_iSource = m_aZones[in_iZone].m_iSourceFb
    
    if( fnCheckSourceUsage(in_iZone, l_iaSrcArray[1]) &&
	fnCheckSourceUsage(in_iZone, l_iaSrcArray[2]) ) {

	if( l_iSource == l_iaSrcArray[1] ||
	    l_iSource == l_iaSrcArray[2] ) {
	    
	    fnProcessSourceSelect(THIS_Room, l_iSource, tp)
	} else {
	    fnSend(tp, '@PPN-_ZoneMsg-ShowSatSources')
	    for(i = 1; i <= l_iMaxSources; i++)
		fnSendSourceUsageToPanel(tp, l_iaSrcArray[i])
	}
    } else {
	if( l_iSource == l_iaSrcArray[1] ||
	    l_iSource == l_iaSrcArray[2] ) {
	    
	    fnProcessSourceSelect(THIS_Room, l_iSource, tp)
	} else {
	    while(l_bRun)
	    {
		count++
		if(count == (l_iMaxSources + 1)) count = 1
	    
		if(m_aSource[l_iaSrcArray[count]].m_iSelected == 0) {
		    fnProcessSourceSelect(THIS_Room, iSrc_Sat_1 - 1 + count, tp)
		    l_bRun = 0
		    break
		}
	    }
	}
    }
}
define_function fnSelect_AppleTV_to_Zone(integer tp, integer in_iZone)
{
     
    //stack_var integer l_iaSrcArray[2], i, l_bRun, count, l_iMaxSources
    //stack_var integer l_iSource
    //stack_var integer l_iOldSource
    
    fnStr(0, "'START fnSelect_AppleTV_to_Zone'")
    
    //l_bRun = 1
    //l_iMaxSources = 2
        
    //l_iaSrcArray[1] = iSrc_AppleTV
    //l_iaSrcArray[2] = iSrc_AppleTV_2
    
    //l_iSource = m_aZones[in_iZone].m_iSourceFb
    
    fnSend(tp, '@PPN-_ZoneMsg-ShowAppleTVSources')
    /*
    if( fnCheckSourceUsage(in_iZone, l_iaSrcArray[1]) &&
	fnCheckSourceUsage(in_iZone, l_iaSrcArray[2]) ) {

	if( l_iSource == l_iaSrcArray[1] ||
	    l_iSource == l_iaSrcArray[2] ) {
	    
	    fnProcessSourceSelect(THIS_Room, l_iSource, tp)
	} else {
	    fnSend(tp, '@PPN-_ZoneMsg-ShowAppleTVSources')
	    for(i = 1; i <= l_iMaxSources; i++)
		fnSendSourceUsageToPanel(tp, l_iaSrcArray[i])
	}
    } else {
	if( l_iSource == l_iaSrcArray[1] ||
	    l_iSource == l_iaSrcArray[2] ) {
	    fnStr(0,"'GO TO APPLE TV fnProcessSourceSelect'")
	    fnProcessSourceSelect(THIS_Room, l_iSource, tp)
	} else {
	    while(l_bRun)
	    {
		count++
		if(count == (l_iMaxSources + 1)) count = 1
		fnStr(0,"'WHILE fnProcessSourceSelect Count = ', itoa(count)")
		
		if(m_aSource[l_iaSrcArray[count]].m_iSelected == 0) {
		    fnStr(0,"'fnProcessSourceSelect(', itoa(THIS_Room),',', itoa(l_iaSrcArray[count]),',', itoa(tp),')'")
		    fnProcessSourceSelect(THIS_Room, l_iaSrcArray[count], tp)
		    l_bRun = 0
		    break
		}
	    }
	}
    }
    */
}
/*
define_function fnSelect_DF_Movies_to_Zone(integer tp, integer in_iZone)
{
    local_var 
	integer l_iaSrcArray[3], i, l_bRun, count, l_iMaxSources
	integer l_iSource
	integer l_iOldSource
    
    l_bRun = 1
    l_iMaxSources = 3
    
    l_iaSrcArray[1] = iSrc_Base_1
    l_iaSrcArray[2] = iSrc_Base_2
    l_iaSrcArray[3] = iSrc_Base_3
    
    l_iSource = m_aZones[in_iZone].m_iSourceFb
    
    if( fnCheckSourceUsage(in_iZone, l_iaSrcArray[1]) &&
	fnCheckSourceUsage(in_iZone, l_iaSrcArray[2]) &&
	fnCheckSourceUsage(in_iZone, l_iaSrcArray[3]) ) {

	if( l_iSource == l_iaSrcArray[1] ||
	    l_iSource == l_iaSrcArray[2] ||
	    l_iSource == l_iaSrcArray[3] ) {
	    
	    fnProcessSourceSelect(THIS_Room, l_iSource, tp)
	} else {
	    fnSend(tp, '@PPN-_ZoneMsg-ShowDFMoviesSources')
	    for(i = 1; i <= l_iMaxSources; i++)
		fnSendSourceUsageToPanel(tp, l_iaSrcArray[i])
	}
    } else {
	if( l_iSource == l_iaSrcArray[1] ||
	    l_iSource == l_iaSrcArray[2] ||
	    l_iSource == l_iaSrcArray[3] ) {
	    
	    fnProcessSourceSelect(THIS_Room, l_iSource, tp)
	} else {
	    while(l_bRun)
	    {
		count++
		if(count == (l_iMaxSources + 1)) count = 1
	    
		if(m_aSource[l_iaSrcArray[count]].m_iSelected == 0) {
		    fnProcessSourceSelect(THIS_Room, iSrc_Base_1 - 1 + count, tp)
		    l_bRun = 0
		    break
		}
	    }
	}
    }
}
*/
define_function fnSelect_DF_Music_to_Zone(integer tp, integer in_iZone)
{
    local_var 
	integer l_iaSrcArray[9], i, l_bRun, count, l_iMaxSources
	integer l_iSource
	integer l_iOldSource
    
    l_bRun = 1
    l_iMaxSources = 9
    
    l_iaSrcArray[1] = iSrc_Sonix_1_1
    l_iaSrcArray[2] = iSrc_Sonix_1_2
    l_iaSrcArray[3] = iSrc_Sonix_1_3
    l_iaSrcArray[4] = iSrc_Sonix_2_1
    l_iaSrcArray[5] = iSrc_Sonix_2_2
    l_iaSrcArray[6] = iSrc_Sonix_2_3
    l_iaSrcArray[7] = iSrc_Sonix_3_1
    l_iaSrcArray[8] = iSrc_Sonix_3_2
    l_iaSrcArray[9] = iSrc_Sonix_3_3
    
    l_iSource = m_aZones[in_iZone].m_iSourceFb
    
    if( fnCheckSourceUsage(in_iZone, l_iaSrcArray[1]) &&
	fnCheckSourceUsage(in_iZone, l_iaSrcArray[2]) &&
	fnCheckSourceUsage(in_iZone, l_iaSrcArray[3]) &&
	fnCheckSourceUsage(in_iZone, l_iaSrcArray[4]) &&
	fnCheckSourceUsage(in_iZone, l_iaSrcArray[5]) &&
	fnCheckSourceUsage(in_iZone, l_iaSrcArray[6]) &&
	fnCheckSourceUsage(in_iZone, l_iaSrcArray[7]) &&
	fnCheckSourceUsage(in_iZone, l_iaSrcArray[8]) &&
	fnCheckSourceUsage(in_iZone, l_iaSrcArray[9]) ) {

	if( l_iSource == l_iaSrcArray[1] ||
	    l_iSource == l_iaSrcArray[2] ||
	    l_iSource == l_iaSrcArray[3] ||
	    l_iSource == l_iaSrcArray[4] ||
	    l_iSource == l_iaSrcArray[5] ||
	    l_iSource == l_iaSrcArray[6] ||
	    l_iSource == l_iaSrcArray[7] ||
	    l_iSource == l_iaSrcArray[8] ||
	    l_iSource == l_iaSrcArray[9] ) {
	    
	    fnProcessSourceSelect(THIS_Room, l_iSource, tp)
	} else {
	    fnSend(tp, '@PPN-_ZoneMsg-ShowDFMusicSources')
	    for(i = 1; i <= l_iMaxSources; i++)
		fnSendSourceUsageToPanel(tp, l_iaSrcArray[i])
	}
    } else {
	if( l_iSource == l_iaSrcArray[1] ||
	    l_iSource == l_iaSrcArray[2] ||
	    l_iSource == l_iaSrcArray[3] ||
	    l_iSource == l_iaSrcArray[4] ||
	    l_iSource == l_iaSrcArray[5] ||
	    l_iSource == l_iaSrcArray[6] ||
	    l_iSource == l_iaSrcArray[7] ||
	    l_iSource == l_iaSrcArray[8] ||
	    l_iSource == l_iaSrcArray[9] ) {
	
	    fnProcessSourceSelect(THIS_Room, l_iSource, tp)
	} else {
	    while(l_bRun)
	    {
		count++
		if(count == (l_iMaxSources + 1)) count = 1
	    
		if(m_aSource[l_iaSrcArray[count]].m_iSelected == 0) {
		    fnProcessSourceSelect(THIS_Room, iSrc_Sonix_1_1 - 1 + count, tp)
		    l_bRun = 0
		    break
		}
	    }
	}
    }
}

define_function fnAtlonaControl(char in_caState[])
{
    if(in_caState == 'OFF;') {
	
	if(timeline_active(TL_Atlona_Check)) {
	    timeline_kill(TL_Atlona_Check)
	    timeline_create(TL_Atlona_Check, m_laTL_AtLONA, 1, timeline_absolute, timeline_once)
	} else {
	    timeline_create(TL_Atlona_Check, m_laTL_AtLONA, 1, timeline_absolute, timeline_once)
	}
    } else {
	if(timeline_active(TL_Atlona_Check))
	    timeline_kill(TL_Atlona_Check)
	
	fnCmd(vdvAtlona_16x16, in_caState)
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

define_function fnPanelsOnlineUpdate()
{
    local_var integer p
    for(p = 1; p <= MAX_PANELS; p++) {
	if(m_aPanels[p].m_iOnline)
	    [g_dvaPanels[p], 998] = m_aPanels[p].m_iOnline
    }
}

define_function fnUpdateAudioSettings(integer tp)
{
    if(THIS_Room)
    {
	if(m_aZones[THIS_Room].m_iSourceFb)
	{
	    [This_Panel, 203] = m_aZones[THIS_Room].m_sSoundSystem.m_iClearVoice
	    [This_Panel, 204] = m_aZones[THIS_Room].m_sSoundSystem.m_iBassExtension
	    [This_Panel, 205] = m_aZones[THIS_Room].m_sSoundSystem.m_iDirect
	    [This_Panel, 206] = m_aZones[THIS_Room].m_sSoundSystem.m_iEnhancer
	    [This_Panel, 219] = m_aZones[THIS_Room].m_sSoundSystem.m_iPureDirect
	    [This_Panel, 222] = m_aZones[THIS_Room].m_sSoundSystem.m_iStraight
	    [This_Panel, 223] = m_aZones[THIS_Room].m_sSoundSystem.m_iYpaoVolume
	    [This_Panel, 234] = m_aZones[THIS_Room].m_sSoundSystem.m_iAdaptiveDRC
	    [This_Panel, 235] = m_aZones[THIS_Room].m_sSoundSystem.m_iAdaptiveDSP
	    
	    send_command THIS_Panel, "'^TXT-213,0,',ftoa(m_aZones[THIS_Room].m_sEqualizer.m_fHigh)"//High
	    send_command THIS_Panel, "'^TXT-211,0,',ftoa(m_aZones[THIS_Room].m_sEqualizer.m_fMid)"//Mid
	    send_command THIS_Panel, "'^TXT-209,0,',ftoa(m_aZones[THIS_Room].m_sEqualizer.m_fLow)"//Low
	    send_command THIS_Panel, "'^TXT-217,0,',format('%2.1f', m_aZones[THIS_Room].m_sSoundSystem.m_fBass)"//Bass
	    send_command THIS_Panel, "'^TXT-215,0,',format('%2.1f', m_aZones[THIS_Room].m_sSoundSystem.m_fTreble)"//Treble
	    send_command THIS_Panel, "'^TXT-200,0,',m_aZones[THIS_Room].m_sSoundSystem.m_caSoundProgram"//Sound Program
	    send_command THIS_Panel, "'^TXT-220,0,',ftoa(m_aZones[THIS_Room].m_sSoundSystem.m_fDialogueLevel)"
	    
	    send_command THIS_Panel, "'^TXT-201,0,',format('%2.1f', m_aZones[THIS_Room].m_sSoundSystem.m_fSubLvl)"//Subwoofer
	    send_command THIS_Panel, "'^TXT-224,0,',format('%2.1f', m_aZones[THIS_Room].m_sSoundSystem.m_fCenterLvl)"//Center 
	    send_command THIS_Panel, "'^TXT-230,0,',format('%2.1f', m_aZones[THIS_Room].m_sSoundSystem.m_fSurrLvl)"//Surround
	    send_command THIS_Panel, "'^TXT-226,0,',format('%2.1f', m_aZones[THIS_Room].m_sSoundSystem.m_fFrontLvl)"//Front
	}
    }
}

define_function fnPanelVolumeUpdate(integer tp)
{
    float l_fBass
    float l_fTreable
    float l_fCenter
    float l_fSub
    float l_fSurr
    
    if(THIS_Room) {
	send_level THIS_Panel, 1, m_aZones[THIS_Room].m_sSoundSystem.m_fVol
	[THIS_Panel, 99] = m_aZones[THIS_Room].m_sSoundSystem.m_fMute
	
	l_fBass 	= m_aZones[THIS_Room].m_sSoundSystem.m_fBass
	l_fTreable 	= m_aZones[THIS_Room].m_sSoundSystem.m_fTreble
	l_fCenter 	= m_aZones[THIS_Room].m_sSoundSystem.m_fCenterLvl
	l_fSub 		= m_aZones[THIS_Room].m_sSoundSystem.m_fSubLvl
	l_fSurr 	= m_aZones[THIS_Room].m_sSoundSystem.m_fSurrLvl
	
	
	if(THIS_Room == iZone_Bedroom) {
	    
	    if(!l_fBass) 	l_fBass 	= 40
	    if(!l_fTreable) 	l_fTreable 	= 40
	    if(!l_fCenter) 	l_fCenter 	= 40
	    if(!l_fSub) 	l_fSub 		= 40
	    
	    fnCmd(THIS_Panel, "'^TXT-4,0,', format('%+2.1f dB', ((l_fBass - 40)/2) )")
	    fnCmd(THIS_Panel, "'^TXT-5,0,', format('%+2.1f dB', ((l_fTreable - 40)/2) )")
	    fnCmd(THIS_Panel, "'^TXT-6,0,', format('%+2.1f dB', ((l_fCenter - 40)/2) )")
	    fnCmd(THIS_Panel, "'^TXT-7,0,', format('%+2.1f dB', ((l_fSub - 40)/2) )")
	    
	    fnCmd(THIS_Panel, "'^TXT-8,0,',  m_aZones[THIS_Room].m_sSoundSystem.m_caDSP_Preset ")
	    fnCmd(THIS_Panel, "'^TXT-9,0,',  m_aZones[THIS_Room].m_sSoundSystem.m_caSurrDecoder ")
	    //fnCmd(THIS_Panel, "'^TXT-10,0,', m_aZones[THIS_Room].m_sSoundSystem.m_caBeamMode ")
	    
	    [THIS_Panel, 215] = ( find_string(m_aZones[THIS_Room].m_sSoundSystem.m_caBeamMode, '5BEAM', 1) == 1 );
	    [THIS_Panel, 216] = ( find_string(m_aZones[THIS_Room].m_sSoundSystem.m_caBeamMode, 'ST+3BEAM', 1) == 1 );
	    [THIS_Panel, 217] = ( find_string(m_aZones[THIS_Room].m_sSoundSystem.m_caBeamMode, '3BEAM', 1) == 1 );
	    [THIS_Panel, 218] = ( find_string(m_aZones[THIS_Room].m_sSoundSystem.m_caBeamMode, 'STEREO', 1) == 1 );
	}
    }
}

DEFINE_START

timeline_create(tl_panels_update, m_laTL_PanelUpdate, 1, timeline_absolute, timeline_repeat)

set_pulse_time(1)
//fnAtlonaControl('OFF;');

//zone names
m_aZones[iZone_Anna_Bedroom].m_cName = 'Anna Bedroom'
m_aZones[iZone_Anna_Bedroom].m_iSoundFrom = _SoundFrom_TV
m_aZones[iZone_Anna_Living].m_cName = 'Anna Living'
m_aZones[iZone_Anna_Living].m_iSoundFrom = _SoundFrom_MR
m_aZones[iZone_Bathroom].m_cName = 'Bathroom'
m_aZones[iZone_Bathroom].m_iSoundFrom = _SoundFrom_MR
m_aZones[iZone_Bedroom].m_cName = 'Bedroom'
m_aZones[iZone_Bedroom].m_iSoundFrom = _SoundFrom_TV
m_aZones[iZone_Billiard].m_cName = 'Billiards'
m_aZones[iZone_Billiard].m_iSoundFrom = _SoundFrom_TV
m_aZones[iZone_Cabinet].m_cName = 'Office'
m_aZones[iZone_Cabinet].m_iSoundFrom = _SoundFrom_MR
m_aZones[iZone_Cinema].m_cName = 'Cinema'
m_aZones[iZone_Cinema].m_iSoundFrom = _SoundFrom_TV
m_aZones[iZone_Dining].m_cName = 'Dining Room'
m_aZones[iZone_Dining].m_iSoundFrom = _SoundFrom_TV
m_aZones[iZone_Foyer].m_cName = 'Main Hall'
m_aZones[iZone_Foyer].m_iSoundFrom = _SoundFrom_MR
m_aZones[iZone_Guest_1].m_cName = 'Guestroom 1'
m_aZones[iZone_Guest_1].m_iSoundFrom = _SoundFrom_TV
m_aZones[iZone_Guest_2].m_cName = 'Guestroom 2'
m_aZones[iZone_Guest_2].m_iSoundFrom = _SoundFrom_TV
m_aZones[iZone_Gym].m_cName = 'Fitness'
m_aZones[iZone_Gym].m_iSoundFrom = _SoundFrom_TV
m_aZones[iZone_Kitchen].m_cName = 'Kitchen'
m_aZones[iZone_Kitchen].m_iSoundFrom = _SoundFrom_TV
m_aZones[iZone_Lounge].m_cName = 'Salon'
m_aZones[iZone_Lounge].m_iSoundFrom = _SoundFrom_MR
m_aZones[iZone_Massage].m_cName = 'Massage'
m_aZones[iZone_Massage].m_iSoundFrom = _SoundFrom_MR
m_aZones[iZone_Playroom].m_cName = 'Playroom'
m_aZones[iZone_Playroom].m_iSoundFrom = _SoundFrom_TV
m_aZones[iZone_Pool].m_cName = 'Pool'
m_aZones[iZone_Pool].m_iSoundFrom = _SoundFrom_TV
m_aZones[iZone_Robik].m_cName = 'Robert Bedroom'
m_aZones[iZone_Robik].m_iSoundFrom = _SoundFrom_MR
m_aZones[iZone_Sigar].m_cName = 'Oriental Relax'
m_aZones[iZone_Sigar].m_iSoundFrom = _SoundFrom_TV
m_aZones[iZone_Yard].m_cName = 'CourtYard'
m_aZones[iZone_Yard].m_iSoundFrom = _SoundFrom_MR
//Source Name
m_aSource[iSrc_ATV_Local].m_cName = 'Apple TV Local'
m_aSource[iSrc_Base_2].m_cName = 'Movie 2'
m_aSource[iSrc_Base_3].m_cName = 'Movie 3'
m_aSource[iSrc_BluRay].m_cName = 'Blu-Ray Player'
m_aSource[iSrc_Dune_1].m_cName = 'Dune HD 1'
m_aSource[iSrc_Dune_2].m_cName = 'Dune HD 2'
m_aSource[iSrc_Dune_3].m_cName = 'Dune HD 3'
m_aSource[iSrc_AppleTV_2].m_cName = 'Apple TV 2'
m_aSource[iSrc_Karaoke_1].m_cName = 'Karaoke AST'
m_aSource[iSrc_Karaoke_2].m_cName = 'Karaoke MBoy'
m_aSource[iSrc_Linn_DS].m_cName = 'Linn DS'
//m_aSource[iSrc_Local_iPod].m_cName = 'iPod Music'
m_aSource[iSrc_Radio_1].m_cName = 'Radio'
m_aSource[iSrc_Radio_2].m_cName = 'Radio'
m_aSource[iSrc_Radio_3].m_cName = 'Radio'
m_aSource[iSrc_Radio_4].m_cName = 'Radio'
m_aSource[iSrc_Radio_5].m_cName = 'Radio'
m_aSource[iSrc_Radio_6].m_cName = 'Radio'
m_aSource[iSrc_Sat_1].m_cName = 'SAT 1'
m_aSource[iSrc_Sat_2].m_cName = 'SAT 2'
m_aSource[iSrc_Sonix_1_1].m_cName = 'Music Server'
m_aSource[iSrc_Sonix_1_2].m_cName = 'Music Server'
m_aSource[iSrc_Sonix_1_3].m_cName = 'Music Server'
m_aSource[iSrc_Sonix_2_1].m_cName = 'Music Server'
m_aSource[iSrc_Sonix_2_2].m_cName = 'Music Server'
m_aSource[iSrc_Sonix_2_3].m_cName = 'Music Server'
m_aSource[iSrc_Sonix_3_1].m_cName = 'Music Server'
m_aSource[iSrc_Sonix_3_2].m_cName = 'Music Server'
m_aSource[iSrc_Sonix_3_3].m_cName = 'Music Server'
m_aSource[iSrc_Sony_PS3].m_cName = 'Sony PS3'
m_aSource[iSrc_TV].m_cName = 'TV'
m_aSource[iSrc_Unidisk].m_cName = 'Linn DVD'
m_aSource[iSrc_iPort_Anna].m_cName 	= 'iPod Music'
m_aSource[iSrc_iPort_Dining].m_cName 	= 'iPod Music'
m_aSource[iSrc_iPort_Lounge].m_cName 	= 'iPod Music'
m_aSource[iSrc_iPort_Massage].m_cName 	= 'AirPlay'
m_aSource[iSrc_iPort_Sigar].m_cName 	= 'iPod Music'
m_aSource[iSrc_AppleTV].m_cName 	= 'Apple TV 1'
m_aSource[iSrc_AppleTV4KCinema].m_cName 	= 'Apple TV 4K'
//m_aSource[iSrc_DVD].m_cName = 'DVD Player'

//Starting modules here
//Atlona
fnCmd(vdvAtlona_16x16, 'START;')
//Dune
fnCmd(vdvDune_1, 'START;')
fnCmd(vdvDune_2, 'START;')
fnCmd(vdvDune_3, 'START;')
//fnCmd(vdvDune_4, 'START;')

//DH MR
send_command vdvMultiroom, 'START;'

//Lutron
fnCmd(vdvLutron_2, 'CONNECT;')
//GlobalCache
fnCmd(vdvGC_1_1, 'START;')
fnCmd(vdvGC_2_1, 'START;')
fnCmd(vdvGC_3_1, 'START;')
//fnCmd(vdvGC_4_1, 'START;')
fnCmd(vdvGC_5_1, 'START;')
//fnCmd(vdvGC_6_1, 'START;')
//fnCmd(vdvGC_7_1, 'START;')
fnCmd(vdvGC_8_1, 'START;')
fnCmd(vdvGC_9_1, 'START;')
fnCmd(vdvGC_10_1, 'START;') //Master bEDRoom
fnCmd(vdvGC_11_1, 'START;')

//Moxa
//fnCmd(vdvMoxa_1_1, 'START;')
//fnCmd(vdvMoxa_2_1, 'START;')
//fnCmd(vdvMoxa_3_1, 'START;')
//fnCmd(vdvMoxa_4_1, 'START;')
fnCmd(vdvMoxa_6_1, 'START;')
//
fnCmd(vdvProjector, 'START;')
fnCmd(vdvYamaha_Cinema, 'START;')
fnCmd(vdvYamaha_Oriental, 'START;')
fnCmd(vdvYamaha_Master, 'START;')
fnCmd(vdvYamaha_Pool, 'START;')
fnCmd(vdvYamaha_Bathroom, 'START;')
fnCmd(vdvYamaha_Fitness, 'START;')
fnCmd(vdvYamaha_Kitchen, 'START;')
fnCmd(vdvYamaha_Hall, 'START;')
fnCmd(vdvYamaha_Yard, 'START;')
//
fnCmd(vdvAPC_Karaoke, 'START;')
fnCmd(vdvUPS_Server, 'START;')

                            
//подключаемые модули
//GlobalCache
DEFINE_MODULE 'GlobalCache_iTouch_IP2IR'	modGC_1	(g_vdvaGC_1, dvGC_IP2IR_1, g_caHost_GC_IP2IR_1, m_iaGC_Shift_1)
DEFINE_MODULE 'GlobalCache_iTouch_IP2IR'	modGC_2	(g_vdvaGC_2, dvGC_IP2IR_2, g_caHost_GC_IP2IR_2, m_iaGC_Shift_2)
DEFINE_MODULE 'GlobalCache_iTouch_IP2IR'	modGC_3	(g_vdvaGC_3, dvGC_IP2IR_3, g_caHost_GC_IP2IR_3, m_iaGC_Shift_3)
//DEFINE_MODULE 'GlobalCache_iTouch_IP2IR'	modGC_4	(g_vdvaGC_4, dvGC_IP2IR_4, g_caHost_GC_IP2IR_4, m_iaGC_Shift_4)
DEFINE_MODULE 'GlobalCache_iTouch_IP2IR'	modGC_5	(g_vdvaGC_5, dvGC_IP2IR_5, g_caHost_GC_IP2IR_5, m_iaGC_Shift_5)
//DEFINE_MODULE 'GlobalCache_iTouch_IP2IR'	modGC_6	(g_vdvaGC_6, dvGC_IP2IR_6, g_caHost_GC_IP2IR_6, m_iaGC_Shift_6)
//DEFINE_MODULE 'GlobalCache_iTouch_IP2IR'	modGC_7	(g_vdvaGC_7, dvGC_IP2IR_7, g_caHost_GC_IP2IR_7, m_iaGC_Shift_7)
DEFINE_MODULE 'GlobalCache_iTouch_IP2IR'	modGC_8	(g_vdvaGC_8, dvGC_IP2IR_8, g_caHost_GC_IP2IR_8, m_iaGC_Shift_8)
DEFINE_MODULE 'GlobalCache_iTouch_IP2IR'	modGC_9	(g_vdvaGC_9, dvGC_IP2IR_9, g_caHost_GC_IP2IR_9, m_iaGC_Shift_9)
DEFINE_MODULE 'GlobalCache_iTouch_IP2IR'	modGC_10(g_vdvaGC_10, dvGC_IP2IR_10, g_caHost_GC_IP2IR_10, m_iaGC_Shift_10)
DEFINE_MODULE 'GlobalCache_iTouch_IP2IR'	modGC_11(g_vdvaGC_11, dvGC_IP2IR_11, g_caHost_GC_IP2IR_11, m_iaGC_Shift_11)

//Lutron Communication Module
DEFINE_MODULE 'Lutron_HWI_8Series_Comm'		modLutronComm(vdvLutron_2, dvLutron_H8P5_2, g_caHost_Lutron_2, g_caLogin, g_vdvaLutron_Keypads)
//Lutron UI Module


//DH Multiroom
DEFINE_MODULE 'DigiHouse_Multiroom_Comm' 	modDigiHouse_MR(vdvMultiroom, dvMultiroom, m_caHost_MR, m_iPort, m_iInputCoil, m_iOutputCoil)

//Atlona Commutaters 
DEFINE_MODULE 'ATLONA_AT_PRO2HD1616'		modAtlona16(vdvAtlona_16x16, dvM1_RS_1, g_vdvaAtlonaPorts, g_caAtlonaPortBaud)

//Linn Classik Movie/Unidisk
DEFINE_MODULE 'Linn_Unidisk_Comm'		modLinn_1(vdvUnidisk_Dining, vdvAtlona_16x16_Port_10)
//DEFINE_MODULE 'Linn_Unidisk_Comm'		modLinn_2(vdvYamaha_Master, vdvAtlona_16x16_Port_2)
//DEFINE_MODULE 'Linn_Unidisk_Comm'		modLinn_3(vdvUnidisk_Cinema, vdvMoxa_3_1)
//DEFINE_MODULE 'Linn_Unidisk_Comm'		modLinn_4(vdvUnidisk_Salon, vdvMoxa_1_1)
//DEFINE_MODULE 'Linn_Unidisk_Comm'		modLinn_5(vdvUnidisk_Sigar, vdvMoxa_4_1)
DEFINE_MODULE 'Linn_Unidisk_Comm'		modLinn_5(vdvUnidisk_Anna_Living, vdvMoxa_6_1)
//anna


//Linn DS Player

//Projector
define_module 'Sony_VPL_IP'			modProj(vdvProjector, dvProjector, g_caHost_Projector)

//define_module 'Yamaha_RX-A2010_Comm'		modRX1(vdvYamaha_Cinema, dvYamaha_Cinema, g_caHost_Yamaha_Cinema, g_dvaYamhaRcv_Panels)

define_module 'Yamaha_YNCA_IP'			modRX2(vdvYamaha_Oriental, dvYamaha_Oriental, g_caHost_Yamaha_Oriental)
define_module 'Yamaha_YNCA_IP'			modRX3(vdvYamaha_Master, dvYamaha_Master, g_caHost_Yamaha_Master)

define_module 'Yamaha_YNCA_IP'			modYamaha_1(vdvYamaha_Bathroom, dvYamaha_Bathroom, g_caHost_Yamaha_Bathroom)
define_module 'Yamaha_YNCA_IP'			modYamaha_2(vdvYamaha_Kitchen, dvYamaha_Kitchen, g_caHost_Yamaha_Kitchen)
define_module 'Yamaha_YNCA_IP'			modYamaha_3(vdvYamaha_Pool, dvYamaha_Pool, g_caHost_Yamaha_Pool)
define_module 'Yamaha_YNCA_IP'			modYamaha_4(vdvYamaha_Fitness, dvYamaha_Fitness, g_caHost_Yamaha_Fitness)
define_module 'Yamaha_YNCA_IP'			modYamaha_5(vdvYamaha_Hall, dvYamaha_Hall, g_caHost_Yamaha_Hall)
define_module 'Yamaha_YNCA_IP'			modYamaha_6(vdvYamaha_Cinema, dvYamaha_Cinema, g_caHost_Yamaha_Cinema)
define_module 'Yamaha_YNCA_IP'			modYamaha_7(vdvYamaha_Yard, dvYamaha_Yard, g_caHost_Yamaha_Yard)
define_module 'Yamaha_YNC_IP'			modYamaha_8(vdvYamaha_Cinema, dvYamaha_Cinema_2, g_caHost_Yamaha_Cinema)

//Moxa
//define_module 'Moxa_nPort5210_Comm' 		modMoxa_01(vdvMoxa_1_1, dvMoxa_nPort5210_1_1, g_caHost_Moxa_nPort_1, g_iaMoxaPort[1])
//define_module 'Moxa_nPort5210_Comm' 		modMoxa_02(vdvMoxa_1_2, dvMoxa_nPort5210_1_2, g_caHost_Moxa_nPort_1, g_iaMoxaPort[2])
//define_module 'Moxa_nPort5210_Comm' 		modMoxa_03(vdvMoxa_2_1, dvMoxa_nPort5210_2_1, g_caHost_Moxa_nPort_2, g_iaMoxaPort[1])
//define_module 'Moxa_nPort5210_Comm' 		modMoxa_04(vdvMoxa_2_2, dvMoxa_nPort5210_2_2, g_caHost_Moxa_nPort_2, g_iaMoxaPort[2])
//define_module 'Moxa_nPort5210_Comm' 		modMoxa_05(vdvMoxa_3_1, dvMoxa_nPort5210_3_1, g_caHost_Moxa_nPort_3, g_iaMoxaPort[1])
//define_module 'Moxa_nPort5210_Comm' 		modMoxa_06(vdvMoxa_3_2, dvMoxa_nPort5210_3_2, g_caHost_Moxa_nPort_3, g_iaMoxaPort[2])
//define_module 'Moxa_nPort5210_Comm' 		modMoxa_07(vdvMoxa_4_1, dvMoxa_nPort5210_4_1, g_caHost_Moxa_nPort_4, g_iaMoxaPort[1])
//define_module 'Moxa_nPort5210_Comm' 		modMoxa_08(vdvMoxa_4_2, dvMoxa_nPort5210_4_2, g_caHost_Moxa_nPort_4, g_iaMoxaPort[2])
//define_module 'Moxa_nPort5210_Comm' 		modMoxa_09(vdvMoxa_5_1, dvMoxa_nPort5210_5_1, g_caHost_Moxa_nPort_5, g_iaMoxaPort[1])
//define_module 'Moxa_nPort5210_Comm' 		modMoxa_10(vdvMoxa_5_2, dvMoxa_nPort5210_5_2, g_caHost_Moxa_nPort_5, g_iaMoxaPort[2])
define_module 'Moxa_nPort5210_Comm' 		modMoxa_11(vdvMoxa_6_1, dvMoxa_nPort5210_6_1, g_caHost_Moxa_nPort_6, g_iaMoxaPort[1])
//define_module 'Moxa_nPort5210_Comm' 		modMoxa_12(vdvMoxa_6_2, dvMoxa_nPort5210_6_2, g_caHost_Moxa_nPort_6, g_iaMoxaPort[2])

//TV's
DEFINE_MODULE 'TV_Sony_Control'			modTV_01(vdvTV_Sigar, vdvGC_9_1, _false)
DEFINE_MODULE 'TV_Sony_Control'			modTV_02(vdvTV_Master_Bedroom, vdvGC_9_2, _false)
DEFINE_MODULE 'TV_Sony_Control'			modTV_03(vdvTV_Master_Bathroom, vdvGC_9_3, _false)
DEFINE_MODULE 'TV_Sony_Control'			modTV_04(vdvTV_Guest_1, vdvGC_1_1, _false)
DEFINE_MODULE 'TV_Sony_Control'			modTV_05(vdvTV_Guest_2, vdvGC_1_2, _false)
DEFINE_MODULE 'TV_Sony_Control'			modTV_06(vdvTV_Playroom, vdvGC_8_1, _false)
DEFINE_MODULE 'TV_Samsung_Control'		modTV_07(vdvTV_Kitchen, vdvGC_1_3, _false)
DEFINE_MODULE 'TV_Sony_Control'			modTV_08(vdvTV_Anna_Living, vdvGC_2_1, _false)
DEFINE_MODULE 'TV_Sony_Control'			modTV_09(vdvTV_Cinema, vdvGC_5_1, _false)
DEFINE_MODULE 'TV_Samsung_Control'		modTV_10(vdvTV_Dining, vdvGC_2_2, _false)
DEFINE_MODULE 'TV_Sony_Control'			modTV_11(vdvTV_Lounge, vdvGC_3_2, _false)
DEFINE_MODULE 'TV_Sony_Control'			modTV_12(vdvTV_Billiard, vdvGC_2_3, _false)
DEFINE_MODULE 'TV_Panasonic_Control'		modTV_13(vdvTV_Gym, vdvGC_3_1, _false)
//DEFINE_MODULE 'TV_Sony_Control'			modTV_14(vdvTV_Pool, vdvGC_3_2, _false)

//bluray modules
DEFINE_MODULE 'Sony_BD_Control'			modBD_1(vdvBD_Cinema, vdvGC_5_2, _false)
DEFINE_MODULE 'Sony_BD_Control'			modBD_2(vdvBD_Lounge, vdvGC_7_2, _false)
DEFINE_MODULE 'Sony_BD_Control'			modBD_3(vdvBD_Sigar, vdvGC_11_2, _false)

//SAT Control
DEFINE_MODULE 'SAT_HD_Control'			modSAT_1(vdvSAT_1, dvM1_IR_1,_false)
DEFINE_MODULE 'SAT_HD_Control'			modSAT_2(vdvSAT_2, dvM2_IR_1,_false)

//Dune Control
DEFINE_MODULE 'Dune_HD_MAX'			modDune_1(vdvDune_1, dvDuneHD_1, g_caHost_Dune_1)	
DEFINE_MODULE 'Dune_HD_MAX'			modDune_2(vdvDune_2, dvDuneHD_2, g_caHost_Dune_2)	
DEFINE_MODULE 'Dune_HD_MAX'			modDune_3(vdvDune_3, dvDuneHD_3, g_caHost_Dune_3)	
//DEFINE_MODULE 'Dune_HD_MAX'			modDune_4(vdvDune_4, dvDuneHD_4, g_caHost_Dune_4)	

//Apple TV
DEFINE_MODULE 'Apple_TV'			ATV1(vdvAppleTV, dvM1_IR_2, _false)	
DEFINE_MODULE 'Apple_TV'			ATV2(vdvAppleTV_2, dvM1_IR_1, _plus100)	
DEFINE_MODULE 'Apple_TV'			ATV2(vdvAppleTV4KCinema, vdvGC_5_3, _false)	
DEFINE_MODULE 'Apple_TV'			ATV2(vdvAppleTV_Master, vdvGC_10_1, _false)	

//UPS
DEFINE_MODULE 'APC_UPS'				modAPC_1(vdvUPS_Server, dvUPS_Server, g_caHost_UPS_Server)

//For APC PDU Switch 32A
DEFINE_MODULE 'SNMP_Module'			snmp1(vdvAPC_Karaoke, dvAPC_Karaoke, g_caHost_APC_Karaoke)



(***********************************************************)
(*                THE EVENTS GO BELOW                      *)
(***********************************************************)
DEFINE_EVENT

timeline_event[TL_PANELS_UPDATE]{
    fnPanelsOnlineUpdate()
}

timeline_event[tl_master_off]
{
    local_var
	integer tp 
	integer seq
	
    seq = timeline.sequence
    
    fnProcessSourceSelect(seq, 0, 0)
    
    if(seq == 1) {
	for(tp = 1; tp <= MAX_PANELS; tp++) {
	    if(THIS_PanelIsOnline)
		fnCmd(THIS_Panel, '@PPN-_ZoneMsg_PleaseWait')
	}
    }
    
    if(seq == MAX_ZONES) {
	for(tp = 1; tp <= MAX_PANELS; tp++) {
	    if(THIS_PanelIsOnline) {
		fnCmd(THIS_Panel, '@PPF-_ZoneMsg_PleaseWait')
		fnProcessPanelUpdate(tp)
	    }
	}
    }
}

timeline_event[TL_Atlona_Check]
{
    fnAtlonaControl('SET_POWER OFF;')
}

level_event[g_vdvaAudio, 0]
{
    stack_var integer l_iLevel,tp,upd 
    float l_fValue
    
    l_iLevel = level.input.level
    l_fValue = level.value
    
    if(l_iLevel == 1) {
	if(m_aZones[get_last(g_vdvaAudio)].m_sSoundSystem.m_fVol != l_fValue) {
	    m_aZones[get_last(g_vdvaAudio)].m_sSoundSystem.m_fVol = l_fValue
	    upd = upd + 1
	}
    }
    if(l_iLevel == 2) {
	if(m_aZones[get_last(g_vdvaAudio)].m_sSoundSystem.m_fMute != l_fValue) {
	    m_aZones[get_last(g_vdvaAudio)].m_sSoundSystem.m_fMute = l_fValue
	    upd = upd + 1
	}
    }
    if(l_iLevel == 3) {
	if(m_aZones[get_last(g_vdvaAudio)].m_sSoundSystem.m_fBass != l_fValue) {
	    m_aZones[get_last(g_vdvaAudio)].m_sSoundSystem.m_fBass = l_fValue
	    upd = upd + 1
	}
    }
    if(l_iLevel == 4) {
	if(m_aZones[get_last(g_vdvaAudio)].m_sSoundSystem.m_fTreble != l_fValue) {
	    m_aZones[get_last(g_vdvaAudio)].m_sSoundSystem.m_fTreble = l_fValue
	    upd = upd + 1
	}
    }
    if(l_iLevel == 5) {
	if(m_aZones[get_last(g_vdvaAudio)].m_sSoundSystem.m_fCenterLvl != l_fValue) {
	    m_aZones[get_last(g_vdvaAudio)].m_sSoundSystem.m_fCenterLvl = l_fValue
	    upd = upd + 1
	}
    }
    if(l_iLevel == 6) {
	if(m_aZones[get_last(g_vdvaAudio)].m_sSoundSystem.m_fSubLvl != l_fValue) {
	    m_aZones[get_last(g_vdvaAudio)].m_sSoundSystem.m_fSubLvl = l_fValue
	    upd = upd + 1
	}
    }
    if(l_iLevel == 7) {
	if(m_aZones[get_last(g_vdvaAudio)].m_sSoundSystem.m_fSurrLvl != l_fValue) {
	    m_aZones[get_last(g_vdvaAudio)].m_sSoundSystem.m_fSurrLvl = l_fValue
	    upd = upd + 1
	}
    }
    if(l_iLevel == 8) {
	if(m_aZones[get_last(g_vdvaAudio)].m_sSoundSystem.m_fEnhancer != l_fValue) {
	    m_aZones[get_last(g_vdvaAudio)].m_sSoundSystem.m_fEnhancer = l_fValue
	    upd = upd + 1
	}
    }
    if(l_iLevel == 9) {
	if(m_aZones[get_last(g_vdvaAudio)].m_sSoundSystem.m_fStraight != l_fValue) {
	    m_aZones[get_last(g_vdvaAudio)].m_sSoundSystem.m_fStraight = l_fValue
	    upd = upd + 1
	}
    }
    
    if(upd)
	for(tp = 1; tp <= MAX_PANELS; tp++)
	    fnPanelVolumeUpdate(tp)
}

data_event[g_vdvaAudio]
{
    string:
    {
	stack_var integer tp,upd
	
	if(find_string(data.text, 'DSP:', 1) == 1) {
	    remove_string(data.text, 'DSP:', 1)
	    if(m_aZones[get_last(g_vdvaAudio)].m_sSoundSystem.m_caDSP_Preset != data.text) {
		m_aZones[get_last(g_vdvaAudio)].m_sSoundSystem.m_caDSP_Preset = data.text
		upd = upd + 1
	    }
	} else
	if(find_string(data.text, 'SURRDECODER:', 1) == 1) {
	    remove_string(data.text, 'SURRDECODER:', 1)
	    if(m_aZones[get_last(g_vdvaAudio)].m_sSoundSystem.m_caSurrDecoder != data.text) {
		m_aZones[get_last(g_vdvaAudio)].m_sSoundSystem.m_caSurrDecoder = data.text
		upd = upd + 1
	    }
	} else
	if(find_string(data.text, 'BEAMMODE:', 1) == 1) {
	    remove_string(data.text, 'BEAMMODE:', 1)
	    if(m_aZones[get_last(g_vdvaAudio)].m_sSoundSystem.m_caBeamMode != data.text) {
		m_aZones[get_last(g_vdvaAudio)].m_sSoundSystem.m_caBeamMode = data.text
		upd = upd + 1
	    }
	}else
	if(find_string(data.text, 'SOUND_PROGRAM:', 1) == 1) {
	    remove_string(data.text, 'SOUND_PROGRAM:', 1)
	    if(m_aZones[get_last(g_vdvaAudio)].m_sSoundSystem.m_caSoundProgram != data.text) {
		m_aZones[get_last(g_vdvaAudio)].m_sSoundSystem.m_caSoundProgram = data.text
		for(tp = 1; tp <= MAX_PANELS; tp++){
		    fnUpdateAudioSettings(tp)
		}
	    }
	} else
	if(find_string(data.text, 'SURROUND_DECODER:', 1) == 1) {
	    remove_string(data.text, 'SURROUND_DECODER:', 1)
	    if(m_aZones[get_last(g_vdvaAudio)].m_sSoundSystem.m_caSurroundDecoder != data.text) {
		m_aZones[get_last(g_vdvaAudio)].m_sSoundSystem.m_caSurroundDecoder = data.text
		upd = upd + 1
	    }
	} else
	if(find_string(data.text, 'CENTER_VOLUME:', 1) == 1) {
	    remove_string(data.text, 'CENTER_VOLUME:', 1)
	    if(m_aZones[get_last(g_vdvaAudio)].m_sSoundSystem.m_fCenterLvl != atof(data.text)){
		m_aZones[get_last(g_vdvaAudio)].m_sSoundSystem.m_fCenterLvl = atof(data.text)
		upd = upd + 1
	    }
	} else
	if(find_string(data.text, 'SURROUND_VOLUME:', 1) == 1) {
	    remove_string(data.text, 'SURROUND_VOLUME:', 1)
	    if(m_aZones[get_last(g_vdvaAudio)].m_sSoundSystem.m_fSurrLvl != atof(data.text)){
		m_aZones[get_last(g_vdvaAudio)].m_sSoundSystem.m_fSurrLvl = atof(data.text)
		upd = upd + 1
	    }
	} else
	if(find_string(data.text, 'FRONT_VOLUME:', 1) == 1) {
	    remove_string(data.text, 'FRONT_VOLUME:', 1)
	    if(m_aZones[get_last(g_vdvaAudio)].m_sSoundSystem.m_fFrontLvl != atof(data.text)){
		m_aZones[get_last(g_vdvaAudio)].m_sSoundSystem.m_fFrontLvl = atof(data.text)
		upd = upd + 1
	    }
	} else
	if(find_string(data.text, 'SUBWOOFER_VOLUME:', 1) == 1) {
	    remove_string(data.text, 'SUBWOOFER_VOLUME:', 1)
	    if(m_aZones[get_last(g_vdvaAudio)].m_sSoundSystem.m_fSubLvl != atof(data.text)){
		m_aZones[get_last(g_vdvaAudio)].m_sSoundSystem.m_fSubLvl = atof(data.text)
		upd = upd + 1
	    }
	} else
	if(find_string(data.text, 'BALANCE:', 1) == 1) {
	    remove_string(data.text, 'BALANCE:', 1)
	    /*
	    if(m_aZones[get_last(g_vdvaAudio)].m_sSoundSystem.m_fSubLvl != atof(data.text)){
		m_aZones[get_last(g_vdvaAudio)].m_sSoundSystem.m_fSubLvl = atof(data.text)
		upd = upd + 1
	    }
	    */
	} else
	if(find_string(data.text, 'TONE_CONTROL_BASS:', 1) == 1) {
	    remove_string(data.text, 'TONE_CONTROL_BASS:', 1)
	    if(m_aZones[get_last(g_vdvaAudio)].m_sSoundSystem.m_fBass != atof(data.text)){
		m_aZones[get_last(g_vdvaAudio)].m_sSoundSystem.m_fBass = atof(data.text)
		upd = upd + 1
	    }
	} else
	if(find_string(data.text, 'TONE_CONTROL_TREBLE:', 1) == 1) {
	    remove_string(data.text, 'TONE_CONTROL_TREBLE:', 1)
	    if(m_aZones[get_last(g_vdvaAudio)].m_sSoundSystem.m_fTreble != atof(data.text)){
		m_aZones[get_last(g_vdvaAudio)].m_sSoundSystem.m_fTreble = atof(data.text)
		upd = upd + 1
	    }
	} else
	if(find_string(data.text, 'EQUALIZER_HIGH:', 1) == 1) {
	    remove_string(data.text, 'EQUALIZER_HIGH:', 1)
	    if(m_aZones[get_last(g_vdvaAudio)].m_sEqualizer.m_fHigh != atof(data.text)){
		m_aZones[get_last(g_vdvaAudio)].m_sEqualizer.m_fHigh = atof(data.text)
		upd = upd + 1
	    }
	} else
	if(find_string(data.text, 'EQUALIZER_MID:', 1) == 1) {
	    remove_string(data.text, 'EQUALIZER_MID:', 1)
	    if(m_aZones[get_last(g_vdvaAudio)].m_sEqualizer.m_fMid != atof(data.text)){
		m_aZones[get_last(g_vdvaAudio)].m_sEqualizer.m_fMid = atof(data.text)
		upd = upd + 1
	    }
	} else
	if(find_string(data.text, 'EQUALIZER_LOW:', 1) == 1) {
	    remove_string(data.text, 'EQUALIZER_LOW:', 1)
	    if(m_aZones[get_last(g_vdvaAudio)].m_sEqualizer.m_fLow != atof(data.text)){
		m_aZones[get_last(g_vdvaAudio)].m_sEqualizer.m_fLow = atof(data.text)
		upd = upd + 1
	    }
	} else
	if(find_string(data.text, 'DIALOGUE_LEVEL', 1) == 1) {
	    remove_string(data.text, 'DIALOGUE_LEVEL:', 1)
	    if(m_aZones[get_last(g_vdvaAudio)].m_sSoundSystem.m_fDialogueLevel != atof(data.text)){
		m_aZones[get_last(g_vdvaAudio)].m_sSoundSystem.m_fDialogueLevel = atof(data.text)
		upd = upd + 1
	    }
	}
	
	if(upd > 0){
	    for(tp = 1; tp <= MAX_PANELS; tp++){
		fnUpdateAudioSettings(tp)
	    }
	}
    }
}

channel_event[g_vdvaAudio, 103]
{
    on:{
	stack_var integer tp
	if(m_aZones[get_last(g_vdvaAudio)].m_sSoundSystem.m_iClearVoice != 1) {
	    m_aZones[get_last(g_vdvaAudio)].m_sSoundSystem.m_iClearVoice = 1
	    for(tp = 1; tp <= MAX_PANELS; tp++){
		fnUpdateAudioSettings(tp)
	    }
	}
    }
    off:{
	stack_var integer tp
	if(m_aZones[get_last(g_vdvaAudio)].m_sSoundSystem.m_iClearVoice != 0) {
	    m_aZones[get_last(g_vdvaAudio)].m_sSoundSystem.m_iClearVoice = 0
	    for(tp = 1; tp <= MAX_PANELS; tp++){
		fnUpdateAudioSettings(tp)
	    }
	}
    }
}
channel_event[g_vdvaAudio, 104]
{
    on:{
	stack_var integer tp
	if(m_aZones[get_last(g_vdvaAudio)].m_sSoundSystem.m_iBassExtension != 1) {
	    m_aZones[get_last(g_vdvaAudio)].m_sSoundSystem.m_iBassExtension = 1
	    for(tp = 1; tp <= MAX_PANELS; tp++){
		fnUpdateAudioSettings(tp)
	    }
	}
    }
    off:{
	stack_var integer tp,upd
	if(m_aZones[get_last(g_vdvaAudio)].m_sSoundSystem.m_iBassExtension != 0) {
	    m_aZones[get_last(g_vdvaAudio)].m_sSoundSystem.m_iBassExtension = 0
	    for(tp = 1; tp <= MAX_PANELS; tp++){
		fnUpdateAudioSettings(tp)
	    }
	}
    }
}

channel_event[g_vdvaAudio, 105]
{
    on:{
	stack_var integer tp
	if(m_aZones[get_last(g_vdvaAudio)].m_sSoundSystem.m_iDirect != 1) {
	    m_aZones[get_last(g_vdvaAudio)].m_sSoundSystem.m_iDirect = 1
	    for(tp = 1; tp <= MAX_PANELS; tp++){
		fnUpdateAudioSettings(tp)
	    }
	}
    }
    off:{
	stack_var integer tp
	if(m_aZones[get_last(g_vdvaAudio)].m_sSoundSystem.m_iDirect != 0) {
	    m_aZones[get_last(g_vdvaAudio)].m_sSoundSystem.m_iDirect = 0
	    for(tp = 1; tp <= MAX_PANELS; tp++){
		fnUpdateAudioSettings(tp)
	    }
	}
    }
}
channel_event[g_vdvaAudio, 106]
{
    on:{
	stack_var integer tp
	if(m_aZones[get_last(g_vdvaAudio)].m_sSoundSystem.m_iEnhancer != 1) {
	    m_aZones[get_last(g_vdvaAudio)].m_sSoundSystem.m_iEnhancer = 1
	    for(tp = 1; tp <= MAX_PANELS; tp++){
		fnUpdateAudioSettings(tp)
	    }
	}
    }
    off:{
	stack_var integer tp
	if(m_aZones[get_last(g_vdvaAudio)].m_sSoundSystem.m_iEnhancer != 0) {
	    m_aZones[get_last(g_vdvaAudio)].m_sSoundSystem.m_iEnhancer = 0
	    for(tp = 1; tp <= MAX_PANELS; tp++){
		fnUpdateAudioSettings(tp)
	    }
	}
    }
}
channel_event[g_vdvaAudio, 119]
{
    on:{
	stack_var integer tp
	if(m_aZones[get_last(g_vdvaAudio)].m_sSoundSystem.m_iPureDirect != 1) {
	    m_aZones[get_last(g_vdvaAudio)].m_sSoundSystem.m_iPureDirect = 1
	    for(tp = 1; tp <= MAX_PANELS; tp++){
		fnUpdateAudioSettings(tp)
	    }
	}
    }
    off:{
	stack_var integer tp
	if(m_aZones[get_last(g_vdvaAudio)].m_sSoundSystem.m_iPureDirect != 0) {
	    m_aZones[get_last(g_vdvaAudio)].m_sSoundSystem.m_iPureDirect = 0
	    for(tp = 1; tp <= MAX_PANELS; tp++){
		fnUpdateAudioSettings(tp)
	    }
	}
    }
}
channel_event[g_vdvaAudio, 122]
{
    on:{
	stack_var integer tp
	if(m_aZones[get_last(g_vdvaAudio)].m_sSoundSystem.m_iStraight != 1) {
	    m_aZones[get_last(g_vdvaAudio)].m_sSoundSystem.m_iStraight = 1
	    for(tp = 1; tp <= MAX_PANELS; tp++){
		fnUpdateAudioSettings(tp)
	    }
	}
    }
    off:{
	stack_var integer tp
	if(m_aZones[get_last(g_vdvaAudio)].m_sSoundSystem.m_iStraight != 0) {
	    m_aZones[get_last(g_vdvaAudio)].m_sSoundSystem.m_iStraight = 0
	    for(tp = 1; tp <= MAX_PANELS; tp++){
		fnUpdateAudioSettings(tp)
	    }
	}
    }
}

channel_event[g_vdvaAudio, 123]
{
    on:{
	stack_var integer tp
	if(m_aZones[get_last(g_vdvaAudio)].m_sSoundSystem.m_iYpaoVolume != 1) {
	    m_aZones[get_last(g_vdvaAudio)].m_sSoundSystem.m_iYpaoVolume = 1
	    for(tp = 1; tp <= MAX_PANELS; tp++){
		fnUpdateAudioSettings(tp)
	    }
	}
    }
    off:{
	stack_var integer tp
	if(m_aZones[get_last(g_vdvaAudio)].m_sSoundSystem.m_iYpaoVolume != 0) {
	    m_aZones[get_last(g_vdvaAudio)].m_sSoundSystem.m_iYpaoVolume = 0
	    for(tp = 1; tp <= MAX_PANELS; tp++){
		fnUpdateAudioSettings(tp)
	    }
	}
    }
}
channel_event[g_vdvaAudio, 124]
{
    on:{
	stack_var integer tp
	if(m_aZones[get_last(g_vdvaAudio)].m_sSoundSystem.m_iAdaptiveDSP != 1) {
	    m_aZones[get_last(g_vdvaAudio)].m_sSoundSystem.m_iAdaptiveDSP = 1
	    for(tp = 1; tp <= MAX_PANELS; tp++){
		fnUpdateAudioSettings(tp)
	    }
	}
    }
    off:{
	stack_var integer tp
	if(m_aZones[get_last(g_vdvaAudio)].m_sSoundSystem.m_iAdaptiveDSP != 0) {
	    m_aZones[get_last(g_vdvaAudio)].m_sSoundSystem.m_iAdaptiveDSP = 0
	    for(tp = 1; tp <= MAX_PANELS; tp++){
		fnUpdateAudioSettings(tp)
	    }
	}
    }
}
channel_event[g_vdvaAudio, 125]
{
    on:{
	stack_var integer tp
	if(m_aZones[get_last(g_vdvaAudio)].m_sSoundSystem.m_iAdaptiveDRC != 1) {
	    m_aZones[get_last(g_vdvaAudio)].m_sSoundSystem.m_iAdaptiveDRC = 1
	    for(tp = 1; tp <= MAX_PANELS; tp++){
		fnUpdateAudioSettings(tp)
	    }
	}
    }
    off:{
	stack_var integer tp
	if(m_aZones[get_last(g_vdvaAudio)].m_sSoundSystem.m_iAdaptiveDRC != 0) {
	    m_aZones[get_last(g_vdvaAudio)].m_sSoundSystem.m_iAdaptiveDRC = 0
	    for(tp = 1; tp <= MAX_PANELS; tp++){
		fnUpdateAudioSettings(tp)
	    }
	}
    }
}

(***********************************************************)
(*            THE ACTUAL PROGRAM GOES BELOW                *)
(***********************************************************)
DEFINE_PROGRAM
/*
wait 5 'pnlupd' {
    for(p = 1; p <= MAX_PANELS; p++) {
	if(m_aPanels[p].m_iOnline)
	    [g_dvaPanels[p], 998] = m_aPanels[p].m_iOnline
    }
}
*/
/*
if(TIME == '03:59:59') {
    wait 11 'time'
	fnCmd(vdvAtlona_16x16, 'SET_POWER OFF;')
}
*/

(***********************************************************)
(*                     END OF PROGRAM                      *)
(*        DO NOT PUT ANY CODE BELOW THIS COMMENT           *)
(***********************************************************)

