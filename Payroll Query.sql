SELECT 
 PPNF.FULL_NAME "Full Name",
 PAPF.PERSON_NUMBER   "Employee Number",
 HR_GENERAL.DECODE_LOOKUP('HRC_YES_NO',PAAM.ASS_ATTRIBUTE2)   "DropAccepted",
 HAPFV.POSITION_CODE || '.'|| HAPFV.NAME || '.' || HR_GENERAL.DECODE_LOOKUP('EMP_CAT',HAPFV.ASSIGNMENT_CATEGORY)   || '.' || HAOUF.NAME   "POSITION" ,
 HR_GENERAL.DECODE_LOOKUP('EMP_CAT',PAAM.EMPLOYMENT_CATEGORY) AS EMPLOYMENT_CATEGORY,
 TO_CHAR(PPOS.ACTUAL_TERMINATION_DATE,'dd-Mon-yy', 'NLS_DATE_LANGUAGE=AMERICAN')       "Termination Date",
 TO_CHAR(paam.ASS_ATTRIBUTE_DATE1,'dd-Mon-yy', 'NLS_DATE_LANGUAGE=AMERICAN')       "Pension Eligibility Date",
 (SELECT GROUP_NAME FROM
   PER_PEOPLE_GROUPS PPG
   WHERE PPG.PEOPLE_GROUP_ID = PAAM.PEOPLE_GROUP_ID
 ) "People Group",
(SELECT prrv.RESULT_VALUE
               FROM pay_run_result_values prrv,
						   pay_run_results prr,
						   pay_payroll_rel_actions ppra,
						   pay_payroll_actions ppa_2,
						   pay_input_values_f PIV,
						   PAY_BALANCE_FEEDS_F PBFF_1    ,
                           PAY_BALANCE_TYPES_VL PBTT_1   ,
                           PAY_DEFINED_BALANCES PDB      ,
                           PAY_BALANCE_DIMENSIONS PBD    
                 WHERE prrv.run_result_id      = prr.run_result_id
						  and prr.payroll_rel_action_id   = ppra.payroll_rel_action_id
						  and prd.payroll_relationship_id = ppra.payroll_relationship_id
						  and ppra.payroll_action_id   = ppa_2.payroll_action_id
						  and ppra.retro_component_id is null
                          and ppa_2.action_type IN ('R','Q','CTG','B','I','V')
						  and PIV.element_type_id = prr.element_type_id
                          and PRRV.input_value_id = PIV.input_value_id
						  AND     prrv.INPUT_VALUE_ID       = PBFF_1.INPUT_VALUE_ID
							AND     PBFF_1.BALANCE_TYPE_ID      = PBTT_1.BALANCE_TYPE_ID
							AND     ppa_2.effective_date BETWEEN PBFF_1.EFFECTIVE_START_DATE AND PBFF_1.EFFECTIVE_END_DATE
							AND     PBTT_1.BALANCE_NAME  IN('Pension Union Eligible Compensation')
							AND     PBTT_1.BALANCE_TYPE_ID   = PDB.BALANCE_TYPE_ID
							AND     PDB.BALANCE_DIMENSION_ID = PBD.BALANCE_DIMENSION_ID
							AND     PBD.BASE_DIMENSION_NAME IN ('Core Relationship Tax Unit Year to Date')
						  and ppa_2.effective_date  between :START_DATE and :END_DATE 
 and ppa_2.payroll_action_id = pra_1.payroll_action_id
and prr.payroll_rel_action_id = pra_1.payroll_rel_action_id
) "Pension Union Wages YTD",

/* (SELECT prrv.RESULT_VALUE
               FROM pay_run_result_values prrv,
						   pay_run_results prr,
						   pay_payroll_rel_actions ppra,
						   pay_payroll_actions ppa_2,
						   pay_input_values_f PIV,
						   PAY_BALANCE_FEEDS_F PBFF_1    ,
                           PAY_BALANCE_TYPES_VL PBTT_1   ,
                           PAY_DEFINED_BALANCES PDB      ,
                           PAY_BALANCE_DIMENSIONS PBD    
                 WHERE prrv.run_result_id      = prr.run_result_id
						  and prr.payroll_rel_action_id   = ppra.payroll_rel_action_id
						  and prd.payroll_relationship_id = ppra.payroll_relationship_id
						  and ppra.payroll_action_id   = ppa_2.payroll_action_id
						  and ppra.retro_component_id is null
                          and ppa_2.action_type IN ('R','Q','CTG','B','I','V')
						  and PIV.element_type_id = prr.element_type_id
                          and PRRV.input_value_id = PIV.input_value_id
						  AND     prrv.INPUT_VALUE_ID       = PBFF_1.INPUT_VALUE_ID
							AND     PBFF_1.BALANCE_TYPE_ID      = PBTT_1.BALANCE_TYPE_ID
							AND     ppa_2.effective_date BETWEEN PBFF_1.EFFECTIVE_START_DATE AND PBFF_1.EFFECTIVE_END_DATE
							AND     PBTT_1.BALANCE_NAME  IN('MARTA Pension NR DC')
							AND     PBTT_1.BALANCE_TYPE_ID   = PDB.BALANCE_TYPE_ID
							AND     PDB.BALANCE_DIMENSION_ID = PBD.BALANCE_DIMENSION_ID
							AND     PBD.BASE_DIMENSION_NAME IN ('Core Relationship Year to Date')
						  and ppa_2.effective_date between :START_DATE and :END_DATE 
 and ppa_2.payroll_action_id = pra_1.payroll_action_id
and prr.payroll_rel_action_id = pra_1.payroll_rel_action_id
) "Pension NR DC YTD", */
(SELECT prrv.RESULT_VALUE
               FROM pay_run_result_values prrv,
						   pay_run_results prr,
						   pay_payroll_rel_actions ppra,
						   pay_payroll_actions ppa_2,
						   pay_input_values_f PIV,
						   PAY_BALANCE_FEEDS_F PBFF_1    ,
                           PAY_BALANCE_TYPES_VL PBTT_1   ,
                           PAY_DEFINED_BALANCES PDB      ,
                           PAY_BALANCE_DIMENSIONS PBD    
                 WHERE prrv.run_result_id      = prr.run_result_id
						  and prr.payroll_rel_action_id   = ppra.payroll_rel_action_id
						  and prd.payroll_relationship_id = ppra.payroll_relationship_id
						  and ppra.payroll_action_id   = ppa_2.payroll_action_id
						  and ppra.retro_component_id is null
                          and ppa_2.action_type IN ('R','Q','CTG','B','I','V')
						  and PIV.element_type_id = prr.element_type_id
                          and PRRV.input_value_id = PIV.input_value_id
						  AND     prrv.INPUT_VALUE_ID       = PBFF_1.INPUT_VALUE_ID
							AND     PBFF_1.BALANCE_TYPE_ID      = PBTT_1.BALANCE_TYPE_ID
							AND     ppa_2.effective_date BETWEEN PBFF_1.EFFECTIVE_START_DATE AND PBFF_1.EFFECTIVE_END_DATE
							AND     PBTT_1.BALANCE_NAME  IN('MARTA Pension Union Hours')
							AND     PBTT_1.BALANCE_TYPE_ID   = PDB.BALANCE_TYPE_ID
							AND     PDB.BALANCE_DIMENSION_ID = PBD.BALANCE_DIMENSION_ID
							AND     PBD.BASE_DIMENSION_NAME IN ('Core Relationship Tax Unit Year to Date')
						  and ppa_2.effective_date between :START_DATE and :END_DATE 
 and ppa_2.payroll_action_id = pra_1.payroll_action_id
and prr.payroll_rel_action_id = pra_1.payroll_rel_action_id
) "Pension Union Hours YTD",
(SELECT prrv.RESULT_VALUE
               FROM pay_run_result_values prrv,
						   pay_run_results prr,
						   pay_payroll_rel_actions ppra,
						   pay_payroll_actions ppa_2,
						   pay_input_values_f PIV,
						   PAY_BALANCE_FEEDS_F PBFF_1    ,
                           PAY_BALANCE_TYPES_VL PBTT_1   ,
                           PAY_DEFINED_BALANCES PDB      ,
                           PAY_BALANCE_DIMENSIONS PBD    
                 WHERE prrv.run_result_id      = prr.run_result_id
						  and prr.payroll_rel_action_id   = ppra.payroll_rel_action_id
						  and prd.payroll_relationship_id = ppra.payroll_relationship_id
						  and ppra.payroll_action_id   = ppa_2.payroll_action_id
						  and ppra.retro_component_id is null
                          and ppa_2.action_type IN ('R','Q','CTG','B','I','V')
						  and PIV.element_type_id = prr.element_type_id
                          and PRRV.input_value_id = PIV.input_value_id
						  AND     prrv.INPUT_VALUE_ID       = PBFF_1.INPUT_VALUE_ID
							AND     PBFF_1.BALANCE_TYPE_ID      = PBTT_1.BALANCE_TYPE_ID
							AND     ppa_2.effective_date BETWEEN PBFF_1.EFFECTIVE_START_DATE AND PBFF_1.EFFECTIVE_END_DATE
							AND     PBTT_1.BALANCE_NAME  IN('Pension Union')
							AND     PBTT_1.BALANCE_TYPE_ID   = PDB.BALANCE_TYPE_ID
							AND     PDB.BALANCE_DIMENSION_ID = PBD.BALANCE_DIMENSION_ID
							AND     PBD.BASE_DIMENSION_NAME IN ('Core Relationship Tax Unit Year to Date')
						  and ppa_2.effective_date between :START_DATE and :END_DATE 
 and ppa_2.payroll_action_id = pra_1.payroll_action_id
and prr.payroll_rel_action_id = pra_1.payroll_rel_action_id
) "Pension Union YTD",

(SELECT prrv.RESULT_VALUE
               FROM pay_run_result_values prrv,
						   pay_run_results prr,
						   pay_payroll_rel_actions ppra,
						   pay_payroll_actions ppa_2,
						   pay_input_values_f PIV,
						   PAY_BALANCE_FEEDS_F PBFF_1    ,
                           PAY_BALANCE_TYPES_VL PBTT_1   ,
                           PAY_DEFINED_BALANCES PDB      ,
                           PAY_BALANCE_DIMENSIONS PBD    
                 WHERE prrv.run_result_id      = prr.run_result_id
						  and prr.payroll_rel_action_id   = ppra.payroll_rel_action_id
						  and prd.payroll_relationship_id = ppra.payroll_relationship_id
						  and ppra.payroll_action_id   = ppa_2.payroll_action_id
						  and ppra.retro_component_id is null
                          and ppa_2.action_type IN ('R','Q','CTG','B','I','V')
						  and PIV.element_type_id = prr.element_type_id
                          and PRRV.input_value_id = PIV.input_value_id
						  AND     prrv.INPUT_VALUE_ID       = PBFF_1.INPUT_VALUE_ID
							AND     PBFF_1.BALANCE_TYPE_ID      = PBTT_1.BALANCE_TYPE_ID
							AND     ppa_2.effective_date BETWEEN PBFF_1.EFFECTIVE_START_DATE AND PBFF_1.EFFECTIVE_END_DATE
							AND     PBTT_1.BALANCE_NAME  IN('Pension Union ER Contribution')
							AND     PBTT_1.BALANCE_TYPE_ID   = PDB.BALANCE_TYPE_ID
							AND     PDB.BALANCE_DIMENSION_ID = PBD.BALANCE_DIMENSION_ID
							AND     PBD.BASE_DIMENSION_NAME IN ('Core Relationship Period to Date')
						  and ppa_2.effective_date between :START_DATE and :END_DATE 
 and ppa_2.payroll_action_id = pra_1.payroll_action_id
and prr.payroll_rel_action_id = pra_1.payroll_rel_action_id
) "Pension Union ER Current",
(SELECT prrv.RESULT_VALUE
               FROM pay_run_result_values prrv,
						   pay_run_results prr,
						   pay_payroll_rel_actions ppra,
						   pay_payroll_actions ppa_2,
						   pay_input_values_f PIV,
						   PAY_BALANCE_FEEDS_F PBFF_1    ,
                           PAY_BALANCE_TYPES_VL PBTT_1   ,
                           PAY_DEFINED_BALANCES PDB      ,
                           PAY_BALANCE_DIMENSIONS PBD    
                 WHERE prrv.run_result_id      = prr.run_result_id
						  and prr.payroll_rel_action_id   = ppra.payroll_rel_action_id
						  and prd.payroll_relationship_id = ppra.payroll_relationship_id
						  and ppra.payroll_action_id   = ppa_2.payroll_action_id
						  and ppra.retro_component_id is null
                          and ppa_2.action_type IN ('R','Q','CTG','B','I','V')
						  and PIV.element_type_id = prr.element_type_id
                          and PRRV.input_value_id = PIV.input_value_id
						  AND     prrv.INPUT_VALUE_ID       = PBFF_1.INPUT_VALUE_ID
							AND     PBFF_1.BALANCE_TYPE_ID      = PBTT_1.BALANCE_TYPE_ID
							AND     ppa_2.effective_date BETWEEN PBFF_1.EFFECTIVE_START_DATE AND PBFF_1.EFFECTIVE_END_DATE
							AND     PBTT_1.BALANCE_NAME  IN('Pension Union ER Contribution')
							AND     PBTT_1.BALANCE_TYPE_ID   = PDB.BALANCE_TYPE_ID
							AND     PDB.BALANCE_DIMENSION_ID = PBD.BALANCE_DIMENSION_ID
							AND     PBD.BASE_DIMENSION_NAME IN ('Core Relationship Tax Unit Year to Date')
						  and ppa_2.effective_date between :START_DATE and :END_DATE 
 and ppa_2.payroll_action_id = pra_1.payroll_action_id
and prr.payroll_rel_action_id = pra_1.payroll_rel_action_id
) "Pension Union ER YTD",
(SELECT prrv.RESULT_VALUE
               FROM pay_run_result_values prrv,
						   pay_run_results prr,
						   pay_payroll_rel_actions ppra,
						   pay_payroll_actions ppa_2,
						   pay_input_values_f PIV,
						   PAY_BALANCE_FEEDS_F PBFF_1    ,
                           PAY_BALANCE_TYPES_VL PBTT_1   ,
                           PAY_DEFINED_BALANCES PDB      ,
                           PAY_BALANCE_DIMENSIONS PBD    
                 WHERE prrv.run_result_id      = prr.run_result_id
						  and prr.payroll_rel_action_id   = ppra.payroll_rel_action_id
						  and prd.payroll_relationship_id = ppra.payroll_relationship_id
						  and ppra.payroll_action_id   = ppa_2.payroll_action_id
						  and ppra.retro_component_id is null
                          and ppa_2.action_type IN ('R','Q','CTG','B','I','V')
						  and PIV.element_type_id = prr.element_type_id
                          and PRRV.input_value_id = PIV.input_value_id
						  AND     prrv.INPUT_VALUE_ID       = PBFF_1.INPUT_VALUE_ID
							AND     PBFF_1.BALANCE_TYPE_ID      = PBTT_1.BALANCE_TYPE_ID
							AND     ppa_2.effective_date BETWEEN PBFF_1.EFFECTIVE_START_DATE AND PBFF_1.EFFECTIVE_END_DATE
							AND     PBTT_1.BALANCE_NAME  IN('Pension Police Eligible Compensation')
							AND     PBTT_1.BALANCE_TYPE_ID   = PDB.BALANCE_TYPE_ID
							AND     PDB.BALANCE_DIMENSION_ID = PBD.BALANCE_DIMENSION_ID
							AND     PBD.BASE_DIMENSION_NAME IN ('Core Relationship NoCB Run')
						  and ppa_2.effective_date between :START_DATE and :END_DATE 
 and ppa_2.payroll_action_id = pra_1.payroll_action_id
and prr.payroll_rel_action_id = pra_1.payroll_rel_action_id
) "Pension Police Wages YTD",  --Doubt

(SELECT prrv.RESULT_VALUE
               FROM pay_run_result_values prrv,
						   pay_run_results prr,
						   pay_payroll_rel_actions ppra,
						   pay_payroll_actions ppa_2,
						   pay_input_values_f PIV,
						   PAY_BALANCE_FEEDS_F PBFF_1    ,
                           PAY_BALANCE_TYPES_VL PBTT_1   ,
                           PAY_DEFINED_BALANCES PDB      ,
                           PAY_BALANCE_DIMENSIONS PBD    
                 WHERE prrv.run_result_id      = prr.run_result_id
						  and prr.payroll_rel_action_id   = ppra.payroll_rel_action_id
						  and prd.payroll_relationship_id = ppra.payroll_relationship_id
						  and ppra.payroll_action_id   = ppa_2.payroll_action_id
						  and ppra.retro_component_id is null
                          and ppa_2.action_type IN ('R','Q','CTG','B','I','V')
						  and PIV.element_type_id = prr.element_type_id
                          and PRRV.input_value_id = PIV.input_value_id
						  AND     prrv.INPUT_VALUE_ID       = PBFF_1.INPUT_VALUE_ID
							AND     PBFF_1.BALANCE_TYPE_ID      = PBTT_1.BALANCE_TYPE_ID
							AND     ppa_2.effective_date BETWEEN PBFF_1.EFFECTIVE_START_DATE AND PBFF_1.EFFECTIVE_END_DATE
							AND     PBTT_1.BALANCE_NAME  IN('Pension Police')
							AND     PBTT_1.BALANCE_TYPE_ID   = PDB.BALANCE_TYPE_ID
							AND     PDB.BALANCE_DIMENSION_ID = PBD.BALANCE_DIMENSION_ID
							AND     PBD.BASE_DIMENSION_NAME IN ('Core Relationship Tax Unit Period to Date')
						  and ppa_2.effective_date between :START_DATE and :END_DATE 
 and ppa_2.payroll_action_id = pra_1.payroll_action_id
and prr.payroll_rel_action_id = pra_1.payroll_rel_action_id
) "Pension Police Current",

(SELECT prrv.RESULT_VALUE
               FROM pay_run_result_values prrv,
						   pay_run_results prr,
						   pay_payroll_rel_actions ppra,
						   pay_payroll_actions ppa_2,
						   pay_input_values_f PIV,
						   PAY_BALANCE_FEEDS_F PBFF_1    ,
                           PAY_BALANCE_TYPES_VL PBTT_1   ,
                           PAY_DEFINED_BALANCES PDB      ,
                           PAY_BALANCE_DIMENSIONS PBD    
                 WHERE prrv.run_result_id      = prr.run_result_id
						  and prr.payroll_rel_action_id   = ppra.payroll_rel_action_id
						  and prd.payroll_relationship_id = ppra.payroll_relationship_id
						  and ppra.payroll_action_id   = ppa_2.payroll_action_id
						  and ppra.retro_component_id is null
                          and ppa_2.action_type IN ('R','Q','CTG','B','I','V')
						  and PIV.element_type_id = prr.element_type_id
                          and PRRV.input_value_id = PIV.input_value_id
						  AND     prrv.INPUT_VALUE_ID       = PBFF_1.INPUT_VALUE_ID
							AND     PBFF_1.BALANCE_TYPE_ID      = PBTT_1.BALANCE_TYPE_ID
							AND     ppa_2.effective_date BETWEEN PBFF_1.EFFECTIVE_START_DATE AND PBFF_1.EFFECTIVE_END_DATE
							AND     PBTT_1.BALANCE_NAME  IN('Pension Police')
							AND     PBTT_1.BALANCE_TYPE_ID   = PDB.BALANCE_TYPE_ID
							AND     PDB.BALANCE_DIMENSION_ID = PBD.BALANCE_DIMENSION_ID
							AND     PBD.BASE_DIMENSION_NAME IN ('Core Relationship Tax Unit Year to Date')
						  and ppa_2.effective_date between :START_DATE and :END_DATE 
 and ppa_2.payroll_action_id = pra_1.payroll_action_id
and prr.payroll_rel_action_id = pra_1.payroll_rel_action_id
) "Pension Police YTD",

(SELECT prrv.RESULT_VALUE
               FROM pay_run_result_values prrv,
						   pay_run_results prr,
						   pay_payroll_rel_actions ppra,
						   pay_payroll_actions ppa_2,
						   pay_input_values_f PIV,
						   PAY_BALANCE_FEEDS_F PBFF_1    ,
                           PAY_BALANCE_TYPES_VL PBTT_1   ,
                           PAY_DEFINED_BALANCES PDB      ,
                           PAY_BALANCE_DIMENSIONS PBD    
                 WHERE prrv.run_result_id      = prr.run_result_id
						  and prr.payroll_rel_action_id   = ppra.payroll_rel_action_id
						  and prd.payroll_relationship_id = ppra.payroll_relationship_id
						  and ppra.payroll_action_id   = ppa_2.payroll_action_id
						  and ppra.retro_component_id is null
                          and ppa_2.action_type IN ('R','Q','CTG','B','I','V')
						  and PIV.element_type_id = prr.element_type_id
                          and PRRV.input_value_id = PIV.input_value_id
						  AND     prrv.INPUT_VALUE_ID       = PBFF_1.INPUT_VALUE_ID
							AND     PBFF_1.BALANCE_TYPE_ID      = PBTT_1.BALANCE_TYPE_ID
							AND     ppa_2.effective_date BETWEEN PBFF_1.EFFECTIVE_START_DATE AND PBFF_1.EFFECTIVE_END_DATE
							AND     PBTT_1.BALANCE_NAME  IN('Pension Police ER Contribution')
							AND     PBTT_1.BALANCE_TYPE_ID   = PDB.BALANCE_TYPE_ID
							AND     PDB.BALANCE_DIMENSION_ID = PBD.BALANCE_DIMENSION_ID
							AND     PBD.BASE_DIMENSION_NAME IN ('Core Relationship Period to Date')
						  and ppa_2.effective_date between :START_DATE and :END_DATE 
 and ppa_2.payroll_action_id = pra_1.payroll_action_id
and prr.payroll_rel_action_id = pra_1.payroll_rel_action_id
) "Pension Police ER Current" ,

(SELECT prrv.RESULT_VALUE
               FROM pay_run_result_values prrv,
						   pay_run_results prr,
						   pay_payroll_rel_actions ppra,
						   pay_payroll_actions ppa_2,
						   pay_input_values_f PIV,
						   PAY_BALANCE_FEEDS_F PBFF_1    ,
                           PAY_BALANCE_TYPES_VL PBTT_1   ,
                           PAY_DEFINED_BALANCES PDB      ,
                           PAY_BALANCE_DIMENSIONS PBD    
                 WHERE prrv.run_result_id      = prr.run_result_id
						  and prr.payroll_rel_action_id   = ppra.payroll_rel_action_id
						  and prd.payroll_relationship_id = ppra.payroll_relationship_id
						  and ppra.payroll_action_id   = ppa_2.payroll_action_id
						  and ppra.retro_component_id is null
                          and ppa_2.action_type IN ('R','Q','CTG','B','I','V')
						  and PIV.element_type_id = prr.element_type_id
                          and PRRV.input_value_id = PIV.input_value_id
						  AND     prrv.INPUT_VALUE_ID       = PBFF_1.INPUT_VALUE_ID
							AND     PBFF_1.BALANCE_TYPE_ID      = PBTT_1.BALANCE_TYPE_ID
							AND     ppa_2.effective_date BETWEEN PBFF_1.EFFECTIVE_START_DATE AND PBFF_1.EFFECTIVE_END_DATE
							AND     PBTT_1.BALANCE_NAME  IN('Pension Police ER Contribution')
							AND     PBTT_1.BALANCE_TYPE_ID   = PDB.BALANCE_TYPE_ID
							AND     PDB.BALANCE_DIMENSION_ID = PBD.BALANCE_DIMENSION_ID
							AND     PBD.BASE_DIMENSION_NAME IN ('Core Relationship Tax Unit Year to Date')
						  and ppa_2.effective_date between :START_DATE and :END_DATE 
 and ppa_2.payroll_action_id = pra_1.payroll_action_id
and prr.payroll_rel_action_id = pra_1.payroll_rel_action_id
) "Pension Police ER YTD",

(SELECT prrv.RESULT_VALUE
               FROM pay_run_result_values prrv,
						   pay_run_results prr,
						   pay_payroll_rel_actions ppra,
						   pay_payroll_actions ppa_2,
						   pay_input_values_f PIV,
						   PAY_BALANCE_FEEDS_F PBFF_1    ,
                           PAY_BALANCE_TYPES_VL PBTT_1   ,
                           PAY_DEFINED_BALANCES PDB      ,
                           PAY_BALANCE_DIMENSIONS PBD    
                 WHERE prrv.run_result_id      = prr.run_result_id
						  and prr.payroll_rel_action_id   = ppra.payroll_rel_action_id
						  and prd.payroll_relationship_id = ppra.payroll_relationship_id
						  and ppra.payroll_action_id   = ppa_2.payroll_action_id
						  and ppra.retro_component_id is null
                          and ppa_2.action_type IN ('R','Q','CTG','B','I','V')
						  and PIV.element_type_id = prr.element_type_id
                          and PRRV.input_value_id = PIV.input_value_id
						  AND     prrv.INPUT_VALUE_ID       = PBFF_1.INPUT_VALUE_ID
							AND     PBFF_1.BALANCE_TYPE_ID      = PBTT_1.BALANCE_TYPE_ID
							AND     ppa_2.effective_date BETWEEN PBFF_1.EFFECTIVE_START_DATE AND PBFF_1.EFFECTIVE_END_DATE
							AND     PBTT_1.BALANCE_NAME  IN('Pension NR Eligible Compensation')
							AND     PBTT_1.BALANCE_TYPE_ID   = PDB.BALANCE_TYPE_ID
							AND     PDB.BALANCE_DIMENSION_ID = PBD.BALANCE_DIMENSION_ID
							AND     PBD.BASE_DIMENSION_NAME IN ('Core Relationship Tax Unit Run')
						  and ppa_2.effective_date between :START_DATE and :END_DATE 
 and ppa_2.payroll_action_id = pra_1.payroll_action_id
and prr.payroll_rel_action_id = pra_1.payroll_rel_action_id
) "Pension NR Wages YTD"  ,--Doubt

(SELECT prrv.RESULT_VALUE
               FROM pay_run_result_values prrv,
						   pay_run_results prr,
						   pay_payroll_rel_actions ppra,
						   pay_payroll_actions ppa_2,
						   pay_input_values_f PIV,
						   PAY_BALANCE_FEEDS_F PBFF_1    ,
                           PAY_BALANCE_TYPES_VL PBTT_1   ,
                           PAY_DEFINED_BALANCES PDB      ,
                           PAY_BALANCE_DIMENSIONS PBD    
                 WHERE prrv.run_result_id      = prr.run_result_id
						  and prr.payroll_rel_action_id   = ppra.payroll_rel_action_id
						  and prd.payroll_relationship_id = ppra.payroll_relationship_id
						  and ppra.payroll_action_id   = ppa_2.payroll_action_id
						  and ppra.retro_component_id is null
                          and ppa_2.action_type IN ('R','Q','CTG','B','I','V')
						  and PIV.element_type_id = prr.element_type_id
                          and PRRV.input_value_id = PIV.input_value_id
						  AND     prrv.INPUT_VALUE_ID       = PBFF_1.INPUT_VALUE_ID
							AND     PBFF_1.BALANCE_TYPE_ID      = PBTT_1.BALANCE_TYPE_ID
							AND     ppa_2.effective_date BETWEEN PBFF_1.EFFECTIVE_START_DATE AND PBFF_1.EFFECTIVE_END_DATE
							AND     PBTT_1.BALANCE_NAME  IN('Pension NR')
							AND     PBTT_1.BALANCE_TYPE_ID   = PDB.BALANCE_TYPE_ID
							AND     PDB.BALANCE_DIMENSION_ID = PBD.BALANCE_DIMENSION_ID
							AND     PBD.BASE_DIMENSION_NAME IN ('Core Relationship Tax Unit Period to Date')
						  and ppa_2.effective_date between :START_DATE and :END_DATE 
 and ppa_2.payroll_action_id = pra_1.payroll_action_id
and prr.payroll_rel_action_id = pra_1.payroll_rel_action_id
) "Pension NR Current",

(SELECT prrv.RESULT_VALUE
               FROM pay_run_result_values prrv,
						   pay_run_results prr,
						   pay_payroll_rel_actions ppra,
						   pay_payroll_actions ppa_2,
						   pay_input_values_f PIV,
						   PAY_BALANCE_FEEDS_F PBFF_1    ,
                           PAY_BALANCE_TYPES_VL PBTT_1   ,
                           PAY_DEFINED_BALANCES PDB      ,
                           PAY_BALANCE_DIMENSIONS PBD    
                 WHERE prrv.run_result_id      = prr.run_result_id
						  and prr.payroll_rel_action_id   = ppra.payroll_rel_action_id
						  and prd.payroll_relationship_id = ppra.payroll_relationship_id
						  and ppra.payroll_action_id   = ppa_2.payroll_action_id
						  and ppra.retro_component_id is null
                          and ppa_2.action_type IN ('R','Q','CTG','B','I','V')
						  and PIV.element_type_id = prr.element_type_id
                          and PRRV.input_value_id = PIV.input_value_id
						  AND     prrv.INPUT_VALUE_ID       = PBFF_1.INPUT_VALUE_ID
							AND     PBFF_1.BALANCE_TYPE_ID      = PBTT_1.BALANCE_TYPE_ID
							AND     ppa_2.effective_date BETWEEN PBFF_1.EFFECTIVE_START_DATE AND PBFF_1.EFFECTIVE_END_DATE
							AND     PBTT_1.BALANCE_NAME  IN('Pension NR')
							AND     PBTT_1.BALANCE_TYPE_ID   = PDB.BALANCE_TYPE_ID
							AND     PDB.BALANCE_DIMENSION_ID = PBD.BALANCE_DIMENSION_ID
							AND     PBD.BASE_DIMENSION_NAME IN ('Core Relationship Tax Unit Year to Date')
						  and ppa_2.effective_date between :START_DATE and :END_DATE 
 and ppa_2.payroll_action_id = pra_1.payroll_action_id
and prr.payroll_rel_action_id = pra_1.payroll_rel_action_id
) "Pension NR YTD",

(SELECT prrv.RESULT_VALUE
               FROM pay_run_result_values prrv,
						   pay_run_results prr,
						   pay_payroll_rel_actions ppra,
						   pay_payroll_actions ppa_2,
						   pay_input_values_f PIV,
						   PAY_BALANCE_FEEDS_F PBFF_1    ,
                           PAY_BALANCE_TYPES_VL PBTT_1   ,
                           PAY_DEFINED_BALANCES PDB      ,
                           PAY_BALANCE_DIMENSIONS PBD    
                 WHERE prrv.run_result_id      = prr.run_result_id
						  and prr.payroll_rel_action_id   = ppra.payroll_rel_action_id
						  and prd.payroll_relationship_id = ppra.payroll_relationship_id
						  and ppra.payroll_action_id   = ppa_2.payroll_action_id
						  and ppra.retro_component_id is null
                          and ppa_2.action_type IN ('R','Q','CTG','B','I','V')
						  and PIV.element_type_id = prr.element_type_id
                          and PRRV.input_value_id = PIV.input_value_id
						  AND     prrv.INPUT_VALUE_ID       = PBFF_1.INPUT_VALUE_ID
							AND     PBFF_1.BALANCE_TYPE_ID      = PBTT_1.BALANCE_TYPE_ID
							AND     ppa_2.effective_date BETWEEN PBFF_1.EFFECTIVE_START_DATE AND PBFF_1.EFFECTIVE_END_DATE
							AND     PBTT_1.BALANCE_NAME  IN('Pension NR ER Contribution')
							AND     PBTT_1.BALANCE_TYPE_ID   = PDB.BALANCE_TYPE_ID
							AND     PDB.BALANCE_DIMENSION_ID = PBD.BALANCE_DIMENSION_ID
							AND     PBD.BASE_DIMENSION_NAME IN ('Core Relationship NoCB Run')
						  and ppa_2.effective_date between :START_DATE and :END_DATE 
 and ppa_2.payroll_action_id = pra_1.payroll_action_id
and prr.payroll_rel_action_id = pra_1.payroll_rel_action_id
) "Pension NR ER Current" ,

(SELECT prrv.RESULT_VALUE
               FROM pay_run_result_values prrv,
						   pay_run_results prr,
						   pay_payroll_rel_actions ppra,
						   pay_payroll_actions ppa_2,
						   pay_input_values_f PIV,
						   PAY_BALANCE_FEEDS_F PBFF_1    ,
                           PAY_BALANCE_TYPES_VL PBTT_1   ,
                           PAY_DEFINED_BALANCES PDB      ,
                           PAY_BALANCE_DIMENSIONS PBD    
                 WHERE prrv.run_result_id      = prr.run_result_id
						  and prr.payroll_rel_action_id   = ppra.payroll_rel_action_id
						  and prd.payroll_relationship_id = ppra.payroll_relationship_id
						  and ppra.payroll_action_id   = ppa_2.payroll_action_id
						  and ppra.retro_component_id is null
                          and ppa_2.action_type IN ('R','Q','CTG','B','I','V')
						  and PIV.element_type_id = prr.element_type_id
                          and PRRV.input_value_id = PIV.input_value_id
						  AND     prrv.INPUT_VALUE_ID       = PBFF_1.INPUT_VALUE_ID
							AND     PBFF_1.BALANCE_TYPE_ID      = PBTT_1.BALANCE_TYPE_ID
							AND     ppa_2.effective_date BETWEEN PBFF_1.EFFECTIVE_START_DATE AND PBFF_1.EFFECTIVE_END_DATE
							AND     PBTT_1.BALANCE_NAME  IN('Pension NR ER Contribution')
							AND     PBTT_1.BALANCE_TYPE_ID   = PDB.BALANCE_TYPE_ID
							AND     PDB.BALANCE_DIMENSION_ID = PBD.BALANCE_DIMENSION_ID
							AND     PBD.BASE_DIMENSION_NAME IN ('Core Relationship Tax Unit Year to Date')
						  and ppa_2.effective_date between :START_DATE and :END_DATE 
 and ppa_2.payroll_action_id = pra_1.payroll_action_id
and prr.payroll_rel_action_id = pra_1.payroll_rel_action_id
) "Pension NR ER YTD" ,

(SELECT prrv.RESULT_VALUE
               FROM pay_run_result_values prrv,
						   pay_run_results prr,
						   pay_payroll_rel_actions ppra,
						   pay_payroll_actions ppa_2,
						   pay_input_values_f PIV,
						   PAY_BALANCE_FEEDS_F PBFF_1    ,
                           PAY_BALANCE_TYPES_VL PBTT_1   ,
                           PAY_DEFINED_BALANCES PDB      ,
                           PAY_BALANCE_DIMENSIONS PBD    
                 WHERE prrv.run_result_id      = prr.run_result_id
						  and prr.payroll_rel_action_id   = ppra.payroll_rel_action_id
						  and prd.payroll_relationship_id = ppra.payroll_relationship_id
						  and ppra.payroll_action_id   = ppa_2.payroll_action_id
						  and ppra.retro_component_id is null
                          and ppa_2.action_type IN ('R','Q','CTG','B','I','V')
						  and PIV.element_type_id = prr.element_type_id
                          and PRRV.input_value_id = PIV.input_value_id
						  AND     prrv.INPUT_VALUE_ID       = PBFF_1.INPUT_VALUE_ID
							AND     PBFF_1.BALANCE_TYPE_ID      = PBTT_1.BALANCE_TYPE_ID
							AND     ppa_2.effective_date BETWEEN PBFF_1.EFFECTIVE_START_DATE AND PBFF_1.EFFECTIVE_END_DATE
							AND     PBTT_1.BALANCE_NAME  IN('Pension NR DC Eligible Compensation')
							AND     PBTT_1.BALANCE_TYPE_ID   = PDB.BALANCE_TYPE_ID
							AND     PDB.BALANCE_DIMENSION_ID = PBD.BALANCE_DIMENSION_ID
							AND     PBD.BASE_DIMENSION_NAME IN ('Core Relationship Tax Unit Run')
						  and ppa_2.effective_date between :START_DATE and :END_DATE 
 and ppa_2.payroll_action_id = pra_1.payroll_action_id
and prr.payroll_rel_action_id = pra_1.payroll_rel_action_id
) "Pension NR DC Wages Current", --Doubt

(SELECT prrv.RESULT_VALUE
               FROM pay_run_result_values prrv,
						   pay_run_results prr,
						   pay_payroll_rel_actions ppra,
						   pay_payroll_actions ppa_2,
						   pay_input_values_f PIV,
						   PAY_BALANCE_FEEDS_F PBFF_1    ,
                           PAY_BALANCE_TYPES_VL PBTT_1   ,
                           PAY_DEFINED_BALANCES PDB      ,
                           PAY_BALANCE_DIMENSIONS PBD    
                 WHERE prrv.run_result_id      = prr.run_result_id
						  and prr.payroll_rel_action_id   = ppra.payroll_rel_action_id
						  and prd.payroll_relationship_id = ppra.payroll_relationship_id
						  and ppra.payroll_action_id   = ppa_2.payroll_action_id
						  and ppra.retro_component_id is null
                          and ppa_2.action_type IN ('R','Q','CTG','B','I','V')
						  and PIV.element_type_id = prr.element_type_id
                          and PRRV.input_value_id = PIV.input_value_id
						  AND     prrv.INPUT_VALUE_ID       = PBFF_1.INPUT_VALUE_ID
							AND     PBFF_1.BALANCE_TYPE_ID      = PBTT_1.BALANCE_TYPE_ID
							AND     ppa_2.effective_date BETWEEN PBFF_1.EFFECTIVE_START_DATE AND PBFF_1.EFFECTIVE_END_DATE
							AND     PBTT_1.BALANCE_NAME  IN('Pension NR DC Eligible Compensation')
							AND     PBTT_1.BALANCE_TYPE_ID   = PDB.BALANCE_TYPE_ID
							AND     PDB.BALANCE_DIMENSION_ID = PBD.BALANCE_DIMENSION_ID
							AND     PBD.BASE_DIMENSION_NAME IN ('Core Relationship Tax Unit Year to Date')
						  and ppa_2.effective_date between :START_DATE and :END_DATE 
 and ppa_2.payroll_action_id = pra_1.payroll_action_id
and prr.payroll_rel_action_id = pra_1.payroll_rel_action_id
) "Pension NR DC Wages YTD" ,

(SELECT prrv.RESULT_VALUE
               FROM pay_run_result_values prrv,
						   pay_run_results prr,
						   pay_payroll_rel_actions ppra,
						   pay_payroll_actions ppa_2,
						   pay_input_values_f PIV,
						   PAY_BALANCE_FEEDS_F PBFF_1    ,
                           PAY_BALANCE_TYPES_VL PBTT_1   ,
                           PAY_DEFINED_BALANCES PDB      ,
                           PAY_BALANCE_DIMENSIONS PBD    
                 WHERE prrv.run_result_id      = prr.run_result_id
						  and prr.payroll_rel_action_id   = ppra.payroll_rel_action_id
						  and prd.payroll_relationship_id = ppra.payroll_relationship_id
						  and ppra.payroll_action_id   = ppa_2.payroll_action_id
						  and ppra.retro_component_id is null
                          and ppa_2.action_type IN ('R','Q','CTG','B','I','V')
						  and PIV.element_type_id = prr.element_type_id
                          and PRRV.input_value_id = PIV.input_value_id
						  AND     prrv.INPUT_VALUE_ID       = PBFF_1.INPUT_VALUE_ID
							AND     PBFF_1.BALANCE_TYPE_ID      = PBTT_1.BALANCE_TYPE_ID
							AND     ppa_2.effective_date BETWEEN PBFF_1.EFFECTIVE_START_DATE AND PBFF_1.EFFECTIVE_END_DATE
							AND     PBTT_1.BALANCE_NAME  IN('Pension NR DC')
							AND     PBTT_1.BALANCE_TYPE_ID   = PDB.BALANCE_TYPE_ID
							AND     PDB.BALANCE_DIMENSION_ID = PBD.BALANCE_DIMENSION_ID
							AND     PBD.BASE_DIMENSION_NAME IN ('Core Relationship Tax Unit Period to Date')
						  and ppa_2.effective_date between :START_DATE and :END_DATE 
 and ppa_2.payroll_action_id = pra_1.payroll_action_id
and prr.payroll_rel_action_id = pra_1.payroll_rel_action_id
) "Pension NR DC Current",

(SELECT prrv.RESULT_VALUE
               FROM pay_run_result_values prrv,
						   pay_run_results prr,
						   pay_payroll_rel_actions ppra,
						   pay_payroll_actions ppa_2,
						   pay_input_values_f PIV,
						   PAY_BALANCE_FEEDS_F PBFF_1    ,
                           PAY_BALANCE_TYPES_VL PBTT_1   ,
                           PAY_DEFINED_BALANCES PDB      ,
                           PAY_BALANCE_DIMENSIONS PBD    
                 WHERE prrv.run_result_id      = prr.run_result_id
						  and prr.payroll_rel_action_id   = ppra.payroll_rel_action_id
						  and prd.payroll_relationship_id = ppra.payroll_relationship_id
						  and ppra.payroll_action_id   = ppa_2.payroll_action_id
						  and ppra.retro_component_id is null
                          and ppa_2.action_type IN ('R','Q','CTG','B','I','V')
						  and PIV.element_type_id = prr.element_type_id
                          and PRRV.input_value_id = PIV.input_value_id
						  AND     prrv.INPUT_VALUE_ID       = PBFF_1.INPUT_VALUE_ID
							AND     PBFF_1.BALANCE_TYPE_ID      = PBTT_1.BALANCE_TYPE_ID
							AND     ppa_2.effective_date BETWEEN PBFF_1.EFFECTIVE_START_DATE AND PBFF_1.EFFECTIVE_END_DATE
							AND     PBTT_1.BALANCE_NAME  IN('Pension NR DC')
							AND     PBTT_1.BALANCE_TYPE_ID   = PDB.BALANCE_TYPE_ID
							AND     PDB.BALANCE_DIMENSION_ID = PBD.BALANCE_DIMENSION_ID
							AND     PBD.BASE_DIMENSION_NAME IN ('Core Relationship Tax Unit Year to Date')
						  and ppa_2.effective_date between :START_DATE and :END_DATE 
 and ppa_2.payroll_action_id = pra_1.payroll_action_id
and prr.payroll_rel_action_id = pra_1.payroll_rel_action_id
) "Pension NR DC YTD",

(SELECT prrv.RESULT_VALUE
               FROM pay_run_result_values prrv,
						   pay_run_results prr,
						   pay_payroll_rel_actions ppra,
						   pay_payroll_actions ppa_2,
						   pay_input_values_f PIV,
						   PAY_BALANCE_FEEDS_F PBFF_1    ,
                           PAY_BALANCE_TYPES_VL PBTT_1   ,
                           PAY_DEFINED_BALANCES PDB      ,
                           PAY_BALANCE_DIMENSIONS PBD    
                 WHERE prrv.run_result_id      = prr.run_result_id
						  and prr.payroll_rel_action_id   = ppra.payroll_rel_action_id
						  and prd.payroll_relationship_id = ppra.payroll_relationship_id
						  and ppra.payroll_action_id   = ppa_2.payroll_action_id
						  and ppra.retro_component_id is null
                          and ppa_2.action_type IN ('R','Q','CTG','B','I','V')
						  and PIV.element_type_id = prr.element_type_id
                          and PRRV.input_value_id = PIV.input_value_id
						  AND     prrv.INPUT_VALUE_ID       = PBFF_1.INPUT_VALUE_ID
							AND     PBFF_1.BALANCE_TYPE_ID      = PBTT_1.BALANCE_TYPE_ID
							AND     ppa_2.effective_date BETWEEN PBFF_1.EFFECTIVE_START_DATE AND PBFF_1.EFFECTIVE_END_DATE
							AND     PBTT_1.BALANCE_NAME  IN('Pension NR DC ER Contribution')
							AND     PBTT_1.BALANCE_TYPE_ID   = PDB.BALANCE_TYPE_ID
							AND     PDB.BALANCE_DIMENSION_ID = PBD.BALANCE_DIMENSION_ID
							AND     PBD.BASE_DIMENSION_NAME IN ('Core Relationship NoCB Run')
						  and ppa_2.effective_date between :START_DATE and :END_DATE 
 and ppa_2.payroll_action_id = pra_1.payroll_action_id
and prr.payroll_rel_action_id = pra_1.payroll_rel_action_id
) "Pension NR DC ER Current" ,

(SELECT prrv.RESULT_VALUE
               FROM pay_run_result_values prrv,
						   pay_run_results prr,
						   pay_payroll_rel_actions ppra,
						   pay_payroll_actions ppa_2,
						   pay_input_values_f PIV,
						   PAY_BALANCE_FEEDS_F PBFF_1    ,
                           PAY_BALANCE_TYPES_VL PBTT_1   ,
                           PAY_DEFINED_BALANCES PDB      ,
                           PAY_BALANCE_DIMENSIONS PBD    
                 WHERE prrv.run_result_id      = prr.run_result_id
						  and prr.payroll_rel_action_id   = ppra.payroll_rel_action_id
						  and prd.payroll_relationship_id = ppra.payroll_relationship_id
						  and ppra.payroll_action_id   = ppa_2.payroll_action_id
						  and ppra.retro_component_id is null
                          and ppa_2.action_type IN ('R','Q','CTG','B','I','V')
						  and PIV.element_type_id = prr.element_type_id
                          and PRRV.input_value_id = PIV.input_value_id
						  AND     prrv.INPUT_VALUE_ID       = PBFF_1.INPUT_VALUE_ID
							AND     PBFF_1.BALANCE_TYPE_ID      = PBTT_1.BALANCE_TYPE_ID
							AND     ppa_2.effective_date BETWEEN PBFF_1.EFFECTIVE_START_DATE AND PBFF_1.EFFECTIVE_END_DATE
							AND     PBTT_1.BALANCE_NAME  IN('Pension NR DC ER Contribution')
							AND     PBTT_1.BALANCE_TYPE_ID   = PDB.BALANCE_TYPE_ID
							AND     PDB.BALANCE_DIMENSION_ID = PBD.BALANCE_DIMENSION_ID
							AND     PBD.BASE_DIMENSION_NAME IN ('Core Relationship Tax Unit Year to Date')
						  and ppa_2.effective_date between :START_DATE and :END_DATE 
 and ppa_2.payroll_action_id = pra_1.payroll_action_id
and prr.payroll_rel_action_id = pra_1.payroll_rel_action_id
) "Pension NR DC ER YTD",

(SELECT prrv.RESULT_VALUE
               FROM pay_run_result_values prrv,
						   pay_run_results prr,
						   pay_payroll_rel_actions ppra,
						   pay_payroll_actions ppa_2,
						   pay_input_values_f PIV,
						   PAY_BALANCE_FEEDS_F PBFF_1    ,
                           PAY_BALANCE_TYPES_VL PBTT_1   ,
                           PAY_DEFINED_BALANCES PDB      ,
                           PAY_BALANCE_DIMENSIONS PBD    
                 WHERE prrv.run_result_id      = prr.run_result_id
						  and prr.payroll_rel_action_id   = ppra.payroll_rel_action_id
						  and prd.payroll_relationship_id = ppra.payroll_relationship_id
						  and ppra.payroll_action_id   = ppa_2.payroll_action_id
						  and ppra.retro_component_id is null
                          and ppa_2.action_type IN ('R','Q','CTG','B','I','V')
						  and PIV.element_type_id = prr.element_type_id
                          and PRRV.input_value_id = PIV.input_value_id
						  AND     prrv.INPUT_VALUE_ID       = PBFF_1.INPUT_VALUE_ID
							AND     PBFF_1.BALANCE_TYPE_ID      = PBTT_1.BALANCE_TYPE_ID
							AND     ppa_2.effective_date BETWEEN PBFF_1.EFFECTIVE_START_DATE AND PBFF_1.EFFECTIVE_END_DATE
							AND     PBTT_1.BALANCE_NAME  IN('MARTA Pension Police Hours')
							AND     PBTT_1.BALANCE_TYPE_ID   = PDB.BALANCE_TYPE_ID
							AND     PDB.BALANCE_DIMENSION_ID = PBD.BALANCE_DIMENSION_ID
							AND     PBD.BASE_DIMENSION_NAME IN ('Core Relationship NoCB Period to Date')
						  and ppa_2.effective_date between :START_DATE and :END_DATE 
 and ppa_2.payroll_action_id = pra_1.payroll_action_id
and prr.payroll_rel_action_id = pra_1.payroll_rel_action_id
) "Pension NR & Police Hours PTD" ,

(SELECT prrv.RESULT_VALUE
               FROM pay_run_result_values prrv,
						   pay_run_results prr,
						   pay_payroll_rel_actions ppra,
						   pay_payroll_actions ppa_2,
						   pay_input_values_f PIV,
						   PAY_BALANCE_FEEDS_F PBFF_1    ,
                           PAY_BALANCE_TYPES_VL PBTT_1   ,
                           PAY_DEFINED_BALANCES PDB      ,
                           PAY_BALANCE_DIMENSIONS PBD    
                 WHERE prrv.run_result_id      = prr.run_result_id
						  and prr.payroll_rel_action_id   = ppra.payroll_rel_action_id
						  and prd.payroll_relationship_id = ppra.payroll_relationship_id
						  and ppra.payroll_action_id   = ppa_2.payroll_action_id
						  and ppra.retro_component_id is null
                          and ppa_2.action_type IN ('R','Q','CTG','B','I','V')
						  and PIV.element_type_id = prr.element_type_id
                          and PRRV.input_value_id = PIV.input_value_id
						  AND     prrv.INPUT_VALUE_ID       = PBFF_1.INPUT_VALUE_ID
							AND     PBFF_1.BALANCE_TYPE_ID      = PBTT_1.BALANCE_TYPE_ID
							AND     ppa_2.effective_date BETWEEN PBFF_1.EFFECTIVE_START_DATE AND PBFF_1.EFFECTIVE_END_DATE
							AND     PBTT_1.BALANCE_NAME  IN('MARTA Pension Police Hours')
							AND     PBTT_1.BALANCE_TYPE_ID   = PDB.BALANCE_TYPE_ID
							AND     PDB.BALANCE_DIMENSION_ID = PBD.BALANCE_DIMENSION_ID
							AND     PBD.BASE_DIMENSION_NAME IN ('Core Relationship NoCB Year to Date')
						  and ppa_2.effective_date between :START_DATE and :END_DATE 
 and ppa_2.payroll_action_id = pra_1.payroll_action_id
and prr.payroll_rel_action_id = pra_1.payroll_rel_action_id
) "Pension NR & Police Hours YTD"


 FROM  
 PER_PERSON_NAMES_F PPNF,
 PER_ALL_ASSIGNMENTS_M PAAM,
 PER_PERIODS_OF_SERVICE PPOS,
 HR_ALL_POSITIONS_F_VL HAPFV,
 HR_ALL_ORGANIZATION_UNITS_F_VL HAOUF,
 pay_pay_relationships_dn prd
,pay_payroll_rel_actions pra_1
,pay_payroll_actions ppa_1
,pay_time_periods pay_prd
,pay_run_types_f prt
,per_all_people_f PAPF
--,PAY_OBJECT_GROUP_AMENDS POGA
--,PAY_OBJECT_GROUPS_VL POG

 where 1=1
-- AND ppa_1.effective_date <= nvl(:START_DATE, to_date('31/12/4712', 'DD/MM/YYYY'))  -- END_DATE 
 --and ppa_1.effective_date >= nvl(:END_DATE, to_date('01/01/0001', 'DD/MM/YYYY'))  -- START_DATE 
 AND PPNF.PERSON_ID = PAPF.PERSON_ID
	  AND PPNF.PERSON_ID = PAAM.PERSON_ID
	  AND PPNF.NAME_TYPE = 'GLOBAL'
      AND PAAM.ASSIGNMENT_TYPE ='E'
      AND PAAM.PRIMARY_ASSIGNMENT_FLAG ='Y'
      AND PAAM.EFFECTIVE_LATEST_CHANGE ='Y'
      AND PAAM.ASSIGNMENT_STATUS_TYPE IN ('ACTIVE','SUSPENDED')	
	  AND TRUNC(SYSDATE) BETWEEN PAPF.EFFECTIVE_START_DATE AND PAPF.EFFECTIVE_END_DATE
	  AND TRUNC(SYSDATE) BETWEEN PPNF.EFFECTIVE_START_DATE AND PPNF.EFFECTIVE_END_DATE
	  AND TRUNC(SYSDATE) BETWEEN PAAM.EFFECTIVE_START_DATE AND PAAM.EFFECTIVE_END_DATE
	  AND TRUNC(SYSDATE) BETWEEN HAPFV.EFFECTIVE_START_DATE AND HAPFV.EFFECTIVE_END_DATE
	  AND TRUNC(SYSDATE) BETWEEN HAOUF.EFFECTIVE_START_DATE AND HAOUF.EFFECTIVE_END_DATE
	  AND HAPFV.POSITION_ID	= PAAM.POSITION_ID
	  AND PAAM.UNION_ID = HAOUF.ORGANIZATION_ID
	  AND PPOS.PERIOD_OF_SERVICE_ID = PAAM.PERIOD_OF_SERVICE_ID
 and PRA_1.retro_component_id is null 

 
AND ppa_1.payroll_action_id = pra_1.payroll_action_id
and pra_1.payroll_relationship_id = prd.payroll_relationship_id
and pra_1.run_type_id is not null
and ppa_1.action_type in ('R','Q','CTG','B','I','V')
and pra_1.action_status='C'
and pay_prd.payroll_id= ppa_1.payroll_id
and pra_1.run_type_id = prt.run_type_id
and ppa_1.effective_date between pay_prd.start_date and pay_prd.end_date
and ppa_1.effective_date between prd.start_date and prd.end_date
and ppa_1.effective_date between prt.effective_start_date and prt.effective_end_date 
AND pay_prd.cut_off_date IS NOT NULL
AND pay_prd.PERIOD_CATEGORY = 'E'
and ppa_1.effective_date between :START_DATE and :END_DATE
and PAPF.person_id = pRD.person_id 
and ppa_1.effective_date between PAPF.effective_start_date and PAPF.effective_end_date 
AND PAAM.EMPLOYMENT_CATEGORY = 'FTP'
--AND prd.PAYROLL_RELATIONSHIP_ID = POGA.OBJECT_ID
--AND POGA.OBJECT_GROUP_ID = POG.OBJECT_GROUP_ID