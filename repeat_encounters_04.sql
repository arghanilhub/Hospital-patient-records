-- STAY in hospital (avg. no of days) 
-- Finding NO of DAYS on avg a patient STAYS in hospital in their each visits and the issues for which admitted 

with c1 as 	( select 	encounter_id, patient_id, encounter_start_date, encounter_stop_date, 
						datediff(encounter_stop_date, encounter_start_date) as no_of_days 
			 from 		encounters  
			)   ,
 
		c2 as	( select 	distinct e.encounter_id, 
							p.procedure_reason_description 
				  from 		encounters e inner join procedures p 
							on e.encounter_id = p.encounter_id ) 
                            
            select 	c1.encounter_id, c1.encounter_start_date, c1.encounter_stop_date,
					c1.no_of_days, c2.procedure_reason_description
            from  	c1 inner join c2 
					on c1.encounter_id = c2.encounter_id   
            order by  c1.no_of_days desc ; 

-- -------------------------------------------------------------------------------------------------  

/* 
with c1 as 	( select 	encounter_id, patient_id, encounter_start_date, encounter_stop_date, 
						datediff(encounter_stop_date, encounter_start_date) as no_of_days 
			 from 		encounters  
			) ,  

	c2 as		(	select * 
				from c1
                where encounter_id = '4079872d-73da-3b52-5306-2a978c6f5c8c'
				order by no_of_days desc 
		    	)	,			   
            
	 c3 as	    ( select 	distinct e.encounter_id, 
							p.procedure_reason_description, p.procedure_code_description 
				  from 		encounters e inner join procedures p 
							on e.encounter_id = p.encounter_id 
				) 
                
             select 	c2.encounter_id, c2.no_of_days, 
						c3.procedure_reason_description
                        -- c3.procedure_code_description  
             from   	c2 left join c3 
						on c2.encounter_id = c3.encounter_id  
*/ 
-- ----------------------------------------------------------------------------------------------------

-- Repeat encounters 
-- analyzing how many patient r coming back again - IS it for same issue or difft ? 

with c1 as 			( select 	patient_id, count(encounter_id) as visit_count 
					 from 		encounters 
					 group by 	patient_id  ) ,
            
		
		c2 as			( select  	c1.patient_id, p.first_name, c1.visit_count 
					  from 	 	c1 inner join patients p 
								on c1.patient_id = p.patient_id   ),
						  
			c3 as 	   (  select distinct patient_id, procedure_reason_description 
						  from procedures ) , 
			
	   c4 as	 ( select  	c2.first_name, c2.visit_count, c3.procedure_reason_description
				  from 		c2 inner join c3 
							on c2.patient_id = c3.patient_id 
				  order by  c2.visit_count desc ) ,           
		
		c5 as 	(	select  first_name, visit_count, count(procedure_reason_description) as no_of_issues
				from c4 
				group by first_name, visit_count ) 
                
           select *  
           from c5 
           where no_of_issues > 2 ; 