﻿
Процедура ОтобратьНажатие(Элемент)

	МВТ = новый МенеджерВременныхТаблиц;
	Запрос=новый Запрос;
	Запрос.МенеджерВременныхТаблиц=МВТ;
	Запрос.Текст="ВЫБРАТЬ
	             |	ЗаказПокупателя.Ссылка КАК ЗаказПокупателя,
	             |	ЗаказПоставщикуСезонный.Ссылка КАК ЗаказПоставщикуСезонный
	             |ПОМЕСТИТЬ втДокументыПоЗаказам
	             |ИЗ
	             |	Документ.ЗаказПокупателя КАК ЗаказПокупателя
	             |		ЛЕВОЕ СОЕДИНЕНИЕ Документ.ЗаказПоставщикуСезонный КАК ЗаказПоставщикуСезонный
	             |		ПО (ЗаказПоставщикуСезонный.ДокументОснование = ЗаказПокупателя.Ссылка)
	             |			И (ЗаказПоставщикуСезонный.Проведен = ИСТИНА)
	             |ГДЕ
	             |	ЗаказПокупателя.Проведен = ИСТИНА
	             |	И ЗаказПокупателя.Организация = &Организация
	             |	И ЗаказПокупателя.Дата МЕЖДУ &ДатаН И &ДатаК
	             |	И ЗаказПокупателя.Контрагент = &Контрагент
	             |;
	             |
	             |////////////////////////////////////////////////////////////////////////////////
	             |ВЫБРАТЬ
	             |	ЗаказыПокупателей.ЗаказПокупателя.Контрагент,
	             |	ЗаказыПокупателей.ЗаказПокупателя,
	             |	РасчетыСКонтрагентамиОстатки.СуммаВзаиморасчетовОстаток КАК ДолгПокупателя,
	             |	0 КАК Оплатить
	             |ПОМЕСТИТЬ втДолгиПокупателей
	             |ИЗ
	             |	(ВЫБРАТЬ РАЗЛИЧНЫЕ
	             |		втДокументыПоЗаказам.ЗаказПокупателя КАК ЗаказПокупателя
	             |	ИЗ
	             |		втДокументыПоЗаказам КАК втДокументыПоЗаказам) КАК ЗаказыПокупателей
	             |		ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.РасчетыСКонтрагентами.Остатки(, ДоговорКонтрагента.Владелец = &Контрагент) КАК РасчетыСКонтрагентамиОстатки
	             |		ПО ЗаказыПокупателей.ЗаказПокупателя = РасчетыСКонтрагентамиОстатки.Сделка
	             |;
	             |
	             |////////////////////////////////////////////////////////////////////////////////
	             |ВЫБРАТЬ
	             |	ВложенныйЗапрос.СезонныйЗаказПоставщику.Контрагент КАК Поставщик,
	             |	ВложенныйЗапрос.СезонныйЗаказПоставщику,
	             |	ВложенныйЗапрос.СезонныйЗаказПоставщику.ДокументОснование.Контрагент КАК Контрагент,
	             |	ВложенныйЗапрос.СезонныйЗаказПоставщику.ДокументОснование КАК ЗаказПокупателя,
	             |	ВложенныйЗапрос.ЗаказПоставщику,
	             |	-РасчетыСКонтрагентамиОстатки.СуммаВзаиморасчетовОстаток КАК ДолгПоставщику,
	             |	0 КАК КОплате,
	             |	ВЫБОР
	             |		КОГДА -РасчетыСКонтрагентамиОстатки.СуммаВзаиморасчетовОстаток < 0
	             |			ТОГДА 0
	             |		ИНАЧЕ -РасчетыСКонтрагентамиОстатки.СуммаВзаиморасчетовОстаток
	             |	КОНЕЦ КАК ДолгДляРаспределения
	             |ПОМЕСТИТЬ втДолгиПередПоставщиком
	             |ИЗ
	             |	(ВЫБРАТЬ
	             |		втДокументыПоЗаказам.ЗаказПоставщикуСезонный КАК СезонныйЗаказПоставщику,
	             |		ЗаказПоставщикуД.Ссылка КАК ЗаказПоставщику
	             |	ИЗ
	             |		втДокументыПоЗаказам КАК втДокументыПоЗаказам
	             |			ЛЕВОЕ СОЕДИНЕНИЕ Документ.ЗаказПоставщику КАК ЗаказПоставщикуД
	             |			ПО втДокументыПоЗаказам.ЗаказПоставщикуСезонный = ЗаказПоставщикуД.Основание) КАК ВложенныйЗапрос
	             |		ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.РасчетыСКонтрагентами.Остатки(, ) КАК РасчетыСКонтрагентамиОстатки
	             |		ПО ВложенныйЗапрос.ЗаказПоставщику = РасчетыСКонтрагентамиОстатки.Сделка";
				 Запрос.УстановитьПараметр("Организация",Справочники.Организации.НайтиПоКоду("00004"));
				  Запрос.УстановитьПараметр("Контрагент",Контрагент);

				 Запрос.УстановитьПараметр("ДатаН",НачПериода);
				 Запрос.УстановитьПараметр("ДатаК",КонецДня(КонПериода));
				  
				 Рез=Запрос.Выполнить();
				 Запрос.Текст="Выбрать * из втДолгиПокупателей";
				 ДолгиКлиента=Запрос.Выполнить().Выгрузить();
				 ЭлементыФормы.ДолгиКлиента.СоздатьКолонки();
				 ///
				 Запрос.Текст="
				 |Выбрать * из втДолгиПередПоставщиком";
				 //Рез=Запрос.Выполнить().Выгрузить();
				 //БазаДляРаспределения=Рез.Итог("ДолгДляРаспределения");
				 //Для каждого стр из Рез Цикл
				 //	Рез.КОплате=?(БазаДляРаспределения=0,0,Рез.Сумма*Рез.ДолгПоставщику/БазаДляРаспределения);
				 //КонецЦикла;

				 ///
				 //Запрос.Текст="
				 //|Выбрать * из втДолгиПередПоставщиком
				 //|ИТОГИ
				 //|	СУММА(ДолгПоставщику),
				 //|	СУММА(ДолгДляРаспределения)
				 //|ПО
				 //|	ОБЩИЕ,
				 //|	Поставщик,
				 //|	Контрагент";
				 ДолгиПоставщику=Запрос.Выполнить().Выгрузить();
				 ЭлементыФормы.ДолгиПоставщику.СоздатьКолонки();
				 
КонецПроцедуры

Процедура ВыбПериодНажатие(Элемент)
	НастройкаПериода = Новый НастройкаПериода;
	НастройкаПериода.РедактироватьКакИнтервал = Истина;
	НастройкаПериода.РедактироватьКакПериод = Истина;
	НастройкаПериода.ВариантНастройки = ВариантНастройкиПериода.Период;
	НастройкаПериода.УстановитьПериод(НачПериода, ?(КонПериода='0001-01-01', КонПериода, КонецДня(КонПериода)));
	Если НастройкаПериода.Редактировать() Тогда
		НачПериода = НастройкаПериода.ПолучитьДатуНачала();
		КонПериода = НастройкаПериода.ПолучитьДатуОкончания();
	КонецЕсли;
КонецПроцедуры

Процедура кнРаспределитьНажатие(Элемент)
	Отбор=новый структура("ЗаказПокупателя");
	Для каждого стр из ДолгиКлиента цикл
		Отбор.ЗаказПокупателя=стр.ЗаказПокупателя;
		Строки=ДолгиПоставщику.НайтиСтроки(Отбор);
		база=0;
		Для Каждого эл из Строки цикл
			   база=база+эл.ДолгДляРаспределения;
		КонецЦикла;
		Для Каждого эл из Строки цикл
			   эл.КОплате=?(база=0,0,Окр(стр.Оплатить*эл.ДолгДляРаспределения/база,2));
		КонецЦикла;   
		
	КонецЦикла;
		ЭлементыФормы.ДолгиПоставщику.СоздатьКолонки();
		ЭлементыФормы.ДолгиПоставщику.Колонки.КОплате.ОтображатьИтогиВПодвале=истина;
		ЭлементыФормы.ДолгиПоставщику.Колонки.КОплате.ГоризонтальноеПоложениеВПодвале=ГоризонтальноеПоложение.Право;
		
		ЭлементыФормы.ДолгиПоставщику.Колонки.ДолгПоставщику.ОтображатьИтогиВПодвале=истина;
		ЭлементыФормы.ДолгиПоставщику.Колонки.ДолгПоставщику.ГоризонтальноеПоложениеВПодвале=ГоризонтальноеПоложение.Право;

КонецПроцедуры


Процедура ОсновныеДействияФормыОсновныеДействияФормыВыполнить(Кнопка)
	Для каждого стр из ДолгиПоставщику цикл
		Если стр.КОплате>0 тогда
		ДокЗаявка=Документы.ЗаявкаНаРасходованиеСредств.СоздатьДокумент();
		ДокЗаявка.Дата=ТекущаяДата();
		ДокЗаявка.Организация=стр.ЗаказПоставщику.Организация;
		ДокЗаявка.Контрагент=стр.Поставщик;
		ДокЗаявка.ВалютаДокумента=стр.ЗаказПоставщику.ВалютаДокумента;
		ДокЗаявка.ВидОперации=Перечисления.ВидыОперацийЗаявкиНаРасходование.ОплатаПоставщику;
		ДокЗаявка.ДатаРасхода=ТекущаяДата();
		ДокЗаявка.ФормаОплаты=Перечисления.ВидыДенежныхСредств.Безналичные;
		ДокЗаявка.Ответственный=глТекущийПользователь;
		ДокЗаявка.Подразделение=стр.ЗаказПоставщику.Подразделение;
		
		СтруктураКурсаВалютаДокумента = ПолучитьКурсВалюты(ДокЗаявка.ВалютаДокумента, ДокЗаявка.Дата);
		ДокЗаявка.КурсДокумента        = СтруктураКурсаВалютаДокумента.Курс;
		ДокЗаявка.КратностьДокумента   = СтруктураКурсаВалютаДокумента.Кратность;
	
        Расшифровка=ДокЗаявка.РасшифровкаПлатежа;
		нстр=Расшифровка.Добавить();
		нстр.Сделка=стр.ЗаказПоставщику;
		нстр.ДоговорКонтрагента=стр.ЗаказПоставщику.ДоговорКонтрагента;
		нстр.КурсВзаиморасчетов=ДокЗаявка.КурсДокумента;
		нстр.КратностьВзаиморасчетов=ДокЗаявка.КратностьДокумента;
		нстр.СуммаПлатежа=стр.КОплате;
		нстр.ДатаРасхода=ТекущаяДата();
		нстр.СуммаВзаиморасчетов=стр.КОплате*нстр.КурсВзаиморасчетов;
		нстр.СтатьяДвиженияДенежныхСредств=Справочники.СтатьиДвиженияДенежныхСредств.ОплатаПоставщику;
		ДокЗаявка.СуммаДокумента=Расшифровка.Итог("СуммаПлатежа");

		ДокЗаявка.ПолучитьФорму("ФормаДокумента").Открыть();
		
		//ДокЗаявка.Записать();
		КонецЕсли;
	конецЦикла;
	
КонецПроцедуры

