PROGRAM_NAME='Lutron_Vars'



DEFINE_DEVICE

//Lutron Processors
#if_not_defined vdvLutron_1    vdvLutron_1			= 33001:1:1 #end_if// Doesnt work, LAN broken
#if_not_defined vdvLutron_2    vdvLutron_2			= 33002:1:1 #end_if// Main Commenication


dvLutron_TP_1	= 10001:5:1
dvLutron_TP_2	= 10002:5:1
dvLutron_TP_3	= 10003:5:1
dvLutron_TP_4	= 10004:5:1
dvLutron_TP_5	= 10005:5:1
dvLutron_TP_6	= 10006:5:1
dvLutron_TP_7	= 10007:5:1
dvLutron_TP_8	= 10008:5:1
dvLutron_TP_9	= 10009:5:1
dvLutron_TP_10	= 10010:5:1
dvLutron_TP_11	= 10011:5:1
dvLutron_TP_12	= 10012:5:1
dvLutron_TP_13	= 10013:5:1
dvLutron_TP_14	= 10014:5:1
dvLutron_TP_15	= 10015:5:1
dvLutron_TP_16	= 10016:5:1
dvLutron_TP_17	= 10017:5:1
dvLutron_TP_18	= 10018:5:1
dvLutron_TP_19	= 10019:5:1
dvLutron_TP_20	= 10020:5:1


vdvKeypad_1	= 38204:5:1 // Kitchen Light - 2:5:4
vdvKeypad_2	= 38205:5:1 // Kitchen MR - 2:5:5
vdvKeypad_3	= 38223:5:1 // Dining Light - 2:5:23
vdvKeypad_4	= 38225:5:1 // Dining MR - 2:5:25
vdvKeypad_5	= 38227:5:1 // Salon Light - 2:5:27
vdvKeypad_6	= 38228:5:1 // Salon MR - 2:5:28
vdvKeypad_7	= 38112:5:1 // Oriental Light - 1:5:12
vdvKeypad_8	= 38113:5:1 // Oriental MR - 1:5:13
vdvKeypad_9	= 38208:6:1 // Bedroom Light - 2:6:8
vdvKeypad_10	= 38209:6:1 // Bedroom MR - 2:6:9
vdvKeypad_11	= 38206:6:1 // Bathroom Light - 2:6:6
vdvKeypad_12	= 38207:6:1 // Bathroom MR - 2:6:7
vdvKeypad_13	= 38218:5:1 // office light - 2:5:18
vdvKeypad_14	= 38220:5:1 // office MR - 2:5:20
vdvKeypad_15	= 38214:5:1 // Hall MR - 2:5:14
vdvKeypad_16	= 38212:5:1 // Hall Light - 2:5:12
vdvKeypad_17	= 38118:5:1 // Pool Light - 1:5:18
vdvKeypad_18	= 38120:5:1 // Pool MR - 1:5:20
vdvKeypad_19	= 38104:5:1 // Massage Light - 1:5:4 
vdvKeypad_20	= 38105:5:1 // Massage MR - 1:5:5
vdvKeypad_21	= 38101:5:1 // Fitness Light - 1:5:1
vdvKeypad_22	= 38103:5:1 // Fitness MR - 1:5:3
vdvKeypad_23	= 38200:6:1 // Robik Light - 
vdvKeypad_24	= 38220:6:1 // Robik MR - 2:6:20
vdvKeypad_25	= 38120:6:1 // Anna Liv Light - 1:6:20
vdvKeypad_26	= 38121:6:1 // Anna Liv MR - 1:6:21
vdvKeypad_27	= 38118:6:1 // Anna Bed Light - 1:6:18
vdvKeypad_28	= 38119:6:1 // Anna Bed MR - 1:6:19
vdvKeypad_29	= 38111:6:1 // Guest 1 Light - 1:6:11
vdvKeypad_30	= 38112:6:1 // Guest 1 MR - 1:6:12
vdvKeypad_31	= 38107:6:1 // Guest 2 Light - 1:6:7
vdvKeypad_32	= 38108:6:1 // Guest 2 MR - 1:6:8
vdvKeypad_33	= 38221:5:1 // Cinema Light - 2:5:21
vdvKeypad_34	= 38222:5:1 // Cinema MR - 2:5:22
vdvKeypad_35	= 38104:6:1 // Playroom Light - 1:6:4
vdvKeypad_36	= 38105:6:1 // Playroom MR - 1:6:5
vdvKeypad_37	= 38213:5:1 // Hall Light2 - 2:5:13
vdvKeypad_38	= 38217:5:1 // Hall near Cabinet - 2:5:17


vdvKeypad_39	= 38129:5:1 // Gena House Panel - 1:5:29
vdvKeypad_40	= 38224:5:1 // Dining MR 2 (TV/SAT - DUNE)
vdvKeypad_41	= 38111:5:1 // Pool glass door
vdvKeypad_42	= 38100:4:1 // 
vdvKeypad_43	= 38100:4:1 // 
vdvKeypad_44	= 38100:4:1 // 
vdvKeypad_45	= 38100:4:1 // 
vdvKeypad_46	= 38100:4:1 // 
vdvKeypad_47	= 38100:4:1 // 
vdvKeypad_48	= 38100:4:1 // 
vdvKeypad_49	= 38100:4:1 // 
vdvKeypad_50	= 38100:4:1 // 


DEFINE_VARIABLE

l = 0
volatile integer LutronOnHold[MAX_PANELS]
volatile dev	g_vdvaLutron_Keypads[]		= { vdvKeypad_1, vdvKeypad_2, vdvKeypad_3, vdvKeypad_4, vdvKeypad_5, vdvKeypad_6, vdvKeypad_7, vdvKeypad_8, vdvKeypad_9, vdvKeypad_10, 
						    vdvKeypad_11, vdvKeypad_12, vdvKeypad_13, vdvKeypad_14, vdvKeypad_15, vdvKeypad_16, vdvKeypad_17, vdvKeypad_18, vdvKeypad_19, vdvKeypad_20,
						    vdvKeypad_21, vdvKeypad_22, vdvKeypad_23, vdvKeypad_24, vdvKeypad_25, vdvKeypad_26, vdvKeypad_27, vdvKeypad_28, vdvKeypad_29, vdvKeypad_30,
						    vdvKeypad_31, vdvKeypad_32, vdvKeypad_33, vdvKeypad_34, vdvKeypad_35, vdvKeypad_36, vdvKeypad_37, vdvKeypad_38, vdvKeypad_39, vdvKeypad_40,
						    vdvKeypad_41, vdvKeypad_42, vdvKeypad_43, vdvKeypad_44, vdvKeypad_45, vdvKeypad_46, vdvKeypad_47, vdvKeypad_48, vdvKeypad_49, vdvKeypad_50
						    }

volatile dev	g_dvaLutron_Panels[]		= { dvLutron_TP_1, dvLutron_TP_2, dvLutron_TP_3, dvLutron_TP_4, dvLutron_TP_5,
						    dvLutron_TP_6, dvLutron_TP_7, dvLutron_TP_8, dvLutron_TP_9, dvLutron_TP_10,
						    dvLutron_TP_11, dvLutron_TP_12, dvLutron_TP_13, dvLutron_TP_14, dvLutron_TP_15,
						    dvLutron_TP_16, dvLutron_TP_17, dvLutron_TP_18, dvLutron_TP_19, dvLutron_TP_20
						    }
volatile dev	g_vdvaLutron_MR_Control[]	= { vdvKeypad_2, 	// 1 - Kitchen
						    vdvKeypad_4, 	// 2 - Dining	    \ - двойная панель
						    vdvKeypad_40,	// 3 - Dining TABLE /
						    vdvKeypad_14, 	// 4 - Cabinet
						    vdvKeypad_34, 	// 5 - Cinema
						    vdvKeypad_6, 	// 6 - Salon
						    vdvKeypad_8, 	// 7 - Sigar
						    vdvKeypad_18, 	// 8 - Pool
						    vdvKeypad_22, 	// 9 - Fitness
						    vdvKeypad_20, 	// 10 - Massage
						    vdvKeypad_15, 	// 11 - Hall
						    vdvKeypad_10, 	// 12 - Bedroom
						    vdvKeypad_12, 	// 13 - bathroom
						    vdvKeypad_24, 	// 14 - Robik
						    vdvKeypad_36, 	// 15 - PlayRoom
						    vdvKeypad_26, 	// 16 - Anna Liv
						    vdvKeypad_28, 	// 17 - Anna Bed
						    vdvKeypad_30, 	// 18 - Guest 1
						    vdvKeypad_32, 	// 19 - Guest 2
						    0, 			// 20 - Billiard
						    0 			// 21 - Yard		
						    }

// присвоение источников на кнопки панелей Лутрон
volatile integer g_iaKeypad_Sources[21][6]	= {
						    {952,11,12,25,99,00},// 1 - Kitchen
						    {11,12,13,25,99,00},// 2 - Dining
						    {952,06,99,99,99,00},// 3 - Dining TABLE
						    {11,12,13,25,99,00},// 4 - Cabinet
						    {98,97,96,99,99,00},// 5 - Cinema
						    {11,12,13,25,99,00},// 6 - Salon
						    {11,12,20,02,99,00},// 7 - Sigar
						    {11,12,13,23,99,00},// 8 - Pool
						    {952,11,12,20,99,00},// 9 - Fitness
						    {11,12,99/*ipod*/,20,99,00},// 10 - Massage
						    {11,12,13,25,99,00},// 11 - Hall
						    {952,11,12,21,99,00},// 12 - Bedroom
						    {952,11,12,21,99,00},// 13 - bathroom
						    {11,12,13,24,99,00},// 14 - Robik
						    {952,11,12,24,99,00},// 15 - PlayRoom
						    {952,11,12,22,99,00},// 16 - Anna Liv
						    {11,12,13,22,99,00},// 17 - Anna Bed
						    {99,11,12,23,99,00},// 18 - Guest 1
						    {99,12,12,23,99,00},// 19 - Guest 2
						    {99,99,99,99,99,00},// 20 - Billiard
						    {99,99,99,99,99,00} // 21 - Yard		
						    }  

// обновление обратной связи подсветки панелей Лутрон
define_function fnLutronKeypadsFb(integer in_iKeypad, integer atlona)
{
    integer l_iRoom
    integer l_iSource
    char l_caLeds[10]
    integer l
    
    if(in_iKeypad == 3)
	l_iRoom = 2
    else
	l_iRoom = in_iKeypad
    
    l_iSource = m_aZones[l_iRoom].m_iSourceFb
    l_caLeds = '000000'
    
    // Cinema
    if(in_iKeypad == 5) {
	
	switch(g_iCinema)
	{
	    case _on_TV:
		l_iSource = 97
	    break;
	    case _on_Proj:
		l_iSource = 98
	    break;
	}
	
	if(l_iSource >= 11 && l_iSource <= 30)
	    l_iSource = 96
    }
    
    // если Атлона выключена, моргаем светодиодами
    if(atlona) {
	l_caLeds = '222200'
    } else {
	
	if( g_iaKeypad_Sources[in_iKeypad][1] == l_iSource ||
	    g_iaKeypad_Sources[in_iKeypad][2] == l_iSource ||
	    g_iaKeypad_Sources[in_iKeypad][3] == l_iSource ||
	    g_iaKeypad_Sources[in_iKeypad][4] == l_iSource ||
	    g_iaKeypad_Sources[in_iKeypad][5] == l_iSource ||
	    g_iaKeypad_Sources[in_iKeypad][6] == l_iSource ) {
	    
	    for(l = 1; l <= 6; l++) {
		if(g_iaKeypad_Sources[in_iKeypad][l] == l_iSource)
		    l_caLeds[l] = $31
	    }
	} else {
	    l_caLeds = '111100'
	}
    }
    
    set_length_string(l_caLeds, 6)
    
    fnCmd(vdvLutron_2, "'SETLEDS, [', fnGetKeypadAddress(g_vdvaLutron_MR_Control[in_iKeypad]), '], ',l_caLeds")
}

define_function fnOnLutronPanelsControl(integer in_iPanel, integer in_iBtn, integer in_iPush)
{
    local_var char l_caLeds[20]
    local_var integer l,u, l_iSource, l_iZoneSource, l_iOldSource
    //l_caLeds = '000000'
    debug("'Lutron Panel - ', itoa(in_iPanel),', Btn - ',itoa(in_iBtn),', State = ', itoa(in_iPush)")
    
    l_iSource = g_iaKeypad_Sources[in_iPanel][in_iBtn]
    
    l_iZoneSource = m_aZones[in_iPanel].m_iSourceFb
    l_iOldSource = m_aZones[in_iPanel].m_iOldSource

    
    if(in_iPanel == 3) in_iPanel = 2
    
    if(in_iBtn != 23 && in_iBtn != 24 && l_iSource != 99) {
	
	// cinema on TV
	if(l_iSource == 97) {
	    
	    g_iCinema = _on_tv
	    
	    if(l_iZoneSource == 0 || ( l_iZoneSource >= 10 && l_iZoneSource <= 30 ) ) {
		fnProcessSourceSelect(in_iPanel, iSrc_Sat_1, 0)
	    } else {
		fnProcessSourceSelect(in_iPanel, l_iZoneSource, 0)
	    }
	    //fnLutronKeypadsFb(5, 0)
	} else
	// Cinema on Projector
	if(l_iSource == 98) {
	    
	    g_iCinema = _on_proj
	    
	    if(l_iZoneSource == 0 || ( l_iZoneSource >= 10 && l_iZoneSource <= 30 ) ) {
		fnProcessSourceSelect(in_iPanel, iSrc_Sat_1, 0)
	    } else {
		fnProcessSourceSelect(in_iPanel, l_iZoneSource, 0)
	    }
	    //fnLutronKeypadsFb(5, 0)
	} else
	// Cinema Music
	if(l_iSource == 96) {
	    
	    fnProcessSourceSelect(in_iPanel, 14, 0)
	    //fnLutronKeypadsFb(5, 0)
	} else 
	if(l_iSource == 952) {
	    local_var fb
	    fb = l_iZoneSource
	    if(fb == iSrc_Sat_1 || fb == iSrc_Sat_2) {
		fnProcessSourceSelect(in_iPanel, fb, 0)
	    } else {
		if(m_aSource[iSrc_Sat_1].m_iSelected || m_aSource[iSrc_Sat_2].m_iSelected) {
		    if(m_aSource[iSrc_Sat_1].m_iSelected && !m_aSource[iSrc_Sat_2].m_iSelected) {
			fnProcessSourceSelect(in_iPanel, iSrc_Sat_2, 0)
		    } else
		    if(!m_aSource[iSrc_Sat_1].m_iSelected && m_aSource[iSrc_Sat_2].m_iSelected) {
			fnProcessSourceSelect(in_iPanel, iSrc_Sat_1, 0)
		    } else 
		    if(m_aSource[iSrc_Sat_1].m_iSelected && m_aSource[iSrc_Sat_2].m_iSelected) {
			fnProcessSourceSelect(in_iPanel, iSrc_Sat_1, 0)
		    }
		} else {
		    fnProcessSourceSelect(in_iPanel, iSrc_Sat_1, 0) 
		}
	    }
	} else {
	    fnProcessSourceSelect(in_iPanel, l_iSource, 0)
	}
	// обновим все панели которые в данный момент управляют системой
	for(u = 1; u <= MAX_PANELS; u++)
	    fnProcessPanelUpdate(u)
    } else {
	switch(in_iBtn)
	{
	    case 23: { // Volume Down
		if(in_iPush)
		    fnLutronVolumeControl(in_iPanel, _down, _push)
		else
		    fnLutronVolumeControl(in_iPanel, _down, _release)
	    } 
	    case 24: { // Volume Up
		if(in_iPush)
		    fnLutronVolumeControl(in_iPanel, _up, _push)
		else
		    fnLutronVolumeControl(in_iPanel, _up, _release)
	    } 
	}
    }
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

define_function fnLutronVolumeControl(integer in_iRoom, integer in_iBtn, integer in_iPush)
{
    local_var 
	integer l_iSource
	dev l_Device
	integer l_iBtn
	integer l_iPulse
    
    l_iSource = m_aZones[in_iRoom].m_iSourceFb
    
    switch(in_iRoom)
    {
	//Зоны где управляется громкость ТВ и Мультирум
	case iZone_Kitchen:
	case iZone_Bathroom:
	{
	    //управление громкостью ТВ
	    if(l_iSource >= iSrc_TV && l_iSource <= iSrc_Base_3 || l_iSource == iSrc_AppleTV) {
		l_Device = g_vdvaTV[in_iRoom] 
		l_iBtn = in_iBtn - 75
	    
	    //управление громкостью мультирум
	    } else
	    if(l_iSource >= iSrc_Sonix_1_1 && l_iSource <= iSrc_iPort_Anna) {
		l_Device = g_vdvaAudio[in_iRoom]
		l_iBtn = in_iBtn
	    }
	}
	case iZone_Foyer:
	case iZone_Pool:	
	case iZone_Gym: 
	case iZone_Bedroom:
	{
	    l_Device = g_vdvaAudio[in_iRoom]
	    l_iBtn = in_iBtn
	}	
	case iZone_Guest_1:
	case iZone_Guest_2:
	case iZone_Playroom:
	case iZone_Robik:
	case iZone_Anna_Bedroom:
	{
	    //управление громкостью ТВ
	    if(l_iSource >= iSrc_TV && l_iSource <= iSrc_Base_3 || l_iSource == iSrc_AppleTV) {
		l_Device = g_vdvaTV[in_iRoom] 
		l_iBtn = in_iBtn - 75
	    
	    //управление громкостью мультирум
	    } else
	    if(l_iSource >= iSrc_Sonix_1_1 && l_iSource <= iSrc_iPort_Anna) {
		l_Device = vdvMultiroom
		l_iBtn = in_iBtn
	    }
	}
	//Зоны где управляется громкость ТВ и Линн Юнидиск
	case iZone_Dining:
	case iZone_Sigar:
	case iZone_Anna_Living:
	{
	    if(l_iSource >= iSrc_TV && l_iSource <= iSrc_BluRay || l_iSource == iSrc_AppleTV) {
		l_Device = g_vdvaAudio[in_iRoom]
		l_iBtn = in_iBtn
	    }
	}
	//зоны только мультирум
	case iZone_Cabinet:
	case iZone_Massage:
	case iZone_Yard:
	{
	    if(l_iSource >= iSrc_Sonix_1_1 && l_iSource <= iSrc_iPort_Anna) {
		l_Device = vdvMultiroom
		l_iBtn = in_iBtn
	    }
	}
	case iZone_Cinema:
	{
	    l_Device = vdvYamaha_Cinema
	    l_iBtn = in_iBtn
	    
	    //volume up
	    if(in_iBtn == 97 && in_iPush == _push && l_iSource == 0) {
		fnDoorControl('Close')
		fnScreenControl('Up')
	    }
	    
	    //volume down
	    if(in_iBtn == 98 && in_iPush == _push && l_iSource == 0) {
		fnDoorControl('Open')
		fnScreenControl('Down')
	    }
	}
	case iZone_Lounge:
	{
	    if(l_iSource >= 1 && l_iSource <= 10  || l_iSource == iSrc_AppleTV) {
		l_Device = vdvTV_Lounge
		l_iBtn = in_iBtn - 75
	    } else {
		l_device = vdvMultiroom
		l_iBtn = in_iBtn
	    }
	}
    }
    if(l_iPulse) {
	if(l_Device != vdvMultiroom)
	    pulse[l_Device, l_iBtn]
	l_iPulse = 0
    } else {
	if(l_iSource) {
	    switch(in_iPush) {
		case _push: 	{ 
			    if(l_Device != vdvMultiroom) {
				on[l_Device, l_iBtn] 
			    } else {
				if(l_iBtn == 97) send_command vdvMultiroom, "'VOLUME_UP ', itoa(g_iaZoneMRoomOutputs[in_iRoom]),';'"
				if(l_iBtn == 98) send_command vdvMultiroom, "'VOLUME_DOWN ', itoa(g_iaZoneMRoomOutputs[in_iRoom]),';'"
				if(l_iBtn == 99) send_command vdvMultiroom, "'MUTE ', itoa(g_iaZoneMRoomOutputs[in_iRoom]),';'"
			    }
		}
		case _release: 	{ 
			    if(l_Device != vdvMultiroom) {
				off[l_Device, l_iBtn]
			    } else {
				if(l_iBtn == 97) send_command vdvMultiroom, "'VOLUME_STOP ', itoa(g_iaZoneMRoomOutputs[in_iRoom]),';'"
				if(l_iBtn == 98) send_command vdvMultiroom, "'VOLUME_STOP ', itoa(g_iaZoneMRoomOutputs[in_iRoom]),';'"
			    }
		}
	    }
	}
    }
}

DEFINE_EVENT

level_event[g_dvaLutron_Panels, 0]
{
    local_var integer l_iLevel, l_iValue
    
    l_iLevel = level.input.level
    l_iValue = level.value*100/255
    
    switch(l_iLevel)
    {
	case 1: {//red
	    fnCmd(vdvLutron_2, "'PASSTHRU-FADEDIM, ', itoa(l_iValue),', 1, 0, [01:01:02:01:01]',13,10")
	break;
	}
	case 2: {//green
	    fnCmd(vdvLutron_2, "'PASSTHRU-FADEDIM, ', itoa(l_iValue),', 1, 0, [01:01:02:01:03]',13,10")
	break;
	}
	case 3: {//blue
	    fnCmd(vdvLutron_2, "'PASSTHRU-FADEDIM, ', itoa(l_iValue),', 1, 0, [01:01:02:01:02]',13,10")
	break;
	}
    }
}

channel_event[vdvLutron_2, 255]
{
    on: {
	local_var integer keypad
	
	for(keypad = 1; keypad <= max_length_array(g_vdvaLutron_MR_Control); keypad++) {
	    if(g_vdvaLutron_MR_Control[keypad])
		fnLutronKeypadsFb(keypad, 0)
	}
    }
}

data_event[g_dvaLutron_Panels]
{
    online:
    {
    
    }
    
    string:
    {
	local_var char l_caData[100]
	
	l_caData = data.text
	
	send_command vdvLutron_2, "'PASSTHRU-', l_caData, $0D, $0A"
    }
    
    command:
    {
    
    }
}
/*
    Обработка нажатий с ТП для управление Лутроном
    
    В данной версии максимально обрабатывается 99 панелей и 9 контроллеров
    
    Кнопки управления сценариями освещения Формат XXYY
	XX - номер кнопки кейпада + 10
	YY - номер кейпада по массиву
	
    кнопки управления и диммирования группами освещения. Формат ____
    
    
    кнопки управления шторами. Формат ____

*/
button_event[g_dvaLutron_Panels, 0]
{
    push: {
	local_var
	    integer l_iBtn
	    integer l_iPanel
	    integer l_iKeyPad
	    integer l_iKeyPad_Btn
	    
	l_iBtn = button.input.channel
	l_iPanel = get_last(g_dvaLutron_Panels)
	
	if(l_iBtn > 1100 && l_iBtn < 3500) {
	    l_iKeyPad 		= atoi(right_string(itoa(l_iBtn), 2))
	    l_iKeyPad_Btn	= atoi(left_string(itoa(l_iBtn), 2)) - 10
	    
	    on[g_vdvaLutron_Keypads[l_iKeyPad], l_iKeyPad_Btn]
	}
    }
    
    release: {
	local_var
	    integer l_iBtn
	    integer l_iPanel
	    integer l_iKeyPad
	    integer l_iKeyPad_Btn
	    
	l_iBtn = button.input.channel
	l_iPanel = get_last(g_dvaLutron_Panels)
	
	if(l_iBtn > 1100 && l_iBtn < 3500) {
	    l_iKeyPad 		= atoi(right_string(itoa(l_iBtn), 2))
	    l_iKeyPad_Btn	= atoi(left_string(itoa(l_iBtn), 2)) - 10
	    
	    off[g_vdvaLutron_Keypads[l_iKeyPad], l_iKeyPad_Btn]
	}
    }
    
    hold[5, repeat]: {
    
    }
    
}

button_event[g_vdvaLutron_MR_Control, 0]
{
    push: {
	local_var
	    integer l_iPanel
	    integer l_iBtn
	    
	l_iBtn = button.input.channel
	l_iPanel = get_last(g_vdvaLutron_MR_Control)
	
	fnOnLutronPanelsControl(l_iPanel, l_iBtn, _push)
    }
    release: {
	local_var
	    integer l_iPanel
	    integer l_iBtn
	    
	l_iBtn = button.input.channel
	l_iPanel = get_last(g_vdvaLutron_MR_Control)
	
	if(LutronOnHold[l_iPanel]) {
	    LutronOnHold[l_iPanel] = 0
	} else {
	    fnOnLutronPanelsControl(l_iPanel, l_iBtn, _release)
	}
    }
    hold[20]: {
	local_var
	    integer l_iPanel
	    integer l_iBtn
	    
	l_iBtn = button.input.channel
	l_iPanel = get_last(g_vdvaLutron_MR_Control)
	LutronOnHold[l_iPanel] = 1
	fnOnLutronPanelsControl(l_iPanel, l_iBtn, _hold)
    }
}

// панель при входе в бассейн из восточной. кнопка управления телевизором
button_event[vdvKeypad_41, 3] 
{
    push:
    {
	local_var fb
	fb = m_aZones[iZone_Sigar].m_iSourceFb
	if(fb == iSrc_Sat_1 || fb == iSrc_Sat_2) {
	    fnProcessSourceSelect(iZone_Sigar, fb, 0)
	} else {
	    if(m_aSource[iSrc_Sat_1].m_iSelected || m_aSource[iSrc_Sat_2].m_iSelected) {
		if(m_aSource[iSrc_Sat_1].m_iSelected && !m_aSource[iSrc_Sat_2].m_iSelected) {
		    fnProcessSourceSelect(iZone_Sigar, iSrc_Sat_2, 0)
		} else
		if(!m_aSource[iSrc_Sat_1].m_iSelected && m_aSource[iSrc_Sat_2].m_iSelected) {
		    fnProcessSourceSelect(iZone_Sigar, iSrc_Sat_1, 0)
		} else 
		if(m_aSource[iSrc_Sat_1].m_iSelected && m_aSource[iSrc_Sat_2].m_iSelected) {
		    fnProcessSourceSelect(iZone_Sigar, iSrc_Sat_1, 0)
		}
	    } else {
		fnProcessSourceSelect(iZone_Sigar, iSrc_Sat_1, 0) 
	    }
	}
    }
}