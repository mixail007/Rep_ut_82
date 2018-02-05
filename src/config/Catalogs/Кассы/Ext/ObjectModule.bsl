﻿
Перем мПраваДоступаПользователей Экспорт;

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ

// Обработчик события ПередЗаписью объекта.
//
Процедура ПередЗаписью(Отказ)
	
	Если НЕ ОбменДанными.Загрузка Тогда
	
		Если НЕ ЭтоГруппа И ЗначениеНеЗаполнено(ВалютаДенежныхСредств) Тогда
			Сообщить("Не указана валюта денежных средств.",СтатусСообщения.Важное);
			Отказ = Истина;
		КонецЕсли;

		Если НЕ ЭтоГруппа 
		   И НЕ ЭтоНовый() 
		   И ВалютаДенежныхСредств <> Ссылка.ВалютаДенежныхСредств 
		   И ЭтотОбъект.СуществуютСсылки() Тогда

			Сообщить("Существуют документы, проведенные по кассе """ + Наименование + """.
			         |Реквизит ""Валюта денежных средств"" не может быть изменен, элемент не записан.", 
			         СтатусСообщения.Важное);

			Отказ = Истина;
		КонецЕсли;
	
	КонецЕсли; 
	
	Если НЕ Отказ Тогда
		
		обЗаписатьПротоколИзменений(ЭтотОбъект);
		
	КонецЕсли; 
	
КонецПроцедуры

// Обработчик события ПриКопировании
//
Процедура ПриКопировании(ОбъектКопирования)

	Если НЕ ЭтотОбъект.ЭтоГруппа
	   И НЕ ОбменДанными.Загрузка
	   И НЕ ЗначениеНеЗаполнено(ОбъектКопирования) Тогда
		ПрочитатьПраваДоступаКОбъекту(мПраваДоступаПользователей, ОбъектКопирования.Ссылка);
	КонецЕсли;

КонецПроцедуры

// Обработчик события ПриЗаписи
//
Процедура ПриЗаписи(Отказ)
	
	Если НЕ ОбменДанными.Загрузка Тогда
	
		ЗаполнитьНаборПравамиДоступаУнаследованымиОтРодителя(мПраваДоступаПользователей, Родитель, Ссылка);
		
		НеобходимоПереписыватьПодчиненных = ПроверитьНеобходимостьПереписыватьПраваДоступаДляПодчиненныхЭлементов(Ссылка, мПраваДоступаПользователей);
		
		ЗаписатьПраваДоступаКОбъекту(мПраваДоступаПользователей, Ссылка, Отказ);
		
		Если НеобходимоПереписыватьПодчиненных И НЕ Отказ Тогда
			УстановитьПраваДоступаДляПодчиненныхЭлементов(Ссылка, ЭтотОбъект.Метаданные().Имя, Отказ);
		КонецЕсли; 
		
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ЭКСПОРТИРУЕМЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

// Функция проверяет, существуют ли движения по кассе.
// Если есть - менять валюту кассы нельзя.
//
// Параметры:
//  Нет.
//
// Возвращаемое значение:
//  Истина - если есть движения, Ложь - если нет.
//
Функция СуществуютСсылки() Экспорт

	Запрос = Новый Запрос();

	Запрос.Текст = 
	"ВЫБРАТЬ РАЗЛИЧНЫЕ ПЕРВЫЕ 1
	|	РегистрНакопления.ДенежныеСредства.Регистратор КАК Документ
	|ИЗ
	|	РегистрНакопления.ДенежныеСредства
	|ГДЕ
	|	РегистрНакопления.ДенежныеСредства.БанковскийСчетКасса = &Касса";

	Запрос.УстановитьПараметр("Касса", Ссылка);

	Возврат НЕ Запрос.Выполнить().Пустой();

КонецФункции

мПраваДоступаПользователей = РегистрыСведений.ПраваДоступаПользователей.СоздатьНаборЗаписей();
Если НЕ Ссылка.Пустая() Тогда
	ПрочитатьПраваДоступаКОбъекту(мПраваДоступаПользователей, Ссылка);
КонецЕсли;
