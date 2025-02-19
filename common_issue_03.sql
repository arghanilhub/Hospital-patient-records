-- MOST COMMON ISSUES 
-- What is that issue, for which patients have been visiting hospital most ?  
-- basically u want to know - what is that procedure which has been done most number of times, through this
-- we can also able to know that-> what is that issue people r facing too much 

/*
with c1 as         ( select    
							e.encounter_id, p.procedure_code, p.procedure_code_description, 
							p.procedure_reason_code, p.procedure_reason_description, e.encounter_start_date, 
							e.payer_id, procedure_base_cost, e.total_claim_cost, e.payer_coverage 
					 from 	encounters e  inner join procedures p 
							on e.encounter_id = p.encounter_id ) 
    
															-- here I'm counting every unique visit which has been made for every ISSUE (procedure_reason_description)
				select 
						procedure_reason_description,  
						count(distinct encounter_id) as visits
					-- count(distinct procedure_code_description) as procedure_count  
				from c1
                group by  procedure_reason_description                              -- issues
                order by visits desc 
			 	
	 
                
  */
 -- ------------------------------------------------------------------------------------------------- 
 
-- Depression trend  
-- Each year , how many depression patient we r seeing ? Can we see any trend, that from which year - it is inc or dec
 
with c1 as 	 ( select   distinct e.encounter_id, year(e.encounter_start_date) as year, 
						p.procedure_reason_description, p.procedure_code_description 
			   from     encounters e  inner join procedures p 
						on e.encounter_id = p.encounter_id  
			  where    p.procedure_code_description = 'Depression screening (procedure)'   )    
			  
    select procedure_code_description, year, count(encounter_id) as visit_counts 
    from c1 
    group by procedure_code_description, year 
    