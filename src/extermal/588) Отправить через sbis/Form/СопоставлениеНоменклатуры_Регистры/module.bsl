﻿// функции для совместимости кода 
&НаКлиенте
Функция сбисПолучитьФорму(ИмяФормы)
	Если ТипЗнч(ЭтаФорма) = Тип("УправляемаяФорма") Тогда
		Попытка
			ЭтотОбъект="";
		Исключение
		КонецПопытки;
		Возврат ПолучитьФорму("ВнешняяОбработка.СБИС.Форма."+ИмяФормы);
	КонецЕсли;
	Возврат ЭтотОбъект.ПолучитьФорму(ИмяФормы);
КонецФункции
///////////////////////////////
&НаКлиенте
Функция НайтиНоменклатуруПоставщикаПоТабличнойЧасти(стрКонтрагент, знач мТаблДок, КаталогНастроек, Ини) Экспорт
// получает контрагента 1С по структуре Контрагента СБИС, вызывает функцию поиска номенклатуры на сервере 
	МестныйКэш = сбисПолучитьФорму("ФормаГлавноеОкно").Кэш;
	Контрагент = МестныйКэш.ОбщиеФункции.НайтиКонтрагентаИзДокументаСБИС(Ини.Конфигурация, стрКонтрагент);
	сч=0;
	СтрСтрок = Новый Структура;
	Для Каждого СтрТабл Из мТаблДок Цикл
		стр = Новый Структура;
		Стр.Вставить("Контрагент",Контрагент);
		Стр.Вставить("Название",СтрТабл.Название);
		Стр.Вставить("Идентификатор",СтрТабл.Идентификатор);
		
		СтрСтрок.Вставить("СтрТабл_"+Строка(Сч),Стр);
		Сч=сч+1;
	КонецЦикла;
	
	Возврат НайтиНоменклатуруПоставщикаПоТабличнойЧастиНаСервере(СтрСтрок, Ини.Конфигурация);
КонецФункции
Функция НайтиНоменклатуруПоставщикаПоТабличнойЧастиНаСервере(стрНоменклатураПоставщикаВсе, ИниКонфигурация) Экспорт
// ищет запись с определенной номенклатурой поставщика по реквизитам, указанным в файле настроек
// возвращает структуру с полями Номенклатура и Характеристика	
	Для Каждого стрНоменклатураПоставщика Из стрНоменклатураПоставщикаВсе Цикл
		Результат = НайтиНоменклатуруПоставщикаНаСервере(стрНоменклатураПоставщика.Значение, ИниКонфигурация);	
		стрНоменклатураПоставщика.Значение.Вставить("НоменклатураПоставщика",Результат);
	КонецЦикла;
	Возврат стрНоменклатураПоставщикаВсе; 
КонецФункции

&НаКлиенте
Функция НайтиНоменклатуруПоставщика(стрКонтрагент, знач стрНоменклатураПоставщика, КаталогНастроек, Ини) Экспорт
// получает контрагента 1С по структуре Контрагента СБИС, вызывает функцию поиска номенклатуры на сервере 
	МестныйКэш = сбисПолучитьФорму("ФормаГлавноеОкно").Кэш;
	Контрагент = МестныйКэш.ОбщиеФункции.НайтиКонтрагентаИзДокументаСБИС(Ини.Конфигурация, стрКонтрагент);
	стрНоменклатураПоставщика.Вставить("Контрагент", Контрагент);
	Возврат НайтиНоменклатуруПоставщикаНаСервере(стрНоменклатураПоставщика, Ини.Конфигурация);	
КонецФункции
&НаКлиенте
Процедура УстановитьСоответствиеНоменклатуры(стрКонтрагент,знач стрНоменклатураПоставщика, КаталогНастроек, Ини) Экспорт
// Получает контрагента 1С по структуре Контрагента СБИС, вызывает процедуру установки соответствия номенклатуры на сервере 
	МестныйКэш = сбисПолучитьФорму("ФормаГлавноеОкно").Кэш;
	Контрагент = МестныйКэш.ОбщиеФункции.НайтиКонтрагентаИзДокументаСБИС(Ини.Конфигурация, стрКонтрагент);
	стрНоменклатураПоставщика.Вставить("Контрагент", Контрагент);
	УстановитьСоответствиеНоменклатурыНаСервере( стрНоменклатураПоставщика, Ини.Конфигурация);
КонецПроцедуры
Функция НайтиНоменклатуруПоставщикаНаСервере(стрНоменклатураПоставщика, ИниКонфигурация) Экспорт
// ищет запись с определенной номенклатурой поставщика по реквизитам, указанным в файле настроек
// возвращает структуру с полями Номенклатура и Характеристика	
	НоменклатураПоставщика = ПолучитьНоменклатуруПоставщикаНаСервере(стрНоменклатураПоставщика, ИниКонфигурация);
	Результат = Новый Структура("Номенклатура, Характеристика");
	
	Если НоменклатураПоставщика<>Неопределено Тогда
		НоменклатураПоставщика = НоменклатураПоставщика.Получить(0);
		ИмяРеквизитаНоменклатуры = сред(ИниКонфигурация.НоменклатураПоставщиков_Номенклатура.Значение,Найти(ИниКонфигурация.НоменклатураПоставщиков_Номенклатура.Значение,".")+1);
		Если ЗначениеЗаполнено(НоменклатураПоставщика[ИмяРеквизитаНоменклатуры]) Тогда
			Результат.Номенклатура = НоменклатураПоставщика[ИмяРеквизитаНоменклатуры];	
			Если ИниКонфигурация.Свойство("НоменклатураПоставщиков_Характеристика") и ИниКонфигурация.НоменклатураПоставщиков_Характеристика.Значение<>"''" Тогда
				ИмяРеквизитаХарактеристики = сред(ИниКонфигурация.НоменклатураПоставщиков_Характеристика.Значение,Найти(ИниКонфигурация.НоменклатураПоставщиков_Характеристика.Значение,".")+1);
				Если ЗначениеЗаполнено(ИмяРеквизитаХарактеристики) и ЗначениеЗаполнено(НоменклатураПоставщика[ИмяРеквизитаХарактеристики]) Тогда
					Результат.Характеристика = НоменклатураПоставщика[ИмяРеквизитаХарактеристики];	
				КонецЕсли;
			КонецЕсли;
			Возврат Результат;
		Иначе
			Возврат Неопределено;
		КонецЕсли;		
	КонецЕсли;
	
	Возврат Неопределено;
КонецФункции
Функция ПолучитьНоменклатуруПоставщикаНаСервере(стрНоменклатураПоставщика, ИниКонфигурация) Экспорт
// получает запись справочника или регистра сведений номенклатуры поставщика по реквизитам, указанным в файле настроек	
	Если Не стрНоменклатураПоставщика.Свойство("Идентификатор") или Не ЗначениеЗаполнено(стрНоменклатураПоставщика.Идентификатор) Тогда
        стрНоменклатураПоставщика.Вставить("Идентификатор", стрНоменклатураПоставщика.Название);
    КонецЕсли;
	ЗнПер = ИниКонфигурация.НоменклатураПоставщиков.Значение;
	Если Найти(ЗнПер,"РегистрыСведений")=1 и ИниКонфигурация.НоменклатураПоставщиков.Свойство("Отбор") Тогда	// ссылка на регистр сведений
    	ИмяРег=сред(ЗнПер,18);
		Отбор = Новый Структура;
		НаборЗаписей = РегистрыСведений[ИмяРег].СоздатьНаборЗаписей();
		Для Каждого Элемент Из ИниКонфигурация.НоменклатураПоставщиков.Отбор Цикл
			Отбор.Вставить(Элемент.Ключ,ПолучитьЗначениеИзСтруктуры(ИниКонфигурация[Элемент.Значение].Данные, стрНоменклатураПоставщика));
		КонецЦикла;
		Если Отбор.Количество()>0 Тогда
			// извращенный метод получения набора записей регистра, т.к. ищем запись по идентификатору, а он лежит в ресурсах, а не в измерениях, а отбор можно устанавливать только по измерениям
			Измерения = Метаданные.РегистрыСведений[ИмяРег].Измерения;
			Запрос = Новый Запрос;
			Запрос.Текст="ВЫБРАТЬ ";
			Для Каждого Измерение Из Измерения Цикл 
				Запрос.Текст=Запрос.Текст+"Рег."+Измерение.Имя+",";
			КонецЦикла;
			Запрос.Текст = Лев(Запрос.Текст, СтрДлина(Запрос.Текст)-1);
			Запрос.Текст = Запрос.Текст + "
				|ИЗ
				|   РегистрСведений."+ИмяРег+" КАК Рег
				|ГДЕ
				| ";
			Для Каждого Элемент Из Отбор Цикл
				Запрос.УстановитьПараметр(Элемент.Ключ, Элемент.Значение);
				Запрос.Текст=Запрос.Текст+"Рег."+Элемент.Ключ+"=&"+Элемент.Ключ+" И ";
			КонецЦикла;
			Запрос.Текст = Лев(Запрос.Текст, СтрДлина(Запрос.Текст)-3);
			Выборка = Запрос.Выполнить().Выбрать();
			Если Выборка.Количество()>0 Тогда
				Пока Выборка.Следующий() Цикл
					Для Каждого Измерение Из Измерения Цикл 
						Если ЗначениеЗаполнено(Выборка[Измерение.Имя]) Тогда
							НаборЗаписей.Отбор[Измерение.Имя].Установить(Выборка[Измерение.Имя]);
						КонецЕсли;
					КонецЦикла;
				    НаборЗаписей.Прочитать();
					Прервать;
				КонецЦикла;
				Если НаборЗаписей.Количество()>0 Тогда
					Возврат НаборЗаписей;
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
	Иначе
		// надо как-то обругаться, что неверно настройки указаны	
	КонецЕсли;
КонецФункции
Процедура УстановитьСоответствиеНоменклатурыНаСервере( стрНоменклатураПоставщика, ИниКонфигурация) Экспорт
// Процедура устанавливает/удаляет соответствие номенклатуры	
	Если Не ЗначениеЗаполнено(стрНоменклатураПоставщика.Идентификатор) Тогда
		стрНоменклатураПоставщика.Идентификатор = стрНоменклатураПоставщика.Название;
	КонецЕсли;
	
	НоменклатураПоставщиков = ПолучитьНоменклатуруПоставщикаНаСервере( стрНоменклатураПоставщика, ИниКонфигурация);
	
	Если НоменклатураПоставщиков<>Неопределено Тогда    // если уже есть запись в регистре, то надо ее удалить, а потом добавить новую (если править найденную запись, то при сохранении набора будет ругаться на несоответствие отбору)
		НоменклатураПоставщиковЗапись = НоменклатураПоставщиков.Получить(0);
		НоменклатураПоставщиков.Удалить(НоменклатураПоставщиковЗапись);
		НоменклатураПоставщиков.Записать();	
	КонецЕсли;
	Если ЗначениеЗаполнено(стрНоменклатураПоставщика.Номенклатура) Тогда
		ИмяРег=сред(ИниКонфигурация.НоменклатураПоставщиков.Значение,18);
		НоменклатураПоставщиков = РегистрыСведений[ИмяРег].СоздатьНаборЗаписей();
		НоменклатураПоставщиков.Прочитать();
		НоменклатураПоставщиковЗапись = НоменклатураПоставщиков.Добавить();
		ЗаполнитьРеквизиты(стрНоменклатураПоставщика,"НоменклатураПоставщиков",ИниКонфигурация,НоменклатураПоставщиковЗапись);
		НоменклатураПоставщиков.Записать();
	КонецЕсли;	
КонецПроцедуры

Функция ЗаполнитьРеквизиты(стрНоменклатураПоставщика,Раздел,Ини,Объект1С) Экспорт
// Функция используется при заполнении реквизитов номенклатуры поставщика по файлу настроек
	Длина = СтрДлина(Раздел);
	Для Каждого Параметр Из ини Цикл
		Если  Лев(Параметр.Ключ,Длина+1)=Раздел+"_" Тогда
			ИмяРеквизита=сред(Параметр.Значение.Значение,Найти(Параметр.Значение.Значение,".")+1);
			Попытка
				Объект1С[ИмяРеквизита]=ПолучитьЗначениеИзСтруктуры(Параметр.Значение.Данные, стрНоменклатураПоставщика);
			Исключение
			КонецПопытки;
		КонецЕсли;
	КонецЦикла;
КонецФункции
Функция ПолучитьЗначениеИзСтруктуры(Путь, знач стрНоменклатураПоставщика)
	ПутьКДанным = РазбитьСтрокуВМассив(Путь, ".");
	ЗначениеРеквизита = стрНоменклатураПоставщика;	
	Для Каждого Узел Из ПутьКДанным Цикл
		Попытка
			ЗначениеРеквизита = ЗначениеРеквизита[Узел];
		Исключение
			Возврат Неопределено;
		КонецПопытки;
	КонецЦикла;
	Возврат ЗначениеРеквизита;
КонецФункции
функция РазбитьСтрокуВМассив(знач Строка, Разделитель) Экспорт
	МассивЭлементов = Новый Массив();
	Если Строка<>"" Тогда
		ЕстьРазделитель = Истина;
		Пока ЕстьРазделитель И Строка<>"" И Разделитель<>"" Цикл
			Если Найти(Строка,Разделитель)=0 Тогда
				Прервать;
			КонецЕсли;
			Элемент = Сред(Строка,1,Найти(Строка,Разделитель)-1);
			МассивЭлементов.Добавить(Элемент);
			Строка = Сред(Строка,Найти(Строка,Разделитель)+1);
		КонецЦикла;
		МассивЭлементов.Добавить(Строка);
	КонецЕсли;
	Возврат МассивЭлементов;
КонецФункции
&НаКлиенте
Функция ПолучитьИдентификаторНоменклатурыПоставщика(стрКонтрагент, стрНоменклатура, КаталогНастроек, Ини) Экспорт
// Процедура ищет идентификатор номенклатуры контрагента	
	МестныйКэш = сбисПолучитьФорму("ФормаГлавноеОкно").Кэш;
	Контрагент = МестныйКэш.ОбщиеФункции.НайтиКонтрагентаИзДокументаСБИС(Ини.Конфигурация, стрКонтрагент);
	Возврат ПолучитьИдентификаторНоменклатурыПоставщикаНаСервере(Контрагент, стрНоменклатура, Ини.Конфигурация);
КонецФункции
Функция ПолучитьИдентификаторНоменклатурыПоставщикаНаСервере(Контрагент, стрНоменклатура, ИниКонфигурация) Экспорт
// Процедура ищет идентификатор номенклатуры контрагента	
	ЗнПер = ИниКонфигурация.НоменклатураПоставщиков.Значение;
	Если Найти(ЗнПер,"РегистрыСведений")=1 Тогда	// ссылка на регистр сведений
    	ИмяРег=сред(ЗнПер,18);
		НаборЗаписей = РегистрыСведений[ИмяРег].СоздатьНаборЗаписей();
		ИмяРеквизитаКонтрагента = Сред(ИниКонфигурация.НоменклатураПоставщиков_Контрагент.Значение, Найти(ИниКонфигурация.НоменклатураПоставщиков_Контрагент.Значение,".")+1);
		ИмяРеквизитаНоменклатуры = Сред(ИниКонфигурация.НоменклатураПоставщиков_Номенклатура.Значение, Найти(ИниКонфигурация.НоменклатураПоставщиков_Номенклатура.Значение,".")+1);
		ИмяРеквизитаХарактеристики = Сред(ИниКонфигурация.НоменклатураПоставщиков_Характеристика.Значение, Найти(ИниКонфигурация.НоменклатураПоставщиков_Характеристика.Значение,".")+1);
		ИмяРеквизитаИдентификатора = Сред(ИниКонфигурация.НоменклатураПоставщиков_Идентификатор.Значение, Найти(ИниКонфигурация.НоменклатураПоставщиков_Идентификатор.Значение,".")+1);
		НаборЗаписей.Отбор[ИмяРеквизитаКонтрагента].Установить(Контрагент);
		НаборЗаписей.Отбор[ИмяРеквизитаНоменклатуры].Установить(стрНоменклатура.Номенклатура);
		Если ЗначениеЗаполнено(стрНоменклатура.Характеристика) Тогда
			НаборЗаписей.Отбор[ИмяРеквизитаХарактеристики].Установить(стрНоменклатура.Характеристика);
		КонецЕсли;
		НаборЗаписей.Прочитать();
		Если НаборЗаписей.Количество()>0 Тогда
			Возврат НаборЗаписей.Получить(0)[ИмяРеквизитаИдентификатора];
		КонецЕсли;
	КонецЕсли;
	Возврат "";
КонецФункции
