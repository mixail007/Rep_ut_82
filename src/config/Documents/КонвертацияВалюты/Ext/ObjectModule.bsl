﻿
Процедура ОбработкаПроведения(Отказ, РежимПроведения)
		Если не ЗначениеЗаполнено(РасчетныйСчетДт) тогда
		Сообщить("Не заполнен расчетный счет по продаже валюты!");
		отказ =Истина;
	конецЕсли;	
	Если не ЗначениеЗаполнено(РасчетныйСчетКт) тогда
		Сообщить("Не заполнен расчетный счет по покупке валюты!");
		отказ =Истина;
	конецЕсли;	

	Если не отказ  тогда
	Движения.ДвиженияДенежныхСредств.Записывать = Истина;
	Движения.ДвиженияДенежныхСредств.Очистить();
	Движение = Движения.ДвиженияДенежныхСредств.Добавить();
	Движение.Период = Дата;
	Движение.ВидДенежныхСредств = Перечисления.ВидыДенежныхСредств.Безналичные;
	Движение.ПриходРасход = Перечисления.ВидыДвиженийПриходРасход.Расход;
	Движение.СтатьяДвиженияДенежныхСредств = Справочники.СтатьиДвиженияДенежныхСредств.ПеречислениеМеждуСчетами;
	Движение.ДокументДвижения = Ссылка;
	Движение.БанковскийСчетКасса = РасчетныйСчетДт;
	Движение.Сумма = СуммаДт;
	Движение.СуммаУпр = СуммаУпрДт;

	Движение = Движения.ДвиженияДенежныхСредств.Добавить();
	Движение.Период = Дата;
	Движение.ВидДенежныхСредств = Перечисления.ВидыДенежныхСредств.Безналичные;
	Движение.ПриходРасход = Перечисления.ВидыДвиженийПриходРасход.Приход;
	Движение.СтатьяДвиженияДенежныхСредств = Справочники.СтатьиДвиженияДенежныхСредств.ПеречислениеМеждуСчетами;
	Движение.ДокументДвижения = Ссылка;
	Движение.БанковскийСчетКасса = РасчетныйСчетКт;
	Движение.Сумма = СуммаКт;
	Движение.СуммаУпр = СуммаУпрКт;
	
	Движения.ДенежныеСредства.Записывать = Истина;
	Движения.ДенежныеСредства.Очистить();
	Движение = Движения.ДенежныеСредства.Добавить();
	Движение.ВидДвижения = ВидДвиженияНакопления.Расход;
	Движение.Период = Дата;
	Движение.БанковскийСчетКасса = РасчетныйСчетДт;
	Движение.ВидДенежныхСредств = Перечисления.ВидыДенежныхСредств.Безналичные;
	Движение.Сумма = СуммаДт;
	Движение.СуммаУпр = СуммаУпрДт;

	Движение = Движения.ДенежныеСредства.Добавить();
	Движение.ВидДвижения = ВидДвиженияНакопления.Приход;
	Движение.Период = Дата;
	Движение.БанковскийСчетКасса = РасчетныйСчетКт;
	Движение.ВидДенежныхСредств = Перечисления.ВидыДенежныхСредств.Безналичные;
	Движение.Сумма = СуммаКт;
	Движение.СуммаУпр = СуммаУпрКт;

	конецЕсли;
КонецПроцедуры
  	
