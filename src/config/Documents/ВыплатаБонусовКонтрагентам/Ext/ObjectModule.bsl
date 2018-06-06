﻿
Процедура ОбработкаПроведения(Отказ, РежимПроведения)
		
	Если Отказ тогда возврат 
	КонецЕсли;
	
	Если Состояние = Перечисления.СостоянияОбъектов.Отклонен тогда
		СообщитьОбОшибке("Отклоненный документ "+строка(ссылка)+" - не может быть проведен!", Отказ);
		возврат; 
	КонецЕсли;
	
	НачалоВыплаты = ПолучитьНачалоВыплаты();
	Если НачалоПериода < НачалоВыплаты тогда
		СообщитьОбОшибке("Начало выплаты "+строка(НачалоПериода)+" не может быть меньше "+строка(НачалоВыплаты)+" !", Отказ);
		возврат;
	КонецЕсли;	

	//+++ 25.12.2017 ---- контроль уникальности ---------------	
	//нужно "закрывать" Сразу все месяцы
	КолМес = Месяц( НачалоМесяца(КонецПериода)) - Месяц( НачалоМесяца(НачалоПериода) ) + 1;
	
	
	Движения.БонусыКонтрагентов.Записывать = истина;
	
	    стр1 = Движения.БонусыКонтрагентов.Добавить();
		стр1.ВидДвижения = ВидДвиженияНакопления.Расход; // РАСХОД !
		стр1.Регистратор = ссылка;
		стр1.Контрагент  = Контрагент;
		стр1.ОТК = (Бонус=1);
		стр1.Нал = Нал; // 06.02.2018 - для ОТК - всегда ЛОЖЬ!
		стр1.ТипБонуса = ?(Бонус=1, перечисления.ТипыБонусов.ПустаяСсылка(), ТипБонуса);
		стр1.НоменклатурнаяГруппа = НоменклатурнаяГруппа;//+++ 18.01.2018 для ОТК - пустая!
		
	  	стр1.Период   = Дата;   //дата выплаты
		стр1.Значение = ?(Бонус=1, 0, КолМес); //ОТК можно выплачивать до бесконечности... пока не закроют!	
		
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	Бонусы.Очистить();
	
	КонецПериода  = Основание.ДатаПо;
	НачалоПериода = ПолучитьНачалоВыплаты();
	
	Комментарий = ""; //очищаем

	КоличествоФакт = 0;
	Состояние = перечисления.СостоянияОбъектов.ПустаяСсылка();
	Выполнен  = ЛОЖЬ;
КонецПроцедуры

функция ПолучитьНачалоВыплаты() Экспорт
	КолМес = 0;
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Контрагент",Контрагент);
	Запрос.УстановитьПараметр("ОТК", (Бонус=1)  );
	Запрос.УстановитьПараметр("ТипБонуса",ТипБонуса);
	Запрос.УстановитьПараметр("Нал",Нал); //06.02.2018
	Запрос.УстановитьПараметр("НоменклатурнаяГруппа",НоменклатурнаяГруппа);
	Запрос.Текст = "ВЫБРАТЬ
	               |	БонусыКонтрагентовОстатки.ЗначениеОстаток как КолМес
	               |ИЗ
	               |	РегистрНакопления.БонусыКонтрагентов.Остатки(  ,
	               |			Контрагент = &Контрагент
	               |				И ОТК = &ОТК
				   |				И Нал = &Нал
	               |				И ТипБонуса = &ТипБонуса
				   |				И НоменклатурнаяГруппа = &НоменклатурнаяГруппа
				   |) КАК БонусыКонтрагентовОстатки";
	Рез = Запрос.Выполнить().Выбрать();
	
	Если Рез.Следующий() тогда
	КолМес = Рез.КолМес;
	КонецЕсли;

	Если (Бонус=0) тогда
		Если КолМес>=0 тогда
		НачПериода = ДобавитьМесяц(НачалоМесяца(Основание.ДатаПо), - КолМес+1 );
			Если НачПериода<Основание.ДатаС тогда //если несколько одинаковых Установок...
			НачПериода=Основание.ДатаС;
			КонецЕсли;
		Иначе
		НачПериода = КонецДня(Основание.ДатаПо)+1;
		КонецЕсли;
	Иначе //Если (Бонус=1) тогда //ОТК
		Если КолМес>=0 тогда
		НачПериода = НачалоМесяца(Основание.Дата);
	    Иначе//отрицательные значения!
		НачПериода = ДобавитьМесяц( НачалоМесяца( Основание.Дата ),  -КолМес+1 );   //максимально!
		КонецЕсли;
	КонецЕсли;
		
	возврат НачПериода;
КонецФункции

// Процедура осуществляет печать документа. Можно направить печать на 
// экран или принтер, а также распечатать необходмое количество копий.
//
//  Название макета печати передается в качестве параметра,
// по переданному названию находим имя макета в соответствии.
//
// Параметры:
//  НазваниеМакета - строка, название макета.
//
Процедура Печать(ИмяМакета, КоличествоЭкземпляров = 1, НаПринтер = Ложь, Форма = Неопределено) Экспорт

#Если Клиент тогда
	Если ЭтоНовый() Тогда
		Предупреждение("Новый Документ можно распечатать только после его Утверждения!", 30);
		Возврат;
		
	ИначеЕсли Не РазрешитьПечатьНепроведенныхДокументов(Проведен) Тогда
		Предупреждение("Недостаточно полномочий для печати непроведенного документа!", 30);
		Возврат;
		
	КонецЕсли; 

	Если Не ПроверитьМодифицированность(ЭтотОбъект) Тогда
		Предупреждение("Документ изменен. Запишите документ перед печатью...",30);
		Возврат;
	КонецЕсли;

//11.02.2018 ---- сразу на принтер - ничего тут нет ----
		Если РольДоступна("ПолныеПрава")                                    //Бух
		или РольДоступна("яштФинДиректор")                                  //Фин.отдел
		или РольДоступна("ПравоЗавершенияРаботыПользователей")				//IT-отдел
		или параметрыСеанса.ТекущийПользователь = менеджер.НаправлениеПродаж.Руководитель //рукНапр
		или параметрыСеанса.ТекущийПользователь = НоменклатурнаяГруппа.Ответственный 	   //рукТГ
		или параметрыСеанса.ТекущийПользователь.ОсновноеПодразделение.Код = "00012" //Юр.отдел
		тогда
		 	НаПринтер = ЛОЖЬ; //доступен предварительный просмотр
		иначе 
			Если НЕ (состояние = Перечисления.СостоянияОбъектов.Утвержден
				или состояние = Перечисления.СостоянияОбъектов.Согласован
				или состояние = Перечисления.СостоянияОбъектов.Выполнен  ) тогда
				Предупреждение("Нельзя печатать не утвержденный документ!");
				возврат;
			иначе	//сразу на принтер!
				НаПринтер = Истина;
			КонецЕсли;
		КонецЕсли;	
#КонецЕсли


	// Получить экземпляр документа на печать
	Если      ИмяМакета = "Служебка" Тогда
			ТабДокумент = ПечатьСлужебки();
			
	ИначеЕсли  ИмяМакета = "СлужебкаБонус" Тогда //31.01.2018
			ТабДокумент = ПечатьСлужебкиБонус();
			
	ИначеЕсли  ИмяМакета = "Акт" Тогда
			ПечатьАкта();
			возврат;
	//---------------------------------------------------------------		
	ИначеЕсли ТипЗнч(ИмяМакета) = Тип("СправочникСсылка.ДополнительныеПечатныеФормы") Тогда
		
		ИмяФайла = КаталогВременныхФайлов()+"PrnForm.tmp";
		ОбъектВнешнейФормы = ИмяМакета.ПолучитьОбъект();
		Если ОбъектВнешнейФормы = Неопределено Тогда
			Сообщить("Ошибка получения внешней формы документа. Возможно форма была удалена", СтатусСообщения.Важное);
			Возврат;
		КонецЕсли;
		
		ДвоичныеДанные = ОбъектВнешнейФормы.ХранилищеВнешнейОбработки.Получить();
		ДвоичныеДанные.Записать(ИмяФайла);
		Обработка = ВнешниеОбработки.Создать(ИмяФайла);
		Обработка.СсылкаНаОбъект = Ссылка;
		ТабДокумент = Обработка.Печать();
		
	КонецЕсли;

	НапечататьДокумент(ТабДокумент, КоличествоЭкземпляров, НаПринтер, СформироватьЗаголовокДокумента(ЭтотОбъект));

КонецПроцедуры // Печать

функция ПечатьСлужебки()
	ТабДокумент = Новый ТабличныйДокумент;
	ТабДокумент.АвтоМасштаб = Истина;
	Макет = ПолучитьМакет("Служебка");
	ОбластьШапка = Макет.ПолучитьОбласть("Шапка");
	ОбластьШапка.Параметры.контр = Контрагент;
	ОбластьШапка.Параметры.Сумма = Бонусы.Итог("СуммаБонуса");
	ОбластьШапка.Параметры.Дата1 = Формат(НачалоПериода,"ДФ=dd.MM.yyyy");
	ОбластьШапка.Параметры.Дата2 = Формат(КонецПериода,"ДФ=dd.MM.yyyy");
	
	ОбластьШапка.Параметры.ОТК = ?(Бонус=1,"ОТК","Бонус("+строка(ТипБонуса)+")" );
	
	//18.01.2018
	ОбластьШапка.Параметры.Номер = ЭтотОбъект.Номер;
	ОбластьШапка.Параметры.Дата  = формат( ЭтотОбъект.Дата, "ДЛФ=DD");
	
	
	ПодключитьВнешнююКомпоненту("ОбщийМакет.КомпонентаСклоненияФИО", "Decl", ТипВнешнейКомпоненты.Native); 
		Объект = Новый("AddIn.Decl.CNameDecl");
		Попытка
			Наим = ПараметрыСеанса.ТекущийПользователь.Наименование;
			Падеж = 2; //Родительный
			Если СокрЛП(Наим) <> "" Тогда
				Если Найти(Наим,".")=0 Тогда
					РодПадеж = Объект.Просклонять(Наим, Падеж);
				Иначе
					РодПадеж = Наим;
				КонецЕсли;	
			КонецЕсли;
		Исключение
		КонецПопытки;
	ОбластьШапка.Параметры.РодПадеж = РодПадеж;

	
	
	
	ОбластьШапка.Параметры.ПродажиО = Бонусы.Итог("Сумма");
	ОбластьШапка.Параметры.ПрибыльО = Бонусы.Итог("Сумма") - Бонусы.Итог("Себестоимость");
	ОбластьШапка.Параметры.ОТКО = Бонусы.Итог("СуммаБонуса");
	
	ТабДокумент.Вывести(ОбластьШапка);
	
	Бонусы1 = Бонусы.Выгрузить();
	Бонусы1.Свернуть("Производитель,НоменклатурнаяГруппа,ПроцентБонуса,Коэффициент,Статус","Сумма,СуммаОбрПродаж,Себестоимость,СуммаБонуса");
	БЕЗОТК = 0;	
	СуммаИтог=0;СуммаСебестоимость=0;СуммаБонуса=0;//12.01.2018
	Для каждого стр из Бонусы1 Цикл
		
		Если стр.Статус <> Перечисления.СтатусыСтрокЗаказа.Подтвержден
			и стр.Статус <> Перечисления.СтатусыСтрокЗаказа.Согласован тогда 
			Продолжить;
		КонецЕсли;	
		
		Областьстрока = Макет.ПолучитьОбласть("Строка");
		Областьстрока.Параметры.Номенклатура = стр.Производитель;
		Областьстрока.Параметры.НомГруппа = стр.НоменклатурнаяГруппа;
	    Областьстрока.Параметры.Продажи = стр.Сумма - стр.СуммаОбрПродаж;
		Областьстрока.Параметры.БезОТК  = ?(Бонус=0, формат(стр.Сумма - стр.СуммаОбрПродаж - стр.СуммаБонуса,"ЧДЦ=2"),
								Формат((100*стр.Сумма/стр.ПроцентБонуса/стр.Коэффициент-100)/(100/стр.ПроцентБонуса/стр.Коэффициент+1),"ЧДЦ=2") );
		Областьстрока.Параметры.Прибыль = стр.Сумма - стр.Себестоимость - стр.СуммаОбрПродаж;
		Областьстрока.Параметры.ОТК  = стр.СуммаБонуса;
		Областьстрока.Параметры.Проц = стр.ПроцентБонуса;
		Областьстрока.Параметры.К = стр.Коэффициент;
		ТабДокумент.Вывести(ОбластьСтрока);
		
		БЕЗОТК = БЕЗОТК + ?(Бонус=0, стр.Сумма - стр.СуммаОбрПродаж - стр.СуммаБонуса, (100*стр.Сумма/стр.ПроцентБонуса/стр.Коэффициент-100)/(100/стр.ПроцентБонуса/стр.Коэффициент+1) ); 
		СуммаИтог = СуммаИтог+стр.Сумма - стр.СуммаОбрПродаж;
	    СуммаБонуса = СуммаБонуса+стр.СуммаБонуса;
	    СуммаСебестоимость = СуммаСебестоимость+стр.Себестоимость;
	    
	КонецЦикла;
	
	ОбластьстрокаИтог = Макет.ПолучитьОбласть("СтрокаИтог");
	ОбластьстрокаИтог.Параметры.ПродажиИтог = СуммаИтог;
	ОбластьстрокаИтог.Параметры.БезОТКИтог  = Формат(БЕЗОТК,"ЧДЦ=2");
	ОбластьстрокаИтог.Параметры.ПрибыльИтог = СуммаИтог - СуммаСебестоимость;
	ОбластьстрокаИтог.Параметры.СуммаИтог   = СуммаБонуса;
	ТабДокумент.Вывести(ОбластьстрокаИтог);
	
	Областьподвал = Макет.ПолучитьОбласть("Подвал");
	Областьподвал.Параметры.Менеджер = ЭтотОбъект.Менеджер;
	ТабДокумент.Вывести(Областьподвал);

возврат ТабДокумент;                         
КонецФункции

//31.01.2018
функция ПечатьСлужебкиБонус()
	ТабДокумент = Новый ТабличныйДокумент;
	ТабДокумент.АвтоМасштаб = Истина;
	Макет = ПолучитьМакет("СлужебкаБонус");
	ОбластьШапка = Макет.ПолучитьОбласть("Шапка");
	
	таблДог = получитьДоговорыБонуса(Контрагент);
	ДоговорыБонуса=""; масДог1="";
	для i=0 по таблДог.Количество()-1 цикл
		ДоговорыБонуса=ДоговорыБонуса+таблДог[i].Наименование+", ";
	КонецЦикла;
    ОбластьШапка.Параметры.ДоговорыБонуса = лев(ДоговорыБонуса, стрДлина(ДоговорыБонуса)-2);
	
		
	Если таблДог.Количество()>0 тогда
	ОбластьШапка.Параметры.НомерДоговора = ?(СокрЛП(таблДог[0].Номер)="", "№______", СокрЛП(таблДог[0].Номер));
	ОбластьШапка.Параметры.ДатаДоговора  =  ?(таблДог[0].Дата='00010101',"«___»________20__г.",формат( таблДог[0].Дата, "ДФ='«dd» MMMM yyyy'")+"г.");
    Иначе
	ОбластьШапка.Параметры.НомерДоговора = "№______";
	ОбластьШапка.Параметры.ДатаДоговора  = "«___»________20__г.";
	КонецЕсли;
	
	ОбластьШапка.Параметры.ТипБонуса = строка(ЭтотОбъект.ТипБонуса);
	
	ОбластьШапка.Параметры.контр   = Контрагент.НаименованиеПолное+" (ИНН "+Контрагент.ИНН+")";
	//ОбластьШапка.Параметры.Дата10 = Формат(Основание.ДатаС,  "ДФ='""dd"" MMMM yyyy'")+"г.";
	//ОбластьШапка.Параметры.Дата20 = Формат(Основание.ДатаПо, "ДФ='""dd"" MMMM yyyy'")+"г.";
	
	ОбластьШапка.Параметры.Дата1 = Формат(НачалоПериода,"ДФ='«dd» MMMM yyyy'")+"г.";
	ОбластьШапка.Параметры.Дата2 = Формат(КонецПериода, "ДФ='«dd» MMMM yyyy'")+"г.";
	
	ОбластьШапка.Параметры.Номер =СокрЛП(ЭтотОбъект.Номер);
	ОбластьШапка.Параметры.Дата  =формат( ЭтотОбъект.Дата, "ДФ='«dd» MMMM yyyy'")+"г.";
	
	ТаблБонусы = Бонусы.Выгрузить();
	i=0;
	пока i<таблБонусы.Количество() цикл
		Если таблБонусы[i].Статус = перечисления.СтатусыСтрокЗаказа.Отменен тогда
			таблБонусы.Удалить(i);
		иначе  i = i+1;
		КонецЕсли;	
	КонецЦикла;
		
	ОбластьШапка.Параметры.СписПроизводителей = ПолучитьСписПроизводителей(ТаблБонусы);	
	Если (таблБонусы.Итог("Сумма") - таблБонусы.Итог("СуммаОбрПродаж"))=0 
		тогда Процент1 = 0
		иначе Процент1 = Окр( 100 * таблБонусы.Итог("СуммаБонуса") / (таблБонусы.Итог("Сумма") - таблБонусы.Итог("СуммаОбрПродаж")), 2);
	КонецЕсли;
	ОбластьШапка.Параметры.Процент = строка(Процент1);

		
//----------------фио в родительном падеже---------------------------------------------------------------------	
	ПодключитьВнешнююКомпоненту("ОбщийМакет.КомпонентаСклоненияФИО", "Decl", ТипВнешнейКомпоненты.Native); 
		Объект = Новый("AddIn.Decl.CNameDecl");
		Попытка
			Наим = Менеджер.ФизЛицо.Наименование;
			Падеж = 2; //Родительный
			Если СокрЛП(Наим) <> "" Тогда
				Если Найти(Наим,".")=0 Тогда
					РодПадеж = Объект.Просклонять(Наим, Падеж);
				Иначе
					РодПадеж = Наим;
				КонецЕсли;	
			КонецЕсли;
		Исключение
		КонецПопытки;
	ОбластьШапка.Параметры.РодПадеж = РодПадеж;

	
	ТабДокумент.Вывести(ОбластьШапка);
	
	СуммаИтог=0;
	СуммаСНДС = 0;	
	СуммаБонуса=0;//12.01.2018
	//СуммаСебестоимость = 0;
	Для каждого стр из ТаблБонусы Цикл
		
		Если стр.Статус <> Перечисления.СтатусыСтрокЗаказа.Подтвержден
			и стр.Статус <> Перечисления.СтатусыСтрокЗаказа.Согласован тогда 
			Продолжить;
		КонецЕсли;	
		
		Областьстрока = Макет.ПолучитьОбласть("Строка");
		Областьстрока.Параметры.Производитель = "«"+стр.Производитель+"»";
		//ЕДИНАЯ для всех! Областьстрока.Параметры.НомГруппа = стр.НоменклатурнаяГруппа;
	    Областьстрока.Параметры.Сумма      = стр.Сумма - стр.СуммаОбрПродаж;
		Областьстрока.Параметры.СуммаСНДС    = Окр( (стр.Сумма - стр.СуммаОбрПродаж)*1.18 );
		Областьстрока.Параметры.СуммаБонуса  = стр.СуммаБонуса;
		//Областьстрока.Параметры.Себестоимость  = стр.Себестоимость;
		
		Областьстрока.Параметры.Проц         = строка(стр.ПроцентБонуса)+"%";
		ТабДокумент.Вывести(ОбластьСтрока);
		
		СуммаИтог = СуммаИтог   +стр.Сумма - стр.СуммаОбрПродаж;
		СуммаСНДС = СуммаСНДС	+Окр( (стр.Сумма - стр.СуммаОбрПродаж)*1.18 );
	    СуммаБонуса = СуммаБонуса+стр.СуммаБонуса;
	   // СуммаСебестоимость = СуммаСебестоимость+стр.Себестоимость;
	    
	КонецЦикла;
	
	ОбластьстрокаИтог = Макет.ПолучитьОбласть("СтрокаИтог");
	ОбластьстрокаИтог.Параметры.Сумма	    = СуммаИтог;
	ОбластьстрокаИтог.Параметры.СуммаСНДС   = СуммаСНДС;
	
	ОбластьстрокаИтог.Параметры.СуммаБонуса = Окр(СуммаБонуса);  // ОКРУГЛЯЕМ!
	
//	ОбластьстрокаИтог.Параметры.Себестоимость = СуммаСебестоимость;
	Если СуммаИтог=0 тогда проц = 0
	иначе  проц = Окр(100*СуммаБонуса/СуммаИтог,2);
	КонецЕсли;
	ОбластьстрокаИтог.Параметры.проц = строка( проц ) +"%";
	ТабДокумент.Вывести(ОбластьстрокаИтог);
	
	Областьподвал = Макет.ПолучитьОбласть("Подвал");
	Областьподвал.Параметры.РукНапрПрод = Менеджер.НаправлениеПродаж.Руководитель.ФизЛицо.Наименование;
	Областьподвал.Параметры.РукТГ       = НоменклатурнаяГруппа.Ответственный.ФизЛицо.Наименование;
	Областьподвал.Параметры.ГлавБух     = Справочники.Пользователи.НайтиПоКоду("Яковлева");
	Областьподвал.Параметры.Менеджер    = Менеджер.ФизЛицо.Наименование + ПолучитьВнТел(Менеджер);
	ТабДокумент.Вывести(Областьподвал);

возврат ТабДокумент;                         
КонецФункции

функция ПолучитьВнТел(Сотрудник)
	рез = "";
	
	Если НЕ Сотрудник.ФизЛицо.Пустая() тогда
	  стрОтбора = Новый Структура("Объект,",Сотрудник.ФизЛицо);
	  стрОтбора.Вставить("Тип", перечисления.ТипыКонтактнойИнформации.Телефон);
	  стрОтбора.Вставить("Вид", справочники.ВидыКонтактнойИнформации.НайтиПоКоду("38840") );  //вн.номер физ.лица
	иначе
	  стрОтбора = Новый Структура("Объект,",Сотрудник);
	  стрОтбора.Вставить("Тип", перечисления.ТипыКонтактнойИнформации.Телефон);
	  стрОтбора.Вставить("Вид", справочники.ВидыКонтактнойИнформации.НайтиПоКоду("38841") );  //вн.номер  сотрудника
	КонецЕсли;
	
	регСв = РегистрыСведений.КонтактнаяИнформация.Получить(стрОтбора);
	  
	Если регСв <> неопределено тогда
	  рез = ", доб. "+регСв.Представление;
  	КонецЕсли;	  
  
	возврат рез;
КонецФункции
 
функция получитьДоговорыБонуса(контр)
	
	 Запрос = Новый Запрос;
	 Запрос.Текст = "ВЫБРАТЬ РАЗЛИЧНЫЕ
	                |	ДоговорыКонтрагентов.Наименование КАК Наименование,
	                |	ДоговорыКонтрагентов.Номер,
	                |	ДоговорыКонтрагентов.Дата
	                |ИЗ
	                |	Справочник.ДоговорыКонтрагентов КАК ДоговорыКонтрагентов
	                |ГДЕ
	                |	ДоговорыКонтрагентов.Владелец = &Владелец
	                |	И ДоговорыКонтрагентов.Наименование ПОДОБНО &Наименование
	                |	И ДоговорыКонтрагентов.ПометкаУдаления = ЛОЖЬ
	                |	И ДоговорыКонтрагентов.ВидДоговора = ЗНАЧЕНИЕ(Перечисление.ВидыДоговоровКонтрагентов.СПокупателем)
	                |	И (ДоговорыКонтрагентов.ДатаОкончанияДействия = &ПустаяДата
	                |		ИЛИ ДоговорыКонтрагентов.ДатаОкончанияДействия >= &ТекДата)
	                |
	                |УПОРЯДОЧИТЬ ПО
	                |	ДоговорыКонтрагентов.Дата УБЫВ";
	 Запрос.УстановитьПараметр("Владелец", контр);
	 Запрос.УстановитьПараметр("ПустаяДата", '00010101');
	 Запрос.УстановитьПараметр("ТекДата", НачалоДня(ЭтотОбъект.Дата) );
	 Запрос.УстановитьПараметр("Наименование", "%*%");
	 
	 Результат = Запрос.Выполнить();
	 табл = Результат.Выгрузить();
	 
	 возврат табл;
	 
КонецФункции	

функция ПолучитьСписПроизводителей(ТаблБонусы)
	
	НомГрб =ТаблБонусы.Скопировать();//+++ 20.12.2017 - только не отмененные
	НомГрб.Свернуть("НоменклатурнаяГруппа");

	ПроизводителиСтрока = "";
		для каждого стрНГ Из НомГрб Цикл
			
			если ПроизводителиСтрока <> "" Тогда
				ПроизводителиСтрока = ПроизводителиСтрока + ", ";
			КонецЕсли;
			
			Если стрНГ.НоменклатурнаяГруппа = Справочники.НоменклатурныеГруппы.НайтиПоКоду("00026") Тогда
				
				ПроизводителиСтрока = ПроизводителиСтрока + "литых дисков под торговыми марками ";
				
			ИначеЕсли стрНГ.НоменклатурнаяГруппа = Справочники.НоменклатурныеГруппы.НайтиПоКоду("00049") Тогда
				
				ПроизводителиСтрока = ПроизводителиСтрока + "штампованных дисков под торговыми марками ";
				
			ИначеЕсли найти(стрНГ.НоменклатурнаяГруппа.Наименование,"лет") > 0  
				и стрНГ.НоменклатурнаяГруппа.ВидТовара = перечисления.ВидыТоваров.Шины Тогда
				
				ПроизводителиСтрока = ПроизводителиСтрока + "летних шин под торговыми марками ";
				
			ИначеЕсли найти(стрНГ.НоменклатурнаяГруппа.Наименование,"зим") > 0
				и стрНГ.НоменклатурнаяГруппа.ВидТовара = перечисления.ВидыТоваров.Шины Тогда
				
				ПроизводителиСтрока = ПроизводителиСтрока + "зимних шин под торговыми марками ";
				
			иначе
				
				ПроизводителиСтрока = ПроизводителиСтрока + СТРОКА(стрНГ.НоменклатурнаяГруппа)+" под торговыми марками ";   //+++ 19.01.201888
						
			КонецЕсли;
			
			Производителитаб = ТаблБонусы.Скопировать();//+++ 20.12.2017 - только не отмененные
			Производителитаб.Свернуть("НоменклатурнаяГруппа,Производитель");
			ПроизводителиСтрокаПр = "";
			
			отбор = Новый Структура;
			отбор.Вставить("НоменклатурнаяГруппа",стрНГ.НоменклатурнаяГруппа);
			
			произОтбор = Производителитаб.НайтиСтроки(отбор);
			
			Для каждого стр из произОтбор Цикл
				//+++( 14.12.2017
				ПроизводительНаименование = стр.Производитель.Наименование;  
				Если ПроизводительНаименование="REPLICA" тогда 
					ПроизводительНаименование="LegeArtis";
				ИначеЕсли ПроизводительНаименование="REPLICA TD" тогда 
					ПроизводительНаименование="Top Driver";
				ИначеЕсли ПроизводительНаименование="REPLICA TD Special Series" тогда
					ПроизводительНаименование="Top Driver Special Series";
				КонецЕсли;	
				//+++)
				ПроизводителиСтрокаПр = ПроизводителиСтрокаПр +""""+ПроизводительНаименование +""""+ ", "; // +""""+
			КонецЦикла;
			с = СтрДлина(ПроизводителиСтрокаПр);
			ПроизводителиСтрокаПр = Сред(ПроизводителиСтрокаПр,1,с-2);
			
			ПроизводителиСтрока = ПроизводителиСтрока + ПроизводителиСтрокаПр;
				
		КонецЦикла;
		
	возврат ПроизводителиСтрока;
КонецФункции	





Процедура ПечатьАкта()
	Документ = ПолучитьМакет("МакетАкт");
	НаимПокупателя				 = "";
		
	МСВорд = Документ.Получить();
	
	Попытка
		
		Документ = МСВорд.Application.Documents(1);
		Документ.Activate();
		
		Замена = Документ.Content.Find;
		Замена.Execute("[Дата]", Ложь, Истина, Ложь,,,Истина,,Ложь,Формат(Дата,"ДФ=dd.MM.yyyy"),2);
		//ДатаДоговора = Формат(Договор.Дата,"ДФ='dd MMMM yyyy'")+" г.";
		Замена = Документ.Content.Find;
		Замена.Execute("[Период]", Ложь, Истина, Ложь,,,Истина,,Ложь,Строка(Формат(НачалоПериода,"ДФ=dd.MM.yyyy"))+" по "+Строка(Формат(КонецПериода,"ДФ=dd.MM.yyyy")),2);
		
		//Плотников+++
		
		ТекПокупатель = Контрагент;
		
   Если ТекПокупатель.ЮрФизЛицо = Перечисления.ЮрФизЛицо.ЮрЛицо Тогда
			
		НаимПокупателя = СокрЛП(ТекПокупатель.НаименованиеПолное);
		
		Если Найти(НаимПокупателя,"Общество") = 0 Тогда
			Если Найти(НаимПокупателя,"ООО") > 0 Тогда
				НаимПокупателя = СтрЗаменить(НаимПокупателя,"ООО","Общество с ограниченной ответственностью");
			Иначе
		        НаимПокупателя = "Общество с ограниченной ответственностью " + НаимПокупателя;
			КонецЕсли;
		КонецЕсли;
		
		НаимКороткое = НаимПокупателя;
		
		СтруктураКонтЛица = КонтактныеЛицаКонтрагента(ТекПокупатель);
		
		Подписант = "Директор "+ СтруктураКонтЛица.НаимДиректора;
		
		НаимПокупателя = НаимПокупателя +", именуемое далее «Покупатель»,
		|в лице (генерального) директора "+ СтруктураКонтЛица.НаимДиректораРодПадеж  +", действующего на основании  Устава";
			   
	Иначе
		
		НаимПокупателя = СокрЛП(ТекПокупатель.НаименованиеПолное);
		
		Если Найти(НаимПокупателя,"Индивидуальный") = 0 Тогда
			Если Найти(НаимПокупателя,"ИП") > 0 Тогда
				НаимПокупателя = СтрЗаменить(НаимПокупателя,"ИП","Индивидуальный предприниматель");
			Иначе
		        НаимПокупателя = "Индивидуальный предприниматель " + НаимПокупателя;
			КонецЕсли;
		КонецЕсли;
		
		НаимКороткое = НаимПокупателя;
		
		Подписант = НаимПокупателя;
		
		СтруктураКонтЛица = КонтактныеЛицаКонтрагента(ТекПокупатель);
		
		НаимПокупателя = НаимПокупателя +", именуемый далее «Покупатель»,
		|в лице "+ СтруктураКонтЛица.НаимДиректораРодПадеж  +", действующий на основании свидетельства ОГРН " + ТекПокупатель.ОГРН;
	КонецЕсли;
	
	Замена = Документ.Content.Find;
	Замена.Execute("[НаимКороткое]", Ложь, Истина, Ложь,,,Истина,,Ложь,НаимКороткое,2);
	
	Замена = Документ.Content.Find;
	Замена.Execute("[НаимПокупателя]", Ложь, Истина, Ложь,,,Истина,,Ложь,НаимПокупателя,2);
	
	Замена = Документ.Content.Find;
	Замена.Execute("[Подписант]", Ложь, Истина, Ложь,,,Истина,,Ложь,Подписант);
	
	
	Если ТекПокупатель.ЮрФизЛицо = Перечисления.ЮрФизЛицо.ЮрЛицо Тогда
			
		НаимПокупателя = СокрЛП(ТекПокупатель.НаименованиеПолное);
		
		Если Найти(НаимПокупателя,"Общество") = 0 Тогда
			Если Найти(НаимПокупателя,"ООО") > 0 Тогда
				НаимПокупателя = СтрЗаменить(НаимПокупателя,"ООО","Общество с ограниченной ответственностью");
			Иначе
		        НаимПокупателя = "Общество с ограниченной ответственностью " + НаимПокупателя;
			КонецЕсли;
		КонецЕсли;
		
		СтруктураКонтЛица = КонтактныеЛицаКонтрагента(ТекПокупатель);
		
		Доверенность = НаимПокупателя + ", ИНН "+ТекПокупатель.ИНН+", ОГРН "+ТекПокупатель.ОГРН+" (далее – Доверитель),
		|в лице "+ СтруктураКонтЛица.НаимДиректораРодПадеж +", действующего на основании устава";
			   
	Иначе
		
		НаимПокупателя = СокрЛП(ТекПокупатель.НаименованиеПолное);
		
		Если Найти(НаимПокупателя,"Индивидуальный") = 0 Тогда
			Если Найти(НаимПокупателя,"ИП") > 0 Тогда
				НаимПокупателя = СтрЗаменить(НаимПокупателя,"ИП","Индивидуальный предприниматель");
			Иначе
		        НаимПокупателя = "Индивидуальный предприниматель " + НаимПокупателя;
			КонецЕсли;
		КонецЕсли;
		
		СтруктураКонтЛица = КонтактныеЛицаКонтрагента(ТекПокупатель);
		
		Доверенность = НаимПокупателя + ", ИНН "+ТекПокупатель.ИНН+" (далее – Доверитель),
		|в лице "+ СтруктураКонтЛица.НаимДиректораРодПадеж +", действующий на основании свидетельства ОГРН " + ТекПокупатель.ОГРН;
	КонецЕсли;
		
	//+++
	
		
		
		Замена = Документ.Content.Find;
		Замена.Execute("[Доверенность]", Ложь, Истина, Ложь,,,Истина,,Ложь,Доверенность,2);
		
		Производителитаб = Бонусы.Выгрузить();
		Производителитаб.Свернуть("Производитель");
		ПроизводителиСтрока = """";
		Для каждого стр из Производителитаб Цикл
			ПроизводителиСтрока = ПроизводителиСтрока + стр.Производитель.Наименование + ", "
		КонецЦикла;
		с = СтрДлина(ПроизводителиСтрока);
		ПроизводителиСтрока = Сред(ПроизводителиСтрока,1,с-2);
		ПроизводителиСтрока = ПроизводителиСтрока + """";
		Замена = Документ.Content.Find;
		Замена.Execute("[Производители]", Ложь, Истина, Ложь,,,Истина,,Ложь,ПроизводителиСтрока,2);
		
		Замена = Документ.Content.Find;
		Замена.Execute("[Сумма]", Ложь, Истина, Ложь,,,Истина,,Ложь,Строка(Формат(Бонусы.Итог("Сумма"),"ЧДЦ=2")),2);
		
		Замена = Документ.Content.Find;
		Замена.Execute("[СуммаБонуса]", Ложь, Истина, Ложь,,,Истина,,Ложь,Строка(Формат(Бонусы.Итог("СуммаБонуса"),"ЧДЦ=2")),2);
		
		Замена = Документ.Content.Find;
		Замена.Execute("[Процент]", Ложь, Истина, Ложь,,,Истина,,Ложь,Строка(Бонусы[0].ПроцентБонуса),2);
		
		Замена = Документ.Content.Find;
		Замена.Execute("[СуммаБезНДС]", Ложь, Истина, Ложь,,,Истина,,Ложь,Строка(Формат(Бонусы.Итог("Сумма")-Бонусы.Итог("Сумма")*0.18,"ЧДЦ=2")),2);
		
				
		СведенияОПокупателе = СведенияОЮрФизЛице(ТекПокупатель, ТекущаяДата());
		
		Запрос = Новый Запрос;
		запрос.УстановитьПараметр("Об",ТекПокупатель);
		запрос.УстановитьПараметр("Тип",Перечисления.ТипыКонтактнойИнформации.Адрес);
		запрос.УстановитьПараметр("Вид",Справочники.ВидыКонтактнойИнформации.НайтиПоКоду("00015"));
		Запрос.Текст = "ВЫБРАТЬ
		               |	КонтактнаяИнформация.Представление
		               |ИЗ
		               |	РегистрСведений.КонтактнаяИнформация КАК КонтактнаяИнформация
		               |ГДЕ
		               |	КонтактнаяИнформация.Объект = &Об
		               |	И КонтактнаяИнформация.Тип = &Тип
		               |	И КонтактнаяИнформация.Вид = &Вид";
		Результат = Запрос.Выполнить().Выгрузить();
		Если Результат.Количество() > 0 Тогда
			ПочтовыйАдрес = Результат[0].Представление;
		Иначе
			ПочтовыйАдрес = СведенияОПокупателе.ФактическийАдрес;
		КонецЕсли;
		
		ЮрАдресПокупателя = СведенияОПокупателе.ЮридическийАдрес;
		Замена = Документ.Content.Find;
		Замена.Execute("[ЮрАдресПокупателя]", Ложь, Истина, Ложь,,,Истина,,Ложь,ЮрАдресПокупателя);
		
		
		Замена = Документ.Content.Find;
		Замена.Execute("[ФактАдресПокупателя]", Ложь, Истина, Ложь,,,Истина,,Ложь,ПочтовыйАдрес);
		
		Если ТекПокупатель.ЮрФизЛицо = Перечисления.ЮрФизЛицо.ФизЛицо Тогда
			КППпокупателя = "ОГРН: "+Строка(ТекПокупатель.ОГРН);
		Иначе	
		    КППпокупателя = "КПП: "+СведенияОПокупателе.КПП;
		КонецЕсли;

		ИННпокупателя = СведенияОПокупателе.ИНН;
		Замена = Документ.Content.Find;
		Замена.Execute("[ИННпокупателя]", Ложь, Истина, Ложь,,,Истина,,Ложь,ИННпокупателя,2);
	    		
		//КППпокупателя = СведенияОПокупателе.КПП;
		Замена = Документ.Content.Find;
		Замена.Execute("[КППпокупателя]", Ложь, Истина, Ложь,,,Истина,,Ложь,КППпокупателя,2);
		
		ОГРНпокупателя = СведенияОПокупателе.ОГРН;
		Замена = Документ.Content.Find;
		Замена.Execute("[ОГРНпокупателя]", Ложь, Истина, Ложь,,,Истина,,Ложь,ОГРНпокупателя,2);

        ТелефонПокупателя = СведенияОПокупателе.Телефоны;
		Замена = Документ.Content.Find;
		Замена.Execute("[ТелефонПокупателя]", Ложь, Истина, Ложь,,,Истина,,Ложь,ТелефонПокупателя);
		
		БанковскийСчетПокупателя = ТекПокупатель.ОсновнойБанковскийСчет;
		БанкПокупателяНаим = "";
		БанкПокупателяОКПО = "";
		БанкПокупателяБИК = "";
		БанкПокупателяАдрес = "";
		БанкПокупателяРасчетныйСчет = "";
		БанкПокупателяКоррСчет = "";

		Если ЗначениеЗаполнено(БанковскийСчетПокупателя) Тогда
			Банк = БанковскийСчетПокупателя.Банк;
			БанкПокупателяНаим = СокрЛП(Банк)+" "+Банк.Город;
			БанкПокупателяБИК = Банк.Код;
            БанкПокупателяАдрес = Банк.Адрес;
			БанкПокупателяРасчетныйСчет = БанковскийСчетПокупателя.НомерСчета;
			БанкПокупателяКоррСчет = БанковскийСчетПокупателя.Банк.КоррСчет;
		КонецЕсли;
		Замена = Документ.Content.Find;
		Замена.Execute("[БанкПокупателяНаим]", Ложь, Истина, Ложь,,,Истина,,Ложь,БанкПокупателяНаим);
		Замена = Документ.Content.Find;
		Замена.Execute("[БанкПокупателяОКПО]", Ложь, Истина, Ложь,,,Истина,,Ложь,БанкПокупателяОКПО);
		Замена = Документ.Content.Find;
		Замена.Execute("[БанкПокупателяБИК]", Ложь, Истина, Ложь,,,Истина,,Ложь,БанкПокупателяБИК);
		Замена = Документ.Content.Find;
		Замена.Execute("[БанкПокупателяАдрес]", Ложь, Истина, Ложь,,,Истина,,Ложь,БанкПокупателяАдрес);
		Замена = Документ.Content.Find;
		Замена.Execute("[БанкПокупателяРасчетныйСчет]", Ложь, Истина, Ложь,,,Истина,,Ложь,БанкПокупателяРасчетныйСчет);
		Замена = Документ.Content.Find;
		Замена.Execute("[БанкПокупателяКоррСчет]", Ложь, Истина, Ложь,,,Истина,,Ложь,БанкПокупателяКоррСчет);
		
		//Паспорт только если Физ. лицо, например ИП-шник
		//Если ТекПокупатель.ЮрФизЛицо = Перечисления.ЮрФизЛицо.ФизЛицо И СокрЛП(ТекПокупатель.ДокументУдостоверяющийЛичность)<>"" Тогда
		//	ПаспортПокупателя = Символы.ВК+Символы.ПС+СокрЛП(ТекПокупатель.ДокументУдостоверяющийЛичность);
		//Иначе
		//	ПаспортПокупателя = "";
		//КонецЕсли;
		//Замена = Документ.Content.Find;
		//Замена.Execute("[ПаспортПокупателя]", Ложь, Истина, Ложь,,,Истина,,Ложь,ПаспортПокупателя);
		
		МСВорд.Application.Visible = 1;
		Документ.Activate();
		МСВорд.ActiveWindow.WindowState = 2;
		МСВорд.ActiveWindow.WindowState = 1;
		
	Исключение
		Сообщить(ОписаниеОшибки());
		МСВорд.Application.Quit();
	КонецПопытки;	

КонецПроцедуры

Функция КонтактныеЛицаКонтрагента(ТекКонтрагент)
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	 "ВЫБРАТЬ
	 |	КонтактныеЛица.Фамилия,
	 |	КонтактныеЛица.Имя,
	 |	КонтактныеЛица.Отчество,
	 |	КонтактныеЛица.Должность,
	 |	КонтактныеЛица.Представление,
	 |	КонтактныеЛица.Роль,
	 |	ВЫБОР
	 |		КОГДА КонтактныеЛица.Роль = &Директор
	 |			ТОГДА 1
	 |		КОГДА КонтактныеЛица.Ссылка = &ОсновноеКонтЛицо
	 |			ТОГДА 2
	 |		ИНАЧЕ 3
	 |	КОНЕЦ КАК Порядок,
	 |	КонтактныеЛица.Описание
	 |ИЗ
	 |	Справочник.КонтактныеЛица КАК КонтактныеЛица
	 |ГДЕ
	 |	КонтактныеЛица.ОбъектВладелец = &ТекКонтрагент
	 |	И КонтактныеЛица.ВидКонтактногоЛица = &ВидКонтактногоЛица
	 |	И КонтактныеЛица.ПометкаУдаления = ЛОЖЬ
	 |
	 |УПОРЯДОЧИТЬ ПО
	 |	Порядок";
	 
	Запрос.УстановитьПараметр("ТекКонтрагент", ТекКонтрагент);
	Запрос.УстановитьПараметр("ВидКонтактногоЛица", Перечисления.ВидыКонтактныхЛиц.КонтактноеЛицоКонтрагента);
	//Запрос.УстановитьПараметр("ГенДиректор", Справочники.РолиКонтактныхЛиц.ГенеральныйДиректор);
	Запрос.УстановитьПараметр("Директор", Справочники.РолиКонтактныхЛиц.Директор);
	Запрос.УстановитьПараметр("ОсновноеКонтЛицо", ТекКонтрагент.ОсновноеКонтактноеЛицо);
	ДолжностьДиректора = "";
	ДолжностьДиректораРодПадеж = "";
	НаимДиректора = "";
	НаимДиректораКраткое = "";
	НаимДиректораРодПадеж = "";
	ДействующийНаОсновании = "";

	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		Если СокрЛП(Выборка.Представление) = "" И СокрЛП(Выборка.Фамилия) = "" И СокрЛП(Выборка.Имя) = "" И СокрЛП(Выборка.Отчество) = "" Тогда
			продолжить;
		КонецЕсли;
		Если СокрЛП(Выборка.Представление) <> "" Тогда
			НаимДиректора = СокрЛП(Выборка.Представление); 
		Иначе
			НаимДиректора = СокрЛП(Выборка.Фамилия)+" "+СокрЛП(Выборка.Имя)+" "+СокрЛП(Выборка.Отчество);
		КонецЕсли;
		ДолжностьДиректора = ?(СокрЛП(Выборка.Должность)="",СокрЛП(Выборка.Роль),СокрЛП(Выборка.Должность));
		ДействующийНаОсновании = СокрЛП(Выборка.Описание);
		прервать;
	КонецЦикла;
	Если Найти(НаимДиректора,".")=0 Тогда
		НаимДиректораКраткое = ФамилияИнициалыФизЛица(НаимДиректора);
	Иначе
		НаимДиректораКраткое = НаимДиректора;
	КонецЕсли;
	
	Попытка
		ПодключитьВнешнююКомпоненту("ОбщийМакет.КомпонентаСклоненияФИО", "Decl", ТипВнешнейКомпоненты.Native); 
		Объект = Новый("AddIn.Decl.CNameDecl");
		Попытка
			Падеж = 2; //Родительный
			Если СокрЛП(НаимДиректора) <> "" Тогда
				Если Найти(НаимДиректора,".")=0 Тогда
					НаимДиректораРодПадеж = Объект.Просклонять(НаимДиректора, Падеж);
				Иначе
					НаимДиректораРодПадеж = НаимДиректора;
				КонецЕсли;	
			КонецЕсли;
			Если СокрЛП(ДолжностьДиректора)<>"" Тогда
				МассивСтрок = РазложитьСтрокуВМассивПодстрок(ДолжностьДиректора, " ");
				//Выделим первые 3 слова, так как компонента не умеет склонять фразу большую 3х символов
				НомерНесклоняемогоСимвола = 4;
				Для Номер = 1 По Мин(МассивСтрок.Количество(), 3) Цикл
					Попытка
						Рез = Объект.Просклонять(МассивСтрок[Номер-1], Падеж);
					Исключение
						Рез = МассивСтрок[Номер-1];
					КонецПопытки;
					ДолжностьДиректораРодПадеж = ДолжностьДиректораРодПадеж + ?(Номер > 1, " ", "") + Рез;
				КонецЦикла;
			КонецЕсли;
		Исключение
			Сообщить("Не просклонять ФИО/должность покупателя "+НаимДиректора+" / "+ДолжностьДиректора);
		КонецПопытки;
	Исключение
		Сообщить("Не удалось подключить внешнюю компоненту по причине: " + ОписаниеОшибки()); 
	КонецПопытки;
	
	СтруктураКонтЛица = Новый Структура;
	СтруктураКонтЛица.Вставить("НаимДиректора", НаимДиректора);
	СтруктураКонтЛица.Вставить("НаимДиректораРодПадеж", ?(СокрЛП(НаимДиректораРодПадеж)="",НаимДиректора,НаимДиректораРодПадеж));
	СтруктураКонтЛица.Вставить("НаимДиректораКраткое", НаимДиректораКраткое);
	СтруктураКонтЛица.Вставить("ДолжностьДиректора", ДолжностьДиректора);
	СтруктураКонтЛица.Вставить("ДолжностьДиректораРодПадеж", ?(СокрЛП(ДолжностьДиректораРодПадеж)="",ДолжностьДиректора,ДолжностьДиректораРодПадеж));
	СтруктураКонтЛица.Вставить("ДействующийНаОсновании", СтрЗаменить(ДействующийНаОсновании,"Действующий на основании",""));

	
    возврат СтруктураКонтЛица;
	
КонецФункции	



Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	//{{__КОНСТРУКТОР_ВВОД_НА_ОСНОВАНИИ
	// Данный фрагмент построен конструктором.
	// При повторном использовании конструктора, внесенные вручную изменения будут утеряны!!!
	Если ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.УстановкаБонусов") Тогда
		// Заполнение шапки
		Бонус = ДанныеЗаполнения.Бонус;
		КонецПериода  = ДанныеЗаполнения.ДатаПо;
		НачалоПериода = ДанныеЗаполнения.ДатаС;
		Контрагент    = ДанныеЗаполнения.Контрагент;
		Менеджер  = ДанныеЗаполнения.Ответственный;
		
		Основание = ДанныеЗаполнения.Ссылка;
		
		КоличествоПлан = Основание.КоличествоПлан;
		ТипБонуса      = Основание.ТипБонуса;
		НоменклатурнаяГруппа = Основание.НоменклатурнаяГруппа;
		Нал 		   = Основание.Нал;
		
		Комментарий = Основание.Комментарий;

	КонецЕсли;
	//}}__КОНСТРУКТОР_ВВОД_НА_ОСНОВАНИИ
КонецПроцедуры
