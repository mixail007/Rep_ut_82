﻿
Процедура КнопкаВыполнитьНажатие(Кнопка)
	//ЭлементыФормы.ПолеТабличногоДокумента.Записать("c:\"+ИмяФайлаСообщения,ТипФайлаТабличногоДокумента.XLS);
	//врФТП = Новый FTPСоединение("83.102.251.100",,"yst76", "yst76admin",, Истина );
	
		// Выгрузка остатков на ответ. хранении Автошина
		
	ИмяФайлаСообщения ="claim.xls";
	ТабДокумент = ОбменДаннымиСWebСайтом.СформироватьФормуЗаявкиДляАвтошины();
        
    ТабДокумент.Записать("c:\"+ИмяФайлаСообщения, ТипФайлаТабличногоДокумента.XLS);
	врФТП = Новый FTPСоединение("83.102.251.100",,"yst76", "yst76admin",, Истина );
	Если врФТП = Неопределено Тогда
		Сообщить( "Во время обмена данными произошла ошибка при подключении	к FTP. " + ОписаниеОшибки());
	КонецЕсли;

	
	врФТП.Записать("c:\"+ИмяФайлаСообщения , "data/"+ИмяФайлаСообщения);
	
		// Выгрузка остатков на ответ. хранении Дальнобой
		
	ИмяФайлаСообщения ="dnb.xls";
	ТабДокумент = ОбменДаннымиСWebСайтом.СформироватьФормуЗаявкиДляДальнобой();
        
    ТабДокумент.Записать("c:\"+ИмяФайлаСообщения, ТипФайлаТабличногоДокумента.XLS);
	врФТП = Новый FTPСоединение("83.102.251.100",,"yst76", "yst76admin",, Истина );
	Если врФТП = Неопределено Тогда
		Сообщить( "Во время обмена данными произошла ошибка при подключении	к FTP. " + ОписаниеОшибки());
	КонецЕсли;

	
	врФТП.Записать("c:\"+ИмяФайлаСообщения , "data/"+ИмяФайлаСообщения);

КонецПроцедуры
