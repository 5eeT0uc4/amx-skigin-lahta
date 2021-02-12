MODULE_NAME='MusicCast' (dev vdvDevice, dev dvDevice, char m_caIPAddress[])

/*
команды MusicCast
{nameZone}:  "main" / "zone2" / "zone3" / "zone4" 
{nameInput}:  cd / tuner / multi_ch / phono / hdmi1 / hdmi2 / hdmi3 / hdmi4 / hdmi5 / hdmi6 / hdmi7 / hdmi8 / hdmi / av1 / av2 / av3 / av4 / av5 / av6 / av7 / v_aux / aux1 / aux2 / aux / audio1 / audio2 / audio3 / audio4 / audio_cd / audio / optical1 / optical2 / optical / coaxial1 / coaxial2 / coaxial / digital1 / digital2 / digital / line1 / line2 / line3 / line_cd / analog / tv / bd_dvd / usb_dac / usb / bluetooth / server / net_radio / rhapsody / napster / pandora / siriusxm / spotify / juke / airplay / radiko / qobuz / mc_link / main_sync / none 

1. power: http://{host}/YamahaExtendedControl/v1/{nameZone}/setPower?power={ "on" / "standby" / "toggle" }
2. volume: http://{host}/YamahaExtendedControl/v1/{nameZone}/setVolume?volume={value/ "up" / "down"}&step={stepNumber} 
step is integer and no required
3. mute: http://{host}/YamahaExtendedControl/v1/{nameZone}/setMute?enable={false/true}
4. input: http://{host}/YamahaExtendedControl/v1/{nameZone}/setInput?input={nameInput}&mode=autoplay_disabled 
5. tone control http://{host}/YamahaExtendedControl/v1/{nameZone}/setToneControl?mode=manual&bass={bassNumber}&treble={trebleNumber}
*/
#include 'Strings.axi'

DEFINE_DEVICE

dvDebug = 0:0:0

DEFINE_CONSTANT

tl_ping_id 		= $A1 //идентификатор пинга
tl_close_socket_id	= $B1

TL_Wait_Drill		= $C1
TL_Drill_Down		= $C2

tcp			= 1
udp			= 0
true			= 1
false			= 0
m_lPort			= 80

DEFINE_TYPE

structure act_vol_s
{
    char m_caMode[10]
    char m_caValue[10]
    char m_caUnit[10]
}

structure eq_s
{
    char m_caMode[10]
    char m_caLow[10]
    char m_caMid[10]
    char m_caHigh[10]
    char m_caBalance[10]

    float m_fMode
    float m_fLow
    float m_fMid
    float m_fHigh
    float m_fBalance
    
    double m_dLow
    double m_dMid
    double m_dHigh
    
}

structure tone_s
{
    char m_caMode[10]
    char m_caBass[10]
    char m_caTreble[10]

    float m_fBass
    float m_fTreble
}

structure mc_s
{
    char m_caPower[10]
    char m_caInput[10]
    char m_caVolume[10]
    char m_caMaxVolume[10]
    char m_caMute[10]
    char m_caMode[10]
    char m_caSoundProgram[20]
    char m_caBassExtension[10]
    char m_caBalance[10]
    char m_caDirect[10]
    char m_caClearVoice[10]
    char m_caPureDirect[10]
    char m_caDialogueLevel[10]
    char m_caEnhancer[10]
    char m_caSurroundDecoderType[50]
    

    integer m_iVolume
    integer m_iMute
    integer m_iMaxVolume
    float m_fPureDirect
    float m_fDialogueLevel
    float m_fPartyEnable
    float m_fSubwooferVolume
    float m_fClearVoice
    float m_fBalance

    eq_s m_sEqualizer
    tone_s m_sToneControl
    act_vol_s m_sActualVolume
}

DEFINE_VARIABLE

volatile integer 	_debug				= 0 //отладка

volatile mc_s		MusicCast
volatile char 		m_caInput[10]			= ''
volatile integer 	m_iClientOnline			= 0 //сокет онлайн
volatile integer 	m_iClientKeepOpen 		= 1 //поддержание соединения
volatile slong 		m_iClientConnectResult 		= 0 //результат подключения
volatile long 		m_laTimeToClose[1]		= 10000
volatile integer 	m_iOnWork			= 0 //режим работы
volatile integer	m_iCount			= 0

volatile char packet[255]


volatile integer	m_iDunePowerState	= 0
volatile long 		m_laPing[1]		= 10000 	// промежуток времени через который производится пинг

define_function fnOnDisconnect()
{
    if(m_iClientOnline)
	ip_client_close(dvDevice.port)
}
define_function fnOnConnect()
{
    if(!m_iClientOnline)
	ip_client_open(dvDevice.port, m_caIPAddress, m_lPort, tcp)
}

define_function fnOnSend(char in_caData[])
{
    printf("'MusiCast.Port[', itoa(dvDevice.port),'] :: ~TxData* ', in_caData")
    
    if(m_iClientOnline)	{
	send_string dvDevice, "in_caData"
    } else {
	ip_client_open(dvDevice.port, m_caIPAddress, m_lPort, tcp)
	send_string dvDevice, "in_caData"
    }
}

define_function fnReset_TL()
{   
    //запуск таймлайна на закрытие сокета по таймауту
    if(timeline_active(tl_ping_id)) { //проверка активности таймлайна
	timeline_kill(tl_ping_id) //перезапуск таймлайна
	timeline_create(tl_ping_id, m_laPing, 1, timeline_absolute, timeline_repeat)
    } else {
	timeline_create(tl_ping_id, m_laPing, 1, timeline_absolute, timeline_repeat)
    }
}

define_function fnControl(integer in_iCh)
{    
    //fnReset_TL()
    stack_var char l_caValue[10]
    stack_var float l_fValue
    l_caValue = ''
    
    printf("'fnControl - ', itoa(in_iCh)")
    
    switch(in_iCh)
    {
	case 24:
	case 97:{
	    fnOnSend("'GET /YamahaExtendedControl/v1/main/setVolume?volume=up', packet")
	}
	case 25:
	case 98:{
	    fnOnSend("'GET /YamahaExtendedControl/v1/main/setVolume?volume=down', packet")
	}
	case 26:
	case 99:{
	    if(find_string(MusicCast.m_caMute, 'false', 1) == 1){
		l_caValue = 'true'
	    } else
	    if(find_string(MusicCast.m_caMute, 'true', 1) == 1){
		l_caValue = 'false'
	    }
	    fnOnSend("'GET /YamahaExtendedControl/v1/main/setMute?enable=', l_caValue, packet")
	}
	case 201:{
	    if(MusicCast.m_fSubwooferVolume < 12)
		fnOnSend("'GET /YamahaExtendedControl/v1/main/setSubwooferVolume?volume=', ftoa(MusicCast.m_fSubwooferVolume + 1), packet")
	}
	case 202:{
	    if(MusicCast.m_fSubwooferVolume > -12)
		fnOnSend("'GET /YamahaExtendedControl/v1/main/setSubwooferVolume?volume=', ftoa(MusicCast.m_fSubwooferVolume - 1), packet")
	}
	case 203:{
	    if(find_string(MusicCast.m_caClearVoice, 'false', 1) == 1){
		l_caValue = 'true'
	    } else
	    if(find_string(MusicCast.m_caClearVoice, 'true', 1) == 1){
		l_caValue = 'false'
	    }
	    fnOnSend("'GET /YamahaExtendedControl/v1/main/setClearVoice?enable=', l_caValue, packet")
	}
	case 204:{
	    if(find_string(MusicCast.m_caBassExtension, 'false', 1) == 1){
		l_caValue = 'true'
	    } else
	    if(find_string(MusicCast.m_caBassExtension, 'true', 1) == 1){
		l_caValue = 'false'
	    }
	    fnOnSend("'GET /YamahaExtendedControl/v1/main/setBassExtension?enable=', l_caValue, packet")
	}
	//Direct
	case 205:{
	    if(find_string(MusicCast.m_caDirect, 'false', 1) == 1){
		l_caValue = 'true'
	    } else
	    if(find_string(MusicCast.m_caDirect, 'true', 1) == 1){
		l_caValue = 'false'
	    }
	    fnOnSend("'GET /YamahaExtendedControl/v1/main/setDirect?enable=', l_caValue, packet")
	}
	//Enhancer
	case 206:{
	    if(find_string(MusicCast.m_caEnhancer, 'false', 1) == 1){
		l_caValue = 'true'
	    } else {
		l_caValue = 'false'
	    }
	    fnOnSend("'GET /YamahaExtendedControl/v1/main/setEnhancer?enable=', l_caValue, packet")
	}
	//Balance +
	case 207:{
	    l_fValue = MusicCast.m_fBalance
	    if(l_fValue < 12)
		fnOnSend("'GET /YamahaExtendedControl/v1/main/setBalance?value=', ftoa(l_fValue + 1), packet")
	}
	//Balance -
	case 208:{
	    l_fValue = MusicCast.m_fBalance
	    if(l_fValue < -12)
		fnOnSend("'GET /YamahaExtendedControl/v1/main/setBalance?value=', ftoa(l_fValue - 1), packet")
	}
	//Low +
	case 209:{
	    l_fValue = MusicCast.m_sEqualizer.m_fLow
	    printf("'MusicCast.m_sEqualizer.m_fLow = ', ftoa(l_fValue)")
	    if(l_fValue < 12)
		fnOnSend("'GET /YamahaExtendedControl/v1/main/setEqualizer?mode=manual&low=', ftoa(l_fValue + 1), packet")	
	}
	//Low -
	case 210:{
	    l_fValue = MusicCast.m_sEqualizer.m_fLow
	    printf("'MusicCast.m_sEqualizer.m_fLow = ', ftoa(l_fValue)")
	    if(l_fValue > -12)
		fnOnSend("'GET /YamahaExtendedControl/v1/main/setEqualizer?mode=manual&low=', ftoa(l_fValue - 1), packet")	
	}
	//Mid +
	case 211:{
	    l_fValue = MusicCast.m_sEqualizer.m_fMid
	    printf("'MusicCast.m_sEqualizer.m_fMid = ', ftoa(l_fValue)")
	    if(l_fValue < 12)
		fnOnSend("'GET /YamahaExtendedControl/v1/main/setEqualizer?mode=manual&mid=', ftoa(l_fValue + 1), packet")	
	}
	//Mid -
	case 212:{
	    l_fValue = MusicCast.m_sEqualizer.m_fMid
	    printf("'MusicCast.m_sEqualizer.m_fMid = ', ftoa(l_fValue)")
	    if(l_fValue > -12)
		fnOnSend("'GET /YamahaExtendedControl/v1/main/setEqualizer?mode=manual&mid=', ftoa(l_fValue - 1), packet")	
	}
	//High +
	case 213:{
	    l_fValue = MusicCast.m_sEqualizer.m_fHigh
	    printf("'MusicCast.m_sEqualizer.m_fHigh = ', ftoa(l_fValue)")
	    if(l_fValue < 12)
		fnOnSend("'GET /YamahaExtendedControl/v1/main/setEqualizer?mode=manual&high=', ftoa(l_fValue + 1), packet")	
	}
	//High -
	case 214:{
	    l_fValue = MusicCast.m_sEqualizer.m_fHigh
	    printf("'MusicCast.m_sEqualizer.m_fHigh = ', ftoa(l_fValue)")
	    if(l_fValue > -12)
		fnOnSend("'GET /YamahaExtendedControl/v1/main/setEqualizer?mode=manual&high=', ftoa(l_fValue - 1), packet")	
	}
	//Treble +
	case 215:{
	    l_fValue = MusicCast.m_sToneControl.m_fTreble
	    printf("'MusicCast.m_sToneControl.m_fTreble = ', ftoa(l_fValue)")
	    if(l_fValue < 12)
		fnOnSend("'GET /YamahaExtendedControl/v1/main/setToneControl?mode=manual&treble=', ftoa(l_fValue + 1), packet")	
	}
	//Treble -
	case 216:{
	    l_fValue = MusicCast.m_sToneControl.m_fTreble
	    printf("'MusicCast.m_sToneControl.m_fTreble = ', ftoa(l_fValue)")
	    if(l_fValue > -12)
		fnOnSend("'GET /YamahaExtendedControl/v1/main/setToneControl?mode=manual&treble=', ftoa(l_fValue - 1), packet")	
	}
	//Bass +
	case 217:{
	    l_fValue = MusicCast.m_sToneControl.m_fBass
	    printf("'MusicCast.m_sToneControl.m_fBass = ', ftoa(l_fValue)")
	    if(l_fValue < 12)
		fnOnSend("'GET /YamahaExtendedControl/v1/main/setToneControl?mode=manual&bass=', ftoa(l_fValue + 1), packet")	
	}
	//Bass -
	case 218:{
	    l_fValue = MusicCast.m_sToneControl.m_fBass
	    printf("'MusicCast.m_sToneControl.m_fBass = ', ftoa(l_fValue)")
	    if(l_fValue > -12)
		fnOnSend("'GET /YamahaExtendedControl/v1/main/setToneControl?mode=manual&bass=', ftoa(l_fValue - 1), packet")	
	}
	//Pure Direct
	case 219:{
	    if(find_string(MusicCast.m_caPureDirect, 'false', 1) == 1){
		l_caValue = 'true'
	    } else
	    if(find_string(MusicCast.m_caEnhancer, 'true', 1) == 1){
		l_caValue = 'false'
	    }
	    fnOnSend("'GET /YamahaExtendedControl/v1/main/setPureDirect?enable=', l_caValue, packet")
	}
	//Dialogue Level +
	case 220:{
	    l_fValue = MusicCast.m_fDialogueLevel
	    printf("'MusicCast.m_fDialogueLevel = ', ftoa(l_fValue)")
	    if(l_fValue < 12)
		fnOnSend("'GET /YamahaExtendedControl/v1/main/setDialogueLevel?value=', ftoa(l_fValue + 1), packet")	
	}
	//Dialogue Level -
	case 221:{
	    l_fValue = MusicCast.m_fDialogueLevel
	    printf("'MusicCast.m_fDialogueLevel = ', ftoa(l_fValue)")
	    if(l_fValue > -12)
		fnOnSend("'GET /YamahaExtendedControl/v1/main/setDialogueLevel?value=', ftoa(l_fValue - 1), packet")	
	}
    }
    
    //fnGetStatus()
}

//функция пинга
define_function fnGetStatus()
{
    fnOnSend("'GET /YamahaExtendedControl/v1/main/getStatus',packet")
}

define_function printf(char in_caData[])
{
    if(_debug)
	send_string 0, "in_caData"
}

define_function fnOnReceive(char in_caData[])
{
    local_var char l_caMode[100]
    local_var char l_caTmp[2048]
    local_var char l_caValue[2048]
    local_var char l_caMaxVolume[10]
    local_var float l_fValue
    
    if(find_string(in_caData, '"response_code":0', 1) > 0){
	//
	if(FIND_STRING(in_caData, '"power":"', 1) > 0)
	{
	    l_caTmp = in_caData
	    remove_string(l_caTmp, '"power":"', 1)
	    l_caValue = remove_string(l_caTmp, '"', 1)
	    set_length_string(l_caValue, length_string(l_caValue) - 1)
	    MusicCast.m_caPower = l_caValue
	}
	if(FIND_STRING(in_caData, '"max_volume":', 1) > 0)
	{
	    l_caTmp = in_caData
	    remove_string(l_caTmp, '"max_volume":', 1)
	    MusicCast.m_iMaxVolume = atoi(l_caTmp)
	}
	if(FIND_STRING(in_caData, '"volume":', 1) > 0)
	{
	    l_caTmp = in_caData
	    remove_string(l_caTmp, '"volume":', 1)
	    MusicCast.m_iVolume = fnCONVERT(atoi(l_caTmp),0,MusicCast.m_iMaxVolume,0,255)
	    MusicCast.m_caVolume = itoa(MusicCast.m_iVolume)
	    send_level vdvDevice, 1, atoi(MusicCast.m_caVolume)
	}
	if(FIND_STRING(in_caData, '"mute":', 1) > 0)
	{
	    l_caTmp = in_caData
	    remove_string(l_caTmp, '"mute":', 1)
	    l_caValue = remove_string(l_caTmp, ',', 1)
	    set_length_string(l_caValue, length_string(l_caValue) - 1)
	    MusicCast.m_caMute = l_caValue
	    MusicCast.m_iMute = l_caValue == 'true'	    
	    send_level vdvDevice, 2, MusicCast.m_iMute
	}
	if(FIND_STRING(in_caData, '"input":', 1) > 0)
	{
	    l_caTmp = in_caData
	    remove_string(l_caTmp, '"input":"', 1)
	    l_caValue = remove_string(l_caTmp, '"', 1)
	    set_length_string(l_caValue, length_string(l_caValue) - 1)
	    MusicCast.m_caInput = l_caValue
	}
	if(FIND_STRING(in_caData, 'subwoofer_volume', 1) > 0)
	{
	    l_caTmp = in_caData
	    remove_string(l_caTmp, '"subwoofer_volume":', 1)
	    printf("'subwoofer_volume data - ', l_caTmp")
	    if(MusicCast.m_fSubwooferVolume != atof(l_caTmp)){
		MusicCast.m_fSubwooferVolume = atof(l_caTmp)
		send_string vdvDevice, "'SUBWOOFER_VOLUME:',ftoa(MusicCast.m_fSubwooferVolume)"
	    }
	}
	if(FIND_STRING(in_caData, 'balance', 1) > 0)
	{
	    l_caTmp = in_caData
	    remove_string(l_caTmp, '"balance":', 1)
	    if(MusicCast.m_fBalance != atof(l_caTmp)){
		MusicCast.m_fBalance = atof(l_caTmp)
		send_string vdvDevice, "'BALANCE:',ftoa(MusicCast.m_fSubwooferVolume)"
	    }
	    //send_level vdvDevice, 7, MusicCast.m_fBalance
	}
	if(FIND_STRING(in_caData, 'sound_program', 1) > 0)
	{
	    l_caTmp = in_caData
	    remove_string(l_caTmp, '"sound_program":"', 1)
	    l_caValue = remove_string(l_caTmp, '"', 1)
	    set_length_string(l_caValue, length_string(l_caValue) - 1)
	    if(length_string(MusicCast.m_caSoundProgram) && MusicCast.m_caSoundProgram != l_caValue){
		MusicCast.m_caSoundProgram = l_caValue
		send_string vdvDevice, "'SOUND_PROGRAM:', l_caValue"
	    }
	}
	if(FIND_STRING(in_caData, 'clear_voice', 1) > 0)
	{
	    l_caTmp = in_caData
	    remove_string(l_caTmp, '"clear_voice":', 1)
	    l_caValue = remove_string(l_caTmp, ',', 1)
	    set_length_string(l_caValue, length_string(l_caValue) - 1)
	    MusicCast.m_caClearVoice = l_caValue
	    [vdvDevice, 103] = (MusicCast.m_caClearVoice == 'true')//clear voice
	}
	if(FIND_STRING(in_caData, 'bass_extension', 1) > 0)
	{
	    l_caTmp = in_caData
	    remove_string(l_caTmp, '"bass_extension":', 1)
	    l_caValue = remove_string(l_caTmp, ',', 1)
	    set_length_string(l_caValue, length_string(l_caValue) - 1)
	    MusicCast.m_caBassExtension = l_caValue
	    [vdvDevice, 104] = (MusicCast.m_caBassExtension == 'true')//bass extension
	}
	if(FIND_STRING(in_caData, 'tone_control', 1) > 0)
	{
	    l_caTmp = in_caData
	    remove_string(l_caTmp, 'tone_control":', 1)
	    l_caTmp = remove_string(l_caTmp, '}', 1)
	    
	    printf("'tone_control - ', l_caTmp")
	    
	    if(find_string(l_caTmp, '"mode"', 1)){
		l_caMode = l_caTmp
		remove_string(l_caMode, '"mode":"', 1)
		l_caMode = remove_string(l_caMode, '"', 1)
		set_length_string(l_caMode, length_string(l_caMode) - 1)
		if(MusicCast.m_sToneControl.m_caMode != l_caMode){
		    MusicCast.m_sToneControl.m_caMode = l_caMode
		    send_string vdvDevice, "'TONE_CONTROL_MODE:', l_caMode"
		}
	    }
	    if(find_string(l_caTmp, '"bass"', 1)){
		l_caValue = l_caTmp
		remove_string(l_caValue, '"bass":', 1)
		if(MusicCast.m_sToneControl.m_caBass != ftoa(atof(l_caValue))){
		    MusicCast.m_sToneControl.m_caBass = ftoa(atof(l_caValue))
		    MusicCast.m_sToneControl.m_fBass = atof(MusicCast.m_sToneControl.m_caBass)
		    send_string vdvDevice, "'TONE_CONTROL_BASS:', MusicCast.m_sToneControl.m_caBass"
		}
		//send_level vdvDevice, 4, atof(l_caValue)
	    }
	    if(find_string(l_caTmp, '"treble"', 1)){
		l_caValue = l_caTmp
		remove_string(l_caValue, '"treble":', 1)
		if(MusicCast.m_sToneControl.m_caTreble != ftoa(atof(l_caValue))){
		    MusicCast.m_sToneControl.m_caTreble = ftoa(atof(l_caValue))
		    MusicCast.m_sToneControl.m_fTreble = atof(MusicCast.m_sToneControl.m_caTreble)
		    send_string vdvDevice, "'TONE_CONTROL_TREBLE:', MusicCast.m_sToneControl.m_caTreble"
		}
		//send_level vdvDevice, 5, atof(l_caValue)
	    }
	}
	//surround decoder type
	if(FIND_STRING(in_caData, 'surround_decoder_type', 1) > 0)
	{
	    l_caTmp = in_caData
	    remove_string(l_caTmp, '"surround_decoder_type":"', 1)
	    l_caValue = remove_string(l_caTmp, '"', 1)
	    set_length_string(l_caValue, length_string(l_caValue) - 1)
	    if(length_string(MusicCast.m_caSurroundDecoderType) && MusicCast.m_caSurroundDecoderType != l_caValue){
		MusicCast.m_caSurroundDecoderType = l_caValue
		send_string vdvDevice, "'SURROUND_DECODER:', MusicCast.m_caSurroundDecoderType"
	    }
	}
	//EQ
	if(FIND_STRING(in_caData, 'equalizer', 1) > 0)
	{
	    l_caTmp = in_caData
	    remove_string(l_caTmp, 'equalizer":', 1)
	    l_caTmp = remove_string(l_caTmp, '}', 1)
	    
	    printf("'equalizer - ', l_caTmp")
	    
	    if(find_string(l_caTmp, '"mode"', 1)){
		l_caValue = l_caTmp
		remove_string(l_caValue, '"mode":"', 1)
		l_caValue = remove_string(l_caValue, '"', 1)
		set_length_string(l_caValue, length_string(l_caValue) - 1)
		printf("'equalizer mode: ', l_caValue")
		if(MusicCast.m_sEqualizer.m_caMode != l_caValue){
		    MusicCast.m_sEqualizer.m_caMode = l_caValue
		    send_string vdvDevice, "'EQUALIZER_MODE:', l_caValue"
		}
	    }
	    if(find_string(l_caTmp, '"low"', 1)){
		l_caValue = l_caTmp
		remove_string(l_caValue, '"low":', 1)
		l_fValue = atof(l_caValue)
		if(MusicCast.m_sEqualizer.m_caLow != l_caValue){
		    MusicCast.m_sEqualizer.m_caLow = l_caValue
		    MusicCast.m_sEqualizer.m_fLow = l_fValue
		    send_string vdvDevice, "'EQUALIZER_LOW:', MusicCast.m_sEqualizer.m_caLow"
		}
		printf("'equalizer low: ', MusicCast.m_sEqualizer.m_caLow")
	    }
	    if(find_string(l_caTmp, '"mid"', 1)){
		l_caValue = l_caTmp
		remove_string(l_caValue, '"mid":', 1)
		l_fValue = atof(l_caValue)
		if(MusicCast.m_sEqualizer.m_caMid != l_caValue){
		    MusicCast.m_sEqualizer.m_caMid = l_caValue
		    MusicCast.m_sEqualizer.m_fMid = l_fValue
		    send_string vdvDevice, "'EQUALIZER_MID:', MusicCast.m_sEqualizer.m_caMid"
		}
		//send_level vdvDevice, 9, l_fValue
		printf("'equalizer mid: ', MusicCast.m_sEqualizer.m_caMid")
	    }
	    if(find_string(l_caTmp, '"high"', 1)){
		l_caValue = l_caTmp
		remove_string(l_caValue, '"high":', 1)
		l_fValue = atof(l_caValue)
		if(MusicCast.m_sEqualizer.m_caHigh != l_caValue){
		    MusicCast.m_sEqualizer.m_caHigh = l_caValue
		    MusicCast.m_sEqualizer.m_fHigh = l_fValue
		    send_string vdvDevice, "'EQUALIZER_HIGH:', MusicCast.m_sEqualizer.m_caHigh"
		}
		//send_level vdvDevice, 8, l_fValue
		printf("'equalizer high: ', MusicCast.m_sEqualizer.m_caHigh")
	    }
	}
	//Pure Direct
	if(FIND_STRING(in_caData, 'pure_direct', 1) > 0)
	{
	    l_caTmp = in_caData
	    remove_string(l_caTmp, '"pure_direct":', 1)
	    l_caValue = remove_string(l_caTmp, ',', 1)
	    set_length_string(l_caValue, length_string(l_caValue) - 1)
	    MusicCast.m_caPureDirect = l_caValue
	    
	    [vdvDevice, 103] = (MusicCast.m_caClearVoice == 'true')//clear voice
	}
	//Dialogue Level
	if(FIND_STRING(in_caData, 'dialogue_level', 1) > 0)
	{
	    l_caTmp = in_caData
	    remove_string(l_caTmp, '"dialogue_level":', 1)
	    l_caValue = remove_string(l_caTmp, ',', 1)
	    set_length_string(l_caValue, length_string(l_caValue) - 1)	    
	    //send_level vdvDevice, 6, l_fValue
	    if(MusicCast.m_caDialogueLevel != l_caValue){
		MusicCast.m_caDialogueLevel = l_caValue
		MusicCast.m_fDialogueLevel = atof(l_caValue)
		send_string vdvDevice, "'DIALOGUE_LEVEL:', l_caValue"
	    }
	}
	//Enhancer
	if(FIND_STRING(in_caData, 'enhancer', 1) > 0)
	{
	    l_caTmp = in_caData
	    remove_string(l_caTmp, '"enhancer":', 1)
	    l_caValue = remove_string(l_caTmp, ',', 1)
	    set_length_string(l_caValue, length_string(l_caValue) - 1)
	    MusicCast.m_caEnhancer = l_caValue	    
	    [vdvDevice, 106] = (MusicCast.m_caEnhancer == 'true')//enhancer
	}
	//Direct
	if(FIND_STRING(in_caData, 'direct', 1) > 0)
	{
	    l_caTmp = in_caData
	    remove_string(l_caTmp, '"direct":', 1)
	    l_caValue = remove_string(l_caTmp, ',', 1)
	    set_length_string(l_caValue, length_string(l_caValue) - 1)
	    MusicCast.m_caDirect = l_caValue	    
	    [vdvDevice, 105] = (MusicCast.m_caDirect == 'true')//direct
	}
	//fnCreateFb()
    }
}

define_function fnSendLongDebugMsg(char dbgmsg[])
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
	    
	    send_string dvDebug,"'Yamaha:'";
	    for(pCursor=1; pCursor <= lenpacket; pCursor = pCursor+block)
	    {
		select
		{
		    active(pCursor==1): 				
			send_string dvDebug,"'# ',mid_string(dbgmsg,pCursor,block)";
		    active((pCursor+block) <= lenpacket):
			send_string dvDebug,"'- ',mid_string(dbgmsg,pCursor,block)";
		    active((pCursor+block) > lenpacket):
		    {
			integer bytesleft;
			bytesleft = lenpacket-pCursor+1;
			send_string dvDebug,"'- ',right_string(dbgmsg,bytesleft)";
		    }
		}
	    }
	}
	else
	{
	    send_string dvDebug,"'Yamaha: ', dbgmsg";
	}
    }
}

define_function fnCreateFb()
{
    stack_var float l_fSub
    stack_var float l_fHigh
    stack_var float l_fMid
    stack_var float l_fLow
    stack_var float l_fBass
    stack_var float l_fTreble
    stack_var float l_fDialogueLevel
    stack_var float l_fBalance
    
    l_fSub = MusicCast.m_fSubwooferVolume
    l_fHigh = MusicCast.m_sEqualizer.m_fHigh
    l_fMid = MusicCast.m_sEqualizer.m_fMid
    l_fLow = MusicCast.m_sEqualizer.m_fLow
    l_fBass = atof(MusicCast.m_sToneControl.m_caBass)
    l_fTreble = atof(MusicCast.m_sToneControl.m_caTreble)
    l_fDialogueLevel = atof(MusicCast.m_caDialogueLevel)
    l_fBalance = MusicCast.m_sEqualizer.m_fBalance
    
    send_level vdvDevice, 1, atoi(MusicCast.m_caVolume) 
    send_level vdvDevice, 2, MusicCast.m_iMute
    send_level vdvDevice, 3, l_fSub
    send_level vdvDevice, 4, l_fBass//bass
    send_level vdvDevice, 5, l_fTreble//treble
    send_level vdvDevice, 6, l_fDialogueLevel//dialogue level
    send_level vdvDevice, 7, l_fBalance//balance
    
    send_level vdvDevice, 8, l_fHigh//high
    send_level vdvDevice, 9, l_fMid//mid
    send_level vdvDevice, 10, l_fLow//low
        
    if(length_string(MusicCast.m_caSoundProgram))
	send_string vdvDevice, "'SOUND_PROGRAM:', MusicCast.m_caSoundProgram"
    if(length_string(MusicCast.m_caSurroundDecoderType))
	send_string vdvDevice, "'SURROUND_DECODER:', MusicCast.m_caSurroundDecoderType"
    
    
    [vdvDevice, 104] = (MusicCast.m_caBassExtension == 'true')//bass extension
    [vdvDevice, 103] = (MusicCast.m_caClearVoice == 'true')//clear voice
    [vdvDevice, 105] = (MusicCast.m_caDirect == 'true')//direct
    [vdvDevice, 106] = (MusicCast.m_caEnhancer == 'true')//enhancer
    [vdvDevice, 119] = (MusicCast.m_caPureDirect == 'true')//pure direct
    
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

DEFINE_START

packet = "' HTTP/1.1',13,10,'HOST: ', m_caIPAddress,13,10,'Connection: Keep-Alive',13,10,13,10"

DEFINE_EVENT

//запрос статуса
timeline_event[TL_PING_ID]
{
    if(timeline.sequence == 1)
	fnGetStatus()
}

//обработка физического порта
data_event[dvDevice]
{
    online:
    {
	m_iClientOnline = true
	//fnReset_TL()
	printf("'MusiCast.Port[', itoa(dvDevice.port),'] :: Online!!!'")
    }
    offline:
    {
	m_iClientOnline = false
	//fnReset_TL()
	if(m_iClientKeepOpen)
	    fnOnConnect()
	printf("'MusiCast.Port[', itoa(dvDevice.port),'] :: Offline!!!'")
    }
    string:
    {
	//printf("'MusiCast.Port[', itoa(dvDevice.port),'] :: ~RxData: * ', data.text")
	fnSendLongDebugMsg(data.text)
	fnOnReceive(data.text)
    }
    onerror:
    {
	printf("'dvMusiCast.Port[', itoa(dvDevice.port),'] :: OnError(',itoa(data.number),')'")
	    
	switch(data.number)
	{
	    //две ошибки при которых не требуется переоткрытие сокета
	    case 9: // Socket closed in response to ip_client_close	
	    case 14: // Local port already used
	    {
	    }
	    default: //all others error. May want to re-try connection
	    {
	    }
	}
    }
}
//обработка виртуального порта
data_event[vdvDevice]
{
    online:
    {
	
    }
    command:
    {
	stack_var char l_caReadData[100]
	
	l_caReadData = Data.Text
	
	select
	{
	    active(find_string(l_caReadData, 'DEBUG ON;', 1)):
	    {
		_debug = 1
	    }
	    active(find_string(l_caReadData, 'DEBUG OFF;', 1)):
	    {
		_debug = 0
	    }
	    active(find_string(l_caReadData, 'START;', 1)):
	    {
		fnGetStatus()
		m_iOnWork = 1
		timeline_create(tl_ping_id, m_laPing, 1, timeline_absolute, timeline_repeat)
	    }
	    active(find_string(l_caReadData, 'STOP;', 1)):
	    {
		m_iOnWork = 0
		if(timeline_active(tl_ping_id))
		    timeline_kill(tl_ping_id)
	    }
	    active(find_string(l_caReadData, 'SET_INPUT', 1)):
	    {
		remove_string(l_caReadData, 'SET_INPUT ', 1)
		set_length_string(l_caReadData, length_string(l_caReadData) - 1)
		m_caInput = l_caReadData
		
		fnOnSend("'GET /YamahaExtendedControl/v1/main/setPower?power=on',packet")
		fnOnSend("'GET /YamahaExtendedControl/v1/main/setInput?input=', m_caInput,'&mode=autoplay_disabled',packet")
	    }
	    active(find_string(l_caReadData, 'SET_POWER ON;', 1)):
	    {
		fnOnSend("'GET /YamahaExtendedControl/v1/main/setPower?power=on',packet")
	    }
	    active(find_string(l_caReadData, 'SET_POWER OFF;', 1)):
	    {
		fnOnSend("'GET /YamahaExtendedControl/v1/main/setPower?power=standby',packet")
	    }
	    active(find_string(l_caReadData, 'SOUND_PROGRAM', 1)):
	    {
		remove_string(l_caReadData, 'SOUND_PROGRAM ', 1)
		fnOnSend("'GET /YamahaExtendedControl/v1/main/setSoundProgram?program=',l_caReadData,packet")
	    }
	    active(find_string(l_caReadData, 'SET_VOLUME', 1)):
	    {
		remove_string(l_caReadData, 'SET_VOLUME ', 1)
		set_length_string(l_caReadData, length_string(l_caReadData) - 1)
		fnOnSend("'GET /YamahaExtendedControl/v1/main/setVolume?volume=',itoa(fnCONVERT(atoi(l_caReadData),0,255,0,MusicCast.m_iMaxVolume)), packet")
	    }
	}
    }
}

channel_event[vdvDevice, 0]
{
    on:
    {
	fnControl(channel.channel)
	//cancel_wait 'drill'
	//wait 5 'drill'
	//do_push_timed(vdvDevice, channel.channel, 100)
    }
    off:
    {
	fnGetStatus()
	//cancel_wait 'drill'
	//do_release(vdvDevice, channel.channel)
    }
}

button_event[vdvDevice, 0]
{
    hold[1.5, repeat]:
    {
	stack_var integer btn
	btn = button.input.channel
	if(btn == 97 || btn == 98 || btn == 24 || btn == 25){
	    fnControl(btn)
	    //fnGetStatus()
	}
    }
}


DEFINE_PROGRAM
