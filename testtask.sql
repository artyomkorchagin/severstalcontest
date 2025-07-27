CREATE TABLE #Intervals (
    _startDateTime DATETIME,
    _endDateTime DATETIME
);


INSERT INTO #Intervals (_startDateTime, _endDateTime)
VALUES
    ('2018-01-01 06:00:00', '2018-01-01 14:00:00'),
    ('2018-01-01 11:00:00', '2018-01-01 19:00:00'),
    ('2018-01-01 20:00:00', '2018-01-02 03:00:00'),
    ('2018-01-02 06:00:00', '2018-01-02 14:00:00'),
    ('2018-01-02 11:00:00', '2018-01-02 19:00:00');

WITH OrderedIntervals AS (
    SELECT 
        _startDateTime,
        _endDateTime,
        LAG(_endDateTime) OVER (ORDER BY _startDateTime) AS PrevEndDateTime
    FROM #Intervals
),
GroupBoundaries AS (
    SELECT 
        _startDateTime,
        _endDateTime,
        SUM(IIF(PrevEndDateTime IS NULL OR PrevEndDateTime < _startDateTime, 1, 0))
        OVER (ORDER BY _startDateTime) AS GroupID
    FROM OrderedIntervals
)
SELECT 
    MIN(_startDateTime) AS _startDateTime,
    MAX(_endDateTime) AS _endDateTime
FROM GroupBoundaries
GROUP BY GroupID
ORDER BY _startDateTime;

DROP TABLE #Intervals;
