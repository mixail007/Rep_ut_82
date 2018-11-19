﻿
Процедура КнопкаВыполнитьНажатие(Кнопка)
	ЭтаФорма.Закрыть();
		
	// Вставить содержимое обработчика.
КонецПроцедуры

Процедура ПриОткрытии()
	
	Если Маршруты.Количество()=0 Тогда
		
		запрос = Новый запрос;
		запрос.УстановитьПараметр("Подразделения",ЭтотОбъект.СписокПодразделений);
		запрос.Текст = "ВЫБРАТЬ
		               |	НовМаршруты.Ссылка КАК маршрут,
		               |	ЛОЖЬ КАК Пометка
		               |ИЗ
		               |	Справочник.НовМаршруты КАК НовМаршруты
		               |ГДЕ
		               |	НовМаршруты.ПометкаУдаления = ЛОЖЬ
		               |	И НовМаршруты.Подразделение в (&Подразделения)";
		Рез = Запрос.Выполнить().Выгрузить();
		
		Маршруты.Загрузить(Рез);

	КонецЕсли;	
		
КонецПроцедуры
