﻿
Процедура КнопкаВыполнитьНажатие(Кнопка)
	//
	Эксель = Новый COMОбъект("Excel.Application");
	//ПутьКФайлу="\\Novikova\Таблица11\таблица 11.xls";
	ПутьКФайлу="c:\Таблица11\таблица 11.xls";
	Файл = Новый Файл(ПутьКФайлу);
	Если Не Файл.Существует() Тогда
		Сообщить("Файл не существует!");
		Возврат;
	КонецЕсли; 
	Книга   = Эксель.Workbooks.Open(ПутьКФайлу);
	КоличествоЛистов = Книга.Sheets.Count;
	НомерЛиста=1;
	СписокЛистов=новый СписокЗначений;
	Пока НомерЛиста <= КоличествоЛистов Цикл
		СписокЛистов.Добавить(Книга.Sheets(НомерЛиста).Name);
		НомерЛиста=НомерЛиста+1;
	КонецЦикла;
	ЛистСезон=СписокЛистов.ВыбратьЭлемент("Укажите сезон");
	Лист                = Книга.Worksheets(ЛистСезон.Значение);
	КоличествоСтрок     = Лист.Cells(1,1).SpecialCells(11).Row;
	
	КолонкаКонтейнер    = "I";
	КолонкаДатаПриходаВПорт="Q";
	//
	СписокКонтрагентов=Новый СписокЗначений;
	СписокКонтрагентов.Добавить(Справочники.Контрагенты.НайтиПоКоду("91735")); //FREEMAN RACING WHEELS INC
	СписокКонтрагентов.Добавить(Справочники.Контрагенты.НайтиПоКоду("93695")); //NINGBO PARTNER INTERNATIONAL TRADE CO., LTD
	СписокКонтрагентов.Добавить(Справочники.Контрагенты.НайтиПоКоду("91535")); //JIANGSU SAINTY MACHINERY I&E CORP. LTD
	СписокКонтрагентов.Добавить(Справочники.Контрагенты.НайтиПоКоду("П000715")); //Zhejiang Jingu Company Ltd
	СписокКонтрагентов.Добавить(Справочники.Контрагенты.НайтиПоКоду("93777")); //Steel Strips Wheels Limited
	СписокКонтрагентов.Добавить(Справочники.Контрагенты.НайтиПоКоду("93694")); //Zhangzhou Shuangsheng WHeels Co., ltd
	СписокКонтрагентов.Добавить(Справочники.Контрагенты.НайтиПоКоду("91834")); //NINGBO LONGTIME MACHINE CO.,LTD
	СписокКонтрагентов.Добавить(Справочники.Контрагенты.НайтиПоКоду("П001626")); //XIAMEN YONGXINGXUN INDUSTRY AND TRADE CO., LTD
	СписокКонтрагентов.Добавить(Справочники.Контрагенты.НайтиПоКоду("92540")); //FUJIAN SHUANGSHENG IM &EX CO., LTD
	СписокКонтрагентов.Добавить(Справочники.Контрагенты.НайтиПоКоду("94302"));//ZHANGZHOU LIYANG MACHINE CO., LTD
	СписокКонтрагентов.Добавить(Справочники.Контрагенты.НайтиПоКоду("93512"));//Nexen Tire Corporation
	СписокКонтрагентов.Добавить(Справочники.Контрагенты.НайтиПоКоду("94632"));//Xiamen Jiashunlai Trading Co..Ltd
	СписокКонтрагентов.Добавить(Справочники.Контрагенты.НайтиПоКоду("П012694"));//SHANDONG ZHONGYI RUBBER CO. LTD

	Запрос=новый Запрос;
	Запрос.Текст="ВЫБРАТЬ
	             |	ЗаказПоставщику.Ссылка,
	             |	ЗаказПоставщику.НомерКонтейнера,
	             |	ЗаказПоставщику.ДатаПоступления
	             |ИЗ
	             |	Документ.ЗаказПоставщику КАК ЗаказПоставщику
	             |ГДЕ
	             |	ЗаказПоставщику.Дата МЕЖДУ &ДатаН И &ДатаК
	             |	И ЗаказПоставщику.Контрагент В(&СписокКонтрагентов)";
	Запрос.УстановитьПараметр("ДатаН",НачПериода);
	Запрос.УстановитьПараметр("ДатаК",КонецДня(КонПериода));
	Запрос.УстановитьПараметр("СписокКонтрагентов",СписокКонтрагентов);
	Рез=Запрос.Выполнить().Выбрать();
	Пока рез.Следующий() Цикл
		КонтейнерИзДока=СокрЛП(Рез.НомерКонтейнера);
		Если КонтейнерИзДока<>"" Тогда
			НСтр = Лист.Columns(КолонкаКонтейнер).Find(КонтейнерИзДока);
			Если НСтр<>Неопределено тогда
				СтрокаExcel=НСтр.Row;
				ДатаПрихода =  СокрЛП(Лист.Cells(СтрокаExcel,  КолонкаДатаПриходаВПорт).Value);
				Если ДатаПрихода<>"" тогда
					Попытка
						Если Рез.ДатаПоступления<>Дата(ДатаПрихода) тогда
							ДокОб=Рез.Ссылка.ПолучитьОбъект();
							ДокОб.ДатаПоступления=Дата(ДатаПрихода);
							Если ДокОб.Проведен тогда
								ДокОб.Записать(РежимЗаписиДокумента.Проведение);
							Иначе
								ДокОб.Записать();
							КонецЕсли;
						КонецЕсли;
						Сообщить("Контейнер: "+КонтейнерИзДока+" было: "+Формат(Рез.ДатаПоступления,"ДФ=dd.MM.yyyy")+" стало "+Формат(Дата(ДатаПрихода),"ДФ=dd.MM.yyyy"));
					Исключение
						Сообщить(КонтейнерИзДока);
						Сообщить(ОписаниеОшибки());
						//ДокОб=Рез.Ссылка.ПолучитьОбъект();
					КонецПопытки;
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	Эксель.DisplayAlerts = 0; 
	Эксель.Quit();
	
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
