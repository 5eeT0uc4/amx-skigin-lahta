MODULE_NAME='Sony_BD_Control' (dev vdvDevice, dev dvDevice, integer in_iShift)

#include 'Strings.axi'

DEFINE_DEVICE

DEFINE_CONSTANT

tl_id		= $A1
tl_long_id	= $A2
TV_POWER_ON	= 27
TV_POWER_OFF	= 28

DEFINE_VARIABLE

volatile long m_laTL[]		= { 1, 600, 8000 }
volatile long m_laLongPush[2]	= { 1, 701 }
volatile integer m_iLongPush	= 10 // 0,5 sec
volatile char m_caInput[10]	= ''

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
	case 1: { on[dvDevice, TV_POWER_ON + in_iShift] }
	case 2: { off[dvDevice, TV_POWER_ON + in_iShift] }
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
		//fnLongPush()
		//pulse[dvDevice, TV_POWER_ON + in_iShift]
		pulse[dvDevice, 1]
	    }
	    active(find_string(l_caReadData, 'SET_POWER OFF;', 1)):
	    {
		//pulse[dvDevice, TV_POWER_OFF + in_iShift]
		pulse[dvDevice, 2]
	    }
	}
    }
}

channel_event[vdvDevice, channel.channel]
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
