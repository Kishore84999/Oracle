SELECT
    pername.display_name   person_name,
    docs.document_name     document_name,
    doctypes.document_type,
    docs.document_number   document_number,
    docs.date_to           expiration_date,
    trunc(nvl(docs.date_to,SYSDATE) ) - trunc(SYSDATE) days_before_expiration
FROM
    per_persons per,
    per_person_names_f pername,
    hr_dor_secured_list_v docs,
    hr_document_types_vl doctypes
WHERE 
    EXISTS (
        SELECT
            NULL
        FROM
            per_assignment_supervisors_f_v mgr
        WHERE
            ( ( mgr.person_id = per.person_id
                AND mgr.manager_id =:plinemanagerid
                AND SYSDATE BETWEEN mgr.effective_start_date AND mgr.effective_end_date
                AND mgr.manager_type = 'LINE_MANAGER' )
              OR (:plinemanagerid IS NULL ) )
    )
    AND EXISTS (
        SELECT
            NULL
        FROM
            per_assignment_supervisors_f_v mgr
        WHERE
            ( ( mgr.person_id = per.person_id
                AND mgr.manager_id =:phrmanagerid
                AND SYSDATE BETWEEN mgr.effective_start_date AND mgr.effective_end_date
                AND mgr.manager_type = 'HR_MANAGER' )
              OR (:phrmanagerid IS NULL ) )
    )
    AND EXISTS (
        SELECT
            NULL
        FROM
            per_all_assignments_m_v asg
        WHERE
            ( ( asg.person_id = per.person_id
                AND asg.organization_id =:pdepartmentid )
              OR (:pdepartmentid IS NULL ) )
    )
    AND per.person_id = pername.person_id
    AND pername.name_type = 'GLOBAL'
    AND SYSDATE BETWEEN pername.effective_start_date AND pername.effective_end_date
    AND docs.person_id = per.person_id
    AND docs.document_type_id = doctypes.document_type_id
    AND doctypes.warning_period > 0
    AND doctypes.date_to_required IN (
        'Y',
        'R'
    )
    AND docs.date_to IS NOT NULL
    AND trunc(nvl(docs.date_to,SYSDATE) ) - trunc(SYSDATE) >= 0