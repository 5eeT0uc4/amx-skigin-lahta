PROGRAM_NAME='CodePage'

DEFINE_CONSTANT
MAX_OUT_STRING_LEN = 256	// Размер строки в символах, для UNI число букв будет определятся длинной деленной на 4

DEFINE_VARIABLE
// Таблица преобразования шеснадцатеричных символов
volatile char g_szHex[] = '0123456789ABCDEF';

// Таблица преобразования символов из cp 1251 в Unicode (не используются коды 98)
volatile integer g_aWIN_CP1251[128] =
{
   $0402, $0403, $201A, $0453, $201E, $2026, $2020, $2021, $20AC, $2030, $0409, $2039, $040A, $040C, $040B, $040F,
   $0452, $2018, $2019, $201C, $201D, $2022, $2013, $2014, $FFFF, $2122, $0459, $203A, $045A, $045C, $045B, $045F,
   $00A0, $040E, $045E, $0408, $00A4, $0490, $00A6, $00A7, $0401, $00A9, $0404, $00AB, $00AC, $00AD, $00AE, $0407,
   $00B0, $00B1, $0406, $0456, $0491, $00B5, $00B6, $00B7, $0451, $2116, $0454, $00BB, $0458, $0405, $0455, $0457,
   $0410, $0411, $0412, $0413, $0414, $0415, $0416, $0417, $0418, $0419, $041A, $041B, $041C, $041D, $041E, $041F,
   $0420, $0421, $0422, $0423, $0424, $0425, $0426, $0427, $0428, $0429, $042A, $042B, $042C, $042D, $042E, $042F,
   $0430, $0431, $0432, $0433, $0434, $0435, $0436, $0437, $0438, $0439, $043A, $043B, $043C, $043D, $043E, $043F,
   $0440, $0441, $0442, $0443, $0444, $0445, $0446, $0447, $0448, $0449, $044A, $044B, $044C, $044D, $044E, $044F
};

// Таблица преобразования символов из cp 1252 в Unicode (не используются коды 81,8d,8f,90,9d)
volatile integer g_aWIN_CP1252[128] =
{
   $20AC, $FFFF, $201A, $0192, $201E, $2026, $2020, $2021, $02C6, $2030, $0160, $2039, $0152, $FFFF, $017D, $FFFF,
   $FFFF, $2018, $2019, $201C, $201D, $2022, $2013, $2014, $02DC, $2122, $0161, $203A, $0153, $FFFF, $017E, $0178,
   $00A0, $00A1, $00A2, $00A3, $00A4, $00A5, $00A6, $00A7, $00A8, $00A9, $00AA, $00AB, $00AC, $00AD, $00AE, $00AF,
   $00B0, $00B1, $00B2, $00B3, $00B4, $00B5, $00B6, $00B7, $00B8, $00B9, $00BA, $00BB, $00BC, $00BD, $00BE, $00BF,
   $00C0, $00C1, $00C2, $00C3, $00C4, $00C5, $00C6, $00C7, $00C8, $00C9, $00CA, $00CB, $00CC, $00CD, $00CE, $00CF,
   $00D0, $00D1, $00D2, $00D3, $00D4, $00D5, $00D6, $00D7, $00D8, $00D9, $00DA, $00DB, $00DC, $00DD, $00DE, $00DF,
   $00E0, $00E1, $00E2, $00E3, $00E4, $00E5, $00E6, $00E7, $00E8, $00E9, $00EA, $00EB, $00EC, $00ED, $00EE, $00EF,
   $00F0, $00F1, $00F2, $00F3, $00F4, $00F5, $00F6, $00F7, $00F8, $00F9, $00FA, $00FB, $00FC, $00FD, $00FE, $00FF
};

/**
    Конвертирование cp1251 в UNI формат
    на входе	:	in_pszString   - указатель на стринг
    на выходе	:	указатель на сконвертированный стринг
*/
define_function char[MAX_OUT_STRING_LEN] ConvertCP1251ToUNI(char in_pszString[])
{
    local_var char l_pszUNI[MAX_OUT_STRING_LEN];
    local_var long l_iLen;
    local_var long l_iIn;
    local_var long l_iOut;
    local_var long l_iCh;
    
    l_iIn	= 1;
    l_iOut	= 1;
    l_iCh	= 0;
    l_iLen	= length_string(in_pszString);

    // Проверка длинны строки
    if(l_iLen > 0)
    {
	while(l_iIn <= l_iLen)
	{
	    l_iCh = g_aWIN_CP1251[in_pszString[l_iIn] - 127];
	    l_iIn++;
		
	    // проверка на выход за пределы строки
	    if((MAX_OUT_STRING_LEN - l_iOut) >= 4)
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

/**
    Конвертирование cp1252 в UNI формат
    на входе	:	in_pszString   - указатель на стринг
    на выходе	:	указатель на сконвертированный стринг
*/
define_function char[MAX_OUT_STRING_LEN] ConvertCP1252ToUNI(char in_pszString[])
{
    local_var char l_pszUNI[MAX_OUT_STRING_LEN];
    local_var long l_iLen;
    local_var long l_iIn;
    local_var long l_iOut;
    local_var long l_iCh;
    
    l_iIn	= 1;
    l_iOut	= 1;
    l_iCh	= 0;
    l_iLen	= length_string(in_pszString);

    // Проверка длинны строки
    if(l_iLen > 0)
    {
	while(l_iIn <= l_iLen)
	{
	    l_iCh = g_aWIN_CP1252[in_pszString[l_iIn] - 127];
	    l_iIn++;
		
	    // проверка на выход за пределы строки
	    if((MAX_OUT_STRING_LEN - l_iOut) >= 4)
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

/**
    Конвертирование из UTF8 в UNI представление
    на входе    :	in_pszUTF8	- указатель на стринг
    на выходе   :	указатель на сконвертированный стринг
*/
define_function char[MAX_OUT_STRING_LEN] ConvertUTF8ToUNI(char in_pszUTF8[])
{
    local_var char l_pszUNI[256];
    local_var long l_iLen;
    local_var long l_iIn;
    local_var long l_iOut;
    local_var long l_iCh;
    
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
	    if((MAX_OUT_STRING_LEN - l_iOut) >= 4)
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

/**
    Конвертирование из UTF8 в cp1251 представление
    на входе    :	in_pszUTF8	- указатель на стринг
    на выходе   :	указатель на сконвертированный стринг
*/
define_function char[MAX_OUT_STRING_LEN] ConvertUTF8ToCP1251(char in_pszUTF8[])
{
    local_var char l_pszUNI[256];
    local_var long l_iLen;
    local_var long l_iIn;
    local_var long l_iOut;
    local_var long l_iCh;
    
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
	    
	    if(l_iCh >= $410 && l_iCh <= $4ff)
		l_iCh = l_iCh - $350;
		
	    // проверка на выход за пределы строки
	    if((MAX_OUT_STRING_LEN - l_iOut) >= 1)
	    {
		// конвертирование символа
		l_pszUNI[l_iOut] = l_iCh;
		l_iOut = l_iOut + 1;
	    }
	}
	
	// установка длинны строки
	set_length_string(l_pszUNI, l_iOut - 1);
    }
    return l_pszUNI;
}
