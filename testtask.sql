USE test_task;
GO

-- временная таблица
CREATE TABLE #DateCountTable (
    _date DATE NOT NULL,
    _count INT NOT NULL
);

INSERT INTO #DateCountTable (_date, _count)
VALUES 
    ('2022-05-04', 5),
    ('2022-05-03', 2),
    ('2022-07-02', 6),
    ('2022-12-01', 3),
    ('2022-10-01', 1),
    ('2022-10-15', 1),
    ('2022-10-27', 7),
    ('2022-07-03', 2);
GO

-- CTE для группировки данных
WITH AggregatedData AS (
    SELECT 
		-- я думал использовать ли CASE WHEN вместо IIF,
		-- но подумал, что раз уж сказано написать на T-SQL,
		-- то нужно использовать фичи T-SQL
        IIF(DAY(_date) = 1,				-- если дата - первое число месяца
		FORMAT(_date, 'dd.MM.yyyy'),	-- то дата форматируется так
		FORMAT(_date, 'MM.yyyy'))		-- в противном случае так
		AS _date,
        SUM(_count) AS _count
    FROM #DateCountTable
    GROUP BY 
		-- группируется по дате с первым числом и без первого числа
        IIF(DAY(_date) = 1, FORMAT(_date, 'dd.MM.yyyy'), FORMAT(_date, 'MM.yyyy')),
		-- и по месяцу, чтобы даты шли в хронологическом порядке, как написано в задании
		MONTH(_date)
)

SELECT 
    _date,
    _count
FROM AggregatedData
ORDER BY 
	-- явное преобразование строки в дату для сортировки
	-- также заменили дефисы на точки
	-- подставили .01 для правильного упорядочивания дат
    TRY_CAST(REPLACE(_date, '.', '-') + '.01' AS DATE)
	
-- логическое завершение работы с временной таблицей
DROP TABLE #DateCountTable;