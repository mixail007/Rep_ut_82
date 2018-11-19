﻿
//Заказ по ОТХ - для операции Списание
Функция ПечатьЗаказаОТХ()
	
	// 5000 всегда печатается в порядке обхода склада
	//Ответ= Вопрос("Распечатать в порядке обхода склада?", РежимДиалогаВопрос.ДаНет,0);
	//
	//ФлагПорядкаОбхода=Ложь;
	//
	//Если Ответ = КодВозвратаДиалога.Да Тогда
		ФлагПорядкаОбхода=Истина;
	//КонецЕсли;	
	
	ТабДокумент = Новый ТабличныйДокумент;
	ТабДокумент.ИмяПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_ЗаказПокупателя_СчетЗаказ";
	
	Если СсылкаНаОбъект.ВидОперации <> перечисления.ВидыОперацийПоОтветственномуХранению.Списание тогда
		Предупреждение("Печатная форма ""Расход 5000"" предназначена для операции Списание!");
		Возврат неопределено;
	КонецЕсли;
	
   Макет = ПолучитьМакет("Заказ");

	ОбластьМакета = Макет.ПолучитьОбласть("Заголовок");
	ОбластьМакета.Параметры.ТекстЗаголовка = СформироватьЗаголовокДокумента(СсылкаНаОбъект,"Заказ по ответ.хранению" );
	//+++ Штрих-Код номера документа - февраль 2012
	// требуется установленная компонента 1CBarCode.exe
    	ОбШтрихКодСообщение = глТорговоеОборудование.ПолучитьШтрихКодПоДокументу(СсылкаНаОбъект);
		попытка
		ОбШтрихКод=ОбластьМакета.Рисунки.ШК.Объект;
		ОбШтрихКод.Сообщение = ОбШтрихКодСообщение; 
		ОбШтрихКод.ТекстКода = ОбШтрихКодСообщение; 
		//ОбШтрихКод.ВидимостьКС = ЛОЖЬ; // не показывать контрольныйСимвол в тексте
		исключение
		 //нет компоненты 1CBarCode.exe
		КонецПопытки; 
	//+++)
	ТабДокумент.Вывести(ОбластьМакета);

	ОбластьМакета = Макет.ПолучитьОбласть("Поставщик");
	//ОбластьМакета.Параметры.Заполнить(Шапка);
	ОбластьМакета.Параметры.ПредставлениеПоставщика = ОписаниеОрганизации(СведенияОЮрФизЛице(СсылкаНаОбъект.Организация, СсылкаНаОбъект.Дата), "ИНН,КПП,ПолноеНаименование,ЮридическийАдрес,Телефоны,");
	ОбластьМакета.Параметры.ПоставщикТекст = "Поставщик:";//+++
	ТабДокумент.Вывести(ОбластьМакета);

	//СведенияОПолучателе = СведенияОЮрФизЛице(Шапка.Получатель, Шапка.Дата);
	ОбластьМакета = Макет.ПолучитьОбласть("Покупатель");
	//ОбластьМакета.Параметры.Заполнить(Шапка);
	ОбластьМакета.Параметры.ПредставлениеПолучателя = ОписаниеОрганизации(СведенияОЮрФизЛице(СсылкаНаОбъект.КОнтрагент, СсылкаНаОбъект.Дата), "ИНН,КПП,ПолноеНаименование,ЮридическийАдрес,Телефоны,");
	ОбластьМакета.Параметры.ПокупательТекст = "Покупатель:";
	ТабДокумент.Вывести(ОбластьМакета);

		
	ОбластьМакета = Макет.ПолучитьОбласть("ШапкаТаблицы");
	ТабДокумент.Вывести(ОбластьМакета);
	
	
	Запрос = Новый Запрос;
//Запрос.Текст = "ВЫБРАТЬ
//			   |	ЕСТЬNULL(ЗаказыПокупателей.НомерСтроки, 1000) КАК НомерСтроки,
//			   |	ЗаказыПокупателейОстатки.Номенклатура КАК Номенклатура,
//			   |	ЗаказыПокупателейОстатки.КоличествоОстаток КАК КоличествоЗаказано,
//			   |	ЕСТЬNULL(ТоварыАдресноеХранениеОстатки.АдресХранения, """") КАК АдресХранения,
//			   |	ЕСТЬNULL(ТоварыАдресноеХранениеОстатки.КоличествоОстаток, 0) КАК КоличествоОстаток,
//			   |	ЕСТЬNULL(ТоварыАдресноеХранениеОстатки1.КоличествоОстаток, 0) КАК КоличествоОстаток2
//			   |ИЗ
//			   |	РегистрНакопления.ЗаказыПокупателей.Остатки(, ЗаказПокупателя = &ЗаказПокупателя) КАК ЗаказыПокупателейОстатки
//			   |		ЛЕВОЕ СОЕДИНЕНИЕ (ВЫБРАТЬ
//			   |			ЗаказПокупателяТовары.НомерСтроки КАК НомерСтроки,
//			   |			ЗаказПокупателяТовары.Номенклатура КАК Номенклатура
//			   |		ИЗ
//			   |			Документ.ЗаказПокупателя.Товары КАК ЗаказПокупателяТовары
//			   |		ГДЕ
//			   |			ЗаказПокупателяТовары.Ссылка = &ЗаказПокупателя) КАК ЗаказыПокупателей
//			   |		ПО ЗаказыПокупателейОстатки.Номенклатура = ЗаказыПокупателей.Номенклатура
//			   |		ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.ТоварыАдресноеХранение.Остатки(, Склад = &Склад5000) КАК ТоварыАдресноеХранениеОстатки
//			   |			ЛЕВОЕ СОЕДИНЕНИЕ (ВЫБРАТЬ РАЗЛИЧНЫЕ
//			   |				РНАдреса.АдресХранения КАК АдресХранения,
//			   |				РНАдреса.КоличествоОстаток КАК КоличествоОстаток
//			   |			ИЗ
//			   |				РегистрНакопления.ТоварыАдресноеХранение.Остатки(, Склад = &Склад5000) КАК РНАдреса) КАК ТоварыАдресноеХранениеОстатки1
//			   |			ПО ТоварыАдресноеХранениеОстатки.АдресХранения = ТоварыАдресноеХранениеОстатки1.АдресХранения
//			   |		ПО ЗаказыПокупателейОстатки.Номенклатура = ТоварыАдресноеХранениеОстатки.Номенклатура
//			   |
//			   |УПОРЯДОЧИТЬ ПО
//			   |	ТоварыАдресноеХранениеОстатки.АдресХранения.Порядок
//			   |ИТОГИ
//			   |	СРЕДНЕЕ(НомерСтроки),
//			   |	СРЕДНЕЕ(КоличествоЗаказано),
//			   |	СУММА(КоличествоОстаток),
//			   |	СУММА(КоличествоОстаток2)
//			   |ПО
//			   |	Номенклатура";

Запрос.УстановитьПараметр("Ссылка", СсылкаНаОбъект);

 Запрос.Текст = "ВЫБРАТЬ
                |	ЕСТЬNULL(ЗаказыПоОТХ.НомерСтроки, 1000) КАК НомерСтроки,
                |	ЗаказыПоОТХ.Номенклатура КАК Номенклатура,
                |	ЗаказыПоОТХ.Количество КАК КоличествоЗаказано,
                |	ЕСТЬNULL(ТоварыАдресноеХранениеОстатки.АдресХранения, """") КАК АдресХранения,
                |	ЕСТЬNULL(ТоварыАдресноеХранениеОстатки.КоличествоОстаток, 0) КАК КоличествоОстаток,
                |	ЕСТЬNULL(ТоварыАдресноеХранениеОстатки1.КоличествоОстаток, 0) КАК КоличествоОстаток2
                |ИЗ
                |	Документ.ЗаказПоОтветственномуХранению.Товары КАК ЗаказыПоОТХ
                |		ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.ТоварыАдресноеХранение.Остатки(, Склад В (&Склад5000)) КАК ТоварыАдресноеХранениеОстатки
                |			ЛЕВОЕ СОЕДИНЕНИЕ (ВЫБРАТЬ РАЗЛИЧНЫЕ
                |				РНАдреса.АдресХранения КАК АдресХранения,
                |				РНАдреса.КоличествоОстаток КАК КоличествоОстаток
                |			ИЗ
                |				РегистрНакопления.ТоварыАдресноеХранение.Остатки(, Склад В (&Склад5000)) КАК РНАдреса) КАК ТоварыАдресноеХранениеОстатки1
                |			ПО ТоварыАдресноеХранениеОстатки.АдресХранения = ТоварыАдресноеХранениеОстатки1.АдресХранения
                |		ПО ЗаказыПоОТХ.Номенклатура = ТоварыАдресноеХранениеОстатки.Номенклатура
                |ГДЕ
                |	ЗаказыПоОТХ.Ссылка = &Ссылка
                |
                |УПОРЯДОЧИТЬ ПО ТоварыАдресноеХранениеОстатки.АдресХранения.Порядок
                |ИТОГИ
                |	СРЕДНЕЕ(НомерСтроки),
                |	СРЕДНЕЕ(КоличествоЗаказано),
                |	СУММА(КоличествоОстаток),
                |	СУММА(КоличествоОстаток2)
                |ПО
                |	Номенклатура";

Если ФлагПорядкаОбхода Тогда
	
Иначе
	Запрос.Текст=СтрЗаменить(Запрос.Текст,"ПО АдресХранения.Порядок","ПО НомерСтроки");
КонецЕсли;	

//+++ 30.09.2013
Запрос.УстановитьПараметр("Склад5000", ?(СсылкаНаОбъект.Подразделение=справочники.Подразделения.НайтиПоКоду("00106"), Справочники.Склады.НайтиПоКоду("00791"), Справочники.Склады.НайтиПоКоду("00642"))  );

	
	Результат = Запрос.Выполнить();
	
	КоличествоСтрок=0;
	КоличествоЗаказаноИтого=0;
	КоличествоLegeArtis=0;
	КоличествоВзятьИтого=0;
	Если не Результат.Пустой() Тогда
		//ТабДокумент.Вывести(ОбластьМакета);
		//ТабДокумент.НачатьАвтогруппировкуСтрок();
		
		ВыборкаНоменклатура = Результат.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
		КоррСтр=0;
		
		Пока ВыборкаНоменклатура.Следующий() Цикл
			СтрокВыводитьДополнительно=2;
			КоличествоСтрок=КоличествоСтрок+1;
			КоличествоЗаказаноИтого=КоличествоЗаказаноИтого+ВыборкаНоменклатура.КоличествоЗаказано;
			
			КоличествоВзятьИтого=КоличествоВзятьИтого+ Мин(ВыборкаНоменклатура.КоличествоЗаказано,ВыборкаНоменклатура.КоличествоОстаток);
			
			ОбластьНоменклатура=Макет.ПолучитьОбласть("Строка");
			ОбластьНоменклатура.Параметры.Заполнить(ВыборкаНоменклатура);
			
			ОбластьНоменклатура.Параметры.АдресХранения	="";
			ОбластьНоменклатура.Параметры.Код	=ВыборкаНоменклатура.Номенклатура.Код;
			Если ВыборкаНоменклатура.НомерСтроки=1000 тогда
				КоррСтр=КоррСтр+1;
				ОбластьНоменклатура.Параметры.НомерСтроки = СсылкаНаОбъект.Товары.Количество()+КоррСтр;
			КонецЕсли;
			
						
			ВыборкаПоАдресам = ВыборкаНоменклатура.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
			
			КоличествоОстатокПоАдресамНакопительно=0; 
			Если ВыборкаПоАдресам.Количество()= 1 Тогда  // есть ТОЛЬКО по одному адресу - выводим в той же строке что и номенклатуру
				ВыборкаПоАдресам.Следующий(); 	
				ОбластьНоменклатура.Параметры.АдресХранения	= ВыборкаПоАдресам.АдресХранения;
				
				Если ВыборкаПоАдресам.КоличествоОстаток2>ВыборкаПоАдресам.КоличествоОстаток тогда //+++ есть другие товары в том же Адресе!
					ОбластьНоменклатура.Параметры.КоличествоОстаток = Формат(ВыборкаПоАдресам.КоличествоОстаток,"ЧДЦ=0")+"*";
					ОбластьНоменклатура.Параметры.АдресХранения = Формат(ВыборкаПоАдресам.АдресХранения,"ЧДЦ=0")+" + ( "+Формат(ВыборкаПоАдресам.КоличествоОстаток2 - ВыборкаПоАдресам.КоличествоОстаток,"ЧДЦ=0")+" )*";

				КонецЕсли;
						
				Если ЗначениеЗаполнено(ВыборкаПоАдресам.АдресХранения) Тогда // без остатков не выводим
				ТабДокумент.Вывести(ОбластьНоменклатура, ВыборкаНоменклатура.Уровень());	
				КонецЕсли;
			
			ИначеЕсли ВыборкаПоАдресам.Количество()>0 Тогда
				ТабДокумент.Вывести(ОбластьНоменклатура, ВыборкаНоменклатура.Уровень());
				
				Пока ВыборкаПоАдресам.Следующий() Цикл
					
					Если ВыборкаПоАдресам.КоличествоОстаток>=ВыборкаНоменклатура.КоличествоЗаказано тогда
						ОбластьСклад=Макет.ПолучитьОбласть("Строка1");
					иначе
						ОбластьСклад=Макет.ПолучитьОбласть("Строка3"); // сдвиг остатка влево
					КонецЕсли;	
					ОбластьСклад.Параметры.Заполнить(ВыборкаПоАдресам);
					
					
					ОбластьСклад.Параметры.Номенклатура="";
					ОбластьСклад.Параметры.КоличествоЗаказано="";
					ОбластьСклад.Параметры.НомерСтроки="";
					Если ВыборкаПоАдресам.КоличествоОстаток>0  Тогда 
						
						Если ВыборкаПоАдресам.КоличествоОстаток2>ВыборкаПоАдресам.КоличествоОстаток тогда //+++ есть другие товары в том же Адресе!
						ОбластьСклад.Параметры.КоличествоОстаток = Формат(ВыборкаПоАдресам.КоличествоОстаток,"ЧДЦ=0")+"*";
						ОбластьСклад.Параметры.АдресХранения = Формат(ВыборкаПоАдресам.АдресХранения,"ЧДЦ=0")+" + ( "+Формат(ВыборкаПоАдресам.КоличествоОстаток2- ВыборкаПоАдресам.КоличествоОстаток,"ЧДЦ=0")+" )*";
 						КонецЕсли;        		
					
						ТабДокумент.Вывести(ОбластьСклад, ВыборкаПоАдресам.Уровень());
					КонецЕсли;
					КоличествоОстатокПоАдресамНакопительно=КоличествоОстатокПоАдресамНакопительно+ВыборкаПоАдресам.КоличествоОстаток;
					Если КоличествоОстатокПоАдресамНакопительно>=ВыборкаНоменклатура.КоличествоЗаказано Тогда // на следующую номенклатуру
						
						Если СтрокВыводитьДополнительно>0 Тогда	
							СтрокВыводитьДополнительно=СтрокВыводитьДополнительно-1;
						Иначе	
							Прервать;
						КонецЕсли;	
					КонецЕсли;	
				КонецЦикла;
				
			Иначе //	ВыборкаСклад.Количество()<=0    не выводим ничего
				//ТабДокумент.Вывести(ОбластьНоменклатура, ВыборкаНоменклатура.Уровень());
				//Сообщить(ВыборкаНоменклатура.НомерСтроки);
			КонецЕсли;
			
		КонецЦикла;
		
		
	КонецЕсли;

	ОбластьИтого=Макет.ПолучитьОбласть("Итого");
	ОбластьИтого.Параметры.КоличествоСтрок=КоличествоСтрок;
	ОбластьИтого.Параметры.КоличествоВзятьИтого=КоличествоВзятьИтого;
	ТабДокумент.Вывести(ОбластьИтого);
	
	//ОбластьМакета=Макет.ПолучитьОбласть("Примечание");
	//ОбластьМакета.Параметры.Комментарий=СсылкаНаОбъект.Комментарий+ ?(КоличествоLegeArtis>0," , Всего дисков YST и LegeArtis=" + Строка(КоличествоLegeArtis) ,"" );
	//ТабДокумент.Вывести(ОбластьМакета);
	
	ОбластьМакета=Макет.ПолучитьОбласть("ПодвалЗаказа");
	ОбластьМакета.Параметры.Менеджер=СсылкаНаОбъект.Ответственный;
	
	//+++ 30.09.2013
	Фио = ?(СсылкаНаОбъект.Подразделение=справочники.Подразделения.НайтиПоКоду("00106"), "Жилин А.В.", "Фролов А.И." );
    
	ОбластьМакета.Параметры.ФИОИсполнителя = Фио;
	ТабДокумент.Вывести(ОбластьМакета);
		
	Возврат ТабДокумент;

КонецФункции // ПечатьСчетаЗаказа()

//ЗаказПокупателя
Функция ПечатьЗаказаПокупателя()
	
	// 5000 всегда печатается в порядке обхода склада
	//Ответ= Вопрос("Распечатать в порядке обхода склада?", РежимДиалогаВопрос.ДаНет,0);
	//
	//ФлагПорядкаОбхода=Ложь;
	//
	//Если Ответ = КодВозвратаДиалога.Да Тогда
		ФлагПорядкаОбхода=Истина;
	//КонецЕсли;	
	
	ТабДокумент = Новый ТабличныйДокумент;
	ТабДокумент.ИмяПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_ЗаказПокупателя_СчетЗаказ";

   Макет = ПолучитьМакет("Заказ");

	// Выводим шапку накладной
		Если  СокрЛП(СсылкаНаОбъект.МаркаАвтомобиля)<>"" Тогда
		ОбластьМакета = Макет.ПолучитьОбласть("Авто");
		ОбластьМакета.Параметры.Авто = СокрЛП(СсылкаНаОбъект.МаркаАвтомобиля);
		ОбластьМакета.Параметры.НомерАвто = СокрЛП(СсылкаНаОбъект.ГосНомерАвтомобиля);
		ОбластьМакета.Параметры.Пункт = СокрЛП(СсылкаНаОбъект.АдресДоставки);
		ТабДокумент.Вывести(ОбластьМакета);
		КОнецЕсли;
	//СведенияОПоставщике = СведенияОЮрФизЛице(СсылкаНаОбъект.Организация, Шапка.Дата);

	ОбластьМакета = Макет.ПолучитьОбласть("Заголовок");
	ОбластьМакета.Параметры.ТекстЗаголовка = СформироватьЗаголовокДокумента(СсылкаНаОбъект,"Заказ покупателя" );
	//+++ Штрих-Код номера документа - февраль 2012
	// требуется установленная компонента 1CBarCode.exe
    	ОбШтрихКодСообщение = глТорговоеОборудование.ПолучитьШтрихКодПоДокументу(СсылкаНаОбъект);
		попытка
		ОбШтрихКод=ОбластьМакета.Рисунки.ШК.Объект;
		ОбШтрихКод.Сообщение = ОбШтрихКодСообщение; 
		ОбШтрихКод.ТекстКода = ОбШтрихКодСообщение; 
		//ОбШтрихКод.ВидимостьКС = ЛОЖЬ; // не показывать контрольныйСимвол в тексте
		исключение
		 //нет компоненты 1CBarCode.exe
		КонецПопытки; 
	//+++)
	ТабДокумент.Вывести(ОбластьМакета);

	ОбластьМакета = Макет.ПолучитьОбласть("Поставщик");
	//ОбластьМакета.Параметры.Заполнить(Шапка);
	ОбластьМакета.Параметры.ПредставлениеПоставщика = ОписаниеОрганизации(СведенияОЮрФизЛице(СсылкаНаОбъект.Организация, СсылкаНаОбъект.Дата), "ИНН,КПП,ПолноеНаименование,ЮридическийАдрес,Телефоны,");
	ОбластьМакета.Параметры.ПоставщикТекст = "Поставщик:";//+++
	ТабДокумент.Вывести(ОбластьМакета);

	//СведенияОПолучателе = СведенияОЮрФизЛице(Шапка.Получатель, Шапка.Дата);
	ОбластьМакета = Макет.ПолучитьОбласть("Покупатель");
	//ОбластьМакета.Параметры.Заполнить(Шапка);
	ОбластьМакета.Параметры.ПредставлениеПолучателя = ОписаниеОрганизации(СведенияОЮрФизЛице(СсылкаНаОбъект.КОнтрагент, СсылкаНаОбъект.Дата), "ИНН,КПП,ПолноеНаименование,ЮридическийАдрес,Телефоны,");
	ОбластьМакета.Параметры.ПокупательТекст = "Покупатель:";
	ТабДокумент.Вывести(ОбластьМакета);

		
	ОбластьМакета = Макет.ПолучитьОбласть("ШапкаТаблицы");
	ТабДокумент.Вывести(ОбластьМакета);
	
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ЗаказПокупателя", СсылкаНаОбъект);
	
////--------------------------------------------------------------------------			   
//Запрос.Текст = " ВЫБРАТЬ
//| 	ЕстьNULL(ЗаказыПокупателей.НомерСтроки, 1000) НомерСтроки,
//| //	ЗаказыПокупателейОстатки.Номенклатура.Типоразмер,
//|	ЗаказыПокупателейОстатки.Номенклатура,
//|	ЗаказыПокупателейОстатки.КоличествоОстаток КоличествоЗаказано,
//|	ЕстьNULL(ТоварыАдресноеХранениеОстатки.АдресХранения,"""") АдресХранения,
//|	ЕстьNULL(ТоварыАдресноеХранениеОстатки.КоличествоОстаток ,0) КоличествоОстаток
//|	
//|ИЗ
//|	РегистрНакопления.ЗаказыПокупателей.Остатки(, ЗаказПокупателя = &ЗаказПокупателя) КАК ЗаказыПокупателейОстатки
//|	ЛЕВОЕ СОЕДИНЕНИЕ
//|	(ВЫБРАТЬ НомерСтроки, Номенклатура ИЗ Документ.ЗаказПокупателя.Товары ГДЕ Ссылка=&ЗаказПокупателя) ЗаказыПокупателей
//|	ПО ЗаказыПокупателейОстатки.Номенклатура=ЗаказыПокупателей.Номенклатура
//|	ЛЕВОЕ СОЕДИНЕНИЕ
//|	РегистрНакопления.ТоварыАдресноеХранение.Остатки(,Склад=&Склад5000)  ТоварыАдресноеХранениеОстатки
//|	ПО ЗаказыПокупателейОстатки.Номенклатура=ТоварыАдресноеХранениеОстатки.Номенклатура
//|	
//|УПОРЯДОЧИТЬ ПО АдресХранения.Порядок 
//|ИТОГИ 
//|СРЕДНЕЕ (НомерСтроки), СРЕДНЕЕ (КоличествоЗаказано), СУММА(КоличествоОстаток)
//|ПО
//|ЗаказыПокупателейОстатки.Номенклатура";
			   
Запрос.Текст = "ВЫБРАТЬ
               |	ЕСТЬNULL(ЗаказыПокупателей.НомерСтроки, 1000) КАК НомерСтроки,
               |	ЗаказыПокупателейОстатки.Номенклатура КАК Номенклатура,
               |	ЗаказыПокупателейОстатки.КоличествоОстаток КАК КоличествоЗаказано,
               |	ЕСТЬNULL(ТоварыАдресноеХранениеОстатки.АдресХранения, """") КАК АдресХранения,
               |	ЕСТЬNULL(ТоварыАдресноеХранениеОстатки.КоличествоОстаток, 0) КАК КоличествоОстаток,
               |	ЕСТЬNULL(ТоварыАдресноеХранениеОстатки1.КоличествоОстаток, 0) КАК КоличествоОстаток2
               |ИЗ
               |	РегистрНакопления.ЗаказыПокупателей.Остатки(, ЗаказПокупателя = &ЗаказПокупателя) КАК ЗаказыПокупателейОстатки
               |		ЛЕВОЕ СОЕДИНЕНИЕ (ВЫБРАТЬ
               |			ЗаказПокупателяТовары.НомерСтроки КАК НомерСтроки,
               |			ЗаказПокупателяТовары.Номенклатура КАК Номенклатура
               |		ИЗ
               |			Документ.ЗаказПокупателя.Товары КАК ЗаказПокупателяТовары
               |		ГДЕ
               |			ЗаказПокупателяТовары.Ссылка = &ЗаказПокупателя) КАК ЗаказыПокупателей
               |		ПО ЗаказыПокупателейОстатки.Номенклатура = ЗаказыПокупателей.Номенклатура
               |		ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.ТоварыАдресноеХранение.Остатки(, Склад В (&Склад5000)) КАК ТоварыАдресноеХранениеОстатки
               |			ЛЕВОЕ СОЕДИНЕНИЕ (ВЫБРАТЬ РАЗЛИЧНЫЕ
               |				РНАдреса.АдресХранения КАК АдресХранения,
               |				РНАдреса.КоличествоОстаток КАК КоличествоОстаток
               |			ИЗ
               |				РегистрНакопления.ТоварыАдресноеХранение.Остатки(, Склад В( &Склад5000)) КАК РНАдреса) КАК ТоварыАдресноеХранениеОстатки1
               |			ПО ТоварыАдресноеХранениеОстатки.АдресХранения = ТоварыАдресноеХранениеОстатки1.АдресХранения
               |		ПО ЗаказыПокупателейОстатки.Номенклатура = ТоварыАдресноеХранениеОстатки.Номенклатура
               |
               |УПОРЯДОЧИТЬ ПО
               |	ТоварыАдресноеХранениеОстатки.АдресХранения.Порядок
               |ИТОГИ
               |	СРЕДНЕЕ(НомерСтроки),
               |	СРЕДНЕЕ(КоличествоЗаказано),
               |	СУММА(КоличествоОстаток),
               |	СУММА(КоличествоОстаток2)
               |ПО
               |	Номенклатура";


Если ФлагПорядкаОбхода Тогда
	
Иначе
	Запрос.Текст=СтрЗаменить(Запрос.Текст,"ПО АдресХранения.Порядок","ПО НомерСтроки");
КонецЕсли;	

 Запрос.УстановитьПараметр("Склад5000", Склад5000()  );
	
	
	Результат = Запрос.Выполнить();
	
	КоличествоСтрок=0;
	КоличествоЗаказаноИтого=0;
	КоличествоLegeArtis=0;
	КоличествоВзятьИтого=0;
	Если не Результат.Пустой() Тогда
		//ТабДокумент.Вывести(ОбластьМакета);
		//ТабДокумент.НачатьАвтогруппировкуСтрок();
		
		ВыборкаНоменклатура = Результат.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
		КоррСтр=0;
		
		Пока ВыборкаНоменклатура.Следующий() Цикл
			СтрокВыводитьДополнительно=5;
			КоличествоСтрок=КоличествоСтрок+1;
			КоличествоЗаказаноИтого=КоличествоЗаказаноИтого+ВыборкаНоменклатура.КоличествоЗаказано;
			
			КоличествоВзятьИтого=КоличествоВзятьИтого+ Мин(ВыборкаНоменклатура.КоличествоЗаказано,ВыборкаНоменклатура.КоличествоОстаток);
			
			ОбластьНоменклатура=Макет.ПолучитьОбласть("Строка");
			ОбластьНоменклатура.Параметры.Заполнить(ВыборкаНоменклатура);
			
			ОбластьНоменклатура.Параметры.АдресХранения	="";
			ОбластьНоменклатура.Параметры.Код	=ВыборкаНоменклатура.Номенклатура.Код;
			Если ВыборкаНоменклатура.НомерСтроки=1000 тогда
				КоррСтр=КоррСтр+1;
				ОбластьНоменклатура.Параметры.НомерСтроки = СсылкаНаОбъект.Товары.Количество()+КоррСтр;
			КонецЕсли;
			
						
			ВыборкаПоАдресам = ВыборкаНоменклатура.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
			
			КоличествоОстатокПоАдресамНакопительно=0; 
			Если ВыборкаПоАдресам.Количество()= 1 Тогда  // есть ТОЛЬКО по одному адресу - выводим в той же строке что и номенклатуру
				ВыборкаПоАдресам.Следующий(); 	
				ОбластьНоменклатура.Параметры.АдресХранения	= ВыборкаПоАдресам.АдресХранения;
				
				Если ВыборкаПоАдресам.КоличествоОстаток2>ВыборкаПоАдресам.КоличествоОстаток тогда //+++ есть другие товары в том же Адресе!
					ОбластьНоменклатура.Параметры.КоличествоОстаток = Формат(ВыборкаПоАдресам.КоличествоОстаток,"ЧДЦ=0")+"*";
					ОбластьНоменклатура.Параметры.АдресХранения = Формат(ВыборкаПоАдресам.АдресХранения,"ЧДЦ=0")+" + ( "+Формат(ВыборкаПоАдресам.КоличествоОстаток2 - ВыборкаПоАдресам.КоличествоОстаток,"ЧДЦ=0")+" )*";

				КонецЕсли;
						
				Если ЗначениеЗаполнено(ВыборкаПоАдресам.АдресХранения) Тогда // без остатков не выводим
				ТабДокумент.Вывести(ОбластьНоменклатура, ВыборкаНоменклатура.Уровень());	
				КонецЕсли;
			
			ИначеЕсли ВыборкаПоАдресам.Количество()>0 Тогда
				ТабДокумент.Вывести(ОбластьНоменклатура, ВыборкаНоменклатура.Уровень());
				
				Пока ВыборкаПоАдресам.Следующий() Цикл
					
					Если ВыборкаПоАдресам.КоличествоОстаток>=ВыборкаНоменклатура.КоличествоЗаказано тогда
						ОбластьСклад=Макет.ПолучитьОбласть("Строка1");
					иначе
						ОбластьСклад=Макет.ПолучитьОбласть("Строка3"); // сдвиг остатка влево
					КонецЕсли;	
					ОбластьСклад.Параметры.Заполнить(ВыборкаПоАдресам);
					
					
					ОбластьСклад.Параметры.Номенклатура="";
					ОбластьСклад.Параметры.КоличествоЗаказано="";
					ОбластьСклад.Параметры.НомерСтроки="";
					Если ВыборкаПоАдресам.КоличествоОстаток>0  Тогда 
						
						Если ВыборкаПоАдресам.КоличествоОстаток2>ВыборкаПоАдресам.КоличествоОстаток тогда //+++ есть другие товары в том же Адресе!
						ОбластьСклад.Параметры.КоличествоОстаток = Формат(ВыборкаПоАдресам.КоличествоОстаток,"ЧДЦ=0")+"*";
						ОбластьСклад.Параметры.АдресХранения = Формат(ВыборкаПоАдресам.АдресХранения,"ЧДЦ=0")+" + ( "+Формат(ВыборкаПоАдресам.КоличествоОстаток2- ВыборкаПоАдресам.КоличествоОстаток,"ЧДЦ=0")+" )*";
 						КонецЕсли;        		
					
						ТабДокумент.Вывести(ОбластьСклад, ВыборкаПоАдресам.Уровень());
					КонецЕсли;
					КоличествоОстатокПоАдресамНакопительно=КоличествоОстатокПоАдресамНакопительно+ВыборкаПоАдресам.КоличествоОстаток;
					Если КоличествоОстатокПоАдресамНакопительно>=ВыборкаНоменклатура.КоличествоЗаказано Тогда // на следующую номенклатуру
						
						Если СтрокВыводитьДополнительно>0 Тогда	
							СтрокВыводитьДополнительно=СтрокВыводитьДополнительно-1;
						Иначе	
							Прервать;
						КонецЕсли;	
					КонецЕсли;	
				КонецЦикла;
				
			Иначе //	ВыборкаСклад.Количество()<=0    не выводим ничего
				//ТабДокумент.Вывести(ОбластьНоменклатура, ВыборкаНоменклатура.Уровень());
				//Сообщить(ВыборкаНоменклатура.НомерСтроки);
			КонецЕсли;
			
		КонецЦикла;
		
		
	КонецЕсли;

	ОбластьИтого=Макет.ПолучитьОбласть("Итого");
	ОбластьИтого.Параметры.КоличествоСтрок=КоличествоСтрок;
	ОбластьИтого.Параметры.КоличествоВзятьИтого=КоличествоВзятьИтого;
	ТабДокумент.Вывести(ОбластьИтого);
	
	//ОбластьМакета=Макет.ПолучитьОбласть("Примечание");
	//ОбластьМакета.Параметры.Комментарий=СсылкаНаОбъект.Комментарий+ ?(КоличествоLegeArtis>0," , Всего дисков YST и LegeArtis=" + Строка(КоличествоLegeArtis) ,"" );
	//ТабДокумент.Вывести(ОбластьМакета);
	
	ОбластьМакета=Макет.ПолучитьОбласть("ПодвалЗаказа");
	ОбластьМакета.Параметры.Менеджер=СсылкаНаОбъект.Ответственный;
	
	//+++ 30.09.2013
	Фио = ?(СсылкаНаОбъект.Подразделение=справочники.Подразделения.НайтиПоКоду("00106"), "Жилин А.В.", "Фролов А.И." );
	
	ОбластьМакета.Параметры.ФИОИсполнителя = Фио;
	ТабДокумент.Вывести(ОбластьМакета);
	

	
	Возврат ТабДокумент;

КонецФункции // ПечатьСчетаЗаказа()

//ЗаказПокупателя
Функция ПечатьПеремещенияТоваров()
	
	// 5000 всегда печатается в порядке обхода склада
	//Ответ= Вопрос("Распечатать в порядке обхода склада?", РежимДиалогаВопрос.ДаНет,0);
	//
	//ФлагПорядкаОбхода=Ложь;
	//
	//Если Ответ = КодВозвратаДиалога.Да Тогда
		ФлагПорядкаОбхода=Истина;
	//КонецЕсли;	
	
	ТабДокумент = Новый ТабличныйДокумент;
	ТабДокумент.ИмяПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_ЗаказПокупателя_СчетЗаказ";

   Макет = ПолучитьМакет("Заказ");

	// Выводим шапку накладной
		Если  СокрЛП(СсылкаНаОбъект.МаркаАвтомобиля)<>"" Тогда
		ОбластьМакета = Макет.ПолучитьОбласть("Авто");
		ОбластьМакета.Параметры.Авто = СокрЛП(СсылкаНаОбъект.МаркаАвтомобиля);
		ОбластьМакета.Параметры.НомерАвто = СокрЛП(СсылкаНаОбъект.ГосНомерАвтомобиля);
		ОбластьМакета.Параметры.Пункт = СокрЛП(СсылкаНаОбъект.АдресДоставки);
		ТабДокумент.Вывести(ОбластьМакета);
		КОнецЕсли;
	//СведенияОПоставщике = СведенияОЮрФизЛице(СсылкаНаОбъект.Организация, Шапка.Дата);

	ОбластьМакета = Макет.ПолучитьОбласть("Заголовок");
	ОбластьМакета.Параметры.ТекстЗаголовка = СформироватьЗаголовокДокумента(СсылкаНаОбъект,"Перемещение товаров" );
	//+++ Штрих-Код номера документа - февраль 2012
	// требуется установленная компонента 1CBarCode.exe
    	ОбШтрихКодСообщение = глТорговоеОборудование.ПолучитьШтрихКодПоДокументу(СсылкаНаОбъект);
		попытка
		ОбШтрихКод=ОбластьМакета.Рисунки.ШК.Объект;
		ОбШтрихКод.Сообщение = ОбШтрихКодСообщение; 
		ОбШтрихКод.ТекстКода = ОбШтрихКодСообщение; 
		//ОбШтрихКод.ВидимостьКС = ЛОЖЬ; // не показывать контрольныйСимвол в тексте
		исключение
		 //нет компоненты 1CBarCode.exe
		КонецПопытки; 
	//+++)
	ТабДокумент.Вывести(ОбластьМакета);

	ОбластьМакета = Макет.ПолучитьОбласть("Поставщик");
	Организация1 = справочники.Организации.НайтиПоКоду("00001");
	ОбластьМакета.Параметры.ПредставлениеПоставщика = ОписаниеОрганизации(СведенияОЮрФизЛице(Организация1, СсылкаНаОбъект.Дата), "ИНН,КПП,ПолноеНаименование,ЮридическийАдрес,Телефоны,");
	ОбластьМакета.Параметры.ПоставщикТекст = "Поставщик:";//+++
	ТабДокумент.Вывести(ОбластьМакета);

	ОбластьМакета = Макет.ПолучитьОбласть("Покупатель");
	ОбластьМакета.Параметры.ПредставлениеПолучателя = Строка(СсылкаНаОбъект.Подразделение)+" Склад: "+строка(СсылкаНаОбъект.СкладПолучатель);
	ОбластьМакета.Параметры.ПокупательТекст = "Покупатель:";
	ТабДокумент.Вывести(ОбластьМакета);

		
	ОбластьМакета = Макет.ПолучитьОбласть("ШапкаТаблицы");
	ТабДокумент.Вывести(ОбластьМакета);
	
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Перемещение", СсылкаНаОбъект);
	СписокНоменклатура = новый СписокЗначений;
	СписокНоменклатура.ЗагрузитьЗначения( СсылкаНаОбъект.Товары.ВыгрузитьКолонку("Номенклатура") );
	СписокНоменклатура.СортироватьПоЗначению();
	
	Запрос.УстановитьПараметр("СписокНоменклатура", СписокНоменклатура);
	
	Запрос.УстановитьПараметр("Склад5000",  Склад5000()  );
	
	Запрос.Текст = "ВЫБРАТЬ
	               |	ЕСТЬNULL(ЗаказыПокупателей.НомерСтроки, 1000) КАК НомерСтроки,
	               |	ЗаказыПокупателей.Номенклатура КАК Номенклатура,
	               |	ЗаказыПокупателей.Количество КАК КоличествоЗаказано,
	               |	ЕСТЬNULL(ТоварыАдресноеХранениеОстатки.АдресХранения, """") КАК АдресХранения,
	               |	ЕСТЬNULL(ТоварыАдресноеХранениеОстатки.КоличествоОстаток, 0) КАК КоличествоОстаток,
	               |	ЕСТЬNULL(ТоварыАдресноеХранениеОстатки1.КоличествоОстаток, 0) КАК КоличествоОстаток2
	               |ИЗ
	               |	(ВЫБРАТЬ
	               |		МИНИМУМ(ПеремещениеТоваровТовары.НомерСтроки) КАК НомерСтроки,
	               |		ПеремещениеТоваровТовары.Номенклатура КАК Номенклатура,
	               |		СУММА(ПеремещениеТоваровТовары.Количество) КАК Количество
	               |	ИЗ
	               |		Документ.ПеремещениеТоваров.Товары КАК ПеремещениеТоваровТовары
	               |	ГДЕ
	               |		ПеремещениеТоваровТовары.Ссылка = &Перемещение
	               |	
	               |	СГРУППИРОВАТЬ ПО
	               |		ПеремещениеТоваровТовары.Номенклатура) КАК ЗаказыПокупателей
	               |		ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.ТоварыАдресноеХранение.Остатки(,Склад В (&Склад5000)
	               |					И Номенклатура В (&СписокНоменклатура)) КАК ТоварыАдресноеХранениеОстатки
	               |			ЛЕВОЕ СОЕДИНЕНИЕ (ВЫБРАТЬ РАЗЛИЧНЫЕ
	               |				РНАдреса.АдресХранения КАК АдресХранения,
	               |				РНАдреса.КоличествоОстаток КАК КоличествоОстаток
	               |			ИЗ
	               |				РегистрНакопления.ТоварыАдресноеХранение.Остатки(, Склад В( &Склад5000)) КАК РНАдреса) КАК ТоварыАдресноеХранениеОстатки1
	               |			ПО ТоварыАдресноеХранениеОстатки.АдресХранения = ТоварыАдресноеХранениеОстатки1.АдресХранения
	               |		ПО ЗаказыПокупателей.Номенклатура = ТоварыАдресноеХранениеОстатки.Номенклатура
	               |
	               |УПОРЯДОЧИТЬ ПО ТоварыАдресноеХранениеОстатки.АдресХранения.Порядок
	               |ИТОГИ
	               |	Минимум(НомерСтроки),
	               |	СРЕДНЕЕ(КоличествоЗаказано),
	               |	СУММА(КоличествоОстаток),
	               |	СУММА(КоличествоОстаток2)
	               |ПО
	               |	Номенклатура";

          			   
Если ФлагПорядкаОбхода Тогда
	
Иначе
	Запрос.Текст=СтрЗаменить(Запрос.Текст,"ПО ТоварыАдресноеХранениеОстаткиАдресХранения.Порядок","ПО НомерСтроки");
КонецЕсли;	

//+++ 30.09.2013
//Запрос.УстановитьПараметр("Склад5000",Справочники.Склады.НайтиПоКоду("00642"));
	
	
	Результат = Запрос.Выполнить();
	
	КоличествоСтрок=0;
	КоличествоЗаказаноИтого=0;
	КоличествоLegeArtis=0;
	КоличествоВзятьИтого=0;
	Если не Результат.Пустой() Тогда
		//ТабДокумент.Вывести(ОбластьМакета);
		//ТабДокумент.НачатьАвтогруппировкуСтрок();
		
		ВыборкаНоменклатура = Результат.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
		КоррСтр=0;
		
		Пока ВыборкаНоменклатура.Следующий() Цикл
			СтрокВыводитьДополнительно=5;
			КоличествоСтрок=КоличествоСтрок+1;
			КоличествоЗаказаноИтого=КоличествоЗаказаноИтого+ВыборкаНоменклатура.КоличествоЗаказано;
			
			КоличествоВзятьИтого=КоличествоВзятьИтого+ Мин(ВыборкаНоменклатура.КоличествоЗаказано,ВыборкаНоменклатура.КоличествоОстаток);
			
			ОбластьНоменклатура=Макет.ПолучитьОбласть("Строка");
			ОбластьНоменклатура.Параметры.Заполнить(ВыборкаНоменклатура);
			
			ОбластьНоменклатура.Параметры.АдресХранения	="";
			ОбластьНоменклатура.Параметры.Код	=ВыборкаНоменклатура.Номенклатура.Код;
			Если ВыборкаНоменклатура.НомерСтроки=1000 тогда
				КоррСтр=КоррСтр+1;
				ОбластьНоменклатура.Параметры.НомерСтроки = СсылкаНаОбъект.Товары.Количество()+КоррСтр;
			КонецЕсли;
			
						
			ВыборкаПоАдресам = ВыборкаНоменклатура.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
			
			КоличествоОстатокПоАдресамНакопительно=0; 
			Если ВыборкаПоАдресам.Количество()= 1 Тогда  // есть ТОЛЬКО по одному адресу - выводим в той же строке что и номенклатуру
				ВыборкаПоАдресам.Следующий(); 	
				ОбластьНоменклатура.Параметры.АдресХранения	= ВыборкаПоАдресам.АдресХранения;
				
				Если ВыборкаПоАдресам.КоличествоОстаток2>ВыборкаПоАдресам.КоличествоОстаток тогда //+++ есть другие товары в том же Адресе!
					ОбластьНоменклатура.Параметры.КоличествоОстаток = Формат(ВыборкаПоАдресам.КоличествоОстаток,"ЧДЦ=0")+"*";
					ОбластьНоменклатура.Параметры.АдресХранения = Формат(ВыборкаПоАдресам.АдресХранения,"ЧДЦ=0")+" + ( "+Формат(ВыборкаПоАдресам.КоличествоОстаток2 - ВыборкаПоАдресам.КоличествоОстаток,"ЧДЦ=0")+" )*";

				КонецЕсли;
						
				Если ЗначениеЗаполнено(ВыборкаПоАдресам.АдресХранения) Тогда // без остатков не выводим
				ТабДокумент.Вывести(ОбластьНоменклатура, ВыборкаНоменклатура.Уровень());	
				КонецЕсли;
			
			ИначеЕсли ВыборкаПоАдресам.Количество()>0 Тогда
				ТабДокумент.Вывести(ОбластьНоменклатура, ВыборкаНоменклатура.Уровень());
				
				Пока ВыборкаПоАдресам.Следующий() Цикл
					
					Если ВыборкаПоАдресам.КоличествоОстаток>=ВыборкаНоменклатура.КоличествоЗаказано тогда
						ОбластьСклад=Макет.ПолучитьОбласть("Строка1");
					иначе
						ОбластьСклад=Макет.ПолучитьОбласть("Строка3"); // сдвиг остатка влево
					КонецЕсли;	
					ОбластьСклад.Параметры.Заполнить(ВыборкаПоАдресам);
					
					
					ОбластьСклад.Параметры.Номенклатура="";
					ОбластьСклад.Параметры.КоличествоЗаказано="";
					ОбластьСклад.Параметры.НомерСтроки="";
					Если ВыборкаПоАдресам.КоличествоОстаток>0  Тогда 
						
						Если ВыборкаПоАдресам.КоличествоОстаток2>ВыборкаПоАдресам.КоличествоОстаток тогда //+++ есть другие товары в том же Адресе!
						ОбластьСклад.Параметры.КоличествоОстаток = Формат(ВыборкаПоАдресам.КоличествоОстаток,"ЧДЦ=0")+"*";
						ОбластьСклад.Параметры.АдресХранения = Формат(ВыборкаПоАдресам.АдресХранения,"ЧДЦ=0")+" + ( "+Формат(ВыборкаПоАдресам.КоличествоОстаток2- ВыборкаПоАдресам.КоличествоОстаток,"ЧДЦ=0")+" )*";
 						КонецЕсли;        		
					
						ТабДокумент.Вывести(ОбластьСклад, ВыборкаПоАдресам.Уровень());
					КонецЕсли;
					КоличествоОстатокПоАдресамНакопительно=КоличествоОстатокПоАдресамНакопительно+ВыборкаПоАдресам.КоличествоОстаток;
					Если КоличествоОстатокПоАдресамНакопительно>=ВыборкаНоменклатура.КоличествоЗаказано Тогда // на следующую номенклатуру
						
						Если СтрокВыводитьДополнительно>0 Тогда	
							СтрокВыводитьДополнительно=СтрокВыводитьДополнительно-1;
						Иначе	
							Прервать;
						КонецЕсли;	
					КонецЕсли;	
				КонецЦикла;
				
			Иначе //	ВыборкаСклад.Количество()<=0    не выводим ничего
				//ТабДокумент.Вывести(ОбластьНоменклатура, ВыборкаНоменклатура.Уровень());
				//Сообщить(ВыборкаНоменклатура.НомерСтроки);
			КонецЕсли;
			
		КонецЦикла;
		
		
	КонецЕсли;

	ОбластьИтого=Макет.ПолучитьОбласть("Итого");
	ОбластьИтого.Параметры.КоличествоСтрок=КоличествоСтрок;
	ОбластьИтого.Параметры.КоличествоВзятьИтого=КоличествоВзятьИтого;
	ТабДокумент.Вывести(ОбластьИтого);
	
	//ОбластьМакета=Макет.ПолучитьОбласть("Примечание");
	//ОбластьМакета.Параметры.Комментарий=СсылкаНаОбъект.Комментарий+ ?(КоличествоLegeArtis>0," , Всего дисков YST и LegeArtis=" + Строка(КоличествоLegeArtis) ,"" );
	//ТабДокумент.Вывести(ОбластьМакета);
	
	ОбластьМакета=Макет.ПолучитьОбласть("ПодвалЗаказа");
	ОбластьМакета.Параметры.Менеджер=СсылкаНаОбъект.Ответственный;
	
	//+++ 30.09.2013
	Фио = ?(СсылкаНаОбъект.Подразделение=справочники.Подразделения.НайтиПоКоду("00106"), "Жилин А.В.", "Фролов А.И." );
	
	ОбластьМакета.Параметры.ФИОИсполнителя = Фио;
	ТабДокумент.Вывести(ОбластьМакета);
	
	Возврат ТабДокумент;

КонецФункции // ПечатьПеремещения()


// общая процедура печати
функция Печать() Экспорт
	ТабДокумент = неопределено;
Если НЕ ЗначениеЗаполнено(СсылкаНаОбъект) тогда
Предупреждение("Не выбран документ!", 30);		
возврат Неопределено;
КонецЕсли;

//Если ПолучитьЗначениеПоУмолчанию(ПараметрыСеанса.ТекущийПользователь, "УчетТолькоПоПодразделениюПользователя") тогда
//	Если ПараметрыСеанса.ТекущийПользователь.ОсновноеПодразделение.Код<>"00106" тогда
//		Предупреждение("По вашему подразделению - не ведется адресного хранения", 30);
//	возврат Неопределено;
//	КонецЕсли;
//КонецЕсли;

	Если ТипЗнч(СсылкаНаОбъект) = Тип("ДокументСсылка.ЗаказПокупателя")	тогда
		  ТабДокумент = ПечатьЗаказаПокупателя();
	//иначеЕсли ТипЗнч(СсылкаНаОбъект) = Тип("ДокументСсылка.ВнутреннийЗаказ") тогда
	//	  ТабДокумент = ПечатьВнутреннегоЗаказа();	  
	иначеЕсли ТипЗнч(СсылкаНаОбъект) = Тип("ДокументСсылка.ЗаказПоОтветственномуХранению") тогда
		  ТабДокумент = ПечатьЗаказаОТХ();	 
	иначеЕсли ТипЗнч(СсылкаНаОбъект) = Тип("ДокументСсылка.ПеремещениеТоваров") тогда
		  ТабДокумент = ПечатьПеремещенияТоваров();
	КонецЕсли;
	
 Возврат ТабДокумент;
 
КонецФункции

функция Склад5000()
	рез=Новый СписокЗначений;
	Если ТипЗнч(СсылкаНаОбъект)=Тип("ДокументСсылка.ПеремещениеТоваров") тогда
		
		Если СсылкаНаОбъект.СкладОтправитель.АдресноеХранение тогда
			Рез.Добавить(СсылкаНаОбъект.СкладОтправитель);
		ИначеЕсли СсылкаНаОбъект.Подразделение=справочники.Подразделения.НайтиПоКоду("00106") тогда
			Рез.Добавить(Справочники.Склады.НайтиПоКоду("00791"));
		ИначеЕсли СсылкаНаОбъект.Подразделение=справочники.Подразделения.НайтиПоКоду("00112") Тогда	
			Рез.Добавить(Справочники.Склады.НайтиПоКоду("00827"));
		Иначе
			Рез.Добавить(Справочники.Склады.НайтиПоКоду("00642"));//5000
			Рез.Добавить(Справочники.Склады.НайтиПоКоду("00904"));//8000
		КонецЕсли;	 
		
		//рез = ?(СсылкаНаОбъект.СкладОтправитель.АдресноеХранение, СсылкаНаОбъект.СкладОтправитель, 
		//?(СсылкаНаОбъект.Подразделение=справочники.Подразделения.НайтиПоКоду("00106"), Справочники.Склады.НайтиПоКоду("00791"), //4000
		//?(СсылкаНаОбъект.Подразделение=справочники.Подразделения.НайтиПоКоду("00112"),  Справочники.Склады.НайтиПоКоду("00827"),//1000
		//Справочники.Склады.НайтиПоКоду("00642"))
		//)	    );
		
	Иначе
		Если СсылкаНаОбъект.Склад.АдресноеХранение тогда
			Рез.Добавить(СсылкаНаОбъект.Склад);
		ИначеЕсли СсылкаНаОбъект.Подразделение=справочники.Подразделения.НайтиПоКоду("00106") тогда
			Рез.Добавить(Справочники.Склады.НайтиПоКоду("00791"));
		ИначеЕсли СсылкаНаОбъект.Подразделение=справочники.Подразделения.НайтиПоКоду("00112") Тогда	
			Рез.Добавить(Справочники.Склады.НайтиПоКоду("00827"));
		Иначе
			Рез.Добавить(Справочники.Склады.НайтиПоКоду("00642"));//5000
			Рез.Добавить(Справочники.Склады.НайтиПоКоду("00904"));//8000
		КонецЕсли;
		
		
		//рез = ?(СсылкаНаОбъект.Склад.АдресноеХранение, СсылкаНаОбъект.Склад, 
		//?( СсылкаНаОбъект.Подразделение=справочники.Подразделения.НайтиПоКоду("00106"), Справочники.Склады.НайтиПоКоду("00791"), //4000
		//?(СсылкаНаОбъект.Подразделение=справочники.Подразделения.НайтиПоКоду("00112"),  Справочники.Склады.НайтиПоКоду("00827"),//1000
		//Справочники.Склады.НайтиПоКоду("00642")) //5000
		//)   );
		
	КонецЕсли;
	
	
	возврат рез;
КонецФункции 