PROGRAM_NAME='Multiroom'

/*
	Multiroom
	    OUT					IN
	1   /-- 1 - Anna Living DAC		/-- 1 - Radio 1
	    |   2 - Bedroom DAC			|   2 - 
	    |   3 - Pool			|   3 - 
	    \-- 4 - Hall			|   4 - 
	2   /-- 5 - Yard			|   5 - 
	    |   6 - Salon Balkon		|   6 - Radio 6
	    |   7 - Dining DAC to Linn		|   7 - iPod Dining
	    \-- 8 - Oriental Sigar DAC		\-- 8 - TV Salon
	3   /-- 9 - Cinema DAC			/-- 9 - Unidisk Salon		
	    |   10 - 				|   10 - Sonix 3-3
	    |   11 - 				|   11 - AirPlay
	    \-- 12 - Salon DME			|   12 -
	4   /-- 13 - Massage			|   13 -
	    |   14 - Playroom			|   14 -
	    |   15 - Billiards			|   15 -
	    \-- 16 - Guest1			\-- 16 - iPod Sigar
	5   /-- 17 - Guest2			/-- 17 - Sonix 1-1
	    |   18 - Anna Bedroom		|   18 - Sonix 1-2
	    |   19 - Kitchen			|   19 - Sonix 1-3
	    \-- 20 - Office			|   20 - Sonix 2-1
	6   /-- 21 - Bathroom			|   21 - Sonix 2-2
	    |   22 - Robik			|   22 - Sonix 2-3
	    |   23 - Dining Table		|   23 - Sonix 3-1
	    \-- 24 - Fitness			\-- 24 - Sonix 3-2
					
	    Radio Tuners:
	    (20) 1. Massage, Pool, Gym, Oriental
	    (21) 2. Bedroom, Bathroom
	    (22) 3. Anna Liv+Bed
	    (23) 4. Guest 1,2; Billiard
	    (24) 5. Robik, Playroom
	    (25) 6. Hall, Kitchen, Dining, Yard, Salon, Cabinet, Cinema
	    
*/

DEFINE_DEVICE

//MR Panels
dvMR_Panel_1			= 10001:4:1 // 
dvMR_Panel_2			= 10002:4:1 // 
dvMR_Panel_3			= 10003:4:1 // 
dvMR_Panel_4			= 10004:4:1 // 
dvMR_Panel_5			= 10005:4:1 // 
dvMR_Panel_6			= 10006:4:1 // 
dvMR_Panel_7			= 10007:4:1 // 
dvMR_Panel_8			= 10008:4:1 // 
dvMR_Panel_9			= 10009:4:1 // 
dvMR_Panel_10			= 10010:4:1 // 
dvMR_Panel_11			= 10011:4:1 // 
dvMR_Panel_12			= 10012:4:1 // 
dvMR_Panel_13			= 10013:4:1 // 
dvMR_Panel_14			= 10014:4:1 // 
dvMR_Panel_15			= 10015:4:1 // 
dvMR_Panel_16			= 10016:4:1 // 
dvMR_Panel_17			= 10017:4:1 // 
dvMR_Panel_18			= 10018:4:1 // 
dvMR_Panel_19			= 10019:4:1 // 
dvMR_Panel_20			= 10020:4:1 // 

#if_not_defined vdvMultiroom
    vdvMultiroom = 33003:1:1
#end_if

DEFINE_CONSTANT


TL_Zone1_id			= 1
TL_Zone2_id			= 2
TL_Zone3_id			= 3
TL_Zone4_id			= 4
TL_Zone5_id			= 5
TL_Zone6_id			= 6
TL_Zone7_id			= 7
TL_Zone8_id			= 8
TL_Zone9_id			= 9
TL_Zone10_id			= 10
TL_Zone11_id			= 11
TL_Zone12_id			= 12
TL_Zone13_id			= 13
TL_Zone14_id			= 14
TL_Zone15_id			= 15
TL_Zone16_id			= 16
TL_Zone17_id			= 17
TL_Zone18_id			= 18
TL_Zone19_id			= 19
TL_Zone20_id			= 20
TL_Zone21_id			= 21
TL_Zone22_id			= 22
TL_Zone23_id			= 23
TL_Zone24_id			= 24

TL_GetBlock_1			= 30
TL_GetBlock_2			= 31
TL_GetBlock_3			= 32
TL_GetBlock_4			= 33
TL_GetBlock_5			= 34
TL_GetBlock_6			= 35

Radio_List			= 500

volatile char		g_caPresetNames[][][30] = { 
					    {'1020','Радио Рокс'},
					    {'1005','Европа Плюс'},
					    {'1053','Love Radio'},
					    {'906', 'Радио Для Двоих'},
					    {'901', 'Радио Эрмитаж'},
					    {'875', 'Дорожное Радио'},
					    {'880', 'Ретро FM'},
					    {'884', 'Авторадио'},
					    {'889', 'Юмор FM'},
					    {'893', 'Вести FM'},
					    {'897', 'Радио Зенит'}, 
					    {'911', 'Кекс FM'},
					    {'915', 'Эхо Москвы'},
					    {'929', 'Русская служба новостей'}, 
					    {'950', 'Радио Energy'},
					    {'959', 'Нева FM'},
					    {'970', 'Радио Дача'},
					    //{'986', 'Настольгия FM'},
					    {'990', 'Радио России FM'},
					    {'1009','Питер FM'},
					    //{'1014','Эльдорадио'},
					    {'1024','Метро FM'},
					    {'1028','Maximum'},
					    {'1034','DFM'},
					    {'1037','Детское Радио'},
					    {'1040','Наше Радио'},
					    {'1044','Русский Шансон'},
					    {'1048','Радио Балтика'},
					    {'1059','MonteCarlo'},
					    {'1063','Радио Рекорд'},
					    {'1070','Радио Маяк'},
					    {'1074','Бизнес FM'},
					    {'1078','Русское Радио'}
					    }

DEFINE_TYPE

structure _Multiroom_s
{
    integer m_iPower
    integer m_iStandBy
    integer m_iSource
    integer m_iVol
    integer m_iMute
    integer m_iStartVolume
    integer m_iTreble
    integer m_iBass
    integer m_iBal
    integer m_iTrim
    integer m_iTypeOfAmp // Amp = 0, DAC = 1
}

structure _MR_Radio_s
{
    integer m_iPreset
    integer m_iFreq
}

DEFINE_VARIABLE

r = 0
m = 0

volatile _Multiroom_s	MultiRoom[24]
persistent _MR_Radio_s	Radio[8]

//#define THIS_MR_ZONE
#define MR_ZONE_PWR	MultiRoom[Zone].m_iPower	
#define MR_ZONE_STBY	MultiRoom[Zone].m_iStandBy	
#define MR_SOURCE	MultiRoom[Zone].m_iSource	
#define MR_VOLUME	MultiRoom[Zone].m_iVol	
#define MR_MUTE		MultiRoom[Zone].m_iMute
#define MR_BASS		MultiRoom[Zone].m_iBass	
#define MR_TREBLE	MultiRoom[Zone].m_iTreble	
#define MR_BAL		MultiRoom[Zone].m_iBal	
#define MR_TRIM		MultiRoom[Zone].m_iTrim	


volatile long m_laZone_Off[2]			= {1, 2500}
volatile long m_laGetBlock[10]			= {250,250,250,250,250,250,250,250,250,250}


volatile integer	g_iaRoomToMR[24] 	= {16,12,8,11,21,6,2,7,
						    5,0,0,6,10,15,20,18,
						    19,17,1,4,13,14,3,9 }


volatile long 		m_laTL_Zone_IDs[24]		= { TL_Zone1_id,TL_Zone2_id,TL_Zone3_id,TL_Zone4_id,
							    TL_Zone5_id,TL_Zone6_id,TL_Zone7_id,TL_Zone8_id,
							    TL_Zone9_id,TL_Zone10_id,TL_Zone11_id,TL_Zone12_id,
							    TL_Zone13_id,TL_Zone14_id,TL_Zone15_id,TL_Zone16_id,
							    TL_Zone17_id,TL_Zone18_id,TL_Zone19_id,TL_Zone20_id,
							    TL_Zone21_id,TL_Zone22_id,TL_Zone23_id,TL_Zone24_id }
volatile long 		m_laTL_GetBlock[6]		= { TL_GetBlock_1,TL_GetBlock_2,TL_GetBlock_3,
							    TL_GetBlock_4,TL_GetBlock_5,TL_GetBlock_6 }

volatile dev		g_dvaMRPanels[]			= { dvMR_Panel_1, dvMR_Panel_2, dvMR_Panel_3, dvMR_Panel_4, dvMR_Panel_5,
							    dvMR_Panel_6, dvMR_Panel_7, dvMR_Panel_8, dvMR_Panel_9, dvMR_Panel_10,
							    dvMR_Panel_11, dvMR_Panel_12, dvMR_Panel_13, dvMR_Panel_14, dvMR_Panel_15,
							    dvMR_Panel_16, dvMR_Panel_17, dvMR_Panel_18, dvMR_Panel_19, dvMR_Panel_20 }


define_function fnMultiRoom(integer Zone, integer Source)
{
    local_var integer block
    
    block = (Zone - 1)/4 + 1
    
    if(Source == 0) {
	fnZone_Off(Zone)
    } else {
	if(MR_ZONE_STBY == 0 || MR_VOLUME <= 5)
	{
	    
	    if(/*Zone == 1 || */Zone == 2 || Zone == 7 /*|| Zone == 8 || Zone == 12*/) {
		send_command vdvMultiroom, "'ON ',  itoa(Zone),',',
					    itoa(Source),',',
					    itoa(MultiRoom[Zone].m_iStartVolume),',', // start volume
					    '9,',  // HF
					    '7,',  // LF
					    '7,', //Balance
					    '0;'" //TRIM
	    } else if(Zone == 1 || Zone == 8 || Zone == 9 || Zone == 11 || Zone == 12 || Zone == 13){
	    
	    } else {
		send_command vdvMultiroom, "'ON ',  itoa(Zone),',',
					    itoa(Source),',',
					    itoa(MultiRoom[Zone].m_iStartVolume),',', // start volume
					    '12,',  // HF
					    '11,',  // LF
					    '7,', //Balance
					    '0;'" //TRIM
	    }
	    
	    //tuner on                         
	    if(Source >= 1 && Source <= 6) {
		fnTuner_Control(Source, Radio[Source].m_iPreset)
		
	    }
	    
	    fnGetBlock(block)
	} else {
	    //
	    send_command vdvMultiroom, "'INPUT ', itoa(Zone),',', itoa(Source),';'"
	    //tuner on                         
	    if(Source >= 1 && Source <= 6)
		fnTuner_Control(Source, Radio[Source].m_iPreset)
	    //
	}
    }
}

define_function fnGetBlock(integer in_iBlock)
{
    if(timeline_active(m_laTL_GetBlock[in_iBlock])) {
	timeline_kill(m_laTL_GetBlock[in_iBlock])
	timeline_create(m_laTL_GetBlock[in_iBlock], m_laGetBlock, 10, timeline_relative, timeline_once)
    } else {
	timeline_create(m_laTL_GetBlock[in_iBlock], m_laGetBlock, 10, timeline_relative, timeline_once)
    }
}

define_function fnZone_Off(integer in_iRoom)
{
    if(timeline_active(m_laTL_Zone_IDs[in_iRoom])) {
	timeline_kill(m_laTL_Zone_IDs[in_iRoom])
	timeline_create(m_laTL_Zone_IDs[in_iRoom], m_laZone_Off, 2, timeline_absolute, timeline_once)
    } else {
	timeline_create(m_laTL_Zone_IDs[in_iRoom], m_laZone_Off, 2, timeline_absolute, timeline_once)
    }
}

define_function fnTuner_Control(integer in_iTuner, integer Preset)
{
    if(Preset == 0) {
	send_command vdvMultiroom, "'TUNER_OFF ', itoa(in_iTuner),';'"
    } else {
	if(Radio[in_iTuner].m_iPreset == 0) {
	    Radio[in_iTuner].m_iPreset = 17
	} else {
	    Radio[in_iTuner].m_iPreset = Preset
	    send_command vdvMultiroom, "'TUNER_ON ', itoa(in_iTuner),',', g_caPresetNames[Radio[in_iTuner].m_iPreset][1],';'"
	}
    }
}

define_function fnUpdatePreset(integer tp)
{
    local_var integer Source
	local_var integer IsOnline
    
    if(tp) IsOnline = m_aPanels[tp].m_iOnline
    
    if(IsOnline && tp) {
	if(m_aPanels[tp].m_iZoneFb) {
	    Source = m_aZones[m_aPanels[tp].m_iZoneFb].m_iSourceFb - 19
	    
	    send_command g_dvaMRPanels[tp], "'IRLB_ADD-', itoa(Radio_List),',',itoa(length_array(g_caPresetNames)),',1'"
	    send_command g_dvaMRPanels[tp], "'IRLB_SCROLL_BAR_ENABLE-', itoa(Radio_List),',1'"
	    send_command g_dvaMRPanels[tp], "'IRLB_SCROLL_BAR_COLOR-', itoa(Radio_List),',grey12'"
	    
	    for(Panel_Preset_Count = 1; Panel_Preset_Count <= length_array(g_caPresetNames); Panel_Preset_Count++) {
		send_command g_dvaMRPanels[tp], "'IRLB_ITEM_UNI-', itoa(Radio_List),',', itoa(Panel_Preset_Count),',1,', CP1251ToUNI("'  ', g_caPresetNames[Panel_Preset_Count][2]")"
		
		if(Radio[Source].m_iPreset != Panel_Preset_Count) {
		    send_command g_dvaMRPanels[tp], "'IRLB_ITEM_OPACITY-',itoa(Radio_List),',',itoa(Panel_Preset_Count),',1,180'"
		    send_command g_dvaMRPanels[tp], "'IRLB_ITEM_COLOR-',itoa(Radio_List),',',itoa(Panel_Preset_Count),',1,grey13'"
		} else {
		    send_command g_dvaMRPanels[tp], "'IRLB_ITEM_OPACITY-',itoa(Radio_List),',',itoa(Panel_Preset_Count),',1,230'"
		    send_command g_dvaMRPanels[tp], "'IRLB_ITEM_COLOR-',itoa(Radio_List),',',itoa(Panel_Preset_Count),',1,verylightaqua'"
		}
	    }
	    
	    //if(Radio[Source].m_iPreset > 9)
		//send_command g_dvaMRPanels[tp], "'IRLB_POSITION-', itoa(Radio_List),',', itoa((Radio[Source].m_iPreset/10)*10)"
	}
    }
}

define_function integer fnReturnPreset(integer in_iTuner, integer in_iPreset)
{
    if(in_iPreset == 0)
	Radio[in_iTuner].m_iPreset = length_array(g_caPresetNames)
    else if(in_iPreset == (length_array(g_caPresetNames) + 1))
	Radio[in_iTuner].m_iPreset = 1
    else
	Radio[in_iTuner].m_iPreset = in_iPreset
	
    return Radio[in_iTuner].m_iPreset
}

define_function fnMR_Off()
{
    for(r = 1; r <= 24; r++)
	fnZone_Off(r)
}

DEFINE_START

MultiRoom[01].m_iStartVolume = 63 // Anna Living DAC to Linn
MultiRoom[01].m_iTypeOfAmp = 1
MultiRoom[02].m_iStartVolume = 63 // Bedroom DAC to Linn
MultiRoom[02].m_iTypeOfAmp = 1
MultiRoom[03].m_iStartVolume = 63 // Pool DAC to Yamaha
MultiRoom[03].m_iTypeOfAmp = 0
MultiRoom[04].m_iStartVolume = 0 // Hall 
MultiRoom[04].m_iTypeOfAmp = 0
MultiRoom[05].m_iStartVolume = 30 // Yard 
MultiRoom[05].m_iTypeOfAmp = 1
MultiRoom[06].m_iStartVolume = 20 // Salon Balkon
MultiRoom[06].m_iTypeOfAmp = 0
MultiRoom[07].m_iStartVolume = 63 // Dining DAC to Linn
MultiRoom[07].m_iTypeOfAmp = 1
MultiRoom[08].m_iStartVolume = 63 // Oriental Sigar DAC to Linn
MultiRoom[08].m_iTypeOfAmp = 1
MultiRoom[09].m_iStartVolume = 63 // Cinema DAC to Yamaha
MultiRoom[09].m_iTypeOfAmp = 1
MultiRoom[10].m_iStartVolume = 0 // --
MultiRoom[10].m_iTypeOfAmp = 0
MultiRoom[11].m_iStartVolume = 0 // --
MultiRoom[11].m_iTypeOfAmp = 0
MultiRoom[12].m_iStartVolume = 15 // Valera DME 
MultiRoom[12].m_iTypeOfAmp = 1
MultiRoom[13].m_iStartVolume = 20 // Massage
MultiRoom[13].m_iTypeOfAmp = 0
MultiRoom[14].m_iStartVolume = 20 // PlayRoom
MultiRoom[14].m_iTypeOfAmp = 0
MultiRoom[15].m_iStartVolume = 20 // Biilliard
MultiRoom[15].m_iTypeOfAmp = 0
MultiRoom[16].m_iStartVolume = 20 // Guest 1
MultiRoom[16].m_iTypeOfAmp = 0
MultiRoom[17].m_iStartVolume = 20 // Guest 2
MultiRoom[17].m_iTypeOfAmp = 0
MultiRoom[18].m_iStartVolume = 20 // Anna Bedroom
MultiRoom[18].m_iTypeOfAmp = 0
MultiRoom[19].m_iStartVolume = 20 // Kitchen
MultiRoom[19].m_iTypeOfAmp = 0
MultiRoom[20].m_iStartVolume = 20 // Office
MultiRoom[20].m_iTypeOfAmp = 0
MultiRoom[21].m_iStartVolume = 20 // Bathroom
MultiRoom[21].m_iTypeOfAmp = 0
MultiRoom[22].m_iStartVolume = 20 // Robik
MultiRoom[22].m_iTypeOfAmp = 0
MultiRoom[23].m_iStartVolume = 20 // Dining Table
MultiRoom[23].m_iTypeOfAmp = 0
MultiRoom[24].m_iStartVolume = 30 // Gym
MultiRoom[24].m_iTypeOfAmp = 0

for(r = 0; r <= 8; r++) {
    if(Radio[r].m_iPreset == 0)
	Radio[r].m_iPreset = 17
}

DEFINE_EVENT

//Lists
level_event[g_dvaMRPanels, Radio_List]
{
    local_var integer tp, Source, p
	local_var long l_lValue
	
    l_lValue = level.value
    tp = get_last(g_dvaMRPanels)
    
    if(m_aPanels[tp].m_iZoneFb && (l_lValue >= 1 && l_lValue <= length_array(g_caPresetNames))) {
	
	Source = m_aZones[m_aPanels[tp].m_iZoneFb].m_iSourceFb - 19
	
	if(Source >= 1 && Source <= 6)
	    fnTuner_Control(Source, l_lValue)
	//
	for(p = 1; p <= MAX_PANELS; p++)
	    if(  m_aPanels[p].m_iOnline && 
		(m_aZones[m_aPanels[p].m_iZoneFb].m_iSourceFb >= iSrc_Radio_1 && 
		 m_aZones[m_aPanels[p].m_iZoneFb].m_iSourceFb <= iSrc_Radio_6))
		fnUpdatePreset(p)
    }

    send_level g_dvaMRPanels[tp], Radio_List, 65535
}


//timeline_event[TL_Zone1_id]
timeline_event[TL_Zone2_id]
timeline_event[TL_Zone3_id]
timeline_event[TL_Zone4_id]
timeline_event[TL_Zone5_id]
timeline_event[TL_Zone6_id]
timeline_event[TL_Zone7_id]
//timeline_event[TL_Zone8_id]
//timeline_event[TL_Zone9_id]
timeline_event[TL_Zone10_id]
//timeline_event[TL_Zone11_id]
//timeline_event[TL_Zone12_id]
//timeline_event[TL_Zone13_id]
timeline_event[TL_Zone14_id]
timeline_event[TL_Zone15_id]
timeline_event[TL_Zone16_id]
timeline_event[TL_Zone17_id]
timeline_event[TL_Zone18_id]
timeline_event[TL_Zone19_id]
timeline_event[TL_Zone20_id]
timeline_event[TL_Zone21_id]
timeline_event[TL_Zone22_id]
timeline_event[TL_Zone23_id]
timeline_event[TL_Zone24_id]
{             
    switch(timeline.sequence)
    {
	case 1:
	{
	    send_command vdvMultiroom, "'VOLUME ', itoa(timeline.id),',0;'"
	}
	case 2:
	{
	    If(MultiRoom[timeline.id].m_iTypeOfAmp)
		send_command vdvMultiroom, "'STANDBY ', itoa(timeline.id),';'"
	    else
		send_command vdvMultiroom, "'OFF ', itoa(timeline.id),';'"
	}
    }
}

timeline_event[TL_GetBlock_1]
timeline_event[TL_GetBlock_2]
timeline_event[TL_GetBlock_3]
timeline_event[TL_GetBlock_4]
timeline_event[TL_GetBlock_5]
timeline_event[TL_GetBlock_6]
{
    local_var integer id
    
    id = timeline.id - 30
    
    send_command vdvMultiroom, "'GET_BLOCK ', itoa(id), ';'"
}


data_event[vdvMultiroom]
{
    string:
    {
	local_var char m_caTmpString[100]
	local_var integer l_iCount, i
	local_var integer l_iaTemp[256]
	local_var integer Zone, l_iVolume
		
	m_caTmpString = data.text
	
	//организуем обратную связь
	select
	{
	    //CHANNEL <Zone>,<Src>,<Pwr>,<Stb>,<Vol>,<Mute>,<Bass>,<Treble>,<Bal>,<Trim>;
	    active(find_string(m_caTmpString, "'CHANNEL'", 1) == 1):
	    {
		l_iCount = fnGetArray(m_caTmpString, l_iaTemp, ',')
		if(l_iCount >= 2)
		{		    
		    Zone = l_iaTemp[1] //MR Zone
		    
		    //fb
		    MR_SOURCE		= l_iaTemp[2] //sourse
		    MR_ZONE_PWR		= l_iaTemp[3] //power state
		    MR_ZONE_STBY	= l_iaTemp[4] //standby state
		    MR_VOLUME		= l_iaTemp[5] //volume
		    MR_MUTE		= l_iaTemp[6] //mute
		    MR_BASS		= l_iaTemp[7] //bass
		    MR_TREBLE		= l_iaTemp[8] //treble
		    MR_BAL		= l_iaTemp[9] //balance
		    MR_TRIM		= l_iaTemp[10] //trim
		    
		    /*
		    if(m_aZones[g_iaRoomToMR[Zone]].m_iSoundFrom == _soundFrom_MR) {
			m_aZones[g_iaRoomToMR[Zone]].m_iVolume = fnCONVERT(MR_VOLUME, 0, 63, 0, 100)
			for(m = 1; m <= MAX_PANELS; m++) {
			    if(m_aPanels[m].m_iZoneFb == g_iaRoomToMR[Zone])
				send_level g_dvaPanels[m], 1, m_aZones[g_iaRoomToMR[Zone]].m_iVolume
			}
		    }*/
		}
	    }
	}
    }
}

data_event[g_dvaMRPanels]
{
    online: {}//fnUpdatePreset(get_last(g_dvaMRPanels))
}

button_event[g_dvaMRPanels, 0]
{
    push:
    {
	local_var integer l_iBtn
	    local_var integer l_iPanel
	    local_var integer tp
	    local_var integer Source
	    
	l_iBtn = button.input.channel
	l_iPanel = get_last(g_dvaMRPanels)
	tp = l_iPanel
	
	if(m_aPanels[l_iPanel].m_iZoneFb) {
	    Source = m_aZones[m_aPanels[l_iPanel].m_iZoneFb].m_iSourceFb - 19
	    
	    //direct preset selection
	    if(l_iBtn >= 101 && l_iBtn <= 128) {
		//to[g_dvaMRPanels[l_iPanel], l_iBtn]
		
		if(Source >= 1 && Source <= 6) {
		    fnTuner_Control(Source, l_iBtn - 100)
		    //
		for(Panel_Update_Preset = 1; Panel_Update_Preset <= MAX_PANELS; Panel_Update_Preset++)
		    fnUpdatePreset(Panel_Update_Preset)
		}
	    } else
	    //preset +
	    if(l_iBtn == 131) {
		fnTuner_Control(Source, fnReturnPreset(Source, Radio[Source].m_iPreset + 1))
	    } else
	    //preset -
	    if(l_iBtn == 132) {
		fnTuner_Control(Source, fnReturnPreset(Source, Radio[Source].m_iPreset - 1))
	    }
	}
    }
    release:
    {
	
    }
}


DEFINE_PROGRAM



