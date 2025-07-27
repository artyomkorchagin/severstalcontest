CREATE TABLE #Intervals (
    StartDateTime DATETIME2,
    EndDateTime DATETIME2
);

INSERT INTO #Intervals (StartDateTime, EndDateTime)
VALUES
    ('2018-01-01 06:00:00', '2018-01-01 14:00:00'),
    ('2018-01-01 11:00:00', '2018-01-01 19:00:00'),
    ('2018-01-01 20:00:00', '2018-01-02 03:00:00'),
    ('2018-01-02 06:00:00', '2018-01-02 14:00:00'),
    ('2018-01-02 11:00:00', '2018-01-02 19:00:00');

set statistics time on;
WITH OrderedIntervals AS (
    SELECT 
        StartDateTime,
        EndDateTime,
        LAG(EndDateTime) OVER (ORDER BY StartDateTime) AS PrevEndDateTime
    FROM #Intervals
),
GroupBoundaries AS (
    SELECT 
        StartDateTime,
        EndDateTime,
        SUM(IIF(PrevEndDateTime IS NULL OR PrevEndDateTime < StartDateTime, 1, 0))
        OVER (ORDER BY StartDateTime) AS GroupID
    FROM OrderedIntervals
)
SELECT 
    MIN(StartDateTime) AS StartDateTime,
    MAX(EndDateTime) AS EndDateTime
FROM GroupBoundaries
GROUP BY GroupID
ORDER BY StartDateTime;

DROP TABLE #Intervals;
GO
set statistics time off
