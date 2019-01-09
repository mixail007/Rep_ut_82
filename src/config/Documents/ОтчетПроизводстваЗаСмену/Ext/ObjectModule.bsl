﻿перем мВалютаРегламентированногоУчета, мВалютаУпрУчета;
Перем мПроведениеИзФормы Экспорт;

#Если Клиент Тогда

// Функция формирует табличный документ с печатной формой накладной,
// разработанной методистами
//
// Возвращаемое значение:
//  Табличный документ - печатная форма накладной
//
Функция ПечатьКалькуляцииСебестоимости()

	ТабДокумент = Новый ТабличныйДокумент;
	ТабДокумент.ИмяПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_РаспределениеЗатратНаВыпускГотовойПродукции_Калькуляция";

	Макет = ЭтотОбъект.ПолучитьМакет("Калькуляция");

	// Выводим шапку документа
	ОбластьМакета = Макет.ПолучитьОбласть("Шапка");
	ОбластьМакета.Параметры.Подразделение = Подразделение;
	ОбластьМакета.Параметры.Номер = Номер;
	ОбластьМакета.Параметры.Дата = формат(Дата,"ДЛФ=D");
	ОбластьМакета.Параметры.Период = формат(Дата,"ДФ='ММMM yyyy'");
	ТабДокумент.Вывести(ОбластьМакета);

	//==========================По готовой продукции==================
	ОбластьСтрокиГ = Макет.ПолучитьОбласть("СтрокаГотПрод");
	
	ОбластьСтрокиМ = Макет.ПолучитьОбласть("СтрокаМат");
	ОбластьШапкаМ = Макет.ПолучитьОбласть("ШапкаМат");
	
	ОбластьШапкаЗ = Макет.ПолучитьОбласть("ШапкаЗатрат");
	ОбластьСтрокаЗ = Макет.ПолучитьОбласть("СтрокаЗатрат");
	
	ОбластьИтого  = Макет.ПолучитьОбласть("СтрокаИтого");
	
	для каждого стрГ из ЭтотОбъект.ГотоваяПродукция цикл
		ОбластьСтрокиГ.Параметры.ГотоваяПродукция = стрГ.Номенклатура;
		ОбластьСтрокиГ.Параметры.Код = стрГ.Номенклатура.Код;
		ОбластьСтрокиГ.Параметры.Себестоимость = Формат(Окр(стрГ.Сумма / стрГ.Количество,2),"ЧДЦ=2");
		ОбластьСтрокиГ.Параметры.Количество = стрГ.Количество;
		ОбластьСтрокиГ.Параметры.Сумма 		= Формат(стрГ.Сумма,"ЧДЦ=2");;
		ОбластьСтрокиГ.Параметры.СуммаПлан  = Формат(стрГ.СуммаПлан,"ЧДЦ=2");
		ТабДокумент.Вывести(ОбластьСтрокиГ);

		ТабДокумент.Вывести(ОбластьШапкаМ);
		ИтогСуммы        = 0;
		для каждого стрК из стрГ.Спецификация.Состав цикл
		ОбластьСтрокиМ.Параметры.Материал   = стрК.Комплектующая;
		колСпец = стрК.Количество * стрГ.Количество;
		ОбластьСтрокиМ.Параметры.Количество = колСпец;
		
		стрМ = материалы.НайтиСтроки(новый Структура("Номенклатура,Распределяется", стрК.Комплектующая,ЛОЖЬ) );
		Если стрМ<>Неопределено тогда
		сумма1 = Окр(стрМ[0].Сумма / стрМ[0].Количество * колСпец,2);
		иначе Сумма1 = 0;
		КонецЕсли;
		ИтогСуммы = ИтогСуммы + Сумма1;
		ОбластьСтрокиМ.Параметры.Цена	    = Окр(сумма1 / КолСпец,2);
		ОбластьСтрокиМ.Параметры.Сумма      = сумма1;
		ТабДокумент.Вывести(ОбластьСтрокиМ);
		КонецЦикла;
		ОбластьИтого.Параметры.Сумма = ИтогСуммы;
		ТабДокумент.Вывести(ОбластьИтого);
	КонецЦикла;
	
	//---------------материалы общие--------------------------
	ТабДокумент.Вывести(ОбластьШапкаЗ);
		ИтогСуммы        = 0;
		для каждого стрМ из Материалы цикл
			если не стрМ.Распределяется тогда
				продолжить;
			КонецЕсли;	
	    ОбластьСтрокиМ.Параметры.Материал   = стрМ.Номенклатура;
		ОбластьСтрокиМ.Параметры.Количество = стрМ.Количество;
		ОбластьСтрокиМ.Параметры.Сумма 		= стрМ.Сумма;
		ОбластьСтрокиМ.Параметры.Цена	    = ?(стрМ.Количество=0, стрМ.Сумма, Окр(стрМ.Сумма / стрМ.Количество,2) );
		ИтогСуммы = ИтогСуммы + стрМ.Сумма;
		ТабДокумент.Вывести(ОбластьСтрокиМ);
		КонецЦикла;
	ОбластьИтого.Параметры.Сумма        = ФорматСумм(ИтогСуммы);
	ТабДокумент.Вывести(ОбластьИтого);

		
	//----------------Затраты общие--------------------
	ИтогСуммы=0;
	для каждого стрЗ из ДопЗатраты цикл
		ОбластьСтрокаЗ.Параметры.СтатьяЗатрат = Строка(стрЗ.СтатьяЗатрат)+?(стрЗ.СтатьяЗатратУПР.Пустая(), "", " ("+строка(стрЗ.СтатьяЗатратУПР)+")");
		ОбластьСтрокаЗ.Параметры.Сумма = стрЗ.Сумма;
		ИтогСуммы = ИтогСуммы + стрЗ.Сумма;
	ТабДокумент.Вывести(ОбластьСтрокаЗ);
	КонецЦикла;	
	ОбластьИтого.Параметры.Сумма        = ФорматСумм(ИтогСуммы);
	ТабДокумент.Вывести(ОбластьИтого);

	Возврат ТабДокумент;

КонецФункции // ПечатьДокумента()

//Процедура осуществляет печать документа. Можно направить печать на 
// экран или принтер, а также распечатать необходмое количество копий.
//
//  Название макета печати передается в качестве параметра,
// по переданному названию находим имя макета в соответствии.
//
// Параметры:
//  НазваниеМакета - строка, название макета.
//
Процедура Печать(ИмяМакета, КоличествоЭкземпляров = 1, НаПринтер = Ложь) Экспорт

	Если ЭтоНовый() Тогда
		Предупреждение("Документ можно распечатать только после его записи");
		Возврат;
	КонецЕсли;

	Если Не ПроверитьМодифицированность(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;

	мВалютаРегламентированногоУчета = константы.ВалютаРегламентированногоУчета.Получить();
	мВалютаУпрУчета = константы.ВалютаУправленческогоУчета.Получить();
	
	// Получить экземпляр документа на печать
	Если ИмяМакета = "КалькуляцияСебестоимости" Тогда

		// Печать упр. формы документа
		ТабДокумент = ПечатьКалькуляцииСебестоимости();
		
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

	НапечататьДокумент(ТабДокумент, КоличествоЭкземпляров, НаПринтер, СформироватьЗаголовокДокумента(ЭтотОбъект, ЭтотОбъект.Метаданные().Представление()));

КонецПроцедуры // Печать

// Возвращает доступные варианты печати документа
//
// Вовращаемое значение:
//  Струткура, каждая строка которой соответствует одному из вариантов печати
//  
Функция ПолучитьСписокПечатныхФорм() Экспорт

	СписокМакетов = Новый СписокЗначений;

	СписокМакетов.Добавить("КалькуляцияСебестоимости", "Калькуляция себестоимости");
	
	ДобавитьВСписокДополнительныеФормы(СписокМакетов, Метаданные());
	Возврат СписокМакетов;

КонецФункции // ПолучитьСписокПечатныхФорм()

#КонецЕсли

процедура ПроверитьСуммуГотПрод(Отказ)
	delta = ГотоваяПродукция.Итог("Сумма") - ( Материалы.Итог("Сумма") + ДопЗатраты.Итог("Сумма") );
	Если delta тогда
		#Если Клиент тогда
		Сообщить("Сумма готовой продукции: "+строка(ГотоваяПродукция.Итог("Сумма"))
		+"р. отличается от суммы Материалов: "+строка(Материалы.Итог("Сумма"))
		+" и Доп.Затрат: "+строка(ДопЗатраты.Итог("Сумма"))+" на "+строка(delta)+"р.!", СтатусСообщения.Внимание );
	//+++ 03.08.2018 - есть расхождения по копейкам!
		Сообщить("Автоматически увеличена цена товара из 1-ой строки.");
		#КонецЕсли	
	Если ГотоваяПродукция.Количество()>0 тогда
	 ГотоваяПродукция[0].Сумма = ГотоваяПродукция[0].Сумма - delta;
	КонецЕсли; 
	//Отказ = ИСТИНА;
	КонецЕсли;	
КонецПроцедуры

Процедура мРасчетСебестоимостиГотовойПродукции() ЭКСПОРТ
	
	//Для контроля количества материалов...
	таблМат = Материалы.Выгрузить();
	
//+++ 20.07.2018 могут быть 2 строки 1 товара ("свой" и +/- из РаспределениеЗатратНаВыпускГотовойПродукции)
// 1-я строка - оригинал, 2-я из корректировки - можно сделать распределение "!
	N=таблМат.Количество(); i=0;
	пока i<N цикл
		Если таблМат[i].распределяется тогда
			таблМат.Удалить(i); N=N-1;
		иначе i=i+1;
		КонецЕсли;	
	КонецЦикла;	
		
	//1) расчет мат.стоимости
	Для каждого стрГ из ГотоваяПродукция цикл
		суммаГ = 0;
		Для каждого стрК из стрГ.Спецификация.Состав цикл //сборка материалов и проверка их достаточности...
			КолНадо = стрК.Количество * стрГ.Количество;
			стрМ = таблМат.Найти( стрК.Комплектующая, "Номенклатура");
			Если стрМ = Неопределено тогда
				КолЕсть = 0;
			Иначе 
				КолЕсть = ?(стрМ.Количество<0,0, стрМ.Количество); // нехватку не считаем в себестоимость!
			КонецЕсли;	
			
			НеХватает = КолНадо - КолЕсть;
			Если  НеХватает>0 тогда
				#Если Клиент тогда
					Сообщить(строка(стрГ.НомерСтроки)+") Недостаточно "+строка(НеХватает)+" шт. "+строка(стрК.Комплектующая)+" для производства "+строка(стрГ.Количество)+" шт. "+строка(стрГ.Номенклатура), СтатусСообщения.Внимание);
				#КонецЕсли	
			КонецЕсли;
			
			Если стрМ <> Неопределено тогда
				сумма1 = КолНадо * стрМ.Сумма / стрМ.Количество; //сумма по Спецификации
				суммаГ = суммаГ + сумма1;
				стрМ.Количество = ?(НеХватает>0, 0, стрМ.Количество - КолНадо);
				стрМ.Сумма      = ?(НеХватает>0, 0, стрМ.Сумма      - Сумма1 ); 
				Если стрМ.Количество=0 тогда //всё списали
					таблМат.Удалить( стрМ );
				КонецЕсли;	
			КонецЕсли;
		КонецЦикла;	
		стрГ.Сумма = суммаГ;
	КонецЦикла;
	
//26.07.2018--------распределяемые материалы из документа "РаспределениеЗатратНаВыпускГотовойПродукции"--------------
	таблМатР = Материалы.Выгрузить();
// 1-я строка - оригинал, 2-я из корректировки - можно сделать распределение "!
	N=таблМатР.Количество(); i=0;
	пока i<N цикл
		Если НЕ таблМатР[i].распределяется тогда
			таблМатР.Удалить(i); N=N-1;
		иначе i=i+1;
		КонецЕсли;	
	КонецЦикла;	
	
//1.а)=========Остатки "лишних" материалов.... распределяются на всю готовую продукцию - по количеству
	таблМат.Свернуть("Номенклатура", "Количество, Сумма");
	для каждого стр1 из таблМат Цикл 
		Если стр1.Количество>0 или стр1.Сумма>0 тогда
		стрР = таблМатР.Добавить();
		ЗаполнитьЗначенияСвойств(стрР, стр1);
		КонецЕсли;
	КонецЦикла;
таблМатР.Свернуть("Номенклатура", "Количество, Сумма"); // общее количество и сумма респределяемых и лишних
таблМат = таблМатР.Скопировать();


распределятьПоГ = "СуммаПлан"; //"Количество" / "Сумма" / "СуммаПлан"; //параметр распределения материалов на Гот.прод
распределятьПоМ = "Сумма"; //"Количество" / "Сумма"  //параметр распределения материалов на Гот.прод

//2.материалы) распределение всех излишков/недостач из корректировки материалов - на готовую продукцию ------------------
Если таблМат.Итог(распределятьПоМ)<>0 тогда   //Есть остатки материалов
	
	Для каждого стрМ из таблМат цикл
		
		Если стрМ.Сумма<>0 тогда 
			стрМ.Количество = 0;// списываем "Излишки/Недостачу" на всю готовую продукцию...
			
			//1) если нет спецификаций - по количеству
			распределятьПоКоличеству = Истина;
			КолГотПрод     = 0;
			Для каждого стрГ из ГотоваяПродукция цикл
				стрСпец = стрГ.Спецификация.Состав.Найти(стрМ.Номенклатура,"Комплектующая");
				Если стрСпец <> неопределено тогда
	            //2) - по спецификациям:  КолГотПрод х КолСпецификация --------------
				распределятьПоКоличеству = ЛОЖЬ;
				КолГотПрод = КолГотПрод + стрГ[распределятьПоГ] * стрСпец.Количество;
                //3) и так и сяк -> только на товары по спецификации!
				//иначеЕсли не распределятьПоКоличеству тогда	
				//	распределятьПоКоличеству = ЛОЖЬ;
			 	КонецЕсли;
			КонецЦикла;
			
			Если распределятьПоКоличеству тогда  //если нет ни одного гот.товара со спецификацией, то по количеству
				КолГотПрод = ГотоваяПродукция.Итог(распределятьПоГ);
			КонецЕсли;
			
			ДопЦена = стрМ.Сумма/КолГотПрод;  ДопСумма=0; максГ=0;
			Для каждого стрГ из ГотоваяПродукция цикл
				
				Если распределятьПоКоличеству тогда
					парамРаспределения = стрГ[распределятьПоГ]; 
				Иначе// "по Спецификации"
					стрСпец = стрГ.Спецификация.Состав.Найти(стрМ.Номенклатура,"Комплектующая");
					Если стрСпец = неопределено 
						тогда КолСпец = 0; //только на товары со спецификацией?!  можно тут ввести число от 0 до 1
						иначе КолСпец = стрСпец.Количество;
					КонецЕсли;	
					парамРаспределения = стрГ[распределятьПоГ]*КолСпец;
				КонецЕсли;
				
				ДопСумма1 = ОКР(ДопЦена * парамРаспределения, 2);
				стрГ.Сумма = стрГ.Сумма + ДопСумма1;
				
				ДопСумма = ДопСумма + ДопСумма1;
				Если парамРаспределения>=максГ тогда // на последнюю максимальную строку
					максГ = парамРаспределения;
					стрДельта = стрГ;
				КонецЕсли;	
			КонецЦикла;	
			
			//копейки
			delta = стрМ.Сумма - ДопСумма;
			Если delta<>0 тогда
				стрДельта.Сумма = стрДельта.Сумма + delta;
			КонецЕсли;	
		КонецЕсли;	
	КонецЦикла;
	
КонецЕсли; //Есть остатки материалов

//07.08.2018 - только сумма всех материалов - нужна для выгрузки в БП!
для каждого стрГ из ГотоваяПродукция цикл 
	стрГ.СуммаМат = стрГ.Сумма;
КонецЦикла;	

//2.затраты) распределение всех затрат на готовую продукцию --------------------------------------------
	СуммаДопЗатрат = ДопЗатраты.Итог("Сумма");
	Если СуммаДопЗатрат=0 тогда
		возврат;
	КонецЕсли;
	
	Если СпособРаспределенияДопЗатрат = перечисления.СпособыРаспределенияДопРасходов.ПоСумме тогда  //По Плановой сумме!
		парамРаспределенияГотПрод = "СуммаПлан";
	ИначеЕсли СпособРаспределенияДопЗатрат = перечисления.СпособыРаспределенияДопРасходов.ПоКоличеству тогда
		парамРаспределенияГотПрод = "Количество";	
	ИначеЕсли СпособРаспределенияДопЗатрат = перечисления.СпособыРаспределенияДопРасходов.ПоВесу тогда
		парамРаспределенияГотПрод = "Вес";	
	КонецЕсли;
	ВсяГотПродукция =ГотоваяПродукция.Итог(парамРаспределенияГотПрод);
	
//-----------корректирока копеек - на макс.себестоимость----------------------------------	
	макс = 0;	стрМакс = неопределено; 	СуммаДопЗатратГ = 0; // Для исправления округления - остаток на макс. сумму1
	Стоимость1 = СуммаДопЗатрат/ВсяГотПродукция;
	Для каждого стрГ из ГотоваяПродукция цикл
		
		сумма1 =  стрГ[парамРаспределенияГотПрод] * Стоимость1;   	
		
		Если сумма1>=макс тогда
			макс = сумма1; стрМакс = стрГ;
		КонецЕсли;	
		
		СуммаДопЗатратГ = СуммаДопЗатратГ + Окр(сумма1,2); // Для контроля копеек
		стрГ.Сумма = стрГ.Сумма + Окр(сумма1,2);
	КонецЦикла;
	
	Если СуммаДопЗатратГ<>СуммаДопЗатрат тогда   //исправление ошибок округления
		 стрМакс.Сумма = стрМакс.Сумма + (СуммаДопЗатрат - СуммаДопЗатратГ);
		 #Если Клиент тогда
		 сообщить("Разность "+строка(СуммаДопЗатрат - СуммаДопЗатратГ)+"р. доп.затрат записана в строку № "+строка(стрМакс.НомерСтроки));
		 #КонецЕсли	 
	КонецЕсли;
	
КонецПроцедуры	


//при вводе на основании -> ТребованиеНакладная
Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	Ответственный = ПараметрыСеанса.ТекущийПользователь;
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.ТребованиеНакладная") Тогда
		// Заполнение шапки
		Комментарий = "По тр.накладной № "+ДанныеЗаполнения.Номер+" от "+формат(ДанныеЗаполнения.Дата,"ДЛФ=D");
		Организация   = ДанныеЗаполнения.Организация;
		Подразделение = ДанныеЗаполнения.Подразделение;
		
		СкладГотовойПродукции = ДанныеЗаполнения.Склад; //куда всё скинули...
		
		Для Каждого ТекСтрокаПродукция Из ДанныеЗаполнения.Продукция Цикл
			НоваяСтрока = ГотоваяПродукция.Добавить();
			НоваяСтрока.Количество   = ТекСтрокаПродукция.Количество;
			НоваяСтрока.Номенклатура = ТекСтрокаПродукция.Номенклатура;
			НоваяСтрока.Сумма        = ТекСтрокаПродукция.ПлановаяСтоимость;
		КонецЦикла;
		
		Запрос = новый Запрос; // сумма незавершёнки только в регистре! 
		запрос.Текст = "ВЫБРАТЬ
		               |	НезавершенноеПроизводствоОбороты.Номенклатура,
		               |	НезавершенноеПроизводствоОбороты.КоличествоОборот как Количество,
		               |	НезавершенноеПроизводствоОбороты.СуммаОборот как Сумма
		               |ИЗ
		               |	РегистрНакопления.НезавершенноеПроизводство.Обороты(&НачДата, &КонДата, Регистратор, ) КАК НезавершенноеПроизводствоОбороты
		               |ГДЕ
		               |	НезавершенноеПроизводствоОбороты.Регистратор = &Регистратор";
		запрос.УстановитьПараметр("Регистратор", ДанныеЗаполнения);
		запрос.УстановитьПараметр("НачДата", ДанныеЗаполнения.Дата);
		запрос.УстановитьПараметр("КонДата", ДанныеЗаполнения.Дата+1);
		результат = запрос.Выполнить();
		Если результат.Пустой() тогда
			Для каждого выборка из ДанныеЗаполнения.Материалы цикл  // прямо из ТЧ.
			НоваяСтрока = Материалы.Добавить();
			НоваяСтрока.Номенклатура = выборка.Номенклатура;
			НоваяСтрока.Количество   = выборка.Количество; 
			//суммы НЕТ!
			КонецЦикла;	
		Иначе	
			выборка = результат.Выбрать(); 
			пока выборка.Следующий() цикл
			НоваяСтрока = Материалы.Добавить();
			НоваяСтрока.Номенклатура = выборка.Номенклатура;
			НоваяСтрока.Количество   = выборка.Количество;
			НоваяСтрока.Сумма        = выборка.Сумма;
			КонецЦикла;
		КонецЕсли;
		
		//по первой строке (все статьи должны быть одинаковые!
		СтатьяМатЗатрат    = ДанныеЗаполнения.Материалы[0].статьяЗатрат;
		СтатьяМатЗатратУПР = ДанныеЗаполнения.Материалы[0].статьяЗатратУПР;
		
	СпособРаспределенияДопЗатрат = перечисления.СпособыРаспределенияДопРасходов.ПоСумме;
		
	КонецЕсли;
	
	//{{__КОНСТРУКТОР_ВВОД_НА_ОСНОВАНИИ
	// Данный фрагмент построен конструктором.
	// При повторном использовании конструктора, внесенные вручную изменения будут утеряны!!!
	
	//}}__КОНСТРУКТОР_ВВОД_НА_ОСНОВАНИИ
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если РежимЗаписи <> РежимЗаписиДокумента.ОтменаПроведения тогда
	мРасчетСебестоимостиГотовойПродукции();
	ПроверитьСуммуГотПрод(Отказ);
	КонецЕсли;

	//+++ 05.08.2018 только по [v]БУ               и только при проведении из формы?
	флВыгружатьвБП = (ОтражатьВБухгалтерскомУчете);  // и мПроведениеИзФормы
	Если флВыгружатьвБП тогда 
		ЗарегистрироватьОбъект(ЭтотОбъект, Отказ, флВыгружатьвБП );
	КонецЕсли;

КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, Режим)
	
	КачествоНовый = справочники.Качество.Новый;
	
	//{{__КОНСТРУКТОР_ДВИЖЕНИЙ_РЕГИСТРОВ
	// Данный фрагмент построен конструктором.
	// При повторном использовании конструктора, внесенные вручную изменения будут утеряны!!!

	//1) регистр НезавершенноеПроизводство Расход - ВСЕ материалы списываются!  ---------------------
	Движения.НезавершенноеПроизводство.Записывать = Истина;
	Движения.НезавершенноеПроизводство.Очистить();
	Для Каждого ТекСтрокаМатериалы Из Материалы Цикл   
		Движение = Движения.НезавершенноеПроизводство.Добавить();
		Движение.ВидДвижения = ВидДвиженияНакопления.Расход;
		Движение.Период = Дата;
		Движение.Номенклатура = ТекСтрокаМатериалы.Номенклатура;
		Движение.Количество   = ТекСтрокаМатериалы.Количество;
		Движение.Сумма        = ТекСтрокаМатериалы.Сумма;     // сумма вторична!
	КонецЦикла;

	//2) регистр Затраты  - СТОРНИРУЮТСЯ!------------------------------------------------------------ 
	Движения.Затраты.Записывать = Истина;
	Движения.Затраты.Очистить();
	//+++ все мат.затраты - списываются одной суммой!
	Если НЕ НомГруппаЗатрат.Пустая() тогда //обязательное поле для учёта затрат!
		Движение = Движения.Затраты.Добавить();
		Движение.Период = Дата;
		Движение.Подразделение = Подразделение;
		Движение.СтатьяЗатрат 	 = СтатьяМатЗатрат;
		Движение.СтатьяЗатратУпр = СтатьяМатЗатратУПР;
		Движение.НоменклатурнаяГруппа = НомГруппаЗатрат;
		Движение.Сумма = -Материалы.Итог("Сумма");
	КонецЕсли;
	
	//+++ доп.затраты - СТОРНО! +++	   ВСЕ доп.затраты списываются!
	Для Каждого ТекСтрокаДопЗатрат Из ДопЗатраты Цикл
		Движение = Движения.Затраты.Добавить();
		Движение.Период = Дата;
		Движение.Подразделение = Подразделение;
		Движение.СтатьяЗатрат 	 = ТекСтрокаДопЗатрат.СтатьяЗатрат;
		Движение.СтатьяЗатратУпр = ТекСтрокаДопЗатрат.СтатьяЗатратУПР;
		Движение.НоменклатурнаяГруппа = НомГруппаЗатрат;
		Движение.Сумма = -ТекСтрокаДопЗатрат.Сумма;
	КонецЦикла;	
		
//================================ВЫПУСК ПРОДУКЦИИ ===========================	

//3) регистр ПартииТоваровНаСкладах -------------------------------------------------
	// сумма = сумма мат. + доп. затрат !
	Движения.ПартииТоваровНаСкладах.Записывать = Истина;
	Движения.ПартииТоваровНаСкладах.Очистить();
		
	СдвигатьПоследовательностьПартий = ЛОЖЬ;   //+++ 20.07.2018 - регистрация а Последовательности ?!
	УчетнаяПолитика = РегистрыСведений.УчетнаяПолитика.ПолучитьПоследнее(Дата);
	Если УчетнаяПолитика.СписыватьПартииПриПроведенииДокументов Тогда

		//--- РАСХОД все материалы - списываются датой выпуска!  уже сделан в Требовании-накладной?!
		//Для Каждого ТекСтрока Из Материалы Цикл
		//	Движение = Движения.ПартииТоваровНаСкладах.Добавить();
		//	Движение.ВидДвижения = ВидДвиженияНакопления.Расход;
		//	Движение.Период = Дата;
		//	Движение.Склад  = СкладГотовойПродукции;
		//	Движение.Качество     = КачествоНовый;
		//	Движение.Номенклатура = ТекСтрока.Номенклатура;
		//	Движение.Количество   = ТекСтрока.Количество;
		//	Движение.Стоимость    = ТекСтрока.Сумма;
		//КонецЦикла;
		//+++ Приход - Готовой продукции (сумма больше!)
		Для Каждого ТекСтрокаГотоваяПродукция Из ГотоваяПродукция Цикл
			Движение = Движения.ПартииТоваровНаСкладах.Добавить();
			Движение.ВидДвижения = ВидДвиженияНакопления.Приход;
			Движение.Период = Дата;
			Движение.Склад  = СкладГотовойПродукции;
			Движение.Качество     = КачествоНовый;
			Движение.Номенклатура = ТекСтрокаГотоваяПродукция.Номенклатура;
			Движение.Количество = ТекСтрокаГотоваяПродукция.Количество;
			Движение.Стоимость = ТекСтрокаГотоваяПродукция.Сумма;
		КонецЦикла;

		Если СдвигатьПоследовательностьПартий и ОтражатьВУправленческомУчете Тогда
			ЗаписьРегистрации = ПринадлежностьПоследовательностям.ПартионныйУчет.Добавить();
			ЗаписьРегистрации.Период      = Дата;
			ЗаписьРегистрации.Регистратор = Ссылка;
		КонецЕсли;

	Иначе  // сдвиг Последовательности

		// В неоперативном режиме границы последовательностей сдвигаются назад, если они позже документа.
		Если СдвигатьПоследовательностьПартий и Режим = РежимПроведенияДокумента.Неоперативный Тогда
			СдвигГраницыПоследовательностиПартионногоУчетаНазад(Дата, Ссылка, Организация, ОтражатьВУправленческомУчете, ОтражатьВБухгалтерскомУчете, ОтражатьВНалоговомУчете)
		КонецЕсли;

	КонецЕсли;
	    	
	//4) регистр ТоварыНаСкладах Приход --------------------------------
	Движения.ТоварыНаСкладах.Записывать = Истина;
	Движения.ТоварыНаСкладах.Очистить();
	//--- Расход материалов    уже сделан в Требовании-накладной?!
	//Для Каждого ТекСтрока Из Материалы Цикл
	//	Движение = Движения.ТоварыНаСкладах.Добавить();
	//	Движение.ВидДвижения = ВидДвиженияНакопления.Расход;
	//	Движение.Период = Дата;
	//	Движение.Склад  = СкладГотовойПродукции;
	//	Движение.Качество     = КачествоНовый;
	//	Движение.Номенклатура = ТекСтрокаГотоваяПродукция.Номенклатура;
	//	Движение.Количество   = ТекСтрокаГотоваяПродукция.Количество;
	//КонецЦикла;
	//+++ Приход - Готовой продукции (сумма больше!)
	Для Каждого ТекСтрокаГотоваяПродукция Из ГотоваяПродукция Цикл
		Движение = Движения.ТоварыНаСкладах.Добавить();
		Движение.ВидДвижения = ВидДвиженияНакопления.Приход;
		Движение.Период = Дата;
		Движение.Склад  = СкладГотовойПродукции;
		Движение.Качество     = КачествоНовый;
		Движение.Номенклатура = ТекСтрокаГотоваяПродукция.Номенклатура;
		Движение.Количество   = ТекСтрокаГотоваяПродукция.Количество;
	КонецЦикла;

	//5) регистр ТоварыОрганизаций------------------------------------------------
	Движения.ТоварыОрганизаций.Записывать = Истина;
	Движения.ТоварыОрганизаций.Очистить();
	//--- Расход материалов   уже сделан в Требовании-накладной?!
	//Для Каждого ТекСтрока Из Материалы Цикл
	//	Движение = Движения.ТоварыОрганизаций.Добавить();
	//	Движение.ВидДвижения = ВидДвиженияНакопления.Расход;
	//	Движение.Период = Дата;
	//	Движение.Организация = Организация;
	//	Движение.Качество     = КачествоНовый;
	//	Движение.Номенклатура = ТекСтрока.Номенклатура;
	//	Движение.Количество   = ТекСтрока.Количество;
	//КонецЦикла;
    //+++ Приход готовой продукции
	Для Каждого ТекСтрокаГотоваяПродукция Из ГотоваяПродукция Цикл
		Движение = Движения.ТоварыОрганизаций.Добавить();
		Движение.ВидДвижения = ВидДвиженияНакопления.Приход;
		Движение.Период = Дата;
		Движение.Организация = Организация;
		Движение.Качество     = КачествоНовый;
		Движение.Номенклатура = ТекСтрокаГотоваяПродукция.Номенклатура;
		Движение.Количество   = ТекСтрокаГотоваяПродукция.Количество;
	КонецЦикла;

	//}}__КОНСТРУКТОР_ДВИЖЕНИЙ_РЕГИСТРОВ
	
	//+++( 08.10.2018 ---> Задача № 56106 
	сввоБылВыпуск = ПланыВидовХарактеристик.СвойстваОбъектов.НайтиПоКоду("90355");
	табл = ГотоваяПродукция.Выгрузить(,"Номенклатура");
	
	//---- 09.10.2018 для всех подобных дисков (производитель+модель+типоразмер) 
	//табл.Свернуть("Номенклатура");
	масТов = табл.выгрузитьКолонку("Номенклатура");
	табл   = ПолучитьПодобныеТовары(масТов);
	Для Каждого стр1 Из табл Цикл
		регСв = РегистрыСведений.ЗначенияСвойствОбъектов.СоздатьМенеджерЗаписи();		
		регСв.Объект = стр1.Номенклатура;
		регСв.Свойство = сввоБылВыпуск;
		регСв.Значение = Истина;
		регСв.Записать(истина);  //перезапись уже установленного св-ва
		#Если Клиент тогда
		сообщить(стр1.Код+" "+строка(стр1.НоменклатураПредставление)+" - ВКЛючено св-во "+строка(сввоБылВыпуск));	
		#КонецЕсли	
	КонецЦикла;
	#Если Клиент тогда
		сообщить(строка(табл.Количество())+" товаров установлено св-во "+строка(сввоБылВыпуск));	
	#КонецЕсли	
	//+++)
	
КонецПроцедуры

функция ПолучитьПодобныеТовары(масНом)
	 Запрос = Новый Запрос;
	 Запрос.Текст = "ВЫБРАТЬ РАЗЛИЧНЫЕ
        |	Номенклатура.Производитель,
        |	Номенклатура.Модель,
        |	Номенклатура.Типоразмер
        |ПОМЕСТИТЬ ВТ_Ном
        |ИЗ
        |	Справочник.Номенклатура КАК Номенклатура
        |ГДЕ
        |	Номенклатура.Ссылка В (&масНом)
        |;
        |
        |////////////////////////////////////////////////////////////////////////////////
        |ВЫБРАТЬ
        |	спрНоменклатура.Ссылка КАК Номенклатура,
        |	Представление(спрНоменклатура.Ссылка) КАК НоменклатураПредставление,
        |	спрНоменклатура.Код КАК Код
        |ИЗ
        |	Справочник.Номенклатура КАК спрНоменклатура
        |ГДЕ
        |	спрНоменклатура.Производитель В (ВЫБРАТЬ вт.Производитель ИЗ ВТ_Ном КАК вт)
        |	И спрНоменклатура.Модель      В (ВЫБРАТЬ вт.Модель ИЗ ВТ_Ном КАК вт)
        |	И спрНоменклатура.Типоразмер  В (ВЫБРАТЬ вт.Типоразмер ИЗ ВТ_Ном КАК вт)
        |	И спрНоменклатура.ПометкаУдаления = ЛОЖЬ";
	 Запрос.УстановитьПараметр("масНом", масНом);
	 
	 Результат = Запрос.Выполнить();
	 табл = Результат.Выгрузить();	
	 возврат табл;
КонецФункции
 
Процедура ОбработкаУдаленияПроведения(Отказ)
	
	//+++( 08.10.2018 ---> Задача № 56106 --- установка св-ва "Был Выпуск" ---
	сввоБылВыпуск = ПланыВидовХарактеристик.СвойстваОбъектов.НайтиПоКоду("90355");
	табл = ГотоваяПродукция.Выгрузить(,"Номенклатура");
	//---- 09.10.2018 для всех подобных дисков (производитель+модель+типоразмер) 
    //	табл.Свернуть("Номенклатура");
	масТов = табл.выгрузитьКолонку("Номенклатура");
	табл   = ПолучитьПодобныеТовары(масТов);
	Для Каждого стр1 Из табл Цикл
		регСв = РегистрыСведений.ЗначенияСвойствОбъектов.СоздатьМенеджерЗаписи();		
		регСв.Объект = стр1.Номенклатура;
		регСв.Свойство = сввоБылВыпуск;
		регСв.Значение = ЛОЖЬ;
		регСв.Записать(истина);  //перезапись уже установленного св-ва
		#Если Клиент тогда
		сообщить(стр1.Код+" "+строка(стр1.НоменклатураПредставление)+" - ВЫКЛючено св-во "+строка(сввоБылВыпуск));	
		#КонецЕсли	
	КонецЦикла;
	#Если Клиент тогда
		сообщить(строка(табл.Количество())+" товаров ВЫКЛючено св-во "+строка(сввоБылВыпуск));	
	#КонецЕсли	
	//+++)

КонецПроцедуры

мПроведениеИзФормы = Ложь;