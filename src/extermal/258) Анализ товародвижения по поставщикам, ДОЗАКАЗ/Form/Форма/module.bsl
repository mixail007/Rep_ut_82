﻿перем КодB2B, КодКрОпт;

функция ПолучитьГлавныйЗапрос()
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	ДокТовары.Номенклатура.Типоразмер КАК Типоразмер,
	               |	ДокТовары.Номенклатура.Код КАК Код,
	               |	ДокТовары.Номенклатура.Артикул КАК Артикул,
	               |	ДокТовары.Номенклатура.Производитель КАК Производитель,
	               |	ДокТовары.Номенклатура,
	               |	ДокТовары.Количество КАК Заказано
	               |ПОМЕСТИТЬ ВТ_Товары
	               |ИЗ
	               |	Документ.ЗаказПоставщикуСезонный.Товары КАК ДокТовары
	               |ГДЕ
	               |	ДокТовары.Ссылка = &СезонныйЗаказПоставщику
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ
	               |	Товары.Типоразмер КАК Типоразмер,
	               |	Товары.Код,
	               |	Товары.Артикул,
	               |	Товары.Производитель,
	               |	Товары.Номенклатура,
	               |	Товары.Заказано КАК Заказано,
	    //-------------------все реальные ЗАКУПКИ!---------------------			   
	               |	ЕстьNull(ЗаказыПоставщикамОбороты.КоличествоОборот,0) КАК Куплено,
				   |	выбор когда Товары.Заказано>ЕстьNull(ЗаказыПоставщикамОбороты.КоличествоОборот,0) 
				   |			тогда Товары.Заказано - ЕстьNull(ЗаказыПоставщикамОбороты.КоличествоОборот,0) иначе 0 Конец КАК Осталось,
				   
		//-------------------Остатки на всех складах---------------------			   
				   |    ЕстьNull(ТоварыОстатки.КоличествоОстаток,0) как НаНачало,
				   
		//--------все Заказы (проделенные) за период с нач. по тек. с той же сторостью - столько ещё будет до конца сезона! ---------------------			   
				   |    ЕстьNull(Заказы.ПодЗаказ,0)*&коэффОст/(1-&коэффОст) как ПодЗаказ,
				   
				   //всегда 0 -> расчетная ---- 
//	текСтр.Дозаказать = текСтр.ПодЗаказ - (текСтр.НаКонец + текСтр.Осталось);
				   | ЕстьNull(Заказы.ПодЗаказ,0)*&коэффОст/(1-&коэффОст)  - (ЕстьNull(ТоварыТекОстатки.КоличествоОстаток,0) + выбор когда Товары.Заказано>ЕстьNull(ЗаказыПоставщикамОбороты.КоличествоОборот,0) 
				   |			тогда Товары.Заказано - ЕстьNull(ЗаказыПоставщикамОбороты.КоличествоОборот,0) иначе 0 Конец) как Дозаказать,
				   
				   //всегда 0 -> расчетная ---- 
				   |    ЕстьNull(ТоварыТекОстатки.КоличествоОстаток,0) как НаКонец,
				   
				   |ВсеЦены.ЦенаB2B как ЦенаB2B,
				   |ВсеЦены.ЦенаКрОпт как ЦенаКрОпт
				   
	               |ИЗ
	               |	ВТ_Товары КАК Товары
				   
	               |ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.Закупки.Обороты(&НачПериода, &ТекДата,,
	               |				Номенклатура В (ВЫБРАТЬ ВТ.Номенклатура ИЗ ВТ_Товары КАК ВТ)) КАК ЗаказыПоставщикамОбороты
	               |		ПО Товары.Номенклатура = ЗаказыПоставщикамОбороты.Номенклатура
				   
				   |ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.ТоварыНаСкладах.Остатки(&НачПериода, 
	               |				Номенклатура В (ВЫБРАТЬ ВТ.Номенклатура ИЗ ВТ_Товары КАК ВТ)) КАК ТоварыОстатки
	               |		ПО Товары.Номенклатура = ТоварыОстатки.Номенклатура
				   
				   |ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.ТоварыНаСкладах.Остатки(&ТекДата, 
	               |				Номенклатура В (ВЫБРАТЬ ВТ.Номенклатура ИЗ ВТ_Товары КАК ВТ)) КАК ТоварыТекОстатки
	               |		ПО Товары.Номенклатура = ТоварыТекОстатки.Номенклатура

				     |ЛЕВОЕ СОЕДИНЕНИЕ (ВЫБРАТЬ
				     |	зак.Номенклатура,
				     |	зак.КоличествоОборот КАК ПодЗаказ
				     |ИЗ
				     |	РегистрНакопления.ЗаказыПокупателей.Обороты(&НачПериода, &ТекДата, ,
					 |	Номенклатура В (ВЫБРАТЬ ВТ.Номенклатура ИЗ ВТ_Товары КАК ВТ)
				     |	И ЗаказПокупателя.Проведен
				     |	И ЗаказПокупателя.Проверен ) КАК зак
				   |) КАК Заказы
	               |		ПО Товары.Номенклатура = Заказы.Номенклатура

 
	               |ЛЕВОЕ СОЕДИНЕНИЕ ( ВЫБРАТЬ
				   |	Цены.Номенклатура,
				   |	МАКСИМУМ(ВЫБОР КОГДА Цены.ТипЦен = &ЦенаB2B	ТОГДА Цены.Цена ИНАЧЕ 0 КОНЕЦ) КАК ЦенаB2B,
				   |	МАКСИМУМ(ВЫБОР КОГДА Цены.ТипЦен = &КрОпт ТОГДА Цены.Цена ИНАЧЕ 0 КОНЕЦ) КАК ЦенаКрОпт
				   |	ИЗ
				   |	РегистрСведений.ЦеныНоменклатуры.СрезПоследних( &ТекДата,
				   |			(ТипЦен = &ЦенаB2B ИЛИ ТипЦен = &КрОпт)
				   |				И Номенклатура В(ВЫБРАТЬ ВТ.Номенклатура ИЗ ВТ_Товары КАК ВТ)) КАК Цены
				   |	СГРУППИРОВАТЬ ПО
				   |	Цены.Номенклатура) как ВсеЦены
	               |		ПО Товары.Номенклатура = ВсеЦены.Номенклатура
	               |ИТОГИ
	               |	СУММА(Заказано),
	               |	СУММА(Куплено),
	               |	СУММА(Осталось),
				   |	СУММА(НаНачало),
	               |	СУММА(ПодЗаказ),
	               |	СУММА(Дозаказать),
	               |	СУММА(НаКонец),
				   
				   |	Среднее(ЦенаB2B),
	               |	Среднее(ЦенаКрОпт)
	               |ПО
	               |	Типоразмер";
				   
	Запрос.УстановитьПараметр("КоэффОст", 1-ПроцентСезона/100); // коэффициент остатка сезона
	Запрос.УстановитьПараметр("СезонныйЗаказПоставщику", СезонныйЗаказПоставщику);
	Запрос.УстановитьПараметр("НачПериода", НачПериода );
	Запрос.УстановитьПараметр("ТекДата",ТекущаяДата() );
	
	Запрос.УстановитьПараметр("ЦенаB2B",справочники.ТипыЦенНоменклатуры.НайтиПоКоду(КодB2B) );
	Запрос.УстановитьПараметр("КрОпт",  справочники.ТипыЦенНоменклатуры.НайтиПоКоду(КодКрОпт) );
	
	возврат Запрос;
	
КонецФункции

Процедура КнопкаВыполнитьНажатие(Кнопка)
	
	Если СезонныйЗаказПоставщику.Пустая() тогда
		Предупреждение("Не выбран Сезонный заказ поставщику!",30);
		возврат
	КонецЕсли;	
	Если НачПериода<'20160101' тогда
		Предупреждение("Не Заполнено поле Начало сезона!",30);
		возврат
	КонецЕсли;	
		
	запросГлавный = ПолучитьГлавныйЗапрос();
	Результат = запросГлавный.выполнить();
	Если Результат.Пустой() тогда
		Предупреждение("Ничего не найдено!", 30);		
	КонецЕсли;
	
	Дерево.Строки.Очистить();
	Дерево = результат.Выгрузить(ОбходРезультатаЗапроса.ПоГруппировкам);
	ЭлементыФормы.КоманднаяПанель1.Кнопки.Свернуть.пометка = ложь;
	ЭлементыФормы.КоманднаяПанель1.Кнопки.Свернуть.Текст = "Развернуть";
КонецПроцедуры

Процедура ОсновныеДействияФормыДозаказ(Кнопка)
//При нажатии собираем только позиции с положительным значением в колонке "Дозаказать" 
//и формируем файлик Эксель. 
//с возможностью отбора по бренду на стадии подготовки заказа.
док = документы.ЗаказПоставщику.СоздатьДокумент();

	Для каждого стр1 из Дерево.Строки цикл
		Для каждого стр2 из стр1.Строки цикл
			Если стр2.Дозаказать>0 тогда
				стрЗак = док.Товары.Добавить();
				стрЗак.Номенклатура = стр2.Номенклатура;
				стрЗак.Количество  = стр2.Дозаказать;
				стрЗак.Коэффициент = 1;
				стрЗак.ЕдиницаИзмерения = стр2.Номенклатура.ЕдиницаХраненияОстатков;
				
				стрЗак.СтавкаНДС = перечисления.СтавкиНДС.БезНДС;
				стрЗак.Цена  = ?(стр2.ЦенаB2B>0, стр2.ЦенаB2B, стр2.ЦенаКрОпт);
				стрЗак.Сумма = стрЗак.Цена  * стрЗак.Количество;
			КонецЕсли;	
		КонецЦикла;		
	КонецЦикла;
 формаЗак = док.ПолучитьФорму("ФормаДокумента");
 формаЗак.Открыть();
КонецПроцедуры

//==============период и %==============================
функция ЧислоРабДней(дата1, дата2)
	колДн = (КонецДня(дата2)+1 - НачПериода)/86400;
	дн1 = ДеньНедели(дата1);
	дн2 = ДеньНедели(дата2);
	колДн = колДн - Цел(колДн/7)*2 - ?(дн1=7,1,?(дн1=6,2,0));
возврат колДн;
КонецФункции	

Процедура НачПериодаПриИзменении(Элемент)
	
	сегодня = НачалоДня(ТекущаяДата()); //БЕЗ сегодняшнего дня!
	Если Флажок1 тогда
		колДней   = ЧислоРабДней(НачПериода,сегодня-1); 
		КолПериод = ЧислоРабДней(НачПериода,КонПериода); 
		Если колДней>КолПериод 
			тогда ПроцентСезона = 100;
			иначе ПроцентСезона =?(КолПериод>0,100*колДней/КолПериод,0);
		КонецЕсли;	
		элементыФормы.Надпись1.Заголовок = "Прошло: "+строка(колДней)+" раб.дней из "+строка(КолПериод)+" = "+формат(ПроцентСезона,"ЧДЦ=1")+"%";
	Иначе
		колДней = (сегодня - НачПериода)/86400;
		КолПериод = (КонецДня(КонПериода)+1 - НачПериода)/86400;
		Если колДней>КолПериод 
			тогда ПроцентСезона = 100;
			иначе ПроцентСезона =?(КолПериод>0,100*колДней/КолПериод,0);
		КонецЕсли;	
		элементыФормы.Надпись1.Заголовок = "Прошло: "+строка(колДней)+" дней из "+строка(КолПериод)+" = "+формат(ПроцентСезона,"ЧДЦ=1")+"%";
	КонецЕсли;	
	
КонецПроцедуры

Процедура НачПериодаРегулирование(Элемент, Направление, СтандартнаяОбработка)
	НачПериодаПриИзменении(неопределено)
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
	
	НачПериодаПриИзменении(неопределено);

КонецПроцедуры

Процедура СезонныйЗаказПоставщикуПриИзменении(Элемент)
	Если не СезонныйЗаказПоставщику.Пустая() тогда 
		Если Вопрос("Обновить ВСЕ данные?",РежимДиалогаВопрос.ДаНет)=КодВозвратаДиалога.Да тогда
			КнопкаВыполнитьНажатие(неопределено);
		КонецЕсли;	
	КонецЕсли;	
КонецПроцедуры

//================изменение дерева=======================================
функция ПолучитьЦену(Номенклатура, ЭтоКрОпт=ЛОЖЬ)
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	|	ЦеныНоменклатурыСрезПоследних.Цена
	|ИЗ
	|	РегистрСведений.ЦеныНоменклатуры.СрезПоследних( ,
	|			Номенклатура = &Номенклатура
	|				И ТипЦен = &ТипЦен) КАК ЦеныНоменклатурыСрезПоследних";
	Запрос.УстановитьПараметр("Номенклатура", Номенклатура );
	КодТипаЦен = ?(ЭтоКрОпт,КодКрОпт,КодB2B);
	Запрос.УстановитьПараметр("ТипЦен", справочники.ТипыЦенНоменклатуры.НайтиПоКоду(КодТипаЦен ) );
	
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	рез = 0;
	Если Выборка.Следующий() тогда
		рез = Выборка.цена;
	КонецЕсли;	
	возврат рез;
КонецФункции	

Процедура ДеревоНоменклатураПриИзменении(Элемент)
	текСтр = ЭлементыФормы.Дерево.ТекущиеДанные;
	Если текСтр<>неопределено тогда
		Если ЗначениеЗаполнено(текСтр.Номенклатура) тогда
			текСтр.Типоразмер    = текСтр.Номенклатура.Типоразмер;
			текСтр.Производитель = текСтр.Номенклатура.Производитель;
			текСтр.Код     = текСтр.Номенклатура.Код;
			текСтр.Артикул = текСтр.Номенклатура.Артикул;
			текСтр.ЦенаB2B   = ПолучитьЦену(текСтр.Номенклатура);
			текСтр.ЦенаКрОпт = ПолучитьЦену(текСтр.Номенклатура, Истина);
		Иначе 
			текСтр.Код 	   = "";
			текСтр.Артикул = ""; 
			текСтр.ЦенаB2B   = 0;
			текСтр.ЦенаКрОпт = 0;
		КонецЕсли;
	КонецЕсли;	
КонецПроцедуры

Процедура ДеревоДозаказатьПриИзменении(Элемент)
	текСтр = ЭлементыФормы.Дерево.ТекущиеДанные;
	Если текСтр.уровень()=1 тогда
		Дозаказать = 0;  //вверх по уровню
		для каждого стр2 из текСтр.Родитель.строки цикл
			Дозаказать = Дозаказать + стр2.Дозаказать;
		КонецЦикла;	
		текСтр.Родитель.Дозаказать = Дозаказать;
	КонецЕсли;	
КонецПроцедуры

Процедура ДеревоПриПолученииДанных(Элемент, ОформленияСтрок)
	масКол = новый массив;
	масКол.Добавить("НаНачало");	масКол.Добавить("НаКонец");
	масКол.Добавить("Заказано");	масКол.Добавить("Куплено");
	масКол.Добавить("Осталось");	масКол.Добавить("ПодЗаказ");
	
	для i=0 по масКол.Количество()-1 цикл
		ЭлементыФормы.Дерево.Колонки[масКол[i]].ТекстПодвала = формат(Дерево.Строки.Итог(масКол[i]),"ЧДЦ=0");
	КонецЦикла;
	
	ИтогДозаказать = 0;
	Для каждого стр1 из Дерево.строки цикл
		для каждого стр2 из стр1.строки цикл
			Если стр2.Дозаказать>0 тогда
	ИтогДозаказать = ИтогДозаказать + стр2.Дозаказать;
			КонецЕсли;
    	КонецЦикла;
	КонецЦикла;
	
	Для каждого стр1 из ОформленияСтрок цикл
		Если стр1.ДанныеСтроки.Уровень()=0 тогда
			стр1.ЦветФона = webЦвета.СветлоЖелтый;
		ИначеЕсли стр1.ДанныеСтроки.Дозаказать<>неопределено 
			и стр1.ДанныеСтроки.Дозаказать>0 тогда
			//стр1.ЦветФона = webЦвета.БледноЗеленый;
			стр1.Шрифт = новый Шрифт(,,Истина); //Жирный!
		КонецЕсли;	
	КонецЦикла;	
	ЭлементыФормы.Дерево.Колонки.Дозаказать.ТекстПодвала = формат(ИтогДозаказать,"ЧДЦ=0");
	
КонецПроцедуры

Процедура КоманднаяПанель1Развернуть(Кнопка)
	
	ЭлементыФормы.КоманднаяПанель1.Кнопки.Свернуть.Пометка = не ЭлементыФормы.КоманднаяПанель1.Кнопки.Свернуть.Пометка;
	фл = ЭлементыФормы.КоманднаяПанель1.Кнопки.Свернуть.Пометка;
	
	ЭлементыФормы.КоманднаяПанель1.Кнопки.Свернуть.Текст = ?(фл,"Свернуть","Развернуть");

	Для каждого стр1 из Дерево.строки цикл
		Если фл тогда
		ЭлементыФормы.Дерево.Развернуть(стр1, ложь);
		иначе	
		ЭлементыФормы.Дерево.Свернуть(стр1);
		КонецЕсли;	
	КонецЦикла;

КонецПроцедуры

Процедура ДеревоПодЗаказПриИзменении(Элемент)
	
	текСтр = ЭлементыФормы.Дерево.ТекущиеДанные;
	текСтр.Осталось = ?(текСтр.Заказано>текСтр.Куплено, текСтр.Заказано - текСтр.Куплено, 0);
	
	коэффОст = (1-ПроцентСезона/100);
		   
    //тек.остаток + ещё будет заказано - скока будет продано (под заказ клиентам) до конца сезона...
	текСтр.Дозаказать = текСтр.ПодЗаказ - (текСтр.НаКонец + текСтр.Осталось);
	
	ДеревоДозаказатьПриИзменении(неопределено);
КонецПроцедуры

КодКрОпт = "00005";
КодB2B   = "00032";