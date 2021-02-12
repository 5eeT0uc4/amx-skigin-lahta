PROGRAM_NAME='htoi'
/**

1. ������� ������� ����������
22:43
2. ������� ������ ��������������
22:44
3. ������� ������ �������, ��������� ������, �� ���� ����� ��������� ��� ������ �������
22:44
����� ����� ����� ����������

*/
(***********************************************************)
(*               ����������� ����������                    *)
(***********************************************************)
DEFINE_VARIABLE

// ������ ��� �������������� �������� � 16 ������ �������������
volatile char m_cSym[16] = {'0','1','2','3','4','5','6','7','8','9','A','B','C','D','E','F'}

/**
    �������������� ������������������ �������� ������ � �������� �������������
    �� �����	:	in_cStr - ������ ��� ��������������
    �� ������	:	��������
    ����������	:	� ������ ���� ������ �� �������� �����, ���������
			���������� 0.
			������ ������� �������� � ����� � �����������
			������������� ������� HEXTOI ��� ���� ���������.
*/
define_function integer HTOI(char in_cStr[32])
{
    local_var integer len, index, value
    local_var char chr, start
    local_var char str[32]
  
    str = upper_string(in_cStr)
    len = length_string(str)
    
    index = 1
    value = 0
    start = 0
    
    while (index <= len)
    {
	chr = str[index]
	if((chr >= $30) and (chr <= $39))		// �������� �� 0 �� 9
	{
	    value = (value * $10) + (chr - $30)
	    start = 1
	} else if((chr >= $41) and (chr <= $46))	// �������� �� A �� F
	{
	    value = (value * $10) + (chr - $37)
	    start = 1
	} else if(start == 1) 				// ����� ���������� �����
	{
	    index = len
	}
	index++
    }
    return value
}

/**
   ������ � ������ ������������� ��������, �� ��������� �������� � �������
   �� ����� : in_cStr  - ������ � ������� ����� ��������
    ��������
  in_iIndex - �������� � ������ � �������� ��������
    ������
  in_cValue - �������� ��� ������
   �� ������ : *
*/
define_function HexByteToString(char in_cStr[], integer in_iIndex, char in_cVal)
{
   in_cStr[in_iIndex    ] = m_cSym[in_cVal >> 4 + 1]
   in_cStr[in_iIndex + 1] = m_cSym[in_cVal & $F + 1]
}
