﻿Процедура ОбменССайтом() Экспорт
	ОбработкаОбмена = Обработки.ОбменССайтом.Создать();
	ОбработкаОбмена.НастроитьПостроительОтчета(ОбработкаОбмена.ПостроительЗапроса);
	ОбработкаОбмена.ЗаполнитьОтборПостроителя(ОбработкаОбмена.ПостроительЗапроса);
	
	ОбработкаОбмена.ПостроительЗапроса.Отбор.ТипЦен.Установить(Справочники.ТипыЦенНоменклатуры.НайтиПоНаименованию("koleso76"));
	
	СписокОтбора = Новый СписокЗначений;
	СписокОтбора.Добавить(Справочники.Номенклатура.НайтиПоКоду("0060103")); //Легковые зимние
	СписокОтбора.Добавить(Справочники.Номенклатура.НайтиПоКоду("0060101")); //Легковые летние
	СписокОтбора.Добавить(Справочники.Номенклатура.НайтиПоКоду("0081439")); //Легкогрузовые зимние
	СписокОтбора.Добавить(Справочники.Номенклатура.НайтиПоКоду("0060106")); //Легкогрузовые летние
	СписокОтбора.Добавить(Справочники.Номенклатура.НайтиПоКоду("0001753")); //Литые
	СписокОтбора.Добавить(Справочники.Номенклатура.НайтиПоКоду("0080631")); //Грузовые и спецтехника
	СписокОтбора.Добавить(Справочники.Номенклатура.НайтиПоКоду("0001750")); //Сельскохозяйственные
	СписокОтбора.Добавить(Справочники.Номенклатура.НайтиПоКоду("0001755")); //Штампованные
	
	ОбработкаОбмена.ПостроительЗапроса.Отбор.Номенклатура.ВидСравнения = ВидСравнения.ВСпискеПоИерархии;
	ОбработкаОбмена.ПостроительЗапроса.Отбор.Номенклатура.Значение = СписокОтбора;
	ОбработкаОбмена.ПостроительЗапроса.Отбор.Номенклатура.Использование = Истина;
	
	ОбработкаОбмена.ВыгрузитьДанные();
КонецПроцедуры


Процедура ФормированиеЗаявкиНаСписаниеСОтвХранения()  Экспорт
		ТабДокумент = ОбменДаннымиСWebСайтом.СформироватьФормуЗаявкиДляАвтошины();
        ИмяФайлаСообщения ="claim.xls";
        ТабДокумент.Записать("c:\"+ИмяФайлаСообщения, ТипФайлаТабличногоДокумента.XLS);
		врФТП = Новый FTPСоединение("83.102.251.100",,"yst76", "yst76admin",, Истина );
		врФТП.Записать("c:\"+ИмяФайлаСообщения , "data/"+ИмяФайлаСообщения);
 	
	КонецПроцедуры	
	
Функция СформироватьФормуЗаявкиДляАвтошины()  Экспорт
	ТабДок=Новый ТабличныйДокумент;
	
	Макет = ПолучитьОбщийМакет("МакетФормаЗаявкиДляАвтошины");
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	Спр.Номенклатура.Код КАК КодЯШТ,
	|	Спр.Номенклатура.КодСБИС КАК КодАвтошина,
	|	Спр.Номенклатура,
	|	ВЫРАЗИТЬ(ОстаткиАвтоШина.Остаток КАК ЧИСЛО(15, 0)) КАК Остаток
	|ИЗ
	|	(ВЫБРАТЬ   РАЗЛИЧНЫЕ
	|Объект Номенклатура
	|ИЗ
	|РегистрСведений.ЗначенияСвойствОбъектов ГДЕ
	|Свойство = &Свойство
	|И (Значение =&Легковые
	|ИЛИ Значение =&ЛегкоГрузовые
	|ИЛИ Значение =&ГрузовыеLingLong
	|ИЛИ Значение =&Крупногабаритные
	|ИЛИ Значение =&ДляПогрузчиков
	|ИЛИ Значение =&Камеры)
	|) КАК Спр
	|		ЛЕВОЕ СОЕДИНЕНИЕ (ВЫБРАТЬ
	|			ТоварыНаОтветственномХраненииОстатки.Номенклатура КАК Номенклатура,
	|			ТоварыНаОтветственномХраненииОстатки.КоличествоОстаток КАК Остаток
	|		ИЗ
	|			РегистрНакопления.ТоварыНаОтветственномХранении.Остатки(, Контрагент = &АвтоШина) КАК ТоварыНаОтветственномХраненииОстатки) КАК ОстаткиАвтоШина
	|		ПО Спр.Номенклатура = ОстаткиАвтоШина.Номенклатура
	|
	|УПОРЯДОЧИТЬ ПО
	|	Спр.Номенклатура.Наименование";

	Запрос.УстановитьПараметр("АвтоШина", Справочники.Контрагенты.НайтиПоКоду("91640"));
	Запрос.УстановитьПараметр("Шины", Перечисления.ВидыТоваров.Шины);
	Запрос.УстановитьПараметр("ГрузовыеLingLong",Справочники.ЗначенияСвойствОбъектов.НайтиПоКоду("01079") );
	Запрос.УстановитьПараметр("ДляПогрузчиков", Справочники.ЗначенияСвойствОбъектов.НайтиПоКоду("01331"));
	Запрос.УстановитьПараметр("Камеры", Справочники.ЗначенияСвойствОбъектов.НайтиПоКоду("01354"));
	Запрос.УстановитьПараметр("Крупногабаритные", Справочники.ЗначенияСвойствОбъектов.НайтиПоКоду("01349"));
	Запрос.УстановитьПараметр("Легковые", Справочники.ЗначенияСвойствОбъектов.НайтиПоКоду("01347"));
	Запрос.УстановитьПараметр("ЛегкоГрузовые", Справочники.ЗначенияСвойствОбъектов.НайтиПоКоду("01330"));
	Запрос.УстановитьПараметр("Свойство", ПланыВидовХарактеристик.СвойстваОбъектов.НайтиПоКоду("00120")); // Св-во производитель/назначение
	

	Результат = Запрос.Выполнить();

	ОбластьЗаголовок = Макет.ПолучитьОбласть("Заголовок");
	ОбластьПодвал = Макет.ПолучитьОбласть("Подвал");
	ОбластьШапкаТаблицы = Макет.ПолучитьОбласть("ШапкаТаблицы");
	ОбластьПодвалТаблицы = Макет.ПолучитьОбласть("ПодвалТаблицы");
	ОбластьДетальныхЗаписей = Макет.ПолучитьОбласть("Детали");

	ТабДок.Очистить();
	
	ОбластьЗаголовок.Параметры.КонДата=Формат(ТекущаяДата(),"ДФ=dd.MM.yyyy") ;
	
	ТабДок.Вывести(ОбластьЗаголовок);
	ТабДок.Вывести(ОбластьШапкаТаблицы);
	ТабДок.НачатьАвтогруппировкуСтрок();

	ВыборкаДетали = Результат.Выбрать();

	
	
	Пока ВыборкаДетали.Следующий() Цикл
		ОбластьДетальныхЗаписей.Параметры.Заполнить(ВыборкаДетали);
		ТабДок.Вывести(ОбластьДетальныхЗаписей, ВыборкаДетали.Уровень());
	КонецЦикла;

	ТабДок.ЗакончитьАвтогруппировкуСтрок();
	ТабДок.Вывести(ОбластьПодвалТаблицы);
	ТабДок.Вывести(ОбластьПодвал);

	Возврат ТабДок;

	
КонецФункции	
Функция СформироватьФормуЗаявкиДляДальнобой()  Экспорт
	ТабДок=Новый ТабличныйДокумент;
	
	Макет = ПолучитьОбщийМакет("МакетФормаЗаявкиДляАвтошины");
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	Спр.Номенклатура.Код КАК КодЯШТ,
	|	Спр.Номенклатура.КодСБИС КАК КодАвтошина,
	|	Спр.Номенклатура,
	|	ВЫРАЗИТЬ(ОстаткиАвтоШина.Остаток КАК ЧИСЛО(15, 0)) КАК Остаток
	|ИЗ
	|	(ВЫБРАТЬ   РАЗЛИЧНЫЕ
	|Объект Номенклатура
	|ИЗ
	|РегистрСведений.ЗначенияСвойствОбъектов ГДЕ
	|Свойство = &Свойство
	|И (Значение =&Легковые)
	|) КАК Спр
	|		ЛЕВОЕ СОЕДИНЕНИЕ (ВЫБРАТЬ
	|			ТоварыНаОтветственномХраненииОстатки.Номенклатура КАК Номенклатура,
	|			ТоварыНаОтветственномХраненииОстатки.КоличествоОстаток КАК Остаток
	|		ИЗ
	|			РегистрНакопления.ТоварыНаОтветственномХранении.Остатки(, Контрагент = &АвтоШина) КАК ТоварыНаОтветственномХраненииОстатки) КАК ОстаткиАвтоШина
	|		ПО Спр.Номенклатура = ОстаткиАвтоШина.Номенклатура
	|
	|УПОРЯДОЧИТЬ ПО
	|	Спр.Номенклатура.Наименование";

	Запрос.УстановитьПараметр("АвтоШина", Справочники.Контрагенты.НайтиПоКоду("92777"));  // Джи Ти
	Запрос.УстановитьПараметр("Шины", Перечисления.ВидыТоваров.Шины);
	Запрос.УстановитьПараметр("Легковые", Справочники.ЗначенияСвойствОбъектов.НайтиПоКоду("01426"));
	Запрос.УстановитьПараметр("Свойство", ПланыВидовХарактеристик.СвойстваОбъектов.НайтиПоКоду("00120")); // Св-во производитель/назначение
	

	Результат = Запрос.Выполнить();

	ОбластьЗаголовок = Макет.ПолучитьОбласть("Заголовок");
	ОбластьПодвал = Макет.ПолучитьОбласть("Подвал");
	ОбластьШапкаТаблицы = Макет.ПолучитьОбласть("ШапкаТаблицы");
	ОбластьПодвалТаблицы = Макет.ПолучитьОбласть("ПодвалТаблицы");
	ОбластьДетальныхЗаписей = Макет.ПолучитьОбласть("Детали");

	ТабДок.Очистить();
	
	ОбластьЗаголовок.Параметры.КонДата=Формат(ТекущаяДата(),"ДФ=dd.MM.yyyy") ;
	
	ТабДок.Вывести(ОбластьЗаголовок);
	ТабДок.Вывести(ОбластьШапкаТаблицы);
	ТабДок.НачатьАвтогруппировкуСтрок();

	ВыборкаДетали = Результат.Выбрать();

	
	
	Пока ВыборкаДетали.Следующий() Цикл
		ОбластьДетальныхЗаписей.Параметры.Заполнить(ВыборкаДетали);
		ТабДок.Вывести(ОбластьДетальныхЗаписей, ВыборкаДетали.Уровень());
	КонецЦикла;

	ТабДок.ЗакончитьАвтогруппировкуСтрок();
	ТабДок.Вывести(ОбластьПодвалТаблицы);
	ТабДок.Вывести(ОбластьПодвал);

	Возврат ТабДок;

	
КонецФункции	

Процедура ВыгрузитьТоварыДляЯндекса() Экспорт
	
	ОбработкаВыгрузки = Обработки.ВыгрузитьДанныеДляЯндекса.Создать();
	ОбработкаВыгрузки.ВыгрузитьДанныеНаВнешнийРесурс();
	
КонецПроцедуры

Процедура ОбновитьСтатусыКонтрагентовПоНоменклГруппам() Экспорт
	
	Обработк = Обработки.ОбновитьСтатусыКонтрагентовПоВидамТоваров.Создать();
	Обработк.ВыполнитьОбновлениеСтатусовКонтрагентовПоНоменклГруппам();
	
КонецПроцедуры

Процедура СообщениеРуководителюОПДЗ() Экспорт
	
	Обработк = Обработки.СообщениеРуководителюОПДЗ.Создать();
	Обработк.ВыполнитьРассылкуОПДЗ();
	
КонецПроцедуры

//Генерит урл моделей дисков и проверяет есть ли такая фотка,
//если нет то записывает в РС ОтсутствующиеФотоМоделей
Процедура ПроверитьДоступностьФотоМоделей() экспорт
	Запрос = новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	СезонныйАссортимент.Номенклатура
	               |ПОМЕСТИТЬ вт
	               |ИЗ
	               |	РегистрСведений.СезонныйАссортимент КАК СезонныйАссортимент
	               |
	               |ОБЪЕДИНИТЬ ВСЕ
	               |
	               |ВЫБРАТЬ
	               |	ЗакупкиОбороты.Номенклатура
	               |ИЗ
	               |	РегистрНакопления.Закупки.Обороты(, , , Номенклатура.ВидТовара = ЗНАЧЕНИЕ(перечисление.ВидыТоваров.Диски)) КАК ЗакупкиОбороты
	               |
	               |ОБЪЕДИНИТЬ ВСЕ
	               |
	               |ВЫБРАТЬ
	               |	Номенклатура.Ссылка
	               |ИЗ
	               |	Справочник.Номенклатура КАК Номенклатура
	               |ГДЕ
	               |	Номенклатура.ПометкаУдаления = ЛОЖЬ
	               |	И Номенклатура.Производитель = &ПроизводительVISSOL
	               |	И Номенклатура.НоменклатурнаяГруппа = &НоменклатурнаяГруппаКованые
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ
	               |	А.Номенклатура,
	               |	А.Номенклатура.Модель КАК НоменклатураМодель,
	               |	А.Номенклатура.Модель.Наименование КАК НоменклатураМодельНаименование,
	               |	взЦвета.Цвет КАК Цвет,
	               |	ЕСТЬNULL(А.Номенклатура.Модель.Наименование, """") + ""_"" + ЕСТЬNULL(взЦвета.Цвет, """") + "".png"" КАК УРЛКартинки
	               |ИЗ
	               |	(ВЫБРАТЬ РАЗЛИЧНЫЕ
	               |		вт.Номенклатура КАК Номенклатура
	               |	ИЗ
	               |		вт КАК вт) КАК А
	               |		ЛЕВОЕ СОЕДИНЕНИЕ (ВЫБРАТЬ
	               |			ЗначенияСвойствОбъектов.Объект КАК Объект,
	               |			ВЫРАЗИТЬ(ЗначенияСвойствОбъектов.Значение КАК СТРОКА(50)) КАК Цвет
	               |		ИЗ
	               |			РегистрСведений.ЗначенияСвойствОбъектов КАК ЗначенияСвойствОбъектов
	               |		ГДЕ
	               |			ЗначенияСвойствОбъектов.Объект В
	               |					(ВЫБРАТЬ
	               |						вт.Номенклатура
	               |					ИЗ
	               |						вт)
	               |			И ЗначенияСвойствОбъектов.Свойство = &СвойствоЦвет) КАК взЦвета
	               |		ПО А.Номенклатура = взЦвета.Объект
	               |ИТОГИ ПО
	               |	НоменклатураМодель,
	               |	Цвет,
	               |	УРЛКартинки";
	Запрос.УстановитьПараметр("СвойствоЦвет",ПланыВидовХарактеристик.СвойстваОбъектов.НайтиПоНаименованию("Цвет"));
	Запрос.УстановитьПараметр("ПроизводительVISSOL",Справочники.Производители.НайтиПоКоду("3657"));
	Запрос.УстановитьПараметр("НоменклатурнаяГруппаКованые",Справочники.НоменклатурныеГруппы.НайтиПоКоду("00022"));
	
	
	РезМодель = Запрос.Выполнить().Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	
	НаборЗаписей = РегистрыСведений.ОтсутствующиеФотоМоделей.СоздатьНаборЗаписей();
	НаборЗаписей.Записать();
	
	Урл = "http://photo.yst.ru/allwheels/";
	Пока РезМодель.Следующий() Цикл
		РезЦвет =РезМодель.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
		пока РезЦвет.Следующий() цикл
			РезУрл =РезЦвет.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
			пока РезУрл.Следующий() цикл
				ИмяВременногоФайла = ПолучитьИмяВременногоФайла(".png");
				УрлКартинки = ""+РезУрл.УРЛКартинки;
				
				ИмяФайла = нрег(Урл+УрлКартинки);
				
				
				Если УрлКартинки = "" тогда
					РезНом = РезУрл.Выбрать();
					пока РезНом.Следующий() цикл 
						МенеджерЗаписи = РегистрыСведений.ОтсутствующиеФотоМоделей.СоздатьМенеджерЗаписи();
						МенеджерЗаписи.Номенклатура = РезНом.Номенклатура;
						МенеджерЗаписи.УрлФото = ИмяФайла;
						МенеджерЗаписи.Записать();
						Сообщить(""+РезНом.Номенклатура+" - "+ИмяФайла);
					КонецЦикла;
				иначе
					попытка
						КопироватьФайл(ИмяФайла, ИмяВременногоФайла);
						УдалитьФайлы(ИмяВременногоФайла);
					Исключение
						РезНом = РезУрл.Выбрать();
						пока РезНом.Следующий() цикл 
							МенеджерЗаписи = РегистрыСведений.ОтсутствующиеФотоМоделей.СоздатьМенеджерЗаписи();
							МенеджерЗаписи.Номенклатура = РезНом.Номенклатура;
							МенеджерЗаписи.УрлФото = ИмяФайла;
							МенеджерЗаписи.Записать();
							Сообщить(""+РезНом.Номенклатура+" - "+ИмяФайла);
						КонецЦикла;
					КонецПопытки; 
				КонецЕсли;
				
			КонецЦикла;
		КонецЦикла;
		
	КонецЦикла;
	
	
	//обновим фото моделей
	ОбновитьУРЛ();
КонецПроцедуры

Процедура ОбновитьУРЛ() Экспорт
	Запрос = новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ РАЗЛИЧНЫЕ
	               |	А.Номенклатура,
	               |	А.Номенклатура.Модель КАК НоменклатураМодель
	               |ПОМЕСТИТЬ втНоменклатура
	               |ИЗ
	               |	(ВЫБРАТЬ
	               |		ТоварыНаСкладахОстатки.Номенклатура КАК Номенклатура
	               |	ИЗ
	               |		РегистрНакопления.ТоварыНаСкладах.Остатки(
	               |				,
	               |				Склад.ЗапретитьИспользование = ЛОЖЬ
	               |					И Номенклатура.ВидТовара = ЗНАЧЕНИЕ(Перечисление.ВидыТоваров.Диски)
	               |					И НЕ Номенклатура.Модель = ЗНАЧЕНИЕ(Справочник.МоделиТоваров.ПустаяСсылка)) КАК ТоварыНаСкладахОстатки
	               |	
	               |	ОБЪЕДИНИТЬ ВСЕ
	               |	
	               |	ВЫБРАТЬ
	               |		СезонныйАссортимент.Номенклатура
	               |	ИЗ
	               |		РегистрСведений.СезонныйАссортимент КАК СезонныйАссортимент
	               |	ГДЕ
	               |		НЕ СезонныйАссортимент.Номенклатура.Модель = ЗНАЧЕНИЕ(Справочник.МоделиТоваров.ПустаяСсылка)
	               |	
	               |	ОБЪЕДИНИТЬ ВСЕ
	               |	
	               |	ВЫБРАТЬ
	               |		Номенклатура.Ссылка
	               |	ИЗ
	               |		Справочник.Номенклатура КАК Номенклатура
	               |	ГДЕ
	               |		Номенклатура.ПометкаУдаления = ложь
	               |		И Номенклатура.Производитель = &ПроизводительVISSOL
	               |		И Номенклатура.НоменклатурнаяГруппа = &НоменклатурнаяГруппаКованые) КАК А
	               |ГДЕ
	               |	НЕ А.Номенклатура.Модель В
	               |				(ВЫБРАТЬ
	               |					ФотоМоделейДисков.Модель
	               |				ИЗ
	               |					РегистрСведений.ФотоМоделейДисков КАК ФотоМоделейДисков)
	               |	И НЕ А.Номенклатура.Модель = ЗНАЧЕНИЕ(Справочник.МоделиТоваров.ПустаяСсылка)
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ РАЗЛИЧНЫЕ
	               |	втНоменклатура.НоменклатураМодель,
	               |	втНоменклатура.Номенклатура,
	               |	ЗначенияСвойствОбъектов.Значение,
	               |	втНоменклатура.НоменклатураМодель.Наименование + ""_"" + (ВЫРАЗИТЬ(ЗначенияСвойствОбъектов.Значение КАК СТРОКА(50))) КАК СтрокаДляПоискаКартинки
	               |ПОМЕСТИТЬ вт
	               |ИЗ
	               |	втНоменклатура КАК втНоменклатура
	               |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.ЗначенияСвойствОбъектов КАК ЗначенияСвойствОбъектов
	               |		ПО втНоменклатура.Номенклатура = ЗначенияСвойствОбъектов.Объект
	               |ГДЕ
	               |	ЗначенияСвойствОбъектов.Свойство = &СвойствоЦвет
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ
	               |	вт.НоменклатураМодель,
	               |	вт.СтрокаДляПоискаКартинки КАК СтрокаДляПоискаКартинки,
	               |	ВЫБОР
	               |		КОГДА ВременныеФото.ИмяФото ЕСТЬ NULL 
	               |			ТОГДА ЛОЖЬ
	               |		ИНАЧЕ ИСТИНА
	               |	КОНЕЦ КАК временная
	               |ПОМЕСТИТЬ втКартинки2
	               |ИЗ
	               |	вт КАК вт
	               |		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ВременныеФото КАК ВременныеФото
	               |		ПО (ВременныеФото.ИмяФото ПОДОБНО вт.СтрокаДляПоискаКартинки СПЕЦСИМВОЛ ""\"")
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ
	               |	втКартинки2.НоменклатураМодель,
	               |	МАКСИМУМ(втКартинки2.СтрокаДляПоискаКартинки) КАК СтрокаДляПоискаКартинки
	               |ИЗ
	               |	втКартинки2 КАК втКартинки2
	               |ГДЕ
	               |	втКартинки2.временная = ЛОЖЬ
	               |
	               |СГРУППИРОВАТЬ ПО
	               |	втКартинки2.НоменклатураМодель";
				   
				   Запрос.УстановитьПараметр("СвойствоЦвет",ПланыВидовХарактеристик.СвойстваОбъектов.НайтиПоНаименованию("Цвет"));
				   Запрос.УстановитьПараметр("ПроизводительVISSOL",Справочники.Производители.НайтиПоКоду("3657"));
					Запрос.УстановитьПараметр("НоменклатурнаяГруппаКованые",Справочники.НоменклатурныеГруппы.НайтиПоКоду("00022"));
				   
				   
				   ЗапросОтсутствующиеКартинки = Новый Запрос;
				   ЗапросОтсутствующиеКартинки.Текст="ВЫБРАТЬ РАЗЛИЧНЫЕ
				                                     |	ОтсутствующиеФотоМоделей.УрлФото
				                                     |ИЗ
				                                     |	РегистрСведений.ОтсутствующиеФотоМоделей КАК ОтсутствующиеФотоМоделей";
				   тзОтсутствующиеФото=ЗапросОтсутствующиеКартинки.Выполнить().Выгрузить();
				   
				   
				   Рез = Запрос.Выполнить().Выбрать();
				   
				   Если Рез.Количество() > 0 тогда
					   НаборЗаписей = РегистрыСведений.ФотоМоделейДисков.СоздатьНаборЗаписей();
					   НаборЗаписей.Записать();
				   КонецЕсли;
				   
				   Пока Рез.Следующий() цикл
					   Если не Рез.СтрокаДляПоискаКартинки="" тогда
						   ИмяФайла = "http://photo.yst.ru/allwheels/"+СокрЛП(нрег(Рез.СтрокаДляПоискаКартинки))+".png";
						   Если тзОтсутствующиеФото.Найти(ИмяФайла,"УрлФото")=неопределено тогда
							   МенеджерЗаписи = РегистрыСведений.ФотоМоделейДисков.СоздатьМенеджерЗаписи();
							   МенеджерЗаписи.Модель = Рез.НоменклатураМодель;
							   МенеджерЗаписи.УрлФото = ИмяФайла;
							   МенеджерЗаписи.Записать();
						   иначе
							   Сообщить("Есть отсутствующее фото: "+ИмяФайла);
						   КонецЕсли;
					   КонецЕсли;   
				   КонецЦикла;
КонецПроцедуры

