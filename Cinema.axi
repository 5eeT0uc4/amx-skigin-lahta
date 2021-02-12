PROGRAM_NAME='Cinema'

DEFINE_DEVICE

dvM2_IO = 5001:4:2

DEFINE_CONSTANT

//_on_tv = 1
//_on_proj = 2
_open = 1
_close = 0

VIEW_ON_TV		= 913
VIEW_ON_PROJ		= 914
VIEW_DIALOG_OPEN	= 912
VIEW_DIALOG_CLOSE	= 915
VIEW_PROJ_OFF_CONFIRM	= 916
VIEW_PROJ_TV_SAT	= 918


DEFINE_TYPE





DEFINE_VARIABLE

volatile devchan dvM2_IO_1	= {dvM2_IO, 1} // proj door is close
volatile devchan dvM2_IO_2	= {dvM2_IO, 2} // proj status
volatile devchan dvM2_IO_3	= {dvM2_IO, 3} // open/close door trigger
volatile devchan dvM2_IO_4	= {dvM2_IO, 4} // 

volatile integer g_iIO_1

//volatile integer g_iCinema	= 0 // 1 - на ТВ, 2 - на проектор, (3 - музыка?)
volatile integer g_iDoor_State	= _close


define_function fnCinemaSourceSelect(integer in_iSource, integer tp)
{
    local_var integer l_iOldSource, c, in_iRoom
    
    in_iRoom = iZone_Cinema
    l_iOldSource = m_aZones[in_iRoom].m_iOldSource
    
    //ask if Projector ON when select audio source
    
    //ask when need re-connect  TV <-> Projector (if source != 0)
    if(in_iSource == 0) {
    
	cancel_wait 'cinema_off1'
	cancel_wait 'cinema_off2'
	
	g_iCinema = 0
	fnScreenControl('Up')
	fnDoorControl('Close')
	send_command vdvTV_Cinema, 'SET_POWER OFF;'
	//send_command vdvBD_Cinema, 'SET_POWER OFF;'
	send_command vdvProjector, 'SET_POWER OFF;'
	fnYamahaSelectSource(0)
	
	wait 100 'cinema_off1'
	{
	    send_command vdvTV_Cinema, 'SET_POWER OFF;'
	    send_command vdvProjector, 'SET_POWER OFF;'
	    fnYamahaSelectSource(0)
	    
	    wait 400 'cinema_off2'
	    {
		send_command vdvTV_Cinema, 'SET_POWER OFF;'
		send_command vdvProjector, 'SET_POWER OFF;'
		fnYamahaSelectSource(0)
	    }
	}
    } else {
	
	cancel_wait 'cinema_off1'
	cancel_wait 'cinema_off2'
	
	if(tp) {
	    if(THIS_Btn == VIEW_DIALOG_OPEN) {
		//
		fnCmd(This_panel, '@PPN-_TV_Projector')
		//
	    } else 
	    //view through TV
	    if(THIS_Btn == VIEW_ON_TV) {
		//
		fnJumpToSource(in_iSource, tp)
		//
		fnCinemaOnTV(in_iSource)
	    } else 
	    //view through Projector
	    if(THIS_Btn == VIEW_ON_PROJ) {
		//
		fnJumpToSource(in_iSource, tp)
		//
		fnCinemaOnProjector(in_iSource)
	    } else 
	    if(THIS_Btn == VIEW_DIALOG_CLOSE) {
		//если предыдущий источник аудио
		//if(fnReturnAudioSrc(in_iSource) && fnReturnVideoSrc(l_iOldSource)) {
		    
		    //fnJumpToSource(in_)
		//} else
		//если предыдущий источник видео
		//if(fnReturnVideoSrc(l_iOldSource)) {
		    
		//}
		//если зона была выключена
		if(l_iOldSource == 0) {
		    This_Source = 0
		    fnBackButton(tp)
		} else {
		    This_Source = l_iOldSource
		    fnBackButton(tp)
		}
		
		//This_Source = 0
		//fnBackButton(tp)
	    } else 
	    if(THIS_Btn == VIEW_PROJ_OFF_CONFIRM) {
		fnYamahaSelectSource(in_iSource)
		fnJumpToSource(in_iSource, tp)
	    } else {
		//Если зона выключена или аудио источник (g_iCinema == 0 OldSource == 0 или Музыкальный источник)
		if((g_iCinema == 0 || fnReturnAudioSrc(l_iOldSource)) && !fnReturnVideoSrc(l_iOldSource)) {
		    
		    if(fnReturnAudioSrc(in_iSource)) {
			fnYamahaSelectSource(in_iSource)
			fnJumpToSource(in_iSource, tp)
		    } else {
			fnCmd(This_panel, '@PPN-_TV_Projector')
		    }
		    
		} else
		//Если зона включена на видео источник
		if(g_iCinema > 0) {
		    if(fnReturnAudioSrc(in_iSource)) {
			if(g_iCinema == _on_tv)  {
			    fnYamahaSelectSource(in_iSource)
			    fnJumpToSource(in_iSource, tp)
			}
			if(g_iCinema == _on_proj) {
			    fnCmd(This_panel, '@PPN-_Projector_Off')
			}
		    } else {
			if(g_iCinema == _on_tv) {
			    fnCinemaOnTV(in_iSource)
			    fnJumpToSource(in_iSource, tp)
			}
			if(g_iCinema == _on_proj) {
			    fnCinemaOnProjector(in_iSource)
			    fnJumpToSource(in_iSource, tp)
			}
		    }
		}
	    }
	} else {
	    if(g_iCinema == _on_proj) {
		fnCinemaOnProjector(in_iSource)
	    } else
	    if(g_iCinema == _on_tv) {
		fnCinemaOnTV(in_iSource)
	    } else {
		fnYamahaSelectSource(in_iSource)
	    }
	}
    }
}

define_function fnJumpToSource(integer in_iSource, integer tp)
{
    stack_var char l_iSource[20]
    
    fnCmd(This_Panel, '@PPF-_TV_Projector')
    fnCmd(This_Panel, '@PPF-_Projector_Off')
    
    if(in_iSource == iSrc_TV) {
	l_iSource = 'TV'
    } else
    if(in_iSource == iSrc_SAT_1 || in_iSource == iSrc_SAT_2) {
	l_iSource = 'SAT'
    } else
    if(in_iSource == iSrc_BluRay) {
	l_iSource = 'BluRay'
    } else
    if(in_iSource >= iSrc_Dune_1 && in_iSource <= iSrc_Dune_3) {
	l_iSource = 'Dune'
    } else
    if(in_iSource >= iSrc_Radio_1 && in_iSource <= iSrc_Radio_6) {
	l_iSource = 'Radio'
    } else
    if(in_iSource == iSrc_AppleTV || in_iSource == iSrc_AppleTV_2 || in_iSource == iSrc_AppleTV4KCinema) {
	l_iSource = 'AppleTV'
    }
    
    if(length_string(l_iSource) > 0) {
	fnCmd(This_Panel, "'@PPN-Source_', l_iSource,'_Control'")
	fnCmd(This_Panel, "'@PPN-Popup_Back'")
    }
}

define_function fnCinemaOnTV(integer in_iSource)
{
    local_var integer tt
    
    g_iCinema = _on_tv
    
    fnScreenControl('Up')
    fnDoorControl('Close')
    
    send_command vdvProjector, 'SET_POWER OFF;'
    send_command vdvTV_Cinema, 'SET_INPUT HDMI2;'

    fnYamahaSelectSource(in_iSource)
    
    for(tt = 1; tt <= MAX_PANELS; tt++)
	fnProcessPanelUpdate(tt)
}

define_function fnCinemaOnProjector(integer in_iSource)
{
    local_var integer tc
    
    g_iCinema = _on_proj
    fnScreenControl('Down')
    fnDoorControl('Open')
    //projector communication
    send_command vdvTV_Cinema, 'SET_POWER OFF;'
    send_command vdvProjector, 'SET_POWER ON;'
    send_command vdvProjector, 'SET_INPUT HDMI1;'
    
    fnYamahaSelectSource(in_iSource)

    for(tc = 1; tc <= MAX_PANELS; tc++)
	fnProcessPanelUpdate(tc)
}

define_function fnYamahaSelectSource(integer in_iSource)
{
    if(in_iSource == 0) {
	send_command vdvYamaha_Cinema, 'SET_POWER OFF;'
    } else
    if(in_iSource == 1) {
	send_command vdvYamaha_Cinema, 'SET_INPUT AUDIO1;'
    } else
    if(in_iSource == 41) {
	send_command vdvYamaha_Cinema, 'SET_INPUT AV2;'
    } else
    if(in_iSource >= 2 && in_iSource <= 10 || in_iSource == 40) {
	send_command vdvYamaha_Cinema, 'SET_INPUT AV3;'
    } else
    if(in_iSource == 33) {
	send_command vdvBD_Cinema, 'SET_POWER ON;'
	send_command vdvYamaha_Cinema, 'SET_INPUT AV1;'
    } else
    //audio sources
    if(in_iSource >= 11 && in_iSource <= 30) {
	g_iCinema = 0
	send_command vdvTV_Cinema, 'SET_POWER OFF;'
	send_command vdvProjector, 'SET_POWER OFF;'
	fnDoorControl('Close')
	fnScreenControl('Up')
	send_command vdvYamaha_Cinema, 'SET_INPUT AUDIO2;'
    }
}

define_function fnScreenControl(char in_caState[])
{
    if(in_caState == 'Up') {
	//pulse[vdvKeypad_34, 2]
	cancel_wait 'scrn'
	fnCmd(vdvLutron_2, "'PASSTHRU-CCOOPEN, [02:04:05], 2',13,10")
	wait 10 'scrn'
	fnCmd(vdvLutron_2, "'PASSTHRU-CCOPULSE, [02:04:05], 1, 2',13,10")
    }
    if(in_caState == 'Down') {
	//pulse[vdvKeypad_34, 1]
	cancel_wait 'scrn'
	fnCmd(vdvLutron_2, "'PASSTHRU-CCOOPEN, [02:04:05], 1',13,10")
	wait 10 'scrn'
	fnCmd(vdvLutron_2, "'PASSTHRU-CCOPULSE, [02:04:05], 2, 2',13,10")
    }
}
// open/close
define_function fnDoorControl(char in_iState[])
{
    //
    off[dvM2_IO_3]
    
    if(in_iState == 'Close') {
	if(![dvM2_IO_1]) {
	    
	    wait 150 'wait_door' {
		on[dvM2_IO_3]
		
		wait 5 'cl' {
		    off[dvM2_IO_3]
		}
	    }
	}
    } else
    if(in_iState == 'Open') {
	cancel_wait 'wait_door'
	if([dvM2_IO_1]) {
	    on[dvM2_IO_3]
	    
	    wait 5 'cl' {
		off[dvM2_IO_3]
	    }
	}
    }
    
}

define_function integer fnReturnVideoSrc(integer in_iSource)
{
    if((in_iSource >= 2 && in_iSource <= 10) || in_iSource == iSrc_BluRay || in_iSource == iSrc_AppleTV || in_iSource == iSrc_AppleTV4KCinema)
	return 1
    else
	return 0
}

define_function integer fnReturnAudioSrc(integer in_iSource)
{
    if(in_iSource >= 11 && in_iSource <= 30)
	return 1
    else
	return 0
}

DEFINE_START



DEFINE_EVENT



DEFINE_PROGRAM

/*
wait 500 'theahter_control' {
    if(m_aZones[iZone_Cinema].m_iSourceFb == 0) {
	send_command vdvProjector, 'SET_POWER OFF;'
	send_command vdvYamaha_Cinema, 'SET_POWER OFF;'
    }
    if(g_iCinema <= 1) {
	send_command vdvProjector, 'SET_POWER OFF;'
    }
}
*/
