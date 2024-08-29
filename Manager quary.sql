SELECT papf.person_number
		,ppnf.first_name
		,ppnf.last_name
		,sup_num.person_number AS manager_number
		,sup_name.full_name AS manager_name
		,pptt.user_person_type AS person_type
                 ,(SELECT PAV.ACTION_NAME  
	                                          FROM PER_ACTION_OCCURRENCES PAO,
                                                   PER_ACTIONS_VL PAV,
												   	per_periods_of_service ppos

                                            WHERE  1=1 	AND PAAM.PERIOD_OF_SERVICE_ID=PPOS.PERIOD_OF_SERVICE_ID(+)

										       AND PAO.ACTION_OCCURRENCE_ID = PPOS.ACTION_OCCURRENCE_ID
                                               AND PPOS.PERSON_ID = PAPF.PERSON_ID
                                               AND PAO.ACTION_ID = PAV.ACTION_ID 
                                               AND PPOS.ACTUAL_TERMINATION_DATE IS NOT NULL), NULL) AS "TERMINATION_ACTION"
	FROM per_all_people_f papf
	,per_all_assignments_m paam
	,per_person_names_f ppnf
	,per_person_types_tl pptt
	,per_assignment_supervisors_f per_sup
	,per_all_people_f sup_num
	,per_person_names_f sup_name
WHERE 1=1
	-- and papf.person_number='111'
	AND ppnf.person_id=papf.person_id
	AND papf.person_id=paam.person_id
	AND pptt.person_type_id = paam.person_type_id
	AND pptt.LANGUAGE = 'US'
	AND pptt.user_person_type <>'As Needed'
	AND ppnf.name_type='GLOBAL'
	AND paam.primary_flag='Y'
	AND paam.assignment_status_type='ACTIVE'
	AND paam.assignment_type IN ('E','C','N','P')
	AND paam.effective_latest_change='Y'
	AND sup_name.name_type = 'GLOBAL'
	and papf.person_id = per_sup.person_id
	and per_sup.manager_id = sup_num.person_id
	and sup_num.person_id = sup_name.person_id
	-- and ppos.person_id=papf.person_id
	AND TRUNC(SYSDATE) BETWEEN papf.effective_start_date AND papf.effective_end_date
	AND TRUNC(SYSDATE) BETWEEN paam.effective_start_date AND paam.effective_end_date
	AND TRUNC(SYSDATE) BETWEEN ppnf.effective_start_date AND ppnf.effective_end_date
	AND TRUNC(SYSDATE) BETWEEN per_sup.effective_start_date AND per_sup.effective_end_date
	AND TRUNC(SYSDATE) BETWEEN sup_name.effective_start_date AND sup_name.effective_end_date
	AND TRUNC(SYSDATE) BETWEEN sup_num.effective_start_date AND sup_num.effective_end_date
	ORDER BY papf.person_number