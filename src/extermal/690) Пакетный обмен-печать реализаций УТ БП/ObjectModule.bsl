﻿Процедура ПеренестиДокиВБухгалтерию(Список) Экспорт
		
	НаименованиеОбработки="УниверсальныйОбменДаннымиXMLv2";
	Если Метаданные.Обработки.Найти("УниверсальныйОбменДаннымиXMLv2") = Неопределено Тогда
		НаименованиеОбработки="УниверсальныйОбменДаннымиXML";
	КонецЕсли;	
	Обработка = Обработки[НаименованиеОбработки].Создать();
	
	удалитьфайлы(КаталогВременныхФайлов(),"*.mxl");

	Обработка.РежимОбмена = "Выгрузка";
	
	УникальныйИдентификатор        = Новый УникальныйИдентификатор();
	ИмяВременногоФайлаПравилОбмена = КаталогВременныхФайлов() + УникальныйИдентификатор + ".xml";

	МакетПравилОбмена = ПолучитьОбщийМакет("ОбменУТБП");//ПланыОбмена.ОбменУТ_БП.ПолучитьМакет("ПравилаОбменаСБухгалтерией");
	МакетПравилОбмена.Записать(ИмяВременногоФайлаПравилОбмена);
	
	Обработка.ИмяФайлаПравилОбмена = ИмяВременногоФайлаПравилОбмена;
	
	Обработка.ЗагружатьДанныеВРежимеОбмена = Истина;
	Обработка.ЗаписыватьРегистрыНаборамиЗаписей = Истина;
	Обработка.ЗапоминатьЗагруженныеОбъекты = Истина;
	Обработка.ИспользоватьОтборПоДатеДляВсехОбъектов = Истина;
	//
	
	
	РежимОтладки = истина;
	
	Если НЕ РежимОтладки Тогда
		Обработка.ИмяСервераИнформационнойБазыДляПодключения      = "server:3041"; //01.07.2013
		Обработка.ИмяИнформационнойБазыНаСервереДляПодключения    = "v83ib_yst_bp";
		Обработка.ВерсияПлатформыИнформационнойБазыДляПодключения = "V83";
	Иначе
		Обработка.ИмяСервераИнформационнойБазыДляПодключения      = "server:3041";
		Обработка.ИмяИнформационнойБазыНаСервереДляПодключения    = "v83ib_yst_bp_copy";
		Обработка.ВерсияПлатформыИнформационнойБазыДляПодключения = "V83";
	КонецЕсли;
	
	Обработка.ТипИнформационнойБазыДляПодключения = Ложь;
	Обработка.ВыгружатьТолькоРазрешенные = Истина;
	Обработка.ПользовательИнформационнойБазыДляПодключения = "Робот (центр - номенклатура)";
	Обработка.ПарольИнформационнойБазыДляПодключения = "09876";
	Обработка.АутентификацияWindowsИнформационнойБазыДляПодключения = Ложь;
	Обработка.НепосредственноеЧтениеВИБПриемнике = Истина;
	Обработка.ТипУдаленияРегистрацииИзмененийДляУзловОбменаПослеВыгрузки = 0; // 0 - не снимать регистрацию,
	

	Обработка.ЗагрузитьПравилаОбмена();
	//Список = Новый СписокЗначений();
	//Список.Добавить(ЭтотОбъект.Ссылка);
	Обработка.Параметры.Вставить("ОбъектДляВыгрузки",Список);
	Обработка.ВыполнитьВыгрузку();
	
	
	
	для каждого реализация из Список цикл 	
		
		докОб = реализация.Значение.ПолучитьОбъект();
		Попытка
			УПД = Новый ХранилищеЗначения(Новый ДвоичныеДанные(КаталогВременныхфайлов()+докОб.Номер+".mxl"));
			докОб.КонтрольСумма = докОб.СуммаДокумента;
			докОб.КонтрольКоличество = докОб.Товары.Итог("Количество");
			докОб.Записать(РежимЗаписиДокумента.Запись);
		Исключение
			Сообщить("Что-то пошло не так при записи документов реализации");	
		КонецПопытки;
	КонецЦикла;
	
	Сообщить(строка(ТекущаяДата())+"Загрузка окончена. ");	
	

конецПроцедуры	
