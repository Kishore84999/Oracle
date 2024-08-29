
WITH balance_dimensions AS
        (       SELECT
                        dbal.defined_balance_id         ,
                        TYPES.balance_name              ,
                        TYPES.legislation_code          ,
                        TYPES.legislative_data_group_id ,
                        BASE_DIMENSION_NAME             ,
                        dims.base_db_item_suffix
                FROM
                        fusion.pay_balance_types_vl types  ,
                        fusion.pay_balance_dimensions dims ,
                        fusion.pay_defined_balances dbal   ,
                        PER_LEGISLATIVE_DATA_GROUPS_VL LDG
                WHERE 1=1
                AND     dims.base_db_item_suffix IN ('_CORE_REL_NOCB_PTD','_CORE_REL_NOCB_YTD' , '_CORE_REL_NOCB_RUN')
                AND     dbal.balance_dimension_id = dims.balance_dimension_id
                AND     dbal.balance_type_id      = TYPES.balance_type_id
                AND     (types.legislation_code = 'US' OR types.CURRENCY_CODE  = 'USD')
        )

SELECT  
PAAM.ASSIGNMENT_NUMBER   AS ASSIGNMENT_NUMBER ,
PAPF.PERSON_NUMBER EMPLOYEE_NUMBER,
HAPFV.NAME POSITION_NAME,
PPNF.LAST_NAME || ',' || PPNF.FIRST_NAME EMPLOYEE_NAME,

        TO_CHAR(PPA_1.DATE_EARNED, 'DD-Mon-YYYY', 'NLS_DATE_LANGUAGE=ENGLISH') AS DATE_EARNED ,
		(CASE WHEN SALARY_BASIS_CODE = 'BIWEEKLY' THEN SAL.SALARY_AMOUNT 
		     WHEN SALARY_BASIS_CODE = 'HOURLY' THEN SAL.SALARY_AMOUNT*PAAM.NORMAL_HOURS
        END	) Biweekly_Salary,
		SAL.ANNUAL_SALARY,
		((6*(CASE WHEN SALARY_BASIS_CODE = 'BIWEEKLY' THEN SAL.SALARY_AMOUNT 
		     WHEN SALARY_BASIS_CODE = 'HOURLY' THEN SAL.SALARY_AMOUNT*PAAM.NORMAL_HOURS
        END	))/100 ) BW_Chng_sal,
        NVL(  (fusion.pay_balance_pkg.get_value_dbi (
                ( SELECT defined_balance_id FROM balance_dimensions
                        WHERE balance_name = 'FIT Withheld'
                        AND     base_db_item_suffix = '_CORE_REL_NOCB_YTD'),PRA_1.payroll_rel_action_id,NULL , NULL, NULL,NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,NULL ) )
       ,0) AS FIT_WITHHELD_YTD ,
	   
	   
	   NVL( (fusion.pay_balance_pkg.get_value_dbi (
                ( SELECT defined_balance_id FROM balance_dimensions
                        WHERE balance_name = 'SIT Withheld'
                        AND     base_db_item_suffix = '_CORE_REL_NOCB_YTD'),PRA_1.payroll_rel_action_id,NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,NULL ) )
						,0) AS SIT_WITHHELD_YTD ,
		
		NVL( (fusion.pay_balance_pkg.get_value_dbi (
                ( SELECT defined_balance_id FROM balance_dimensions
                        WHERE balance_name = 'Social Security Employee Withheld'
                        AND     base_db_item_suffix = '_CORE_REL_NOCB_YTD'),PRA_1.payroll_rel_action_id,NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,NULL ) )
        ,0) AS Social_Security_YTD ,
		
		NVL(  (fusion.pay_balance_pkg.get_value_dbi (
                ( SELECT defined_balance_id FROM balance_dimensions
                        WHERE balance_name = 'Medicare Employee Withheld'
                        AND     base_db_item_suffix = '_CORE_REL_NOCB_YTD'),PRA_1.payroll_rel_action_id,NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,NULL ) )
        ,0) AS Medicare_YTD ,
		
		NVL(  (fusion.pay_balance_pkg.get_value_dbi (
                ( SELECT defined_balance_id FROM balance_dimensions
                        WHERE balance_name = 'Pretax Deductions'
                        AND     base_db_item_suffix = '_CORE_REL_NOCB_YTD'),PRA_1.payroll_rel_action_id,NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,NULL ) )
        ,0) AS Insurance_Benfits_YTD ,
		
		NVL( (fusion.pay_balance_pkg.get_value_dbi (
                ( SELECT defined_balance_id FROM balance_dimensions
                        WHERE balance_name = 'Net Payment'
                        AND     base_db_item_suffix = '_CORE_REL_NOCB_YTD'),PRA_1.payroll_rel_action_id,NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,NULL ) )
       ,0) AS Take_Home_Pay_YTD ,
		
		NVL(  (fusion.pay_balance_pkg.get_value_dbi (
                ( SELECT defined_balance_id FROM balance_dimensions
                        WHERE balance_name = 'Gross Pay'
                        AND     base_db_item_suffix = '_CORE_REL_NOCB_YTD'),PRA_1.payroll_rel_action_id,NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,NULL ) )
        ,0) AS Gross_Pay ,
		
		NVL(  (fusion.pay_balance_pkg.get_value_dbi (
                ( SELECT defined_balance_id FROM balance_dimensions
                        WHERE balance_name = 'Voluntary Deductions'
                        AND     base_db_item_suffix = '_CORE_REL_NOCB_YTD'),PRA_1.payroll_rel_action_id,NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,NULL ) )
        ,0) AS Voluntary_Deduction_YTD ,
		
		NVL(  (fusion.pay_balance_pkg.get_value_dbi (
                ( SELECT defined_balance_id FROM balance_dimensions
                        WHERE balance_name = 'Involuntary Deductions'
                        AND     base_db_item_suffix = '_CORE_REL_NOCB_YTD'),PRA_1.payroll_rel_action_id,NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,NULL ) )
        ,0) AS Involuntary_Deduction_YTD ,
		
		NVL(  (fusion.pay_balance_pkg.get_value_dbi (
                ( SELECT defined_balance_id FROM balance_dimensions
                        WHERE balance_name = 'Pension NR'
                        AND     base_db_item_suffix = '_CORE_REL_NOCB_YTD'),PRA_1.payroll_rel_action_id,NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,NULL ) )
        ,0) AS Pension_NR_YTD ,
		
		NVL(  (fusion.pay_balance_pkg.get_value_dbi (
                ( SELECT defined_balance_id FROM balance_dimensions
                        WHERE balance_name = 'Pension NR DC'
                        AND     base_db_item_suffix = '_CORE_REL_NOCB_YTD'),PRA_1.payroll_rel_action_id,NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,NULL ) )
       ,0) AS Pension_NR_DC_YTD ,
		
		NVL(  (fusion.pay_balance_pkg.get_value_dbi (
                ( SELECT defined_balance_id FROM balance_dimensions
                        WHERE balance_name = 'Pension Police'
                        AND     base_db_item_suffix = '_CORE_REL_NOCB_YTD'),PRA_1.payroll_rel_action_id,NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,NULL ) )
       ,0) AS Pension_Police_YTD ,
		
		NVL(  (fusion.pay_balance_pkg.get_value_dbi (
                ( SELECT defined_balance_id FROM balance_dimensions
                        WHERE balance_name = 'Pension Police DC'
                        AND     base_db_item_suffix = '_CORE_REL_NOCB_YTD'),PRA_1.payroll_rel_action_id,NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,NULL ) )
        ,0) AS Pension_Police_DC_YTD ,
		
		NVL(  (fusion.pay_balance_pkg.get_value_dbi (
                ( SELECT defined_balance_id FROM balance_dimensions
                        WHERE balance_name = 'Pension Union'
                        AND     base_db_item_suffix = '_CORE_REL_NOCB_YTD'),PRA_1.payroll_rel_action_id,NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,NULL ) )
       ,0) AS Pension_Union_YTD ,
	   
	   
	   
	   
	   NVL(  (fusion.pay_balance_pkg.get_value_dbi (
                ( SELECT defined_balance_id FROM balance_dimensions
                        WHERE balance_name = 'FIT Withheld'
                        AND     base_db_item_suffix = '_CORE_REL_NOCB_PTD'),PRA_1.payroll_rel_action_id,NULL , NULL, NULL,ppa_1.payroll_id, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,NULL ) )
       ,0) AS FIT_WITHHELD_PTD ,
	   
	   
	   NVL( (fusion.pay_balance_pkg.get_value_dbi (
                ( SELECT defined_balance_id FROM balance_dimensions
                        WHERE balance_name = 'SIT Withheld'
                        AND     base_db_item_suffix = '_CORE_REL_NOCB_PTD'),PRA_1.payroll_rel_action_id,NULL, NULL, NULL, ppa_1.payroll_id, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,NULL ) )
						,0) AS SIT_WITHHELD_PTD ,
		
		NVL( (fusion.pay_balance_pkg.get_value_dbi (
                ( SELECT defined_balance_id FROM balance_dimensions
                        WHERE balance_name = 'Social Security Employee Withheld'
                        AND     base_db_item_suffix = '_CORE_REL_NOCB_PTD'),PRA_1.payroll_rel_action_id,NULL, NULL, NULL, ppa_1.payroll_id, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,NULL ) )
        ,0) AS Social_Security_PTD ,
		
		NVL(  (fusion.pay_balance_pkg.get_value_dbi (
                ( SELECT defined_balance_id FROM balance_dimensions
                        WHERE balance_name = 'Medicare Employee Withheld'
                        AND     base_db_item_suffix = '_CORE_REL_NOCB_PTD'),PRA_1.payroll_rel_action_id,NULL, NULL, NULL, ppa_1.payroll_id, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,NULL ) )
        ,0) AS Medicare_PTD ,
		
		NVL(  (fusion.pay_balance_pkg.get_value_dbi (
                ( SELECT defined_balance_id FROM balance_dimensions
                        WHERE balance_name = 'Pretax Deductions'
                        AND     base_db_item_suffix = '_CORE_REL_NOCB_PTD'),PRA_1.payroll_rel_action_id,NULL, NULL, NULL, ppa_1.payroll_id, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,NULL ) )
        ,0) AS Insurance_Benfits_PTD ,
		
		NVL( (fusion.pay_balance_pkg.get_value_dbi (
                ( SELECT defined_balance_id FROM balance_dimensions
                        WHERE balance_name = 'Net Payment'
                        AND     base_db_item_suffix = '_CORE_REL_NOCB_PTD'),PRA_1.payroll_rel_action_id,NULL, NULL, NULL, ppa_1.payroll_id, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,NULL ) )
       ,0) AS Take_Home_Pay_PTD ,
		
		NVL(  (fusion.pay_balance_pkg.get_value_dbi (
                ( SELECT defined_balance_id FROM balance_dimensions
                        WHERE balance_name = 'Gross Pay'
                        AND     base_db_item_suffix = '_CORE_REL_NOCB_PTD'),PRA_1.payroll_rel_action_id,NULL, NULL, NULL, ppa_1.payroll_id, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,NULL ) )
        ,0) AS BW_GrossPay ,
		
		
		NVL(  (6*(fusion.pay_balance_pkg.get_value_dbi (
                ( SELECT defined_balance_id FROM balance_dimensions
                        WHERE balance_name = 'Gross Pay'
                        AND     base_db_item_suffix = '_CORE_REL_NOCB_PTD'),PRA_1.payroll_rel_action_id,NULL, NULL, NULL, ppa_1.payroll_id, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,NULL ) )/100)
        ,0) AS BW_Chng_Gpay ,
		
		NVL(  (fusion.pay_balance_pkg.get_value_dbi (
                ( SELECT defined_balance_id FROM balance_dimensions
                        WHERE balance_name = 'Voluntary Deductions'
                        AND     base_db_item_suffix = '_CORE_REL_NOCB_PTD'),PRA_1.payroll_rel_action_id,NULL, NULL, NULL, ppa_1.payroll_id, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,NULL ) )
        ,0) AS Voluntary_Deduction_PTD ,
		
		NVL(  (fusion.pay_balance_pkg.get_value_dbi (
                ( SELECT defined_balance_id FROM balance_dimensions
                        WHERE balance_name = 'Involuntary Deductions'
                        AND     base_db_item_suffix = '_CORE_REL_NOCB_PTD'),PRA_1.payroll_rel_action_id,NULL, NULL, NULL, ppa_1.payroll_id, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,NULL ) )
        ,0) AS Involuntary_Deduction_PTD ,
		
		NVL(  (fusion.pay_balance_pkg.get_value_dbi (
                ( SELECT defined_balance_id FROM balance_dimensions
                        WHERE balance_name = 'Pension NR'
                        AND     base_db_item_suffix = '_CORE_REL_NOCB_PTD'),PRA_1.payroll_rel_action_id,NULL, NULL, NULL, ppa_1.payroll_id, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,NULL ) )
        ,0) AS Pension_NR_PTD ,
		
		NVL(  (fusion.pay_balance_pkg.get_value_dbi (
                ( SELECT defined_balance_id FROM balance_dimensions
                        WHERE balance_name = 'Pension NR DC'
                        AND     base_db_item_suffix = '_CORE_REL_NOCB_PTD'),PRA_1.payroll_rel_action_id,NULL, NULL, NULL, ppa_1.payroll_id, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,NULL ) )
       ,0) AS Pension_NR_DC_PTD ,
		
		NVL(  (fusion.pay_balance_pkg.get_value_dbi (
                ( SELECT defined_balance_id FROM balance_dimensions
                        WHERE balance_name = 'Pension Police'
                        AND     base_db_item_suffix = '_CORE_REL_NOCB_PTD'),PRA_1.payroll_rel_action_id,NULL, NULL, NULL, ppa_1.payroll_id, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,NULL ) )
       ,0) AS Pension_Police_PTD ,
		
		NVL(  (fusion.pay_balance_pkg.get_value_dbi (
                ( SELECT defined_balance_id FROM balance_dimensions
                        WHERE balance_name = 'Pension Police DC'
                        AND     base_db_item_suffix = '_CORE_REL_NOCB_PTD'),PRA_1.payroll_rel_action_id,NULL, NULL, NULL, ppa_1.payroll_id, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,NULL ) )
        ,0) AS Pension_Police_DC_PTD ,
		
		NVL(  (fusion.pay_balance_pkg.get_value_dbi (
                ( SELECT defined_balance_id FROM balance_dimensions
                        WHERE balance_name = 'Pension Union'
                        AND     base_db_item_suffix = '_CORE_REL_NOCB_PTD'),PRA_1.payroll_rel_action_id,NULL, NULL, NULL, ppa_1.payroll_id, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,NULL ) )
       ,0) AS Pension_Union_PTD
FROM  
pay_pay_relationships_dn prd ,
pay_payroll_rel_actions pra_1,
pay_payroll_actions ppa_1,
PAY_REL_GROUPS_DN PRG,
PER_ALL_ASSIGNMENTS_F PAAM,
PER_ALL_PEOPLE_F PAPF,
HR_ALL_POSITIONS_F_VL HAPFV,
PER_PERSON_NAMES_F PPNF,
CMP_SALARY SAL 
where ppa_1.payroll_action_id = pra_1.payroll_action_id 
and pra_1.payroll_relationship_id = prd.payroll_relationship_id
AND PRA_1.payroll_relationship_id = PRG.payroll_relationship_id 
and pra_1.run_type_id is not null 
and ppa_1.action_type in ('R','Q','B','I','V') 
and pra_1.action_status ='C'   
and ppa_1.effective_date between prd.start_date and prd.end_date 

AND PAAM.ASSIGNMENT_ID = PRG.ASSIGNMENT_ID
and ppa_1.effective_date between PAAM.effective_start_date and PAAM.effective_end_date 
AND PAAM.ASSIGNMENT_ID = SAL.ASSIGNMENT_ID
AND PAAM.EFFECTIVE_START_DATE BETWEEN SAL.DATE_FROM AND SAL.DATE_TO
AND PAAM.PERSON_ID = PAPF.PERSON_ID
and ppa_1.effective_date between PAPF.effective_start_date and PAPF.effective_end_date
AND PAAM.POSITION_ID = HAPFV.POSITION_ID
and ppa_1.effective_date between HAPFV.effective_start_date and HAPFV.effective_end_date
AND PAPF.PERSON_ID = PPNF.PERSON_ID
AND PPNF.NAME_TYPE = 'GLOBAL'
and ppa_1.effective_date between PPNF.effective_start_date and PPNF.effective_end_date
and ppa_1.effective_date <= :EFFECTIVE_DATE 
and pra_1.payroll_rel_action_id IN (SELECT max(ppra.payroll_rel_action_id)
FROM 
pay_run_results prr,
pay_payroll_rel_actions ppra,
pay_payroll_actions ppa_2,
PAY_BALANCE_FEEDS_F PBFF_1 ,
PAY_BALANCE_TYPES_VL PBTT_1   
WHERE 1=1
and prr.payroll_rel_action_id   = ppra.payroll_rel_action_id
and PRD.payroll_relationship_id = ppra.payroll_relationship_id
and ppra.payroll_action_id   = ppa_2.payroll_action_id
and ppra.retro_component_id is null
and ppa_2.action_type IN ('R','Q','B','I','V')
and PRR.element_type_id = PBFF_1.element_type_id
AND PBFF_1.BALANCE_TYPE_ID = PBTT_1.BALANCE_TYPE_ID
AND ppa_2.effective_date BETWEEN PBFF_1.EFFECTIVE_START_DATE AND PBFF_1.EFFECTIVE_END_DATE
AND PBTT_1.BALANCE_NAME IN (SELECT HL.MEANING FROM HCM_LOOKUPS HL WHERE HL.LOOKUP_TYPE = 'MARTA_BASEPAY_CALC')
and ppa_2.effective_date <= :EFFECTIVE_DATE 
)

AND PAAM.ASSIGNMENT_ID in (select max(rel_g.assignment_id)
FROM  pay_rel_groups_dn rel_g
WHERE 1=1
and rel_g.group_type     = 'A'
and PRD.payroll_relationship_id  = rel_g.payroll_relationship_id
and :EFFECTIVE_DATE  between rel_g.start_date and rel_g.end_date
)

/* AND     PAAM.ASSIGNMENT_ID =
        (SELECT MAX(REL0.ASSIGNMENT_ID)
                FROM
                        PAY_REL_GROUPS_DN REL0         ,
                        PAY_PAYROLL_REL_ACTIONS REL_ACT,
                        PAY_ACTION_CONTEXTS REL_ACT_CN
                WHERE
                        REL0.PAYROLL_RELATIONSHIP_ID     = PRG.PAYROLL_RELATIONSHIP_ID
                AND     REL_ACT.PAYROLL_RELATIONSHIP_ID  = REL0.PAYROLL_RELATIONSHIP_ID
                AND     REL_ACT_CN.PAYROLL_REL_ACTION_ID = REL_ACT.PAYROLL_REL_ACTION_ID
                AND     REL_ACT.PAYROLL_REL_ACTION_ID    = PRA_1.PAYROLL_REL_ACTION_ID
                AND     REL_ACT.PAYROLL_ACTION_ID        = PRA_1.PAYROLL_ACTION_ID
                AND     ( (REL_ACT_CN.PAYROLL_ASSIGNMENT_ID IS NOT NULL
                                AND REL_ACT_CN.PAYROLL_TERM_ID IS NOT NULL
                                AND REL0.RELATIONSHIP_GROUP_ID = REL_ACT_CN.PAYROLL_ASSIGNMENT_ID )
                        OR (REL_ACT_CN.PAYROLL_ASSIGNMENT_ID IS NULL ) ) 
		) */