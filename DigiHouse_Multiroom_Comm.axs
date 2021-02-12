/**
    ��������������:
	���������� ����� � ����������� DigiHouse (���������� �������� Modbus TCP)

    ������:
	������������ ����� (marat@ixbt.com, at_marat@list.ru)
	������ �������
    
    ������: 1.6
    
    �������:
	28.11.2011 - 1.6 ��������� ������ SET_DIMMER, SET_RELAY, SET_THERMOSTATE
	07.05.2011 - 1.5 ������������ ������ ������/������ ������ SET_CS, GET_CS, GET_IS, SET_HR,
		     GET_HR, GET_IR, START, STOP
	03.06.2008 - 1.4 ����������: ��� ���������� ���������� ������������� ���������� DISCONECT
	22.05.2008 - 1.3 ��������� ������� GET_U16, SET_U16 �������� ����������� ���������
		     ������ ������ ����� ������ ����� ����������� integer
	10.05.2008 - 1.2 ������������� �������� ������ � ����� �������� ����� ��������� ';'
	05.05.2008 - 1.1 ���������� ������ ������ ������, ������� ������ ��������
		    ���������� ������ � �����
	16.04.2008 - ������ printf �������� �� ��������� Debug.axi
	11.04.2008 - ��������� �������� ���������� ������, ������ fnSB_Add,
		     ������������ CREATE_BUFFER.
	09.04.2008 - ���������� ���������� � ������������
	08.04.2008 - ���������� ������ ��� ��������� ���������� ������ ������
	20.03.2008 - ������ ����������

    ����������� � ��������������:
	�������������� �������������� �� ���� ������������ �����, ����� 
	�������� �������� �������������. ����������� ���� � ���� �������
	�������� ����������������� ��� ������������ �����. � ������
	������������ ����� ������ �������� �� �������� ���������� ��������
	� ��� �� ���������� ������. ���������� ���� ���������� ����
	��������� ���������� �������, ������������� �������, ������� �������,
	���������� ������. ��������� �� ������������ ��������.
	������������ ����������.
	
    ������������� � �������:
	1. ������������ ���� DigiHouse_Lighting_Comm.axs � ������.
	2. ���������� ������ ������������ � ����������� �����, � ��� �� ���� � ����
	   Modbus TCP ���������� �������� ���:
	   PHIS_PORT = 0:3:0
	   VIRT_PORT = 33010:1:1
	   
	   char g_caHost[] = "192.168.0.1"
	   integer g_iPort = 502
	    
	3. � ��������, ������� ����� ������� ����������� ������
	   DEFINE_MODULE 'DigiHouse_Lighting_Comm' modName(VIRT_PORT, PHIS_PORT, m_caHost, m_iPort)
	   
	4. ������������ �������� �����
	   DATA_EVENT[VIRT_PORT]
	   {
	        // ��������� ������� � �������
		STRING:
		{
		    // ���������� ����������
		    #IF_DEFINED __DEBUG__
			printf("'virtual device string =', data.text")
		    #END_IF
		}
	   }
	
	5. ��������� ������
	    send_command VIRT_PORT, "'START;'"
	    
	6. ������������ �������� ��������
	    send_command VIRT_PORT, "'GET_HR 1, 0, 10;'"	// ��������� 10 16 ������ ��������� �� ������� 0
	    send_command VIRT_PORT, "'SET_HR 1, 0, 1, 2, 3;'"	// ������ 3 16 ������ ��������  ������� � 0 ������ ���������� 1,2,3

	7. � ������ ������������� ���������� ������ ������
	    send_command VIRT_PORT, "'STOP;'"
    
    �������� ������ ������������ �����:
	GET_CS NN, ADDR, COUNT;	��������� �������� ���������� �������
	�� �����:
	    NN		- ����� ���������� (� ���������� �������) ��� ����������� ���������
			����� ���������� ����� ���� �����, ������� ��� ������������� � Modbus TCP
	    ADDR	- ����� ������ ���� ��������� ������ (� ���������� �������)
	    COUNT	- ���������� �������� ������ (� ���������� �������)
	�� ������:

	GET_IS NN, ADDR, COUNT;	��������� �������� ���������� ������
	�� �����:
	    NN		- ����� ���������� (� ���������� �������) ��� ����������� ���������
			����� ���������� ����� ���� �����, ������� ��� ������������� � Modbus TCP
	    ADDR	- ����� ������ ���� ��������� ������ (� ���������� �������)
	    COUNT	- ���������� �������� ������ (� ���������� �������)
	�� ������:
    
	SET_CS NN, ADDR, V1, ..., Vn;	��������� �������� ���������� �������
	�� �����:
	    NN		- ����� ���������� (� ���������������� �������) �� ���� �����
			����� ���������� ����� ���� �����, ������� ��� ������������� � Modbus TCP
	    ADDR	- ����� ���� ���� �������� ������
	    V1, ..., Vn	- ������ �������� ����� �������
	�� ������:
	
	GET_HR NN, ADDR, COUNT;	��������� �������� �������� ���������
	�� �����:
	    NN		- ����� ���������� (� ���������� �������) ��� ����������� ���������
			����� ���������� ����� ���� �����, ������� ��� ������������� � Modbus TCP
	    ADDR	- ����� ������ ���� ��������� ������ (� ���������� �������)
	    COUNT	- ���������� �������� ������ (� ���������� �������)
	�� ������:
	
	GET_IR NN, ADDR, COUNT;	��������� �������� ������� ���������
	�� �����:
	    NN		- ����� ���������� (� ���������� �������) ��� ����������� ���������
			����� ���������� ����� ���� �����, ������� ��� ������������� � Modbus TCP
	    ADDR	- ����� ������ ���� ��������� ������ (� ���������� �������)
	    COUNT	- ���������� �������� ������ (� ���������� �������)
	�� ������:

	SET_HR NN, ADDR, V1, ..., Vn;	��������� �������� �������� ���������
	�� �����:
	    NN		- ����� ���������� (� ���������������� �������) �� ���� �����
			����� ���������� ����� ���� �����, ������� ��� ������������� � Modbus TCP
	    ADDR	- ����� ���� ���� �������� ������
	    V1, ..., Vn	- ������ �������� ����� �������
	�� ������:
	
	START;	������ ������
	�� �����:
	�� ������:
	
	STOP;	��������� ������
	�� �����:
	�� ������:
*/	

MODULE_NAME='DigiHouse_Multiroom_Comm' (dev vdvDevice,
					dev dvPhysicalDevice,
					char caHost[],
					integer iPort,
					integer iInputCoil,
					integer iOutputCoil)

//#include 'Debug.axi'		// � ������ ���� ������� �� ����� ��������� �������������
#include 'htoi.axi'		// ������ �� ���������
//#include 'Strings.axi'		// ������ �� ���������
#include 'StreamBuffer.axi'	// ��������� �����

//#DEFINE _DEBUG_FLAG
(***********************************************************)
(*          DEVICE NUMBER DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_DEVICE

(***********************************************************)
(*               CONSTANT DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_CONSTANT
/*
#IF_NOT_DEFINED __DEBUG__
__DEBUG__ = 1
#END_IF
*/
_debug = 0
// �������������� �������
TL_PING_ID				= $A0	// ������������� ������ �����
TL_WORK_ID				= $A1

// �������������� ��������
OPERATION_PING				= 0	// ������ �����
OPERATION_READ_COIL_STATUS		= 1	// ������ ��������� ����������� ������
OPERATION_READ_INPUT_STATUS		= 2	// ������ ��������� ����������� �����
OPERATION_READ_HOLDING_REGISTER		= 3	// ������ ��������� ��������� 16 ������� ��������
OPERATION_READ_INPUT_REGISTER		= 4	// ������ ��������� �������� 16 ������� ��������
OPERATION_WRITE_COIL_STATUS		= 5	// ������ ��������� ����������� ������
OPERATION_WRITE_HOLDING_REGISTER	= 6	// ������ ��������� ��������� 16 ������� ��������
OPERATION_WRITE_COIL_STATUS_ARRAY	= 7	// ������ ��������� ����������� ������
OPERATION_WRITE_HOLDING_REGISTER_ARRAY	= 8	// ������ ��������� ��������� 16 ������� ��������
OPERATION_READ_REGISTER_BLOCK_1		= 9	// ������ ��������� �������� 16 ������� ��������
OPERATION_READ_REGISTER_BLOCK_2		= 10	// ������ ��������� �������� 16 ������� ��������
OPERATION_READ_REGISTER_BLOCK_3		= 11	// ������ ��������� �������� 16 ������� ��������
OPERATION_READ_REGISTER_BLOCK_4		= 12	// ������ ��������� �������� 16 ������� ��������
OPERATION_READ_REGISTER_BLOCK_5		= 13	// ������ ��������� �������� 16 ������� ��������
OPERATION_READ_REGISTER_BLOCK_6		= 14	// ������ ��������� �������� 16 ������� ��������
OPERATION_READ_RDS_TUNER_1		= 15	// ������ ��������� �������� 16 ������� ��������
OPERATION_READ_RDS_TUNER_2		= 16	// ������ ��������� �������� 16 ������� ��������
OPERATION_READ_RDS_TUNER_3		= 17	// ������ ��������� �������� 16 ������� ��������
OPERATION_READ_RDS_TUNER_4		= 18	// ������ ��������� �������� 16 ������� ��������
OPERATION_READ_RDS_TUNER_5		= 19	// ������ ��������� �������� 16 ������� ��������
OPERATION_READ_RDS_TUNER_6		= 20	// ������ ��������� �������� 16 ������� ��������
OPERATION_READ_RDS_TUNER_7		= 21	// ������ ��������� �������� 16 ������� ��������
OPERATION_READ_RDS_TUNER_8		= 22	// ������ ��������� �������� 16 ������� ��������

// ���� Modbus ��������
MODBUS_READ_COIL_STATUS			= 1	// ������ ��������� ����������� ������
MODBUS_READ_INPUT_STATUS		= 2	// ������ ��������� ����������� �����
MODBUS_READ_HOLDING_REGISTER		= 3	// ������ ��������� ��������� 16 ������� ��������
MODBUS_READ_INPUT_REGISTER		= 4	// ������ ��������� �������� 16 ������� ��������
MODBUS_WRITE_COIL_STATUS		= 5	// ������ ��������� ����������� ������
MODBUS_WRITE_HOLDING_REGISTER		= 6	// ������ ��������� ��������� 16 ������� ��������
MODBUS_WRITE_COIL_STATUS_ARRAY		= 15	// ������ ��������� ����������� ������
MODBUS_WRITE_HOLDING_REGISTER_ARRAY	= 16	// ������ ��������� ��������� 16 ������� ��������

MULTIROOM_COMUNICATE_INDEX		= 0	// �������� � ����� �� �����������
MULTIROOM_VOLUME_INDEX			= 4	// �������� � ����� �� ���������
MULTIROOM_BASS_INDEX			= 8	// �������� � ����� �� ������ �������
MULTIROOM_TREBLE_INDEX			= 12	// �������� � ����� �� ������� �������
MULTIROOM_BALANCE_INDEX			= 16	// �������� � ����� �� ������
MULTIROOM_TRIM_INDEX			= 26	// �������� � ����� �� TRIM
(***********************************************************)
(*              DATA TYPE DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_TYPE

// ��������� ����������� �����
structure sBlock
{
    integer	m_iaComutation[4];		// ��������� �������
    integer	m_iaPower[4];		// ��������� ������ ������� �� ����������
    integer	m_iaStandby[4];		// ����� Standby ( 0 - STB ON, 1 - STB OFF)
    integer	m_iaVolume[4];			// ��������� ������
    integer	m_iaMute[4];			// ��������� ������
    integer	m_iaLF[4];			// ������ ������ �������
    integer	m_iaHF[4];			// ������ ������� �������
    integer	m_iaBalance[4];			// ������ ������ ������
    integer	m_iaTrim[4];			// �������� ����
}

(***********************************************************)
(*               VARIABLE DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_VARIABLE

volatile integer 	m_iCurTID	= 0	// ������� ������������ ����������
volatile long 		m_laPing[1]	= 250 	// ���������� ������� ����� ������� ������������ ����
volatile long 		m_laWork[1]	= 5000	// ���������� ������� ����� ������� ������������ ��������� ��������� ����������

volatile StreamBuffer 	m_sbInputBuffer		// ������������� �������� �����

volatile char		m_cIsConnect	= 0	// ���� ����������

// ������� ��� �������� �������� ��������� ����������
volatile integer	m_iaStatuses[10]
volatile integer	m_iaOldStatuses[10]
volatile char		m_caInputCoil[256]
volatile char		m_caCoilStatus[256]
volatile integer	m_iaHoldingRegisters[512]
volatile integer	m_iaOldHoldingRegisters[512]
volatile integer	m_iaInputRegisters[512]
volatile integer	m_iaOldInputRegisters[512]
volatile sBlock		m_sBlocks[8];
volatile char		m_caRDS[8];

volatile long		m_lCurTime	= 0
volatile long		m_lLastPingTime	= 0
volatile long		m_lStartWaitTime= 0
volatile long		m_lRDS		= 0

(***********************************************************)
(*               LATCHING DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_LATCHING

(***********************************************************)
(*       MUTUALLY EXCLUSIVE DEFINITIONS GO BELOW           *)
(***********************************************************)
DEFINE_MUTUALLY_EXCLUSIVE

/**
    ��������� �������������� ����������
    �� �����	:	in_cOperation	- ��� ����������� ��������
    �� ������	:	�������������
    ����������	: 	������� ����������� ��� ���� ����� ��������� ���������
			0 ��������
*/
define_function integer fnGetTID(char in_cOperation)
{
    m_iCurTID++
    m_iCurTID = m_iCurTID & $3FF
    if(m_iCurTID == 0)
	m_iCurTID++

    // ��������� ��� ��������
    return m_iCurTID | TYPE_CAST(in_cOperation << 10)
}

/**
    ��������� ���� �������� �� �������������� ����������
    �� �����	:	in_iTID	- ������������� ����������
    �� ������	:	��� ��������
*/
define_function char fnGetOperation(integer in_iTID)
{
    return TYPE_CAST(in_iTID >> 10)
}

/**
    �������� ������ ���������� � ������
    �� �����	:	in_iDevice	- ����� ����������
			in_iAddress	- �����
    �� ������	:	0 - ������������ ������
			1 - ������ ���������
*/
define_function char fnTestParameters(integer in_iDevice, integer in_iAddress)
{
    local_var char l_cResult
    
    l_cResult = 0
    
    if(in_iDevice < 255 && in_iAddress < 65535)
	l_cResult = 1
	
    return l_cResult
}

/**
    ��������� ������ ���������� �� ������
    �� �����	:	in_caString	- ��������� �� ������ ������ ������ ��������
			in_iaBuffer	- ��������� �� ����� ���� ����� ������� ��������
    �� ������	:	���������� ����������
*/

define_function integer fnGetArray(char in_caString[], integer in_iaBuffer[])
{
    local_var integer l_iCount, i
    local_var char l_bRun
    
    l_iCount = 0
    l_bRun = 1
    
    while(l_bRun)
    {
	// ���������� ����������
	#IF_DEFINED _DEBUG_FLAG
	    send_string 0, in_caString
	#END_IF
	
	l_iCount++
	
	in_iaBuffer[l_iCount] = TYPE_CAST(atoi(in_caString))
	
	if(find_string(in_caString, ',', 1) != 0)
	    remove_string(in_caString, ',', 1)
	else
	    l_bRun = 0
    }
	
    return l_iCount
}
/**
    ������� ������ �� ��� ��� ���� �� ���������� ������� ������
    �� �����	:	in_caIn		- �������� �����
			in_caOut	- ���� ����� ��������� ������
			in_cEnd		- ������ �� ����������� �������� ����� ���������� �������
    �� ������	:	true 	- ������ �������
			false	- ������ �� �������
*/

define_function char fnStr_GetStringWhile(char in_caIn[], char in_caOut[], char in_cEnd)
{
    local_var integer i
    
    // ����������� ������
    for(i = 0; i < length_string(in_caIn); i++)
    {
	if(in_caIn[i + 1] != in_cEnd)
	{
	    in_caOut[i + 1] = in_caIn[i + 1]
	} else
	{
	    // �������� ������ ������
	    set_length_array(in_caOut, i)
	    return true
	}
    }
    // ������ �� �������
    set_length_array(in_caOut, 0)
    return false
}

/**
    ������� ������ � ������ �������
    �� �����	:	in_caBuffer	- �������� �����
    �� ������	:	*
    ���������� 	: �������� ������ � ����������� ���������
*/
define_function fnStr_ToUpper(char in_caBuffer[])
{
    local_var integer i
    local_var char v
    //
    for(i = 1; i <= length_string(in_caBuffer); i++)
    {
	v = in_caBuffer[i]
	if(v >= $61 and v <= $7A)
	{
	    v = v - $20
	    in_caBuffer[i] = v
	}
    }
}


/**
    �������������
    �� �����	:	in_dvDevice - ����������
			in_cIPAddr  - IP ����� ���������� � �������� ����� �������������
			in_iPort    - ���� � �������� ����� �������������
    �� ������	:	*
*/
define_function fnOnConnect(dev in_dvDevice, char in_cIPAddr[], integer in_iPort)
{
    ip_client_open(in_dvDevice.port, in_cIPAddr, in_iPort, 1);
}

/**
    ������������
    �� �����	:	in_dvDevice - ����������
    �� ������	:	*
*/
define_function fnOnDisconnect(dev in_dvDevice)
{
    if(m_cIsConnect == 1)
    {
	ip_client_close(in_dvDevice.port)
	m_cIsConnect = 0;
    }
}

/**
    ������������� ����������
    �� �����	:	*
    �� ������	:	*
*/
define_function fnOnInit()
{
    local_var integer i
    
    // ������������� ������� ���������
    for(i = 1; i <= 10; i++)
    {
	m_iaStatuses[i]    = 0
	m_iaOldStatuses[i] = $FFFF
    }
	
    // ������������� ������� � ����������� �������
    for(i = 1; i < 256; i++)
	m_caInputCoil[i] = 0

    // ������������� ������� � ����������� �������
    for(i = 1; i < 256; i++)
	m_caCoilStatus[i] = 0

    for(i = 1; i <= 8; i++)
	m_caRDS[i] = 0
	
    // ������������� ������� � ����������
    for(i = 1; i < 512; i++)
    {
	m_iaHoldingRegisters[i] = 0
	m_iaOldHoldingRegisters[i] = $FFFF
	m_iaInputRegisters[i] = 0
	m_iaOldInputRegisters[i] = $FFFF
    }
    
    for(i = 0; i <= 5; i++)
	fnOnSendReadHoldingRegisterBlock(0, i);
    
    //����������� �������� ������������ ���������� (���������) � �������� ���������� ����������
    for(i = 0; i <= 5; i++)
	fnOnSendWriteHoldingRegister(0, 57 + 32*i, 131)
    
    wait 15 'tl_1' {
	// 
	m_lLastPingTime 	= m_lCurTime;
	m_lStartWaitTime	= m_lCurTime;
	
	// �������� ������� ��� ����������� ����������
	timeline_create(TL_PING_ID, m_laPing, 1, TIMELINE_ABSOLUTE, TIMELINE_REPEAT)	
    }
}

/**
    ����� ����������
    �� �����	:	*
    �� ������	:	*
*/
define_function fnOnReset()
{
    local_var integer i
    
    // ������������� ������� ���������
    for(i = 1; i <= 10; i++)
    {
	m_iaStatuses[i]    = 0
	m_iaOldStatuses[i] = $FFFF
    }
	
    // ������������� ������� � ����������� �������
    for(i = 1; i < 256; i++)
	m_caInputCoil[i] = 0

    // ������������� ������� � ����������� �������
    for(i = 1; i < 256; i++)
	m_caCoilStatus[i] = 0
	
    // ������������� ������� � ����������
    for(i = 1; i < 512; i++)
    {
	m_iaHoldingRegisters[i] = 0
	m_iaOldHoldingRegisters[i] = $FFFF
	m_iaInputRegisters[i] = 0
	m_iaOldInputRegisters[i] = $FFFF
    }
    
}

define_function printf(char data[]){
    if(_debug)
	send_string 0, data
}
/**
    ��������������� ����������
    �� �����	:	*
    �� ������	:	*
*/
define_function fnOnDeInit()
{
    // ��������� ��������
    if(timeline_active(TL_PING_ID))
	timeline_kill(TL_PING_ID);
    
    m_lLastPingTime 	= m_lCurTime;
    m_lStartWaitTime	= m_lCurTime;
}

/**
    ����
    �� �����	:	*
    �� ������	:	*
    ����������	: 	������ ������� ������������� ��� ����������� ����������
*/
define_function fnOnPing()
{
    local_var char packet[32]
    local_var integer ID
    if(m_cIsConnect == 1)
    {
	// ��������� ��������������
	ID = fnGetTID(OPERATION_PING)
	
	packet[01] = TYPE_CAST(ID >> 8)				// TID
	packet[02] = TYPE_CAST(ID & $FF)
	packet[03] = 0						// PID ������ ����
	packet[04] = 0
	packet[05] = 0						// ������ ������
	packet[06] = 6
	packet[07] = 0						// ������������� ��������� (���������������� �������������)
	packet[08] = MODBUS_READ_HOLDING_REGISTER		// ��� ��������
	packet[09] = 8						// ����� 0x800 (2048) // 0x881 2177
	packet[10] = $80
	packet[11] = 0						// ���������� 4 16-� ������ ��������
	packet[12] = 10
	
	// ��������� ������ ������
	set_length_string(packet, 12)

	// �������� �� ����������
	send_string dvPhysicalDevice, packet
    }
}

/**
    ����� ��������� � ��������� � ������ ������������ ������
    �� �����	:	*
    �� ������	:	*
*/
define_function fnOnFindingChanges()
{
    // �������� ���������
    if(m_iaStatuses[4] != m_iaOldStatuses[4])
    {
	m_iaOldStatuses[4] = m_iaStatuses[4];
	
	// ������ ���� ������� ������
	fnOnSendReadInputRegisterBlock(0, 0);
	fnOnSendReadInputRegisterBlock(0, 1);
	fnOnSendReadInputRegisterBlock(0, 2);
	fnOnSendReadInputRegisterBlock(0, 3);
	fnOnSendReadInputRegisterBlock(0, 4);
	fnOnSendReadInputRegisterBlock(0, 5);
    }
    if(m_iaStatuses[5] != m_iaOldStatuses[5]) {
	m_iaOldStatuses[5] = m_iaStatuses[5];
	fnOnSendReadInputRegisterBlock(0, 0);
    }
    if(m_iaStatuses[6] != m_iaOldStatuses[6]) {
	m_iaOldStatuses[6] = m_iaStatuses[6];
	fnOnSendReadInputRegisterBlock(0, 1);
    }
    if(m_iaStatuses[7] != m_iaOldStatuses[7]) {
	m_iaOldStatuses[7] = m_iaStatuses[7];
	fnOnSendReadInputRegisterBlock(0, 2);
    }
    if(m_iaStatuses[8] != m_iaOldStatuses[8]) {
	m_iaOldStatuses[8] = m_iaStatuses[8];
	fnOnSendReadInputRegisterBlock(0, 3);
    }
    if(m_iaStatuses[9] != m_iaOldStatuses[9]) {
	m_iaOldStatuses[9] = m_iaStatuses[9];
	fnOnSendReadInputRegisterBlock(0, 4);
    }
    if(m_iaStatuses[10] != m_iaOldStatuses[10]) {
	m_iaOldStatuses[10] = m_iaStatuses[10];
	fnOnSendReadInputRegisterBlock(0, 5);
    }
}

/**
    �������� ������� �� ��������� �������� ���������� �������
    �� �����	:	in_cDevice	- ������������� ���������� ��� ��������
					����� ���������� ������
			in_iAddr	- �����
			in_iCount	- ����������
    �� ������	:	*
*/
define_function fnOnSendReadCoilStatus(char in_cDevice, integer in_iAddr, integer in_iCount)
{
    local_var char packet[512]
    local_var integer ID
    
    if(m_cIsConnect == 1)
    {
	// ��������� ��������������
	ID = fnGetTID(OPERATION_READ_COIL_STATUS)
	
	// ����� ���������
	packet[01] = TYPE_CAST(ID >> 8)				// TID
	packet[02] = TYPE_CAST(ID & $FF)
	packet[03] = 0						// PID ������ ����
	packet[04] = 0
	
	packet[05] = 0						// ������ ������
	packet[06] = 6
	packet[07] = in_cDevice					// ������������� ���������
	packet[08] = MODBUS_READ_COIL_STATUS			// ��� ��������
	packet[09] = TYPE_CAST(in_iAddr >> 8)			// �����
	packet[10] = TYPE_CAST(in_iAddr & $FF)
	packet[11] = TYPE_CAST(in_iCount >> 8)			// ���������� ���
	packet[12] = TYPE_CAST(in_iCount & $FF)
	
	// ��������� ������ ������
	set_length_string(packet, 12)

	// �������� �� ����������
	send_string dvPhysicalDevice, packet
    }
}

/**
    �������� ������� �� ��������� �������� ���������� ������
    �� �����	:	in_cDevice	- ������������� ���������� ��� ��������
					����� ���������� ������
			in_iAddr	- �����
			in_iCount	- ����������
    �� ������	:	*
*/
define_function fnOnSendReadInputStatus(char in_cDevice, integer in_iAddr, integer in_iCount)
{
    local_var char packet[512]
    local_var integer ID
    
    if(m_cIsConnect == 1)
    {
	// ��������� ��������������
	ID = fnGetTID(OPERATION_READ_INPUT_STATUS)
	
	// ����� ���������
	packet[01] = TYPE_CAST(ID >> 8)				// TID
	packet[02] = TYPE_CAST(ID & $FF)
	packet[03] = 0						// PID ������ ����
	packet[04] = 0
	
	packet[05] = 0						// ������ ������
	packet[06] = 6
	packet[07] = in_cDevice					// ������������� ���������
	packet[08] = MODBUS_READ_INPUT_STATUS			// ��� ��������
	packet[09] = TYPE_CAST(in_iAddr >> 8)			// �����
	packet[10] = TYPE_CAST(in_iAddr & $FF)
	packet[11] = TYPE_CAST(in_iCount >> 8)			// ����������
	packet[12] = TYPE_CAST(in_iCount & $FF)
	
	// ��������� ������ ������
	set_length_string(packet, 12)

	// �������� �� ����������
	send_string dvPhysicalDevice, packet
    }
}

/**
    �������� ������� �� ��������� �������� �������� ���������
    �� �����	:	in_cDevice	- ������������� ���������� ��� ��������
					����� ���������� ������
			in_iAddr	- �����
			in_iCount	- ����������
    �� ������	:	*
*/
define_function fnOnSendReadHoldingRegister(char in_cDevice, integer in_iAddr, integer in_iCount)
{
    local_var char packet[512]
    local_var integer ID
    
    if(m_cIsConnect == 1)
    {
	// ��������� ��������������
	ID = fnGetTID(OPERATION_READ_HOLDING_REGISTER)
	
	// ����� ���������
	packet[01] = TYPE_CAST(ID >> 8)				// TID
	packet[02] = TYPE_CAST(ID & $FF)
	packet[03] = 0						// PID ������ ����
	packet[04] = 0
	
	packet[05] = 0						// ������ ������
	packet[06] = 6
	packet[07] = in_cDevice					// ������������� ���������
	packet[08] = MODBUS_READ_HOLDING_REGISTER		// ��� ��������
	packet[09] = TYPE_CAST(in_iAddr >> 8)			// �����
	packet[10] = TYPE_CAST(in_iAddr & $FF)
	packet[11] = TYPE_CAST(in_iCount >> 8)			// ����������
	packet[12] = TYPE_CAST(in_iCount & $FF)
	
	// ��������� ������ ������
	set_length_string(packet, 12)

	// �������� �� ����������
	send_string dvPhysicalDevice, packet
    }
}

/**
    �������� ������� �� ��������� �������� ������� ���������
    �� �����	:	in_cDevice	- ������������� ���������� ��� ��������
					����� ���������� ������
			in_iAddr	- �����
			in_iCount	- ����������
    �� ������	:	*
*/
define_function fnOnSendReadInputRegister(char in_cDevice, integer in_iAddr, integer in_iCount)
{
    local_var char packet[512]
    local_var integer ID
    
    if(m_cIsConnect == 1)
    {
	// ��������� ��������������
	ID = fnGetTID(OPERATION_READ_INPUT_REGISTER)
	
	// ����� ���������
	packet[01] = TYPE_CAST(ID >> 8)				// TID
	packet[02] = TYPE_CAST(ID & $FF)
	packet[03] = 0						// PID ������ ����
	packet[04] = 0
	
	packet[05] = 0						// ������ ������
	packet[06] = 6
	packet[07] = in_cDevice					// ������������� ���������
	packet[08] = MODBUS_READ_INPUT_REGISTER			// ��� ��������
	packet[09] = TYPE_CAST(in_iAddr >> 8)			// �����
	packet[10] = TYPE_CAST(in_iAddr & $FF)
	packet[11] = TYPE_CAST(in_iCount >> 8)			// ����������
	packet[12] = TYPE_CAST(in_iCount & $FF)
	
	// ��������� ������ ������
	set_length_string(packet, 12)

	// �������� �� ����������
	send_string dvPhysicalDevice, packet
    }
}

/**
    �������� ������� �� ��������� �������� ������� ��������� �����
    �� �����	:	in_cDevice	- ������������� ���������� ��� ��������
					����� ���������� ������
			in_iBlock	- ����� ����� � ����� 128 ���������
    �� ������	:	*
*/

define_function fnOnSendReadInputRegisterBlock(char in_cDevice, integer in_iBlock)
{
    local_var char packet[512]
    local_var integer ID, l_iAddr
    
    l_iAddr = in_iBlock * 32 + 32
    
    if(m_cIsConnect == 1)
    {
	// ��������� ��������������
	ID = fnGetTID(OPERATION_READ_REGISTER_BLOCK_1 + in_iBlock)
	
	// ����� ���������
	packet[01] = TYPE_CAST(ID >> 8)				// TID
	packet[02] = TYPE_CAST(ID & $FF)
	packet[03] = 0						// PID ������ ����
	packet[04] = 0
	
	packet[05] = 0						// ������ ������
	packet[06] = 6
	packet[07] = in_cDevice					// ������������� ���������
	packet[08] = MODBUS_READ_INPUT_REGISTER			// ��� ��������
	packet[09] = TYPE_CAST(l_iAddr >> 8)			// �����
	packet[10] = TYPE_CAST(l_iAddr & $FF)
	packet[11] = 0						// ����������
	packet[12] = 32
	
	// ��������� ������ ������
	set_length_string(packet, 12)

	// �������� �� ����������
	send_string dvPhysicalDevice, packet
    }
}


/**
    �������� ������� �� ��������� �������� ������� ��������� �����
    �� �����	:	in_cDevice	- ������������� ���������� ��� ��������
					����� ���������� ������
			in_iBlock	- ����� ����� � ����� 128 ���������
    �� ������	:	*
*/
define_function fnOnSendReadHoldingRegisterBlock(char in_cDevice, integer in_iBlock)
{
    local_var char packet[512]
    local_var integer ID, l_iAddr
    
    l_iAddr = in_iBlock * 32 + 32
    if(m_cIsConnect == 1)
    {
	// ��������� ��������������
	ID = fnGetTID(OPERATION_READ_REGISTER_BLOCK_1 + in_iBlock)
	
	// ����� ���������
	packet[01] = TYPE_CAST(ID >> 8)				// TID
	packet[02] = TYPE_CAST(ID & $FF)
	packet[03] = 0						// PID ������ ����
	packet[04] = 0
	
	packet[05] = 0						// ������ ������
	packet[06] = 6
	packet[07] = in_cDevice					// ������������� ���������
	packet[08] = MODBUS_READ_HOLDING_REGISTER		// ��� ��������
	packet[09] = TYPE_CAST(l_iAddr >> 8)			// �����
	packet[10] = TYPE_CAST(l_iAddr & $FF)
	packet[11] = 0						// ����������
	packet[12] = 32
	
	// ��������� ������ ������
	set_length_string(packet, 12)

	// �������� �� ����������
	send_string dvPhysicalDevice, packet
    }
}

/**
    �������� ������� �� ��������� �������� ������� ��������� �����
    �� �����	:	in_cDevice	- ������������� ���������� ��� ��������
					����� ���������� ������
			in_iBlock	- ����� ����� � ����� 128 ���������
    �� ������	:	*
*/
define_function fnOnSendReadRDS(char in_cDevice, integer in_iTuner)
{
    local_var char packet[512]
    local_var integer ID, addr
    
    if(m_cIsConnect == 1)
    {
	// ��������� ��������������
	ID = fnGetTID(OPERATION_READ_RDS_TUNER_1 + in_iTuner - 1)
	addr = (in_iTuner - 1) * 32 + 256
	
	// ����� ���������
	packet[01] = TYPE_CAST(ID >> 8)				// TID
	packet[02] = TYPE_CAST(ID & $FF)
	packet[03] = 0						// PID ������ ����
	packet[04] = 0
	
	packet[05] = 0						// ������ ������
	packet[06] = 6
	packet[07] = in_cDevice					// ������������� ���������
	packet[08] = MODBUS_READ_INPUT_REGISTER			// ��� ��������
	packet[09] = TYPE_CAST(addr >> 8)			// �����
	packet[10] = TYPE_CAST(addr & $FF)
	packet[11] = 0						// ����������
	packet[12] = 9
	
	// ��������� ������ ������
	set_length_string(packet, 12)

	// �������� �� ����������
	send_string dvPhysicalDevice, packet
    }
}

/**
    �������� ������� �� ��������� ����������� ������
    �� �����	:	in_cDevice	- ������������� ���������� ��� ��������
					����� ���������� ������
			in_iAddr	- �����
			in_cValue	- �������� ��� ���������
    �� ������	:	*
*/
define_function fnOnSendWriteCoilStatus(char in_cDevice, integer in_iAddr, char in_cValue)
{
    local_var char packet[512]
    local_var integer ID
    local_var integer val

    val = 0
    if(in_cValue != 0)
	val = $FF00
    
    if(m_cIsConnect == 1)
    {
	// ��������� ��������������
	ID = fnGetTID(OPERATION_WRITE_COIL_STATUS)
	
	// ����� ���������
	packet[01] = TYPE_CAST(ID >> 8)				// TID
	packet[02] = TYPE_CAST(ID & $FF)
	packet[03] = 0						// PID ������ ����
	packet[04] = 0
	
	packet[05] = 0						// ������ ������
	packet[06] = 6
	packet[07] = in_cDevice					// ������������� ���������
	packet[08] = MODBUS_WRITE_COIL_STATUS			// ��� ��������
	packet[09] = TYPE_CAST(in_iAddr >> 8)			// �����
	packet[10] = TYPE_CAST(in_iAddr & $FF)
	packet[11] = TYPE_CAST(val >> 8)			// ��������
	packet[12] = TYPE_CAST(val & $FF)
	
	// ��������� ������ ������
	set_length_string(packet, 12)

	// �������� �� ����������
	send_string dvPhysicalDevice, packet
    }
}

/**
    �������� ������� �� ��������� ������������ ������
    �� �����	:	in_cDevice	- ������������� ���������� ��� ��������
					����� ���������� ������
			in_iAddr	- �����
			in_iValue	- �������� ��� ���������
    �� ������	:	*
*/
define_function fnOnSendWriteHoldingRegister(char in_cDevice, integer in_iAddr, integer in_iValue)
{
    local_var char packet[512]
    local_var integer ID
    local_var integer val
    
    if(m_cIsConnect == 1)
    {
	// ��������� ��������������
	ID = fnGetTID(OPERATION_WRITE_HOLDING_REGISTER)
	
	// ����� ���������
	packet[01] = TYPE_CAST(ID >> 8)				// TID
	packet[02] = TYPE_CAST(ID & $FF)
	packet[03] = 0						// PID ������ ����
	packet[04] = 0
	
	packet[05] = 0						// ������ ������
	packet[06] = 6
	packet[07] = in_cDevice					// ������������� ���������
	packet[08] = MODBUS_WRITE_HOLDING_REGISTER		// ��� ��������
	packet[09] = TYPE_CAST(in_iAddr >> 8)			// �����
	packet[10] = TYPE_CAST(in_iAddr & $FF)
	packet[11] = TYPE_CAST(in_iValue >> 8)			// ��������
	packet[12] = TYPE_CAST(in_iValue & $FF)
	
	// ��������� ������ ������
	set_length_string(packet, 12)

	// �������� �� ����������
	send_string dvPhysicalDevice, packet
    }
}

/**
    �������� ������� �� ��������� ���������� ���������� �������
    �� �����	:	in_cDevice	- ������������� ���������� ��� ��������
					����� ���������� ������
			in_iAddr	- �����
			in_iCount	- ���������� �������� ��� ���������
			in_iaArray	- ������ �������� ��� ���������
    �� ������	:	*
*/
define_function fnOnSendWriteCoilStatusArray(char in_cDevice, integer in_iAddr, integer in_iCount, integer in_iaArray[])
{
    local_var char packet[512]
    local_var integer ID, len, i
    local_var char idx, bit, byte
    
    if(m_cIsConnect == 1)
    {
	// ��������� ��������������
	ID = fnGetTID(OPERATION_WRITE_COIL_STATUS_ARRAY)
	
	// ����� ���������
	packet[01] = TYPE_CAST(ID >> 8)				// TID
	packet[02] = TYPE_CAST(ID & $FF)
	packet[03] = 0						// PID ������ ����
	packet[04] = 0
	
	// ���������� ������� ������
	len = (in_iCount + 7) / 8

	// ������������ ������
	packet[05] = TYPE_CAST(len >> 8)			// ������ ������
	packet[06] = TYPE_CAST(len & $FF)
	packet[07] = in_cDevice					// ������������� ���������
	packet[08] = MODBUS_WRITE_COIL_STATUS_ARRAY		// ��� ��������
	packet[09] = TYPE_CAST(in_iAddr >> 8)			// ������
	packet[10] = TYPE_CAST(in_iAddr & $FF)
	packet[11] = TYPE_CAST(in_iCount >> 8)			// ���������� ���
	packet[12] = TYPE_CAST(in_iCount & $FF)
	packet[13] = TYPE_CAST(len)				// ���������� ����
	
	// ������� ������
	for(i = 0; i < len; i++)
	    packet[14 + i] = 0

	// ������������ ������ ��� ������
	for(i = 0; i < in_iCount; i++)
	{
	    idx = i / 8
	    bit = i % 8
	    
	    byte = packet[14 + idx]
	    
	    if(in_iaArray[i + 1] != 0)
		byte = byte | (1 << bit)
		
	    packet[14 + idx] = byte
	}
	    
	// ��������� ������ ������
	set_length_string(packet, 13 + len)
	
	// �������� �� ����������
	send_string dvPhysicalDevice, packet
    }
}

/**
    �������� ������� �� ��������� ���������� �������� ���������
    �� �����	:	in_cDevice	- ������������� ���������� ��� ��������
					����� ���������� ������
			in_iAddr	- �����
			in_iCount	- ���������� �������� ��� ���������
			in_iaArray	- ������ �������� ��� ���������
    �� ������	:	*
*/
define_function fnOnSendWriteHoldingRegisterArray(char in_cDevice, integer in_iAddr, integer in_iCount, integer in_iaArray[])
{
    local_var char packet[512]
    local_var integer ID, len, i
    
    if(m_cIsConnect == 1)
    {
	// ��������� ��������������
	ID = fnGetTID(OPERATION_WRITE_HOLDING_REGISTER_ARRAY)
	
	// ����� ���������
	packet[01] = TYPE_CAST(ID >> 8)				// TID
	packet[02] = TYPE_CAST(ID & $FF)
	packet[03] = 0						// PID ������ ����
	packet[04] = 0
	
	// ���������� ������� ������
	len = 7 + in_iCount * 2

	// ������������ ������
	packet[05] = TYPE_CAST(len >> 8)			// ������ ������
	packet[06] = TYPE_CAST(len & $FF)
	packet[07] = in_cDevice					// ������������� ���������
	packet[08] = MODBUS_WRITE_HOLDING_REGISTER_ARRAY	// ��� ��������
	packet[09] = TYPE_CAST(in_iAddr >> 8)			// �����
	packet[10] = TYPE_CAST(in_iAddr & $FF)
	packet[11] = TYPE_CAST(in_iCount >> 8)			// ����������
	packet[12] = TYPE_CAST(in_iCount & $FF)
	packet[13] = TYPE_CAST(in_iCount * 2)

	// ������������ ������ ��� ������
	for(i = 0; i < in_iCount; i++)
	{
	    packet[14 + i*2    ] = TYPE_CAST(in_iaArray[i + 1] >> 8)
	    packet[14 + i*2 + 1] = TYPE_CAST(in_iaArray[i + 1] & $FF)
	}
	
	// ��������� ������ ������
	set_length_array(packet, 6 + len)
	
	// �������� �� ����������
	send_string dvPhysicalDevice, packet
    }
}

/**
    ��������� ������
    �� �����	:	in_sbBuffer - ��������� �����
    �� ������	:	true - ������� ����������
			false - ������������ ������
*/
define_function char fnOnReceive(StreamBuffer in_sbBuffer)
{
    local_var integer i, j, len, ptr, packet_len, a, s, tid, pid, op, fc
    local_var integer value, l_iVal, idx1, idx2
    local_var char d, c, o, b, byte
    local_var char str[16]
   
    // �������� ������� ������
    if(fnSB_GetSize(in_sbBuffer) < 8)
	return false
    
    // ��������� TID � PID
    tid = fnSB_GetIntBE(in_sbBuffer)
    pid = fnSB_GetIntBE(in_sbBuffer)
    op  = fnGetOperation(tid);

    // ��������� ������ ������
    packet_len	= fnSB_GetIntBE(in_sbBuffer)
    
    // ������������� ����������
    d	= fnSB_GetChar(in_sbBuffer)
    fc	= fnSB_GetChar(in_sbBuffer)

    if(	fc == MODBUS_READ_COIL_STATUS ||
	fc == MODBUS_READ_INPUT_STATUS ||
	fc == MODBUS_READ_HOLDING_REGISTER ||
	fc == MODBUS_READ_INPUT_REGISTER)
    {
	if(fnSB_GetSize(in_sbBuffer) < 3)
	    return false

	// ���������� ��������� ����
	c = fnSB_GetChar(in_sbBuffer)
	if(fnSB_GetSize(in_sbBuffer) < c)
	    return false
    }

    // ��������� �������
    switch(fc)
    {
	case MODBUS_READ_COIL_STATUS:
	{
	    for(i = 0; i < c; i++)
	    {
		b = fnSB_GetChar(in_sbBuffer)
		for(j = 0; j < 8; j++)
		{
		    byte = (b >> j) & 1
		    
		    if(m_caCoilStatus[i * 8 + j + 1] != byte)
		    {
			if(byte == 0)
			    do_release(vdvDevice, iOutputCoil + i * 8 + j)
			else
			    do_push_timed(vdvDevice, iOutputCoil + i * 8 + j, do_push_timed_infinite)
		    }
		    m_caCoilStatus[i * 8 + j + 1] = byte
		}
	    }

	    // ����� ������
	    fnSB_Shift(in_sbBuffer)
	    
	    // ���������� ����������
	    #IF_DEFINED _DEBUG_FLAG
		send_string 0, "'Receive: Read coil status'"
	    #END_IF
	    return true
	}
	case MODBUS_READ_INPUT_STATUS:
	{
	    for(i = 0; i < c; i++)
	    {
		b = fnSB_GetChar(in_sbBuffer)
		for(j = 0; j < 8; j++)
		{
		    byte = (b >> j) & 1
		    
		    if(m_caInputCoil[i * 8 + j + 1] != byte)
		    {
			if(byte == 0)
			    do_release(vdvDevice, iInputCoil + i * 8 + j)
			else
			    do_push_timed(vdvDevice, iInputCoil + i * 8 + j, do_push_timed_infinite)
		    }
		    m_caInputCoil[i * 8 + j + 1] = byte
		}
	    }

	    // ����� ������
	    fnSB_Shift(in_sbBuffer)
	    
	    // ���������� ����������
	    #IF_DEFINED _DEBUG_FLAG
		send_string 0, "'Receive: Read input status'"
	    #END_IF
	    return true
	}
	// ����� �� ������
	case MODBUS_READ_HOLDING_REGISTER:
	{
	    // ���� ����
	    if(op == OPERATION_PING)
	    {
		// �������� ����� ���������� �����
		m_lLastPingTime = m_lCurTime
		
		for(i = 0; i < (c/2); i++)
		    m_iaStatuses[i+1] = fnSB_GetIntBE(in_sbBuffer)
		    
		// ����� ������
		fnSB_Shift(in_sbBuffer)
		
		// ����� ���������
		fnOnFindingChanges()
		
		// ���������� ����������
		#IF_DEFINED _DEBUG_FLAG
		    send_string 0, "'Receive: Ping'"
		#END_IF
	    
	    } else 	    
	    // �������� ������� ����������
	    if(op >= OPERATION_READ_REGISTER_BLOCK_1 && op <= OPERATION_READ_REGISTER_BLOCK_6)
	    {
		idx1 = op - OPERATION_READ_REGISTER_BLOCK_1;
		idx2 = idx1 * 4
		
		// ������ ������
		for(i = 1; i <= (c/2); i++)
		{
		    m_iaHoldingRegisters[i] = fnSB_GetIntBE(in_sbBuffer)
		    
		    #IF_DEFINED _DEBUG_FLAG
			send_string 0, "'hr ', itoa(m_iaHoldingRegisters[i])"
		    #END_IF
		}
		
		// ���������� ������ �� �������
		for(i = 0; i < 4; i++)
		{
		    //����������� ��������� ����
		    m_sBlocks[idx1 + 1].m_iaMute[i + 1]		= (m_iaHoldingRegisters[01 + i] >> 5) & 1
		    m_sBlocks[idx1 + 1].m_iaStandby[i + 1]	= (m_iaHoldingRegisters[01 + i] >> 6) & 1
		    m_sBlocks[idx1 + 1].m_iaPower[i + 1]	= (m_iaHoldingRegisters[01 + i] >> 7) & 1
		    
		    if(m_sBlocks[idx1 + 1].m_iaStandby[i + 1])
			m_sBlocks[idx1 + 1].m_iaComutation[i + 1]	= (m_iaHoldingRegisters[01 + i] & $1F) + 1
		    else
			m_sBlocks[idx1 + 1].m_iaComutation[i + 1]	= 0
		    
		    //������� �������� ����
		    m_sBlocks[idx1 + 1].m_iaTrim[i + 1]		= m_iaHoldingRegisters[27 + i]
		}
		
		//�������� ��������� ��������
		fnOnSendReadInputRegisterBlock(0, idx1)
	    }

	    // ����� ������
	    fnSB_Shift(in_sbBuffer)
	    
	    // ���������� ����������
	    #IF_DEFINED _DEBUG_FLAG
		send_string 0, "'Receive: Read holding register'"
	    #END_IF
	    return true
	}

	// ����� �� ������
	case MODBUS_READ_INPUT_REGISTER:
	{
	    if(op == OPERATION_READ_INPUT_REGISTER)
	    {
		// ��������� ��������
		for(i = 0; i < (c/2); i++)
		{
		    m_iaInputRegisters[i + 1] = fnSB_GetIntBE(in_sbBuffer)
		    #IF_DEFINED _DEBUG_FLAG
			send_string 0, "'ir ', itoa(m_iaInputRegisters[i + 1])"
		    #END_IF
		}
		
	    } else 
	    // �������� ������� ����������
	    if(op >= OPERATION_READ_REGISTER_BLOCK_1 && op <= OPERATION_READ_REGISTER_BLOCK_6)
	    {
		idx1 = op - OPERATION_READ_REGISTER_BLOCK_1;
		idx2 = idx1 * 4
		
		// ������ ������
		for(i = 1; i <= (c/2); i++)
		{
		    m_iaInputRegisters[i] = fnSB_GetIntBE(in_sbBuffer)
		    
		    #IF_DEFINED _DEBUG_FLAG
			send_string 0, "'ir ', itoa(m_iaInputRegisters[i])"
		    #END_IF
		}
		    
		// ���������� ������ �� �������
		for(i = 0; i < 4; i++)
		{
		    //
		    m_sBlocks[idx1 + 1].m_iaVolume[i + 1]	= m_iaInputRegisters[05 + i]
		    m_sBlocks[idx1 + 1].m_iaLF[i + 1]		= m_iaInputRegisters[09 + i]
		    m_sBlocks[idx1 + 1].m_iaHF[i + 1]		= m_iaInputRegisters[13 + i]
		    m_sBlocks[idx1 + 1].m_iaBalance[i + 1]	= m_iaInputRegisters[17 + i]
		    
		    //���������� �������� �����
		    send_string vdvDevice, "'CHANNEL ', itoa(idx2 + i + 1), ',',
					    itoa(m_sBlocks[idx1 + 1].m_iaComutation[i + 1]), ',',
					    itoa(m_sBlocks[idx1 + 1].m_iaPower[i + 1]), ',',
					    itoa(m_sBlocks[idx1 + 1].m_iaStandby[i + 1]), ',',
					    itoa(m_sBlocks[idx1 + 1].m_iaVolume[i + 1]), ',',
					    itoa(m_sBlocks[idx1 + 1].m_iaMute[i + 1]), ',',
					    itoa(m_sBlocks[idx1 + 1].m_iaLF[i + 1]), ',',
					    itoa(m_sBlocks[idx1 + 1].m_iaHF[i + 1]), ',',
					    itoa(m_sBlocks[idx1 + 1].m_iaBalance[i + 1]),',',
					    itoa(m_sBlocks[idx1 + 1].m_iaTrim[i + 1])"
		}

	    } else
	    if(op >= OPERATION_READ_RDS_TUNER_1 && op <= OPERATION_READ_RDS_TUNER_8)
	    {
		idx1 = op - OPERATION_READ_RDS_TUNER_1 + 1;
		
		// ��������� ��������
		for(i = 1; i <= 8; i++)
		    str[i] = fnSB_GetIntBE(in_sbBuffer)
		    
		set_length_string(str, 8);

		if(str[1] != 0)
		    send_string vdvDevice, "'RDS ',itoa(idx1), ',', str"

		// ����� ������
		fnSB_Shift(in_sbBuffer)
	    
		// ���������� ����������
		#IF_DEFINED _DEBUG_FLAG
		    send_string 0, "'Receive: Read input registers'"
		#END_IF
	    }
	    
	    // ����� ������
	    fnSB_Shift(in_sbBuffer)
	    
	    // ���������� ����������
	    #IF_DEFINED _DEBUG_FLAG
		send_string 0, "'Receive: Read input registers'"
	    #END_IF
	    
	    return true
	}
	
	// ����� �� ������ ����������� ������
	case MODBUS_WRITE_COIL_STATUS:
	{
	    fnSB_SkipBytes(in_sbBuffer, 4)
	    
	    // ����� ������
	    fnSB_Shift(in_sbBuffer)
	    
	    // ���������� ����������
	    #IF_DEFINED _DEBUG_FLAG
		send_string 0, "'Receive: Write coil status'"
	    #END_IF
	    return true
	}

	// ����� �� ������ �������� ��������
	case MODBUS_WRITE_HOLDING_REGISTER:
	{
	    fnSB_SkipBytes(in_sbBuffer, 4)
	    
	    // ����� ������
	    fnSB_Shift(in_sbBuffer)
	    
	    // ���������� ����������
	    #IF_DEFINED _DEBUG_FLAG
		send_string 0, "'Receive: Write holding registers'"
	    #END_IF
	    return true
	}

	// ����� �� ������ ���������� �������
	case MODBUS_WRITE_COIL_STATUS_ARRAY:
	{
	    fnSB_SkipBytes(in_sbBuffer, 4)
	    
	    // ����� ������
	    fnSB_Shift(in_sbBuffer)
	    
	    // ���������� ����������
	    #IF_DEFINED _DEBUG_FLAG
		send_string 0, "'Receive: Write coil status array'"
	    #END_IF
	    return true
	}

	// ����� �� ������ �������� ���������
	case MODBUS_WRITE_HOLDING_REGISTER_ARRAY:
	{
	    if(fnSB_GetSize(in_sbBuffer) < 4)
		return false
		
	    a = fnSB_GetIntBE(in_sbBuffer)
	    s = fnSB_GetIntBE(in_sbBuffer)
	    
	    // ����� ������
	    fnSB_Shift(in_sbBuffer)
	    
	    // ���������� ����������
	    #IF_DEFINED _DEBUG_FLAG
		send_string 0, "'Receive: Write holding register array'"
	    #END_IF
	    return true
	}
    }
	
    // ����������� ������ ������ ��
    fnSB_Reset(in_sbBuffer)
    return false
}

/**
    ��������� ������� ���������� �� ����������� ����
    �� �����	: in_caCommand	- ��������� �� �������
    �� ������	: *
*/
define_function fnOnCommand(char in_caCommand[])
{
    local_var 
	integer a, v, l_iCount, i, bit
	integer value
	integer mute
	integer block
	integer zone
	char d, c, l_bRun
	integer l_iaTemp[256]
	integer l_iaValue[256]
	integer l_iAddr
	char l_caBlock[8]
    
    // �������� ������� ������� ��������� ���������� �������
    if(find_string(in_caCommand, 'GET_CS ', 1) == 1)
    {
	// �������� ������� ����������
	if(m_cIsConnect == 1)
	{
	    // ������ ������ ����������
	    remove_string(in_caCommand, 'GET_CS ', 1)
	    d = TYPE_CAST(atoi(in_caCommand))
	    
	    // ������ ������
	    remove_string(in_caCommand, ',', 1)
	    a = atoi(in_caCommand)
	    
	    // ������ ���������� �������� ������
	    remove_string(in_caCommand, ',', 1)
	    c = TYPE_CAST(atoi(in_caCommand))
    
	    // �������� ����������
	    if(fnTestParameters(d, a))
		fnOnSendReadCoilStatus(d, a, c)
	    else
		send_string vdvDevice, "'ERROR_GET: ', ITOHEX(d), ', invalid parameters'"
	}

    // �������� ������� ������� ��������� ���������� ������
    } else if(find_string(in_caCommand, 'GET_IS ', 1) == 1)
    {
	// �������� ������� ����������
	if(m_cIsConnect == 1)
	{
	    // ������ ������ ����������
	    remove_string(in_caCommand, 'GET_IS ', 1)
	    d = TYPE_CAST(atoi(in_caCommand))
	    
	    // ������ ������
	    remove_string(in_caCommand, ',', 1)
	    a = atoi(in_caCommand)
	    
	    // ������ ���������� �������� ������
	    remove_string(in_caCommand, ',', 1)
	    c = TYPE_CAST(atoi(in_caCommand))
    
	    // �������� ����������
	    if(fnTestParameters(d, a))
		fnOnSendReadInputStatus(d, a, c)
	    else
		send_string vdvDevice, "'ERROR_GET: ', ITOHEX(d), ', invalid parameters'"
	}

    // �������� �� ������� ������� GET
    } else if(find_string(in_caCommand, 'GET_HR ', 1) == 1)
    {
	// �������� ������� ����������
	if(m_cIsConnect == 1)
	{
	    // ������ ������ ����������
	    remove_string(in_caCommand, 'GET_HR ', 1)
	    d = TYPE_CAST(atoi(in_caCommand))
	    
	    // ������ ������
	    remove_string(in_caCommand, ',', 1)
	    a = atoi(in_caCommand)
	    
	    // ������ ���������� �������� ������
	    remove_string(in_caCommand, ',', 1)
	    c = TYPE_CAST(atoi(in_caCommand))
    
	    // �������� ����������
	    if(fnTestParameters(d, a))
		fnOnSendReadHoldingRegister(d, a, c)
	    else
		send_string vdvDevice, "'ERROR_GET: ', ITOHEX(d), ', invalid parameters'"
	}
	
    // �������� �� ������� ������� GET
    } else if(find_string(in_caCommand, 'GET_IR ', 1) == 1)
    {
	// �������� ������� ����������
	if(m_cIsConnect == 1)
	{
	    // ������ ������ ����������
	    remove_string(in_caCommand, 'GET_IR ', 1)
	    d = TYPE_CAST(atoi(in_caCommand))
	    
	    // ������ ������
	    remove_string(in_caCommand, ',', 1)
	    a = atoi(in_caCommand)
	    
	    // ������ ����������
	    
	    // ������ ���������� �������� ������
	    remove_string(in_caCommand, ',', 1)
	    c = TYPE_CAST(atoi(in_caCommand))
    
	    // �������� ����������
	    if(fnTestParameters(d, a))
		fnOnSendReadInputRegister(d, a, c)
	    else
		send_string vdvDevice, "'ERROR_GET: ', ITOHEX(d), ', invalid parameters'"
	}

    // ������� SET_CS
    } else if(find_string(in_caCommand, 'SET_CS ', 1) == 1)
    {
	// �������� ������� ����������
	if(m_cIsConnect == 1)
	{
	    // ������ ������ ����������
	    remove_string(in_caCommand, 'SET_CS ', 1)
	    d = TYPE_CAST(atoi(in_caCommand))
	    
	    // ������ ������
	    remove_string(in_caCommand, ',', 1)
	    a = atoi(in_caCommand)
	    
	    remove_string(in_caCommand, ',', 1)
	    
	    l_iCount = fnGetArray(in_caCommand, l_iaTemp);
	    
	    // �������� ����������
	    if(fnTestParameters(d, a))
	    {
		if(l_iCount == 1)
		    fnOnSendWriteCoilStatus(d, a, l_iaTemp[1])
		else
		    fnOnSendWriteCoilStatusArray(d, a, l_iCount, l_iaTemp);
	    }
	    else
		send_string vdvDevice, "'ERROR_SET: ', ITOHEX(d), ', invalid parameters'"
	}

    // ������� SET_HR
    } else if(find_string(in_caCommand, 'SET_HR ', 1) == 1)
    {
	// �������� ������� ����������
	if(m_cIsConnect == 1)
	{
	    // ������ ������ ����������
	    remove_string(in_caCommand, 'SET_HR ', 1)
	    d = TYPE_CAST(atoi(in_caCommand))
	    
	    // ������ ������
	    remove_string(in_caCommand, ',', 1)
	    a = atoi(in_caCommand)
	    
	    remove_string(in_caCommand, ',', 1)
	    
	    l_iCount = fnGetArray(in_caCommand, l_iaTemp);
	    
	    // �������� ����������
	    if(fnTestParameters(d, a))
	    {
		if(l_iCount == 1)
		    fnOnSendWriteHoldingRegister(d, a, l_iaTemp[1])
		else
		    fnOnSendWriteHoldingRegisterArray(d, a, l_iCount, l_iaTemp);
	    }
	    #IF_DEFINED _DEBUG_FLAG
	    else
		send_string 0, "'ERROR_SET: ', ITOHEX(d), ', invalid parameters'"
	    #END_IF
	}
    // �������� ������� ������� ��������� ������
    } else if(find_string(in_caCommand, 'INPUT', 1) == 1)
    {
	l_iCount = fnGetArray(in_caCommand, l_iaTemp);
	if(l_iCount >= 2 && l_iaTemp[1] > 0)
	{
	    // �������� ������ �����, ���� ����� ����� ������ ��� 24 ���������� �����
	    if(l_iaTemp[2] > 24)
		l_iaTemp[2] = 32
		
	    // ���������� ����������
	    #IF_DEFINED _DEBUG_FLAG
		send_string 0, "'input ', itoa(l_iaTemp[1]), ',', itoa(l_iaTemp[2])"
	    #END_IF
	    
	    l_iAddr = ((l_iaTemp[1] - 1) / 4) * 32 + (l_iaTemp[1] - 1) % 4
	    
	    if(l_iaTemp[2] != 0)
		l_iaValue[1] = (l_iaTemp[2] - 1) | $C0
	    else
		l_iaValue[1] = l_iaTemp[2]
	    
	    // �������� � ����� �� ���������� +0
	    fnOnSendWriteHoldingRegisterArray(0, 32 + MULTIROOM_COMUNICATE_INDEX + l_iAddr, 1, l_iaValue)

	    // ������� ������������ ����
	    l_caBlock[((l_iaTemp[1] - 1) / 4) + 1] = 1
	}
	
    // �������� ������� ������� ��������� ���������� ���������
    } else if(find_string(in_caCommand, 'VOLUME_UP', 1) == 1)
    {
	l_iCount = fnGetArray(in_caCommand, l_iaTemp);
	if(l_iCount >= 1 && l_iaTemp[1] > 0)
	{
	    #IF_DEFINED _DEBUG_FLAG
		send_string 0, "'volume ', itoa(l_iaTemp[1]), ',', itoa(l_iaTemp[2])"
	    #END_IF
	    
	    l_iAddr = ((l_iaTemp[1] - 1) / 4) * 32 + (l_iaTemp[1] - 1) % 4
	    
	    l_iaValue[1] = 64
	    
	    // �������� � ����� �� ��������� +4
	    fnOnSendWriteHoldingRegisterArray(0, 32 + MULTIROOM_VOLUME_INDEX + l_iAddr, 1, l_iaValue)
	    
	    // ������� ������������ ����
	    //l_caBlock[((l_iaTemp[1] - 1) / 4) + 1] = 1
	}
	
    // �������� ������� ������� ��������� ���������� ���������
    } else if(find_string(in_caCommand, 'VOLUME_DOWN', 1) == 1)
    {
	l_iCount = fnGetArray(in_caCommand, l_iaTemp);
	if(l_iCount >= 1 && l_iaTemp[1] > 0)
	{
	    #IF_DEFINED _DEBUG_FLAG
		send_string 0, "'volume ', itoa(l_iaTemp[1]), ',', itoa(l_iaTemp[2])"
	    #END_IF
	    
	    l_iAddr = ((l_iaTemp[1] - 1) / 4) * 32 + (l_iaTemp[1] - 1) % 4
	    
	    l_iaValue[1] = 128
	    
	    // �������� � ����� �� ��������� +4
	    fnOnSendWriteHoldingRegisterArray(0, 32 + MULTIROOM_VOLUME_INDEX + l_iAddr, 1, l_iaValue)
	    
	    // ������� ������������ ����
	    //l_caBlock[((l_iaTemp[1] - 1) / 4) + 1] = 1
	}
	
    // �������� ������� ������� ��������� ��������� ���������
    } else if(find_string(in_caCommand, 'VOLUME_STOP', 1) == 1)
    {
	l_iCount = fnGetArray(in_caCommand, l_iaTemp);
	if(l_iCount >= 1 && l_iaTemp[1] > 0)
	{
	    #IF_DEFINED _DEBUG_FLAG
		send_string 0, "'volume ', itoa(l_iaTemp[1]), ',', itoa(l_iaTemp[2])"
	    #END_IF
	    
	    l_iAddr = ((l_iaTemp[1] - 1) / 4) * 32 + (l_iaTemp[1] - 1) % 4
	    
	    l_iaValue[1] = 192
	    
	    // �������� � ����� �� ��������� +4
	    fnOnSendWriteHoldingRegisterArray(0, 32 + MULTIROOM_VOLUME_INDEX + l_iAddr, 1, l_iaValue)
	    
	    // ������� ������������ ����
	    l_caBlock[((l_iaTemp[1] - 1) / 4) + 1] = 1
	}
    // �������� ������� ������� ��������� ���������
    } else if(find_string(in_caCommand, 'VOLUME', 1) == 1)
    {
	l_iCount = fnGetArray(in_caCommand, l_iaTemp);
	if(l_iCount >= 2 && l_iaTemp[1] > 0 && l_iaTemp[2] <= 63)
	{
	    #IF_DEFINED _DEBUG_FLAG
		send_string 0, "'volume ', itoa(l_iaTemp[1]), ',', itoa(l_iaTemp[2])"
	    #END_IF
	    
	    l_iAddr = ((l_iaTemp[1] - 1) / 4) * 32 + (l_iaTemp[1] - 1) % 4
	    
	    l_iaValue[1] = l_iaTemp[2]
	    
	    // �������� � ����� �� ��������� +4
	    fnOnSendWriteHoldingRegisterArray(0, 32 + MULTIROOM_VOLUME_INDEX + l_iAddr, 1, l_iaValue)
	    
	    // ������� ������������ ����
	    l_caBlock[((l_iaTemp[1] - 1) / 4) + 1] = 1
	}
	
    // �������� ������� ������� ��������� Mute
    } else if(find_string(in_caCommand, 'MUTE', 1) == 1)
    {
	l_iCount = fnGetArray(in_caCommand, l_iaTemp);
	if(l_iCount >= 1 && l_iaTemp[1] > 0)
	{		
	    // ���������� ����������
	    #IF_DEFINED _DEBUG_FLAG
		send_string 0, "'mute ', itoa(l_iaTemp[1]), ',', itoa(l_iaTemp[2])"
	    #END_IF
	    
	    //������� ����� �����
	    block = (l_iaTemp[1] - 1) / 4
	    //������� ����� ������ �����������
	    zone = (l_iaTemp[1] - 1) % 4
	    //��������� ����� �������
	    l_iAddr = block * 32 + zone
	    
	    //������� ����� ��������� � ��������� ����
	    value = m_sBlocks[block + 1].m_iaComutation[zone + 1]
	    //������� �������� Mute
	    mute = m_sBlocks[block + 1].m_iaMute[zone + 1]
	    
	    //send_string 0, "'DH ZONE = ', itoa(zone + 1)"
	    //send_string 0, "'DH SOURCE = ', itoa(value)"
	    //�������� ���������
	    //if(value >= 1 && value <= 24)	
		value = (value - 1) | 192
	    //if(value == 32)			
		//value = 223
	    
	    //send_string 0, "'DH BLOCK = ', itoa(block)"
	    
	    send_string 0, "'DH VALUE = ', itoa(value)"
	    
	    //�������� �������� Mute
	    l_iaValue[1] = (value & (~(1 << 5))) | ((~mute & 1) << 5)
	    
	    send_string 0, "'DH MUTE VALUE = ', itoa(l_iaValue[1])"
	    
	    // �������� � ����� �� ���������� +0
	    fnOnSendWriteHoldingRegisterArray(0, 32 + MULTIROOM_COMUNICATE_INDEX + l_iAddr, 1, l_iaValue)
	    
	    // ������� ������������ ����
	    l_caBlock[((l_iaTemp[1] - 1) / 4) + 1] = 1
	    
	    /*
	    //���������� 5-� ��� � 1
	    value = value | (1<<5);
	    
	    //���������� 5-� ��� � 0
	    value = value & (~(1 << 5));
	    
	    
	    //������������ 5-�� ����
	    if((value & (1 << 5)) != 0)
		value = value & (~(1 << 5));
	    else
		value = value | (1<<5)
	    //������������ 5-�� ����
	    bit = value & (1 << 5);
	    value = (value & (~(1 << 5))) | ~bit;
	    
	    */
	}
    // �������� ������� ������� ��������� ������ �������
    } else if(find_string(in_caCommand, 'BASS', 1) == 1)
    {
	l_iCount = fnGetArray(in_caCommand, l_iaTemp);
	if(l_iCount >= 2 && l_iaTemp[1] > 0 && l_iaTemp[2] <= 15)
	{
	    // ���������� ����������
	    #IF_DEFINED _DEBUG_FLAG
		send_string 0, "'bass ', itoa(l_iaTemp[1]), ',', itoa(l_iaTemp[2])"
	    #END_IF
	    
	    l_iAddr = ((l_iaTemp[1] - 1) / 4) * 32 + (l_iaTemp[1] - 1) % 4
	    
	    l_iaValue[1] = l_iaTemp[2]
	    
	    // �������� � ����� �� ������ ������� +8
	    fnOnSendWriteHoldingRegisterArray(0, 32 + MULTIROOM_BASS_INDEX + l_iAddr, 1, l_iaValue)
	    
	    // ������� ������������ ����
	    l_caBlock[((l_iaTemp[1] - 1) / 4) + 1] = 1
	}
	
    // �������� ������� ������� ��������� ������ �������
    } else if(find_string(in_caCommand, 'TREBLE', 1) == 1)
    {
	l_iCount = fnGetArray(in_caCommand, l_iaTemp);
	if(l_iCount >= 2 && l_iaTemp[1] > 0 && l_iaTemp[2] <= 15)
	{
	    // ���������� ����������
	    #IF_DEFINED _DEBUG_FLAG
		send_string 0, "'treble ', itoa(l_iaTemp[1]), ',', itoa(l_iaTemp[2])"
	    #END_IF
	    
	    l_iAddr = ((l_iaTemp[1] - 1) / 4) * 32 + (l_iaTemp[1] - 1) % 4
	    
	    l_iaValue[1] = l_iaTemp[2]

	    // �������� � ����� �� ������� ������� +8
	    fnOnSendWriteHoldingRegisterArray(0, 32 + MULTIROOM_TREBLE_INDEX + l_iAddr, 1, l_iaValue)
	    
	    // ������� ������������ ����
	    l_caBlock[((l_iaTemp[1] - 1) / 4) + 1] = 1
	}
    
    // �������� ������� ������� ��������� �������
    } else if(find_string(in_caCommand, 'BALANCE', 1) == 1)
    {
	l_iCount = fnGetArray(in_caCommand, l_iaTemp);
	if(l_iCount >= 2 && l_iaTemp[1] > 0 && l_iaTemp[2] <= 15)
	{
	    // ���������� ����������
	    #IF_DEFINED _DEBUG_FLAG
		send_string 0, "'balance ', itoa(l_iaTemp[1]), ',', itoa(l_iaTemp[2])"
	    #END_IF
	    
	    l_iAddr = ((l_iaTemp[1] - 1) / 4) * 32 + (l_iaTemp[1] - 1) % 4
	    
	    l_iaValue[1] = l_iaTemp[2]
	    
	    // �������� � ����� �� ������ +16
	    fnOnSendWriteHoldingRegisterArray(0, 32 + MULTIROOM_BALANCE_INDEX + l_iAddr, 1, l_iaValue)
	    
	    // ������� ������������ ����
	    l_caBlock[((l_iaTemp[1] - 1) / 4) + 1] = 1
	}
	
    // �������� ������� ������� ��������� TRIM
    } else if(find_string(in_caCommand, 'TRIM', 1) == 1)
    {
	l_iCount = fnGetArray(in_caCommand, l_iaTemp);
	if(l_iCount >= 2 && l_iaTemp[1] > 0 && l_iaTemp[2] <= 127)
	{
	    // ���������� ����������
	    #IF_DEFINED _DEBUG_FLAG
		send_string 0, "'trim ', itoa(l_iaTemp[1]), ',', itoa(l_iaTemp[2])"
	    #END_IF
	    
	    l_iAddr = ((l_iaTemp[1] - 1) / 4) * 32 + (l_iaTemp[1] - 1) % 4
	    
	    l_iaValue[1] = l_iaTemp[2]
	    
	    // �������� � ����� �� TRIM +26
	    fnOnSendWriteHoldingRegisterArray(0, 32 + MULTIROOM_TRIM_INDEX + l_iAddr, 1, l_iaValue)
	    
	    // ������� ������������ ����
	    l_caBlock[((l_iaTemp[1] - 1) / 4) + 1] = 1
	}
	
    // �������� ������� ������� ������� ��������� ������
    // TUNER_ON tuner, frequency;
    } else if(find_string(in_caCommand, 'TUNER_ON', 1) == 1)
    {
	l_iCount = fnGetArray(in_caCommand, l_iaTemp);
	if(l_iCount >= 2 && l_iaTemp[1] > 0)
	{
	    // ���������� ����������
	    #IF_DEFINED _DEBUG_FLAG
		send_string 0, "'tuner_on ', itoa(l_iaTemp[1]), ',', itoa(l_iaTemp[2])"
	    #END_IF
	    
	    l_iAddr = (l_iaTemp[1] - 1) * 32
	    
	    l_iaValue[1] = 128			// ����� ������ �����
	    l_iaValue[2] = l_iaTemp[2] & $FF	// ������� ���� �������
	    l_iaValue[3] = l_iaTemp[2] >> 8	// ������� ���� �������

	    // �������� � ����� �� ������� ������� +8
	    fnOnSendWriteHoldingRegisterArray(0, 256 + l_iAddr, 3, l_iaValue)
	}
	
    // �������� ������� ������� ������� ���������� ������
    // TUNER_OFF tuner;
    } else if(find_string(in_caCommand, 'TUNER_OFF', 1) == 1)
    {
	l_iCount = fnGetArray(in_caCommand, l_iaTemp);
	if(l_iCount >= 1 && l_iaTemp[1] > 0)
	{
	    // ���������� ����������
	    #IF_DEFINED _DEBUG_FLAG
		send_string 0, "'tuner_off ', itoa(l_iaTemp[1])"
	    #END_IF
	    
	    l_iAddr = (l_iaTemp[1] - 1) * 32
	    
	    l_iaValue[1] = 0			// ����� ������ �����
	    l_iaValue[2] = 0			// ������� ���� �������
	    l_iaValue[3] = 0			// ������� ���� �������

	    // �������� � ����� �� ������� ������� +8
	    fnOnSendWriteHoldingRegisterArray(0, 256 + l_iAddr, 3, l_iaValue)
	}
	
    // �������� ������� ������� ������� �������� �����
    } else if(find_string(in_caCommand, 'GET_BLOCK', 1) == 1)
    {
	l_iCount = fnGetArray(in_caCommand, l_iaTemp);
	if(l_iCount >= 1)
	{
	    // ������ �����
	    fnOnSendReadHoldingRegisterBlock(0, l_iaTemp[1]);
	    fnOnSendReadInputRegisterBlock(0, l_iaTemp[1]);
	}
	
    // �������� ������� ������� ������� ���������� � RDS
    } else if(find_string(in_caCommand, 'GET_RDS', 1) == 1)
    {
	l_iCount = fnGetArray(in_caCommand, l_iaTemp);
	if(l_iCount >= 1)
	{
	    // ������ �����
	    fnOnSendReadRDS(0, l_iaTemp[1]);
	}
	
    // �������� ������� ������� ������� ���������� � RDS
    } else if(find_string(in_caCommand, 'SET_RDS', 1) == 1)
    {
	l_iCount = fnGetArray(in_caCommand, l_iaTemp);
	if(l_iCount >= 1 && l_iaTemp[1] > 0 && l_iaTemp[1] <= 8)
	    m_caRDS[l_iaTemp[1]] = l_iaTemp[2]
	
    // �������� ������� ������� ��������� ����
    // ON channel, source, volume, lh, hf, bal, trim;
    } else if(find_string(in_caCommand, 'ON', 1) == 1)
    {
	l_iCount = fnGetArray(in_caCommand, l_iaTemp);
	if(l_iCount >= 7 && l_iaTemp[3] <= 63 && l_iaTemp[4] <= 15 && l_iaTemp[5] <= 15 && l_iaTemp[6] <= 15 && l_iaTemp[7] <= 127)
	{
	    // �������� ������ �����, ���� ����� ����� ������ ��� 24 ���������� �����
	    if(l_iaTemp[2] > 24)
		l_iaTemp[2] = 32
		
	    // ���������� ����������
	    #IF_DEFINED _DEBUG_FLAG
		send_string 0, "'on ', itoa(l_iaTemp[1]), ',', itoa(l_iaTemp[2]), ',', itoa(l_iaTemp[3]), ',', itoa(l_iaTemp[4]), ',',itoa(l_iaTemp[5]), ',',itoa(l_iaTemp[6]), ',',itoa(l_iaTemp[7])"
	    #END_IF
	    
	    l_iAddr = ((l_iaTemp[1] - 1) / 4) * 32 + (l_iaTemp[1] - 1) % 4

	    // ����� ���������
	    if(l_iaTemp[2] != 0)
		l_iaValue[1] = (l_iaTemp[2] - 1) | $C0
	    else
		l_iaValue[1] = l_iaTemp[2]

	    // �������� � ����� �� ���������� +0
	    fnOnSendWriteHoldingRegisterArray(0, 32 + MULTIROOM_COMUNICATE_INDEX + l_iAddr, 1, l_iaValue)
	    
	    // �������� � ����� �� ��������� +4
	    l_iaValue[1] = l_iaTemp[3]	// ���������
	    fnOnSendWriteHoldingRegisterArray(0, 32 + MULTIROOM_VOLUME_INDEX + l_iAddr, 1, l_iaValue)
	    
	    // �������� � ����� �� ������ ������� +8
	    l_iaValue[1] = l_iaTemp[4]	// ������ �������
	    fnOnSendWriteHoldingRegisterArray(0, 32 + MULTIROOM_BASS_INDEX + l_iAddr, 1, l_iaValue)
	    
	    // �������� � ����� �� ������� ������� +12
	    l_iaValue[1] = l_iaTemp[5]	// ������� �������
	    fnOnSendWriteHoldingRegisterArray(0, 32 + MULTIROOM_TREBLE_INDEX + l_iAddr, 1, l_iaValue)
	    
	    // �������� � ����� �� ������ +16
	    l_iaValue[1] = l_iaTemp[6]	// ������
	    fnOnSendWriteHoldingRegisterArray(0, 32 + MULTIROOM_BALANCE_INDEX + l_iAddr, 1, l_iaValue)
	    
	    // �������� � ����� �� trim +26
	    l_iaValue[1] = l_iaTemp[7]	// trim
	    fnOnSendWriteHoldingRegisterArray(0, 32 + MULTIROOM_TRIM_INDEX + l_iAddr, 1, l_iaValue)
	    
	    // ������� ������������ ����
	    l_caBlock[((l_iaTemp[1] - 1) / 4) + 1] = 1
	}
	
    // �������� ������� ������� ���������� ����
    } else if(find_string(in_caCommand, 'OFF', 1) == 1)
    {
	l_iCount = fnGetArray(in_caCommand, l_iaTemp);
	if(l_iCount >= 1 && l_iaTemp[1] > 0)
	{
	    // ���������� ����������
	    #IF_DEFINED _DEBUG_FLAG
		send_string 0, "'off ', itoa(l_iaTemp[1])"
	    #END_IF
	    
	    l_iAddr = ((l_iaTemp[1] - 1) / 4) * 32 + (l_iaTemp[1] - 1) % 4
	    
	    // �����������
	    l_iaValue[1] = 0
	    // �������� � ����� �� ���������� +0
	    fnOnSendWriteHoldingRegisterArray(0, 32 + MULTIROOM_COMUNICATE_INDEX + l_iAddr, 1, l_iaValue)
	    // �������� � ����� �� ��������� +4
	    fnOnSendWriteHoldingRegisterArray(0, 32 + MULTIROOM_VOLUME_INDEX + l_iAddr, 1, l_iaValue)
	    
	    // ������� ������������ ����
	    l_caBlock[((l_iaTemp[1] - 1) / 4) + 1] = 1
	}
	
    // �������� ������� ������� ���������� ���� � ����� STANDBY
    } else if(find_string(in_caCommand, 'STANDBY', 1) == 1)
    {
	l_iCount = fnGetArray(in_caCommand, l_iaTemp);
	if(l_iCount >= 1 && l_iaTemp[1] > 0)
	{
	    // ���������� ����������
	    #IF_DEFINED _DEBUG_FLAG
		send_string 0, "'standby ', itoa(l_iaTemp[1])"
	    #END_IF
	    
	    l_iAddr = ((l_iaTemp[1] - 1) / 4) * 32 + (l_iaTemp[1] - 1) % 4
	    
	    // �����������
	    l_iaValue[1] = 128
	    // �������� � ����� �� ���������� +0
	    fnOnSendWriteHoldingRegisterArray(0, 32 + MULTIROOM_COMUNICATE_INDEX + l_iAddr, 1, l_iaValue)
	    // �������� � ����� �� ��������� +4
	    l_iaValue[1] = 0
	    fnOnSendWriteHoldingRegisterArray(0, 32 + MULTIROOM_VOLUME_INDEX + l_iAddr, 1, l_iaValue)
	    
	    // ������� ������������ ����
	    l_caBlock[((l_iaTemp[1] - 1) / 4) + 1] = 1
	}
	
    // �������� ������� ������� ����������
    } else if(find_string(in_caCommand, 'START', 1) == 1)
    {
	//  ������ ������ ��� ����������� ����������
	timeline_create(TL_WORK_ID, m_laWork, 1, TIMELINE_ABSOLUTE, TIMELINE_REPEAT)
	send_string vdvDevice, "'START'"
	
    } else if(find_string(in_caCommand, 'STOP', 1) == 1)
    {
	// ��������� ������ ��� ����������� ����������
	timeline_kill(TL_WORK_ID);
	send_string vdvDevice, "'STOP'"
    }
    
    // ������ ������������ ������
    for(i = 1; i <= 6; i++) {
	if(l_caBlock[i] != 0) {
	    fnOnSendReadHoldingRegisterBlock(0, i - 1);
	    fnOnSendReadInputRegisterBlock(0, i - 1);
	}
    }
}

/**
    ��������� ����������� ���������� � ������������
    �� �����	: *
    �� ������	: *
*/
define_function fnOnWork()
{
    local_var long l_lTime
    if(m_cIsConnect == 0)
    {
	// ��������� 
	l_lTime = m_lCurTime - m_lStartWaitTime
	if(l_lTime > 3000)
	{
	    m_cIsConnect = 2
	    
	    send_command vdvDevice, "'fnOnConnect(', caHost, ',', itoa(iPort), ')'"
	    fnOnConnect(dvPhysicalDevice, caHost, iPort)
	    
	    m_lStartWaitTime = m_lCurTime
	}
    } else if(m_cIsConnect == 1)
    {
	l_lTime = m_lCurTime - m_lLastPingTime
	if(l_lTime > 8000)
	{
	    fnOnDisconnect(dvPhysicalDevice)
	    send_string vdvDevice, "'TIMEOUT'"
	}
    } else if(m_cIsConnect == 2)
    {
	// ��������� 
	l_lTime = m_lCurTime - m_lStartWaitTime
	if(l_lTime > 5000)
	{
	    send_command vdvDevice, "'TIMEOUT WAIT CONNECT'"
	    m_cIsConnect = 0
	    m_lStartWaitTime = m_lCurTime
	}
    }
}

define_function fnOnUpdateRDS()
{
    local_var integer i
    for(i = 1; i <= 8; i++)
	if(m_caRDS[i] != 0)
	    fnOnSendReadRDS(0, i)
}

(***********************************************************)
(*        SUBROUTINE/FUNCTION DEFINITIONS GO BELOW         *)
(***********************************************************)
(* EXAMPLE: DEFINE_FUNCTION <RETURN_TYPE> <NAME> (<PARAMETERS>) *)
(* EXAMPLE: DEFINE_CALL '<NAME>' (<PARAMETERS>) *)

(***********************************************************)
(*                STARTUP CODE GOES BELOW                  *)
(***********************************************************)
DEFINE_START
// ������������� ���������� ������
fnSB_Reset(m_sbInputBuffer)

(***********************************************************)
(*                THE EVENTS GO BELOW                      *)
(***********************************************************)
DEFINE_EVENT

/**
    ���������� ������� �����
*/
TIMELINE_EVENT[TL_PING_ID]
{
    if(timeline.sequence == 1)
    {
	fnOnPing()
	
	m_lRDS = m_lRDS + m_laPing[1]
	if(m_lRDS >= 1000)
	{
	    m_lRDS = 0
	    fnOnUpdateRDS()
	}
    }
}

/**
    ���������� ����������� ����������
*/
TIMELINE_EVENT[TL_WORK_ID]
{
    if(timeline.sequence == 1)
    {
	m_lCurTime = m_lCurTime + m_laWork[1]
	fnOnWork()
    }
}

/**
    ���������� ����������� �����
*/
DATA_EVENT[dvPhysicalDevice]
{
    // ��������� ����������
    ONLINE:
    {
	// ���������� ����������
	#IF_DEFINED __DEBUG__
	    printf("'modbus tcp physical port is online'")
	#END_IF
	
	// ���������� �����������
	m_cIsConnect = 1

	// ������������� ����������
	fnOnInit()
	// �������� ������������� �������� ������
	send_string vdvDevice, "'DigiHouse Multiroom Is Connected!!!'"
    }
    
    // ���������� ����������
    OFFLINE:
    {
	// ���������� ����������
	#IF_DEFINED __DEBUG__
	    printf("'modbus physical port is offline'")
	#END_IF
	
	// ������������� ����������
	fnOnDeInit()
	
	// ���������� ��������
	m_cIsConnect = 0
	
	// �������� ������������� �������� ������
	send_string vdvDevice, "'DigiHouse Multiroom Disconnected!!!'"
    }
    
    // ��������� �������
    STRING:
    {
	// ���������� ����������
	#IF_DEFINED __DEBUG__
	//    printf(data.text)
	#END_IF
	
	// ���������� ��������� ������ � �����
	if(fnSB_Add(m_sbInputBuffer, data.text))
	{
	    // ��������� ��������� ������
	    while(1)
	    {
		if(fnOnReceive(m_sbInputBuffer) == false)
		    break
	    }
	} else
	{
	    // ������������ ������
	    send_string vdvDevice, "'Buffer overflow!'"

	    // ����� ������ ������
	    fnSB_Reset(m_sbInputBuffer)
	}
    }
    
    // ��������� ������
    ONERROR:
    {
	// ���������� ����������
	#IF_DEFINED __DEBUG__
	    printf("'modbus physical port error'")
	    printf(DATA.TEXT)
	#END_IF
	    send_string vdvDevice, DATA.TEXT
    }
}

/**
    ���������� ������������ �����
*/
DATA_EVENT[vdvDevice]
{
    COMMAND:
    {
	local_var char caCommand[256]
	
	// ������� � ������� �������
	fnStr_ToUpper(data.text)
	
	// ���������� ����������
	#IF_DEFINED __DEBUG__
	    printf(data.text)
	#END_IF

	// ��������� ���� ���� �������
	while(fnStr_GetStringWhile(data.text, caCommand, $3B))
	{
	    // ��������� �������
	    fnOnCommand(caCommand)
	    
	    // �������� ����������� �������
	    remove_string(data.text, "$3B", 1)
	}
    }
}

channel_event[vdvDevice, 0]
{
    on:
    {
	local_var integer l_iCh
	local_var integer l_iZone
	    
	l_iZone = atoi(left_string(itoa(channel.channel), 2)) - 10
	l_iCh = atoi(right_string(itoa(channel.channel), 2))
	
	switch(l_iCh)
	{
	    case 97: send_command vdvDevice, "'VOLUME_UP ', itoa(l_iZone), ';'"
	    case 98: send_command vdvDevice, "'VOLUME_DOWN ', itoa(l_iZone), ';'"
	    case 99: send_command vdvDevice, "'MUTE ', itoa(l_iZone), ';'"
	}
    }
    off:
    {
	local_var integer l_iCh
	local_var integer l_iZone
	    
	l_iZone = atoi(left_string(itoa(channel.channel), 2)) - 10
	l_iCh = atoi(right_string(itoa(channel.channel), 2))
	
	switch(l_iCh)
	{
	    case 97:
	    case 98: 
		send_command vdvDevice, "'VOLUME_STOP ', itoa(l_iZone), ';'"
	}
    }
}
(***********************************************************)
(*            THE ACTUAL PROGRAM GOES BELOW                *)
(***********************************************************)
DEFINE_PROGRAM

(***********************************************************)
(*                     END OF PROGRAM                      *)
(*        DO NOT PUT ANY CODE BELOW THIS COMMENT           *)
(***********************************************************)
