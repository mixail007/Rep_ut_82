﻿Перем DiadocConnection Экспорт;

Процедура КнопкаВыполнитьНажатие(Кнопка)
	
	Если ШифроватьДокументы И НЕ ПолучитьМодульПрог("Модуль_РаботаССерверомДиадок").Organization(OrganizationId).EncryptedDocumentsAllowed Тогда
		
		Получитьформу("Модуль_СообщенияДляПользователей_Форма_ВыводОшибки").ПоказатьОшибку(
		"Ошибка настройки шифрования документов!",
		"Опция отправки зашифрованных документов не подключена!" + Символы.ПС + Символы.ПС + "Для того чтобы включить подключить опцию, обратитесь в техподдержку.");
		
		Возврат;
		
	КонецЕсли;
	
	НастройкиОрганизации.НакладныеСТоварами = НакладныеСТоварами;
	НастройкиОрганизации.НакладныеСУслугамиБезТоваров = НакладныеСУслугамиБезТоваров;
	
	НастройкиОрганизации.ОтправлятьНепроведенные = ?(ОтправлятьНепроведенные, "Да", "");
	НастройкиОрганизации.ТекстКомментарияДиадок  = ?(ЗаписыватьКомментарийПриОтправке, ТекстКомментария, "");
	
	НастройкиОрганизации.ПредставлениеДопСертификата =	ПредставлениеДопСертификата;
	НастройкиОрганизации.ФормироватьУПД 	= ФормироватьУПД;
	НастройкиОрганизации.ШифроватьДокументы = ?(ШифроватьДокументы, "ДА", "НЕТ");
	
	КэшВПФ = Неопределено;
	
	Успех = Истина;
	
	Закрыть();

КонецПроцедуры

Функция ПредставлениеКолонкиФормированиеАкта(НастройкиВнешнихПечатныхФорм)
		Если  ЗначениеЗаполнено(НастройкиВнешнихПечатныхФорм.ДиадокВнешняяПечатнаяФормаАкта) Тогда
			Возврат "используя внешнюю печатную форму"
		Иначе 
			Возврат "в соответствии с форматом ФНС"
		КонецЕсли;	
	
КонецФункции	
	
Функция ПредставлениеКолонкиФормированиеСчета(НастройкиВнешнихПечатныхФорм)
	Если  НастройкиВнешнихПечатныхФорм.ДиадокСпособОтправкиСчета = "НеФормировать" Тогда 
		Возврат "не формировать"
	Иначе 
		Описание = "формировать на основании документа ";
		Если  НастройкиВнешнихПечатныхФорм.ДиадокСпособОтправкиСчета = "СчетНаОплату"  Тогда
			описание = Описание + """Счет на оплату""";
		ИначеЕсли  НастройкиВнешнихПечатныхФорм.ДиадокСпособОтправкиСчета = "Заказ"  Тогда
			описание = Описание + """Заказ""";
		Иначе 
			описание = Описание + """Расходная накладная""";
		КонецЕсли;
		
		Если ЗначениеЗаполнено(НастройкиВнешнихПечатныхФорм.ДиадокВнешняяПечатнаяФормаСчета) Тогда
			Описание = Описание + ", используя внешнюю печатную форму";
		КонецЕсли;	
		Возврат описание;	
	КонецЕсли;	
КонецФункции

Функция ПредставлениеКолонкиФормированиеСверки(НастройкиВнешнихПечатныхФорм)
	Если  НастройкиВнешнихПечатныхФорм.ДиадокСпособОтправкиСверки = "НеФормировать" Тогда 
		Возврат "не формировать"
	Иначе 
		Описание = "формировать, ";
		
		Если ЗначениеЗаполнено(НастройкиВнешнихПечатныхФорм.ДиадокВнешняяПечатнаяФормаСверки) Тогда
			Описание = Описание + "используя внешнюю печатную форму";
		Иначе 
			Описание = Описание + "используя типовую форму";
		КонецЕсли;	
		Возврат описание;	
	КонецЕсли;	
КонецФункции

Функция ПредставлениеКолонкиДополнительныеВнешниеПечатныеФормы(НастройкиВнешнихПечатныхФорм)
	МассивДополнительныхВПФ =НастройкиВнешнихПечатныхФорм.МассивДополнительныхВПФ ;
	
	Если  МассивДополнительныхВПФ.количество() = 0 Тогда
		Возврат "не настроено"   
	Иначе
		СтрокаНазванийФорм=	"";
		Для каждого ДополнительнаяФорма Из МассивДополнительныхВПФ Цикл
			СтрокаНазванийФорм=	СтрокаНазванийФорм + ?(ПустаяСтрока(СтрокаНазванийФорм), "", "; ") + ДополнительнаяФорма.Наименование;
		КонецЦикла;
		
		Возврат СокрЛП(СтрокаНазванийФорм);

	КонецЕсли;	   
КонецФункции	

Процедура ОбновитьнадписиФормы()
	
	НадписьФормированиеАкта=		ПредставлениеКолонкиФормированиеАкта(НастройкиОрганизации.НастройкиВнешнихПечатныхФорм) ;
	НадписьФормированиеСчета=		ПредставлениеКолонкиФормированиеСчета(НастройкиОрганизации.НастройкиВнешнихПечатныхФорм) ;
	НадписьФормированиеАктаСверки=	ПредставлениеКолонкиФормированиеСверки(НастройкиОрганизации.НастройкиВнешнихПечатныхФорм) ;
	
	Попытка
		НадписьДополнительныеВПФ=		ПредставлениеКолонкиДополнительныеВнешниеПечатныеФормы(НастройкиОрганизации.НастройкиВнешнихПечатныхФорм);
	Исключение
		Получитьформу("Модуль_СообщенияДляПользователей_Форма_ВыводОшибки").ПоказатьОшибку(
			"Внимание!",
			"Не удалось обновить данные по дополнительным ВПФ",
			ОписаниеОшибки());
	КонецПопытки;
		
	ВерхнийЗаголовокФормы=			"Организация: " + ПредставлениеОрганизации;
	ПредставлениеДопСертификата=	НастройкиОрганизации.ПредставлениеДопСертификата;
	
КонецПроцедуры 	

Процедура ПриОткрытии()
	
	КартинкаЗаголовка= ЭДО_БиблиотекаКартинок().КартинкаЗаголовка;
	ОбновитьнадписиФормы();
		
	Если (ПолучитьПрофильКонфигурации().АнализироватьВидОперацииРТУ) Тогда 
		Элементыформы.НакладныеСУслугамиБезТоваров.СписокВыбора.Добавить("В зависимости от вида операции");
	КонецЕсли;
	
	Если ИмяФормыПрикладногорешенияДляИнтеграцииДиадок() = "Модуль_ИнтеграцияАльфаАвто41"
		ИЛИ ИмяФормыПрикладногорешенияДляИнтеграцииДиадок() = "Модуль_ИнтеграцияУТ102" Тогда
		УстановитьРежимСверткиЭлементаУправления(ЭлементыФормы.ПанельФормированиеПрочихДокументов, РежимСверткиЭлементаУправления.Верх);
	КонецЕсли;
	
	ЭлементыФормы.ФормироватьУПД.СписокВыбора = ФорматДокументовНаОтправкуСписокВыбора();
	
	НакладныеСТоварами	= НастройкиОрганизации.НакладныеСТоварами;
	НакладныеСУслугамиБезТоваров = НастройкиОрганизации.НакладныеСУслугамиБезТоваров;
	
	ОтправлятьНепроведенные		      = НастройкиОрганизации.ОтправлятьНепроведенные = "Да";
	ТекстКомментария			      = ?(ЗначениеЗаполнено(НастройкиОрганизации.ТекстКомментарияДиадок), НастройкиОрганизации.ТекстКомментарияДиадок, "Передано через "+НаименованиеСистемы);
	ЗаписыватьКомментарийПриОтправке  =ЗначениеЗаполнено(НастройкиОрганизации.ТекстКомментарияДиадок);
	ЗаписыватьКомментарийПриОтправкеПриИзменении("");
	ФормироватьУПД		 			  = НастройкиОрганизации.ФормироватьУПД;
	ШифроватьДокументы	 			  = ВРЕГ(НастройкиОрганизации.ШифроватьДокументы) = "ДА";
	
КонецПроцедуры

Процедура НадписьФормированиеАктаНажатие(Элемент)
	фрм = ЭтотОбъект.получитьФорму("ФормаНастройкиДополнительныхПечатныхФормДляАкта");
	фрм.НастройкиВнешнихПечатныхФорм = НастройкиОрганизации.НастройкиВнешнихПечатныхФорм;
	фрм.ОткрытьМодально();
	Если фрм.успех Тогда
		НастройкиОрганизации.НастройкиВнешнихПечатныхФорм.ДиадокВнешняяПечатнаяФормаАкта = фрм.НастройкиВнешнихПечатныхФорм.ДиадокВнешняяПечатнаяФормаАкта;
		ОбновитьнадписиФормы();
	КонецЕсли;	
КонецПроцедуры

Процедура НадписьФормированиеСчетаНажатие(Элемент)
	фрм = ЭтотОбъект.получитьФорму("ФормаНастройкиДополнительныхПечатныхФормДляСчета");
	фрм.НастройкиВнешнихПечатныхФорм = НастройкиОрганизации.НастройкиВнешнихПечатныхФорм;
	фрм.ОткрытьМодально();
	Если фрм.успех Тогда
		НастройкиОрганизации.НастройкиВнешнихПечатныхФорм.ДиадокСпособОтправкиСчета 	  = фрм.НастройкиВнешнихПечатныхФорм.ДиадокСпособОтправкиСчета;
		НастройкиОрганизации.НастройкиВнешнихПечатныхФорм.ДиадокВнешняяПечатнаяФормаСчета = фрм.НастройкиВнешнихПечатныхФорм.ДиадокВнешняяПечатнаяФормаСчета;
		ОбновитьнадписиФормы();
	КонецЕсли;
КонецПроцедуры

Процедура НадписьДополнительныеВПФНажатие(Элемент)
	// Вставить содержимое обработчика.
	фрм = ЭтотОбъект.ПолучитьФорму("ФормаНастройкиДополнительныхВнешнихПечатныхФорм");
	фрм.массивВПФ =   НастройкиОрганизации.НастройкиВнешнихПечатныхФорм.МассивДополнительныхВПФ;
	Если фрм.НастроитьСписокВнешнихПечатныхФорм()=Истина Тогда
		НастройкиОрганизации.НастройкиВнешнихПечатныхФорм.МассивДополнительныхВПФ = фрм.массивВПФ ;
		ОбновитьнадписиФормы();
	КонецЕсли;

КонецПроцедуры

Процедура НадписьФормированиеАктаСверкиНажатие(Элемент)
	// Вставить содержимое обработчика.
	фрм = ЭтотОбъект.получитьФорму("ФормаНастройкиДополнительныхПечатныхФормДляСверки");
	фрм.НастройкиВнешнихПечатныхФорм = НастройкиОрганизации.НастройкиВнешнихПечатныхФорм;
	фрм.ОткрытьМодально();
	Если фрм.успех Тогда
		НастройкиОрганизации.НастройкиВнешнихПечатныхФорм.ДиадокСпособОтправкиСверки 	   = фрм.НастройкиВнешнихПечатныхФорм.ДиадокСпособОтправкиСверки;
		НастройкиОрганизации.НастройкиВнешнихПечатныхФорм.ДиадокВнешняяПечатнаяФормаСверки = фрм.НастройкиВнешнихПечатныхФорм.ДиадокВнешняяПечатнаяФормаСверки;
		ОбновитьнадписиФормы();
	КонецЕсли;

КонецПроцедуры

Процедура ЗаписыватьКомментарийПриОтправкеПриИзменении(Элемент)
	ЭлементыФормы.ТекстКомментария.Доступность = ЗаписыватьКомментарийПриОтправке;
КонецПроцедуры

Процедура ПолеВвода1НачалоВыбора(Элемент, СтандартнаяОбработка)
	
	ПараметрыDiadocConnection=	Модуль_РаботаССерверомДиадок.ВыбратьСертификатДляОрганизации(ПредставлениеОрганизации, OrganizationId);
	Если НЕ ПараметрыDiadocConnection = Неопределено Тогда
		ПредставлениеДопСертификата=	Модуль_РаботаССерверомДиадок.ПредставлениеСертификата(ПараметрыDiadocConnection.DiadocConnection.Certificate);
		DiadocConnection=				ПараметрыDiadocConnection.DiadocConnection;
	КонецЕсли;
	
КонецПроцедуры

Процедура ПредставлениеСертификатаОрганизацииОчистка(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка=	Ложь;
	
	ПредставлениеДопСертификата=	"";
	
КонецПроцедуры

Процедура ФормироватьУПДОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	СтандартнаяОбработка = ВыбранноеЗначение <> "Разделитель";
	
КонецПроцедуры

Процедура ПодробнееОНастройкахНажатие(Элемент)

	ФормаHTMLДокумента = ПолучитьМодульПрог("ФормаHTMLДокумента");
	
	ФормаHTMLДокумента.Заголовок	= "Руководство пользователя";
	ФормаHTMLДокумента.URL			= "https://wiki.diadoc.ru/pages/viewpage.action?pageId=7668170";
	
	ФормаHTMLДокумента.ОткрытьМодально();
	
КонецПроцедуры
