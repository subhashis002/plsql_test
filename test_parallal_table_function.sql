SET TIMING ON

PROMPT
PROMPT Serial Execution
PROMPT ================
SELECT sid,count(*)
FROM TABLE(parallel_ptf_api.test_ptf(CURSOR(SELECT *
											FROM parallel_test t1
											)
									)
			) t2
GROUP BY sid;

PROMPT
PROMPT Parallel Execution
PROMPT ================
SELECT sid,count(*)
FROM TABLE(parallel_ptf_api.test_ptf(CURSOR(SELECT /*+ parallel(t1,5) */ *
											FROM parallel_test t1
											)
									)
			) t2
GROUP BY sid;
