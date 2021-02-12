/**
    Предназначение:
	Собраны наиболее часто используемые функции для работы со стрингами

    Автор:
	Гилязетдинов Марат (marat@ixbt.com, at_marat@list.ru)
    
    Версия: 1.1
    
    История:
	28.04.2008 - 1.1 Добавлена функция fnStr_IntegerToString
	15.04.2008 - 1.0 Первая реализация

    Присоединение к проекту:
	#include 'Strings.axi'
    
*/

PROGRAM_NAME='Strings'

(***********************************************************)
(*               Определение переменных                    *)
(***********************************************************)
DEFINE_VARIABLE

/**
    Получение набора параметров из строки
    на входе	:	in_caString	- указатель на строку откуда извлеч значения
			in_iaBuffer	- указатель на буфер куда нужно сложить значения
			in_caDel	- разделитель
    на выходе	:	количество параметров
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
    Выборка строки до тех пор пока не встретится искомый символ
    на входе	:	in_caIn		- входящий буфер
			in_caOut	- куда нужно поместить данные
			in_cEnd		- символ по обнаружению которого нужно прекратить выборку
    на выходе	:	true 	- строка выбрана
			false	- строка не найдена
*/

define_function char fnStr_GetStringWhile(char in_caIn[], char in_caOut[], char in_cEnd)
{
    local_var integer i
    
    // копирование данных
    for(i = 0; i < length_string(in_caIn); i++)
    {
	if(in_caIn[i + 1] != in_cEnd)
	{
	    in_caOut[i + 1] = in_caIn[i + 1]
	} else
	{
	    // выставим размер буфера
	    set_length_array(in_caOut, i)
	    return true
	}
    }
    // строка не найдена
    set_length_array(in_caOut, 0)
    return false
}

/**
    Перевод строки в нижний регистр
    на входе	:	in_caBuffer	- входящий буфер
    на выходе	:	*
    Примечание 	: работает только с английскими символами
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
    Перевод строки в вверхний регистр
    на входе	:	in_caBuffer	- входящий буфер
    на выходе	:	*
    Примечание 	: работает только с английскими символами
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
    Преобразование числа в стринг с фиксированным количеством символов
    на входе	:	in_cDigit	- количество символов в числе
			in_iValue	- значение для перевода
    на выходе	:	строка, в случае ошибки возвращается пустая
			строка.
    Примечание 	: в случае если число больше чем количество симаолов,
		  программа запишет только первый числа.
*/
define_function char[16] fnStr_IntegerToString(integer in_cDigit, integer in_iValue)
{
    local_var integer i, n, p, l
    local_var char caTemp[16]
    local_var char caNumber[6]
    
    // проверка на максимальный размер строки
    if(in_cDigit <= 16)
    {
	caNumber = itoa(in_iValue)
	
	// подготовка стринга
	for(i = 0; i < in_cDigit; i++)
	    caTemp[i + 1] = '0'
    
	set_length_string(caTemp, in_cDigit)
	
	// вычисление длинны числа в символах
	n = length_string(caNumber)
    
	// обработка переполнения
	if(n > in_cDigit)
	    l = in_cDigit
	else
	    l = n
	
	p = in_cDigit - l
    
	// переброска числа в стринг
	for(i = 0; i < l; i++)
	    caTemp[i + p + 1] = caNumber[i + 1]
    }
    return caTemp
}

/**
    Преобразование числа в стринг с фиксированным количеством символов
    на входе	:	in_cDigit	- количество символов в числе
			in_sValue	- значение для перевода
    на выходе	:	строка, в случае ошибки возвращается пустая
			строка.
    Примечание 	: в случае если число больше чем количество симаолов,
		  программа запишет только первый числа.
*/
define_function char[16] fnStr_SintegerToString(char in_cDigit, sinteger in_sValue)
{
    local_var char i, n, p, l
    local_var char caTemp[16]
    local_var char caNumber[16]
    local_var sinteger val
    
    val = in_sValue
    
    // проверка на максимальный размер строки
    if(in_cDigit <= 16)
    {
	// подготовка стринга
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
	
	// вычисление длинны числа в символах
	n = length_string(caNumber)
    
	// обработка переполнения
	if(n > in_cDigit)
	    l = in_cDigit
	else
	    l = n
	
	p = in_cDigit - l
    
	// переброска числа в стринг
	for(i = 0; i < l; i++)
	    caTemp[i + p + 2] = caNumber[i + 1]
    }
    return caTemp
}