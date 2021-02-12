PROGRAM_NAME='ConvertUTF8'

DEFINE_CONSTANT

DEFINE_VARIABLE

#if_not_defined g_szHex
    volatile char g_szHex[] = '0123456789ABCDEF';
#end_if

define_function char[256] ConvertUTF8ToUNI(char in_pszUTF8[])
{
    local_var char	l_pszUNI[256];
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

/**
    Конвертирование из UTF8 в CP1251 представление
*/
define_function char[256] ConvertUTF8ToCP1251(char in_pszUTF8[])
{
    local_var char	l_pszUNI[256];
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
	    if((256 - l_iOut) >= 1)
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