PROGRAM_NAME='URICoder'

DEFINE_CONSTANT

long MAX_CODEC_STRING	= 384;	// ћаксимальна€ длинна кодируемого/декодируемого стринга

(***********************************************************)
(*               ќпределение переменных                    *)
(***********************************************************)
DEFINE_VARIABLE

char g_aHexTable[16] = { $30, $31, $32, $33, $34, $35, $36, $37, $38, $39, $41, $42, $43, $44, $45, $46 }

define_function char IsHeximal(char in_cIn)
{
    if(	(in_cIn >= '0' && in_cIn <= '9') ||
	(in_cIn >= 'a' && in_cIn <= 'f') ||
	(in_cIn >= 'A' && in_cIn <= 'F'))
	return true;
	
    return false;
}
define_function char IsUnreceived(char in_cIn)
{
    if(	(in_cIn >= '0' && in_cIn <= '9') ||
	(in_cIn >= 'a' && in_cIn <= 'z') ||
	(in_cIn >= 'A' && in_cIn <= 'Z') ||
	in_cIn == '-' || in_cIn == '-' || in_cIn == '-' || in_cIn == '-')
	return true
	
    return false
}

/**
    ѕроверка кодируетс€ ли символ в соответствии с документом RFC 1738
    на входе	:	ch - провер€емый символ
    на выходе	:	TRUE - символ нужно кодировать
			FALSE - символ записываетс€ без кодировани€
			
   For rules on encoding a URL, see RFC 1738 (www.rfc-editor.org) or WWW site:
	http://www.blooberry.com/indexdot/html/topics/urlencoding.htm
*/
/*
define_function char isQuoteRequired(char ch)
{
    if (Find_String("'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-_.!*()'", "ch", 1) == 0)
	return TRUE;

    return FALSE;
}
*/
/**
    ѕреобразование шестнадцатеричного значени€ строки в числовое представление
    на входе	:	in_caIn		- строка дл€ преобразовани€
			out_caOut	- строка куда нужно поместить результат работы
    на выходе	:	*
    примечание	:	
*/
define_function char[MAX_CODEC_STRING] URICodec_Encode(char in_caIn[])
{
/*
    char str[MAX_CODEC_STRING], newStr[MAX_CODEC_STRING];
    char loop;

    set_length_array(newStr, 0);
    str = in_caIn;

    // Loop through string of possible bytes to reformat ...

    for (loop = 1; loop <= Length_String(str); loop++) {
	if (isQuoteRequired(str[loop]))
	    newStr = "newStr,'%',Format('%02X',str[loop])";
	else
	    newStr = "newStr,str[loop]";
    }

    return newStr;
*/
    local_var integer i, len, cur
    char l_szNew[MAX_CODEC_STRING]
   
    len = length_string(in_caIn);
    cur	= 1
    
    for(i = 1; i <= len; i++)
    {
	if(IsUnreceived(in_caIn[i]))
	{
	    l_szNew[cur] = in_caIn[i];
	    cur = cur + 1;
	} else
	{
	    l_szNew[cur + 0] = '%';
	    l_szNew[cur + 1] = g_aHexTable[(in_caIn[i] >> 4)	+ 1];
	    l_szNew[cur + 2] = g_aHexTable[(in_caIn[i] & $0F) + 1];
	    cur = cur + 3
	}
    }
    set_length_string(l_szNew, cur - 1)
    return l_szNew;
}

/**
    ѕреобразование шестнадцатеричного значени€ строки в числовое представление
    на входе	:	in_caIn		- строка дл€ преобразовани€
			out_caOut	- строка куда нужно поместить результат работы
    на выходе	:	*
    примечание	:	
*/
define_function char[MAX_CODEC_STRING] URICodec_Decode(char in_caIn[])
{
/*
    char str[MAX_CODEC_STRING], newStr[MAX_CODEC_STRING], strSegment[MAX_CODEC_STRING], strHex[2];

    set_length_array(newStr, 0);
    str = in_caIn;

    // Loop through string looking for '%' prefix characters
    strSegment = remove_string(str, '%', 1);
    while (length_array(strSegment) <> 0) {
	// Strip off '%' character from string segment, fetch HEX ASCII byte, reconstruct
	set_length_array(strSegment, length_array(strSegment) - 1);
	strHex = Left_String(str, 2);
	str = Right_String(str, length_array(str)-2);
	newStr = "newStr,strSegment,HexToI(strHex)";

	strSegment = remove_string(str, '%', 1);
    }
    
    newStr = "newStr,str";
    set_length_array(str, 0);
    return newStr;
*/

    local_var integer i, len, cur, run
    local_var char l_caStr[2]
    char l_szNew[MAX_CODEC_STRING]
   
    len = length_string(in_caIn);
    i	= 1
    cur	= 1
    run = 1
    
    set_length_string(l_caStr, 2)
		
    while(run && (i <= len))
    {
	if(in_caIn[i] == '%')
	{
	    if(IsHeximal(in_caIn[i + 1]) && IsHeximal(in_caIn[i + 2]))
	    {
		l_caStr[1] = in_caIn[i + 1];
		l_caStr[2] = in_caIn[i + 2];
		
		l_szNew[cur] = HEXTOI(l_caStr);
		i = i + 3;
	    } else
	    {
		run = false;
	    }
	    
	} else
	{
	    l_szNew[cur] = in_caIn[i];
	    i = i + 1;
	}
	cur = cur + 1;
    }
    set_length_string(l_szNew, cur - 1)
    return l_szNew;
}
