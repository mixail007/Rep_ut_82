﻿
Процедура КнопкаВыполнитьНажатие(Кнопка)
	
	
	Если не ПроверитьЗаполнение()тогда
		Сообщить("Заполните все необходимые поля!");
		Возврат;
	КонецЕсли;
	
	Если СписокРеализаций.Количество()= 0 тогда
		Сообщить("В списке пусто!!");
		Возврат;
	КонецЕсли;
	
	Если Договор.ТипДоговора = Справочники.ТипыДоговоров.ФормулаАвтоПлюс или Договор.ТипДоговора = Справочники.ТипыДоговоров.ШинтрейдЯрославль тогда
		Предупреждение("Данная обработка не предназначена для печати договоров с типом Шинтрейд и ФАП! ");
				
		Возврат;
	КонецЕсли;
	
Сообщить(строка(ТекущаяДата())+" Обработка начало ------------------------");	

ПеренестиДокиВБухгалтерию(СписокРеализаций);	
 
Сообщить(строка(ТекущаяДата())+" документы перенесены в Бухгалтерию  ---------------");	
 
 для каждого реализация из СписокРеализаций цикл
	 
	 реал = реализация.Значение;
	 
	 ТабДок = Новый ТабличныйДокумент();     //Плотников - не показывать
	 попытка
		 Если  (реал.Дата<Дата('20160501000000')или Найти(реал.ДоговорКонтрагента.Наименование,"*")<>0)  тогда
			 ТабДокСФ = Новый ТабличныйДокумент();
			 ТабДокСФ.Прочитать(КаталогВременныхфайлов()+реал.Номер+".mxl");
			 табДокСФ.АвтоМасштаб = Истина;
			 ТабдокСФ.ОтображатьСетку = Ложь;
			 ТабДокСФ.ТолькоПросмотр = Истина;
			 Если флПоказывать тогда //09.08.2018
			 	ТабДокСФ.Показать();
			 КонецЕсли;
		 иначе
			 ТабДок.Прочитать(КаталогВременныхфайлов()+реал.Номер+".mxl");
			 табДок.АвтоМасштаб = Истина;
			 Табдок.ОтображатьСетку = Ложь;
			 ТабДок.ТолькоПросмотр = Истина;
			 Макет = ПолучитьОбщийМакет("ШтрихКодДляУПД");
			 ОбластьШтриха = Макет.ПолучитьОбласть("Штрих");
			 Рисунок = ОбластьШтриха.Рисунки.Штрихкод;
			 Тд = Новый ТабличныйДокумент;
			 ОбШтрихКод=ОбластьШтриха.Рисунки.Штрихкод.Объект ;
			 ОбШтрихКод.ТипКода = 4; 
			 ОбШтрихКод.Сообщение = СформироватьШКРеализации(реал,"8");//XMLСтрока(ЭтотОбъект.Ссылка.УникальныйИдентификатор()); 
			 ОбШтрихКод.ОтображатьТекст = Ложь;
			 
			 Тд.Вывести(ОбластьШтриха);
			 ТД.Вывести(ТабДок);
			 ТД.Рисунки.D1.Верх = ТД.Рисунки.ШтрихКод.Верх;   
			 ТД.Рисунки.D1.Лево = ТД.Рисунки.ШтрихКод.Лево;   
			 тд.УдалитьОбласть(ТД.Область("Штрих"),ТипСмещенияТабличногоДокумента.ПоВертикали);   
			 тд.АвтоМасштаб = Истина;
			 Тд.ОтображатьСетку = Ложь;
			 Тд.ТолькоПросмотр = Истина;
			 тд.ОтображатьЗаголовки = ложь;  
			 Если флПоказывать тогда //09.08.2018
			 	ТД.Показать();
			 КонецЕсли;	
			 
		 КонецЕсли;
	 исключение
	 конецпопытки;
	 
	 
 КонецЦикла;

Сообщить(строка(ТекущаяДата())+" Обработка завершена ------------------------");	
	
	
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

Процедура КоманднаяПанель2ЗаполнитьПоОтбору(Кнопка)
	
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	РеализацияТоваровУслуг.Ссылка
	|ИЗ
	|	Документ.РеализацияТоваровУслуг КАК РеализацияТоваровУслуг
	|ГДЕ
	|	РеализацияТоваровУслуг.Контрагент = &Контрагент
	|" +?(ЗначениеЗаполнено(Договор)," И РеализацияТоваровУслуг.ДоговорКонтрагента = &ДоговорКонтрагента","")+"
	|	И РеализацияТоваровУслуг.Дата МЕЖДУ &ДатаНач И &ДатаКон
	|	И РеализацияТоваровУслуг.Проведен И НЕ РеализацияТоваровУслуг.НеОтправлятьВБухгалтерию";
	
	Запрос.УстановитьПараметр("ДатаКон", КонецДня(КонПериода));
	Запрос.УстановитьПараметр("ДатаНач", НачалоДня(НачПериода));
	Запрос.УстановитьПараметр("ДоговорКонтрагента", Договор);
	Запрос.УстановитьПараметр("Контрагент", Контрагент);
	Запрос.УстановитьПараметр("Подразделение", ЭлементыФормы.Подразделения.Значение);
	
	
	Запрос.Текст = Запрос.Текст + " И РеализацияТоваровУслуг.Подразделение" + " %ТекстЗамещения% &Подразделение" ;
	Если ВидСравненияПодразделение = ВидСравнения.Равно тогда
		Запрос.Текст = СтрЗаменить(Запрос.Текст,"%ТекстЗамещения%","=");
	ИначеЕсли ВидСравненияПодразделение = ВидСравнения.НеРавно тогда
		Запрос.Текст = СтрЗаменить(Запрос.Текст,"%ТекстЗамещения%","<>");
	ИначеЕсли ВидСравненияПодразделение = ВидСравнения.ВСписке тогда
		Запрос.Текст = СтрЗаменить(Запрос.Текст,"%ТекстЗамещения%","В (");
		Запрос.Текст = Запрос.Текст  + ")"
	ИначеЕсли ВидСравненияПодразделение = ВидСравнения.НеВСписке тогда
		Запрос.Текст = СтрЗаменить(Запрос.Текст,"%ТекстЗамещения%","НЕ В (");		
		Запрос.Текст = Запрос.Текст  + ")"
	КонецЕсли;
	
	
	
	Если ЗначениеЗаполнено(ЭлементыФормы.Комментарий.Значение) тогда
		Запрос.Текст = Запрос.Текст + " И РеализацияТоваровУслуг.Комментарий" + ?(ВидСравненияКомментарий = ВидСравнения.Содержит, " ПОДОБНО "," НЕ ПОДОБНО ")   +"""%" + ЭлементыФормы.Комментарий.Значение+"%"""   ;
	КонецЕсли;
	
	
	Результат = Запрос.Выполнить();
	
	Если не Результат.Пустой() тогда
		
		Если СписокРеализаций.Количество() > 0 тогда
			ТекстВопроса = "Перед заполнением табличная часть будет очищена. Заполнить?";
			Ответ = Вопрос(ТекстВопроса, РежимДиалогаВопрос.ДаНет, , КодВозвратаДиалога.Да, Метаданные().Имя);
			Если Ответ <> КодВозвратаДиалога.Да Тогда
				Возврат;
			КонецЕсли; 
			
			СписокРеализаций.Очистить();		
		КонецЕсли;
		СписокРеализаций.ЗагрузитьЗначения( Результат.Выгрузить().ВыгрузитьКолонку("Ссылка"));
		
		
	КонецЕсли;
	
	
Предупреждение("Найдено "+строка(СписокРеализаций.Количество())+" документов", 30);
	
	
КонецПроцедуры

Процедура ДоговорНачалоВыбора(Элемент, СтандартнаяОбработка)
	
	//СписокВидовДоговоров = Новый СписокЗначений;
	//СписокВидовДоговоров.Добавить(Перечисления.ВидыДоговоровКонтрагентов.СПокупателем);
	//СписокВидовДоговоров.Добавить(Перечисления.ВидыДоговоровКонтрагентов.СКомиссионером);

	НачалоВыбораЗначенияДоговораКонтрагента(ЭтотОбъект, ЭтаФорма, Элемент, Контрагент, Справочники.ДоговорыКонтрагентов.ПустаяСсылка(),
			Неопределено, СтандартнаяОбработка);

КонецПроцедуры

Процедура ПриОткрытии()
	
	
	СписокВыбора  = Новый СписокЗначений;
    СписокВыбора.Добавить(ВидСравнения.Равно);
    СписокВыбора.Добавить(ВидСравнения.НеРавно);
    СписокВыбора.Добавить(ВидСравнения.ВСписке);
    СписокВыбора.Добавить(ВидСравнения.НеВСписке);  
   
	
	ЭлементыФормы.ВидСравненияПодразделение.СписокВыбора = СписокВыбора;
    ЭлементыФормы.ВидСравненияПодразделение.Значение     = ВидСравнения.Равно;
    ЭлементыФормы.Подразделения.ТипЗначения = Новый ОписаниеТипов("СправочникСсылка.Подразделения");
	ЭлементыФормы.Подразделения.Значение = справочники.Подразделения.НайтиПоКоду("00005"); // Ярославль
	
	СписокВыбора1  = Новый СписокЗначений;	 
    СписокВыбора1.Добавить(ВидСравнения.Содержит);
    СписокВыбора1.Добавить(ВидСравнения.НеСодержит);
	
	ЭлементыФормы.ВидСравненияКомментарий.СписокВыбора = СписокВыбора1;
    ЭлементыФормы.ВидСравненияКомментарий.Значение     = ВидСравнения.Содержит;
    ЭлементыФормы.Комментарий.ТипЗначения = Новый ОписаниеТипов("Строка");
	
	//сразу ограничим текущим месяцем
	НачПериода = НачалоМесяца( ТекущаяДата() );
	КонПериода = ТекущаяДата();
	флПоказывать = истина;
	
КонецПроцедуры

Процедура ВидСравненияПодразделениеПриИзменении(Элемент)
	  ПриИзмененииПоляВидаСравнения(ЭтаФорма, Элемент, "Подразделения");
КонецПроцедуры


Процедура ПриИзмененииПоляВидаСравнения(Форма, Элемент, Поле)  Экспорт
    Если Элемент.Значение = ВидСравнения.ВСписке
     ИЛИ Элемент.Значение = ВидСравнения.НеВСписке
     ИЛИ Элемент.Значение = ВидСравнения.ВСпискеПоИерархии
     ИЛИ Элемент.Значение = ВидСравнения.НеВСпискеПоИерархии Тогда
        Значение = Неопределено;
        Если Форма.ЭлементыФормы[Поле].ТипЗначения <> Новый ОписаниеТипов("СписокЗначений")Тогда
            Значение = Форма.ЭлементыФормы[Поле].Значение;
            Форма.ЭлементыФормы[Поле].ТипЗначения = Новый ОписаниеТипов("СписокЗначений");
            Форма.ЭлементыФормы[Поле].ТипЗначенияСписка = Новый ОписаниеТипов("СправочникСсылка."+Поле);
        КонецЕсли;

        Если ЗначениеЗаполнено(Значение) Тогда
            Форма.ЭлементыФормы[Поле].Значение.Добавить(Значение);
        КонецЕсли;

    ИначеЕсли Элемент.Значение = ВидСравнения.Равно
          ИЛИ Элемент.Значение = ВидСравнения.ВИерархии
          ИЛИ Элемент.Значение = ВидСравнения.НеРавно
          ИЛИ Элемент.Значение = ВидСравнения.НеВИерархии
          Тогда
        Значение = Неопределено;
        Если Форма.ЭлементыФормы[Поле].ТипЗначения = Новый ОписаниеТипов("СписокЗначений")Тогда
            Если Форма.ЭлементыФормы[Поле].Значение.Количество()>0 Тогда
                Значение = Форма.ЭлементыФормы[Поле].Значение[0].Значение;
            КонецЕсли;    
            Форма.ЭлементыФормы[Поле].ТипЗначения = Новый ОписаниеТипов("СправочникСсылка."+Поле);
        КонецЕсли;
        
        Если ЗначениеЗаполнено(Значение) Тогда
            Форма.ЭлементыФормы[Поле].Значение = Значение;
        КонецЕсли;
    
    КонецЕсли;
КонецПроцедуры

