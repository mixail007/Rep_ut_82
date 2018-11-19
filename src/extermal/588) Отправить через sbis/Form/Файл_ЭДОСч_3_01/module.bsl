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

Функция ПолучитьРеквизитМетаданныхОбъекта(Объект1С, ИмяРеквизита)
	Возврат Объект1С.Метаданные()[ИмяРеквизита];	
КонецФункции

&НаКлиенте
Функция ПолучитьТабличнуюЧастьДокумента1С(Кэш,Контекст) Экспорт
	
	ИмяДокумента = ПолучитьРеквизитМетаданныхОбъекта(Контекст.Документ, "Имя");
	фрм = сбисПолучитьФорму("ФормаГлавноеОкно").сбисНайтиФормуФункции("ПолучитьТабличнуюЧастьДокумента1С","Документ_"+ИмяДокумента,"Файл_Шаблон",Кэш);
	фрм.ПолучитьТабличнуюЧастьДокумента1С(Кэш,Контекст);
	
КонецФункции
