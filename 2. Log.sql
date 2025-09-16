--DROP TABLE IF EXISTS PBI_LearningJourneyFAMRAM_LOG;

WITH RankedQuiz AS (
    SELECT
        uu.username,
        qq.content_id,
        qq.quiz_id,
        cc.title as course_title,
        qq.code as quiz_type,
        qq.score,
        qq.created as quiz_created,
        qq.is_pass,
        ROW_NUMBER() OVER (
            PARTITION BY uu.username, qq.quiz_id
            ORDER BY qq.score DESC, qq.created ASC
        ) AS rn,
        COUNT(*) OVER (
            PARTITION BY uu.username, qq.quiz_id
        ) AS num_attempts
    FROM quizzes_quizsession qq
	LEFT JOIN UsersMbeat uu on uu.id = qq.user_id
	LEFT JOIN ContentsCourse2 cc on cc.id = qq.content_id
    WHERE qq.title LIKE '%Learning Journey FAM & RAM : Basic%'
       OR qq.title LIKE '%Learning Journey FAM & RAM : Intermediate%'
	   OR qq.title LIKE '%Learning Journey FAM & RAM : Advance%'
)

SELECT
    rq.username                                  AS NIK,
    de.Name,
    de.JobTitle,
    de.[Join Date],
    rq.content_id,
    rq.quiz_id,
    rq.course_title,
    rq.quiz_type,
    rq.score,
    rq.quiz_created,
    rq.is_pass,
    CASE WHEN rq.is_pass = 1 THEN 'Lulus' ELSE 'Tidak Lulus' END                  AS [Status Kelulusan],
    CASE WHEN rq.is_pass = 1 OR rq.num_attempts >= 3 THEN 'Completed'
         ELSE 'Incompleted' END                                                  AS [Completion Status],
    rq.num_attempts,
    -- Course Level
    CASE 
        WHEN rq.course_title LIKE '%Learning Journey FAM & RAM : Basic Course%'		   THEN 'Basic'
        WHEN rq.course_title LIKE '%Learning Journey FAM & RAM : Intermediate Course%' THEN 'Intermediate'
        WHEN rq.course_title LIKE '%Learning Journey FAM & RAM : Advance Course%'      THEN 'Advance'
        ELSE 'Unknown Course Level'
    END AS [Course Level]
--INTO PBI_LearningJourneyFAMRAM_LOG
FROM RankedQuiz rq
LEFT JOIN DataEmployeeMbeat de ON de.nik = rq.username
WHERE rq.rn = 1   -- ambil skor tertinggi, jika sama ambil tanggal terawal
ORDER BY rq.course_title ASC, rq.username ASC;
