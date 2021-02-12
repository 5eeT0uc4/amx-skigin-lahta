PROGRAM_NAME='htoi'
/**

1. »зучить систему исчислени€
22:43
2. »зучить методы преобразовани€
22:44
3. »зучить Ѕулеву алгебру, начальные знани€, то есть карты истиности дл€ каждой опрации
22:44
думаю этого будет достаточно

*/
(***********************************************************)
(*               ќпределение переменных                    *)
(***********************************************************)
DEFINE_VARIABLE

// ћассив дл€ преобразовани€ полубайт в 16 ричное представление
volatile char m_cSym[16] = {'0','1','2','3','4','5','6','7','8','9','A','B','C','D','E','F'}

/**
    ѕреобразование шестнадцатеричного значени€ строки в числовое представление
    на входе	:	in_cStr - строка дл€ преобразовани€
    на выходе	:	значение
    примечание	:	в случае если строка не содержит числа, программа
			возвращает 0.
			ƒанна€ функци€ написана в св€зи с неудобством
			использовани€ функции HEXTOI дл€ нужд программы.
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
	if((chr >= $30) and (chr <= $39))		// диапозон от 0 до 9
	{
	    value = (value * $10) + (chr - $30)
	    start = 1
	} else if((chr >= $41) and (chr <= $46))	// диапозон от A до F
	{
	    value = (value * $10) + (chr - $37)
	    start = 1
	} else if(start == 1) 				// конец извлечени€ числа
	{
	    index = len
	}
	index++
    }
    return value
}

/**
   «апись в стринг однобайтового значени€, по указаному смещению в стринге
   на входе : in_cStr  - строка в которую нажно записать
    значение
  in_iIndex - смещение в строке с которого начинать
    запись
  in_cValue - значение дл€ записи
   на выходе : *
*/
define_function HexByteToString(char in_cStr[], integer in_iIndex, char in_cVal)
{
   in_cStr[in_iIndex    ] = m_cSym[in_cVal >> 4 + 1]
   in_cStr[in_iIndex + 1] = m_cSym[in_cVal & $F + 1]
}
