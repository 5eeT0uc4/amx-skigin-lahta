/**
    Предназначение:
	Реализация потокового буфера. Написано специально для обработки
	входящих данных.

    Автор:
	Гилязетдинов Марат (marat@ixbt.com, at_marat@list.ru)
    
    Версия: 1.0d
    
    История:
	15.04.2008 - 1.0d Исправлена ошибка сдвига буфера
	14.04.2008 - 1.0c Добавлена функция fnSB_GetStringWhile
	10.04.2008 - 1.0b Исправлена ошибка дополнения данных
		   - Удалено поле _iLen в связи с рассинхронизацией данных
	09.04.2008 - 1.0a добавлены методы fnSB_GetString, fnSB_GetUNICODEString, fnSB_GetPosition, fnSB_SetPosition
	17.03.2008 - 1.0  первая реализация

    Присоединение к проекту:
	#include 'StreamBuffer'
    
*/
PROGRAM_NAME='StreamBuffer'

// файлы включения
#INCLUDE 'UnicodeLib.axi'

DEFINE_TYPE

// Структура с описанием буфера
structure StreamBuffer
{
    char 	_caBuffer[8192]	// буфер с данными
    integer	_iPtr		// текущий индекс данных
}

/**
    Инициализация буфера
    на входе	:	in_sbBuffer 	- указатель на данные буфера
			in_iIndex	- данные буфера при инициализации
    на выходе	:	*
*/
define_function fnSB_Init(StreamBuffer in_sbBuffer, char in_caBuffee[])
{
    in_sbBuffer._caBuffer	= in_caBuffee
    in_sbBuffer._iPtr		= 1
}

/**
    Сброс, очистка буфера
    на входе	:	in_sbBuffer 	- указатель на данные буфера
    на выходе	:	*
*/
define_function fnSB_Reset(StreamBuffer in_sbBuffer)
{
    in_sbBuffer._iPtr	= 1
    set_length_string(in_sbBuffer._caBuffer, 0)
}

/**
    Получение символа (байта) из потока
    на входе	:	in_sbBuffer 	- указатель на данные буфера
    на выходе	:	полученое значение 
*/
define_function char fnSB_GetChar(StreamBuffer in_sbBuffer)
{
    local_var char val
    val = in_sbBuffer._caBuffer[in_sbBuffer._iPtr]
    in_sbBuffer._iPtr++
    return val
}

/**
    Получение числа (два байта) из потока остроконечный вариант записи (x86 вариант)
    на входе	:	in_sbBuffer 	- указатель на данные буфера
    на выходе	:	полученое значение
*/
define_function integer fnSB_GetIntLE(StreamBuffer in_sbBuffer)
{
    local_var integer val
    val = TYPE_CAST(in_sbBuffer._caBuffer[in_sbBuffer._iPtr + 1] << 8 | in_sbBuffer._caBuffer[in_sbBuffer._iPtr])
    in_sbBuffer._iPtr = in_sbBuffer._iPtr + 2
    return val
}

/**
    Получение числа (два байта) из потока тупоконечный вариант записи (сетевой вариант)
    на входе	:	in_sbBuffer 	- указатель на данные буфера
    на выходе	:	полученое значение
*/
define_function integer fnSB_GetIntBE(StreamBuffer in_sbBuffer)
{
    local_var integer val
    val = TYPE_CAST(in_sbBuffer._caBuffer[in_sbBuffer._iPtr] << 8 | in_sbBuffer._caBuffer[in_sbBuffer._iPtr + 1])
    in_sbBuffer._iPtr = in_sbBuffer._iPtr + 2
    return val
}

/**
    Получение количества символов (байт) в буфере
    на входе	:	in_sbBuffer 	- указатель на данные буфера
    на выходе	:	количество символов (байт) в буфере
*/
define_function integer fnSB_GetSize(StreamBuffer in_sbBuffer)
{
    return length_string(in_sbBuffer._caBuffer) - (in_sbBuffer._iPtr - 1)
}

/**
    Пропуск указанного количества символов (байт)
    на входе	:	in_sbBuffer 	- указатель на данные буфера
			in_iSkip	- количество пропускаемых символов
    на выходе	:	*
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
    Сдвиг буфера на указаное количество символов
    на входе	:	in_sbBuffer 	- указатель на данные буфера
			in_iSkip	- количество символов на которое нужно
					сдвинуть буфер
    на выходе	:	*
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
    Сдвиг на количество пропущеных байт
    на входе	:	in_sbBuffer 	- указатель на данные буфера
    на выходе	:	*
*/
define_function fnSB_Shift(StreamBuffer in_sbBuffer)
{
    fnSB_ShiftBytes(in_sbBuffer, in_sbBuffer._iPtr - 1)
}

/**
    Добавление данных в буфер
    на входе	:	in_sbBuffer 	- указатель на данные буфера
			in_caBuffer	- указатель на добавляемые данные
    на выходе	:	true 	- данные добавлены
			false 	- данные не помещаются
*/
define_function char fnSB_Add(StreamBuffer in_sbBuffer, char in_caBuffer[])
{
    local_var integer append_size, dest_size, free_size, i
    
    // вычисление размера текущих и входящих данных
    append_size = length_string(in_caBuffer)
    dest_size = length_string(in_sbBuffer._caBuffer)
    
    // количество свободных данных
    free_size = max_length_string(in_sbBuffer._caBuffer) - dest_size
    
    // проверка возможности добавления
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
    Поиск последовательности в буфере
    на входе	:	in_sbBuffer 	- указатель на данные буфера
			in_caSeq	- указатель на искомую последовательность
			in_cSeek	- флаг сдвига в случае обнаружения
					true - в случае обнаружения последовательности
					позиция в буфере будет указывать на начало стринга
					false - позиция останется без изменения
    на выходе	:	true 	- искомая последовательность найдена
			false 	- последовательность не найдена
*/
define_function char fnSB_Find(StreamBuffer in_sbBuffer, char in_caSeq[], char in_cSeek)
{
    local_var integer p, l
    p = find_string(in_sbBuffer._caBuffer, in_caSeq, in_sbBuffer._iPtr)
    if(p != 0)
    {
	// проверка наличия флага сдвига
	if(in_cSeek)
	{
	    // сдвиг буфера
	    l = p - in_sbBuffer._iPtr
	    in_sbBuffer._iPtr = in_sbBuffer._iPtr + l
	}
	return true
    }
    return false
}

/**
    Получение стринга заданой длинны из буфера
    на входе	:	in_sbBuffer 	- указатель на данные буфера
			in_caBuffer	- указатель на принимающий буфер
			in_iBufferPtr	- индекс с которого нужно заполнять буфер 
			in_iSize	- количество получаемых данных в символах
    на выходе	:	количество полученых символов, в случае ошибки функция возвращает 0
*/
define_function integer fnSB_GetString(StreamBuffer in_sbBuffer, char in_caBuffer[], integer in_iBufferPtr, integer in_iSize)
{
    local_var integer len, max, i

    // получение ращмера принимающего буфера
    max = max_length_string(in_caBuffer)
    
    // проверка параметров
    if(in_iBufferPtr == 0 || in_iSize == 0 || in_iBufferPtr > max)
	return 0

    // вычисление размера принимающего буфера
    len = max - (in_iBufferPtr - 1)
    
    // проверка размера принимающего буфера
    if(len == 0)
	return 0
    
    // проверка возможности помещения запрашиваемых данных
    if(len > in_iSize)
	len = in_iSize
    
    // проверка наличия данных в буфере
    if(len > fnSB_GetSize(in_sbBuffer))
	len = fnSB_GetSize(in_sbBuffer)

    // переброска данных
    for(i = 0; i < len; i++)
	in_caBuffer[in_iBufferPtr + i] = in_sbBuffer._caBuffer[in_sbBuffer._iPtr + i]

    // изменение параметров буфера
    in_sbBuffer._iPtr = in_sbBuffer._iPtr + len
    
    // установка размера буфера
    set_length_string(in_caBuffer, len)
    return len
}

/**
    Получение Unicode стринга заданой длинны из буфера
    на входе	:	in_sbBuffer 	- указатель на данные буфера
			in_waBuffer	- указатель на принимающий буфер
			in_iBufferPtr	- индекс с которого нужно заполнять буфер 
			in_iSize	- количество получаемых данных в символах
			in_iType	- тип последовательности
					- true - LE
					- false - BE
    на выходе	:	количество полученых символов, в случае ошибки функция возвращает 0
*/
define_function integer fnSB_GetUNICODEString(StreamBuffer in_sbBuffer, widechar in_waBuffer[], integer in_iBufferPtr, integer in_iSize, char in_cType)
{
    local_var integer len, max, i

    // получение ращмера принимающего буфера
    max = TYPE_CAST(wc_max_length_string(in_waBuffer))
    
    // проверка параметров
    if(in_iBufferPtr == 0 || in_iSize == 0 || in_iBufferPtr > max)
	return 0

    // вычисление размера принимающего буфера
    len = max - (in_iBufferPtr - 1)
    
    // проверка размера принимающего буфера
    if(len == 0)
	return 0
    
    // проверка возможности помещения запрашиваемых данных
    if(len > in_iSize)
	len = in_iSize
    
    // проверка наличия данных в буфере
    if(len > (fnSB_GetSize(in_sbBuffer)/2))
	len = fnSB_GetSize(in_sbBuffer)/2

    // переброска данных
    if(in_cType)
    {
	for(i = 0; i < len; i++)
	    in_waBuffer[in_iBufferPtr + i] = TYPE_CAST(fnSB_GetIntLE(in_sbBuffer))
    } else
    {
	for(i = 0; i < len; i++)
	    in_waBuffer[in_iBufferPtr + i] = TYPE_CAST(fnSB_GetIntBE(in_sbBuffer))
    }

    // установка размера буфера
    wc_set_length_string(in_waBuffer, len)
    return len
}

/**
    Получение текущей позиции
    на входе	:	in_sbBuffer 	- указатель на данные буфера
    на выходе	:	текущее положение индекса в буфере
*/
define_function integer fnSB_GetPosition(StreamBuffer in_sbBuffer)
{
    return in_sbBuffer._iPtr
}

/**
    Установка текущей позиции
    на входе	:	in_sbBuffer 	- указатель на данные буфера
			in_iPosition 	- новая позиция
    на выходе	:	*
*/
define_function fnSB_SetPosition(StreamBuffer in_sbBuffer, integer in_iPosition)
{
    in_sbBuffer._iPtr = in_iPosition
}

/**
    Выборка строки до тех пор пока не встретится искомый символ
    на входе	:	in_sbBuffer 	- указатель на данные буфера
			in_caOut	- куда нужно поместить данные
			in_cEnd		- символ по обнаружению которого нужно прекратить выборку
    на выходе	:	true 	- данные получены 
			false 	- данные не получены
*/
define_function char fnSB_GetStringWhile(StreamBuffer in_sbBuffer, char in_caOut[], char in_cEnd)
{
    local_var integer i, l

    // получение длинны буфера
    l = fnSB_GetSize(in_sbBuffer)
    // копирование данных
    for(i = 0; i < l; i++)
    {
	if(in_sbBuffer._caBuffer[in_sbBuffer._iPtr + i] != in_cEnd)
	{
	    in_caOut[i + 1] = in_sbBuffer._caBuffer[in_sbBuffer._iPtr + i]
	} else
	{
	    in_sbBuffer._iPtr = in_sbBuffer._iPtr + i + 1
	    // выставим размер буфера
	    set_length_array(in_caOut, i)
	    return true
	}
    }
    set_length_array(in_caOut, 0)
    return false
}
