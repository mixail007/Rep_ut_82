﻿Перем ТЗдок Экспорт;

Процедура КнопкаВыполнитьНажатие(Кнопка)
		
	Если Не ЗначениеЗаполнено(ДатаНач) или Не ЗначениеЗаполнено(ДатаКон) Тогда
		Предупреждение("Не заполнен период оплаты !");
		возврат;
	КонецЕсли;	
	Если Не ЗначениеЗаполнено(Организация) Тогда
		Предупреждение("Не указана организация !");
		возврат;
	КонецЕсли;	
	Если Не ЗначениеЗаполнено(ОтветственныйЗаДоговор) Тогда
		Предупреждение("Не указан ответственный за договоры по расчетным документам!");
		возврат;
	КонецЕсли;	
	
	Запрос = Новый Запрос;
	Если Контрагент.Код = "91546  " Тогда // Рускон
		зтОтборПоДатеНачИспользОбработки = " И Сделка.ДатаСчета >= &ДатаНачИспользОбработки";
		Запрос.УстановитьПараметр("ДатаНачИспользОбработки", '20170204000000');
	ИначеЕсли Контрагент.Код = "94237  " Тогда // ООСЛ Логистика (Раша) Лимитед
		зтОтборПоДатеНачИспользОбработки = " И Сделка.ДатаСчета >= &ДатаНачИспользОбработки";
		Запрос.УстановитьПараметр("ДатаНачИспользОбработки", '20170117000000');
	Иначе
		зтОтборПоДатеНачИспользОбработки = "";
	КонецЕсли;
	
	Запрос.Текст = "ВЫБРАТЬ
	               |	ВзаиморасчетыСКонтрагентамиОстатки.ДоговорКонтрагента.Владелец КАК Контрагент,
	               |	ВзаиморасчетыСКонтрагентамиОстатки.ДоговорКонтрагента,
	               |	ВзаиморасчетыСКонтрагентамиОстатки.Сделка КАК ДокументДопРасхода,
	               |	ВзаиморасчетыСКонтрагентамиОстатки.Сделка.НомерСчета КАК НомерСчета,
	               |	ВзаиморасчетыСКонтрагентамиОстатки.Сделка.ДатаСчета КАК ДатаСчета,
	               |	ВзаиморасчетыСКонтрагентамиОстатки.СуммаВзаиморасчетовОстаток КАК СуммаДолга,
	               |	ВзаиморасчетыСКонтрагентамиОстатки.ДоговорКонтрагента.ДопустимоеЧислоДнейЗадолженности КАК КолДнейОтсрочки
	               |ПОМЕСТИТЬ ТЗдокументов
	               |ИЗ
	               |	РегистрНакопления.ВзаиморасчетыСКонтрагентами.Остатки(
	               |			,
	               |			ДоговорКонтрагента.ОтветственноеЛицо = &СотрудникВЭД
				   |			И ДоговорКонтрагента.Владелец = &Контрагент
	               |				И ДоговорКонтрагента.ВедениеВзаиморасчетов = ЗНАЧЕНИЕ(Перечисление.ВедениеВзаиморасчетовПоДоговорам.ПоРасчетнымДокументам)
	               |				И Сделка ССЫЛКА Документ.ПоступлениеДопРасходов" + зтОтборПоДатеНачИспользОбработки + ") КАК ВзаиморасчетыСКонтрагентамиОстатки
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ
	               |	ТЗдокументов.Контрагент КАК Контрагент,
	               |	ТЗдокументов.ДоговорКонтрагента КАК ДоговорКонтрагента,
	               |	ТЗдокументов.ДоговорКонтрагента.ВалютаВзаиморасчетов КАК ВалютаДоговора,
	               |	ТЗдокументов.ДокументДопРасхода,
	               |	ТЗдокументов.НомерСчета КАК НомерСчета,
	               |	ТЗдокументов.ДатаСчета КАК ДатаСчета,
	               |	ТЗдокументов.СуммаДолга КАК СуммаДолга,
	               |	-1 * ТЗдокументов.СуммаДолга КАК СуммаДляОплаты,
	               |	ТЗдокументов.КолДнейОтсрочки КАК КолДнейОтсрочки,
	               |	ДОБАВИТЬКДАТЕ(ТЗдокументов.ДатаСчета, ДЕНЬ, ТЗдокументов.КолДнейОтсрочки) КАК СрокОплаты,
				 //  |    ВЫБОР
				 //  |       КОГДА ДОБАВИТЬКДАТЕ(ТЗдокументов.ДатаСчета, ДЕНЬ, ТЗдокументов.КолДнейОтсрочки) >= &ТекДата
				 //  |             И ДОБАВИТЬКДАТЕ(ТЗдокументов.ДатаСчета, ДЕНЬ, ТЗдокументов.КолДнейОтсрочки) <= &ДатаКон
				 ////  |       ТОГДА ДОБАВИТЬКДАТЕ(ТЗдокументов.ДатаСчета, ДЕНЬ, ТЗдокументов.КолДнейОтсрочки)
				 //  |       ТОГДА &ТекДата
				 //  |       ИНАЧЕ &ТекДата
				 //  |    КОНЕЦ КАК ДатаОплаты,
				   |	&ДатаОплаты КАК ДатаОплаты,
	               |	ЕстьNull(ВложенныйЗапрос.СуммаВзаиморасчетовПриход,0) КАК СуммаЗаявок,
	               |	ВЫБОР
	               |		КОГДА -1 * ТЗдокументов.СуммаДолга - ВложенныйЗапрос.СуммаВзаиморасчетовПриход <= 0
	               |			ТОГДА ЛОЖЬ
	               |		ИНАЧЕ ИСТИНА
	               |	КОНЕЦ КАК НужнаЗаявкаНаОплату,
				   |	ВЫБОР
	               |		КОГДА -1 * ТЗдокументов.СуммаДолга - ВложенныйЗапрос.СуммаВзаиморасчетовПриход <= 0
	               |			ТОГДА ЛОЖЬ
	               |		ИНАЧЕ ИСТИНА
	               |	КОНЕЦ КАК СоздатьЗаявкуНаОплату
	               |ИЗ
	               |	ТЗдокументов КАК ТЗдокументов
	               |		ЛЕВОЕ СОЕДИНЕНИЕ (ВЫБРАТЬ
	               |			ЗаявкиНаРасходованиеСредствОбороты.ДоговорКонтрагента КАК ДоговорКонтрагента,
	               |			ЗаявкиНаРасходованиеСредствОбороты.Сделка КАК Сделка,
	               |			ЗаявкиНаРасходованиеСредствОбороты.СуммаВзаиморасчетовПриход КАК СуммаВзаиморасчетовПриход
	               |		ИЗ
	               |			РегистрНакопления.ЗаявкиНаРасходованиеСредств.Обороты(
	               |					,
	               |					,
	               |					,
	               |					Сделка В
	               |						(ВЫБРАТЬ
	               |							ТЗдокументов.ДокументДопРасхода
	               |						ИЗ
	               |							ТЗдокументов КАК ТЗдокументов)) КАК ЗаявкиНаРасходованиеСредствОбороты) КАК ВложенныйЗапрос
	               |		ПО ТЗдокументов.ДоговорКонтрагента = ВложенныйЗапрос.ДоговорКонтрагента
	               |			И ТЗдокументов.ДокументДопРасхода = ВложенныйЗапрос.Сделка
	               |ГДЕ
	               |	ДОБАВИТЬКДАТЕ(ТЗдокументов.ДатаСчета, ДЕНЬ, ТЗдокументов.КолДнейОтсрочки) <= &ДатаКон
	               |	И ТЗдокументов.СуммаДолга < 0
	               |
	               |УПОРЯДОЧИТЬ ПО
				   |    СрокОплаты,
	               |	ДатаОплаты,
				   |	Контрагент,
				   |	НомерСчета
	               |ИТОГИ
	               |	МАКСИМУМ(ВалютаДоговора),
	               |	СУММА(СуммаДолга),
	               |	СУММА(СуммаДляОплаты),
	               |	МАКСИМУМ(КолДнейОтсрочки),
	               |	МАКСИМУМ(СрокОплаты),
				   |	МАКСИМУМ(ДатаОплаты),
	               |	СУММА(СуммаЗаявок),
				   |	МАКСИМУМ(СоздатьЗаявкуНаОплату)
	               |ПО
	               |	Контрагент,
	               |	ДоговорКонтрагента,
	               |	ДатаСчета,
	               |	НомерСчета";


				   
	//Запрос.УстановитьПараметр("ДатаНач", НачалоДня(ДатаНач));
	Запрос.УстановитьПараметр("ДатаКон", КонецДня(ДатаКон));
	Запрос.УстановитьПараметр("Организация", Организация);
	Запрос.УстановитьПараметр("СотрудникВЭД", ОтветственныйЗаДоговор);
	Запрос.УстановитьПараметр("Контрагент", Контрагент);
	Запрос.УстановитьПараметр("ТекДата", КонецДня(ТекущаяДата()));
	Если ДатаРасхода = '00010101000000' Тогда
		Запрос.УстановитьПараметр("ДатаОплаты", КонецДня(ТекущаяДата()));
	Иначе
		Запрос.УстановитьПараметр("ДатаОплаты", КонецДня(ДатаРасхода));
	КонецЕсли;
	
	Если ЗначениеНеЗаполнено(Контрагент) Тогда
		Запрос.Текст = СтрЗаменить(Запрос.Текст,"И ДоговорКонтрагента.Владелец = &Контрагент","");
	КонецЕсли;	
				   
	Таб = ЭлементыФормы.ПолеТабличногоДокумента1;
	Таб.Очистить();
	Макет = ПолучитьМакет("Макет");
	ОбластьШапка = Макет.ПолучитьОбласть("Шапка");
	ОбластьСтрока = Макет.ПолучитьОбласть("Строка");
	ОбластьСчет = Макет.ПолучитьОбласть("Счет");
	ОбластьЗаявка = Макет.ПолучитьОбласть("Заявка");
	
    Таб.Вывести(ОбластьШапка);
	
	РезультатЗапроса = Запрос.Выполнить();
	ТЗдок = РезультатЗапроса.Выгрузить();
	//ТЗдок.ВыбратьСтроку();
	ВыборкаКонтрагент = РезультатЗапроса.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	
	Таб.НачатьАвтогруппировкуСтрок();
	Пока ВыборкаКонтрагент.Следующий() Цикл
		ВыборкаДоговор = ВыборкаКонтрагент.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
		Пока ВыборкаДоговор.Следующий() Цикл
			ВыборкаДатаСчета = ВыборкаДоговор.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
			Пока ВыборкаДатаСчета.Следующий() Цикл
				ВыборкаНомерСчета = ВыборкаДатаСчета.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
				Пока ВыборкаНомерСчета.Следующий() Цикл
					ОбластьСчет.Параметры.Заполнить(ВыборкаНомерСчета);
					РасшифровкаДляПечати = Новый Структура;
					РасшифровкаДляПечати.Вставить("Контрагент", ВыборкаНомерСчета.Контрагент);
					РасшифровкаДляПечати.Вставить("Договор", ВыборкаНомерСчета.ДоговорКонтрагента);
					РасшифровкаДляПечати.Вставить("НомерСчета", ВыборкаНомерСчета.НомерСчета);
					РасшифровкаДляПечати.Вставить("ДатаСчета", ВыборкаНомерСчета.ДатаСчета);
					РасшифровкаДляПечати.Вставить("ВалютаДоговора", ВыборкаНомерСчета.ВалютаДоговора);
					РасшифровкаДляПечати.Вставить("СоздатьЗаявку", Истина);
					
					РасшифровкаДатаОплаты = Новый Структура;
					РасшифровкаДатаОплаты.Вставить("Контрагент", ВыборкаНомерСчета.Контрагент);
					РасшифровкаДатаОплаты.Вставить("Договор", ВыборкаНомерСчета.ДоговорКонтрагента);
					РасшифровкаДатаОплаты.Вставить("НомерСчета", ВыборкаНомерСчета.НомерСчета);
					РасшифровкаДатаОплаты.Вставить("ДатаСчета", ВыборкаНомерСчета.ДатаСчета);
					РасшифровкаДатаОплаты.Вставить("ВалютаДоговора", ВыборкаНомерСчета.ВалютаДоговора);
					РасшифровкаДатаОплаты.Вставить("ДатаОплаты", ВыборкаНомерСчета.ДатаОплаты);

					ОбластьСчет.Параметры.РасшифровкаДляПечати = РасшифровкаДляПечати;
					ОбластьСчет.Параметры.РасшифровкаДатаОплаты = РасшифровкаДатаОплаты;

					Если ВыборкаНомерСчета.СуммаДляОплаты <= ВыборкаНомерСчета.СуммаЗаявок Тогда
						ОбластьСчет.Параметры.СоздатьЗаявку = "";
					Иначе
						ОбластьСчет.Параметры.СоздатьЗаявку = "V";
					КонецЕсли;
					
					Таб.Вывести(ОбластьСчет,1);
					Выборка = ВыборкаНомерСчета.Выбрать();
					Пока Выборка.Следующий() Цикл
						ОбластьСтрока.Параметры.Заполнить(Выборка);
						//ОбластьСтрока.Параметры.НомерКонтейнера = Выборка.ДокументДопРасхода.Сделка.НомерКонтейнера;
						Таб.Вывести(ОбластьСтрока,2,,Ложь);
					КонецЦикла;
				КонецЦикла;
			КонецЦикла;
		КонецЦикла;
	КонецЦикла;
	Таб.ЗакончитьАвтогруппировкуСтрок();
	
	Таб.ТолькоПросмотр = Истина;
	Таб.ФиксацияСверху = 1;
	
	ОбновитьИтговуюСумму();
 	
КонецПроцедуры

Процедура КнопкаВвестиПериодНажатие(Элемент)
	
	НастройкаПериода = Новый НастройкаПериода;
	НастройкаПериода.РедактироватьКакИнтервал = Истина;
	НастройкаПериода.РедактироватьКакПериод = Истина;
	НастройкаПериода.ВариантНастройки = ВариантНастройкиПериода.Период;
	НастройкаПериода.УстановитьПериод(ДатаНач, ?(ДатаКон='0001-01-01', ДатаКон, КонецДня(ДатаКон)));
	Если НастройкаПериода.Редактировать() Тогда
		ДатаНач = НастройкаПериода.ПолучитьДатуНачала();
		ДатаКон = НастройкаПериода.ПолучитьДатуОкончания();
	КонецЕсли;
	
КонецПроцедуры

Процедура ОсновныеДействияФормыДействиеСоздатьЗаявки(Кнопка)
	
	ОтборДокументов = ТЗдок.НайтиСтроки(Новый Структура("НужнаЗаявкаНаОплату, СоздатьЗаявкуНаОплату", Истина, Истина));
	ТЗсчетов = ТЗдок.Скопировать(ОтборДокументов);
	Если ТЗсчетов.Количество()=0 Тогда
		Предупреждение("Нет неоплаченных документов!");
		возврат;
	Иначе
		Ответ = Вопрос("Создать заявки на оплату по отмеченным счетам?", РежимДиалогаВопрос.ДаНет);
		Если Ответ = КодВозвратаДиалога.Нет Тогда
			Возврат;
		КонецЕсли;
	КонецЕсли;	
	ТЗдокументов = ТЗсчетов.Скопировать();
	//ТЗсчетов.ВыбратьСтроку();  возврат;
	ТЗсчетов.Свернуть("Контрагент, ДоговорКонтрагента, ДатаОплаты", "СуммаДолга");
	ТЗсчетов.Сортировать("Контрагент, ДоговорКонтрагента, ДатаОплаты");
	//создание заявок на оплату - для каждого контрагента, договора и даты оплаты своя заявка
	Для Каждого Стр из ТЗсчетов Цикл
		
		НадоСоздатьДокумент = Ложь;
		НазначениеПлатежа = "";
		НовДок = Документы.ЗаявкаНаРасходованиеСредств.СоздатьДокумент();
		НовДок.Дата = ТекущаяДата();
		НовДок.ФормаОплаты =  Перечисления.ВидыДенежныхСредств.Безналичные;
		НовДок.ВидОперации = Перечисления.ВидыОперацийЗаявкиНаРасходование.ОплатаПоставщику;
		Если Стр.ДатаОплаты < ТекущаяДата() Тогда
			НовДок.ДатаРасхода = ТекущаяДата();
		Иначе	
			НовДок.ДатаРасхода = Стр.ДатаОплаты;
		КонецЕсли;
		НовДок.Контрагент = Стр.Контрагент;
		НовДок.БанковскийСчетКонтрагента = Стр.Контрагент.ОсновнойБанковскийСчет;
		НовДок.Организация = Организация;
		НовДок.Ответственный=глТекущийПользователь;
		НовДок.Подразделение = Справочники.Подразделения.НайтиПоКоду("00003"); //Департамент ВЭД
		НовДок.Состояние=Перечисления.СостоянияОбъектов.ПустаяСсылка();
		НовДок.ВалютаДокумента = Стр.ДоговорКонтрагента.ВалютаВзаиморасчетов;
		НовДок.КурсДокумента = 1;
		НовДок.КратностьДокумента = 1;
		НовДок.ПериодПланирования = НачалоМесяца(НовДок.ДатаРасхода);
		УстановитьНомерДокумента(НовДок);
				
		//заполнение документами расчетов табличной части
		НайденныеСтроки = ТЗдокументов.НайтиСтроки(Новый Структура("Контрагент, ДоговорКонтрагента, ДатаОплаты",
		Стр.Контрагент, Стр.ДоговорКонтрагента, Стр.ДатаОплаты));
		СуммаНДС = 0;
		Для Каждого СтрокаДокумента Из НайденныеСтроки Цикл
			
			СтрОплатаПоСчету = СокрЛП(СтрокаДокумента.НомерСчета)+" от "+Формат(СтрокаДокумента.ДатаСчета, "ДФ=dd.MM.yyyy")+" на сумму "+СтрокаДокумента.СуммаДляОплаты;
			Если Найти(НазначениеПлатежа, СтрОплатаПоСчету)=0 Тогда
				//сначала проверка на длину строки, все назначение платежа не должно превышать 210 символов
				//если не влезает, то создаем новый документ
				ВремНазначениеПлатежа = НазначениеПлатежа+СтрОплатаПоСчету+","; 
				Если СтрДлина(ВремНазначениеПлатежа) > 170 Тогда
					НадоСоздатьДокумент = Истина;
				Иначе	
					НазначениеПлатежа = НазначениеПлатежа+СтрОплатаПоСчету+",";
				КонецЕсли;
			КонецЕсли;	
			Если НадоСоздатьДокумент Тогда
				
				//сначала запишем старый документ
				Если НовДок.РасшифровкаПлатежа.Количество()>0 Тогда
					//Для Юниверсал логистик сумму НДС считаем по каждому счету ндс 18 - 20% и складываем
					Если СокрЛП(НовДок.Контрагент.Код) = "93345" Тогда
						СуммаНДС = РассчитатьСуммуНДСпоСчетам(НовДок);
					КонецЕсли;	
					НовДок.СуммаДокумента = НовДок.РасшифровкаПлатежа.Итог("СуммаПлатежа");
					НовДок.НазначениеПлатежа = "Оплата по счету "+Лев(НазначениеПлатежа,СтрДлина(НазначениеПлатежа)-1)+
					Символы.ПС+"Сумма "+Формат(НовДок.СуммаДокумента,"ЧДЦ=2; ЧРГ=")+
					Символы.ПС+"НДС "+Формат(СуммаНДС,"ЧДЦ=2; ЧРГ=");
					НовДок.Состояние = Перечисления.СостоянияОбъектов.Подготовлен;
					НовДок.Записать(РежимЗаписиДокумента.Проведение);
					сообщить("Записан новый "+НовДок);
				КонецЕсли;
				
				НазначениеПлатежа = СтрОплатаПоСчету+",";
				СуммаНДС = 0;
				
				НовДок = Документы.ЗаявкаНаРасходованиеСредств.СоздатьДокумент();
				НовДок.Дата = ТекущаяДата();
				НовДок.ФормаОплаты =  Перечисления.ВидыДенежныхСредств.Безналичные;
				НовДок.ВидОперации = Перечисления.ВидыОперацийЗаявкиНаРасходование.ОплатаПоставщику;
				Если Стр.ДатаОплаты < ТекущаяДата() Тогда
					НовДок.ДатаРасхода = ТекущаяДата();
				Иначе	
					НовДок.ДатаРасхода = Стр.ДатаОплаты;
				КонецЕсли;
				НовДок.Контрагент = Стр.Контрагент;
				НовДок.БанковскийСчетКонтрагента = Стр.Контрагент.ОсновнойБанковскийСчет;
				НовДок.Организация = Организация;
				НовДок.Ответственный=глТекущийПользователь;
				НовДок.Состояние=Перечисления.СостоянияОбъектов.ПустаяСсылка();
				НовДок.ВалютаДокумента = Стр.ДоговорКонтрагента.ВалютаВзаиморасчетов;
				НовДок.Подразделение = Справочники.Подразделения.НайтиПоКоду("00003"); //Департамент ВЭД
				НовДок.КурсДокумента = 1;
				НовДок.КратностьДокумента = 1;
				НовДок.ПериодПланирования = НачалоМесяца(НовДок.ДатаРасхода);
				УстановитьНомерДокумента(НовДок);
				НадоСоздатьДокумент = Ложь;
				
			КонецЕсли;	
			
			НовСтр = НовДок.РасшифровкаПлатежа.Добавить();
			Если Стр.ДатаОплаты < ТекущаяДата() Тогда
				НовСтр.ДатаРасхода = ТекущаяДата();
			Иначе	
				НовСтр.ДатаРасхода = Стр.ДатаОплаты;
			КонецЕсли;
			НовСтр.Сделка = СтрокаДокумента.ДокументДопРасхода;
			НовСтр.ДоговорКонтрагента  = Стр.ДоговорКонтрагента;
			НовСтр.СуммаПлатежа 	   = СтрокаДокумента.СуммаДляОплаты;
			НовСтр.СуммаВзаиморасчетов = СтрокаДокумента.СуммаДляОплаты;
			НовСтр.КурсВзаиморасчетов  = 1;
			НовСтр.КратностьВзаиморасчетов = 1;
			НовСтр.СтавкаНДС = НовСтр.Сделка.СтавкаНДС; 
			СуммаНДС = СуммаНДС + НовСтр.Сделка.СуммаНДС;
			
			УстановитьСтатьюДДСПоУмолчанию(НовСтр,НовДок.ВидОперации);
            НовСтр.СтатьяРасхода =  Справочники.СтатьиРасходов.НайтиПоКоду("000000043");
			НовСтр.ОтветственныйЗаПланирование = справочники.Пользователи.НайтиПоКоду("Жарикова В.");
		КонецЦикла;
		
		//записываем последний документ
		//Для Юниверсал логистик сумму НДС считаем по каждому счету ндс 18 - 20% и складываем
		Если СокрЛП(НовДок.Контрагент.Код) = "93345" Тогда
			СуммаНДС = РассчитатьСуммуНДСпоСчетам(НовДок);
		КонецЕсли;
		НовДок.СуммаДокумента = НовДок.РасшифровкаПлатежа.Итог("СуммаПлатежа");
		НовДок.НазначениеПлатежа = "Оплата по счету "+Лев(НазначениеПлатежа,СтрДлина(НазначениеПлатежа)-1)+
		"; "+"Сумма "+Формат(НовДок.СуммаДокумента,"ЧДЦ=2; ЧРГ=")+
		"; "+"НДС "+Формат(СуммаНДС,"ЧДЦ=2; ЧРГ=");
		НовДок.Состояние = Перечисления.СостоянияОбъектов.Подготовлен;
		НовДок.Записать(РежимЗаписиДокумента.Проведение);
		сообщить("Записан новый "+НовДок);
		
	КонецЦикла;	
	
КонецПроцедуры

Функция РассчитатьСуммуНДСпоСчетам(НовДок)
	ТекСуммаНДС = 0;
	времТЗ = НовДок.РасшифровкаПлатежа.Выгрузить();
	времТЗ.Колонки.Добавить("НомерСчета", Новый ОписаниеТипов("Строка"));
	времТЗ.Колонки.Добавить("ДатаСчета", Новый ОписаниеТипов("Дата"));
	Для Каждого времТЗстр из времТЗ Цикл
		времТЗстр.НомерСчета = времТЗстр.Сделка.НомерСчета;
		времТЗстр.ДатаСчета  = времТЗстр.Сделка.ДатаСчета;
	КонецЦикла;
	СтавкаНДС_2019 = СтавкаНДСнаДату( НовДок.Дата ); //28.12.2018
	чНДС = ПолучитьСтавкуНДС( СтавкаНДС_2019 );
	времТЗ.Свернуть("НомерСчета, ДатаСчета","СуммаПлатежа");
	Для Каждого времТЗстр из времТЗ Цикл
		ТекСуммаНДС = ТекСуммаНДС+Окр(времТЗстр.СуммаПлатежа*чНДС/(100+чНДС),2,1);
	КонецЦикла;
	возврат ТекСуммаНДС;
КонецФункции	

Процедура ПриОткрытии()
	Если ЗначениеНеЗаполнено(ДатаНач) или ЗначениеНеЗаполнено(ДатаКон) Тогда
		ДатаНач = НачалоМесяца(ТекущаяДата());
		ДатаКон = КонецМесяца(ТекущаяДата());
	КонецЕсли;
	Организация = Справочники.Организации.НайтиПоКоду("00001");
	ОтветственныйЗаДоговор = глТекущийПользователь; // кто открыл
	ДатаРасхода = ТекущаяДата();
КонецПроцедуры

Процедура ПолеТабличногоДокумента1ОбработкаРасшифровки(Элемент, Расшифровка, СтандартнаяОбработка)
	
	Если ТипЗнч(Расшифровка) = Тип("Структура") Тогда
		Если Расшифровка.Свойство("СоздатьЗаявку") Тогда
			СтандартнаяОбработка = Ложь;
			ОтметитьДокументыПоСчету(ЭлементыФормы.ПолеТабличногоДокумента1.ТекущаяОбласть);
			ОбновитьИтговуюСумму();
		ИначеЕсли Расшифровка.Свойство("ДатаОплаты") Тогда
			 СтандартнаяОбработка = Ложь;
             ТекДатаОплаты = Расшифровка.ДатаОплаты;
			 Если ВвестиДату(ТекДатаОплаты, "Укажите новую дату оплаты", ЧастиДаты.Дата) Тогда
				 Если ТекДатаОплаты <> Расшифровка.ДатаОплаты Тогда
					 УстановитьДатуОплаты(ЭлементыФормы.ПолеТабличногоДокумента1.ТекущаяОбласть, ТекДатаОплаты); 
				 КонецЕсли;
			 КонецЕсли;	 
		КонецЕсли;
	КонецЕсли;
		
КонецПроцедуры

Процедура КнопкаОтметитьВсеНажатие(Элемент)
	
	ТекТаб = ЭлементыФормы.ПолеТабличногоДокумента1;
	Для к = 1 по ТекТаб.ВысотаТаблицы Цикл
		ТекОбласть = ТекТаб.Область(к,1,к,1);
		ОтметитьДокументыПоСчету(ТекОбласть, Истина);
	КонецЦикла;
	ОбновитьИтговуюСумму();
	
КонецПроцедуры

Процедура КнопкаОтменитьВсеНажатие(Элемент)
	
	ТекТаб = ЭлементыФормы.ПолеТабличногоДокумента1;
	Для к = 1 по ТекТаб.ВысотаТаблицы Цикл
		ТекОбласть = ТекТаб.Область(к,1,к,1);
		ОтметитьДокументыПоСчету(ТекОбласть, Ложь);
	КонецЦикла;
	ОбновитьИтговуюСумму();
	
КонецПроцедуры

Процедура ОтметитьДокументыПоСчету(ТекОбласть, Отметка = Неопределено)
	
	ТекРасшифровка = ТекОбласть.Расшифровка;
	Если ТипЗнч(ТекРасшифровка)=Тип("Структура") Тогда
		Если ТекРасшифровка.Свойство("СоздатьЗаявку") Тогда
			НомерСчета = "";
			ДатаСчета = "";
			Контрагент = "";
			Договор = "";
			Валюта = "";
			Если ТекРасшифровка.Свойство("НомерСчета", НомерСчета) И ТекРасшифровка.Свойство("ДатаСчета", ДатаСчета)
				И ТекРасшифровка.Свойство("Контрагент", Контрагент) И ТекРасшифровка.Свойство("Договор", Договор) 
				И ТекРасшифровка.Свойство("ВалютаДоговора", Валюта) Тогда
				НайденныеСтроки = ТЗдок.НайтиСтроки(Новый Структура("Контрагент, ДоговорКонтрагента, НомерСчета, ДатаСчета, ВалютаДоговора"
				,Контрагент, Договор, НомерСчета, ДатаСчета, Валюта));
				Если НайденныеСтроки.Количество() > 0 Тогда
					Если Отметка = Неопределено Тогда
						//ставим значение наоборот
						Если ТекОбласть.Текст = "V" Тогда
							ТекОбласть.Текст = "";
							СоздатьЗаявку = Ложь;
						Иначе
							ТекОбласть.Текст = "V";
							СоздатьЗаявку = Истина;
						КонецЕсли;
					ИначеЕсли Отметка = Истина Тогда
						//значение передано в процедуру
						ТекОбласть.Текст = "V";
						СоздатьЗаявку = Истина;
					Иначе
						ТекОбласть.Текст = "";
						СоздатьЗаявку = Ложь;
					КонецЕсли;
					Для Каждого СтрДок ИЗ НайденныеСтроки Цикл
						СтрДок.СоздатьЗаявкуНаОплату = СоздатьЗаявку;
					КонецЦикла;	
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбновитьИтговуюСумму()
	
	ОтборДокументов = ТЗдок.НайтиСтроки(Новый Структура("НужнаЗаявкаНаОплату, СоздатьЗаявкуНаОплату", Истина, Истина));
	ТЗвал = ТЗдок.Скопировать(ОтборДокументов);
	ТЗвал.Свернуть("ВалютаДоговора", "СуммаДляОплаты");
	ТЗвал.Сортировать("ВалютаДоговора");
	ПечСуммаОплаты = "";
	Для Каждого Стр из ТЗвал Цикл
		ПечСуммаОплаты = ПечСуммаОплаты+?(ПечСуммаОплаты = "","",", ")+Формат(Стр.СуммаДляОплаты,"ЧДЦ=2")+" "+СокрЛП(Стр.ВалютаДоговора);
	КонецЦикла;
	ЭлементыФормы.НадписьВсегоКОплате.Заголовок = "Всего к оплате: "+ПечСуммаОплаты;
	
КонецПроцедуры	

Процедура УстановитьДатуОплаты(ТекОбласть, ТекДата)
	
	ТекРасшифровка = ТекОбласть.Расшифровка;
	Если ТипЗнч(ТекРасшифровка)=Тип("Структура") Тогда
		Если ТекРасшифровка.Свойство("ДатаОплаты") Тогда
			НомерСчета = "";
			ДатаСчета = "";
			Контрагент = "";
			Договор = "";
			Валюта = "";
			Если ТекРасшифровка.Свойство("НомерСчета", НомерСчета) И ТекРасшифровка.Свойство("ДатаСчета", ДатаСчета)
				И ТекРасшифровка.Свойство("Контрагент", Контрагент) И ТекРасшифровка.Свойство("Договор", Договор) 
				И ТекРасшифровка.Свойство("ВалютаДоговора", Валюта) Тогда
				НайденныеСтроки = ТЗдок.НайтиСтроки(Новый Структура("Контрагент, ДоговорКонтрагента, НомерСчета, ДатаСчета, ВалютаДоговора"
				,Контрагент, Договор, НомерСчета, ДатаСчета, Валюта));
				Если НайденныеСтроки.Количество() > 0 Тогда
					ТекОбласть.Текст = Формат(ТекДата,"ДФ=dd.MM.yyyy");
					Для Каждого СтрДок ИЗ НайденныеСтроки Цикл
						СтрДок.ДатаОплаты = ТекДата;
					КонецЦикла;	
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры	
