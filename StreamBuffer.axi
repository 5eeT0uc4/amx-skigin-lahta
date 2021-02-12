/**
    ��������������:
	���������� ���������� ������. �������� ���������� ��� ���������
	�������� ������.

    �����:
	������������ ����� (marat@ixbt.com, at_marat@list.ru)
    
    ������: 1.0d
    
    �������:
	15.04.2008 - 1.0d ���������� ������ ������ ������
	14.04.2008 - 1.0c ��������� ������� fnSB_GetStringWhile
	10.04.2008 - 1.0b ���������� ������ ���������� ������
		   - ������� ���� _iLen � ����� � ����������������� ������
	09.04.2008 - 1.0a ��������� ������ fnSB_GetString, fnSB_GetUNICODEString, fnSB_GetPosition, fnSB_SetPosition
	17.03.2008 - 1.0  ������ ����������

    ������������� � �������:
	#include 'StreamBuffer'
    
*/
PROGRAM_NAME='StreamBuffer'

// ����� ���������
#INCLUDE 'UnicodeLib.axi'

DEFINE_TYPE

// ��������� � ��������� ������
structure StreamBuffer
{
    char 	_caBuffer[8192]	// ����� � �������
    integer	_iPtr		// ������� ������ ������
}

/**
    ������������� ������
    �� �����	:	in_sbBuffer 	- ��������� �� ������ ������
			in_iIndex	- ������ ������ ��� �������������
    �� ������	:	*
*/
define_function fnSB_Init(StreamBuffer in_sbBuffer, char in_caBuffee[])
{
    in_sbBuffer._caBuffer	= in_caBuffee
    in_sbBuffer._iPtr		= 1
}

/**
    �����, ������� ������
    �� �����	:	in_sbBuffer 	- ��������� �� ������ ������
    �� ������	:	*
*/
define_function fnSB_Reset(StreamBuffer in_sbBuffer)
{
    in_sbBuffer._iPtr	= 1
    set_length_string(in_sbBuffer._caBuffer, 0)
}

/**
    ��������� ������� (�����) �� ������
    �� �����	:	in_sbBuffer 	- ��������� �� ������ ������
    �� ������	:	��������� �������� 
*/
define_function char fnSB_GetChar(StreamBuffer in_sbBuffer)
{
    local_var char val
    val = in_sbBuffer._caBuffer[in_sbBuffer._iPtr]
    in_sbBuffer._iPtr++
    return val
}

/**
    ��������� ����� (��� �����) �� ������ ������������� ������� ������ (x86 �������)
    �� �����	:	in_sbBuffer 	- ��������� �� ������ ������
    �� ������	:	��������� ��������
*/
define_function integer fnSB_GetIntLE(StreamBuffer in_sbBuffer)
{
    local_var integer val
    val = TYPE_CAST(in_sbBuffer._caBuffer[in_sbBuffer._iPtr + 1] << 8 | in_sbBuffer._caBuffer[in_sbBuffer._iPtr])
    in_sbBuffer._iPtr = in_sbBuffer._iPtr + 2
    return val
}

/**
    ��������� ����� (��� �����) �� ������ ������������ ������� ������ (������� �������)
    �� �����	:	in_sbBuffer 	- ��������� �� ������ ������
    �� ������	:	��������� ��������
*/
define_function integer fnSB_GetIntBE(StreamBuffer in_sbBuffer)
{
    local_var integer val
    val = TYPE_CAST(in_sbBuffer._caBuffer[in_sbBuffer._iPtr] << 8 | in_sbBuffer._caBuffer[in_sbBuffer._iPtr + 1])
    in_sbBuffer._iPtr = in_sbBuffer._iPtr + 2
    return val
}

/**
    ��������� ���������� �������� (����) � ������
    �� �����	:	in_sbBuffer 	- ��������� �� ������ ������
    �� ������	:	���������� �������� (����) � ������
*/
define_function integer fnSB_GetSize(StreamBuffer in_sbBuffer)
{
    return length_string(in_sbBuffer._caBuffer) - (in_sbBuffer._iPtr - 1)
}

/**
    ������� ���������� ���������� �������� (����)
    �� �����	:	in_sbBuffer 	- ��������� �� ������ ������
			in_iSkip	- ���������� ������������ ��������
    �� ������	:	*
*/
define_function fnSB_SkipBytes(StreamBuffer in_sbBuffer, integer in_iSkip)
{
    local_var integer l
    
    l = in_iSkip
    if(in_iSkip > fnSB_GetSize(in_sbBuffer))
	l = fnSB_GetSize(in_sbBuffer)
    
    in_sbBuffer._iPtr = in_sbBuffer._iPtr + l
}

/**
    ����� ������ �� �������� ���������� ��������
    �� �����	:	in_sbBuffer 	- ��������� �� ������ ������
			in_iSkip	- ���������� �������� �� ������� �����
					�������� �����
    �� ������	:	*
*/
define_function fnSB_ShiftBytes(StreamBuffer in_sbBuffer, integer in_iSkip)
{
    local_var integer i, len
    len = length_string(in_sbBuffer._caBuffer)
    
    if(in_iSkip == 0)
	return

    if(in_iSkip >= len)
    {
	len = 0
    } else
    {
	len = len - in_iSkip
	for(i = 1; i <= len; i++)
	    in_sbBuffer._caBuffer[i] = in_sbBuffer._caBuffer[i + in_iSkip]
    }
    
    in_sbBuffer._iPtr = 1
    set_length_string(in_sbBuffer._caBuffer, len)
}

/**
    ����� �� ���������� ���������� ����
    �� �����	:	in_sbBuffer 	- ��������� �� ������ ������
    �� ������	:	*
*/
define_function fnSB_Shift(StreamBuffer in_sbBuffer)
{
    fnSB_ShiftBytes(in_sbBuffer, in_sbBuffer._iPtr - 1)
}

/**
    ���������� ������ � �����
    �� �����	:	in_sbBuffer 	- ��������� �� ������ ������
			in_caBuffer	- ��������� �� ����������� ������
    �� ������	:	true 	- ������ ���������
			false 	- ������ �� ����������
*/
define_function char fnSB_Add(StreamBuffer in_sbBuffer, char in_caBuffer[])
{
    local_var integer append_size, dest_size, free_size, i
    
    // ���������� ������� ������� � �������� ������
    append_size = length_string(in_caBuffer)
    dest_size = length_string(in_sbBuffer._caBuffer)
    
    // ���������� ��������� ������
    free_size = max_length_string(in_sbBuffer._caBuffer) - dest_size
    
    // �������� ����������� ����������
    if(free_size >= append_size)
    {
	for(i = 0; i < append_size; i++)
	    in_sbBuffer._caBuffer[dest_size + i + 1] = in_caBuffer[i + 1]
	
	set_length_string(in_sbBuffer._caBuffer, dest_size + append_size)
	return true
    }
    return false
}

/**
    ����� ������������������ � ������
    �� �����	:	in_sbBuffer 	- ��������� �� ������ ������
			in_caSeq	- ��������� �� ������� ������������������
			in_cSeek	- ���� ������ � ������ �����������
					true - � ������ ����������� ������������������
					������� � ������ ����� ��������� �� ������ �������
					false - ������� ��������� ��� ���������
    �� ������	:	true 	- ������� ������������������ �������
			false 	- ������������������ �� �������
*/
define_function char fnSB_Find(StreamBuffer in_sbBuffer, char in_caSeq[], char in_cSeek)
{
    local_var integer p, l
    p = find_string(in_sbBuffer._caBuffer, in_caSeq, in_sbBuffer._iPtr)
    if(p != 0)
    {
	// �������� ������� ����� ������
	if(in_cSeek)
	{
	    // ����� ������
	    l = p - in_sbBuffer._iPtr
	    in_sbBuffer._iPtr = in_sbBuffer._iPtr + l
	}
	return true
    }
    return false
}

/**
    ��������� ������� ������� ������ �� ������
    �� �����	:	in_sbBuffer 	- ��������� �� ������ ������
			in_caBuffer	- ��������� �� ����������� �����
			in_iBufferPtr	- ������ � �������� ����� ��������� ����� 
			in_iSize	- ���������� ���������� ������ � ��������
    �� ������	:	���������� ��������� ��������, � ������ ������ ������� ���������� 0
*/
define_function integer fnSB_GetString(StreamBuffer in_sbBuffer, char in_caBuffer[], integer in_iBufferPtr, integer in_iSize)
{
    local_var integer len, max, i

    // ��������� ������� ������������ ������
    max = max_length_string(in_caBuffer)
    
    // �������� ����������
    if(in_iBufferPtr == 0 || in_iSize == 0 || in_iBufferPtr > max)
	return 0

    // ���������� ������� ������������ ������
    len = max - (in_iBufferPtr - 1)
    
    // �������� ������� ������������ ������
    if(len == 0)
	return 0
    
    // �������� ����������� ��������� ������������� ������
    if(len > in_iSize)
	len = in_iSize
    
    // �������� ������� ������ � ������
    if(len > fnSB_GetSize(in_sbBuffer))
	len = fnSB_GetSize(in_sbBuffer)

    // ���������� ������
    for(i = 0; i < len; i++)
	in_caBuffer[in_iBufferPtr + i] = in_sbBuffer._caBuffer[in_sbBuffer._iPtr + i]

    // ��������� ���������� ������
    in_sbBuffer._iPtr = in_sbBuffer._iPtr + len
    
    // ��������� ������� ������
    set_length_string(in_caBuffer, len)
    return len
}

/**
    ��������� Unicode ������� ������� ������ �� ������
    �� �����	:	in_sbBuffer 	- ��������� �� ������ ������
			in_waBuffer	- ��������� �� ����������� �����
			in_iBufferPtr	- ������ � �������� ����� ��������� ����� 
			in_iSize	- ���������� ���������� ������ � ��������
			in_iType	- ��� ������������������
					- true - LE
					- false - BE
    �� ������	:	���������� ��������� ��������, � ������ ������ ������� ���������� 0
*/
define_function integer fnSB_GetUNICODEString(StreamBuffer in_sbBuffer, widechar in_waBuffer[], integer in_iBufferPtr, integer in_iSize, char in_cType)
{
    local_var integer len, max, i

    // ��������� ������� ������������ ������
    max = TYPE_CAST(wc_max_length_string(in_waBuffer))
    
    // �������� ����������
    if(in_iBufferPtr == 0 || in_iSize == 0 || in_iBufferPtr > max)
	return 0

    // ���������� ������� ������������ ������
    len = max - (in_iBufferPtr - 1)
    
    // �������� ������� ������������ ������
    if(len == 0)
	return 0
    
    // �������� ����������� ��������� ������������� ������
    if(len > in_iSize)
	len = in_iSize
    
    // �������� ������� ������ � ������
    if(len > (fnSB_GetSize(in_sbBuffer)/2))
	len = fnSB_GetSize(in_sbBuffer)/2

    // ���������� ������
    if(in_cType)
    {
	for(i = 0; i < len; i++)
	    in_waBuffer[in_iBufferPtr + i] = TYPE_CAST(fnSB_GetIntLE(in_sbBuffer))
    } else
    {
	for(i = 0; i < len; i++)
	    in_waBuffer[in_iBufferPtr + i] = TYPE_CAST(fnSB_GetIntBE(in_sbBuffer))
    }

    // ��������� ������� ������
    wc_set_length_string(in_waBuffer, len)
    return len
}

/**
    ��������� ������� �������
    �� �����	:	in_sbBuffer 	- ��������� �� ������ ������
    �� ������	:	������� ��������� ������� � ������
*/
define_function integer fnSB_GetPosition(StreamBuffer in_sbBuffer)
{
    return in_sbBuffer._iPtr
}

/**
    ��������� ������� �������
    �� �����	:	in_sbBuffer 	- ��������� �� ������ ������
			in_iPosition 	- ����� �������
    �� ������	:	*
*/
define_function fnSB_SetPosition(StreamBuffer in_sbBuffer, integer in_iPosition)
{
    in_sbBuffer._iPtr = in_iPosition
}

/**
    ������� ������ �� ��� ��� ���� �� ���������� ������� ������
    �� �����	:	in_sbBuffer 	- ��������� �� ������ ������
			in_caOut	- ���� ����� ��������� ������
			in_cEnd		- ������ �� ����������� �������� ����� ���������� �������
    �� ������	:	true 	- ������ �������� 
			false 	- ������ �� ��������
*/
define_function char fnSB_GetStringWhile(StreamBuffer in_sbBuffer, char in_caOut[], char in_cEnd)
{
    local_var integer i, l

    // ��������� ������ ������
    l = fnSB_GetSize(in_sbBuffer)
    // ����������� ������
    for(i = 0; i < l; i++)
    {
	if(in_sbBuffer._caBuffer[in_sbBuffer._iPtr + i] != in_cEnd)
	{
	    in_caOut[i + 1] = in_sbBuffer._caBuffer[in_sbBuffer._iPtr + i]
	} else
	{
	    in_sbBuffer._iPtr = in_sbBuffer._iPtr + i + 1
	    // �������� ������ ������
	    set_length_array(in_caOut, i)
	    return true
	}
    }
    set_length_array(in_caOut, 0)
    return false
}
