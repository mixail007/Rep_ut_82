﻿Перем тзМенеджерПомощник;

Процедура Пауза(Сек)
	Попытка
		scr = Новый COMОбъект("WScript.Shell");
		scr.Run("sleep "+СокрЛП(Число(Сек)),0,1);
	Исключение
	КонецПопытки;
КонецПроцедуры

Процедура ОповеститьПоПодразделениям() Экспорт
	
	МВТ=Новый МенеджерВременныхТаблиц;
	Запрос= новый Запрос;
	Запрос.МенеджерВременныхТаблиц=МВТ;
	НачДата=КонецМесяца(ТекущаяДата())+1;
	//НачДата=КонецМесяца(Дата(2014,6,1))+1;
	КонецПоступлений=КонецМесяца(НачДата);
	Запрос.УстановитьПараметр("ДатаНач",НачДата);
	Запрос.УстановитьПараметр("ДатаКон",КонецДня(НачДата+20*86400)); //до 20 числа
	Запрос.УстановитьПараметр("ДатаКон",КонецМесяца(НачДата));

	Запрос.УстановитьПараметр("КонецПоступлений",КонецДня(НачДата+20*86400));
	Запрос.УстановитьПараметр("ПустаяДата",Дата(1,1,1));
	Запрос.УстановитьПараметр("Диски",Перечисления.ВидыТоваров.Диски);
	Запрос.УстановитьПараметр("ДатаНТекМесяц",НачалоМесяца(ТекущаяДата()));
	Запрос.УстановитьПараметр("ДатаКТекМесяц",КонецМесяца(ТекущаяДата()));
	Запрос.Текст="ВЫБРАТЬ
	             |	ЗаказыПоставщикамОстатки.Номенклатура,
	             |	СУММА(ЗаказыПоставщикамОстатки.КоличествоОстаток) КАК Количество,
	             |	ЗаказыПоставщикамОстатки.Номенклатура.Производитель,
	             |	ЗаказыПоставщикамОстатки.ЗаказПоставщику.Подразделение КАК Подразделение,
	             |	ЗаказыПоставщикамОстатки.ЗаказПоставщику.НомерКонтейнера КАК НомерКонтейнера,
	             |	ЗаказыПоставщикамОстатки.ЗаказПоставщику.ДатаПоступления КАК ДатаПоступления,
	             |	ЗаказыПоставщикамОстатки.ЗаказПоставщику.Грузополучатель КАК Грузополучатель,
	             |	ЗаказыПоставщикамОстатки.ЗаказПоставщику.Транзит КАК Транзит,
	             |	ЗаказыПоставщикамОстатки.ДоговорКонтрагента.ОтветственноеЛицо КАК ГрузополучательОсновнойДоговорКонтрагентаОтветственноеЛицо,
	             |	ЗаказыПоставщикамОстатки.ЗаказПоставщику
	             |ПОМЕСТИТЬ втТЧ
	             |ИЗ
	             |	РегистрНакопления.ЗаказыПоставщикам.Остатки(
	             |			,
	             |			ЗаказПоставщику.ДатаПоступления <= &КонецПоступлений
	             |				И ЗаказПоставщику.ДатаПоступления <> &ПустаяДата
	             |				И ЗаказПоставщику.НомерКонтейнера <> """"
	             |				И Номенклатура.ВидТовара = &Диски) КАК ЗаказыПоставщикамОстатки
	             |ГДЕ
	             |	ЗаказыПоставщикамОстатки.КоличествоОстаток > 0
	             |
	             |СГРУППИРОВАТЬ ПО
	             |	ЗаказыПоставщикамОстатки.Номенклатура,
	             |	ЗаказыПоставщикамОстатки.ЗаказПоставщику.Подразделение,
	             |	ЗаказыПоставщикамОстатки.ЗаказПоставщику.НомерКонтейнера,
	             |	ЗаказыПоставщикамОстатки.ЗаказПоставщику.Грузополучатель,
	             |	ЗаказыПоставщикамОстатки.ЗаказПоставщику.ДатаПоступления,
	             |	ЗаказыПоставщикамОстатки.ЗаказПоставщику.Транзит,
	             |	ЗаказыПоставщикамОстатки.ДоговорКонтрагента.ОтветственноеЛицо,
	             |	ЗаказыПоставщикамОстатки.Номенклатура.Производитель,
	             |	ЗаказыПоставщикамОстатки.ЗаказПоставщику
	             |;
	             |
	             |////////////////////////////////////////////////////////////////////////////////
	             |ВЫБРАТЬ РАЗЛИЧНЫЕ
	             |	ЗаданиеНаОтгрузкуЗаказыПоставщикам.ЗаказПоставщику
	             |ПОМЕСТИТЬ втЗаказыНаВыгрузкеВТекМесяце
	             |ИЗ
	             |	Документ.ЗаданиеНаОтгрузку.ЗаказыПоставщикам КАК ЗаданиеНаОтгрузкуЗаказыПоставщикам
	             |ГДЕ
	             |	ЗаданиеНаОтгрузкуЗаказыПоставщикам.Ссылка.Дата МЕЖДУ &ДатаНТекМесяц И &ДатаКТекМесяц
	             |	И ЗаданиеНаОтгрузкуЗаказыПоставщикам.ЗаказПоставщику В
	             |			(ВЫБРАТЬ
	             |				втТЧ.ЗаказПоставщику
	             |			ИЗ
	             |				втТЧ КАК втТЧ)
	             |	И ЗаданиеНаОтгрузкуЗаказыПоставщикам.Ссылка.ПометкаУдаления = ЛОЖЬ
	             |;
	             |
	             |////////////////////////////////////////////////////////////////////////////////
	             |ВЫБРАТЬ
	             |	КонтактнаяИнформация.Объект КАК Объект,
	             |	ВЫРАЗИТЬ(КонтактнаяИнформация.Представление КАК СТРОКА(200)) КАК Представление
	             |ПОМЕСТИТЬ втАдреса
	             |ИЗ
	             |	РегистрСведений.КонтактнаяИнформация КАК КонтактнаяИнформация
	             |ГДЕ
	             |	КонтактнаяИнформация.Тип = ЗНАЧЕНИЕ(Перечисление.ТипыКонтактнойИнформации.АдресЭлектроннойПочты)
	             |	И КонтактнаяИнформация.Вид = ЗНАЧЕНИЕ(Справочник.ВидыКонтактнойИнформации.СлужебныйАдресЭлектроннойПочтыПользователя)
	             |;
	             |
	             |////////////////////////////////////////////////////////////////////////////////
	             |ВЫБРАТЬ
	             |	втТЧ.Номенклатура,
	             |	втТЧ.Количество,
	             |	втТЧ.НоменклатураПроизводитель,
	             |	втТЧ.Подразделение,
	             |	втТЧ.НомерКонтейнера,
	             |	втТЧ.ДатаПоступления,
	             |	втТЧ.Грузополучатель,
	             |	втТЧ.ГрузополучательОсновнойДоговорКонтрагентаОтветственноеЛицо,
	             |	ЕСТЬNULL(втАдреса.Представление, """") КАК Адрес,
	             |	втТЧ.Транзит
	             |ПОМЕСТИТЬ втОсноваОБЩ
	             |ИЗ
	             |	втТЧ КАК втТЧ
	             |		ЛЕВОЕ СОЕДИНЕНИЕ втАдреса КАК втАдреса
	             |		ПО втТЧ.ГрузополучательОсновнойДоговорКонтрагентаОтветственноеЛицо = втАдреса.Объект
				 //|ГДЕ                                                                                                 //***заремлено 03.02.2016 ибо когда делалось это условие подразумевалось, что
				                                                                                                        //задание на отгрузку будет вводиться непосредственно перед заездом машины на территорию склада.
				 //|	НЕ втТЧ.ЗаказПоставщику В                                                                       //сейчас задание на отгр делается заранее (до 7 дней), поэтому такие заказы исключаются из рассылки
				 //|				(ВЫБРАТЬ
				 //|					втЗаказыНаВыгрузкеВТекМесяце.ЗаказПоставщику
				 //|				ИЗ
				 //|					втЗаказыНаВыгрузкеВТекМесяце КАК втЗаказыНаВыгрузкеВТекМесяце)
				 |";
	
	Запрос.Выполнить();
	//Сначала посылаем информацию по подразделениям, потом по грузополучателям
	Адреса=Новый СписокЗначений;
	Адреса.Добавить("MALYSHEV@YST.RU");
	Адреса.Добавить("novikova@YST.RU");
	
	СписокПодразделений=Новый СписокЗначений;
	СписокПодразделений.Добавить(Справочники.Подразделения.ПустаяСсылка()); 
	СписокПодразделений.Добавить(Справочники.Подразделения.НайтиПоКоду("00005")); //Головное подразделение Ярославль
	ОтправитьПисьмаПоПодразделениям(Адреса,СписокПодразделений,Запрос,НачДата);
	
	//этим товарищам - по всем филиалам
	Адреса.Очистить();
	Адреса.Добавить("bondarenko@YST.RU");
		//+++ 01.07.2016 - рассылка
		Адреса.Добавить("lusine@YST.RU");
		Адреса.Добавить("mikhail_zh@yst.ru ");
		Адреса.Добавить("roman_nr@YST.RU");
		Адреса.Добавить("smirnov_ua@yst.ru");
		Адреса.Добавить("budanova@yst.ru"); 
	
	Адреса.Добавить("MALYSHEV@YST.RU");
	Адреса.Добавить("novikova@YST.RU");
	СписокПодразделений.Очистить();
	СписокПодразделений.Добавить(Справочники.Подразделения.НайтиПоКоду("00112")); //Подразделение Санкт-Петербург
	СписокПодразделений.Добавить(Справочники.Подразделения.НайтиПоКоду("00106")); //Подразделение Ростов на Дону
	//16.09.2015	
	//СписокПодразделений.Добавить(Справочники.Подразделения.НайтиПоКоду("00122")); //Подразделение Екатеринбург
	СписокПодразделений.Добавить(Справочники.Подразделения.НайтиПоКоду("00138")); //Подразделение Екатеринбург
	ОтправитьПисьмаПоПодразделениям(Адреса,СписокПодразделений,Запрос,НачДата);
	
//=================================Отдельно по каждому=========================================================	
	СписокПодразделений.Очистить();
	СписокПодразделений.Добавить(Справочники.Подразделения.НайтиПоКоду("00112")); //Подразделение Санкт-Петербург
	Адреса.Очистить();
	Адреса.Добавить(РегистрыСведений.КонтактнаяИнформация.Получить(Новый Структура("Объект,Тип,Вид",Справочники.Подразделения.НайтиПоКоду("00112").Руководитель,Перечисления.ТипыКонтактнойИнформации.АдресЭлектроннойПочты,Справочники.ВидыКонтактнойИнформации.СлужебныйАдресЭлектроннойПочтыПользователя)));
	ОтправитьПисьмаПоПодразделениям(Адреса,СписокПодразделений,Запрос,НачДата);
	
	СписокПодразделений.Очистить();
	СписокПодразделений.Добавить(Справочники.Подразделения.НайтиПоКоду("00106"));//Подразделение Ростов на Дону
	Адреса.Очистить();
	Адреса.Добавить(РегистрыСведений.КонтактнаяИнформация.Получить(Новый Структура("Объект,Тип,Вид",Справочники.Подразделения.НайтиПоКоду("00106").Руководитель,Перечисления.ТипыКонтактнойИнформации.АдресЭлектроннойПочты,Справочники.ВидыКонтактнойИнформации.СлужебныйАдресЭлектроннойПочтыПользователя)));
	ОтправитьПисьмаПоПодразделениям(Адреса,СписокПодразделений,Запрос,НачДата);
	
	СписокПодразделений.Очистить();
	СписокПодразделений.Добавить(Справочники.Подразделения.НайтиПоКоду("00138"));//Подразделение Екатеринбург
	Адреса.Очистить();
	Адреса.Добавить(РегистрыСведений.КонтактнаяИнформация.Получить(Новый Структура("Объект,Тип,Вид",Справочники.Подразделения.НайтиПоКоду("00138").Руководитель,Перечисления.ТипыКонтактнойИнформации.АдресЭлектроннойПочты,Справочники.ВидыКонтактнойИнформации.СлужебныйАдресЭлектроннойПочтыПользователя)));
	ОтправитьПисьмаПоПодразделениям(Адреса,СписокПодразделений,Запрос,НачДата);
	
	
	///Теперь сформируем письма для менеджеров грузополучателей
	Запрос.Текст="ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	втОсноваОБЩ.ГрузополучательОсновнойДоговорКонтрагентаОтветственноеЛицо,
	|	втОсноваОБЩ.Адрес
	|ИЗ
	|	втОсноваОБЩ КАК втОсноваОБЩ
	|ГДЕ
	|	втОсноваОБЩ.Адрес <> """"
	|	И втОсноваОБЩ.Транзит";
	Рез=Запрос.Выполнить().Выбрать();
	Пока Рез.Следующий() Цикл
		//Если нрег(Рез.Адрес)="bondarenko@yst76.ru" тогда
			ОтправитьПисьмаПоМенеджерам(Рез.Адрес,Рез.ГрузополучательОсновнойДоговорКонтрагентаОтветственноеЛицо,Запрос,НачДата);
		//КонецЕсли;
	КонецЦикла;
КонецПроцедуры

Процедура ОтправитьПисьмаПоПодразделениям(Адресаты,СписокПодразделений,Запрос,НачДата)
	
	Вложение1=ПолучитьИмяВременногоФайла("xls");
	Вложение2=ПолучитьИмяВременногоФайла("xls");
	Запрос.УстановитьПараметр("СписокПодразделений",СписокПодразделений);
	Запрос.Текст="Выбрать * Поместить втОснова из втОсноваОБЩ как втОсноваОБЩ где втОсноваОБЩ.Подразделение в (&СписокПодразделений)";
	Запрос.Выполнить();
	
	Запрос.Текст="ВЫБРАТЬ
	|	втОснова.Подразделение КАК Подразделение,
	|	втОснова.НоменклатураПроизводитель КАК НоменклатураПроизводитель,
	|	СУММА(втОснова.Количество) КАК Количество
	|ИЗ
	|	втОснова КАК втОснова
	|
	|СГРУППИРОВАТЬ ПО
	|	втОснова.Подразделение,
	|	втОснова.НоменклатураПроизводитель
	|
	|УПОРЯДОЧИТЬ ПО
	|	Подразделение.Наименование,
	|	НоменклатураПроизводитель.Наименование
	|ИТОГИ
	|	СУММА(Количество)
	|ПО
	|	Подразделение,
	|	НоменклатураПроизводитель";
	//ВремФайл=ПолучитьИмяВременногоФайла("txt");
	ТекстПисьма = "";//Новый ЗаписьТекста(ВремФайл);
	ВыборкаПодразделение=Запрос.Выполнить().Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	Пока ВыборкаПодразделение.Следующий() Цикл
		//ТекстПисьма.ЗаписатьСтроку("Подразделение: "+ВыборкаПодразделение.Подразделение);
		ТекстПисьма=ТекстПисьма+"Подразделение: "+ВыборкаПодразделение.Подразделение+Символы.ПС;
		ВыборкаБренд=ВыборкаПодразделение.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
		Пока ВыборкаБренд.Следующий() Цикл
			Стр=""+ВыборкаБренд.НоменклатураПроизводитель;
			ТекстПисьма=ТекстПисьма+"              "+ДополнитьСтрокуЯ(стр,30," ",1)+"	"+ВыборкаБренд.Количество+Символы.ПС;
		КонецЦикла;
		стр="Итого по "+ВыборкаПодразделение.Подразделение;
		ТекстПисьма=ТекстПисьма+ДополнитьСтрокуЯ(стр,45," ",1)+"	"+ВыборкаПодразделение.Количество+Символы.ПС;
		ТекстПисьма=ТекстПисьма+"____________________________________________________________"+символы.ПС;
	КонецЦикла;
	//ТекстПисьма.Закрыть();
	
	Запрос.Текст="ВЫБРАТЬ
	|	втОснова.Подразделение КАК Подразделение,
	|	втОснова.Номенклатура КАК Номенклатура,
	|	втОснова.Номенклатура.Код КАК Код,
	|	втОснова.НомерКонтейнера КАК НомерКонтейнера,
	|	втОснова.ДатаПоступления КАК ДатаПоступления,
	|	СУММА(втОснова.Количество) КАК Количество
	|ИЗ
	|	втОснова КАК втОснова
	|
	|СГРУППИРОВАТЬ ПО
	|	втОснова.ДатаПоступления,
	|	втОснова.НомерКонтейнера,
	|	втОснова.Номенклатура,
	|	втОснова.Подразделение
	|
	|УПОРЯДОЧИТЬ ПО
	|	Подразделение.Наименование,
	|	ДатаПоступления,
	|  НомерКонтейнера,
	|	Номенклатура.Наименование
	|ИТОГИ
	|МАКСИМУМ(ДатаПоступления),
	|	СУММА(Количество)
	|ПО
	|	Подразделение,
	|	НомерКонтейнера";
	
	ТабДок=Новый ТабличныйДокумент;
	Макет=ПолучитьМакет("МакетВложение1");
	ОбластьШапка=Макет.ПолучитьОбласть("Шапка");
	ОбластьКонтейнер=Макет.ПолучитьОбласть("СтрокаКонтейнер");
	ОбластьНоменклатура=Макет.ПолучитьОбласть("СтрокаНоменклатура");
	ОбластьИтог=Макет.ПолучитьОбласть("Подвал");
	ТабДок.НачатьАвтогруппировкуСтрок();
	ВыборкаПодразделение=Запрос.Выполнить().Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	Пока ВыборкаПодразделение.Следующий() цикл
		ОбластьШапка.Параметры.Подразделение=ВыборкаПодразделение.Подразделение;
		ОбластьИтог.Параметры.Количество=ВыборкаПодразделение.Количество;
		
		ТабДок.Вывести(ОбластьШапка,1);
		ВыборкаКонтейнер=ВыборкаПодразделение.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
		Пока ВыборкаКонтейнер.Следующий() Цикл
			ОбластьКонтейнер.Параметры.ДатаПоступления=ВыборкаКонтейнер.ДатаПоступления;
			ОбластьКонтейнер.Параметры.НомерКонтейнера=ВыборкаКонтейнер.НомерКонтейнера;
			ОбластьКонтейнер.Параметры.Количество=ВыборкаКонтейнер.Количество;
			ТабДок.Вывести(ОбластьКонтейнер,2);
			ВыборкаНоменклатура=ВыборкаКонтейнер.Выбрать();
			Пока ВыборкаНоменклатура.Следующий() Цикл
				ОбластьНоменклатура.Параметры.Номенклатура	=ВыборкаНоменклатура.Номенклатура;
				ОбластьНоменклатура.Параметры.Код	=ВыборкаНоменклатура.Код;
				ОбластьНоменклатура.Параметры.Количество=ВыборкаНоменклатура.Количество;
				ТабДок.Вывести(ОбластьНоменклатура,3);
			КонецЦикла;
		КонецЦикла;
		ТабДок.Вывести(ОбластьИтог,1);
	КонецЦикла;
	ТабДок.ЗакончитьАвтогруппировкуСтрок();
	ТабДок.ПоказатьУровеньГруппировокСтрок(2);
	табДок.Записать(Вложение1, ТипФайлаТабличногоДокумента.XLS);
	
	Вложение1ZIP=КаталогВременныхФайлов()+"\Вложение1.zip";
	Архив = Новый ЗаписьZIPФайла(Вложение1ZIP,,,
	МетодСжатияZIP.Сжатие, УровеньСжатияZIP.Максимальный, МетодШифрованияZIP.Zip20);
	Архив.Добавить(Вложение1, РежимСохраненияПутейZIP.НеСохранятьПути);
	Архив.Записать();
	
	Дата20=КонецДня(Дата(Год(НачДата),Месяц(НачДата),20));
	Запрос.УстановитьПараметр("Дата20",Дата20);
	Запрос.Текст="ВЫБРАТЬ
	|	втОснова.Номенклатура,
	|	втОснова.Номенклатура.Код КАК Код,
	|	втОснова.НоменклатураПроизводитель КАК Производитель,
	|	втОснова.Подразделение КАК Подразделение,
	|	СУММА(ВЫБОР
	|			КОГДА втОснова.ДатаПоступления <= &Дата20
	|				ТОГДА втОснова.Количество
	|			ИНАЧЕ 0
	|		КОНЕЦ) КАК КоличествоДо20,
	|	СУММА(ВЫБОР
	|			КОГДА втОснова.ДатаПоступления > &Дата20
	|				ТОГДА втОснова.Количество
	|			ИНАЧЕ 0
	|		КОНЕЦ) КАК КоличествоПосле20
	|ИЗ
	|	втОснова КАК втОснова
	|
	|СГРУППИРОВАТЬ ПО
	|	втОснова.НоменклатураПроизводитель,
	|	втОснова.Подразделение,
	|	втОснова.Номенклатура
	|
	|УПОРЯДОЧИТЬ ПО
	|	втОснова.Подразделение.Наименование,
	|	втОснова.НоменклатураПроизводитель.Наименование,
	|	втОснова.Номенклатура.Наименование
	|ИТОГИ
	|	СУММА(КоличествоДо20),
	|	СУММА(КоличествоПосле20)
	|ПО
	|	Подразделение,
	|	НоменклатураПроизводитель";
	
	ТабДок=Новый ТабличныйДокумент;
	Макет=ПолучитьМакет("МакетВложение2");
	ОбластьШапка=Макет.ПолучитьОбласть("Шапка");
	ОбластьПроизводитель=Макет.ПолучитьОбласть("СтрокаПроизводитель");
	ОбластьНоменклатура=Макет.ПолучитьОбласть("СтрокаНоменклатура");
	ОбластьИтог=Макет.ПолучитьОбласть("Подвал");
	ТабДок.НачатьАвтогруппировкуСтрок();
	
	
	ВыборкаПодразделение=Запрос.Выполнить().Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);	 
	Пока ВыборкаПодразделение.Следующий() Цикл
		ОбластьШапка.Параметры.Подразделение=ВыборкаПодразделение.Подразделение;
		ТабДок.Вывести(ОбластьШапка,1);
		ВыборкаПроизводитель=ВыборкаПодразделение.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
		Пока ВыборкаПроизводитель.Следующий() Цикл
			ОбластьПроизводитель.Параметры.Производитель=ВыборкаПроизводитель.Производитель;
			ОбластьПроизводитель.Параметры.КоличествоДо20=ВыборкаПроизводитель.КоличествоДо20;
			ОбластьПроизводитель.Параметры.КоличествоПосле20=ВыборкаПроизводитель.КоличествоПосле20;
			ТабДок.Вывести(ОбластьПроизводитель,2);
			ВыборкаНоменклатура=ВыборкаПроизводитель.Выбрать();
			Пока ВыборкаНоменклатура.Следующий() Цикл
				ОбластьНоменклатура.Параметры.Номенклатура=ВыборкаНоменклатура.Номенклатура;
				ОбластьНоменклатура.Параметры.Код=ВыборкаНоменклатура.Код;
				ОбластьНоменклатура.Параметры.КоличествоДо20=ВыборкаНоменклатура.КоличествоДо20;
				ОбластьНоменклатура.Параметры.КоличествоПосле20=ВыборкаНоменклатура.КоличествоПосле20;
				ТабДок.Вывести(ОбластьНоменклатура,3);
			КонецЦикла;
		КонецЦикла;
		ОбластьИтог.Параметры.КоличествоДо20=ВыборкаПодразделение.КоличествоДо20;
		ОбластьИтог.Параметры.КоличествоПосле20=ВыборкаПодразделение.КоличествоПосле20;
		ТабДок.Вывести(ОбластьИтог,1);
	КонецЦикла;
	ТабДок.ЗакончитьАвтогруппировкуСтрок();
	ТабДок.ПоказатьУровеньГруппировокСтрок(2);
	табДок.Записать(Вложение2, ТипФайлаТабличногоДокумента.XLS);
	
	Вложение2ZIP=КаталогВременныхФайлов()+"\Вложение2.zip";
	Архив = Новый ЗаписьZIPФайла(Вложение2ZIP,,,
	МетодСжатияZIP.Сжатие, УровеньСжатияZIP.Максимальный, МетодШифрованияZIP.Zip20);
	Архив.Добавить(Вложение2, РежимСохраненияПутейZIP.НеСохранятьПути);
	Архив.Записать();
	
	Если ВыборкаПодразделение.Количество()>0 тогда
		
		Профиль = Новый ИнтернетПочтовыйПрофиль;
		Профиль.АдресСервераSMTP   = "mail.yst76.ru";
		Профиль.ПортSMTP		   = 25;
		Профиль.АутентификацияSMTP = СпособSMTPАутентификации.БезАутентификации;
		Профиль.ПарольSMTP         = "";
		Профиль.ПользовательSMTP   = "";
		Письмо = Новый ИнтернетПочтовоеСообщение;
		Письмо.Отправитель = "no-reply@yst76.ru";
		Для каждого Адр из Адресаты Цикл
			Письмо.Получатели.Добавить(Адр.Значение);
		КонецЦикла;
		
		Письмо.Получатели.Добавить("smirnov@yst.ru");
		Письмо.Получатели.Добавить("MALYSHEV@YST76.RU");
		Письмо.Получатели.Добавить("smirnov@yst.ru");
		Письмо.Получатели.Добавить("serebrennikovaa@mail.ru");
		Письмо.Получатели.Добавить("lusine@yst.ru");
		Письмо.Получатели.Добавить("troshin@yst.ru");
		Письмо.Получатели.Добавить("roman_nr@yst.ru");
		Письмо.Получатели.Добавить("budanova@yst.ru");
		//+12.01.2018
		Письмо.Получатели.Добавить("roman_nr@yst.ru");
		Письмо.Получатели.Добавить("mikhail_zh@yst.ru");
		Письмо.Получатели.Добавить("klimovich@yst.ru");
		Письмо.Получатели.Добавить("yudin@yst.ru");
		//-12.01.2018
		
		//+23.01.2018
		Письмо.Получатели.Добавить("emelyanov@yst.ru");
		Письмо.Получатели.Добавить("gorelov@yst.ru");
		//-23.01.2018
		
		Письмо.Вложения.Добавить(Вложение1ZIP,"Вложение 1");
		Письмо.Вложения.Добавить(Вложение2ZIP,"Вложение 2");
		Письмо.Тема = "Приход контейнеров в следующем месяце.";
		Письмо.Тексты.Добавить(ТекстПисьма,ТипТекстаПочтовогоСообщения.ПростойТекст);
		Почта = Новый ИнтернетПочта;
		
		Попытка
			Почта.Подключиться(Профиль);
			Почта.Послать(Письмо);
			Почта.Отключиться();
		Исключение
			Пауза(20);
			Почта.Подключиться(Профиль);
			Почта.Послать(Письмо);
			Почта.Отключиться();
		КонецПопытки;
	КонецЕсли;
	Запрос.Текст="УНИЧТОЖИТЬ втОснова";
	Запрос.Выполнить();
КонецПроцедуры

Процедура ОтправитьПисьмаПоМенеджерам(Адрес,Менеджер,Запрос,НачДата)
	Вложение1=ПолучитьИмяВременногоФайла("xls");
	Вложение2=ПолучитьИмяВременногоФайла("xls");
	Запрос.УстановитьПараметр("Менеджер",Менеджер);
	Запрос.Текст="ВЫБРАТЬ * 
	|				ПОМЕСТИТЬ втОснова 
	|				ИЗ втОсноваОБЩ 
	|				КАК втОсноваОБЩ 
	|				ГДЕ втОсноваОБЩ.ГрузополучательОсновнойДоговорКонтрагентаОтветственноеЛицо=&Менеджер
	|					и втОсноваОБЩ.Грузополучатель<>Значение(Справочник.Контрагенты.ПустаяСсылка)";
	
	Запрос.Выполнить();
	
	Запрос.Текст="ВЫБРАТЬ
	|	втОснова.Грузополучатель КАК Грузополучатель,
	|	втОснова.НоменклатураПроизводитель КАК НоменклатураПроизводитель,
	|	СУММА(втОснова.Количество) КАК Количество
	|ИЗ
	|	втОснова КАК втОснова
	|
	|СГРУППИРОВАТЬ ПО
	|	втОснова.Грузополучатель,
	|	втОснова.НоменклатураПроизводитель
	|
	|УПОРЯДОЧИТЬ ПО
	|	Грузополучатель.Наименование,
	|	НоменклатураПроизводитель.Наименование
	|ИТОГИ
	|	СУММА(Количество)
	|ПО
	|	Грузополучатель,
	|	НоменклатураПроизводитель";
	//ВремФайл=ПолучитьИмяВременногоФайла("txt");
	ТекстПисьма = "";//Новый ЗаписьТекста(ВремФайл);
	ВыборкаГрузополучатель=Запрос.Выполнить().Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	Пока ВыборкаГрузополучатель.Следующий() Цикл
		//ТекстПисьма.ЗаписатьСтроку("Подразделение: "+ВыборкаПодразделение.Подразделение);
		ТекстПисьма=ТекстПисьма+"Грузополучатель: "+ВыборкаГрузополучатель.Грузополучатель+Символы.ПС;
		ВыборкаБренд=ВыборкаГрузополучатель.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
		Пока ВыборкаБренд.Следующий() Цикл
			Стр=""+ВыборкаБренд.НоменклатураПроизводитель;
			ТекстПисьма=ТекстПисьма+"              "+ДополнитьСтрокуЯ(стр,30," ",1)+"	"+ВыборкаБренд.Количество+Символы.ПС;
		КонецЦикла;
		стр="Итого по "+ВыборкаГрузополучатель.Грузополучатель;
		ТекстПисьма=ТекстПисьма+ДополнитьСтрокуЯ(стр,45," ",1)+"	"+ВыборкаГрузополучатель.Количество+Символы.ПС;
		ТекстПисьма=ТекстПисьма+"____________________________________________________________"+символы.ПС;
	КонецЦикла;
	//ТекстПисьма.Закрыть();
	
	Запрос.Текст="ВЫБРАТЬ
	|	втОснова.Грузополучатель КАК Грузополучатель,
	|	втОснова.Номенклатура КАК Номенклатура,
	|	втОснова.Номенклатура.Код КАК Код,
	|	втОснова.НомерКонтейнера КАК НомерКонтейнера,
	|	втОснова.ДатаПоступления КАК ДатаПоступления,
	|	СУММА(втОснова.Количество) КАК Количество
	|ИЗ
	|	втОснова КАК втОснова
	|
	|СГРУППИРОВАТЬ ПО
	|	втОснова.ДатаПоступления,
	|	втОснова.НомерКонтейнера,
	|	втОснова.Номенклатура,
	|	втОснова.Грузополучатель
	|
	|УПОРЯДОЧИТЬ ПО
	|	Грузополучатель.Наименование,
	|	ДатаПоступления,
	|   НомерКонтейнера,
	|	Номенклатура.Наименование
	|ИТОГИ
	|МАКСИМУМ(ДатаПоступления),
	|	СУММА(Количество)
	|ПО
	|	Грузополучатель,
	|	НомерКонтейнера";
	
	ТабДок=Новый ТабличныйДокумент;
	Макет=ПолучитьМакет("МакетВложение1");
	ОбластьШапка=Макет.ПолучитьОбласть("Шапка");
	ОбластьКонтейнер=Макет.ПолучитьОбласть("СтрокаКонтейнер");
	ОбластьНоменклатура=Макет.ПолучитьОбласть("СтрокаНоменклатура");
	ОбластьИтог=Макет.ПолучитьОбласть("Подвал");
	ТабДок.НачатьАвтогруппировкуСтрок();
	ВыборкаГрузополучатель=Запрос.Выполнить().Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	Пока ВыборкаГрузополучатель.Следующий() цикл
		ОбластьШапка.Параметры.Подразделение=ВыборкаГрузополучатель.Грузополучатель;
		ОбластьИтог.Параметры.Количество=ВыборкаГрузополучатель.Количество;
		
		ТабДок.Вывести(ОбластьШапка,1);
		ВыборкаКонтейнер=ВыборкаГрузополучатель.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
		Пока ВыборкаКонтейнер.Следующий() Цикл
			ОбластьКонтейнер.Параметры.ДатаПоступления=ВыборкаКонтейнер.ДатаПоступления;
			ОбластьКонтейнер.Параметры.НомерКонтейнера=ВыборкаКонтейнер.НомерКонтейнера;
			ОбластьКонтейнер.Параметры.Количество=ВыборкаКонтейнер.Количество;
			ТабДок.Вывести(ОбластьКонтейнер,2);
			ВыборкаНоменклатура=ВыборкаКонтейнер.Выбрать();
			Пока ВыборкаНоменклатура.Следующий() Цикл
				ОбластьНоменклатура.Параметры.Номенклатура	=ВыборкаНоменклатура.Номенклатура;
				ОбластьНоменклатура.Параметры.Код	=ВыборкаНоменклатура.Код;
				ОбластьНоменклатура.Параметры.Количество=ВыборкаНоменклатура.Количество;
				ТабДок.Вывести(ОбластьНоменклатура,3);
			КонецЦикла;
		КонецЦикла;
		ТабДок.Вывести(ОбластьИтог,1);
	КонецЦикла;
	ТабДок.ЗакончитьАвтогруппировкуСтрок();
	ТабДок.ПоказатьУровеньГруппировокСтрок(2);
	табДок.Записать(Вложение1, ТипФайлаТабличногоДокумента.XLS);
	
	Вложение1ZIP=КаталогВременныхФайлов()+"\Вложение1.zip";
	Архив = Новый ЗаписьZIPФайла(Вложение1ZIP,,,
	МетодСжатияZIP.Сжатие, УровеньСжатияZIP.Максимальный, МетодШифрованияZIP.Zip20);
	Архив.Добавить(Вложение1, РежимСохраненияПутейZIP.НеСохранятьПути);
	Архив.Записать();
	
	Дата20=КонецДня(Дата(Год(НачДата),Месяц(НачДата),20));
	Запрос.УстановитьПараметр("Дата20",Дата20);
	Запрос.Текст="ВЫБРАТЬ
	|	втОснова.Номенклатура,
	|	втОснова.Номенклатура.Код КАК Код,
	|	втОснова.НоменклатураПроизводитель КАК Производитель,
	|	втОснова.Грузополучатель КАК Грузополучатель,
	|	СУММА(ВЫБОР
	|			КОГДА втОснова.ДатаПоступления <= &Дата20
	|				ТОГДА втОснова.Количество
	|			ИНАЧЕ 0
	|		КОНЕЦ) КАК КоличествоДо20,
	|	СУММА(ВЫБОР
	|			КОГДА втОснова.ДатаПоступления > &Дата20
	|				ТОГДА втОснова.Количество
	|			ИНАЧЕ 0
	|		КОНЕЦ) КАК КоличествоПосле20
	|ИЗ
	|	втОснова КАК втОснова
	|
	|СГРУППИРОВАТЬ ПО
	|	втОснова.НоменклатураПроизводитель,
	|	втОснова.Грузополучатель,
	|	втОснова.Номенклатура
	|
	|УПОРЯДОЧИТЬ ПО
	|	втОснова.Грузополучатель.Наименование,
	|	втОснова.НоменклатураПроизводитель.Наименование,
	|	втОснова.Номенклатура.Наименование
	|ИТОГИ
	|	СУММА(КоличествоДо20),
	|	СУММА(КоличествоПосле20)
	|ПО
	|	Грузополучатель,
	|	НоменклатураПроизводитель";
	
	ТабДок=Новый ТабличныйДокумент;
	Макет=ПолучитьМакет("МакетВложение2");
	ОбластьШапка=Макет.ПолучитьОбласть("Шапка");
	ОбластьПроизводитель=Макет.ПолучитьОбласть("СтрокаПроизводитель");
	ОбластьНоменклатура=Макет.ПолучитьОбласть("СтрокаНоменклатура");
	ОбластьИтог=Макет.ПолучитьОбласть("Подвал");
	ТабДок.НачатьАвтогруппировкуСтрок();
	
	
	ВыборкаГрузополучатель=Запрос.Выполнить().Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);	 
	Пока ВыборкаГрузополучатель.Следующий() Цикл
		ОбластьШапка.Параметры.Подразделение=ВыборкаГрузополучатель.Грузополучатель;
		ТабДок.Вывести(ОбластьШапка,1);
		ВыборкаПроизводитель=ВыборкаГрузополучатель.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
		Пока ВыборкаПроизводитель.Следующий() Цикл
			ОбластьПроизводитель.Параметры.Производитель=ВыборкаПроизводитель.Производитель;
			ОбластьПроизводитель.Параметры.КоличествоДо20=ВыборкаПроизводитель.КоличествоДо20;
			ОбластьПроизводитель.Параметры.КоличествоПосле20=ВыборкаПроизводитель.КоличествоПосле20;
			ТабДок.Вывести(ОбластьПроизводитель,2);
			ВыборкаНоменклатура=ВыборкаПроизводитель.Выбрать();
			Пока ВыборкаНоменклатура.Следующий() Цикл
				ОбластьНоменклатура.Параметры.Номенклатура=ВыборкаНоменклатура.Номенклатура;
				ОбластьНоменклатура.Параметры.Код=ВыборкаНоменклатура.Код;
				ОбластьНоменклатура.Параметры.КоличествоДо20=ВыборкаНоменклатура.КоличествоДо20;
				ОбластьНоменклатура.Параметры.КоличествоПосле20=ВыборкаНоменклатура.КоличествоПосле20;
				ТабДок.Вывести(ОбластьНоменклатура,3);
			КонецЦикла;
		КонецЦикла;
		ОбластьИтог.Параметры.КоличествоДо20=ВыборкаГрузополучатель.КоличествоДо20;
		ОбластьИтог.Параметры.КоличествоПосле20=ВыборкаГрузополучатель.КоличествоПосле20;
		ТабДок.Вывести(ОбластьИтог,1);
	КонецЦикла;
	ТабДок.ЗакончитьАвтогруппировкуСтрок();
	ТабДок.ПоказатьУровеньГруппировокСтрок(2);
	табДок.Записать(Вложение2, ТипФайлаТабличногоДокумента.XLS);
	
	Вложение2ZIP=КаталогВременныхФайлов()+"\Вложение2.zip";
	Архив = Новый ЗаписьZIPФайла(Вложение2ZIP,,,
	МетодСжатияZIP.Сжатие, УровеньСжатияZIP.Максимальный, МетодШифрованияZIP.Zip20);
	Архив.Добавить(Вложение2, РежимСохраненияПутейZIP.НеСохранятьПути);
	Архив.Записать();
	
	
	Если ВыборкаГрузополучатель.Количество()>0 тогда
		
		
		Профиль = Новый ИнтернетПочтовыйПрофиль;
		Профиль.АдресСервераSMTP   = "mail.yst76.ru";
		Профиль.ПортSMTP		   = 25;
		Профиль.АутентификацияSMTP = СпособSMTPАутентификации.БезАутентификации;
		Профиль.ПарольSMTP         = "";
		Профиль.ПользовательSMTP   = "";
		Письмо = Новый ИнтернетПочтовоеСообщение;
		Письмо.Отправитель = "no-reply@yst76.ru";
		//ДобавитьПолучателей(Письмо,Адрес,Менеджер); //менеджер контрагента+его помощники
		//Письмо.Получатели.Добавить(Адрес);
		
		Письмо.Получатели.Добавить("smirnov@yst.ru");
		Письмо.Получатели.Добавить("MALYSHEV@YST.RU");
		Письмо.Получатели.Добавить("serebrennikovaa@mail.ru");
		//Письмо.Получатели.Добавить("selivanov@yst.ru");
		
		
		Письмо.Вложения.Добавить(Вложение1ZIP,"Вложение 1");
		Письмо.Вложения.Добавить(Вложение2ZIP,"Вложение 2");
		Письмо.Тема = "Приход контейнеров в следующем месяце.";
		Письмо.Тексты.Добавить(ТекстПисьма,ТипТекстаПочтовогоСообщения.ПростойТекст);
		Почта = Новый ИнтернетПочта;
		
		Попытка
			Почта.Подключиться(Профиль);
			Почта.Послать(Письмо);
			Почта.Отключиться();
		Исключение
			Пауза(20);
			Почта.Подключиться(Профиль);
			Почта.Послать(Письмо);
			Почта.Отключиться();
		КонецПопытки;
	КонецЕсли;
	Запрос.Текст="УНИЧТОЖИТЬ втОснова";
	Запрос.Выполнить();
КонецПроцедуры	

Процедура ДобавитьПолучателей(Письмо,Адрес,Менеджер)
	Запрос = Новый Запрос;
	Запрос.Текст="ВЫБРАТЬ
	|	КонтактнаяИнформация.Объект КАК Объект,
	|	ВЫРАЗИТЬ(КонтактнаяИнформация.Представление КАК СТРОКА(200)) КАК Адрес
	|ИЗ
	|	РегистрСведений.КонтактнаяИнформация КАК КонтактнаяИнформация
	|ГДЕ
	|	КонтактнаяИнформация.Тип = ЗНАЧЕНИЕ(Перечисление.ТипыКонтактнойИнформации.АдресЭлектроннойПочты)
	|	И КонтактнаяИнформация.Вид = ЗНАЧЕНИЕ(Справочник.ВидыКонтактнойИнформации.СлужебныйАдресЭлектроннойПочтыПользователя)
	|	И КонтактнаяИнформация.Объект = &Менеджер";
	
	Письмо.Получатели.Добавить(Адрес);
	Помощники=тзМенеджерПомощник.НайтиСтроки(новый Структура("Менеджер",Менеджер));
	Для Каждого Пом из Помощники цикл
		Запрос.УстановитьПараметр("Менеджер",Пом.Помощник);
		Рез=Запрос.Выполнить().Выбрать();
		Если Рез.Следующий() Тогда
			//Сообщить(Рез.Адрес);
			массивАдресов = оРазложитьСтрокуВМассивПодстрок(Рез.Адрес,";");
			Для каждого эл из массивАдресов цикл
				Если СокрЛП(эл)<>"" тогда
					Письмо.Получатели.Добавить(эл);
				КонецЕсли;
			КонецЦикла;
			//Письмо.Получатели.Добавить(Рез.Адрес);
		КонецЕсли;
	КонецЦикла;
КонецПроцедуры

Функция оРазложитьСтрокуВМассивПодстрок(Знач Стр, Разделитель = ",") Экспорт
	
	МассивСтрок = Новый Массив();
	Если Разделитель = " " Тогда
		Стр = СокрЛП(Стр);
		Пока 1=1 Цикл
			Поз = Найти(Стр,Разделитель);
			Если Поз=0 Тогда
				МассивСтрок.Добавить(Стр);
				Возврат МассивСтрок;
			КонецЕсли;
			МассивСтрок.Добавить(Лев(Стр,Поз-1));
			Стр = СокрЛ(Сред(Стр,Поз));
		КонецЦикла;
	Иначе
		ДлинаРазделителя = СтрДлина(Разделитель);
		Пока 1=1 Цикл
			Поз = Найти(Стр,Разделитель);
			Если Поз=0 Тогда
				МассивСтрок.Добавить(Стр);
				Возврат МассивСтрок;
			КонецЕсли;
			МассивСтрок.Добавить(Лев(Стр,Поз-1));
			Стр = Сред(Стр,Поз+ДлинаРазделителя);
		КонецЦикла;
	КонецЕсли;
	
КонецФункции

Функция ДополнитьСтрокуЯ(Знач Стр, Длина, Чем=" ", Режим = 0) Экспорт
	
	СимволовДополнить = Длина -  СтрДлина(Стр);
	Добавок = "";
	Для Н=1 по СимволовДополнить Цикл
		Добавок =	Добавок + Чем;
	КонецЦикла;
	Возврат ?(Режим=0, Добавок + Стр, Стр + Добавок);
	
КонецФункции 

тзМенеджерПомощник = новый ТаблицаЗначений;
тзМенеджерПомощник.Колонки.Добавить("Менеджер");
тзМенеджерПомощник.Колонки.Добавить("Помощник");
нстр=тзМенеджерПомощник.Добавить();
нстр.Менеджер=Справочники.Пользователи.НайтиПоНаименованию("Бондаренко Евгений",ИСТИНА);
//нстр.Помощник=Справочники.Пользователи.НайтиПоНаименованию("Горюшкина Екатерина Александровна",ИСТИНА);

//+++ 05.07.2016 - рассылка
нстр.Помощник = Справочники.Пользователи.НайтиПоНаименованию("Хачатурян Лусине Карленовна",ИСТИНА); //  lusine@
нстр=тзМенеджерПомощник.Добавить();
нстр.Менеджер = Справочники.Пользователи.НайтиПоНаименованию("Трошин Денис Олегович",ИСТИНА);     // troshin@YST.RU
//нстр.Помощник = Справочники.Пользователи.НайтиПоНаименованию("Грошко Михаил Анатольевич",Истина); //  roman_nr@YST.RU

нстр=тзМенеджерПомощник.Добавить();
нстр.Менеджер=Справочники.Пользователи.НайтиПоНаименованию("Малышев Егор Игоревич",ИСТИНА);
//нстр.Помощник=Справочники.Пользователи.НайтиПоНаименованию("Бурова Наталья Ивановна",ИСТИНА);

нстр.Менеджер=Справочники.Пользователи.НайтиПоНаименованию("Никитин Михаил",ИСТИНА);
нстр.Помощник=Справочники.Пользователи.НайтиПоНаименованию("Челышева Татьяна Александровна",ИСТИНА);

нстр.Менеджер=Справочники.Пользователи.НайтиПоНаименованию("Плешивцева Наталья Владимировна",ИСТИНА);
нстр.Помощник=Справочники.Пользователи.НайтиПоНаименованию("Антонов Алексей Вячеславович",ИСТИНА);

нстр.Менеджер=Справочники.Пользователи.НайтиПоНаименованию("Филатова Светлана Владимировна",ИСТИНА);
