PROGRAM_NAME='Panels_Main_Include'


DEFINE_DEVICE

DEFINE_VARIABLE

DEFINE_EVENT

data_event[g_dvaPanels]
{
    online:
    {
	stack_var integer tp
	
	tp = get_last(g_dvaPanels)

	//send_command data.device,"'ABEEP'"			// Notify device is online
	send_command data.device,"'TPAGEON'"			// Page tracking
	
	m_aPanels[tp].m_caPanelID = itoa(data.device.number)
	m_aPanels[tp].m_caIP_Address = data.SourceIP
	
	
	m_aPanels[tp].m_iOnline = 1
	fnProcessPanelUpdate(tp)
    }
    offline:
    {
	stack_var integer tp
	
	tp = get_last(g_dvaPanels)
	m_aPanels[tp].m_iOnline = 0
    }
    string:
    {
	stack_var char UDID[100], ORIENTATION[2], tp, VOLUME[3]
	
	tp = get_last(g_dvaPanels)
	debug("'[STR] :: Panel ', itoa(tp),' = ', data.text")
	if(find_string(data.text, 'UDID:', 1) == 1) {
	    remove_string(data.text, 'UDID:', 1)
	    UDID = data.text
	    m_aPanels[tp].m_caUDID = UDID
	} else
	if(find_string(data.text, 'ORIENTATION:', 1) == 1) {
	    remove_string(data.text, 'ORIENTATION:', 1)
	    ORIENTATION = data.text
	    m_aPanels[tp].m_iOrientation = atoi(ORIENTATION)	    
	} else
	if(find_string(data.text, 'VOLUME_VALUE:', 1) == 1) {
	    remove_string(data.text, 'VOLUME_VALUE:', 1)
	    VOLUME = data.text
	    send_command g_vdvaAudio[This_Room], "'SET_VOLUME ', VOLUME,';'"    
	} else
	if(find_string(data.text, 'SOUND_PROGRAM:', 1) == 1) {
	    remove_string(data.text, 'SOUND_PROGRAM:', 1)
	    send_command g_vdvaAudio[This_Room], "'SOUND_PROGRAM ', data.text"    
	}
    }
    command:
    {
	stack_var char UDID[100], tp
	
	tp = get_last(g_dvaPanels)
	debug("'[CMD] :: Panel ', itoa(tp),' = ', data.text")
    }
}

button_event[g_dvaPanels, 0]
{
    push:
    {
	stack_var integer tp
	
	tp 	= get_last(g_dvaPanels)
	THIS_Btn 	= button.input.channel
	THIS_Push 	= _push
	THIS_HoldTime	= 0
	THIS_HoldCount 	= 0
	THIS_LongPush	= 0
	send_string 0,"':: BTN(', itoa(THIS_Btn),') :: Push :: Panel(',itoa(tp),')'"
	fnProcessPanelControl(tp)
    }
    release:
    {
	stack_var integer tp
	
	tp = get_last(g_dvaPanels)
	THIS_Btn = button.input.channel
	THIS_Push = _release
	//THIS_HoldCount 	= 0
	
	//if(THIS_LongPush) {
	  //THIS_LongPush = 0
	//} 
	send_string 0,"':: BTN(', itoa(THIS_Btn),') :: Release :: Panel(',itoa(tp),')'"
	fnProcessPanelControl(tp)
    }
    hold[3, repeat]:
    {
	stack_var integer tp
	
	tp = get_last(g_dvaPanels)
	
	THIS_Btn = button.input.channel
	
	//if(THIS_HoldCount == 3)
	    THIS_Push = _hold
	
	if(THIS_HoldCount >= 2)
	    THIS_LongPush = 1
	
	// if count >= 20 --> Mega_Hold :))
	
	THIS_HoldTime = button.holdtime
	THIS_HoldCount ++
	send_string 0,"':: BTN(', itoa(THIS_Btn),') :: Hold Count :: = ', itoa(THIS_HoldCount),', Panel(',itoa(tp),')'"
	
	fnProcessPanelControl(tp)
    }
}
