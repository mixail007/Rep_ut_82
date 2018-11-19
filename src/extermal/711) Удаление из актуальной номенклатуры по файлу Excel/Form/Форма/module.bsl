﻿

Процедура Кнопка3Нажатие(Элемент)
	
	ДиалогВыбораФайла = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Открытие);
	
	ДиалогВыбораФайла.Заголовок = "Прочитать табличный документ из файла";
	ДиалогВыбораФайла.Фильтр    = "Лист Excel (*.xls)|*.xls";
	Если ДиалогВыбораФайла.Выбрать() Тогда
		
		//		ТабличныйДокумент = ЭлементыФормы.ТабличныйДокумент;
		ФайлНаДиске = Новый Файл(ДиалогВыбораФайла.ПолноеИмяФайла);
		Если нРег(ФайлНаДиске.Расширение) = ".xls" Тогда
			мПрочитатьТабличныйДокументИзExcel(ДиалогВыбораФайла.ПолноеИмяФайла,1);
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

Функция мПрочитатьТабличныйДокументИзExcel(ИмяФайла, НомерЛистаExcel = 1) Экспорт
	
	//НачатьТранзакцию();
	
	xlLastCell = 11;
	
	ВыбФайл = Новый Файл(ИмяФайла);
	Если НЕ ВыбФайл.Существует() Тогда
		Сообщить("Файл не существует!");
		Возврат Ложь;
	КонецЕсли;
	
	Попытка
		Excel = Новый COMОбъект("Excel.Application");
		Excel.WorkBooks.Open(ИмяФайла);
		Состояние("Обработка файла Microsoft Excel...");
		ExcelЛист = Excel.Sheets(1);
	Исключение
		Сообщить("Ошибка. Возможно неверно указан номер листа книги Excel.");
		Возврат ложь;
		
	КонецПопытки;	
	
	ActiveCell = Excel.ActiveCell.SpecialCells(xlLastCell);
	RowCount = ActiveCell.Row;
	Если ЭлементыФормы.ПерваяСтрока.Значение > RowCount тогда
		ЭлементыФормы.ПерваяСтрока.Значение = RowCount;
	КонецЕсли;	
	
	
	ColumnCount = ActiveCell.Column;
	
	Сообщить("Найдено "+строка(RowCount)+" строк и "+строка(ColumnCount)+" столбцов");
		
	Если ЭлементыФормы.перваяСтрока.Значение = 0 тогда
		ЭлементыФормы.перваяСтрока.Значение = 2; 
	КонецЕсли;
	
	сообщить("Начало ----------"+строка(ТекущаяДата())+"---------" );
	
	Для Row = перваяСтрока По КоличествоСтрок Цикл
		
		ОбработкаПрерыванияПользователя();
		
		Состояние("Идет обработка файла Excel: "+строка(Row)+" / "+строка(RowCount)+" ("+строка(окр(Row*100/RowCount,1))+"%)");
		
		Номенклатура = Справочники.Номенклатура.НайтиПоКоду(СокрЛП(Формат(ExcelЛист.Cells(Row,1).Value, "ЧГ=0"))); 
		
		Если ЭтоЭкспорт Тогда
			НаборЗаписей = РегистрыСведений.СезонныйАссортиментЭкспорт.СоздатьНаборЗаписей();
			НаборЗаписей.Отбор.Номенклатура.Установить(Номенклатура);
			НаборЗаписей.Записать();
			Сообщить(Номенклатура.Код);
		Иначе
			НаборЗаписей = РегистрыСведений.СезонныйАссортимент.СоздатьНаборЗаписей();
			НаборЗаписей.Отбор.Номенклатура.Установить(Номенклатура);
			НаборЗаписей.Записать();
			Сообщить(Номенклатура.Код);
		КонецЕсли;
		
	КонецЦикла;
	
	//ЗафиксироватьТранзакцию();
	
	Excel.WorkBooks.Close();
	Excel = 0;
	сообщить("Конец--------"+строка(ТекущаяДата())+"-------" );	
	Возврат Истина;
	
КонецФункции // ()

