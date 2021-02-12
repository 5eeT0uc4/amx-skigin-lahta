MODULE_NAME='SAT_HD_Control' (dev vdvDevice, dev dvDevice, integer in_iShift)
/*

	Модуль управления спутниковым ресивером

*/

#include 'Strings.axi'

DEFINE_DEVICE

DEFINE_CONSTANT

tl_id		= $A1
tl_long_id	= $A2
tl_power_off	= $A3
POWER_ON	= 27
POWER_OFF	= 28
POWER		= 31

DEFINE_VARIABLE

volatile long m_laTL[]		= { 1, 600, 8000 }
volatile long m_laLongPush[2]	= { 1, 701 }
volatile long m_laPowerOff[3]	= { 1, 701 }
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
define_function fnPowerOff()
{
    if(timeline_active(tl_power_off)) {
	timeline_kill(tl_power_off)
	timeline_create(tl_power_off, m_laPowerOff, 2, timeline_absolute, timeline_once)
    } else {
	timeline_create(tl_power_off, m_laPowerOff, 2, timeline_absolute, timeline_once)    
    }
}

DEFINE_START

DEFINE_EVENT

timeline_event[tl_long_id]
{
    switch(timeline.sequence)
    {
	case 1: { pulse[dvDevice, 10 + in_iShift] }
	case 2: { pulse[dvDevice, 31 + in_iShift] }
    }
}
timeline_event[tl_power_off]
{
    switch(timeline.sequence)
    {
	case 1: { pulse[dvDevice, 10 + in_iShift] }
	case 2: { pulse[dvDevice, 31 + in_iShift] }
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
	    active(find_string(l_caReadData, 'SET_POWER ON;', 1) == 1):
	    {
		pulse[dvDevice, 10 + in_iShift]
		//fnLongPush()
	    }
	    active(find_string(l_caReadData, 'SET_POWER OFF;', 1) == 1):
	    {
		fnPowerOff()//pulse[dvDevice, TV_POWER_OFF + in_iShift]
	    }
	}
    }
}

channel_event[vdvDevice, channel.channel]
{
    on:		
    {
	if(channel.channel < 255)	{
	    on[dvDevice, channel.channel + in_iShift]
	}
	if(channel.channel > 255)	{
	    send_command dvDevice, "'SEND_IR ',itoa(channel.channel),',1;'"
	}
    }
    off:	
    {
	if(channel.channel < 255)	{
	    off[dvDevice, channel.channel + in_iShift]
	}
    }
}
/*
button_event[vdvDevice, button.input.channel]
{
    push:	{ on[dvDevice, button.input.channel + in_iShift] }
    release:	{ off[dvDevice, button.input.channel + in_iShift] }
}
*/
DEFINE_PROGRAM

