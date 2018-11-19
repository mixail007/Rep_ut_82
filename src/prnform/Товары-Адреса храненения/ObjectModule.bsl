﻿
//--------------Общая выборка для любого документа с ТЧ  ТоварыАдресноеХранение ----------------------------
// получает съитоженную выборку по Номенклатуре
функция ПолучитьВыборкуТоваровАдресноеХранение()
	
	
	типДок = СсылкаНаОбъект.Метаданные().Имя;
	
	ЗапросПоТоварам = Новый Запрос();
	ЗапросПоТоварам.УстановитьПараметр("ТекущийДокумент", СсылкаНаОбъект);
	ЗапросПоТоварам.УстановитьПараметр("ПустойСклад", справочники.склады.ПустаяСсылка());
			
		ЗапросПоТоварам.текст = "ВЫБРАТЬ РАЗЛИЧНЫЕ
		                        |	ЕСТЬNULL(Товары.НомерСтроки, 0) КАК НомерСтроки,
		                        |	ЕСТЬNULL(Товары.Номенклатура, ВложенныйЗапрос.Номенклатура) КАК Номенклатура,
		                        |	ЕСТЬNULL(Товары.Количество, 0) КАК Количество,
		                        |	ЕСТЬNULL(ВложенныйЗапрос.АдресХранения, """") КАК Адрес,
		                        |	ЕСТЬNULL(Товары.КоличествоПМ, ЕСТЬNULL(ВложенныйЗапрос.КоличествоПМ,0)) КАК КоличествоПМ,
		                        |	ЕСТЬNULL(ВложенныйЗапрос.Количество, 0) КАК КоличествоФакт,
		                        |	ЕСТЬNULL(ВложенныйЗапрос.Количество, 0) КАК КоличествоФактПМ
		                        |ИЗ
		                        |	(ВЫБРАТЬ РАЗЛИЧНЫЕ
		                        |		ПоступлениеТоваровУслугТоварыАдресноеХранение.Номенклатура КАК Номенклатура,
		                        |		ПоступлениеТоваровУслугТоварыАдресноеХранение.АдресХранения КАК АдресХранения,
		                        |		ПоступлениеТоваровУслугТоварыАдресноеХранение.Количество КАК Количество,
		                        |		ПоступлениеТоваровУслугТоварыАдресноеХранение.Склад КАК Склад,
		                        |		ЕСТЬNULL(НормыПаллетирования.Количество, 0) КАК КоличествоПМ
		                        |	ИЗ
		                        |		Документ.ПоступлениеТоваровУслуг.ТоварыАдресноеХранение КАК ПоступлениеТоваровУслугТоварыАдресноеХранение
		                        |			ЛЕВОЕ СОЕДИНЕНИЕ Справочник.НормыПаллетирования КАК НормыПаллетирования
		                        |			ПО ПоступлениеТоваровУслугТоварыАдресноеХранение.Номенклатура.Типоразмер.Ширина = НормыПаллетирования.Ширина
		                        |				И ПоступлениеТоваровУслугТоварыАдресноеХранение.Номенклатура.Типоразмер.Диаметр = НормыПаллетирования.Диаметр
		                        |	ГДЕ
		                        |		ПоступлениеТоваровУслугТоварыАдресноеХранение.Ссылка = &ТекущийДокумент) КАК ВложенныйЗапрос
		                        |		ПОЛНОЕ СОЕДИНЕНИЕ (ВЫБРАТЬ РАЗЛИЧНЫЕ
		                        |			СРЕДНЕЕ(ТЧТовары.НомерСтроки) КАК НомерСтроки,
		                        |			ТЧТовары.Номенклатура КАК Номенклатура,
		                        |			ВЫБОР
		                        |				КОГДА ТЧТовары.Склад = &ПустойСклад
		                        |					ТОГДА ТЧТовары.Ссылка.СкладОрдер
		                        |				ИНАЧЕ ТЧТовары.Склад
		                        |			КОНЕЦ КАК Склад,
		                        |			СРЕДНЕЕ(ТЧТовары.Количество) КАК Количество,
		                        |			МАКСИМУМ(НормыПаллетирования.Количество) КАК КоличествоПМ
		                        |		ИЗ
		                        |			Документ.ПоступлениеТоваровУслуг.Товары КАК ТЧТовары
		                        |				ЛЕВОЕ СОЕДИНЕНИЕ Справочник.НормыПаллетирования КАК НормыПаллетирования
		                        |				ПО ТЧТовары.Номенклатура.Типоразмер.Ширина = НормыПаллетирования.Ширина
		                        |					И ТЧТовары.Номенклатура.Типоразмер.Диаметр = НормыПаллетирования.Диаметр
		                        |		ГДЕ
		                        |			ТЧТовары.Ссылка = &ТекущийДокумент
		                        |			И (ТЧТовары.Склад.АдресноеХранение
		                        |					ИЛИ ТЧТовары.Склад = &ПустойСклад)
		                       //склад в шапке - не обязательно адресный 
							   //|			И ТЧТовары.Ссылка.СкладОрдер.АдресноеХранение
		                        |		
		                        |		СГРУППИРОВАТЬ ПО
		                        |			ТЧТовары.Номенклатура,
		                        |			ВЫБОР
		                        |				КОГДА ТЧТовары.Склад = &ПустойСклад
		                        |					ТОГДА ТЧТовары.Ссылка.СкладОрдер
		                        |				ИНАЧЕ ТЧТовары.Склад
		                        |			КОНЕЦ) КАК Товары
		                        |		ПО ВложенныйЗапрос.Номенклатура = Товары.Номенклатура
								|			И Выбор КОГДА Товары.Склад = &ПустойСклад тогда Истина
								|					иначе ( ВложенныйЗапрос.Склад = Товары.Склад )
								|			  Конец
		                        |		
		                        |
		                        |УПОРЯДОЧИТЬ ПО
		                        |	НомерСтроки,
		                        |	Адрес
		                        |ИТОГИ
		                        |	МИНИМУМ(НомерСтроки),
		                        |	МАКСИМУМ(Количество),
		                        |	МАКСИМУМ(КоличествоПМ),
		                        |	СУММА(КоличествоФакт),
		                        |	СУММА(КоличествоФактПМ)
		                        |ПО
		                        |	Номенклатура
		                        |АВТОУПОРЯДОЧИВАНИЕ";

	// другие документы - аналогично!						
	Если типДок<>"ПоступлениеТоваровУслуг" тогда
		ЗапросПоТоварам.текст = стрЗаменить(ЗапросПоТоварам.текст, "ПоступлениеТоваровУслуг", типДок);
	КонецЕсли;	
	
	Если типДок = "ПеремещениеТоваров" тогда
		Если значениеЗаполнено(СсылкаНаОбъект.ВнутреннийЗаказ) и СсылкаНаОбъект.СкладОтправитель.АдресноеХранение тогда
			ЗапросПоТоварам.текст = стрЗаменить(ЗапросПоТоварам.текст, ".СкладОрдер", ".СкладОтправитель");
		иначе //Если НЕ значениеЗаполнено(СсылкаНаОбъект.ВнутреннийЗаказ) и СсылкаНаОбъект.СкладПолучатель.АдресноеХранение тогда
			ЗапросПоТоварам.текст = стрЗаменить(ЗапросПоТоварам.текст, ".СкладОрдер", ".СкладПолучатель");
		КонецЕсли;
	иначеЕсли типДок <> "ПоступлениеТоваровУслуг" и типДок <> "ВозвратТоваровОтПокупателя"  тогда
		ЗапросПоТоварам.текст = стрЗаменить(ЗапросПоТоварам.текст, ".СкладОрдер", ".Склад");
	КонецЕсли;	
		
	ВыборкаСтрокТовары = ЗапросПоТоварам.Выполнить().Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);

	возврат ВыборкаСтрокТовары;

КонецФункции


Функция Печать() экспорт
	
	ДатаПечати = ТекущаяДата();//+++ это очень важно!!!
	//Склад5000  = справочники.Склады.НайтиПоНаименованию("5000");	
  		ВыборкаСтрокТовары = ПолучитьВыборкуТоваровАдресноеХранение();
		ЕстьАдресФакт = истина; // флаг для выборки из выборки...
	

	Макет = ПолучитьМакет("АдресноеХранение");

	ТабДокумент = Новый ТабличныйДокумент;
	ТабДокумент.ИмяПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_ПоступлениеТоваровУслуг_АдресноеХранение";

	// Выводим общие реквизиты шапки
	СведенияОПокупателе = СведенияОЮрФизЛице(СсылкаНаОбъект.Организация, ДатаПечати);

	ОбластьМакета = Макет.ПолучитьОбласть("Шапка");
	ОбластьМакета.Параметры.ДокументПредставление  = строка(СсылкаНаОбъект.Ссылка);
	ОбластьМакета.Параметры.Организация   = ОписаниеОрганизации(СведенияОПокупателе);
	//-----------должны быть такие реквизиты во всех документах!--------------------------
	ОбластьМакета.Параметры.Подразделение = СокрЛП(СсылкаНаОбъект.Подразделение);
	ОбластьМакета.Параметры.Комментарий   = СокрЛП(СсылкаНаОбъект.Комментарий);
	ТабДокумент.Вывести(ОбластьМакета);
    	
	ТолькоРазличия = Истина;//+++ 13.11.2013
	Режим = РежимДиалогаВопрос.ДаНет;
	Ответ = Вопрос("Показывать только различия?", Режим, 10);
	Если Ответ = КодВозвратаДиалога.Нет Тогда
	    ТолькоРазличия = Ложь;
	КонецЕсли;
	
	
	// Выводим заголовок таблицы
	ЗаголовокТаблицы = Макет.ПолучитьОбласть("ЗаголовокТаблицы");
	ЗаголовокТаблицы.Параметры.ТолькоРазличия = ?(ТолькоРазличия, "ТолькоРазличия!", "");
	ТабДокумент.Вывести(ЗаголовокТаблицы);

	СтрокШапки      = 9;
	СтрокНаСтранице = 40;
	СтрокПодвала    = 6;
	НомерСтраницы   = 1;
	
	КоличествоСтрок = ВыборкаСтрокТовары.Количество();
	Если КоличествоСтрок = 1 Тогда
		ПереноситьПоследнююСтроку = 0;
	Иначе
		ЦелыхСтраницСПодвалом     = Цел((СтрокШапки + КоличествоСтрок + СтрокПодвала) / СтрокНаСтранице);
		ЦелыхСтраницБезПодвала    = Цел((СтрокШапки + КоличествоСтрок - 1) / СтрокНаСтранице);
		ПереноситьПоследнююСтроку = ЦелыхСтраницСПодвалом - ЦелыхСтраницБезПодвала;
	КонецЕсли;

	// Инициализация итогов в документе
	ИтогоКоличество     = 0;
	ИтогоКоличествоФакт = 0;
	Ном              = СтрокШапки;
	НомерСтрокиПМ = 0;
    КолНаСтранице = 0;
	КолНаСтраницеФакт=0;
	
	// Выводим многострочную часть докмента
	ОбластьМакета = Макет.ПолучитьОбласть("Строка");
	ОбластьМакета1= Макет.ПолучитьОбласть("Строка1");
	
	ПодвалСтрок   = Макет.ПолучитьОбласть("ПодвалСтрок");
	размер = "";	
	
	номенклатураПредСтроки=справочники.Номенклатура.ПустаяСсылка();
	
	
	//====================Основной цикл====================================================
	Пока ВыборкаСтрокТовары.Следующий() Цикл
		Если номенклатураПредСтроки=ВыборкаСтрокТовары.Номенклатура тогда  //+++ 06.01.2013 защита от дублирования
			продолжить;
		иначе
			номенклатураПредСтроки=ВыборкаСтрокТовары.Номенклатура;
		КонецЕсли;
		
	Ном = Ном + 1; 
		Если ЗначениеНеЗаполнено(ВыборкаСтрокТовары.Номенклатура) Тогда
			Сообщить("В одной из строк не заполнено значение номенклатуры - строка при печати пропущена.", СтатусСообщения.Важное);
			Продолжить;
		КонецЕсли;

		//Начинаем новую страницу, если предыдущая строка была последней на странице
		//или пора переносить последнюю строку на последнюю страницу с подвалом.
		ЦелаяСтраница = (СтрокШапки + Ном - 1) / СтрокНаСтранице;

		Если (ЦелаяСтраница = Цел(ЦелаяСтраница))
		 или ((ПереноситьПоследнююСтроку = 1) и (Ном = КоличествоСтрок)) Тогда
                Ном = 3;
			НомерСтраницы = НомерСтраницы + 1;
			
				 ПодвалСтрок.Параметры.ИтогоПоСтранице = Формат(КолНаСтранице,"ЧДЦ=0; ЧГ=0");
			 ПодвалСтрок.Параметры.ИтогоПоСтраницеФакт = Формат(КолНаСтраницеФакт,"ЧДЦ=0; ЧГ=0");
			ТабДокумент.Вывести(ПодвалСтрок);
			    КолНаСтранице = 0;
            КолНаСтраницеФакт = 0;
			
			ТабДокумент.ВывестиГоризонтальныйРазделительСтраниц();
			
			ЗаголовокТаблицы.Параметры.НомерСтраницы = "Страница N " + НомерСтраницы;
			ТабДокумент.Вывести(ЗаголовокТаблицы);
			
		КонецЕсли;

		ОбластьМакета.Параметры.Заполнить(ВыборкаСтрокТовары);
			ОбластьМакета.Параметры.НоменклатураНаименование = СокрЛП(ВыборкаСтрокТовары.Номенклатура.НаименованиеПолное);
			//09.12.2015
			Если ВыборкаСтрокТовары.Номенклатура.ВидТовара = Перечисления.ВидыТоваров.Аксессуары тогда
			ОбластьМакета.Параметры.Код = СокрЛП(ВыборкаСтрокТовары.Номенклатура.Артикул);
			иначе
			ОбластьМакета.Параметры.Код = СокрЛП(ВыборкаСтрокТовары.Номенклатура.Код);
			КонецЕсли;
		ОбластьМакета.параметры.Склад = "---"; //"";

		//+++ 13.11.2013 количество совпадаем - не выводим строки
		Если ТолькоРазличия тогда
			Если ВыборкаСтрокТовары.Количество=ВыборкаСтрокТовары.КоличествоФакт тогда
				Продолжить;
			КонецЕсли;	
     	КонецЕсли;	
     	ТабДокумент.Вывести(ОбластьМакета);

				
//-----------------цикл по ячейкам-----------------------------------------------------------
	колПМ = ?(ВыборкаСтрокТовары.КоличествоПМ>0, ВыборкаСтрокТовары.КоличествоПМ, ВыборкаСтрокТовары.Количество); //09.12.2015
	КолДопСтрок = Цел( ВыборкаСтрокТовары.Количество / колПМ);
	
	
	Если ЕстьАдресФакт тогда //+++
		ВыборкаСтрокАдреса = ВыборкаСтрокТовары.Выбрать();
   		КолДопСтрок = макс(КолДопСтрок, Цел(ВыборкаСтрокАдреса.Количество()/ колПМ) );
		размер = ВыборкаСтрокТовары.Номенклатура.Типоразмер.Диаметр + "х" + ВыборкаСтрокТовары.Номенклатура.Типоразмер.Ширина+"  ";
	иначе
		ОбластьМакета1.Параметры.Заполнить(ВыборкаСтрокТовары);
		размер = ВыборкаСтрокТовары.Типоразмер.Диаметр + "х" + ВыборкаСтрокТовары.Типоразмер.Ширина+"  ";
	КонецЕсли;	
	
	ОбластьМакета1.Параметры.КоличествоПМ = колПМ;
	ОбластьМакета1.Параметры.ТипоРазмер = размер;
		
	//----- вывод строк -----
	НомСтр = ВыборкаСтрокТовары.НомерСтроки;
	
	для i=1 по КолДопСтрок цикл 
		НомерСтрокиПМ = НомерСтрокиПМ + 1; // порядковый номер строки Адреса
		
		Если ЕстьАдресФакт тогда //+++
			
			Если ВыборкаСтрокАдреса.Следующий() тогда
				ОбластьМакета1.Параметры.КоличествоПМ = 0;
				ОбластьМакета1.Параметры.Заполнить(ВыборкаСтрокАдреса);
				КолНаСтраницеФакт = КолНаСтраницеФакт + ВыборкаСтрокАдреса.КоличествоФактПМ;
			иначе	
   				//прервать; 
				ОбластьМакета1.Параметры.Заполнить(ВыборкаСтрокТовары);
				ОбластьМакета1.Параметры.КоличествоФактПМ = 0;
			КонецЕсли;
		КонецЕсли;
		
		КолНаСтранице = КолНаСтранице + колПМ;
		ОбластьМакета1.Параметры.КоличествоПМ = колПМ;
		ОбластьМакета1.Параметры.НомерСтроки = НомерСтрокиПМ; //Строка(НомСтр)+"-"+строка(i);
        ОбластьМакета1.Параметры.ТипоРазмер = размер;
	    ТабДокумент.Вывести(ОбластьМакета1);
		
		
		//------------------конец страницы-----------------------------
		Если (Ном % СтрокНаСтранице = 0 )
		 или (  (ПереноситьПоследнююСтроку = 1) и (Ном = КоличествоСтрок)  ) Тогда
            Ном = 4;
			НомерСтраницы = НомерСтраницы + 1;
			
			 ПодвалСтрок.Параметры.ИтогоПоСтранице = Формат(КолНаСтранице,"ЧДЦ=0; ЧГ=0");
			 ПодвалСтрок.Параметры.ИтогоПоСтраницеФакт =  Формат(КолНаСтраницеФакт,"ЧДЦ=0; ЧГ=0");
			ТабДокумент.Вывести(ПодвалСтрок);
			    КолНаСтранице = 0;
            КолНаСтраницеФакт = 0;
		
			ТабДокумент.ВывестиГоризонтальныйРазделительСтраниц();
			
			ЗаголовокТаблицы.Параметры.НомерСтраницы = "Страница N " + НомерСтраницы;
			ТабДокумент.Вывести(ЗаголовокТаблицы);
			
			//ОбластьМакета.Параметры.Количество = ОбластьМакета.Параметры.Количество - КолНаСтранице;
			//КолНаСтранице = 0;
			
			ОбластьМакета.параметры.КоличествоФакт = "---";  //промежуточная строка... не нужно общей суммы
			ОбластьМакета.параметры.Склад = "---";
			ТабДокумент.Вывести( ОбластьМакета );
	
		КонецЕсли;
    	Ном = Ном + 1;
	 	
	КонецЦикла; //-----------------------------------------------------------

	КолНеЦелое = ВыборкаСтрокТовары.Количество % колПМ;
	НадоПечатать = истина;

	Если (КолНеЦелое>0) тогда
		
		КолНаСтранице = КолНаСтранице + КолНеЦелое;
		
		Если ЕстьАдресФакт тогда //+++ 111
			ОбластьМакета1.Параметры.КоличествоФактПМ = 0;
	    	Если ВыборкаСтрокАдреса.Следующий() тогда
   				ОбластьМакета1.Параметры.Заполнить(ВыборкаСтрокАдреса);
				КолНаСтраницеФакт = КолНаСтраницеФакт + ВыборкаСтрокАдреса.КоличествоФактПМ;
				НадоПечатать = истина;
			иначе
			//	НадоПечатать = ложь; 
				ОбластьМакета1.Параметры.Заполнить(ВыборкаСтрокТовары);
		   		ОбластьМакета1.Параметры.КоличествоФактПМ = 0;
			 КонецЕсли;
		КонецЕсли;

		Если НадоПечатать тогда   //+++ 222
			НомерСтрокиПМ = НомерСтрокиПМ + 1;
			ОбластьМакета1.Параметры.НомерСтроки =  НомерСтрокиПМ;		// Строка(НомСтр)+"-"+строка(i);
			ОбластьМакета1.Параметры.КоличествоПМ =	КолНеЦелое;
		    ОбластьМакета1.Параметры.ТипоРазмер = размер;
	 		ТабДокумент.Вывести(ОбластьМакета1);
		 	Ном = Ном + 1;//следующий номер товара
		КонецЕсли;
	КонецЕсли;
	
	
	
	
	//+++ 25.01.2013  может быть Количество строк Факт > разбивка по ПМ
	//Если ТипЗнч(СсылкаНаОбъект) <> Тип("ДокументСсылка.ЗаказПоставщику") тогда
		пока ВыборкаСтрокАдреса.Следующий() цикл
			ОбластьМакета1.Параметры.КоличествоФактПМ = 0;
	  		Если ЕстьАдресФакт тогда
					ОбластьМакета1.Параметры.Заполнить(ВыборкаСтрокАдреса);
				КолНаСтраницеФакт = КолНаСтраницеФакт + ВыборкаСтрокАдреса.КоличествоФактПМ;
			иначе
			//	НадоПечатать = ложь; 
				ОбластьМакета1.Параметры.Заполнить(ВыборкаСтрокТовары);
				ОбластьМакета1.Параметры.КоличествоФактПМ =	0;
		  	КонецЕсли;
			НомерСтрокиПМ = НомерСтрокиПМ + 1;
			ОбластьМакета1.Параметры.НомерСтроки = НомерСтрокиПМ;		// Строка(НомСтр)+"-"+строка(i);
			ОбластьМакета1.Параметры.КоличествоПМ =	0;      // уже не надо писать...
			ОбластьМакета1.Параметры.ТипоРазмер = размер;
			
				Если ОбластьМакета1.Параметры.КоличествоФактПМ<>0 и ОбластьМакета1.Параметры.Адрес="" тогда
					ОбластьМакета1.Параметры.КоличествоФактПМ = 0;
				КонецЕсли;	

	 		ТабДокумент.Вывести(ОбластьМакета1);
		 	Ном = Ном + 1;//следующий номер товара
		КонецЦикла;
	//КонецЕсли;
		
		
		
//--------------------------------------------------------------------------------------------------
		ИтогоКоличество 	= ИтогоКоличество     + ВыборкаСтрокТовары.Количество;
		ИтогоКоличествоФакт = ИтогоКоличествоФакт + ВыборкаСтрокТовары.КоличествоФакт;
		
  		Если (Ном % СтрокНаСтранице = 0 )
		 или (  (ПереноситьПоследнююСтроку = 1) и (Ном = КоличествоСтрок)  ) Тогда
            Ном = 3;
			НомерСтраницы = НомерСтраницы + 1;
			
			  ПодвалСтрок.Параметры.ИтогоПоСтранице = Формат(КолНаСтранице,"ЧДЦ=0; ЧГ=0");
			  ПодвалСтрок.Параметры.ИтогоПоСтраницеФакт =  Формат(КолНаСтраницеФакт,"ЧДЦ=0; ЧГ=0");
	 		  ТабДокумент.Вывести(ПодвалСтрок);
		 	    КолНаСтранице = 0;
            КолНаСтраницеФакт = 0;
		
			ТабДокумент.ВывестиГоризонтальныйРазделительСтраниц();
			
			ЗаголовокТаблицы.Параметры.НомерСтраницы = "Страница " + НомерСтраницы;
			ТабДокумент.Вывести(ЗаголовокТаблицы);
			КолНаСтранице     = 0;
			КолНаСтраницеФакт = 0;
		КонецЕсли;
				
	КонецЦикла;
  //=======================================================================
  
	  ПодвалСтрок.Параметры.ИтогоПоСтранице = Формат(КолНаСтранице,"ЧДЦ=0; ЧГ=0");
	  ПодвалСтрок.Параметры.ИтогоПоСтраницеФакт =  Формат(КолНаСтраницеФакт,"ЧДЦ=0; ЧГ=0");
	  ТабДокумент.Вывести(ПодвалСтрок);

	// Выводим итоги по документу
	ОбластьМакета = Макет.ПолучитьОбласть("Итого");
 	ОбластьМакета.Параметры.ИтогоКоличество     = ИтогоКоличество;
	ОбластьМакета.Параметры.ИтогоКоличествоФакт = ИтогоКоличествоФакт;
	ТабДокумент.Вывести(ОбластьМакета);

	// Выводим итоги по документу
	ОбластьМакета = Макет.ПолучитьОбласть("Подвал");
	ОбластьМакета.Параметры.ДолжностьСдал = "";
	ОбластьМакета.Параметры.ФИОСдал = "";
	ОбластьМакета.Параметры.ДолжностьПринял = "";
	ОбластьМакета.Параметры.ФИОПринял = "";
	ТабДокумент.Вывести(ОбластьМакета);

	// Зададим параметры макета
	ТабДокумент.Защита = истина;
	ТабДокумент.ТолькоПросмотр = истина;
	
	Возврат ТабДокумент;

КонецФункции // Печать()
