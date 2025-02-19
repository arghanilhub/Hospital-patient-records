-- Showing the AGE GROUP of patients belong to Medicare company. 

with c1 as 		(select  distinct payer_id, patient_id 
				from encounters) ,   
																	-- First, I took the distinct players with their respective payer (pair)
                
	c2 as	   ( select		  p.payer_name, c1.patient_id 
				 from 		 c1 left join payers p 
							 on c1.payer_id = p.payer_id  
				 where       payer_name = 'Medicare'      ) ,       
																	-- Then, only see for those patients who has opted for "Medicare" payer
																	-- By joining payers table 1st so that we could indentify- which payer_id is Medicare , as the whole point to filter out, only for Medicare. 
																	-- then after knowing, filtered the rows only for Medicare
                 
		c3 as	( select patient_id,  (year(patient_death_date) - year(patient_birth_date)) as age  
				  from patients ) ,
																	-- Then, created a table which shows the years for each patients who r opted for medicare
																	-- as normal patient table has only birth and death dates so we need to extract years from it and then subtract it to know the excat no of years 
				  
																	-- and then finaly joins c2 and c3- to know the years for each patints 
                                                            
		c4 as	( select  	c2.payer_name, c2.patient_id, c3.age   
				  from 	    c2 left join c3  
							on c2.patient_id = c3.patient_id  
				  where 	age IS NOT NULL )     
																	-- THis code shows that, patients who belong to Medicare, they r genrally +60 in AGE group
																	-- THis also to check that - as MEdicare is for +60 age groups, we have those patients records who r actually +60 in theirs ages and falls in Medicare. 
                 
             select 	p.first_name, c4.age 
             from 		c4 left join patients p 
						on c4.patient_id = p.patient_id     
                                                                    -- fetching patient names 