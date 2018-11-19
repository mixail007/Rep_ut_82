﻿
Процедура УстановитьНастройку(НаименованиеНастройки, Значение) Экспорт
	
	Если ПустаяСтрока(НаименованиеНастройки) Тогда
		Возврат;
	КонецЕсли;
	
	Настройка= ПланыВидовХарактеристик.ПраваИНастройки.НайтиПоНаименованию(НаименованиеНастройки);
	
	Если НЕ ЗначениеЗаполнено(Настройка) И НЕ ПустаяСтрока(Значение) Тогда 
		ВызватьИсключение "Запись настройки пользователя:""" + НаименованиеНастройки + """ невозможна. Настройка не создана";
	КонецЕсли; 
	
	Запись= РегистрыСведений.ПраваИНастройки.СоздатьМенеджерЗаписи();
	
	Запись.Объект= ПолучитьМодульПрог("Модуль_1САдаптер").ТекущийПользователь();
	Запись.ПравоНастройка= Настройка;
	
	Если ЗначениеЗаполнено(Значение) Тогда
		Запись.Значение= Значение;
		Запись.Записать();
	Иначе
		Запись.Удалить();
	КонецЕсли;
		
КонецПроцедуры

Функция ПолучитьНастройку(Настройка, ЗначениеПоУмолчанию) Экспорт
	
	Если НЕ ЗначениеЗаполнено(Настройка) Тогда
		Возврат ЗначениеПоУмолчанию;
	КонецЕсли;
	
	Запрос= Новый Запрос(
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	Значение
	|ИЗ
	|	РегистрСведений.ПраваИНастройки
	|ГДЕ
	|	Объект = &Объект И ПравоНастройка = &Настройка");
	
	Запрос.УстановитьПараметр("Объект"	 , ПолучитьМодульПрог("Модуль_1САдаптер").ТекущийПользователь());
	Запрос.УстановитьПараметр("Настройка", Настройка);
	
	Если ТипЗнч(Настройка) = Тип("Строка") Тогда
		Запрос.Текст= СтрЗаменить(Запрос.Текст, "ПравоНастройка", "ПравоНастройка.Наименование");
	КонецЕсли;
	
	РезультатЗапроса= Запрос.Выполнить();
	
	Если НЕ РезультатЗапроса.Пустой() Тогда
		
		Выборка= РезультатЗапроса.Выбрать();
		Выборка.Следующий();
		
		Возврат Выборка.Значение;
		
	Иначе
		Возврат ЗначениеПоУмолчанию;
	КонецЕсли;
	
КонецФункции


Функция ПолучитьНастройку1С(Настройка) Экспорт
	
	Возврат ПолучитьНастройку(Настройка, Неопределено);
	
КонецФункции

Функция ПолучитьНастройку1С_СкладПоУмолчанию() Экспорт
	
	Возврат ПолучитьНастройку1С(ПланыВидовХарактеристик.ПраваИНастройки.ОсновнойСкладКомпании);
	
КонецФункции


Функция ПроверитьНаличиеНастроекПользователя(НаименованияНастроекПользователя) Экспорт
	НенайденныеНастройки = Новый Массив;
	Для каждого НаименованиеНастройки Из НаименованияНастроекПользователя Цикл
		Если НЕ ЗначениеЗаполнено(ПланыВидовХарактеристик.ПраваИНастройки.НайтиПоНаименованию(НаименованиеНастройки)) Тогда
			НенайденныеНастройки.Добавить(НаименованиеНастройки);
		КонецЕсли;
	КонецЦикла;
	
	Возврат НенайденныеНастройки;

КонецФункции

Функция СоздатьНастройкиПользователя(СтруктураНастроекПользователя) Экспорт
	
	СозданныеНастройки = Новый Массив;
	
	Для Каждого ТекущаяНастройка Из СтруктураНастроекПользователя Цикл
		
		НаименованиеНастройки = ТекущаяНастройка.Ключ;
		ТипЗначенияНастройки  = ТекущаяНастройка.Значение.ТипЗначения;
		
		НастройкаСсылка = ПланыВидовХарактеристик.ПраваИНастройки.НайтиПоНаименованию(НаименованиеНастройки);
		
		Если НЕ ЗначениеЗаполнено(НастройкаСсылка) Тогда
			
			НастройкаОбъект = ПланыВидовХарактеристик.ПраваИНастройки.СоздатьЭлемент();
			НастройкаОбъект.Родитель = ПолучитьИЛИСоздатьГруппуНастроекПользователя_Диадок();
			НастройкаОбъект.Наименование = НаименованиеНастройки;
			НастройкаОбъект.ТипЗначения = ТипЗначенияНастройки;
			НастройкаОбъект.Назначение = Перечисления.НазначениеПравИНастроек.Пользователь;
			НастройкаОбъект.УстановитьНовыйКод();
			НастройкаОбъект.Записать();
			
			СозданныеНастройки.Добавить(НаименованиеНастройки);
			
		ИначеЕсли НастройкаСсылка.ТипЗначения <> ТипЗначенияНастройки Тогда
			
			НастройкаОбъект = НастройкаСсылка.ПолучитьОбъект();
			НастройкаОбъект.ТипЗначения = ТипЗначенияНастройки;
			НастройкаОбъект.Записать();
			
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат СозданныеНастройки;
	
КонецФункции

Функция ПолучитьНеобходимыеДляРаботыТипы() Экспорт
	НеобходимыеДляРаботыТипы = Новый Массив;
	НеобходимыеДляРаботыТипы.Добавить(Метаданные.ПланыВидовХарактеристик.ПраваИНастройки);
	Возврат НеобходимыеДляРаботыТипы;
КонецФункции


Функция ПолучитьИЛИСоздатьГруппуНастроекПользователя_Диадок()
	ГруппаНастроекСсылка = планыВидовХарактеристик.ПраваИНастройки.НайтиПоНаименованию("Параметры подсистемы ДИАДОК");
	
	Если ЗначениеЗаполнено(ГруппаНастроекСсылка) Тогда 
		Возврат ГруппаНастроекСсылка;
	КонецЕсли;
	
	ГруппаНастроекОбъект = ПланыВидовХарактеристик.ПраваИНастройки.СоздатьГруппу();
	ГруппаНастроекОбъект.Наименование =  "Параметры подсистемы ДИАДОК";
	ГруппаНастроекОбъект.УстановитьНовыйКод();
	ГруппаНастроекОбъект.Записать();
	Возврат ГруппаНастроекОбъект.Ссылка;
КонецФункции

Функция ПроверитьПВХНастроекНаКвалификаторСтроки() Экспорт
	
	Если Метаданные.ПланыВидовХарактеристик.ПраваИНастройки.Тип.КвалификаторыСтроки.Длина < 50 Тогда
		Предупреждение("В конфигурации плане видов характеристик ""Права и настройки"" 
		|тип значения характеристик ""Строка"" имеет недостаточную длинну
		|необходимо минимум 50 символов", 60);
		Возврат Ложь;
	Иначе
		Возврат Истина;
	КонецЕсли;
	
КонецФункции
