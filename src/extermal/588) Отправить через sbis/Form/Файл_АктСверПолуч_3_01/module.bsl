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
//------------------------------------------------------
&НаКлиенте
Функция ПолучитьДанныеИзДокумента1С(Кэш,Контекст) Экспорт
// вызываем ту же функцию из формы Файл_СчФктр_3_01	
	фрм = Кэш.ГлавноеОкно.сбисНайтиФормуФункции("ПолучитьДанныеИзДокумента1С","Файл_АктСвер_3_01","", Кэш);
	Возврат фрм.ПолучитьДанныеИзДокумента1С(Кэш,Контекст);		
КонецФункции
&НаКлиенте
Функция СформироватьРасхождение(СтруктураФайлаКонтрагента, СтруктураФайлаНаша, Кэш) Экспорт
	Док = СтруктураФайлаНаша;
	ШаблонXML = Кэш.ОбщиеФункции.ПолучитьXMLДокумента1С(Док);
	ТекстHTML = Кэш.Интеграция.ПолучитьHTMLПоXML(Кэш, ШаблонXML);
	Вложение = Новый Структура("СтруктураФайла,XMLДокумента,Название,ТекстHTML", Док, ШаблонXML, СтруктураФайлаНаша.Файл.Документ.Название,ТекстHTML);
	Возврат Вложение;
КонецФункции