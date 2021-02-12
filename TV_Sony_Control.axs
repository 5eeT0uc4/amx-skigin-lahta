MODULE_NAME='TV_Sony_Control' (dev vdvDevice, dev dvDevice, integer in_iShift)
/*

	Модуль управления телевизором

*/
#include 'Strings.axi'

DEFINE_DEVICE

DEFINE_CONSTANT

tl_id		= $A1
tl_long_id	= $A2
TV_POWER_ON	= 27
TV_POWER_OFF	= 28
TV_HDMI_1	= 40
TV_HDMI_2	= 41
TV_HDMI_3	= 42
TV_HDMI_4	= 53
TV_HDMI_5	= 54
TV_AV_1		= 55

DEFINE_VARIABLE

volatile long m_laTL[]		= { 1, 1000, 12000 }
volatile long m_laLongPush[2]	= { 1, 701 }
volatile integer m_iLongPush	= 10 // 0,5 sec
volatile char m_caInput[10]	= ''
volatile char m_caPower[10]	= ''
define_function fnLongPush()
{
    if(timeline_active(tl_long_id)) {
	timeline_kill(tl_long_id)
	timeline_create(tl_long_id, m_laLongPush, 2, timeline_absolute, timeline_once)
    } else {
	timeline_create(tl_long_id, m_laLongPush, 2, timeline_absolute, timeline_once)    
    }
}

DEFINE_START



DEFINE_EVENT

timeline_event[tl_long_id]
{
    switch(timeline.sequence)
    {
	case 1: 
	{ 
	    switch(m_caPower)
	    {
		case 'ON':	on[dvDevice, TV_POWER_ON + in_iShift]
		case 'OFF':	on[dvDevice, TV_POWER_OFF + in_iShift]
	    }	    
	}
	case 2:
	{ 
	    switch(m_caPower)
	    {
		case 'ON':	off[dvDevice, TV_POWER_ON + in_iShift]
		case 'OFF':	off[dvDevice, TV_POWER_OFF + in_iShift]
	    }
	}
    }
}
timeline_event[tl_id]
{
    switch(timeline.sequence)
    {
	case 1:
	{
	    switch(m_caInput)
	    {
		case 'HDMI1':	pulse[dvDevice, TV_HDMI_1 + in_iShift]
		case 'HDMI2':	pulse[dvDevice, TV_HDMI_2 + in_iShift]
		case 'HDMI3':	pulse[dvDevice, TV_HDMI_3 + in_iShift]
		case 'HDMI4':	pulse[dvDevice, TV_HDMI_4 + in_iShift]
		case 'HDMI5':	pulse[dvDevice, TV_HDMI_5 + in_iShift]
		case 'TV':	pulse[dvDevice, 2 + in_iShift]
		case 'AV1':	pulse[dvDevice, TV_AV_1 + in_iShift]
	    }
	}
	case 2:
	{
	    fnLongPush()
	}
	case 3:
	{
	    switch(m_caInput)
	    {
		case 'HDMI1':	pulse[dvDevice, TV_HDMI_1 + in_iShift]
		case 'HDMI2':	pulse[dvDevice, TV_HDMI_2 + in_iShift]
		case 'HDMI3':	pulse[dvDevice, TV_HDMI_3 + in_iShift]
		case 'TV':	pulse[dvDevice, 2 + in_iShift]
		case 'AV1':	pulse[dvDevice, TV_AV_1 + in_iShift]
	    }
	}
    }
}

data_event[vdvDevice]
{
    command:
    {
	stack_var
	char l_caReadData[100]
	char l_caTempData[100]
	
	l_caReadData = Data.Text
	
	select
	{
	    active(find_string(l_caReadData, 'SET_POWER ON;', 1)):
	    {
		m_caPower = 'ON'
		
		fnLongPush()
	    }
	    active(find_string(l_caReadData, 'SET_POWER OFF;', 1)):
	    {
		m_caPower = 'OFF'
		
		fnLongPush()
		//pulse[dvDevice, TV_POWER_OFF + in_iShift]
	    }
	    active(find_string(l_caReadData, 'SET_INPUT', 1)):
	    {
		l_caTempData = remove_string(l_caReadData, 'SET_INPUT ', 1)
		m_caPower = 'ON'
		fnStr_GetStringWhile(l_caReadData, m_caInput, ';')
		
		if(timeline_active(tl_id)) {
		    timeline_kill(tl_id)
		    timeline_create(tl_id, m_laTL, 3, timeline_absolute, timeline_once)
		} else {
		    timeline_create(tl_id, m_laTL, 3, timeline_absolute, timeline_once)
		}
	    }
	}
    
    }
}

channel_event[vdvDevice, 0]
{
    on:		{ on[dvDevice, channel.channel + in_iShift] }
    off:	{ off[dvDevice, channel.channel + in_iShift] }
}
/*
button_event[vdvDevice, button.input.channel]
{
    push:	{ on[dvDevice, button.input.channel + in_iShift] }
    release:	{ off[dvDevice, button.input.channel + in_iShift] }
}
*/

DEFINE_PROGRAM