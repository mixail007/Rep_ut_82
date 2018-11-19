﻿Процедура СохранитьНастройки()

	ТекущиеНастройки.Подразделения.Очистить();
	
	Для каждого Подразделение Из Подразделения Цикл
	
		Если Подразделение.Пометка Тогда
		
			ТекущиеНастройки.Подразделения.Добавить(Подразделение.Значение);
		
		КонецЕсли; 
	
	КонецЦикла;
	
	ТекущиеНастройки.ТипыДоговоров.Очистить();
	
	Для каждого ТипДоговора Из ТипыДоговоров Цикл
	
		Если ТипДоговора.Пометка Тогда
		
			ТекущиеНастройки.ТипыДоговоров.Добавить(ТипДоговора.Значение);
		
		КонецЕсли; 
	
	КонецЦикла;
	
	ТекущиеНастройки.МенеджерОтбор = ОтборПоМенеджеру;
	ТекущиеНастройки.Контрагенты.Очистить();
	
	Для каждого СтрокаТЗ Из ОтобратьПоКонтрагентам Цикл
	
		ТекущиеНастройки.Контрагенты.Добавить(СтрокаТЗ.Контрагент);
	
	КонецЦикла;
	
	ТекущиеНастройки.ИсключитьКонтрагентов = ИсключитьВыбранныхКонтрагентов;
	
	ТекущиеНастройки.ВидДоговора.Очистить();
	
	Если СПокупателем Тогда
	
		ТекущиеНастройки.ВидДоговора.Добавить(Перечисления.ВидыДоговоровКонтрагентов.СПокупателем);
	
	КонецЕсли; 
	
	Если СПоставщиком Тогда
	
		ТекущиеНастройки.ВидДоговора.Добавить(Перечисления.ВидыДоговоровКонтрагентов.СПоставщиком);
	
	КонецЕсли; 
	
	Если Прочее Тогда
	
		ТекущиеНастройки.ВидДоговора.Добавить(Перечисления.ВидыДоговоровКонтрагентов.Прочее);
	
	КонецЕсли; 

	
	ТекущиеНастройки.Менеджер = Менеджер;
	ТекущиеНастройки.ГруппироватьПоПодразделениям = ГруппироватьПоПодразделениям;


КонецПроцедуры
 

Процедура ВосстановитьНастройки()

	Для каждого Подразделение Из ТекущиеНастройки.Подразделения Цикл
		
		СтрокаСписка = Подразделения.НайтиПоЗначению(Подразделение);
		
		Если СтрокаСписка <> Неопределено Тогда
			
			СтрокаСписка.Пометка = Истина;
			
		КонецЕсли;
			
	
	КонецЦикла; 
	
	Для каждого ТипДоговора Из ТекущиеНастройки.ТипыДоговоров Цикл
		
		СтрокаСписка = ТипыДоговоров.НайтиПоЗначению(ТипДоговора);
		
		Если СтрокаСписка <> Неопределено Тогда
			
			СтрокаСписка.Пометка = Истина;
			
		КонецЕсли;
			
	
	КонецЦикла;
	
	Менеджер = ТекущиеНастройки.Менеджер;
	//ВидДоговора1 = ТекущиеНастройки.ВидДоговора;
	
	СПокупателем = Ложь;
	СПоставщиком = Ложь;
	Прочее = Ложь;
	
	Для каждого ВидДоговора Из ТекущиеНастройки.ВидДоговора Цикл
	
		Если ВидДоговора = Перечисления.ВидыДоговоровКонтрагентов.СПокупателем Тогда
		
			СПокупателем = Истина;
		
		КонецЕсли; 
		
		Если ВидДоговора = Перечисления.ВидыДоговоровКонтрагентов.СПоставщиком Тогда
		
			СПоставщиком = Истина;
		
		КонецЕсли; 

		Если ВидДоговора = Перечисления.ВидыДоговоровКонтрагентов.Прочее Тогда
		
			Прочее = Истина;
		
		КонецЕсли; 

	
	КонецЦикла; 
	
	
	ОтобратьПоКонтрагентам.Очистить();
	
	Для каждого Ктг Из ТекущиеНастройки.Контрагенты Цикл
	
		СтрокаКонтрагентов = ОтобратьПоКонтрагентам.Добавить();
		СтрокаКонтрагентов.Контрагент = Ктг;
	
	КонецЦикла;
	
	ОтборПоМенеджеру = ТекущиеНастройки.МенеджерОтбор;
	
	ИсключитьВыбранныхКонтрагентов = ТекущиеНастройки.ИсключитьКонтрагентов;
    ГруппироватьПоПодразделениям = ТекущиеНастройки.ГруппироватьПоПодразделениям;

КонецПроцедуры
 

Процедура КнопкаВыполнитьНажатие(Кнопка)

	Если ТипЗнч(ТекущиеНастройки) <> Неопределено Тогда
	
		Если ТипЗнч(ТекущиеНастройки) = Тип("Структура") Тогда
		
			СохранитьНастройки();
		
		КонецЕсли; 
	
	КонецЕсли; 
	
	Закрыть(Истина);
	
КонецПроцедуры

Процедура ЗаполнитьПодразделения()
	
	Подразделения.Очистить();
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	Подразделения.Ссылка,
	|	Подразделения.Наименование
	|ИЗ
	|	Справочник.Подразделения КАК Подразделения";
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
	
		Подразделения.Добавить(Выборка.Ссылка, Выборка.Наименование, Ложь);
	
	КонецЦикла;
	
	Подразделения.Добавить(Справочники.Подразделения.ПустаяСсылка(), "Пустое подразделение", Ложь);
	
	
КонецПроцедуры

Процедура ЗаполнитьТипыДоговоров()

	ТипыДоговоров.Очистить();
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ТипыДоговоров.Ссылка,
	|	ТипыДоговоров.Наименование
	|ИЗ
	|	Справочник.ТипыДоговоров КАК ТипыДоговоров";
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
	
		ТипыДоговоров.Добавить(Выборка.Ссылка, Выборка.Наименование, Ложь);
	
	КонецЦикла;
	
	ТипыДоговоров.Добавить(Справочники.ТипыДоговоров.ПустаяСсылка(), "Пустой тип договора", Ложь);

КонецПроцедуры
 

Процедура ПриОткрытии()
	
	/// Временная мера - наверно :)
	
	ЭлементыФормы.Менеджер.Доступность = Ложь;
	ЭлементыФормы.Переключатель1.Доступность = Ложь;
	
	///

	
	ЗаполнитьПодразделения();
	ЗаполнитьТипыДоговоров();
	Менеджер = 1;
	
	Если ТипЗнч(ТекущиеНастройки) = Тип("Структура") Тогда
	
		ВосстановитьНастройки();
		
	Иначе
		
		ТекущиеНастройки = Новый Структура;
		ТекущиеНастройки.Вставить("Менеджер", Менеджер);
		ТекущиеНастройки.Вставить("ВидДоговора", Новый Массив);
		ТекущиеНастройки.Вставить("Подразделения", Новый Массив);
		ТекущиеНастройки.Вставить("ТипыДоговоров", Новый Массив);
		ТекущиеНастройки.Вставить("Контрагенты", Новый Массив);
		ТекущиеНастройки.Вставить("МенеджерОтбор", Справочники.Пользователи.ПустаяСсылка());
		ТекущиеНастройки.Вставить("ИсключитьКонтрагентов", Ложь);
		ТекущиеНастройки.Вставить("ГруппироватьПоПодразделениям", Ложь);
	
	КонецЕсли;
	
	
	
КонецПроцедуры
