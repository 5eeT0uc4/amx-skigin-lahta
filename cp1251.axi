PROGRAM_NAME='cp1251'

DEFINE_CONSTANT
long MAX_CODEC_STRING	= 384;	// Максимальная длинна кодируемого/декодируемого стринга

(***********************************************************)
(*               Определение переменных                    *)
(***********************************************************)
DEFINE_VARIABLE
char g_aHexTable[16] = { $30, $31, $32, $33, $34, $35, $36, $37, $38, $39, $41, $42, $43, $44, $45, $46 }

#if_not_defined g_szHex
    volatile char g_szHex[] = '0123456789ABCDEF';
#end_if

integer g_aWinCP1251[128] =
{
    $0402, $0403, $201A, $0453, $201E, $2026, $2020, $2021,
    $20AC, $2030, $0409, $2039, $040A, $040C, $040B, $040F,
    $0452, $2018, $2019, $201C, $201D, $2022, $2013, $2014,
    $FFFD, $2122, $0459, $203A, $045A, $045C, $045B, $045F,
    $00A0, $040E, $045E, $0408, $00A4, $0490, $00A6, $00A7,
    $0401, $00A9, $0404, $00AB, $00AC, $00AD, $00AE, $0407,
    $00B0, $00B1, $0406, $0456, $0491, $00B5, $00B6, $00B7,
    $0451, $2116, $0454, $00BB, $0458, $0405, $0455, $0457,
    $0410, $0411, $0412, $0413, $0414, $0415, $0416, $0417,
    $0418, $0419, $041A, $041B, $041C, $041D, $041E, $041F,
    $0420, $0421, $0422, $0423, $0424, $0425, $0426, $0427,
    $0428, $0429, $042A, $042B, $042C, $042D, $042E, $042F,
    $0430, $0431, $0432, $0433, $0434, $0435, $0436, $0437,
    $0438, $0439, $043A, $043B, $043C, $043D, $043E, $043F,
    $0440, $0441, $0442, $0443, $0444, $0445, $0446, $0447,
    $0448, $0449, $044A, $044B, $044C, $044D, $044E, $044F
};

/**
    Преобразование шестнадцатеричного значения строки в числовое представление
    на входе	:	in_caIn		- строка для преобразования
			out_caOut	- строка куда нужно поместить результат работы
    на выходе	:	*
    примечание	:	
*/
define_function char[MAX_CODEC_STRING] CP1251ToUNI(char in_caIn[])
{
    local_var integer i, len, cur, val
    char l_szNew[MAX_CODEC_STRING]
   
    len = length_string(in_caIn);
    cur	= 1
    
    for(i = 1; i <= len; i++)
    {
	val = in_caIn[i];
	if(in_caIn[i] >= 128)
	    val = g_aWinCP1251[in_caIn[i] - 127];
	    
	// Преобразование в UNI
	l_szNew[cur + 0] = g_aHexTable[((val >> 12) & $0F) + 1];
	l_szNew[cur + 1] = g_aHexTable[((val >> 8)  & $0F) + 1];
	l_szNew[cur + 2] = g_aHexTable[((val >> 4)  & $0F) + 1];
	l_szNew[cur + 3] = g_aHexTable[ (val        & $0F) + 1];
	cur = cur + 4;
    }
    set_length_string(l_szNew, cur - 1)
    return l_szNew;
}

/**
    Конвертирование из UTF8 в UNI представление
*/
define_function char[256] ConvertUTF8ToUNI(char in_pszUTF8[])
{
    char	l_pszUNI[256];
    stack_var long l_iLen;
    stack_var long l_iIn;
    stack_var long l_iOut;
    stack_var long l_iCh;
    
    l_iIn	= 1;
    l_iOut	= 1;
    l_iCh	= 0;
    l_iLen	= length_string(in_pszUTF8);

    // $E2 $92 $84
    if(l_iLen > 0)
    {
	while(l_iIn <= l_iLen)
	{
	    if((in_pszUTF8[l_iIn] & $80) == 0)
	    {
		// 0x00000000 — 0x0000007F: 0xxxxxxx
		l_iCh = in_pszUTF8[l_iIn]
		l_iIn++
	    
	    } else
	    {
		if((in_pszUTF8[l_iIn] & $E0) == $C0)
		{
		    // 0x00000080 — 0x000007FF: 110xxxxx 10xxxxxx
		    l_iCh = ((in_pszUTF8[l_iIn] & $1F) << 6) | (in_pszUTF8[l_iIn + 1] & $3F)
		    l_iIn = l_iIn + 2
		} else
		{
		    if((in_pszUTF8[l_iIn] & $F0) == $E0)
		    {
			// 0x00000800 — 0x0000FFFF: 1110xxxx 10xxxxxx 10xxxxxx
			l_iCh = (((in_pszUTF8[l_iIn] & $0F) << 12) | ((in_pszUTF8[l_iIn + 1] & $3F) << 6) | (in_pszUTF8[l_iIn + 2] & $3F));
			l_iIn = l_iIn + 3

		    } else
		    {
			if((in_pszUTF8[l_iIn] & $F8) == $F0)
			{
			    // 0x00010000 — 0x001FFFFF: 11110xxx 10xxxxxx 10xxxxxx 10xxxxxx
			    l_iCh = (((in_pszUTF8[l_iIn] & $0F) << 18) | ((in_pszUTF8[l_iIn + 1] & $3F) << 12) | ((in_pszUTF8[l_iIn + 2] & $3F) << 6) | (in_pszUTF8[l_iIn + 3] & $3F));
			    l_iIn = l_iIn + 4
			} else
			{
			    l_iIn++;
			}
		    }
		}
	    }
		
	    // проверка на выход за пределы строки
	    if((256 - l_iOut) >= 4)
	    {
		// конвертирование символа в UNI символ
		l_pszUNI[l_iOut + 0] = g_szHex[((l_iCh >> 12) & $F) + 1];
		l_pszUNI[l_iOut + 1] = g_szHex[((l_iCh >> 8) & $F) + 1];
		l_pszUNI[l_iOut + 2] = g_szHex[((l_iCh >> 4) & $F) + 1];
		l_pszUNI[l_iOut + 3] = g_szHex[(l_iCh & $F) + 1];
		
		l_iOut = l_iOut + 4;
	    }
	}
	
	// установка длинны строки
	set_length_string(l_pszUNI, l_iOut - 1);
    }
    return l_pszUNI;
}
