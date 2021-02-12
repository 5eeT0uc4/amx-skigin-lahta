/**
    ��������������:
	������� �������� ����� ������������ ������� ��� ������ �� ���������

    �����:
	������������ ����� (marat@ixbt.com, at_marat@list.ru)
    
    ������: 1.1
    
    �������:
	28.04.2008 - 1.1 ��������� ������� fnStr_IntegerToString
	15.04.2008 - 1.0 ������ ����������

    ������������� � �������:
	#include 'Strings.axi'
    
*/

PROGRAM_NAME='Strings'

(***********************************************************)
(*               ����������� ����������                    *)
(***********************************************************)
DEFINE_VARIABLE

/**
    ��������� ������ ���������� �� ������
    �� �����	:	in_caString	- ��������� �� ������ ������ ������ ��������
			in_iaBuffer	- ��������� �� ����� ���� ����� ������� ��������
			in_caDel	- �����������
    �� ������	:	���������� ����������
*/
define_function integer fnGetArray(char in_caString[], integer in_iaBuffer[], char in_caDel[])
{
    local_var integer l_iCount, i
    local_var char l_bRun
    
    l_iCount = 0
    l_bRun = 1
    
    while(l_bRun)
    {
	l_iCount++
	
	in_iaBuffer[l_iCount] = TYPE_CAST(atoi(in_caString))
	
	if(find_string(in_caString, in_caDel, 1) != 0)
	    remove_string(in_caString, in_caDel, 1)
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
    ������� ������ � �������� �������
    �� �����	:	in_caBuffer	- �������� �����
    �� ������	:	*
    ���������� 	: �������� ������ � ����������� ���������
*/
define_function fnStr_ToLower(char in_caBuffer[])
{
    local_var integer i
    local_var char v
    //
    for(i = 1; i <= length_string(in_caBuffer); i++)
    {
	v = in_caBuffer[i]
	if(v >= $41 and v <= $5A)
	{
	    v = v + $20
	    in_caBuffer[i] = v
	}
    }
}

/**
    �������������� ����� � ������ � ������������� ����������� ��������
    �� �����	:	in_cDigit	- ���������� �������� � �����
			in_iValue	- �������� ��� ��������
    �� ������	:	������, � ������ ������ ������������ ������
			������.
    ���������� 	: � ������ ���� ����� ������ ��� ���������� ��������,
		  ��������� ������� ������ ������ �����.
*/
define_function char[16] fnStr_IntegerToString(integer in_cDigit, integer in_iValue)
{
    local_var integer i, n, p, l
    local_var char caTemp[16]
    local_var char caNumber[6]
    
    // �������� �� ������������ ������ ������
    if(in_cDigit <= 16)
    {
	caNumber = itoa(in_iValue)
	
	// ���������� �������
	for(i = 0; i < in_cDigit; i++)
	    caTemp[i + 1] = '0'
    
	set_length_string(caTemp, in_cDigit)
	
	// ���������� ������ ����� � ��������
	n = length_string(caNumber)
    
	// ��������� ������������
	if(n > in_cDigit)
	    l = in_cDigit
	else
	    l = n
	
	p = in_cDigit - l
    
	// ���������� ����� � ������
	for(i = 0; i < l; i++)
	    caTemp[i + p + 1] = caNumber[i + 1]
    }
    return caTemp
}

/**
    �������������� ����� � ������ � ������������� ����������� ��������
    �� �����	:	in_cDigit	- ���������� �������� � �����
			in_sValue	- �������� ��� ��������
    �� ������	:	������, � ������ ������ ������������ ������
			������.
    ���������� 	: � ������ ���� ����� ������ ��� ���������� ��������,
		  ��������� ������� ������ ������ �����.
*/
define_function char[16] fnStr_SintegerToString(char in_cDigit, sinteger in_sValue)
{
    local_var char i, n, p, l
    local_var char caTemp[16]
    local_var char caNumber[16]
    local_var sinteger val
    
    val = in_sValue
    
    // �������� �� ������������ ������ ������
    if(in_cDigit <= 16)
    {
	// ���������� �������
	for(i = 0; i <= in_cDigit; i++)
	    caTemp[i + 1] = '0'
	    
	set_length_string(caTemp, in_cDigit + 1)
	    
	if(val < 0)
	{
	    caTemp[1] = '-'
	    val = -val
	} else
	{
	    caTemp[1] = '+'
	}
	
	caNumber = itoa(val)
	
	// ���������� ������ ����� � ��������
	n = length_string(caNumber)
    
	// ��������� ������������
	if(n > in_cDigit)
	    l = in_cDigit
	else
	    l = n
	
	p = in_cDigit - l
    
	// ���������� ����� � ������
	for(i = 0; i < l; i++)
	    caTemp[i + p + 2] = caNumber[i + 1]
    }
    return caTemp
}