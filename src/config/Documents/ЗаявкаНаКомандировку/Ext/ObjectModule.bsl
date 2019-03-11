﻿
Процедура ПриКопировании(ОбъектКопирования)

	Если НЕ ЗначениеНеЗаполнено(Состояние) Тогда
	Состояние = перечисления.СостоянияОбъектов.ПустаяСсылка();
	КонецЕсли;
	
	Ответственный = глТекущийПользователь;
	НомерКомандировки = "";
	ДатаКомандировки  = '00010101';
	
	Утвердил   = справочники.Пользователи.ПустаяСсылка();
	Согласовал = справочники.Пользователи.ПустаяСсылка();
	
КонецПроцедуры


функция ПечатьЗаписка()
	
	ТабДокумент = Новый ТабличныйДокумент;
	ТабДокумент.ИмяПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_ЗаявкаНаКомандировку_Записка";
 	Макет = ПолучитьМакет("Записка");

	ОбластьМакета = Макет.ПолучитьОбласть("Шапка");
	ЗаполнитьЗначенияСвойств( ОбластьМакета.Параметры, ЭтотОбъект);
	
	ОбластьМакета.Параметры.СотрудникДолжность = "менеджера";
	
	//--------------склоняем фамилию-----------------------------------	
	СотрудникФИО = Сотрудник.Наименование;
	УстановитьВнешнююКомпоненту("ОбщийМакет.КомпонентаСклоненияФИО");
	Попытка
		ПодключитьВнешнююКомпоненту("ОбщийМакет.КомпонентаСклоненияФИО", "Decl", ТипВнешнейКомпоненты.Native); 
		Объект = Новый("AddIn.Decl.CNameDecl");
		Падеж = 2; //Дательный: кому? чему? 
		Если НЕ ЗначениеЗаполнено(СотрудникФИО) Тогда
		//	Сообщить("Не заполнено основное контактное лицо контрагента!", СтатусСообщения.Важное);
		Иначе
			СотрудникФИО = Объект.Просклонять(СотрудникФИО, Падеж);
		КонецЕсли;	
	Исключение
		Сообщить("Измените фамилию сотрудника вручную..."); 
	КонецПопытки;
	ОбластьМакета.Параметры.СотрудникФИО = СотрудникФИО;
	
	ОбластьМакета.Параметры.ПодразделениеНазвание = ?(ЗначениеЗаполнено(Подразделение.Контрагент),
					строка(Подразделение.Контрагент),
					строка(Подразделение) );
	
	ОбластьМакета.Параметры.ДатаПрибытия = формат(Дата,"ДЛФ=DD");
	
	если месяц(ДатаУбытия) = месяц(ДатаПрибытия) тогда
		ОбластьМакета.Параметры.ДатаУбытия = строка(День(ДатаУбытия));
		ОбластьМакета.Параметры.ДатаПрибытия = формат(ДатаПрибытия,"ДЛФ=DD");
	Иначе
		ОбластьМакета.Параметры.ДатаУбытия = формат(ДатаУбытия,"ДЛФ=DD");
		ОбластьМакета.Параметры.ДатаПрибытия = формат(ДатаПрибытия,"ДЛФ=DD");
	КонецЕсли;
	ТабДокумент.Вывести(ОбластьМакета);
	
	
	//==========================================================
	ОбластьМакета = Макет.ПолучитьОбласть("Строка");
	ном = 0;
	для каждого стр1 из Расходы цикл
		ном = ном + 1;
		ЗаполнитьЗначенияСвойств( ОбластьМакета.Параметры, стр1);
		ОбластьМакета.Параметры.НомерСтроки = ном;
	    ТабДокумент.Вывести(ОбластьМакета);
	КонецЦикла;
	
	//==========================================================
	ОбластьМакета = Макет.ПолучитьОбласть("Подвал");
	ОбластьМакета.Параметры.СуммаИтого    = расходы.Итог("Сумма");
	ОбластьМакета.Параметры.СуммаПрописью = формат(СуммаДокумента,"ЧДЦ=2; ЧН=0,00")+" "+строка(ВалютаДокумента)+" ("+СформироватьСуммуПрописью(СуммаДокумента, ВалютаДокумента)+")";
	
	
	регСв = РегистрыСведений.ФИОФизЛиц.ПолучитьПоследнее(Дата,  новый Структура("ФизЛицо",Сотрудник) );
	если ЗначениеНеЗаполнено(регСв) тогда
		ОбластьМакета.Параметры.СотрудникФИО = строка(Сотрудник);
	иначе
	ОбластьМакета.Параметры.СотрудникФИО = регСв.Фамилия+" "+Лев(регСв.Имя,1)+". "+Лев(регСв.Отчество,1)+".";
	КонецЕсли;
	
	Если Согласовал.Пустая() тогда
		пользователь = справочники.Пользователи.НайтиПоРеквизиту("ФизЛицо", Сотрудник );
		если пользователь.Пустая() тогда
			пользователь = Ответственный;
		КонецЕсли;	
		Согласовал = ?(Подразделение.Код ="00005", Ответственный.НаправлениеПродаж.Руководитель,
						Подразделение.Руководитель);
		Если Согласовал.Пустая() тогда // если нет направления продаж или руководителя
			//Согласовал =  Справочники.пользователи.НайтиПоКоду("Серков");
			Согласовал =  Справочники.пользователи.НайтиПоКоду("Бондаренко Е.Д. (снабжение)");
		КонецЕсли;
	КонецЕсли;	
	Руководитель = Согласовал.ФизЛицо;
	регСв = РегистрыСведений.ФИОФизЛиц.ПолучитьПоследнее(Дата,  новый Структура("ФизЛицо",Руководитель) );
	если ЗначениеНеЗаполнено(регСв) тогда
		ОбластьМакета.Параметры.РуководительФИО = строка(Руководитель);
	иначе
	ОбластьМакета.Параметры.РуководительФИО = регСв.Фамилия+" "+Лев(регСв.Имя,1)+". "+Лев(регСв.Отчество,1)+".";
	КонецЕсли;

	//--------------------------------------------------
	Если Утвердил.Пустая() тогда // по Ярославлю - Аверкина
		Утвердил = ?(Подразделение.Код ="00005", Справочники.пользователи.НайтиПоКоду("Аверкина"),
						 //Справочники.пользователи.НайтиПоКоду("Серков"));
						 Справочники.пользователи.НайтиПоКоду("Бондаренко Е.Д. (снабжение)"));
	КонецЕсли;	
	Утвердитель = Утвердил.ФизЛицо;
	регСв = РегистрыСведений.ФИОФизЛиц.ПолучитьПоследнее(Дата,  новый Структура("ФизЛицо",Утвердитель) );
	если ЗначениеНеЗаполнено(регСв) тогда
		ОбластьМакета.Параметры.УтвердилФИО = строка(Утвердил);
	иначе
	ОбластьМакета.Параметры.УтвердилФИО = регСв.Фамилия+" "+Лев(регСв.Имя,1)+". "+Лев(регСв.Отчество,1)+".";
	КонецЕсли;


	
	//Флаги
	флП = ЛОЖЬ; флС =ЛОЖЬ; флУ = ЛОЖЬ;
	Если Состояние = перечисления.СостоянияОбъектов.Утвержден тогда
		флП = истина; флС =истина; флУ = истина;
	ИначеЕсли Состояние = перечисления.СостоянияОбъектов.Согласован тогда
		флП = истина; флС =истина; 
	ИначеЕсли Состояние = перечисления.СостоянияОбъектов.Подготовлен тогда
		флП = истина; 
	КонецЕсли;	
	
	Если Состояние = перечисления.СостоянияОбъектов.Отклонен тогда
		Если Утвердил.Пустая() тогда // отклонил тот кто согласовывает
			ОбластьМакета.Параметры.флП = "V";
			ОбластьМакета.Параметры.флС = "X";
			ОбластьМакета.Параметры.флУ = "-";
		иначе
			ОбластьМакета.Параметры.флП = "V";
			ОбластьМакета.Параметры.флС = "V";
			ОбластьМакета.Параметры.флУ = "X";
		КонецЕсли;	
	Иначе
		ОбластьМакета.Параметры.флП = формат(флП, "БЛ=-; БИ=V");
		ОбластьМакета.Параметры.флС = формат(флС, "БЛ=-; БИ=V");
		ОбластьМакета.Параметры.флУ = формат(флУ, "БЛ=-; БИ=V");
	КонецЕсли;
	ТабДокумент.Вывести(ОбластьМакета);
	
	
	возврат ТабДокумент;
КонецФункции

функция ПечатьПриказ()
	
	Если Состояние = перечисления.СостоянияОбъектов.Согласован тогда
		Предупреждение("Приказ еще не Утвержден!", 10);
	ИначеЕсли Состояние = перечисления.СостоянияОбъектов.Подготовлен тогда
		Предупреждение("Приказ еще не Согласован! Печать приказа невозможна!", 10);
		возврат неопределено;
	КонецЕсли;	
		
	ТабДокумент = Новый ТабличныйДокумент;
	ТабДокумент.ИмяПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_ЗаявкаНаКомандировку_Записка";
 	Макет = ПолучитьМакет("Приказ_Т9");

	ОбластьМакета = Макет.ПолучитьОбласть("Шапка");
	ОбластьМакета.Параметры.НазваниеОрганизации = Организация.НаименованиеПолное;
	ОбластьМакета.Параметры.КодПоОКПО = Организация.КодПоОКПО;
	
	Если ДатаКомандировки='00010101' или сокрЛП(НомерКомандировки)="" тогда
		Предупреждение("Не заполнены Номер и Дата приказа на командировку!", 10);
	КонецЕсли;	
	ОбластьМакета.Параметры.НомерДок = НомерКомандировки;
	ОбластьМакета.Параметры.ДатаДок  = формат(ДатаКомандировки,"ДЛФ=D; ДП=' '");
	ТабДокумент.Вывести(ОбластьМакета);
	
	Если Сотрудник.Пустая() тогда
		Предупреждение("Не заполнен Сотрудник!", 10);
		возврат неопределено;
	КонецЕсли;	
	ОбластьМакета = Макет.ПолучитьОбласть("Работник");
	ОбластьМакета.Параметры.Работник = Сотрудник.Наименование;
	ОбластьМакета.Параметры.ТабельныйНомер = Сотрудник.ТабНомер;
	ОбластьМакета.Параметры.ПодразделениеРаботника = строка(Подразделение.Контрагент);
	ОбластьМакета.Параметры.Должность = "менеджер";
	ОбластьМакета.Параметры.СтранаНазначения = МестоКомандировки;
	ОбластьМакета.Параметры.ОрганизацияНазначения = "";
	ОбластьМакета.Параметры.Цель = Описание;
	
	ОбластьМакета.Параметры.ИсточникФинансирования = "";
	ОбластьМакета.Параметры.ОснованиеКомандировки  = "Заявка на командировку "+строка(Номер)+" от "+формат(Дата,"ДЛФ=D");
	
	ОбластьМакета.Параметры.Продолжительность = (ДатаПрибытия - ДатаУбытия)/86400 + 1;
	ОбластьМакета.Параметры.ДатаНачала 	  = формат(ДатаУбытия, "ДЛФ=DD");
	ОбластьМакета.Параметры.ДатаОкончания = формат(ДатаПрибытия, "ДЛФ=DD");
	
	//рс1 = РегистрыСведений.ПаспортныеДанныеФизЛиц.ПолучитьПоследнее( Дата, новый Структура("ФизЛицо", Сотрудник) );
	//если рс1 = неопределено тогда
	//	ОбластьМакета.Параметры.РеквизитыПаспорта = "";
	//иначе
	//	ОбластьМакета.Параметры.РеквизитыПаспорта = строка(рс1.ДокументВид)+" Серия: "+рс1.ДокументСерия+" № "+рс1.ДокументНомер
	//							+" Выдан: "+ рс1.ДокументКемВыдан+" "+формат(рс1.ДокументДатаВыдачи,"ДЛФ=D");
	//КонецЕсли;	
	ТабДокумент.Вывести(ОбластьМакета);
	
	
	ОбластьМакета = Макет.ПолучитьОбласть("Подвал");
    ОбластьМакета.Параметры.ДолжностьРуководителя	= "Генеральный директор";
	ОбластьМакета.Параметры.ФИОРуководителя			= "Малышев И.И.";
	ОбластьМакета.Параметры.ДатаДок = формат(ДатаКомандировки,"ДЛФ=D; ДП=' '"); // дата приказа!
	ТабДокумент.Вывести(ОбластьМакета);
	
	возврат ТабДокумент;
КонецФункции

функция ПечатьУдостоверения()
	
	Если Состояние = перечисления.СостоянияОбъектов.Согласован тогда
		Предупреждение("Заявка еще не Утверждена!", 10);
	ИначеЕсли Состояние = перечисления.СостоянияОбъектов.Подготовлен тогда
		Предупреждение("Заявка еще не Согласована! Печать Удостоверения невозможна!", 10);
		возврат неопределено;
	КонецЕсли;	

	ТабДокумент = Новый ТабличныйДокумент;
	ТабДокумент.ИмяПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_ЗаявкаНаКомандировку_Удостоверение";
 	Макет = ПолучитьМакет("Удостоверение_Т10");

	ОбластьМакета = Макет.ПолучитьОбласть("Шапка");
	ОбластьМакета.Параметры.НазваниеОрганизации = Организация.НаименованиеПолное;
	ОбластьМакета.Параметры.КодПоОКПО = Организация.КодПоОКПО;
	
	Если ДатаКомандировки='00010101' или сокрЛП(НомерКомандировки)="" тогда
		Предупреждение("Не заполнены Номер и Дата приказа на командировку!", 10);
	КонецЕсли;	
	ОбластьМакета.Параметры.НомерДок = НомерКомандировки;
	ОбластьМакета.Параметры.ДатаДок  = формат(ДатаКомандировки,"ДЛФ=D; ДП=' '");
	ТабДокумент.Вывести(ОбластьМакета);
	
	Если Сотрудник.Пустая() тогда
		Предупреждение("Не заполнен Сотрудник!", 10);
		возврат неопределено;
	КонецЕсли;	
	ОбластьМакета = Макет.ПолучитьОбласть("Работник");
	ОбластьМакета.Параметры.Работник = Сотрудник.Наименование;
	ОбластьМакета.Параметры.ТабельныйНомер = Сотрудник.ТабНомер;
	ОбластьМакета.Параметры.ПодразделениеРаботника = строка(Подразделение.Контрагент);
	ОбластьМакета.Параметры.Должность = "менеджер";
	ОбластьМакета.Параметры.СтранаНазначения = МестоКомандировки;
	ОбластьМакета.Параметры.ОрганизацияНазначения = "";
	ОбластьМакета.Параметры.Цель = Описание;
	ОбластьМакета.Параметры.Продолжительность = (ДатаПрибытия - ДатаУбытия)/86400 + 1;
	ОбластьМакета.Параметры.ДатаНачала 	  = формат(ДатаУбытия, "ДЛФ=DD");
	ОбластьМакета.Параметры.ДатаОкончания = формат(ДатаПрибытия, "ДЛФ=DD");
	рс1 = РегистрыСведений.ПаспортныеДанныеФизЛиц.ПолучитьПоследнее( Дата, новый Структура("ФизЛицо", Сотрудник) );
	если рс1 = неопределено тогда
		ОбластьМакета.Параметры.РеквизитыПаспорта = "";
	иначе
	    ОбластьМакета.Параметры.РеквизитыПаспорта = строка(рс1.ДокументВид)+" Серия: "+рс1.ДокументСерия+" № "+рс1.ДокументНомер
								+" Выдан: "+ рс1.ДокументКемВыдан+" "+формат(рс1.ДокументДатаВыдачи,"ДЛФ=D");
	КонецЕсли;	
	ТабДокумент.Вывести(ОбластьМакета);
	
	
	ОбластьМакета = Макет.ПолучитьОбласть("Подвал");
    ОбластьМакета.Параметры.ДолжностьРуководителя	= "Генеральный директор";
	ОбластьМакета.Параметры.ФИОРуководителя			= "Малышев И.И.";
	ТабДокумент.Вывести(ОбластьМакета);
	
	//============================2-я страница!=============================
	табДокумент.ВывестиГоризонтальныйРазделительСтраниц();
	ОбластьМакета = Макет.ПолучитьОбласть("ШапкаОтметок");
	ТабДокумент.Вывести(ОбластьМакета);
	
	ОбластьМакета = Макет.ПолучитьОбласть("Отметки");
	ТабДокумент.Вывести(ОбластьМакета);
	ТабДокумент.Вывести(ОбластьМакета);
	ТабДокумент.Вывести(ОбластьМакета);
	ТабДокумент.Вывести(ОбластьМакета);
	ТабДокумент.Вывести(ОбластьМакета);
	
	возврат ТабДокумент;
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

	Если ЭтоНовый() Тогда
		Предупреждение("Документ можно распечатать только после его записи");
		Возврат;
	ИначеЕсли Не РазрешитьПечатьНепроведенныхДокументов(Проведен) Тогда
		Предупреждение("Недостаточно полномочий для печати непроведенного документа!");
		Возврат;
	КонецЕсли; 

	Если Не ПроверитьМодифицированность(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;

 	// Получить экземпляр документа на печать
	Если      ИмяМакета = "Записка" Тогда
		    ТабДокумент = ПечатьЗаписка();
			
	ИначеЕсли ИмяМакета = "Приказ" тогда  //Т9
		//Предупреждение("Приказ на командировку (Т9) формируется ТОЛЬКО 
		//			   |в программе ""Зарплата и Управление персоналом""
		//			   |после создания документа ""Командировка организации"".", 10);
			    ТабДокумент = ПечатьПриказ();
					   
	ИначеЕсли ИмяМакета = "Удостоверение" тогда
		//Предупреждение("Командировочное удостоверение (Т10) формируется ТОЛЬКО 
		//			   |в программе ""Зарплата и Управление персоналом""
		//				|после создания документа ""Командировка организации"".", 10);
			    ТабДокумент = ПечатьУдостоверения();
			
										   
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

// Возвращает доступные варианты печати документа
//
// Вовращаемое значение:
//  Струткура, каждая строка которой соответствует одному из вариантов печати
//  
Функция ПолучитьСписокПечатныхФорм() Экспорт

	СписокМакетов = Новый СписокЗначений;
	СписокМакетов.Добавить("Записка", "Служебная записка (по заявке)");
	СписокМакетов.Добавить("Приказ",  		 "Приказ на командировку (Т9)");
	СписокМакетов.Добавить("Удостоверение",  "Командировочное удостоверение (Т10)");
	
	ДобавитьВСписокДополнительныеФормы(СписокМакетов, Метаданные());
	
	Возврат СписокМакетов;

КонецФункции // ПолучитьСписокПечатныхФорм()

