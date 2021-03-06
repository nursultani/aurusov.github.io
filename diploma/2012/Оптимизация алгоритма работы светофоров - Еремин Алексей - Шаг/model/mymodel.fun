$Constant
	Шаг_интегрирования     : real = 0.02 // в секундах. чем меньше будет эта константа, тем дольше но точнеее будет прогон
	Коэффициент            : real = 8.3333 // увеличение масштаба: в 1 метре столько пикселей (25/3 = 8.333)
	Максимальная_скорость  : real = 92.5926// пиксели в секунду, приблизительно 40 км/ч, большую скорость водители себе не позволяют
	Время_разгона_до_макс  : real = 3.0 // секунды
	Время_торможения_с_макс: real = 2.0 // секунды
	Запас                  : real = 33.3333 // в пикселях. расстояние, на котором должны оказаться машина до препятствия (с целью не врезаться в стену), с учетом длины машины (примерно 3 метра)
	Красный_свет_1         : real = 144.0 // секунды
	Зеленый_свет_2         : real = 144.0 // секунды
	Зеленый_свет_4         : real = 140.0 // секунды
	Желтый_свет            : real = 4.0  // секунды
	Зеленый_свет_1         : real = 16.0 // секунды
	Красный_свет_2         : real = 20.0 // секунды
	Красный_свет_4         : real = 20.0 // секунды
	Красный_свет_3         : real = 144.0 // секунды
	Зеленый_свет_3   	   : real = 16.0 // секунды
	Время_подъезжания      : real = 2.0 // секунды
	Дистанция              : real = 3.3333 // в пикселях. Нужно для того, чтобы машины не ехали друг за другом впритык на макс. скорости - это не реалистично, хотя идеально
$End

$Function Координата_разгона_X: real
$Type = algorithmic
$Parameters
	Начальная_координата: real
	Начальная_скорость  : real
	Направление         : integer
$Body
	if (Направление == 1)
		return Начальная_координата + Начальная_скорость * Шаг_интегрирования + Максимальная_скорость / Время_разгона_до_макс / 2 * Шаг_интегрирования * Шаг_интегрирования; // по формуле S = V0 * t + a * t^2 / 2
	if (Направление == 2)
		return Начальная_координата;
	if (Направление == 3)
		return Начальная_координата - Начальная_скорость * Шаг_интегрирования + Максимальная_скорость / Время_разгона_до_макс / 2 * Шаг_интегрирования * Шаг_интегрирования; // знак - т.к. движение влево
	if (Направление == 4)
		return Начальная_координата;
$End

$Function Координата_разгона_Y: real
$Type = algorithmic
$Parameters
	Начальная_координата: real
	Начальная_скорость  : real
	Направление         : integer
$Body
	if (Направление == 2)
		return Начальная_координата + Начальная_скорость * Шаг_интегрирования + Максимальная_скорость / Время_разгона_до_макс / 2 * Шаг_интегрирования * Шаг_интегрирования; // по формуле S = V0 * t + a * t^2 / 2
	if (Направление == 1)
		return Начальная_координата;
	if (Направление == 3)
		return Начальная_координата;
	if (Направление == 4)
		return Начальная_координата - Начальная_скорость * Шаг_интегрирования - Максимальная_скорость / Время_разгона_до_макс / 2 * Шаг_интегрирования * Шаг_интегрирования;
$End

$Function Координата_езды_X: real
$Type = algorithmic
$Parameters
	Координата : real
	Направление: integer
$Body
	if (Направление == 1)
		return Координата + Максимальная_скорость * Шаг_интегрирования;
	if (Направление == 2)
		return Координата;
	if (Направление == 3)
		return Координата - Максимальная_скорость * Шаг_интегрирования;
	if (Направление == 4)
		return Координата;
$End

$Function Координата_езды_Y: real
$Type = algorithmic
$Parameters
	Координата : real
	Направление: integer
$Body
	if (Направление == 2)
		return Координата + Максимальная_скорость * Шаг_интегрирования;
	if (Направление == 1)
		return Координата;
	if (Направление == 3)
		return Координата;
	if (Направление == 4)
		return Координата - Максимальная_скорость * Шаг_интегрирования;
$End

$Function Скорость_разгона: real
$Type = algorithmic
$Parameters
	Начальная_скорость        : real
$Body
	if (Начальная_скорость == 0)
		return Максимальная_скорость / Время_разгона_до_макс * Шаг_интегрирования; // по формуле V = V0 + a * t для начальной скорости равной нулю. Если эту строчку убрать машина правильно не разгонится :)
	if (Начальная_скорость <= Максимальная_скорость - Максимальная_скорость / Время_разгона_до_макс * Шаг_интегрирования) 
		return Начальная_скорость + Максимальная_скорость / Время_разгона_до_макс * Шаг_интегрирования; // по формуле V = V0 + a * t
	if (Начальная_скорость > Максимальная_скорость - Максимальная_скорость / Время_разгона_до_макс * Шаг_интегрирования) // если паттерн может повысить скорость выше максимальной за 1 шаг интегрирования, мы не позволяем
		return Максимальная_скорость;
$End

$Function Расстояние_до_препятствия_правильное: real
$Type = algorithmic
$Parameters
	Скорость: real
$Body
	if (0 == 0)
		return Скорость * Время_торможения_с_макс / 2.0 + Запас; // расстояние, которое остается до препятствия, когда надо начинать тормозить
$End

$Function Координата_торможения_X: real
$Type = algorithmic
$Parameters
	Координата : real
	Скорость   : real
	Направление: integer
$Body
	if (Направление == 1)
		return Координата + Скорость * Шаг_интегрирования - Максимальная_скорость / Время_торможения_с_макс * Шаг_интегрирования * Шаг_интегрирования / 2; // по формуле S = V0 * t - a * t^2 / 2
	if (Направление == 2)
		return Координата;
	if (Направление == 3)
		return Координата - Скорость * Шаг_интегрирования - Максимальная_скорость / Время_торможения_с_макс * Шаг_интегрирования * Шаг_интегрирования / 2;
	if (Направление == 4)
		return Координата;
$End

$Function Координата_торможения_Y: real
$Type = algorithmic
$Parameters
	Координата : real
	Скорость   : real
	Направление: integer
$Body
	if (Направление == 2)
		return Координата + Скорость * Шаг_интегрирования - Максимальная_скорость / Время_торможения_с_макс * Шаг_интегрирования * Шаг_интегрирования / 2; // по формуле S = V0 * t - a * t^2 / 2
	if (Направление == 1)
		return Координата;
	if (Направление == 3)
		return Координата;
	if (Направление == 4)
		return Координата - Скорость * Шаг_интегрирования + Максимальная_скорость / Время_торможения_с_макс * Шаг_интегрирования * Шаг_интегрирования / 2;
$End

$Function Скорость_торможения: real
$Type = algorithmic
$Parameters
	Начальная_скорость : real
$Body
	if (Начальная_скорость >= Максимальная_скорость / Время_торможения_с_макс * Шаг_интегрирования) 
		return Начальная_скорость - Максимальная_скорость / Время_торможения_с_макс * Шаг_интегрирования; 
	if (Начальная_скорость < Максимальная_скорость / Время_торможения_с_макс * Шаг_интегрирования)
		return 0;
$End

$Function Препятствие: integer
$Type = algorithmic
$Parameters
	XКоордината 		 : real
	YКоордината 		 : real
	XКоордината_светофора: real
	YКоордината_светофора: real
	Скорость             : real
	Сигнал               : such_as Светофоры.Сигнал
	Направление          : integer
$Body
	if (Скорость >= sqrt(2 * Максимальная_скорость / Время_торможения_с_макс * ( XКоордината_светофора - XКоордината - Запас)) and XКоордината_светофора > XКоордината and Сигнал == Красный and Направление == 1)
		return 1;
	if (Сигнал == Желтый and abs(XКоордината_светофора - XКоордината - Скорость * Скорость / 2 / Максимальная_скорость * Время_торможения_с_макс) <= Запас and Направление == 1)
		return 1;
	if (Скорость >= sqrt(2 * Максимальная_скорость / Время_торможения_с_макс * (946 - XКоордината)) and YКоордината >= 607.0 and Направление == 1) // надо затормозить перед поворотом
		return 1; 
	if (Направление == 1) //else
		return 0;
	
		
	if (Скорость >= sqrt(2 * Максимальная_скорость / Время_торможения_с_макс * ( YКоордината_светофора - YКоордината - Запас)) and YКоордината_светофора > YКоордината and Сигнал == Красный and Направление == 2)
		return 1;
	if (Сигнал == Желтый and abs(YКоордината_светофора - YКоордината - Скорость * Скорость / 2 / Максимальная_скорость * Время_торможения_с_макс) <= Запас and Направление == 2)
		return 1;
	if (Select(Машины: Машины.Направление == 1 and Машины.YКоордината > 600 and abs(Машины.XКоордината - 500) < Запас).Size() > 0 and Скорость >= sqrt(2 * Максимальная_скорость / Время_торможения_с_макс * (585 - YКоордината)) and Направление == 2)
		return 1; 
	if (Select(Машины: Машины.Направление == 1 and Машины.YКоордината > 600 and abs(Машины.XКоордината - 500) < Запас).Empty() and Скорость >= sqrt(2 * Максимальная_скорость / Время_торможения_с_макс * (607 - YКоордината)) and Направление == 2)
		return 1; 
	if (Направление == 2) //else
		return 0;
		
	if (Скорость >= sqrt(2 * Максимальная_скорость / Время_торможения_с_макс * ( YКоордината - YКоордината_светофора - Запас)) and YКоордината_светофора < YКоордината and Сигнал == Красный and Направление == 4)
		return 1;
	if (Сигнал == Желтый and abs(YКоордината - YКоордината_светофора - Скорость * Скорость / 2 / Максимальная_скорость * Время_торможения_с_макс) <= Запас and YКоордината - YКоордината_светофора < Расстояние_до_препятствия_правильное(Скорость) and YКоордината_светофора < YКоордината and Направление == 4)
		return 1;
	if (Направление == 4) //else
		return 0;
$End

$Function Состояние_1: such_as Машины.Состояние
$Type = algorithmic
$Parameters
	Препятствие          : integer
	XКоордината 		 : real
	YКоордината 		 : real
	XКоордината_светофора: real
	YКоордината_светофора: real
	Скорость             : real
	Сигнал               : such_as Светофоры.Сигнал
	Направление          : integer
$Body
	if (Препятствие <> 0) 
		return ТорможениеВозможно;
	if 	(Направление == 1 and
					(Скорость >= sqrt(2 * Максимальная_скорость / Время_торможения_с_макс * ( XКоордината_светофора - XКоордината - Запас)) and XКоордината_светофора > XКоордината and Сигнал == Красный) or
				(Сигнал == Желтый and abs(XКоордината_светофора - XКоордината - Скорость * Скорость / 2 / Максимальная_скорость * Время_торможения_с_макс) <= Запас) and YКоордината - YКоордината_светофора < Расстояние_до_препятствия_правильное(Скорость) and YКоордината_светофора < YКоордината )
					return ТорможениеВозможно;
	if 	(Направление == 2 and
					((Скорость >= sqrt(2 * Максимальная_скорость / Время_торможения_с_макс * ( YКоордината_светофора - YКоордината - Запас)) and YКоордината_светофора > YКоордината and Сигнал == Красный) or
				(Сигнал == Желтый and abs(YКоордината_светофора - YКоордината - Скорость * Скорость / 2 / Максимальная_скорость * Время_торможения_с_макс) <= Запас and YКоордината_светофора - YКоордината - Запас < Расстояние_до_препятствия_правильное(Скорость))))
					return ТорможениеВозможно;
	if 	(Направление == 4 and
					((Скорость >= sqrt(2 * Максимальная_скорость / Время_торможения_с_макс * ( YКоордината - YКоордината_светофора - Запас)) and YКоордината_светофора < YКоордината and Сигнал == Красный) or
				(Сигнал == Желтый and abs(YКоордината - YКоордината_светофора - Скорость * Скорость / 2 / Максимальная_скорость * Время_торможения_с_макс) <= Запас and YКоордината - YКоордината_светофора - Запас < Расстояние_до_препятствия_правильное(Скорость) and YКоордината > YКоордината_светофора)))
					return ТорможениеВозможно;
	if (Скорость == Максимальная_скорость)
					return ЕздаВозможна;
	if (Скорость < Максимальная_скорость)
					return РазгонВозможен;
$End

$Function Время_переключения_светофора: real
$Type = algorithmic
$Parameters
	Текущий_сигнал: such_as Светофоры.Сигнал
	Направление   : integer
$Body
	if (Текущий_сигнал == Красный and Направление == 1)
		return Красный_свет_1;
	if (Текущий_сигнал == Красный and Направление == 2)
		return Красный_свет_2;
	if (Текущий_сигнал == Красный and Направление == 4)
		return Красный_свет_4;
	if (Текущий_сигнал == Желтый)
		return Желтый_свет;
	if (Текущий_сигнал == Зеленый and Направление == 1)
		return Зеленый_свет_1;
	if (Текущий_сигнал == Зеленый and Направление == 2)
		return Зеленый_свет_2;
	if (Текущий_сигнал == Зеленый and Направление == 4)
		return Зеленый_свет_4;
$End

$Function Новый_сигнал: such_as Светофоры.Сигнал
$Type = algorithmic
$Parameters
	Текущий_сигнал: such_as Светофоры.Сигнал
$Body
	if (Текущий_сигнал == Красный)
		return Зеленый;
	if (Текущий_сигнал == Желтый)
		return Красный;
	if (Текущий_сигнал == Зеленый)
		return Желтый;
$End

$Function Состояние_3: such_as Машины.Состояние
$Type = algorithmic
$Parameters
	Препятствие            : integer
	Направление            : integer
	XКоордината            : real
	YКоордината            : real
	XКоордината_др_машины  : real
	YКоордината_др_машины  : real
	XКоордината_светофора  : real
	YКоордината_светофора  : real
	Скорость               : real
	Скорость_др_машины     : real
	Препятствие_др_машины  : integer
	Сигнал                 : such_as Светофоры.Сигнал
	Куда                   : such_as Машины.Куда
	Откуда                 : such_as Машины.Откуда
$Body
	if (Препятствие <> 0) 
		return ТорможениеВозможно;
		
	if (Направление == 1 and Скорость < Максимальная_скорость and 
				((Препятствие_др_машины == 0  and XКоордината <= XКоордината_др_машины - Запас - Дистанция - (Скорость - Скорость_др_машины) * ((Максимальная_скорость - Скорость_др_машины) / Максимальная_скорость * Время_разгона_до_макс) and XКоордината_светофора > XКоордината_др_машины) or
				(Препятствие_др_машины <> 0 and Скорость < sqrt(Скорость_др_машины * Скорость_др_машины + 2 * Максимальная_скорость / Время_торможения_с_макс * (XКоордината_др_машины - XКоордината - Запас)) and XКоордината_светофора > XКоордината_др_машины) or
				(Сигнал == Зеленый and XКоордината_светофора <= XКоордината_др_машины) or
				(Сигнал == Красный and Скорость < sqrt(2 * Максимальная_скорость / Время_торможения_с_макс * ( XКоордината_светофора - XКоордината - Запас)) and XКоордината_светофора <= XКоордината_др_машины) or
				(Сигнал == Желтый and XКоордината_светофора - XКоордината - Запас <= Скорость * Скорость / 2 / Максимальная_скорость * Время_торможения_с_макс)))
			return РазгонВозможен;
	if (Направление == 1 and Скорость == Максимальная_скорость and 
				((Препятствие_др_машины == 0  and XКоордината <= XКоордината_др_машины - Запас - Дистанция - (Скорость - Скорость_др_машины) * ((Максимальная_скорость - Скорость_др_машины) / Максимальная_скорость * Время_разгона_до_макс) and XКоордината_светофора > XКоордината_др_машины) or
				(Препятствие_др_машины <> 0 and Скорость < sqrt(Скорость_др_машины * Скорость_др_машины + 2 * Максимальная_скорость / Время_торможения_с_макс * (XКоордината_др_машины - XКоордината - Запас)) and XКоордината_светофора > XКоордината_др_машины) or
				(Сигнал == Зеленый and XКоордината_светофора <= XКоордината_др_машины) or
				(Сигнал == Красный and Скорость < sqrt(2 * Максимальная_скорость / Время_торможения_с_макс * ( XКоордината_светофора - XКоордината - Запас)) and XКоордината_светофора <= XКоордината_др_машины) or
				(Сигнал == Желтый and XКоордината_светофора - XКоордината - Запас <= Скорость * Скорость / 2 / Максимальная_скорость * Время_торможения_с_макс)))
			return ЕздаВозможна;
	if (Направление == 1 and 
				 (((abs(XКоордината_светофора - XКоордината) < Запас) or 
				 (Препятствие_др_машины == 0  and XКоордината > XКоордината_др_машины - Запас - (Скорость - Скорость_др_машины) * ((Максимальная_скорость - Скорость_др_машины) / Максимальная_скорость * Время_разгона_до_макс) and XКоордината_светофора > XКоордината_др_машины) or
				 (Препятствие_др_машины <> 0 and Скорость >= sqrt(Скорость_др_машины * Скорость_др_машины + 2 * Максимальная_скорость / Время_торможения_с_макс * (XКоордината_др_машины - XКоордината - Запас)) and XКоордината_светофора > XКоордината_др_машины) or
				 (Сигнал == Красный and Скорость >= sqrt(2 * Максимальная_скорость / Время_торможения_с_макс * ( XКоордината_светофора - XКоордината - Запас)) and XКоордината_светофора <= XКоордината_др_машины) or
				 (Сигнал == Желтый and abs(XКоордината_светофора - XКоордината - Скорость * Скорость / 2 / Максимальная_скорость * Время_торможения_с_макс) <= Запас and YКоордината_светофора <= YКоордината_др_машины) or
				 (Направление == 1 and Сигнал <> Красный and XКоордината_светофора <= XКоордината_др_машины and Скорость >= sqrt(Скорость_др_машины * Скорость_др_машины + 2 * Максимальная_скорость / Время_торможения_с_макс * (XКоордината_др_машины - XКоордината - Запас))))))
			return ТорможениеВозможно;
	
	
	if (Направление == 2 and Скорость < Максимальная_скорость and 
				((Препятствие_др_машины == 0  and YКоордината <= YКоордината_др_машины - Запас - Дистанция - (Скорость - Скорость_др_машины) * ((Максимальная_скорость - Скорость_др_машины) / Максимальная_скорость * Время_разгона_до_макс) and YКоордината_светофора > YКоордината_др_машины) or
				(Препятствие_др_машины <> 0 and Скорость < sqrt(Скорость_др_машины * Скорость_др_машины + 2 * Максимальная_скорость / Время_торможения_с_макс * (YКоордината_др_машины - YКоордината - Запас)) and YКоордината_светофора > YКоордината_др_машины) or
				(Сигнал == Зеленый and YКоордината_светофора <= YКоордината_др_машины) or
				(Сигнал == Красный and Скорость < sqrt(2 * Максимальная_скорость / Время_торможения_с_макс * ( YКоордината_светофора - YКоордината - Запас)) and YКоордината_светофора <= YКоордината_др_машины) or
				(Сигнал == Желтый and YКоордината_светофора - YКоордината - Запас <= Скорость * Скорость / 2 / Максимальная_скорость * Время_торможения_с_макс)))
			return РазгонВозможен;
	if (Направление == 2 and Скорость == Максимальная_скорость and 
				((Препятствие_др_машины == 0  and YКоордината <= YКоордината_др_машины - Запас - Дистанция - (Скорость - Скорость_др_машины) * ((Максимальная_скорость - Скорость_др_машины) / Максимальная_скорость * Время_разгона_до_макс) and YКоордината_светофора > YКоордината_др_машины) or
				(Препятствие_др_машины <> 0 and Скорость < sqrt(Скорость_др_машины * Скорость_др_машины + 2 * Максимальная_скорость / Время_торможения_с_макс * (YКоордината_др_машины - YКоордината - Запас)) and YКоордината_светофора > YКоордината_др_машины) or
				(Сигнал == Зеленый and YКоордината_светофора <= YКоордината_др_машины) or
				(Сигнал == Красный and Скорость < sqrt(2 * Максимальная_скорость / Время_торможения_с_макс * ( YКоордината_светофора - YКоордината - Запас)) and YКоордината_светофора <= YКоордината_др_машины) or
				(Сигнал == Желтый and YКоордината_светофора - YКоордината - Запас <= Скорость * Скорость / 2 / Максимальная_скорость * Время_торможения_с_макс)))
			return ЕздаВозможна;
	if (Направление == 2 and 
				 ((abs(YКоордината_светофора - YКоордината) < Запас) or 
				 (Препятствие_др_машины == 0  and YКоордината > YКоордината_др_машины - Запас - (Скорость - Скорость_др_машины) * ((Максимальная_скорость - Скорость_др_машины) / Максимальная_скорость * Время_разгона_до_макс) and YКоордината_светофора > YКоордината_др_машины) or
				 (Препятствие_др_машины <> 0 and Скорость >= sqrt(Скорость_др_машины * Скорость_др_машины + 2 * Максимальная_скорость / Время_торможения_с_макс * (YКоордината_др_машины - YКоордината - Запас)) and YКоордината_светофора > YКоордината_др_машины) or
				 (Сигнал == Красный and Скорость >= sqrt(2 * Максимальная_скорость / Время_торможения_с_макс * ( YКоордината_светофора - YКоордината - Запас)) and YКоордината_светофора <= YКоордината_др_машины) or
				 (Сигнал == Желтый and abs(YКоордината_светофора - YКоордината - Скорость * Скорость / 2 / Максимальная_скорость * Время_торможения_с_макс) <= Запас and YКоордината_светофора <= YКоордината_др_машины) or
				 (Направление == 2 and Сигнал <> Красный and YКоордината_светофора <= YКоордината_др_машины and Скорость >= sqrt(Скорость_др_машины * Скорость_др_машины + 2 * Максимальная_скорость / Время_торможения_с_макс * (YКоордината_др_машины - YКоордината - Запас)))))
			return ТорможениеВозможно;
	
	
	if (Направление == 4 and Скорость < Максимальная_скорость and 
				((Препятствие_др_машины == 0  and abs(YКоордината - YКоордината_др_машины) <= - Запас - Дистанция - (Скорость - Скорость_др_машины) * ((Максимальная_скорость - Скорость_др_машины) / Максимальная_скорость * Время_разгона_до_макс) and YКоордината_светофора < YКоордината_др_машины) or
				(Препятствие_др_машины <> 0 and Скорость < sqrt(Скорость_др_машины * Скорость_др_машины + 2 * Максимальная_скорость / Время_торможения_с_макс * (YКоордината - YКоордината_др_машины - Запас)) and YКоордината_светофора < YКоордината_др_машины) or
				(Сигнал == Зеленый and YКоордината_светофора >= YКоордината_др_машины) or
				(Сигнал == Красный and Скорость < sqrt(2 * Максимальная_скорость / Время_торможения_с_макс * ( YКоордината - YКоордината_светофора - Запас)) and YКоордината_светофора >= YКоордината_др_машины) or
				(Сигнал == Желтый and YКоордината - YКоордината_светофора - Запас <= Скорость * Скорость / 2 / Максимальная_скорость * Время_торможения_с_макс)))
			return РазгонВозможен;
	if (Направление == 4 and Скорость == Максимальная_скорость and 
				((Препятствие_др_машины == 0  and abs(YКоордината - YКоордината_др_машины) <= - Запас - Дистанция - (Скорость - Скорость_др_машины) * ((Максимальная_скорость - Скорость_др_машины) / Максимальная_скорость * Время_разгона_до_макс) and YКоордината_светофора < YКоордината_др_машины) or
				(Препятствие_др_машины <> 0 and Скорость < sqrt(Скорость_др_машины * Скорость_др_машины + 2 * Максимальная_скорость / Время_торможения_с_макс * (YКоордината - YКоордината_др_машины - Запас)) and YКоордината_светофора < YКоордината_др_машины) or
				(Сигнал == Зеленый and YКоордината_светофора >= YКоордината_др_машины) or
				(Сигнал == Красный and Скорость < sqrt(2 * Максимальная_скорость / Время_торможения_с_макс * ( YКоордината - YКоордината_светофора - Запас)) and YКоордината_светофора >= YКоордината_др_машины) or
				(Сигнал == Желтый and YКоордината - YКоордината_светофора - Запас <= Скорость * Скорость / 2 / Максимальная_скорость * Время_торможения_с_макс)))
			return ЕздаВозможна;
	if (Направление == 4 and 
				 ((abs(YКоордината - YКоордината_светофора) < Запас) or 
				 (Препятствие_др_машины == 0  and YКоордината_др_машины - YКоордината > - Запас - (Скорость - Скорость_др_машины) * ((Максимальная_скорость - Скорость_др_машины) / Максимальная_скорость * Время_разгона_до_макс) and YКоордината_светофора < YКоордината_др_машины) or
				 (Препятствие_др_машины <> 0 and Скорость >= sqrt(Скорость_др_машины * Скорость_др_машины + 2 * Максимальная_скорость / Время_торможения_с_макс * (YКоордината - YКоордината_др_машины - Запас)) and YКоордината_светофора < YКоордината_др_машины) or
				 (Сигнал == Красный and Скорость >= sqrt(2 * Максимальная_скорость / Время_торможения_с_макс * ( YКоордината - YКоордината_светофора - Запас)) and YКоордината_светофора <= YКоордината_др_машины) or
				 (Сигнал == Желтый and abs(YКоордината - YКоордината_светофора - Скорость * Скорость / 2 / Максимальная_скорость * Время_торможения_с_макс) <= Запас and YКоордината_светофора <= YКоордината_др_машины) or
				 (Направление == 2 and Сигнал <> Красный and YКоордината_светофора <= YКоордината_др_машины and Скорость >= sqrt(Скорость_др_машины * Скорость_др_машины + 2 * Максимальная_скорость / Время_торможения_с_макс * (YКоордината_др_машины - YКоордината - Запас)))))
			return ТорможениеВозможно;
	if (Скорость < Максимальная_скорость)
		return РазгонВозможен;
	if (Скорость == Максимальная_скорость)
		return ЕздаВозможна;
$End

$Function Препятствие_3: integer
$Type = algorithmic
$Parameters
	Направление            : integer
	XКоордината            : real
	YКоордината            : real
	XКоордината_др_машины  : real
	YКоордината_др_машины  : real
	XКоордината_светофора  : real
	YКоордината_светофора  : real
	Скорость               : real
	Скорость_др_машины     : real
	Препятствие_др_машины  : integer
	Сигнал                 : such_as Светофоры.Сигнал
	Куда                   : such_as Машины.Куда
	Откуда                 : such_as Машины.Откуда
	Направление_препятствия: integer
$Body
	if (XКоордината_светофора - XКоордината < Запас and XКоордината_светофора < XКоордината_др_машины and Сигнал <> Зеленый and Направление == 1)
		return 1;
	if (XКоордината_др_машины - XКоордината < Запас and Направление == 1)
		return 2;
	if (Препятствие_др_машины == 0  and XКоордината > XКоордината_др_машины - Запас - Дистанция - (Скорость - Скорость_др_машины) * ((Максимальная_скорость - Скорость_др_машины) / Максимальная_скорость * Время_разгона_до_макс) and XКоордината_светофора > XКоордината_др_машины and Направление == 1)
		return 2;
	if (Препятствие_др_машины <> 0 and Скорость >= sqrt(Скорость_др_машины * Скорость_др_машины + 2 * Максимальная_скорость / Время_торможения_с_макс * (XКоордината_др_машины - XКоордината - Запас)) and XКоордината_светофора > XКоордината_др_машины and Направление == 1)
		return 2;
	
	if (Сигнал == Красный and Скорость >= sqrt(2 * Максимальная_скорость / Время_торможения_с_макс * ( XКоордината_светофора - XКоордината - Запас)) and XКоордината_светофора <= XКоордината_др_машины and Направление == 1)
		return 1;
	if (Сигнал == Желтый and abs(XКоордината_светофора - XКоордината - Скорость * Скорость / 2 / Максимальная_скорость * Время_торможения_с_макс) <= Запас and XКоордината_светофора <= XКоордината_др_машины and Направление == 1)
		return 1;
	if (Направление == 1 and Сигнал <> Красный and XКоордината_светофора <= XКоордината_др_машины and Скорость >= sqrt(Скорость_др_машины * Скорость_др_машины + 2 * Максимальная_скорость / Время_торможения_с_макс * (XКоордината_др_машины - XКоордината - Запас)))
		return 2;
	if (Направление == 1 and Направление_препятствия == 2 and Скорость >= sqrt(2 * Максимальная_скорость / Время_торможения_с_макс * (340 - XКоордината)))
		return 1;
	if (Направление == 1)
		return 0;
		
	if (YКоордината_светофора - YКоордината < Запас and YКоордината_светофора < YКоордината_др_машины and Сигнал <> Зеленый and Направление == 2)
		return 1;
	if (YКоордината_др_машины - YКоордината < Запас and Направление == 2)
		return 2;
	if (Препятствие_др_машины == 0  and YКоордината > YКоордината_др_машины - Запас - Дистанция - (Скорость - Скорость_др_машины) * ((Максимальная_скорость - Скорость_др_машины) / Максимальная_скорость * Время_разгона_до_макс) and YКоордината_светофора > YКоордината_др_машины and Направление == 2)
		return 2;
	if (Препятствие_др_машины <> 0 and Скорость >= sqrt(Скорость_др_машины * Скорость_др_машины + 2 * Максимальная_скорость / Время_торможения_с_макс * (YКоордината_др_машины - YКоордината - Запас)) and YКоордината_светофора > YКоордината_др_машины and Направление == 2)
		return 2;
	if (Направление == 2 and Сигнал <> Красный and YКоордината_светофора <= YКоордината_др_машины and Скорость >= sqrt(Скорость_др_машины * Скорость_др_машины + 2 * Максимальная_скорость / Время_торможения_с_макс * (YКоордината_др_машины - YКоордината - Запас)))
		return 2;
	
	if (Сигнал == Красный and Скорость >= sqrt(2 * Максимальная_скорость / Время_торможения_с_макс * ( YКоордината_светофора - YКоордината - Запас)) and YКоордината_светофора <= YКоордината_др_машины and Направление == 2)
		return 1;
	if (Сигнал == Желтый and abs(YКоордината_светофора - YКоордината - Скорость * Скорость / 2 / Максимальная_скорость * Время_торможения_с_макс) <= Запас and Направление == 2 and YКоордината_светофора <= YКоордината_др_машины)
		return 1;
	if (Направление == 2)
		return 0;
		
	if (YКоордината - YКоордината_светофора < Запас and YКоордината_светофора > YКоордината_др_машины and Сигнал <> Зеленый and Направление == 4)
		return 1;
	if (YКоордината - YКоордината_др_машины < Запас and Направление == 4)
		return 2;
	if (Препятствие_др_машины == 0  and YКоордината_др_машины - YКоордината > - Запас - Дистанция - (Скорость - Скорость_др_машины) * ((Максимальная_скорость - Скорость_др_машины) / Максимальная_скорость * Время_разгона_до_макс) and YКоордината_светофора < YКоордината_др_машины and Направление == 4)
		return 2;
	if (Препятствие_др_машины <> 0 and Скорость >= sqrt(Скорость_др_машины * Скорость_др_машины + 2 * Максимальная_скорость / Время_торможения_с_макс * (YКоордината - YКоордината_др_машины - Запас)) and YКоордината_светофора < YКоордината_др_машины and Направление == 4)
		return 2;
	if (Направление == 4 and Сигнал <> Красный and YКоордината_светофора >= YКоордината_др_машины and Скорость >= sqrt(Скорость_др_машины * Скорость_др_машины + 2 * Максимальная_скорость / Время_торможения_с_макс * (YКоордината - YКоордината_др_машины - Запас)))
		return 2;
	
	if (Сигнал == Красный and Скорость >= sqrt(2 * Максимальная_скорость / Время_торможения_с_макс * ( YКоордината - YКоордината_светофора - Запас)) and YКоордината_светофора >= YКоордината_др_машины and Направление == 4)
		return 1;
	if (Сигнал == Желтый and abs(YКоордината - YКоордината_светофора - Скорость * Скорость / 2 / Максимальная_скорость * Время_торможения_с_макс) <= Запас and Направление == 4 and YКоордината_светофора >= YКоордината_др_машины)
		return 1;
	if (Направление == 4)
		return 0;
$End

$Function Препятствие_2: integer
$Type = algorithmic
$Parameters
	XКоордината            : real
	YКоордината            : real
	XКоордината_др_машины  : real
	YКоордината_др_машины  : real
	Скорость               : real
	Скорость_др_машины     : real
	Препятствие_др_машины  : integer
	Направление            : integer
$Body
	if (XКоордината_др_машины - XКоордината < Запас and Направление == 1)
		return 2;
	if (Препятствие_др_машины == 0  and XКоордината > XКоордината_др_машины - Запас - Дистанция - (Скорость - Скорость_др_машины) * ((Максимальная_скорость - Скорость_др_машины) / Максимальная_скорость * Время_разгона_до_макс)  and Направление == 1)
		return 2;
	if (Препятствие_др_машины == 0  and XКоордината <= XКоордината_др_машины - Запас - Дистанция - (Скорость - Скорость_др_машины) * ((Максимальная_скорость - Скорость_др_машины) / Максимальная_скорость * Время_разгона_до_макс) and Направление == 1)
		return 0;
	if (Препятствие_др_машины <> 0 and Скорость >= sqrt(Скорость_др_машины * Скорость_др_машины + 2 * Максимальная_скорость / Время_торможения_с_макс * (XКоордината_др_машины - XКоордината - Запас)) and Направление == 1)
		return 2;
	if (Препятствие_др_машины <> 0 and Скорость < sqrt(Скорость_др_машины * Скорость_др_машины + 2 * Максимальная_скорость / Время_торможения_с_макс * (XКоордината_др_машины - XКоордината - Запас)) and Направление == 1)
		return 0;
		
	if (YКоордината_др_машины - YКоордината < Запас and Направление == 2)
		return 2;
	if (Препятствие_др_машины == 0  and YКоордината > YКоордината_др_машины - Запас - Дистанция - (Скорость - Скорость_др_машины) * ((Максимальная_скорость - Скорость_др_машины) / Максимальная_скорость * Время_разгона_до_макс)  and Направление == 2)
		return 2;
	if (Препятствие_др_машины == 0  and YКоордината <= YКоордината_др_машины - Запас - Дистанция - (Скорость - Скорость_др_машины) * ((Максимальная_скорость - Скорость_др_машины) / Максимальная_скорость * Время_разгона_до_макс) and Направление == 2)
		return 0;
	if (Препятствие_др_машины <> 0 and Скорость >= sqrt(Скорость_др_машины * Скорость_др_машины + 2 * Максимальная_скорость / Время_торможения_с_макс * (YКоордината_др_машины - YКоордината - Запас)) and Направление == 2)
		return 2;
	if (Препятствие_др_машины <> 0 and Скорость < sqrt(Скорость_др_машины * Скорость_др_машины + 2 * Максимальная_скорость / Время_торможения_с_макс * (YКоордината_др_машины - YКоордината - Запас)) and Направление == 2)
		return 0;
		
	if (YКоордината - YКоордината_др_машины < Запас and Направление == 4)
		return 2;
	if (Препятствие_др_машины == 0  and YКоордината_др_машины - YКоордината > - Запас - Дистанция - (Скорость - Скорость_др_машины) * ((Максимальная_скорость - Скорость_др_машины) / Максимальная_скорость * Время_разгона_до_макс)  and Направление == 4)
		return 2;
	if (Препятствие_др_машины == 0  and YКоордината_др_машины - YКоордината <= - Запас - Дистанция - (Скорость - Скорость_др_машины) * ((Максимальная_скорость - Скорость_др_машины) / Максимальная_скорость * Время_разгона_до_макс) and Направление == 4)
		return 0;
	if (Препятствие_др_машины <> 0 and Скорость >= sqrt(Скорость_др_машины * Скорость_др_машины + 2 * Максимальная_скорость / Время_торможения_с_макс * (YКоордината - YКоордината_др_машины - Запас)) and Направление == 4)
		return 2;
	if (Препятствие_др_машины <> 0 and Скорость < sqrt(Скорость_др_машины * Скорость_др_машины + 2 * Максимальная_скорость / Время_торможения_с_макс * (YКоордината - YКоордината_др_машины - Запас)) and Направление == 4)
		return 0;
$End

$Function Состояние_2: such_as Машины.Состояние
$Type = algorithmic
$Parameters
	Препятствие            : integer
	XКоордината            : real
	YКоордината            : real
	XКоордината_др_машины  : real
	YКоордината_др_машины  : real
	Скорость               : real
	Скорость_др_машины     : real
	Препятствие_др_машины  : integer
	Направление            : integer
$Body
	if (Препятствие <> 0) 
		return ТорможениеВозможно;
		
	if (Направление == 1 and Скорость_др_машины > Скорость and Скорость == Максимальная_скорость and
				((Препятствие_др_машины == 0  and XКоордината <= XКоордината_др_машины - Запас - Дистанция - (Скорость - Скорость_др_машины) * ((Максимальная_скорость - Скорость_др_машины) / Максимальная_скорость * Время_разгона_до_макс)) or
				(Препятствие_др_машины <> 0 and Скорость < sqrt(Скорость_др_машины * Скорость_др_машины + 2 * Максимальная_скорость / Время_торможения_с_макс * (XКоордината_др_машины - XКоордината - Запас)))))
					return ЕздаВозможна;
	if (Направление == 2 and Скорость_др_машины > Скорость and Скорость == Максимальная_скорость and
				((Препятствие_др_машины == 0  and YКоордината <= YКоордината_др_машины - Запас - Дистанция - (Скорость - Скорость_др_машины) * ((Максимальная_скорость - Скорость_др_машины) / Максимальная_скорость * Время_разгона_до_макс)) or
				(Препятствие_др_машины <> 0 and Скорость < sqrt(Скорость_др_машины * Скорость_др_машины + 2 * Максимальная_скорость / Время_торможения_с_макс * (YКоордината_др_машины - YКоордината - Запас)))))
					return ЕздаВозможна;
	if (Направление == 4 and Скорость_др_машины > Скорость and Скорость == Максимальная_скорость and
				((Препятствие_др_машины == 0  and YКоордината_др_машины - YКоордината <= - Запас - Дистанция - (Скорость - Скорость_др_машины) * ((Максимальная_скорость - Скорость_др_машины) / Максимальная_скорость * Время_разгона_до_макс)) or
				(Препятствие_др_машины <> 0 and Скорость < sqrt(Скорость_др_машины * Скорость_др_машины + 2 * Максимальная_скорость / Время_торможения_с_макс * (YКоордината - YКоордината_др_машины - Запас)))))
					return ЕздаВозможна;
	if (Направление == 1 and Скорость < Максимальная_скорость and 
				((Препятствие_др_машины == 0  and XКоордината <= XКоордината_др_машины - Запас - Дистанция - (Скорость - Скорость_др_машины) * ((Максимальная_скорость - Скорость_др_машины) / Максимальная_скорость * Время_разгона_до_макс)) or
				(Препятствие_др_машины <> 0 and Скорость < sqrt(Скорость_др_машины * Скорость_др_машины + 2 * Максимальная_скорость / Время_торможения_с_макс * (XКоордината_др_машины - XКоордината - Запас)))))
					return РазгонВозможен;
	if (Направление == 2 and Скорость < Максимальная_скорость and 
				((Препятствие_др_машины == 0  and YКоордината <= YКоордината_др_машины - Запас - Дистанция - (Скорость - Скорость_др_машины) * ((Максимальная_скорость - Скорость_др_машины) / Максимальная_скорость * Время_разгона_до_макс)) or
				(Препятствие_др_машины <> 0 and Скорость < sqrt(Скорость_др_машины * Скорость_др_машины + 2 * Максимальная_скорость / Время_торможения_с_макс * (YКоордината_др_машины - YКоордината - Запас)))))
					return РазгонВозможен;
	if (Направление == 4 and Скорость < Максимальная_скорость and 
				((Препятствие_др_машины == 0  and YКоордината_др_машины - YКоордината <= - Запас - Дистанция - (Скорость - Скорость_др_машины) * ((Максимальная_скорость - Скорость_др_машины) / Максимальная_скорость * Время_разгона_до_макс)) or
				(Препятствие_др_машины <> 0 and Скорость < sqrt(Скорость_др_машины * Скорость_др_машины + 2 * Максимальная_скорость / Время_торможения_с_макс * (YКоордината - YКоордината_др_машины - Запас)))))
					return РазгонВозможен;
	if (Направление == 1 and ((XКоордината_др_машины - XКоордината < Запас) or
				 (Препятствие_др_машины == 0 and XКоордината > XКоордината_др_машины - Запас - (Скорость - Скорость_др_машины) * ((Максимальная_скорость - Скорость_др_машины) / Максимальная_скорость * Время_разгона_до_макс)) or
				 (Препятствие_др_машины <> 0 and Скорость >= sqrt(Скорость_др_машины * Скорость_др_машины + 2 * Максимальная_скорость / Время_торможения_с_макс * (XКоордината_др_машины - XКоордината - Запас)))))
					return ТорможениеВозможно;
	if (Направление == 2 and ((YКоордината_др_машины - YКоордината < Запас) or
				 (Препятствие_др_машины == 0 and YКоордината > YКоордината_др_машины - Запас - (Скорость - Скорость_др_машины) * ((Максимальная_скорость - Скорость_др_машины) / Максимальная_скорость * Время_разгона_до_макс)) or
				 (Препятствие_др_машины <> 0 and Скорость >= sqrt(Скорость_др_машины * Скорость_др_машины + 2 * Максимальная_скорость / Время_торможения_с_макс * (YКоордината_др_машины - YКоордината - Запас)))))
					return ТорможениеВозможно;
	if (Направление == 4 and ((YКоордината - YКоордината_др_машины < Запас) or
				 (Препятствие_др_машины == 0 and YКоордината_др_машины - YКоордината > - Запас - (Скорость - Скорость_др_машины) * ((Максимальная_скорость - Скорость_др_машины) / Максимальная_скорость * Время_разгона_до_макс)) or
				 (Препятствие_др_машины <> 0 and Скорость >= sqrt(Скорость_др_машины * Скорость_др_машины + 2 * Максимальная_скорость / Время_торможения_с_макс * (YКоордината - YКоордината_др_машины - Запас)))))
					return ТорможениеВозможно;
	if (1 == 1) //else
					return ТорможениеВозможно;
$End

$Function Состояние_нет_препятствия: such_as Машины.Состояние
$Type = algorithmic
$Parameters
	Скорость: real
$Body
	if (Скорость == Максимальная_скорость)
		return ЕздаВозможна;
	if (Скорость < Максимальная_скорость)
		return РазгонВозможен;
$End

$Function Минимальная_координата_2: real
$Type = algorithmic
$Parameters
	Направление            : integer
	XКоордината_препятствия: real
	YКоордината_препятствия: real
$Body
	if (Направление == 1)
		return XКоордината_препятствия;
	if (Направление == 2)
		return YКоордината_препятствия;
	if (Направление == 4)
		return  - YКоордината_препятствия;
$End

$Function Минимальная_координата_3: real
$Type = algorithmic
$Parameters
	Направление: integer
	XКоордината_светофора  : real
	YКоордината_светофора  : real
	XКоордината_препятствия: real
	YКоордината_препятствия: real
$Body
	if (Направление == 1)
		return XКоордината_светофора + XКоордината_препятствия;
	if (Направление == 2)
		return YКоордината_светофора + YКоордината_препятствия;
	if (Направление == 4)
		return  - (YКоордината_светофора + YКоордината_препятствия);
$End

$Function Минимальная_координата_1: real
$Type = algorithmic
$Parameters
	Направление			 : integer
	XКоордината_светофора: real
	YКоордината_светофора: real	
$Body
	if (Направление == 1) 
		return XКоордината_светофора;
	if (Направление == 2)
		return YКоордината_светофора;
	if (Направление == 4)
		return - YКоордината_светофора;
$End

$Sequence Розыгрыш_куда_2: such_as Машины.Куда
$Type = by_hist
$Body
	Влево 0.15
	Вправо  0.85
$End