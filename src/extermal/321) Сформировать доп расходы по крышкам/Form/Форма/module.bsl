﻿
Процедура КнопкаВыполнитьНажатие(Кнопка)
	тзДискиБезКрышекИлиС0Ценой=новый ТаблицаЗначений;
	тзДискиБезКрышекИлиС0Ценой.Колонки.Добавить("ПоступлениеДопРасходов",Новый ОписаниеТипов("ДокументСсылка.ПоступлениеДопРасходов"));
	тзДискиБезКрышекИлиС0Ценой.Колонки.Добавить("Диск",Новый ОписаниеТипов("СправочникСсылка.Номенклатура"));
	тзДискиБезКрышекИлиС0Ценой.Колонки.Добавить("Крышка",Новый ОписаниеТипов("СправочникСсылка.Номенклатура"));
	тзДискиБезКрышекИлиС0Ценой.Колонки.Добавить("Цена",Новый ОписаниеТипов("Число",,,Новый КвалификаторыЧисла(12,2)));
	
	Запрос = новый Запрос;
	Запрос.Текст="ВЫБРАТЬ РАЗЛИЧНЫЕ
	             |	ПоступлениеТоваровУслугТовары.Ссылка
	             |ПОМЕСТИТЬ втПоступленияТиУ
	             |ИЗ
	             |	Документ.ПоступлениеТоваровУслуг.Товары КАК ПоступлениеТоваровУслугТовары
	             |ГДЕ
	             |	ПоступлениеТоваровУслугТовары.Номенклатура.Производитель = &Производитель
	             |	И ПоступлениеТоваровУслугТовары.Ссылка.Контрагент = &Контрагент
	             |	И ПоступлениеТоваровУслугТовары.Ссылка.Проведен = ИСТИНА
	             |	И ПоступлениеТоваровУслугТовары.Ссылка.Дата МЕЖДУ &ДатаН И &ДатаК
	             |;
	             |
	             |////////////////////////////////////////////////////////////////////////////////
	             |ВЫБРАТЬ РАЗЛИЧНЫЕ
	             |	ПоступлениеДопРасходовТовары.ДокументПартии КАК Поступление
	             |ПОМЕСТИТЬ втПоступленияСДопРасходамиКрышки
	             |ИЗ
	             |	Документ.ПоступлениеДопРасходов.Товары КАК ПоступлениеДопРасходовТовары
	             |ГДЕ
	             |	ПоступлениеДопРасходовТовары.ДокументПартии В
	             |			(ВЫБРАТЬ
	             |				втПоступленияТиУ.Ссылка
	             |			ИЗ
	             |				втПоступленияТиУ КАК втПоступленияТиУ)
	             |	И ПоступлениеДопРасходовТовары.Ссылка.ДоговорКонтрагента = &ДоговорКонтрагентаКрышки
	             |	И ПоступлениеДопРасходовТовары.Ссылка.Сделка = &ЗаказКрышки
	             |	И ПоступлениеДопРасходовТовары.Ссылка.Проведен = ИСТИНА
	             |	И ПоступлениеДопРасходовТовары.Ссылка.СуммаДокумента > 0
	             |;
	             |
	             |////////////////////////////////////////////////////////////////////////////////
	             |ВЫБРАТЬ
	             |	втПоступленияТиУ.Ссылка
	             |ИЗ
	             |	втПоступленияТиУ КАК втПоступленияТиУ
	             |ГДЕ
	             |	НЕ втПоступленияТиУ.Ссылка В
	             |				(ВЫБРАТЬ
	             |					втПоступленияСДопРасходамиКрышки.Поступление
	             |				ИЗ
	             |					втПоступленияСДопРасходамиКрышки КАК втПоступленияСДопРасходамиКрышки)
	             |
	             |УПОРЯДОЧИТЬ ПО
	             |	втПоступленияТиУ.Ссылка.Дата
	             |АВТОУПОРЯДОЧИВАНИЕ";
				 Запрос.Параметры.Вставить("ДатаН",НачПериода);
				 Запрос.Параметры.Вставить("ДатаК",КонецДня(КонПериода));
				 Запрос.Параметры.Вставить("ДоговорКонтрагентаКрышки",ДоговорКрышки);
				 Запрос.Параметры.Вставить("ЗаказКрышки",ЗаказКрышки);
				 Запрос.Параметры.Вставить("Контрагент",Поставщик);
				 Запрос.Параметры.Вставить("Производитель",Справочники.Производители.НайтиПоКоду("65"));
				 
				 Рез=Запрос.Выполнить().Выбрать();
				 Пока Рез.Следующий() Цикл
					 Попытка
						 СформироватьДопРасходыКрышки(Рез.Ссылка,ДоговорКрышки,ЗаказКрышки,тзДискиБезКрышекИлиС0Ценой);
					 Исключение
						 Сообщить(ОписаниеОшибки());
					 КонецПопытки;
				 КонецЦикла;
				 Если тзДискиБезКрышекИлиС0Ценой.Количество()>0 тогда
					 ФормаКрышкиБезЦены=ПолучитьФорму("ФормаКрышкиС0Ценой");
					 ФормаКрышкиБезЦены.КрышкиС0Ценой=тзДискиБезКрышекИлиС0Ценой;
					 ФормаКрышкиБезЦены.ЗаказПоКрышкам=ЗаказКрышки;
					 
					 ФормаКрышкиБезЦены.ОткрытьМодально();
				 КонецЕсли;
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

Процедура ЗаказКрышкиНачалоВыбора(Элемент, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;

	Если ЗначениеНеЗаполнено(ДоговорКрышки) Тогда
		Предупреждение("Не выбран договор контрагента!");
		ТекущийЭлемент = ЭлементыФормы.ДоговорКрышки;
		Возврат;
	КонецЕсли;
	
	ФормаВыбора = Документы.ЗаказПоставщику.ПолучитьФормуВыбора(,Элемент,);
	
	// Отфильруем список документов по договору.
	ФормаВыбора.Отбор.ДокументыПоДоговоруКонтрагента.Значение      = ДоговорКрышки;
	ФормаВыбора.Отбор.ДокументыПоДоговоруКонтрагента.Использование = Истина;
	
	ФормаВыбора.Открыть();
КонецПроцедуры

Процедура ПоставщикПриИзменении(Элемент)
	ДоговорКрышки=Справочники.ДоговорыКонтрагентов.ПустаяСсылка();
	ЗаказКрышки=Документы.ЗаказПоставщику.ПустаяСсылка();
КонецПроцедуры

Функция СформироватьДопРасходыКрышки(ПоступлениеТиУ,ДоговорПоКрышкам,ЗаказПоКрышкам,тзДискиБезКрышекИлиС0Ценой)
	ДокПоступлениеДопРасходов=Документы.ПоступлениеДопРасходов.СоздатьДокумент();
	
	Отбор=Новый Структура("Роль,Организация",Перечисления.НаборПравПользователей.МенеджерПоЗакупкам,Справочники.Организации.НайтиПоКоду("00001"));
	РсДатыЗапрета=РегистрыСведений.ГраницыЗапретаИзмененияДанных.Получить(Отбор);
	
	ДатаЗапретаРедактирования=РсДатыЗапрета.ГраницаЗапретаИзменений;
	Если ПоступлениеТиУ.Дата>ДатаЗапретаРедактирования тогда
		ДокПоступлениеДопРасходов.Дата=ПоступлениеТиУ.Дата+5;
	Иначе
		ДокПоступлениеДопРасходов.Дата=ТекущаяДата();
	КонецЕсли;
	ЗаполнитьШапкуДокументаПоОснованию(ДокПоступлениеДопРасходов, ПоступлениеТиУ);
	ДокПоступлениеДопРасходов.Контрагент=ДоговорПоКрышкам.Владелец;
	ДокПоступлениеДопРасходов.ЗаполнитьТоварыПоПоступлениюТоваров(ПоступлениеТиУ, ДокПоступлениеДопРасходов.Товары);
	ДокПоступлениеДопРасходов.СпособРаспределения = Перечисления.СпособыРаспределенияДопРасходов.ПоСумме;
	ДокПоступлениеДопРасходов.ВидОперации=Перечисления.ВидыОперацийПоступлениеДопРасходов.УслугаСтороннейОрганизации;
	ДокПоступлениеДопРасходов.ДоговорКонтрагента=ДоговорПоКрышкам;
	//пересчитать суммы/курс
	ДокПоступлениеДопРасходов.ВалютаДокумента              = ДоговорКрышки.ВалютаВзаиморасчетов;
	СтруктураКурсаНовый        							   = ПолучитьКурсВалюты(ДокПоступлениеДопРасходов.ВалютаДокумента, ДокПоступлениеДопРасходов.Дата);
	ДокПоступлениеДопРасходов.КурсВзаиморасчетов           = КурсПоступленияДопРасходов;//СтруктураКурсаНовый.Курс;
	ДокПоступлениеДопРасходов.КратностьВзаиморасчетов      = СтруктураКурсаНовый.Кратность;
	
	ДокПоступлениеДопРасходов.Сделка=ЗаказПоКрышкам;
	ДокПоступлениеДопРасходов.Записать();
	//проставляем цены на крышки
	ПроставитьЦеныКрышек(ДокПоступлениеДопРасходов,тзДискиБезКрышекИлиС0Ценой);
	ДокПоступлениеДопРасходов.Комментарий="Сформирован обработкой. "+ТекущаяДата();
	ДокПоступлениеДопРасходов.Ответственный=глТекущийПользователь;
	ДокПоступлениеДопРасходов.Записать(РежимЗаписиДокумента.Проведение);
	Сообщить(ДокПоступлениеДопРасходов);
КонецФункции
Процедура ПроставитьЦеныКрышек(ПостДопРасходов,тзДискиБезКрышекИлиС0Ценой) 
	Запрос = новый запрос;
	Запрос.Текст="ВЫБРАТЬ
	             |	ПоступлениеДопРасходовТовары.Номенклатура
	             |ПОМЕСТИТЬ втНоменклатураДопРасходов
	             |ИЗ
	             |	Документ.ПоступлениеДопРасходов.Товары КАК ПоступлениеДопРасходовТовары
	             |ГДЕ
	             |	ПоступлениеДопРасходовТовары.Ссылка = &ДокДопРасходов
	             |
	             |СГРУППИРОВАТЬ ПО
	             |	ПоступлениеДопРасходовТовары.Номенклатура
	             |;
	             |
	             |////////////////////////////////////////////////////////////////////////////////
	             |ВЫБРАТЬ РАЗЛИЧНЫЕ
	             |	втНоменклатураДопРасходов.Номенклатура,
	             |	КомплектующиеНоменклатуры.Комплектующая
	             |ПОМЕСТИТЬ втДискиСКрышками
	             |ИЗ
	             |	втНоменклатураДопРасходов КАК втНоменклатураДопРасходов
	             |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.КомплектующиеНоменклатуры КАК КомплектующиеНоменклатуры
	             |		ПО втНоменклатураДопРасходов.Номенклатура = КомплектующиеНоменклатуры.Номенклатура
	             |;
	             |
	             |////////////////////////////////////////////////////////////////////////////////
	             |ВЫБРАТЬ
	             |	втДискиСКрышками.Номенклатура,
	             |	А.Цена,
	             |	втДискиСКрышками.Комплектующая
	             |ИЗ
	             |	втДискиСКрышками КАК втДискиСКрышками
	             |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ (ВЫБРАТЬ
	             |			ЗаказПоставщикуТовары.Номенклатура КАК Номенклатура,
	             |			МАКСИМУМ(ЗаказПоставщикуТовары.Цена) КАК Цена
	             |		ИЗ
	             |			Документ.ЗаказПоставщику.Товары КАК ЗаказПоставщикуТовары
	             |		ГДЕ
	             |			ЗаказПоставщикуТовары.Ссылка = &ЗаказПоставщику
	             |		
	             |		СГРУППИРОВАТЬ ПО
	             |			ЗаказПоставщикуТовары.Номенклатура) КАК А
	             |		ПО втДискиСКрышками.Комплектующая = А.Номенклатура";
	Запрос.УстановитьПараметр("ДокДопРасходов",ПостДопРасходов.ссылка);
	Запрос.УстановитьПараметр("ЗаказПоставщику",ПостДопРасходов.Сделка);
	Запрос.УстановитьПараметр("Крышки",Справочники.Номенклатура.НайтиПоКоду("0080004"));
	Коэфф=1.1;//крышки заказываем с 10% запасом, стоимость диска увеличиваем на стоимость крышки +10%
	Рез=Запрос.Выполнить().Выгрузить();
	Для каждого стр из ПостДопРасходов.Товары цикл
		стрКрышка=Рез.Найти(стр.Номенклатура,"Номенклатура");
		Если стрКрышка<>Неопределено тогда
			стр.Сумма=Стр.Количество*стрКрышка.Цена*Коэфф;
			Если найти(нрег(стр.Номенклатура.Наименование),"legeartis")>0 и стр.Сумма=0 тогда
				нстр=тзДискиБезКрышекИлиС0Ценой.Добавить();
				нстр.ПоступлениеДопРасходов=ПостДопРасходов.ссылка;
				нстр.Диск=стр.Номенклатура;
				нстр.Крышка=стрКрышка.Комплектующая;
			КонецЕсли;
		ИначеЕсли найти(нрег(стр.Номенклатура.Наименование),"legeartis")>0 тогда
			//найтикомплектующую
			
			ЗапросКомплектующие=Новый Запрос;
			ЗапросКомплектующие.Текст="ВЫБРАТЬ ПЕРВЫЕ 1
			                          |	КомплектующиеНоменклатуры.Комплектующая
			                          |ИЗ
			                          |	РегистрСведений.КомплектующиеНоменклатуры КАК КомплектующиеНоменклатуры
			                          |ГДЕ
			                          |	КомплектующиеНоменклатуры.Номенклатура = &Номенклатура";
									  
			ЗапросКомплектующие.УстановитьПараметр("Номенклатура",стр.Номенклатура);
			РезКомпл=ЗапросКомплектующие.Выполнить().Выбрать();
			Если РезКомпл.Количество()>0 тогда
				РезКомпл.Следующий();
				Комплектующая=РезКомпл.Комплектующая;
			Иначе
				Комплектующая=Справочники.Номенклатура.ПустаяСсылка();
			КонецЕсли;
			
			нстр2=тзДискиБезКрышекИлиС0Ценой.Добавить();
			нстр2.ПоступлениеДопРасходов=ПостДопРасходов.ссылка;
			нстр2.Диск=стр.Номенклатура;
			нстр2.Крышка=Комплектующая;
		КонецЕсли;	
	КонецЦикла
КонецПроцедуры