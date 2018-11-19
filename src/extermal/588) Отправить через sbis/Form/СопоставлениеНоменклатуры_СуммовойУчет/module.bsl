﻿&НаКлиенте
Функция НайтиНоменклатуруПоставщикаПоТабличнойЧасти(стрКонтрагент, знач мТаблДок, КаталогНастроек, Ини) Экспорт
// получает контрагента 1С по структуре Контрагента СБИС, вызывает функцию поиска номенклатуры на сервере 
	сч=0;
	СтрСтрок = Новый Структура;
	Для Каждого СтрТабл Из мТаблДок Цикл
		стр = Новый Структура;
		Стр.Вставить("Название",СтрТабл.Название);
		Стр.Вставить("Идентификатор",СтрТабл.Идентификатор);
		
		СтрСтрок.Вставить("СтрТабл_"+Строка(Сч),Стр);
		Сч=сч+1;
	КонецЦикла;
	
	Возврат НайтиНоменклатуруПоставщикаПоТабличнойЧастиНаСервере(стрКонтрагент,СтрСтрок, КаталогНастроек, Ини.Конфигурация);
КонецФункции
Функция НайтиНоменклатуруПоставщикаПоТабличнойЧастиНаСервере(стрКонтрагент,стрНоменклатураПоставщикаВсе, КаталогНастроек, ИниКонфигурация) Экспорт
// ищет запись с определенной номенклатурой поставщика по реквизитам, указанным в файле настроек
// возвращает структуру с полями Номенклатура и Характеристика	
	Результат = НайтиНоменклатуруПоставщикаНаСервере(ИниКонфигурация);
	Для Каждого стрНоменклатураПоставщика Из стрНоменклатураПоставщикаВсе Цикл	
		стрНоменклатураПоставщика.Значение.Вставить("НоменклатураПоставщика",Результат);	
	КонецЦикла;
	Возврат стрНоменклатураПоставщикаВсе; 
КонецФункции
&НаКлиенте
Функция НайтиНоменклатуруПоставщика(стрКонтрагент, стрНоменклатураПоставщика, КаталогНастроек, Ини) Экспорт
// Функция сопоставляет любую номенклатуру поставщика с одной единственной номенклатурой нашей организации по коду
	Возврат НайтиНоменклатуруПоставщикаНаСервере(Ини.Конфигурация);	 
КонецФункции
Функция НайтиНоменклатуруПоставщикаНаСервере(ИниКонфигурация) Экспорт
// Функция сопоставляет любую номенклатуру поставщика с одной единственной номенклатурой нашей организации по коду

	Результат = Новый Структура("Номенклатура, Характеристика");
	Если Не ИниКонфигурация.Свойство("СуммовойУчетКодНоменклатуры") Тогда
		Возврат Неопределено;	
	КонецЕсли;
	КодНоменклатуры = СтрЗаменить(ИниКонфигурация.СуммовойУчетКодНоменклатуры.Значение,"'","");
	
	Если КодНоменклатуры <> "" Тогда
		НайденнаяСсылка = Справочники.Номенклатура.НайтиПоКоду(КодНоменклатуры);
		Результат.Номенклатура = НайденнаяСсылка;
		Возврат Результат;
	Иначе 
		Возврат Неопределено;
	КонецЕсли;
	 
КонецФункции
Процедура УстановитьСоответствиеНоменклатуры(стрКонтрагент, стрНоменклатураПоставщика, КаталогНастроек, Ини) Экспорт
// Процедура упразднена, т.к. сопоставление не ведется 	
КонецПроцедуры
Функция ПолучитьИдентификаторНоменклатурыПоставщика(стрКонтрагент, стрНоменклатура, КаталогНастроек, Ини) Экспорт
// Процедура упразднена, т.к. сопоставление не ведется	
	Возврат "";
КонецФункции