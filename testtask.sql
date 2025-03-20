USE test_task;
GO

-- ��������� �������
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

-- CTE ��� ����������� ������
WITH AggregatedData AS (
    SELECT 
		-- � ����� ������������ �� CASE WHEN ������ IIF,
		-- �� �������, ��� ��� �� ������� �������� �� T-SQL,
		-- �� ����� ������������ ���� T-SQL
        IIF(DAY(_date) = 1,				-- ���� ���� - ������ ����� ������
		FORMAT(_date, 'dd.MM.yyyy'),	-- �� ���� ������������� ���
		FORMAT(_date, 'MM.yyyy'))		-- � ��������� ������ ���
		AS _date,
        SUM(_count) AS _count
    FROM #DateCountTable
    GROUP BY 
		-- ������������ �� ���� � ������ ������ � ��� ������� �����
        IIF(DAY(_date) = 1, FORMAT(_date, 'dd.MM.yyyy'), FORMAT(_date, 'MM.yyyy')),
		-- � �� ������, ����� ���� ��� � ��������������� �������, ��� �������� � �������
		MONTH(_date)
)

SELECT 
    _date,
    _count
FROM AggregatedData
ORDER BY 
	-- ����� �������������� ������ � ���� ��� ����������
	-- ����� �������� ������ �� �����
	-- ���������� .01 ��� ����������� �������������� ���
    TRY_CAST(REPLACE(_date, '.', '-') + '.01' AS DATE)
	
-- ���������� ���������� ������ � ��������� ��������
DROP TABLE #DateCountTable;