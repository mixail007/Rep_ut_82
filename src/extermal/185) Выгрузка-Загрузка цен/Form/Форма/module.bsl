﻿
Процедура КнопкаВыполнитьНажатие(Кнопка)
	Запрос=Новый Запрос;
	Запрос.УстановитьПараметр("НоменклатурнаяГруппа",НоменклатурнаяГруппа);
	Запрос.УстановитьПараметр("ТипЦен",ТипЦен);
	Запрос.УстановитьПараметр("ТолькоНаОстатках",ТолькоНаОстатках);
	Запрос.Текст="ВЫБРАТЬ
|ЦеныНоменклатуры.Номенклатура Номенклатура,
|ЦеныНоменклатуры.Цена Цена
|ИЗ
|	РегистрСведений.ЦеныНоменклатуры.СрезПоследних( ,ТипЦен = &ТипЦен
| И Номенклатура В ИЕРАРХИИ (&НоменклатурнаяГруппа)) ЦеныНоменклатуры
| ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.ТоварыНаСкладах.Остатки(,Номенклатура В ИЕРАРХИИ (&НоменклатурнаяГруппа)) ТоварыНаСкладах
| ПО ЦеныНоменклатуры.Номенклатура=ТоварыНаСкладах.Номенклатура
| ГДЕ ЕстьNULL(Цена,0)>0 И (ЕстьNULL(ТоварыНаСкладах.КоличествоОстаток,0)>0 ИЛИ НЕ &ТолькоНаОстатках)
|Упорядочить По ЦеныНоменклатуры.Номенклатура.Наименование";

Выборка=Запрос.Выполнить().Выбрать();

ТД=Новый ТекстовыйДокумент;
Пока Выборка.Следующий() Цикл
	
ТД.ДобавитьСтроку(Выборка.Номенклатура.Код+ " "+ Формат(Выборка.Цена,"ЧДЦ=0; ЧГ=0"));
//ТД.ДобавитьСтроку(Выборка.Номенклатура.Код+ " "+ Строка(Выборка.Цена));

КонецЦикла;
ТД.Записать(ПутьКФайлу,"UTF-8");

КонецПроцедуры

Процедура Кнопка1Нажатие(Элемент)
	ДиалогВыбораФайла = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Открытие);
	
	ДиалогВыбораФайла.Заголовок = "Выбрать файл";
	ДиалогВыбораФайла.Фильтр    = "Текстовый файл (*.txt)|*.txt";
	Если ДиалогВыбораФайла.Выбрать() Тогда
		
//		ТабличныйДокумент = ЭлементыФормы.ТабличныйДокумент;
		ФайлНаДиске = Новый Файл(ДиалогВыбораФайла.ПолноеИмяФайла);
		Если нРег(ФайлНаДиске.Расширение) = ".txt" Тогда
			 ПутьКФайлу=ДиалогВыбораФайла.ПолноеИмяФайла;
		КонецЕсли;
		
	КонецЕсли;

КонецПроцедуры

Процедура ОсновныеДействияФормыЗагрузить(Кнопка)
	
ТД=Новый ТекстовыйДокумент;

ТД.Прочитать(ПутьКФайлу,"UTF-8");

ДокУЦН=Документы.УстановкаЦенНоменклатуры.СоздатьДокумент();
ДокУЦН.Дата=ТекущаяДата();
	
строкаТипыЦен=ДокУЦН.ТипыЦен.Добавить();
строкаТипыЦен.ТипЦен=ТипЦен;

Для сч=1 По ТД.КоличествоСтрок()-1 Цикл
	СтрокаНоменклатуры=ТД.ПолучитьСтроку(сч);
	позиция=Найти(СтрокаНоменклатуры," ");
	Код=Лев(СтрокаНоменклатуры,7);
	Цена=Сред(СтрокаНоменклатуры,9,СтрДлина(СтрокаНоменклатуры)-8);	
	//Сообщить("Код"+Строка(Код));
	//Сообщить("Цена"+Строка(Цена));
	строкаТовары=ДокУЦН.Товары.Добавить();
	строкаТовары.Номенклатура=Справочники.Номенклатура.НайтиПоКоду(Код);
	строкаТовары.Цена=Число(Цена);
	строкаТовары.Валюта=Константы.ВалютаУправленческогоУчета.Получить();
	строкаТовары.ЕдиницаИзмерения=строкаТовары.Номенклатура.ЕдиницаХраненияОстатков;
	строкаТовары.ТипЦен=ТипЦен;
КонецЦикла;		

ДокУЦН.ПолучитьФорму().Открыть();
КонецПроцедуры
