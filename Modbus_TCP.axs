/**
    Предназначение:
	Реализация связи с контролером DigiHouse (физический протокол Modbus TCP)

    Авторы:
	Гилязетдинов Марат (marat@ixbt.com, at_marat@list.ru)
	Рыжков Дмитрий
    
    Версия: 1.6
    
    История:
	28.11.2011 - 1.6 Добавлены методы SET_DIMMER, SET_RELAY, SET_THERMOSTATE
	07.05.2011 - 1.5 Переработаны методы записи/чтения данных SET_CS, GET_CS, GET_IS, SET_HR,
		     GET_HR, GET_IR, START, STOP
	03.06.2008 - 1.4 Доработано: при отсутствии соединения любоедействие возвращает DISCONECT
	22.05.2008 - 1.3 Добавлены команды GET_U16, SET_U16 изменена размерность входящего
		     буфера теперь буфер данных имеет размерность integer
	10.05.2008 - 1.2 Модифицирован протокол теперь в конце операции нужно указывать ';'
	05.05.2008 - 1.1 Исправлена ошибка сдвига буфера, обратну вернул механизм
		    добавления данных в буфер
	16.04.2008 - Методы printf вынесены во включение Debug.axi
	11.04.2008 - Исправлен механизм добавления данных, вместо fnSB_Add,
		     используется CREATE_BUFFER.
	09.04.2008 - Исправлены неточносим в документации
	08.04.2008 - Исправлена ошибка при получении нескольких блоков данных
	20.03.2008 - Первая реализация

    Архитектура и взаимодействие:
	Взаимодействие осуществляется за счет виртуального порта, номер 
	которого задается программистом. Виртуальный порт в свою очередь
	является маршрутиризатором для физичесткого порта. В задачи
	виртуального порта входит контроль за областью допустимых значений
	а так же трансляция команд. Собственно порт занимается всем
	отправкой получением даннных, формированием пакетов, сборкой пакетов,
	выделением данных. Слежением за целостностью передачи.
	Поддержанием соединения.
	
    Присоединение к проекту:
	1. Присоеденить файл DigiHouse_Lighting_Comm.axs в проект.
	2. Определить номера виртуального и физического порта, а так же хост и порт
	   Modbus TCP устройства например так:
	   PHIS_PORT = 0:3:0
	   VIRT_PORT = 33010:1:1
	   
	   char g_caHost[] = "192.168.0.1"
	   integer g_iPort = 502
	    
	3. В основном, рутовом файле сделать подключение модуля
	   DEFINE_MODULE 'DigiHouse_Lighting_Comm' modName(VIRT_PORT, PHIS_PORT, m_caHost, m_iPort)
	   
	4. Организовать обратнуя связь
	   DATA_EVENT[VIRT_PORT]
	   {
	        // получение стринга с ответом
		STRING:
		{
		    // Отладочная информация
		    #IF_DEFINED __DEBUG__
			printf("'virtual device string =', data.text")
		    #END_IF
		}
	   }
	
	5. Запустить модуль
	    send_command VIRT_PORT, "'START;'"
	    
	6. Организовать передачу например
	    send_command VIRT_PORT, "'GET_HR 1, 0, 10;'"	// получения 10 16 битных регистров из области 0
	    send_command VIRT_PORT, "'SET_HR 1, 0, 1, 2, 3;'"	// запись 3 16 битных значений  начиная с 0 адреса значениями 1,2,3

	7. В случае необходимости остановить работу модуля
	    send_command VIRT_PORT, "'STOP;'"
    
    Описание команд виртуального порта:
	GET_CS NN, ADDR, COUNT;	Получение значений дискретных выходов
	На входе:
	    NN		- Номер устройства (в десятичном формате) для большинства устройств
			номер устройства может быть любым, сделано для совместимости с Modbus TCP
	    ADDR	- Адрес откуда надо причитать данные (в десятичном формате)
	    COUNT	- Количество читаемых данных (в десятичном формате)
	На выходе:

	GET_IS NN, ADDR, COUNT;	Получение значений дискретных входов
	На входе:
	    NN		- Номер устройства (в десятичном формате) для большинства устройств
			номер устройства может быть любым, сделано для совместимости с Modbus TCP
	    ADDR	- Адрес откуда надо причитать данные (в десятичном формате)
	    COUNT	- Количество читаемых данных (в десятичном формате)
	На выходе:
    
	SET_CS NN, ADDR, V1, ..., Vn;	Установка значений дискретных выходов
	На входе:
	    NN		- Номер устройства (в шеснадцетеричном формате) по сути своей
			номер устройства может быть любым, сделано для совместимости с Modbus TCP
	    ADDR	- Адрес куда надо записать данные
	    V1, ..., Vn	- Список значений через запятую
	На выходе:
	
	GET_HR NN, ADDR, COUNT;	Получение значений выходных регистров
	На входе:
	    NN		- Номер устройства (в десятичном формате) для большинства устройств
			номер устройства может быть любым, сделано для совместимости с Modbus TCP
	    ADDR	- Адрес откуда надо причитать данные (в десятичном формате)
	    COUNT	- Количество читаемых данных (в десятичном формате)
	На выходе:
	
	GET_IR NN, ADDR, COUNT;	Получение значений входных регистров
	На входе:
	    NN		- Номер устройства (в десятичном формате) для большинства устройств
			номер устройства может быть любым, сделано для совместимости с Modbus TCP
	    ADDR	- Адрес откуда надо причитать данные (в десятичном формате)
	    COUNT	- Количество читаемых данных (в десятичном формате)
	На выходе:

	SET_HR NN, ADDR, V1, ..., Vn;	Установка значений выходных регистров
	На входе:
	    NN		- Номер устройства (в шеснадцетеричном формате) по сути своей
			номер устройства может быть любым, сделано для совместимости с Modbus TCP
	    ADDR	- Адрес куда надо записать данные
	    V1, ..., Vn	- Список значений через запятую
	На выходе:
	
	START;	Запуск модуля
	На входе:
	На выходе:
	
	STOP;	Остановка модуля
	На входе:
	На выходе:
*/	

MODULE_NAME='Modbus_TCP' (dev vdvDevice,
					dev dvPhysicalDevice,
					char caHost[])

//#include 'Debug.axi'		// в случае если отладка не нужна включение коментируется
#include 'htoi.axi'		// работа со стрингами
//#include 'Strings.axi'		// работа со стрингами
#include 'StreamBuffer.axi'	// потоковый буфер

//#DEFINE _DEBUG_FLAG
(***********************************************************)
(*          DEVICE NUMBER DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_DEVICE

(***********************************************************)
(*               CONSTANT DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_CONSTANT
/*
#IF_NOT_DEFINED _DEBUG_FLAG
_DEBUG_FLAG = 1
#END_IF
*/
// идентификаторы потоков
TL_PING_ID				= $A0	// идентификатор потока пинга
TL_WORK_ID				= $A1

// идентификаторы операций
OPERATION_PING				= 0	// запрос пинга
OPERATION_READ_COIL_STATUS		= 1	// чтение состояния дискретного выхода
OPERATION_READ_INPUT_STATUS		= 2	// чтение состояния дискретного входа
OPERATION_READ_HOLDING_REGISTER		= 3	// чтение состояния выходного 16 битного регистра
OPERATION_READ_INPUT_REGISTER		= 4	// чтение состояния входного 16 битного регистра
OPERATION_WRITE_COIL_STATUS		= 5	// чтение состояния дискретного выхода
OPERATION_WRITE_HOLDING_REGISTER	= 6	// чтение состояния выходного 16 битного регистра
OPERATION_WRITE_COIL_STATUS_ARRAY	= 7	// чтение состояния дискретного выхода
OPERATION_WRITE_HOLDING_REGISTER_ARRAY	= 8	// чтение состояния выходного 16 битного регистра

// коды Modbus операций
MODBUS_READ_COIL_STATUS			= 1	// чтение состояния дискретного выхода
MODBUS_READ_INPUT_STATUS		= 2	// чтение состояния дискретного входа
MODBUS_READ_HOLDING_REGISTER		= 3	// чтение состояния выходного 16 битного регистра
MODBUS_READ_INPUT_REGISTER		= 4	// чтение состояния входного 16 битного регистра
MODBUS_WRITE_COIL_STATUS		= 5	// чтение состояния дискретного выхода
MODBUS_WRITE_HOLDING_REGISTER		= 6	// чтение состояния выходного 16 битного регистра
MODBUS_WRITE_COIL_STATUS_ARRAY		= 15	// чтение состояния дискретного выхода
MODBUS_WRITE_HOLDING_REGISTER_ARRAY	= 16	// чтение состояния выходного 16 битного регистра

(***********************************************************)
(*              DATA TYPE DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_TYPE

(***********************************************************)
(*               VARIABLE DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_VARIABLE

volatile long 		iPort = 502
volatile integer	outTempp = 0
volatile integer 	m_iCurTID	= 0	// текущий идентификатр транзакции
volatile long 		m_laPing[1]	= 500	// промежуток времени через который производится пинг
volatile long 		m_laWork[1]	= 5000	// промежуток времени через который производится обработка состояние соединения

volatile StreamBuffer 	m_sbInputBuffer		// промежуточный входящий буфер

volatile char		m_cIsConnect	= 0	// флаг соединения

// массивы для хранения текущего состояния переменных
volatile integer	m_iaStatuses[10]
volatile integer	m_iaOldStatuses[10]
volatile char		m_caInputCoil[256]
volatile char		m_caCoilStatus[256]
volatile integer	m_iaHoldingRegisters[512]
volatile integer	m_iaOldHoldingRegisters[512]
volatile integer	m_iaInputRegisters[512]
volatile integer	m_iaOldInputRegisters[512]

volatile long		m_lCurTime	= 0
volatile long		m_lLastPingTime	= 0
volatile long		m_lStartWaitTime= 0

(***********************************************************)
(*               LATCHING DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_LATCHING

(***********************************************************)
(*       MUTUALLY EXCLUSIVE DEFINITIONS GO BELOW           *)
(***********************************************************)
DEFINE_MUTUALLY_EXCLUSIVE

define_function printf(char text[]){
    send_string 0, "'Modbus Debug: ', text"
}

/**
    Получение идентификатора транзакции
    на входе	:	in_cOperation	- код выполняемой операции
    на выходе	:	идентификатор
    примечание	: 	функция реализована для того чтобы исключить появление
			0 значения
*/
define_function integer fnGetTID(char in_cOperation)
{
    m_iCurTID++
    m_iCurTID = m_iCurTID & $3FF
    if(m_iCurTID == 0)
	m_iCurTID++

    // подмешаем тип операции
    return m_iCurTID | TYPE_CAST(in_cOperation << 10)
}

/**
    Получение типа операции по идентификатору транзакции
    на входе	:	in_iTID	- идентификатор транзакции
    на выходе	:	тип операции
*/
define_function char fnGetOperation(integer in_iTID)
{
    return TYPE_CAST(in_iTID >> 10)
}

/**
    Проверка номера устройства и адреса
    на входе	:	in_iDevice	- номер устройства
			in_iAddress	- адрес
    на выходе	:	0 - недопустимые данные
			1 - данные допустимы
*/
define_function char fnTestParameters(integer in_iDevice, integer in_iAddress)
{
    local_var char l_cResult
    
    l_cResult = 0
    
    if(in_iDevice < 255 && in_iAddress < 65535)
	l_cResult = 1
	
    return l_cResult
}

/**
    Получение набора параметров из строки
    на входе	:	in_caString	- указатель на строку откуда извлеч значения
			in_iaBuffer	- указатель на буфер куда нужно сложить значения
    на выходе	:	количество параметров
*/

define_function integer fnGetArray(char in_caString[], integer in_iaBuffer[])
{
    local_var integer l_iCount, i
    local_var char l_bRun
    
    l_iCount = 0
    l_bRun = 1
    
    while(l_bRun)
    {
	// отладочная информация
	#IF_DEFINED _DEBUG_FLAG
	    send_string 0, in_caString
	#END_IF
	
	l_iCount++
	
	in_iaBuffer[l_iCount] = TYPE_CAST(atoi(in_caString))
	
	if(find_string(in_caString, ',', 1) != 0)
	    remove_string(in_caString, ',', 1)
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
    Подсоединение
    на входе	:	in_dvDevice - устройство
			in_cIPAddr  - IP адрес устройства к которому нужно присоеденится
			in_iPort    - порт к которому нужно присоеденится
    на выходе	:	*
*/
define_function fnOnConnect(dev in_dvDevice, char in_cIPAddr[], integer in_iPort)
{
    ip_client_open(in_dvDevice.port, in_cIPAddr, in_iPort, 1);
}

/**
    Отсоединение
    на входе	:	in_dvDevice - устройство
    на выходе	:	*
*/
define_function fnOnDisconnect(dev in_dvDevice)
{
    if(m_cIsConnect == 1)
    {
	ip_client_close(in_dvDevice.port)
	m_cIsConnect = 0;
    }
}

/**
    Инициализация устройства
    на входе	:	*
    на выходе	:	*
*/
define_function fnOnInit()
{
    local_var integer i
    
    m_lLastPingTime 	= m_lCurTime;
    m_lStartWaitTime	= m_lCurTime;
	
    // создание таймера для поддержания соединения
    timeline_create(TL_PING_ID, m_laPing, 1, TIMELINE_ABSOLUTE, TIMELINE_REPEAT)	
}

/**
    Сброс параметров
    на входе	:	*
    на выходе	:	*
*/
define_function fnOnReset()
{
    local_var integer i
        
}

/**
    Деинициализация устройства
    на входе	:	*
    на выходе	:	*
*/
define_function fnOnDeInit()
{
    // остановка таймеров
    if(timeline_active(TL_PING_ID))
	timeline_kill(TL_PING_ID);
    
    m_lLastPingTime 	= m_lCurTime;
    m_lStartWaitTime	= m_lCurTime;
}

/**
    Пинг
    на входе	:	*
    на выходе	:	*
    примечание	: 	данная функция пердназначена для поддержания соединения
*/
define_function fnOnPing()
{
    local_var char packet[32]
    local_var integer ID
    
    if(m_cIsConnect == 1)
    {
	send_command vdvDevice, "'GET_HR 1,130,1;'"
	/*
	// получение идентификатора
	ID = fnGetTID(OPERATION_PING)
	
	packet[01] = TYPE_CAST(ID >> 8)				// TID
	packet[02] = TYPE_CAST(ID & $FF)
	packet[03] = 0						// PID всегда ноль
	packet[04] = 0
	
	packet[05] = 0						// Длинна пакета
	packet[06] = 6
	packet[07] = 0						// идентификатор устройсва (зарезервированый идентификатор)
	packet[08] = MODBUS_READ_HOLDING_REGISTER		// тип операции
	packet[09] = 1						// 130
	packet[10] = $82
	packet[11] = 0						// количество 4 16-и битных регистра
	packet[12] = 1
	
	// установка длинны пакета
	set_length_string(packet, 12)

	// отправка на устройство
	send_string dvPhysicalDevice, packet
	*/
    }
}

/**
    Поиск изменений в стуатусах и запрос изменившихся данных
    на входе	:	*
    на выходе	:	*
*/
define_function fnOnFindingChanges()
{
    // проверка изменения
    if(m_iaStatuses[4] != m_iaOldStatuses[4])
    {
	m_iaOldStatuses[4] = m_iaStatuses[4];
	/*
	// чтение всех четырех блоков
	fnOnSendReadInputRegisterBlock(0, 0);
	fnOnSendReadInputRegisterBlock(0, 1);
	fnOnSendReadInputRegisterBlock(0, 2);
	fnOnSendReadInputRegisterBlock(0, 3);
	fnOnSendReadInputRegisterBlock(0, 4);
	fnOnSendReadInputRegisterBlock(0, 5);
	*/
    }
}

/**
    Отправка запроса на получение значений дискретных выходов
    на входе	:	in_cDevice	- идентификатор устройства для которого
					нужно отправлять данные
			in_iAddr	- адрес
			in_iCount	- количество
    на выходе	:	*
*/
define_function fnOnSendReadCoilStatus(char in_cDevice, integer in_iAddr, integer in_iCount)
{
    local_var char packet[512]
    local_var integer ID
    
    if(m_cIsConnect == 1)
    {
	// получение идентификатора
	ID = fnGetTID(OPERATION_READ_COIL_STATUS)
	
	// общий заголовок
	packet[01] = TYPE_CAST(ID >> 8)				// TID
	packet[02] = TYPE_CAST(ID & $FF)
	packet[03] = 0						// PID всегда ноль
	packet[04] = 0
	
	packet[05] = 0						// Длинна пакета
	packet[06] = 6
	packet[07] = in_cDevice					// идентификатор устройсва
	packet[08] = MODBUS_READ_COIL_STATUS			// тип операции
	packet[09] = TYPE_CAST(in_iAddr >> 8)			// адрес
	packet[10] = TYPE_CAST(in_iAddr & $FF)
	packet[11] = TYPE_CAST(in_iCount >> 8)			// количество бит
	packet[12] = TYPE_CAST(in_iCount & $FF)
	
	// установка длинны пакета
	set_length_string(packet, 12)

	// отправка на устройство
	send_string dvPhysicalDevice, packet
    }
}

/**
    Отправка запроса на получение значений дискретных входов
    на входе	:	in_cDevice	- идентификатор устройства для которого
					нужно отправлять данные
			in_iAddr	- адрес
			in_iCount	- количество
    на выходе	:	*
*/
define_function fnOnSendReadInputStatus(char in_cDevice, integer in_iAddr, integer in_iCount)
{
    local_var char packet[512]
    local_var integer ID
    
    if(m_cIsConnect == 1)
    {
	// получение идентификатора
	ID = fnGetTID(OPERATION_READ_INPUT_STATUS)
	
	// общий заголовок
	packet[01] = TYPE_CAST(ID >> 8)				// TID
	packet[02] = TYPE_CAST(ID & $FF)
	packet[03] = 0						// PID всегда ноль
	packet[04] = 0
	
	packet[05] = 0						// Длинна пакета
	packet[06] = 6
	packet[07] = in_cDevice					// идентификатор устройсва
	packet[08] = MODBUS_READ_INPUT_STATUS			// тип операции
	packet[09] = TYPE_CAST(in_iAddr >> 8)			// адрес
	packet[10] = TYPE_CAST(in_iAddr & $FF)
	packet[11] = TYPE_CAST(in_iCount >> 8)			// количество
	packet[12] = TYPE_CAST(in_iCount & $FF)
	
	// установка длинны пакета
	set_length_string(packet, 12)

	// отправка на устройство
	send_string dvPhysicalDevice, packet
    }
}

/**
    Отправка запроса на получение значений выходных регистров
    на входе	:	in_cDevice	- идентификатор устройства для которого
					нужно отправлять данные
			in_iAddr	- адрес
			in_iCount	- количество
    на выходе	:	*
*/
define_function fnOnSendReadHoldingRegister(char in_cDevice, integer in_iAddr, integer in_iCount)
{
    local_var char packet[512]
    local_var integer ID
    
    if(m_cIsConnect == 1)
    {
	// получение идентификатора
	ID = fnGetTID(OPERATION_READ_HOLDING_REGISTER)
	
	// общий заголовок
	packet[01] = TYPE_CAST(ID >> 8)				// TID
	packet[02] = TYPE_CAST(ID & $FF)
	packet[03] = 0						// PID всегда ноль
	packet[04] = 0
	
	packet[05] = 0						// Длинна пакета
	packet[06] = 6
	packet[07] = in_cDevice					// идентификатор устройсва
	packet[08] = MODBUS_READ_HOLDING_REGISTER		// тип операции
	packet[09] = TYPE_CAST(in_iAddr >> 8)			// адрес
	packet[10] = TYPE_CAST(in_iAddr & $FF)
	packet[11] = TYPE_CAST(in_iCount >> 8)			// количество
	packet[12] = TYPE_CAST(in_iCount & $FF)
	
	// установка длинны пакета
	set_length_string(packet, 12)

	// отправка на устройство
	send_string dvPhysicalDevice, packet
    }
}

/**
    Отправка запроса на получение значений входных регистров
    на входе	:	in_cDevice	- идентификатор устройства для которого
					нужно отправлять данные
			in_iAddr	- адрес
			in_iCount	- количество
    на выходе	:	*
*/
define_function fnOnSendReadInputRegister(char in_cDevice, integer in_iAddr, integer in_iCount)
{
    local_var char packet[512]
    local_var integer ID
    
    if(m_cIsConnect == 1)
    {
	// получение идентификатора
	ID = fnGetTID(OPERATION_READ_INPUT_REGISTER)
	
	// общий заголовок
	packet[01] = TYPE_CAST(ID >> 8)				// TID
	packet[02] = TYPE_CAST(ID & $FF)
	packet[03] = 0						// PID всегда ноль
	packet[04] = 0
	
	packet[05] = 0						// Длинна пакета
	packet[06] = 6
	packet[07] = in_cDevice					// идентификатор устройсва
	packet[08] = MODBUS_READ_INPUT_REGISTER			// тип операции
	packet[09] = TYPE_CAST(in_iAddr >> 8)			// адрес
	packet[10] = TYPE_CAST(in_iAddr & $FF)
	packet[11] = TYPE_CAST(in_iCount >> 8)			// количество
	packet[12] = TYPE_CAST(in_iCount & $FF)
	
	// установка длинны пакета
	set_length_string(packet, 12)

	// отправка на устройство
	send_string dvPhysicalDevice, packet
    }
}

/**
    Отправка запроса на установку дискретного выхода
    на входе	:	in_cDevice	- идентификатор устройства для которого
					нужно отправлять данные
			in_iAddr	- адрес
			in_cValue	- значение для установки
    на выходе	:	*
*/
define_function fnOnSendWriteCoilStatus(char in_cDevice, integer in_iAddr, char in_cValue)
{
    local_var char packet[512]
    local_var integer ID
    local_var integer val

    val = 0
    if(in_cValue != 0)
	val = $FF00
    
    if(m_cIsConnect == 1)
    {
	// получение идентификатора
	ID = fnGetTID(OPERATION_WRITE_COIL_STATUS)
	
	// общий заголовок
	packet[01] = TYPE_CAST(ID >> 8)				// TID
	packet[02] = TYPE_CAST(ID & $FF)
	packet[03] = 0						// PID всегда ноль
	packet[04] = 0
	
	packet[05] = 0						// Длинна пакета
	packet[06] = 6
	packet[07] = in_cDevice					// идентификатор устройсва
	packet[08] = MODBUS_WRITE_COIL_STATUS			// тип операции
	packet[09] = TYPE_CAST(in_iAddr >> 8)			// адрес
	packet[10] = TYPE_CAST(in_iAddr & $FF)
	packet[11] = TYPE_CAST(val >> 8)			// значение
	packet[12] = TYPE_CAST(val & $FF)
	
	// установка длинны пакета
	set_length_string(packet, 12)

	// отправка на устройство
	send_string dvPhysicalDevice, packet
    }
}

/**
    Отправка запроса на установку регистрового выхода
    на входе	:	in_cDevice	- идентификатор устройства для которого
					нужно отправлять данные
			in_iAddr	- адрес
			in_iValue	- значение для установки
    на выходе	:	*
*/
define_function fnOnSendWriteHoldingRegister(char in_cDevice, integer in_iAddr, integer in_iValue)
{
    local_var char packet[512]
    local_var integer ID
    local_var integer val
    
    if(m_cIsConnect == 1)
    {
	// получение идентификатора
	ID = fnGetTID(OPERATION_WRITE_HOLDING_REGISTER)
	
	// общий заголовок
	packet[01] = TYPE_CAST(ID >> 8)				// TID
	packet[02] = TYPE_CAST(ID & $FF)
	packet[03] = 0						// PID всегда ноль
	packet[04] = 0
	
	packet[05] = 0						// Длинна пакета
	packet[06] = 6
	packet[07] = in_cDevice					// идентификатор устройсва
	packet[08] = MODBUS_WRITE_HOLDING_REGISTER		// тип операции
	packet[09] = TYPE_CAST(in_iAddr >> 8)			// адрес
	packet[10] = TYPE_CAST(in_iAddr & $FF)
	packet[11] = TYPE_CAST(in_iValue >> 8)			// значение
	packet[12] = TYPE_CAST(in_iValue & $FF)
	
	// установка длинны пакета
	set_length_string(packet, 12)

	// отправка на устройство
	send_string dvPhysicalDevice, packet
    }
}

/**
    Отправка запроса на установку нескольких дискретных выходов
    на входе	:	in_cDevice	- идентификатор устройства для которого
					нужно отправлять данные
			in_iAddr	- адрес
			in_iCount	- количество значений для установки
			in_iaArray	- список значений для установки
    на выходе	:	*
*/
define_function fnOnSendWriteCoilStatusArray(char in_cDevice, integer in_iAddr, integer in_iCount, integer in_iaArray[])
{
    local_var char packet[512]
    local_var integer ID, len, i
    local_var char idx, bit, byte
    
    if(m_cIsConnect == 1)
    {
	// получение идентификатора
	ID = fnGetTID(OPERATION_WRITE_COIL_STATUS_ARRAY)
	
	// общий заголовок
	packet[01] = TYPE_CAST(ID >> 8)				// TID
	packet[02] = TYPE_CAST(ID & $FF)
	packet[03] = 0						// PID всегда ноль
	packet[04] = 0
	
	// вычисление размера пакета
	len = (in_iCount + 7) / 8

	// формирование пакета
	packet[05] = TYPE_CAST(len >> 8)			// Длинна пакета
	packet[06] = TYPE_CAST(len & $FF)
	packet[07] = in_cDevice					// идентификатор устройсва
	packet[08] = MODBUS_WRITE_COIL_STATUS_ARRAY		// тип операции
	packet[09] = TYPE_CAST(in_iAddr >> 8)			// адресс
	packet[10] = TYPE_CAST(in_iAddr & $FF)
	packet[11] = TYPE_CAST(in_iCount >> 8)			// количество бит
	packet[12] = TYPE_CAST(in_iCount & $FF)
	packet[13] = TYPE_CAST(len)				// количество байт
	
	// очистка буфера
	for(i = 0; i < len; i++)
	    packet[14 + i] = 0

	// формирование данных для записи
	for(i = 0; i < in_iCount; i++)
	{
	    idx = i / 8
	    bit = i % 8
	    
	    byte = packet[14 + idx]
	    
	    if(in_iaArray[i + 1] != 0)
		byte = byte | (1 << bit)
		
	    packet[14 + idx] = byte
	}
	    
	// установка длинны пакета
	set_length_string(packet, 13 + len)
	
	// отправка на устройство
	send_string dvPhysicalDevice, packet
    }
}

/**
    Отправка запроса на установку нескольких выходных регистров
    на входе	:	in_cDevice	- идентификатор устройства для которого
					нужно отправлять данные
			in_iAddr	- адрес
			in_iCount	- количество значений для установки
			in_iaArray	- список значений для установки
    на выходе	:	*
*/
define_function fnOnSendWriteHoldingRegisterArray(char in_cDevice, integer in_iAddr, integer in_iCount, integer in_iaArray[])
{
    local_var char packet[512]
    local_var integer ID, len, i
    
    if(m_cIsConnect == 1)
    {
	// получение идентификатора
	ID = fnGetTID(OPERATION_WRITE_HOLDING_REGISTER_ARRAY)
	
	// общий заголовок
	packet[01] = TYPE_CAST(ID >> 8)				// TID
	packet[02] = TYPE_CAST(ID & $FF)
	packet[03] = 0						// PID всегда ноль
	packet[04] = 0
	
	// вычисление размера пакета
	len = 7 + in_iCount * 2

	// формирование пакета
	packet[05] = TYPE_CAST(len >> 8)			// Длинна пакета
	packet[06] = TYPE_CAST(len & $FF)
	packet[07] = in_cDevice					// идентификатор устройсва
	packet[08] = MODBUS_WRITE_HOLDING_REGISTER_ARRAY	// тип операции
	packet[09] = TYPE_CAST(in_iAddr >> 8)			// адрес
	packet[10] = TYPE_CAST(in_iAddr & $FF)
	packet[11] = TYPE_CAST(in_iCount >> 8)			// количество
	packet[12] = TYPE_CAST(in_iCount & $FF)
	packet[13] = TYPE_CAST(in_iCount * 2)

	// формирование данных для записи
	for(i = 0; i < in_iCount; i++)
	{
	    packet[14 + i*2    ] = TYPE_CAST(in_iaArray[i + 1] >> 8)
	    packet[14 + i*2 + 1] = TYPE_CAST(in_iaArray[i + 1] & $FF)
	}
	
	// установка длинны пакета
	set_length_array(packet, 6 + len)
	
	// отправка на устройство
	send_string dvPhysicalDevice, packet
    }
}

/**
    Обработка ответа
    на входе	:	in_sbBuffer - полученый пакет
    на выходе	:	true - команда обработана
			false - недостаточно данных
*/
define_function char fnOnReceive(StreamBuffer in_sbBuffer)
{
    local_var integer i, j, len, ptr, packet_len, a, s, tid, pid, op, fc
    local_var integer value, l_iVal, idx1, idx2
    local_var char d, c, o, b, byte
    local_var char str[16]
   
    // проверка размера пакета
    if(fnSB_GetSize(in_sbBuffer) < 8)
	return false
    
    // пропустим TID и PID
    tid = fnSB_GetIntBE(in_sbBuffer)
    pid = fnSB_GetIntBE(in_sbBuffer)
    op  = fnGetOperation(tid);

    // прочитаем размер пакета
    packet_len	= fnSB_GetIntBE(in_sbBuffer)
    
    // идентификатор устройства
    d	= fnSB_GetChar(in_sbBuffer)
    fc	= fnSB_GetChar(in_sbBuffer)

    if(	fc == MODBUS_READ_COIL_STATUS ||
	fc == MODBUS_READ_INPUT_STATUS ||
	fc == MODBUS_READ_HOLDING_REGISTER ||
	fc == MODBUS_READ_INPUT_REGISTER)
    {
	if(fnSB_GetSize(in_sbBuffer) < 3)
	    return false

	// количество полученых байт
	c = fnSB_GetChar(in_sbBuffer)
	if(fnSB_GetSize(in_sbBuffer) < c)
	    return false
    }

    // обработка ответов
    switch(fc)
    {
	case MODBUS_READ_COIL_STATUS:
	{/*
	    for(i = 0; i < c; i++)
	    {
		b = fnSB_GetChar(in_sbBuffer)
		for(j = 0; j < 8; j++)
		{
		    byte = (b >> j) & 1
		    
		    if(m_caCoilStatus[i * 8 + j + 1] != byte)
		    {
			if(byte == 0)
			    do_release(vdvDevice, iOutputCoil + i * 8 + j)
			else
			    do_push_timed(vdvDevice, iOutputCoil + i * 8 + j, do_push_timed_infinite)
		    }
		    m_caCoilStatus[i * 8 + j + 1] = byte
		}
	    }
*/
	    // сдвиг буфера
	    fnSB_Shift(in_sbBuffer)
	    
	    // отладочная информация
	    #IF_DEFINED _DEBUG_FLAG
		send_string 0, "'Receive: Read coil status'"
	    #END_IF
	    return true
	}
	case MODBUS_READ_INPUT_STATUS:
	{/*
	    for(i = 0; i < c; i++)
	    {
		b = fnSB_GetChar(in_sbBuffer)
		for(j = 0; j < 8; j++)
		{
		    byte = (b >> j) & 1
		    
		    if(m_caInputCoil[i * 8 + j + 1] != byte)
		    {
			if(byte == 0)
			    do_release(vdvDevice, iInputCoil + i * 8 + j)
			else
			    do_push_timed(vdvDevice, iInputCoil + i * 8 + j, do_push_timed_infinite)
		    }
		    m_caInputCoil[i * 8 + j + 1] = byte
		}
	    }
*/
	    // сдвиг буфера
	    fnSB_Shift(in_sbBuffer)
	    
	    // отладочная информация
	    #IF_DEFINED _DEBUG_FLAG
		send_string 0, "'Receive: Read input status'"
	    #END_IF
	    return true
	}
	// ответ на чтение
	case MODBUS_READ_HOLDING_REGISTER:
	{
/*
	    // если пинг
	    if(op == OPERATION_PING)
	    {
		// запомним время последнего пинга
		m_lLastPingTime = m_lCurTime
		
		outTempp = fnSB_GetIntBE(in_sbBuffer)
		    
		// сдвиг буфера
		fnSB_Shift(in_sbBuffer)
		
		// поиск изменений
		//fnOnFindingChanges()
		
		// отладочная информация
		#IF_DEFINED _DEBUG_FLAG
		    send_string 0, "'Receive: Ping'"
		#END_IF
	    
	    } 	 
*/	    
	    
	    m_lLastPingTime = m_lCurTime
	    outTempp = fnSB_GetIntBE(in_sbBuffer)
	    // сдвиг буфера
	    fnSB_Shift(in_sbBuffer)
	    
	    // отладочная информация
	    #IF_DEFINED _DEBUG_FLAG
		send_string 0, "'Receive: Read holding register - ', itoa(c)"
	    #END_IF
	    return true
	}

	// ответ на чтение
	case MODBUS_READ_INPUT_REGISTER:
	{
	    if(op == OPERATION_READ_INPUT_REGISTER)
	    {
		// получение значения
		for(i = 0; i < (c/2); i++)
		{
		    m_iaInputRegisters[i + 1] = fnSB_GetIntBE(in_sbBuffer)
		    #IF_DEFINED _DEBUG_FLAG
			send_string 0, "'ir ', itoa(m_iaInputRegisters[i + 1])"
		    #END_IF
		}
		
	    }
	    
	    // сдвиг буфера
	    fnSB_Shift(in_sbBuffer)
	    
	    // отладочная информация
	    #IF_DEFINED _DEBUG_FLAG
		send_string 0, "'Receive: Read input registers'"
	    #END_IF
	    
	    return true
	}
	
	// ответ на запись дискретного выхода
	case MODBUS_WRITE_COIL_STATUS:
	{
	    fnSB_SkipBytes(in_sbBuffer, 4)
	    
	    // сдвиг буфера
	    fnSB_Shift(in_sbBuffer)
	    
	    // отладочная информация
	    #IF_DEFINED _DEBUG_FLAG
		send_string 0, "'Receive: Write coil status'"
	    #END_IF
	    return true
	}

	// ответ на запись выходого регистра
	case MODBUS_WRITE_HOLDING_REGISTER:
	{
	    fnSB_SkipBytes(in_sbBuffer, 4)
	    
	    // сдвиг буфера
	    fnSB_Shift(in_sbBuffer)
	    
	    // отладочная информация
	    #IF_DEFINED _DEBUG_FLAG
		send_string 0, "'Receive: Write holding registers'"
	    #END_IF
	    return true
	}

	// ответ на запись дискретнох выходов
	case MODBUS_WRITE_COIL_STATUS_ARRAY:
	{
	    fnSB_SkipBytes(in_sbBuffer, 4)
	    
	    // сдвиг буфера
	    fnSB_Shift(in_sbBuffer)
	    
	    // отладочная информация
	    #IF_DEFINED _DEBUG_FLAG
		send_string 0, "'Receive: Write coil status array'"
	    #END_IF
	    return true
	}

	// ответ на запись выходных регистров
	case MODBUS_WRITE_HOLDING_REGISTER_ARRAY:
	{
	    if(fnSB_GetSize(in_sbBuffer) < 4)
		return false
		
	    a = fnSB_GetIntBE(in_sbBuffer)
	    s = fnSB_GetIntBE(in_sbBuffer)
	    
	    // сдвиг буфера
	    fnSB_Shift(in_sbBuffer)
	    
	    // отладочная информация
	    #IF_DEFINED _DEBUG_FLAG
		send_string 0, "'Receive: Write holding register array'"
	    #END_IF
	    return true
	}
    }
	
    // неопознаные данные удалим их
    fnSB_Reset(in_sbBuffer)
    return false
}

/**
    Обработка команды приходящих на виртуальный порт
    на входе	: in_caCommand	- указатель на команду
    на выходе	: *
*/
define_function fnOnCommand(char in_caCommand[])
{
    local_var 
	integer a, v, l_iCount, i, bit
	integer value
	integer mute
	integer block
	integer zone
	char d, c, l_bRun
	integer l_iaTemp[256]
	integer l_iaValue[256]
	integer l_iAddr
	char l_caBlock[8]
    
    // проверка наличия команды получение дискретных выходов
    if(find_string(in_caCommand, 'GET_CS ', 1) == 1)
    {
	// проверка наличия соединения
	if(m_cIsConnect == 1)
	{
	    // чтение номера устройства
	    remove_string(in_caCommand, 'GET_CS ', 1)
	    d = TYPE_CAST(atoi(in_caCommand))
	    
	    // чтение адреса
	    remove_string(in_caCommand, ',', 1)
	    a = atoi(in_caCommand)
	    
	    // чтение количества читаемых данных
	    remove_string(in_caCommand, ',', 1)
	    c = TYPE_CAST(atoi(in_caCommand))
    
	    // проверка параметров
	    if(fnTestParameters(d, a))
		fnOnSendReadCoilStatus(d, a, c)
	    else
		send_string vdvDevice, "'ERROR_GET: ', ITOHEX(d), ', invalid parameters'"
	}

    // проверка наличия команды получения дискретных входов
    } else if(find_string(in_caCommand, 'GET_IS ', 1) == 1)
    {
	// проверка наличия соединения
	if(m_cIsConnect == 1)
	{
	    // Чтение номера устройства
	    remove_string(in_caCommand, 'GET_IS ', 1)
	    d = TYPE_CAST(atoi(in_caCommand))
	    
	    // Чтение адреса
	    remove_string(in_caCommand, ',', 1)
	    a = atoi(in_caCommand)
	    
	    // Чтение количества читаемых данных
	    remove_string(in_caCommand, ',', 1)
	    c = TYPE_CAST(atoi(in_caCommand))
    
	    // проверка параметров
	    if(fnTestParameters(d, a))
		fnOnSendReadInputStatus(d, a, c)
	    else
		send_string vdvDevice, "'ERROR_GET: ', ITOHEX(d), ', invalid parameters'"
	}

    // Проверка на наличие команды GET
    } else if(find_string(in_caCommand, 'GET_HR ', 1) == 1)
    {
	// проверка наличия соединения
	if(m_cIsConnect == 1)
	{
	    // Чтение номера устройства
	    remove_string(in_caCommand, 'GET_HR ', 1)
	    d = TYPE_CAST(atoi(in_caCommand))
	    
	    // Чтение адреса
	    remove_string(in_caCommand, ',', 1)
	    a = atoi(in_caCommand)
	    
	    // Чтение количества читаемых данных
	    remove_string(in_caCommand, ',', 1)
	    c = TYPE_CAST(atoi(in_caCommand))
    
	    // проверка параметров
	    if(fnTestParameters(d, a))
		fnOnSendReadHoldingRegister(d, a, c)
	    else
		send_string vdvDevice, "'ERROR_GET: ', ITOHEX(d), ', invalid parameters'"
	}
	
    // Проверка на наличие команды GET
    } else if(find_string(in_caCommand, 'GET_IR ', 1) == 1)
    {
	// проверка наличия соединения
	if(m_cIsConnect == 1)
	{
	    // Чтение номера устройства
	    remove_string(in_caCommand, 'GET_IR ', 1)
	    d = TYPE_CAST(atoi(in_caCommand))
	    
	    // Чтение адреса
	    remove_string(in_caCommand, ',', 1)
	    a = atoi(in_caCommand)
	    
	    // чтение параметров
	    
	    // Чтение количества читаемых данных
	    remove_string(in_caCommand, ',', 1)
	    c = TYPE_CAST(atoi(in_caCommand))
    
	    // проверка параметров
	    if(fnTestParameters(d, a))
		fnOnSendReadInputRegister(d, a, c)
	    else
		send_string vdvDevice, "'ERROR_GET: ', ITOHEX(d), ', invalid parameters'"
	}

    // команда SET_CS
    } else if(find_string(in_caCommand, 'SET_CS ', 1) == 1)
    {
	// проверка наличия соединения
	if(m_cIsConnect == 1)
	{
	    // чтение номера устройства
	    remove_string(in_caCommand, 'SET_CS ', 1)
	    d = TYPE_CAST(atoi(in_caCommand))
	    
	    // чтение адреса
	    remove_string(in_caCommand, ',', 1)
	    a = atoi(in_caCommand)
	    
	    remove_string(in_caCommand, ',', 1)
	    
	    l_iCount = fnGetArray(in_caCommand, l_iaTemp);
	    
	    // проверка параметров
	    if(fnTestParameters(d, a))
	    {
		if(l_iCount == 1)
		    fnOnSendWriteCoilStatus(d, a, l_iaTemp[1])
		else
		    fnOnSendWriteCoilStatusArray(d, a, l_iCount, l_iaTemp);
	    }
	    else
		send_string vdvDevice, "'ERROR_SET: ', ITOHEX(d), ', invalid parameters'"
	}

    // команда SET_HR
    } else if(find_string(in_caCommand, 'SET_HR ', 1) == 1)
    {
	// проверка наличия соединения
	if(m_cIsConnect == 1)
	{
	    // Чтение номера устройства
	    remove_string(in_caCommand, 'SET_HR ', 1)
	    d = TYPE_CAST(atoi(in_caCommand))
	    
	    // Чтение адреса
	    remove_string(in_caCommand, ',', 1)
	    a = atoi(in_caCommand)
	    
	    remove_string(in_caCommand, ',', 1)
	    
	    l_iCount = fnGetArray(in_caCommand, l_iaTemp);
	    
	    // проверка параметров
	    if(fnTestParameters(d, a))
	    {
		if(l_iCount == 1)
		    fnOnSendWriteHoldingRegister(d, a, l_iaTemp[1])
		else
		    fnOnSendWriteHoldingRegisterArray(d, a, l_iCount, l_iaTemp);
	    }
	    #IF_DEFINED _DEBUG_FLAG
	    else
		send_string 0, "'ERROR_SET: ', ITOHEX(d), ', invalid parameters'"
	    #END_IF
	}	
    // проверка наличия команды соединения
    } else if(find_string(in_caCommand, 'START', 1) == 1)
    {
	//  запуск потока для поддержания соединения
	timeline_create(TL_WORK_ID, m_laWork, 1, TIMELINE_ABSOLUTE, TIMELINE_REPEAT)
	printf('modbus START')
	
    } else if(find_string(in_caCommand, 'STOP', 1) == 1)
    {
	// остановка потока для поддержания соединения
	timeline_kill(TL_WORK_ID);
	printf('modbus STOP')
    }
}

/**
    Обработка поддержания соединения с контроллером
    на входе	: *
    на выходе	: *
*/
define_function fnOnWork()
{
    local_var long l_lTime
    
    if(m_cIsConnect == 0)
    {
	// обработка 
	l_lTime = m_lCurTime - m_lStartWaitTime
	if(l_lTime > 3000)
	{
	    m_cIsConnect = 2
	    
	    send_command vdvDevice, "'fnOnConnect(', caHost, ',', itoa(iPort), ')'"
	    fnOnConnect(dvPhysicalDevice, caHost, iPort)
	    
	    m_lStartWaitTime = m_lCurTime
	}
    } else if(m_cIsConnect == 1)
    {
	l_lTime = m_lCurTime - m_lLastPingTime
	if(l_lTime > 8000)
	{
	    fnOnDisconnect(dvPhysicalDevice)
	    send_string vdvDevice, "'TIMEOUT'"
	}
    } else if(m_cIsConnect == 2)
    {
	// обработка 
	l_lTime = m_lCurTime - m_lStartWaitTime
	if(l_lTime > 5000)
	{
	    send_command vdvDevice, "'TIMEOUT WAIT CONNECT'"
	    m_cIsConnect = 0
	    m_lStartWaitTime = m_lCurTime
	}
    }
}

(***********************************************************)
(*        SUBROUTINE/FUNCTION DEFINITIONS GO BELOW         *)
(***********************************************************)
(* EXAMPLE: DEFINE_FUNCTION <RETURN_TYPE> <NAME> (<PARAMETERS>) *)
(* EXAMPLE: DEFINE_CALL '<NAME>' (<PARAMETERS>) *)

(***********************************************************)
(*                STARTUP CODE GOES BELOW                  *)
(***********************************************************)
DEFINE_START
// Инициализация потокового буфера
fnSB_Reset(m_sbInputBuffer)

(***********************************************************)
(*                THE EVENTS GO BELOW                      *)
(***********************************************************)
DEFINE_EVENT

/**
    Обработчик таймера пинга
*/
TIMELINE_EVENT[TL_PING_ID]
{
    fnOnPing()
}

/**
    Обработчик поддержания соединения
*/
TIMELINE_EVENT[TL_WORK_ID]
{
    if(timeline.sequence == 1)
    {
	m_lCurTime = m_lCurTime + m_laWork[1]
	fnOnWork()
    }
}

/**
    Обработчик физического порта
*/
DATA_EVENT[dvPhysicalDevice]
{
    // включение устройства
    ONLINE:
    {
	// Отладочная информация
	printf("'modbus tcp physical port is online'")
	
	// соединение установлено
	m_cIsConnect = 1

	// инициализация соединения
	fnOnInit()
	// отправим подтверждение отправки данных
	send_string vdvDevice, "'Modbus TCP Is Connected!!!'"
    }
    
    // отключение устройства
    OFFLINE:
    {
	// Отладочная информация
	printf("'modbus physical port is offline'")
	
	// инициализация соединения
	fnOnDeInit()
	
	// соединение прервано
	m_cIsConnect = 0
	
	// отправим подтверждение отправки данных
	send_string vdvDevice, "'Modbus TCP Disconnected!!!'"
    }
    
    // Получение стринга
    STRING:
    {
	// Отладочная информация
	// printf(data.text)
	
	// добавление полученых данных в буфер
	if(fnSB_Add(m_sbInputBuffer, data.text))
	{
	    // обработка полученых данных
	    while(1)
	    {
		if(fnOnReceive(m_sbInputBuffer) == false)
		    break
	    }
	} else
	{
	    // переполнение буфера
	    send_string vdvDevice, "'Buffer overflow!'"

	    // сброс данных буфера
	    fnSB_Reset(m_sbInputBuffer)
	}
    }
    
    // обработка ошибки
    ONERROR:
    {
	// Отладочная информация
	    printf("'modbus physical port error'")
	    printf(DATA.TEXT)
	    send_string vdvDevice, DATA.TEXT
    }
}

/**
    Обработчик виртуального порта
*/
DATA_EVENT[vdvDevice]
{
    COMMAND:
    {
	local_var char caCommand[256]
	
	// перевод в верхний регистр
	fnStr_ToUpper(data.text)
	
	// отладочная информация
	printf("'COMMAND - ', data.text")

	// выполнять пока есть команды
	while(fnStr_GetStringWhile(data.text, caCommand, $3B))
	{
	    // обработка команды
	    fnOnCommand(caCommand)
	    
	    // удаление обработаной команды
	    remove_string(data.text, "$3B", 1)
	}
    }
}
/*
channel_event[vdvDevice, 0]
{
    on:
    {
	local_var integer l_iCh
	local_var integer l_iZone
	    
	l_iZone = atoi(left_string(itoa(channel.channel), 2)) - 10
	l_iCh = atoi(right_string(itoa(channel.channel), 2))
	
	switch(l_iCh)
	{
	    case 97: send_command vdvDevice, "'VOLUME_UP ', itoa(l_iZone), ';'"
	    case 98: send_command vdvDevice, "'VOLUME_DOWN ', itoa(l_iZone), ';'"
	    case 99: send_command vdvDevice, "'MUTE ', itoa(l_iZone), ';'"
	}
    }
    off:
    {
	local_var integer l_iCh
	local_var integer l_iZone
	    
	l_iZone = atoi(left_string(itoa(channel.channel), 2)) - 10
	l_iCh = atoi(right_string(itoa(channel.channel), 2))
	
	switch(l_iCh)
	{
	    case 97:
	    case 98: 
		send_command vdvDevice, "'VOLUME_STOP ', itoa(l_iZone), ';'"
	}
    }
}
*/
(***********************************************************)
(*            THE ACTUAL PROGRAM GOES BELOW                *)
(***********************************************************)
DEFINE_PROGRAM

(***********************************************************)
(*                     END OF PROGRAM                      *)
(*        DO NOT PUT ANY CODE BELOW THIS COMMENT           *)
(***********************************************************)
