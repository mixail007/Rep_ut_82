﻿Перем логин, пароль;
Перем ПланОбменаССайтом;
Процедура ПолучитьСтатусЗаказаDPD(ДатаНачала,ДатаКонца) экспорт
	Запрос = новый Запрос;
	Запрос.Текст="ВЫБРАТЬ РАЗЛИЧНЫЕ
	             |	ЗаказПокупателя.Грузоотправитель КАК Поставщик,
	             |	ЗаказПокупателя.Ссылка КАК ЗаказПокупателя,
	             |	ЗаказПокупателя.Номер КАК НомерЗаказа,
	             |	ЕСТЬNULL(ЗаказПокупателя.Грузоотправитель.Код, ЗаказПокупателя.Организация.Код) КАК ПоставщикКод,
	             |	ЗаказПокупателя.Ссылка
	             |ИЗ
	             |	Документ.ЗаказПокупателя КАК ЗаказПокупателя
	             |ГДЕ
	             |	ЗаказПокупателя.Дата МЕЖДУ &ДатаН И &ДатаК
	             |	И ЗаказПокупателя.TerminalОтгрузкаТранспортнойКомпанией = ИСТИНА";
				 
				 
				 Запрос.УстановитьПараметр("ДатаН",ДатаНачала);
				 //Запрос.УстановитьПараметр("ДатаК",КонецДня(ДатаКонца));
				 Запрос.УстановитьПараметр("ДатаК",(ДатаКонца));
			//	 Запрос.УстановитьПараметр("НаправлениеОтгрузкиDPD",Справочники.НаправленияОтгрузок.НайтиПоКоду("000000013"));
				 Запрос.УстановитьПараметр("ДатаПерехода",КонецГода(ТекущаяДата()));

				 
				 Рез=Запрос.Выполнить().Выбрать();
				 Выборка = Запрос.Выполнить().Выбрать();
				 Пока Выборка.Следующий() цикл
					 ЗаписьXML = ПодготовитьШапкуXML(Рез,неопределено);
					 ЗаписьXML = ДобавитьЗаказВDPD(ЗаписьXML,Выборка,неопределено);
					 ЗаписьXML = ДополнитьЗаписьXML(ЗаписьXML);
					 ТекстXML = ЗаписьXML.Закрыть();
					 Ответ = ОтправитьЗапросWEBСервису("http://ws.dpd.ru:80/services/order2",ТекстXML);
					 Сообщить(Ответ);
			//		 Ответ = ОтправитьЗапросWEBСервису("http://wstest.dpd.ru:80/services/order2",ТекстXML);
					 Если Ответ<>"" тогда
						 Текст = новый ТекстовыйДокумент;
						 Текст.ДобавитьСтроку(Ответ);
						 ИмяФайла = ПолучитьИмяВременногоФайла("xml");
						 Текст.Записать(ИмяФайла,"UTF-8 ");
					    РазобратьXMLОтветGetOrderStatus(ИмяФайла,Выборка.Ссылка);
					 КонецЕсли;
				 КонецЦикла;
					 
	//СоздатьЗадачиПоВозвратнымЗаказам();//по заказам, которые дпд вот-вот отправит назад, создадим задачи
КонецПроцедуры
			 
Функция ПодготовитьШапкуXML(Выборка,ДатаОтправки)
	ЗаписьXML = Новый ЗаписьXML;
	ЗаписьXML.УстановитьСтроку();
	ЗаписьXML.ЗаписатьНачалоЭлемента("soap:Envelope");
	ЗаписьXML.ЗаписатьАтрибут("xmlns:soap", "http://schemas.xmlsoap.org/soap/envelope/");
	ЗаписьXML.ЗаписатьАтрибут("xmlns:ns","http://dpd.ru/ws/order2/2012-04-04");
	ЗаписьXML.ЗаписатьНачалоЭлемента("soap:Header");
	ЗаписьXML.ЗаписатьКонецЭлемента();
	ЗаписьXML.ЗаписатьНачалоЭлемента("soap:Body");
	ЗаписьXML.ЗаписатьНачалоЭлемента("ns:getOrderStatus");
    ЗаписьXML.ЗаписатьНачалоЭлемента("orderStatus");
	
	ЗаписьXML.ЗаписатьНачалоЭлемента("auth");
	ЗаписьXML.ЗаписатьНачалоЭлемента("clientNumber"); ЗаписьXML.ЗаписатьТекст(Логин); ЗаписьXML.ЗаписатьКонецЭлемента();
	ЗаписьXML.ЗаписатьНачалоЭлемента("clientKey"); ЗаписьXML.ЗаписатьТекст(Пароль); ЗаписьXML.ЗаписатьКонецЭлемента();
	ЗаписьXML.ЗаписатьКонецЭлемента();//auth
	
	Возврат ЗаписьXML;
КонецФункции
Функция ДобавитьЗаказВDPD(Запись,Выборка,КодУслуги)
	//Важен порядок!!!!!!!!
	Запись.ЗаписатьНачалоЭлемента("order");
	Запись.ЗаписатьНачалоЭлемента("orderNumberInternal"); Запись.ЗаписатьТекст(""+СокрЛП(Выборка.НомерЗаказа)+"_"+СокрЛП(Выборка.ПоставщикКод)); Запись.ЗаписатьКонецЭлемента();
	Запись.ЗаписатьКонецЭлемента();//order
	возврат Запись;
КонецФункции
Функция ДополнитьЗаписьXML(Запись)
	 Запись.ЗаписатьКонецЭлемента();//orders
     Запись.ЗаписатьКонецЭлемента();//createOrder
     Запись.ЗаписатьКонецЭлемента();//Body
	 Запись.ЗаписатьКонецЭлемента();//Envelope
	возврат Запись;
КонецФункции
Функция ОтправитьЗапросWEBСервису(URL,ТекстXML,Таймаут = 10000)
	Если ПустаяСтрока(ТекстXML) Тогда
		Возврат "";
	КонецЕсли;
	WinHttp = Новый COMОбъект("WinHttp.WinHttpRequest.5.1");
	WinHttp.SetTimeouts(Таймаут, Таймаут, Таймаут, Таймаут);
	WinHttp.Option(2,"utf-8");
	WinHttp.Open("POST",URL);
	WinHttp.setRequestHeader("Content-Type","text/xml; charset=utf-8");
	//Сообщить("Начало - " + ТекущаяДата());
	//Сообщить("URL: " + URL);
	//Сообщить("ТекстXML запроса: " + ТекстXML);
	Попытка
		WinHttp.Send(ТекстXML);
		//Сообщить("Завершение - " + ТекущаяДата());
		Если WinHttp.Status = 200 Тогда
			Ответ=WinHttp.ResponseStream;
			//Список=Ответ.ПолучитьСписок("parcelShop");
			//ВсегоЗаписей=Список.Количество();
			//Сообщить("Ответ: " + WinHttp.ResponseText);
			//Текст = новый ТекстовыйДокумент;
			//Текст.ДобавитьСтроку(WinHttp.ResponseText());
			//Текст.Записать("C:\1c\" + "otvet.xml","UTF-8 "); 
			//Сообщить("ВсегоЗаписей: " + ВсегоЗаписей);

			Возврат(WinHttp.ResponseText);
		Иначе
			Сообщить("Ошибка сервера: " + WinHttp.Status + " " + WinHttp.ResponseText + " " + WinHttp.StatusText, СтатусСообщения.Важное);
			Возврат("");
		КонецЕсли;
	Исключение
		Сообщить(ОписаниеОшибки(), СтатусСообщения.Важное);
		Возврат("");
	КонецПопытки;
КонецФункции
Функция РазобратьXMLОтветGetOrderStatus(файл,заказ)
	ЧтениеXML = Новый ЧтениеXML;
	ЧтениеXML.ОткрытьФайл(Файл);
	ТабЗаказы = новый ТаблицаЗначений;
	ТабЗаказы.Колонки.Добавить("orderNumberInternal");
	ТабЗаказы.Колонки.Добавить("status");
	ТабЗаказы.Колонки.Добавить("orderNum");
	ТабЗаказы.Колонки.Добавить("errorMessage");
	ТабЗаказы.Колонки.Добавить("ЗаказПоставщика");
	
	ЗаказыXDTO = ФабрикаXDTO.ПрочитатьXML(ЧтениеXML);
	
	Заказы = ЗаказыXDTO.Body.getOrderStatusResponse.return;
	
	
	ЗаказОб = Заказ.ПолучитьОбъект();
	 		Если СокрЛП(Заказы.status)="OK" тогда
	        	ЗаказОб.СтатусДПД  = Перечисления.СтатусыЗаказовДПД.ДПДЗаказПодтвержден;
				ЗаказОб.СтатусПеревозчика  = Заказы.status;
				нстр=ЗаказОб.РеквизитыЗаказаТК.Добавить();
				нстр.Поле="Номер заказа перевозчика";
				нстр.Значение=Заказы.orderNum;
				Сообщить(Заказ.Номер+" "+ Заказы.errorMessage);
			ИначеЕсли СокрЛП(Заказы.status)="OrderPending" тогда
	        	ЗаказОб.СтатусДПД  = Перечисления.СтатусыЗаказовДПД.ДПДНаРассмотрении;
				ЗаказОб.СтатусПеревозчика  = Заказы.status;
				Сообщить(Заказ.Номер+" "+ Заказы.errorMessage);
			ИначеЕсли СокрЛП(Заказы.status)<>"" тогда
				ЗаказОб.СтатусДПД  = Перечисления.СтатусыЗаказовДПД.ДПДОшибка;
				ЗаказОб.СтатусПеревозчика  = Заказы.status;
				Сообщить(Заказ.Номер+" "+ Заказы.errorMessage);
			КонецЕсли;
      ЗаказОб.записать(РежимЗаписиДокумента.Запись);
	
	
	//Если ТипЗнч(Заказы)<>Тип("СписокXDTO") Тогда
	//	СписокXDTOЗаказы = Новый Массив;
	//	попытка
	//		СписокXDTOЗаказы.Добавить(Заказы.return);
	//	исключение
	//		СписокXDTOЗаказы.Добавить(Заказы);
	//	КонецПопытки;
	//Иначе
	//	СписокXDTOЗаказы = Заказы;
	//КонецЕсли;
	//
	//Для Каждого XDTOЗаказ из СписокXDTOЗаказы цикл
	//	нстр = ТабЗаказы.Добавить();
	//	ЗаполнитьЗначенияСвойств(нстр,XDTOЗаказ);
	//КонецЦикла;
	//отбор = новый Структура("Поставщик");
	//
	//Для каждого стр из ТабЗаказы цикл
	//	номерВрем = стр.orderNumberInternal;
	//	Позиция_=Найти(номерВрем,"_")-1;
	//	НомерЗаказа=лев(номерВрем,Позиция_);
	//	КодПоставщика = Сред(номерВрем,Позиция_+2);
	//	Заказ = Документы.ЗаказПокупателя.НайтиПоНомеру(НомерЗаказа,текущаяДата());
	//	Если Заказ = Документы.ЗаказПокупателя.ПустаяСсылка() тогда
	//		 Заказ = Документы.ЗаказПокупателя.НайтиПоНомеру(НомерЗаказа,НачалоГода(текущаяДата())-1);
	//	КонецЕсли;
	//	ЗаказОб=Заказ.ПолучитьОбъект();
	//	ЗаказОб.ОбменДанными.Загрузка = Истина;
	//	Товары = ЗаказОб.Товары;
	//	РеквизитыТК = ЗаказОб.РеквизитыЗаказаТК;
	//	Поставщик = справочники.Контрагенты.НайтиПоКоду(КодПоставщика);
	//	отбор.Поставщик = Поставщик;
	//	НайденныеСтроки = товары.НайтиСтроки(отбор);
	//	СтатусОК=0;
	//	СтатусНаРассмотрении=0;
	//	СтатусОшибка=0;
	//	ЗаказПоставщика="";
	//	Для каждого строка из НайденныеСтроки цикл
	//		строка.ЗаказПеревозчика=стр.orderNum;
	//		строка.СтатусЗаказаПеревозчика=стр.status;
	//		строка.ОшибкаПеревозчика=стр.errorMessage;
	//		
	//		Если СокрЛП(стр.status)="OK" тогда
	//			СтатусОК=СтатусОК+1;
	//		ИначеЕсли СокрЛП(стр.status)="OrderPending" тогда
	//			СтатусНаРассмотрении=СтатусНаРассмотрении+1;
	//		ИначеЕсли СокрЛП(стр.status)<>"" тогда
	//			СтатусОшибка=СтатусОшибка+1;
	//		КонецЕсли;
	//		ЗаказПоставщика = строка.НомерЗаказаПоставщика;
	//	КонецЦикла;
	//	
	//	
	//	Если СтатусОшибка>0 тогда
	//		//ЗаказОб.Статус  = Перечисления.СтатусыЗаказов.ДПДОшибка;
	//	ИначеЕсли СтатусНаРассмотрении>0 тогда
	//		//ЗаказОб.Статус  = Перечисления.СтатусыЗаказов.ДПДНаРассмотрении;
	//	ИначеЕсли  СтатусОК>0 тогда
	//		//ЗаказОб.Статус  = Перечисления.СтатусыЗаказов.ДПДЗаказПодтвержден;		
	//		нстрТК = РеквизитыТК.Добавить();
	//		нстр=ЗаказОб.РеквизитыЗаказаТК.Добавить();
	//		нстр.Заказ=стр.orderNumberInternal;
	//		нстр.ЗаказПоставщика = ЗаказПоставщика;
	//		нстр.Поле="Номер заказа перевозчика";
	//		нстр.Значение=стр.orderNum;
	//	КонецЕсли;	
	//	//ПланыОбмена.ЗарегистрироватьИзменения(ПланОбменаССайтом, ЗаказОб.Ссылка);
	//	ЗаказОб.Записать();
	//	//Если Заказоб.Статус = Перечисления.СтатусыЗаказов.ДПДЗаказПодтвержден тогда
	//	//	интернетМагазин.ОбновитьЗаказВЯШТ(Заказоб.Ссылка);
	//	//КонецЕсли;
	//	#Если клиент тогда
	//		Сообщить(ЗаказОб);
	//	#КонецЕсли	
	//КонецЦикла;
КонецФункции

Процедура СоздатьЗадачиПоВозвратнымЗаказам() экспорт
	//Запрос = Новый Запрос;
	//Запрос.Текст="ВЫБРАТЬ РАЗЛИЧНЫЕ
	//			 |	ЗадачиПользователя.Объект КАК ЗаказПокупателя
	//			 |ПОМЕСТИТЬ втЗаказыВЗадачах
	//			 |ИЗ
	//			 |	Задача.ЗадачиПользователя КАК ЗадачиПользователя
	//			 |;
	//			 |
	//			 |////////////////////////////////////////////////////////////////////////////////
	//			 |ВЫБРАТЬ РАЗЛИЧНЫЕ 
	//			 |	ЗаказПокупателяТовары.Ссылка КАК ЗаказПокупателя,
	//			 |	ЗаказПокупателяТовары.Ссылка.Ответственный,
	//			 |	ЗаказПокупателяТовары.Ссылка.Номер
	//			 |ИЗ
	//			 |	Документ.ЗаказПокупателя.Товары КАК ЗаказПокупателяТовары
	//			 |ГДЕ
	//			 |	ЗаказПокупателяТовары.Статус = ЗНАЧЕНИЕ(Перечисление.СтатусыЗаказов.ОтмененЖдемВозвратаОтТК)
	//			 |	И НЕ ЗаказПокупателяТовары.Ссылка В
	//			 |				(ВЫБРАТЬ
	//			 |					втЗаказыВЗадачах.ЗаказПокупателя
	//			 |				ИЗ
	//			 |					втЗаказыВЗадачах КАК втЗаказыВЗадачах)";
	//			 Рез = Запрос.Выполнить().Выбрать();
	//			 
	//			 пока Рез.Следующий() цикл
	//				 ЗадачаОб = Задачи.ЗадачиПользователя.СоздатьЗадачу();
	//				 ЗадачаОб.Дата=ТекущаяДата();
	//				 //ЗадачаОб.Исполнитель = Рез.Ответственный;
	//				 ЗадачаОб.Исполнитель =Справочники.Пользователи.НайтиПоНаименованию("Левченко Евгения Сергеевна");
	//				 ЗадачаОб.Наименование = "Заказ №"+ Рез.Номер+" отменен ТК";
	//				 ЗадачаОб.Объект = Рез.ЗаказПокупателя;
	//				 ЗадачаОб.Описание="Заказ №"+ Рез.Номер+" отменен ТК";
	//				 ЗадачаОб.Оповещение = Истина;
	//				 ЗадачаОб.Выполнена = ложь;
	//				 //ЗадачаОб.Выполнена = истина;
	//				 
	//				 ЗадачаОб.СрокОповещения = ТекущаяДата()-1;
	//				 ЗадачаОб.Записать();
	//			 КонецЦикла;
				 
			 КонецПроцедуры
			 
Процедура ДобавитьПараметраТК(тз,Заказ,Поле,Значение,ЗаказПоставщика)
	нстр = тз.Добавить();
	нстр.ЗаказПоставщика=ЗаказПоставщика;
	нстр.Заказ=Заказ;
	нстр.Поле=Поле;
	нстр.Значение = Значение;
КонецПроцедуры
    //для рабочего
    Логин="1007003275"; //ЯШТ
	Пароль = "6078E6EF054E13F442B4A46ADDE226628F946EDC"; //ЯШТ
	//		 
//для тестового
//Логин= "1001027795";
//Пароль = "182A17BD6FC5557D1FCA30FA1D56593EB21AEF88";
//	
	