PROGRAM_NAME='Salon_Karaoke'

DEFINE_DEVICE

#if_not_defined vdvAPC_Karaoke 		vdvAPC_Karaoke 		= 33065:1:1 	#end_if
#if_not_defined vdvUnidisk_Salon	vdvUnidisk_Salon 	= 33059:1:1 	#end_if
#if_not_defined vdvKaraoke_MadBoy	vdvKaraoke_MadBoy 	= 33037:1:1 	#end_if
#if_not_defined vdvKaraoke_2		vdvKaraoke_2 		= 33038:1:1 	#end_if
#if_not_defined vdvBD_Lounge		vdvBD_Lounge 		= 33035:1:1 	#end_if
#if_not_defined vdvTV_Lounge		vdvTV_Lounge 		= 33024:1:1 	#end_if
#if_not_defined vdvYamaha_LS9		vdvYamaha_LS9		= 33039:1:1 	#end_if
#if_not_defined iZone_Lounge 		iZone_Lounge 		= 6	 	#end_if
//#if_not_defined vdvAtlona_Salon_Left 	vdvAtlona_Salon_Left	= 33067:1:1	#end_if
//#if_not_defined vdvAtlona_Karaoke_Right	vdvAtlona_Karaoke_Right	= 33068:1:1	#end_if



DEFINE_CONSTANT

OUTLET_MEYER		= 1 // 1-6 Outlets Group
OUTLET_LS9		= 9
OUTLET_DME		= 10
OUTLET_SHURE		= 12
OUTLET_ADAMHALL		= 11
OUTLET_AST_100		= 13
OUTLET_BEHRINGER	= 7

OUTLET_ON		= 1
OUTLET_OFF		= 2
OUTLET_REBOOT		= 3
OUTLET_DELAYED_ON	= 4
OUTLET_DELAYED_OFF	= 5
OUTLET_DELAYED_REBOOT	= 6




DEFINE_TYPE





DEFINE_VARIABLE



DEFINE_COMBINE

//(vdvAtlona_Salon_Left, vdvAtlona_16x16_Port_11)
//(vdvAtlona_Karaoke_Right, vdvMoxa_2_1)


define_function fnSalonSourceSelect(integer in_iSource, integer tp)
{
    stack_var integer l_iOldSource, c, in_iRoom
    
    in_iRoom = iZone_Lounge
    
    l_iOldSource = m_aZones[iZone_Cinema].m_iOldSource
    
    //
    if(in_iSource == 0) {
	
	cancel_wait 'kara_off'
	
	fnCmd(vdvTV_Lounge, "'SET_POWER OFF;'")
	
	//Make a Kara Func
	fnRack(0, OUTLET_ON, OUTLET_ON,OUTLET_ON,OUTLET_ON,OUTLET_ON)
	
	wait 50 'kara_off' {
	    fnCmd(vdvTV_Lounge, "'SET_POWER OFF;'")
	    fnRack(0, OUTLET_ON, OUTLET_ON,OUTLET_ON,OUTLET_ON,OUTLET_ON)
	}
    } else {
	if(in_iSource == 34 || in_iSource == 35) {
	    //on karaoke rack
	    cancel_wait 'kara_on'
	    fnRack(1, OUTLET_ON, OUTLET_ON,OUTLET_ON,OUTLET_ON,OUTLET_ON)
	    wait 50 'kara_on'
	    fnRack(1, OUTLET_ON, OUTLET_ON,OUTLET_ON,OUTLET_ON,OUTLET_ON)
	    
	    if(in_iSource == 34)
		send_string vdvMoxa_2_1, "'I2'" //Karaoke Atlona
	    if(in_iSource == 35)
		send_string vdvMoxa_2_1, "'I1'" //Karaoke Atlona
		
	    fnCmd(vdvTV_Lounge, "'SET_INPUT HDMI2;'")
	} else
	if(in_iSource == 33) { // BD Player
	    fnRack(0, OUTLET_ON, OUTLET_ON,OUTLET_ON,OUTLET_ON,OUTLET_ON)
	    fnCmd(vdvTV_Lounge, "'SET_INPUT HDMI1;'")
	    send_string vdvAtlona_16x16_Port_11, "'A2'"
	    
	} else
	if(in_iSource >= 2 && in_iSource <= 10) { // Video Source Atlona
	    fnRack(0, OUTLET_ON, OUTLET_ON,OUTLET_ON,OUTLET_ON,OUTLET_ON)
	    fnCmd(vdvTV_Lounge, "'SET_INPUT HDMI1;'")
	    send_string vdvAtlona_16x16_Port_11, "'A1'"
	    
	} else
	if(fnReturnAudioSrc(in_iSource)) { // Audio Source
	    fnRack(2,outlet_on,outlet_on,outlet_off,outlet_off,outlet_off)
	    fnCmd(vdvTV_Lounge, "'SET_POWER OFF;'")
	} 
	
	fnJumpToSalonSource(in_iSource, tp)
    }
}



/*
	in_iAll - 0 - all off,  1 - all on, 2 - separate mode 
*/
define_function fnRack(integer ALL, integer MEYER, integer DME, integer LS9, integer SHURE, integer AST100)
{
    cancel_wait 'apc_1'
    cancel_wait 'apc_2'
    cancel_wait 'apc_3'
    cancel_wait 'apc_4'
		    
    switch(ALL)
    {
	//all off
	case 0: {
		    fnCmd(vdvAPC_Karaoke, "'SET_OUTLET ', itoa(OUTLET_AST_100),',', itoa(OUTLET_OFF),';'")  
		    wait 1 'apc_1'
		    fnCmd(vdvAPC_Karaoke, "'SET_OUTLET ', itoa(OUTLET_DME),',', itoa(OUTLET_OFF),';'")  
		    wait 2 'apc_2'
		    fnCmd(vdvAPC_Karaoke, "'SET_OUTLET ', itoa(OUTLET_LS9),',', itoa(OUTLET_OFF),';'")  
		    wait 3 'apc_3'
		    fnCmd(vdvAPC_Karaoke, "'SET_OUTLET ', itoa(OUTLET_MEYER),',', itoa(OUTLET_OFF),';'")  
		    wait 4 'apc_4'
		    fnCmd(vdvAPC_Karaoke, "'SET_OUTLET ', itoa(OUTLET_SHURE),',', itoa(OUTLET_OFF),';'")  
	}
	//all on
	case 1: {
		    fnCmd(vdvAPC_Karaoke, "'SET_OUTLET ', itoa(OUTLET_AST_100),',', itoa(OUTLET_ON),';'")  
		    wait 1 'apc_1'
		    fnCmd(vdvAPC_Karaoke, "'SET_OUTLET ', itoa(OUTLET_DME),',', itoa(OUTLET_ON),';'")  
		    wait 2 'apc_2'
		    fnCmd(vdvAPC_Karaoke, "'SET_OUTLET ', itoa(OUTLET_LS9),',', itoa(OUTLET_ON),';'")  
		    wait 3 'apc_3'
		    fnCmd(vdvAPC_Karaoke, "'SET_OUTLET ', itoa(OUTLET_MEYER),',', itoa(OUTLET_ON),';'")  
		    wait 4 'apc_4'
		    fnCmd(vdvAPC_Karaoke, "'SET_OUTLET ', itoa(OUTLET_SHURE),',', itoa(OUTLET_ON),';'")  
	}
	//separate on/off
	case 2: {
		    fnCmd(vdvAPC_Karaoke, "'SET_OUTLET ', itoa(OUTLET_AST_100),',', itoa(AST100),';'")  
		    wait 1 'apc_1'
		    fnCmd(vdvAPC_Karaoke, "'SET_OUTLET ', itoa(OUTLET_DME),',', itoa(DME),';'")  
		    wait 2 'apc_2'
		    fnCmd(vdvAPC_Karaoke, "'SET_OUTLET ', itoa(OUTLET_LS9),',', itoa(LS9),';'")  
		    wait 3 'apc_3'
		    fnCmd(vdvAPC_Karaoke, "'SET_OUTLET ', itoa(OUTLET_MEYER),',', itoa(MEYER),';'")  
		    wait 4 'apc_4'
		    fnCmd(vdvAPC_Karaoke, "'SET_OUTLET ', itoa(OUTLET_SHURE),',', itoa(SHURE),';'") 
	}
    }
}

define_function fnJumpToSalonSource(integer in_iSource, integer tp)
{
    stack_var char l_iSource[20]
    
    //fnCmd(This_Panel, '@PPF-')
    //fnCmd(This_Panel, '@PPF-')
    
    if(in_iSource == iSrc_TV) {
	l_iSource = 'TV'
    } else
    if(in_iSource == iSrc_AppleTV || in_iSource == iSrc_AppleTV_2) {
	l_iSource = 'AppleTV'
    } else
    if(in_iSource == iSrc_SAT_1 || in_iSource == iSrc_SAT_2) {
	l_iSource = 'SAT'
    } else
    if(in_iSource >= iSrc_Dune_1 && in_iSource <= iSrc_Dune_3) {
	l_iSource = 'Dune'
    } else
    if(in_iSource >= iSrc_Radio_1 && in_iSource <= iSrc_Radio_6) {
	l_iSource = 'Radio'
    } else
    if(in_iSource == iSrc_BluRay) {
	l_iSource = 'BluRay'
    } /*else
    if(in_iSource >= iSrc_Base_1 && in_iSource >= iSrc_Base_3) {
	l_iSource = ''
    } else
    if(in_iSource >= iSrc_Sonix_1_1 && in_iSource <= iSrc_Sonix_3_3) {
	l_iSource = ''
    }*/

    fnCmd(This_Panel, "'@PPN-Source_', l_iSource,'_Control'")
    fnCmd(This_Panel, "'@PPN-Popup_Back'")
}



DEFINE_START



DEFINE_EVENT



DEFINE_PROGRAM




