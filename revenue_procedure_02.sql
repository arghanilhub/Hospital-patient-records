-- REVENUE PROCEDURE 
-- analyzing from which procedure hospital has generated most revenue 

 with c1 as         ( select    
							e.encounter_id, p.procedure_code, p.procedure_code_description, 
							p.procedure_reason_code, p.procedure_reason_description, 
							e.payer_id, procedure_base_cost, e.total_claim_cost, e.payer_coverage 
					 from 		encounters e  inner join procedures p 
								on e.encounter_id = p.encounter_id ) ,
      
-- Table 1 -> procedure with its no. of visits       
		c2 as		(	select 
								procedure_code_description, procedure_reason_description,  
								count(distinct encounter_id) as visits
							--  count(distinct procedure_code_description) as procedure_count  
						from 		c1
						group by 	procedure_code_description, procedure_reason_description   
						order by 	visits desc ) , 
                                                                                  -- NOTE: To find reveue, we need-> frequency(no of times occured) * its base cost 
                                                                                  --       so, 1st we find out frquency in table1 - i.e number of encounters we got for every procedures hospital has done       
			 	
 -- Table 2 -> evry procedure with its base cost          
         c3 as (	select 
							distinct procedure_code_description,  procedure_base_cost
					from procedures 
	           ), 
                                                                                  -- NOTE: 2nd, here we r finding base cost for every procedures 
                                                                                  --       Now, we have multiple base costs for every procedures 
                                                                                  --       so we r taking only those which has highest amount

	c4 as	(select * , 
          row_number () over (partition by procedure_code_description order by procedure_base_cost desc ) as re 
			from c3 
			order by procedure_base_cost desc)  ,

	c5 as		 (	select procedure_code_description, procedure_base_cost 
					from c4 
					where re = 1  ) , 
																			       -- NOTE: in c4 & c5 -> I have used the window function to number the base cost for all procedures 
                                                                                   --        and then filter out only those which has highest for every procedure 
        
  -- Now joining Table 1 & Table 2 [ i.e c2 with c5 ]  
	c6 as    ( select 	c2.procedure_code_description, c2.procedure_reason_description, 
						c2.visits, c5.procedure_base_cost
			   from 	c2 left join c5 
						on c2.procedure_code_description = c5.procedure_code_description  ) , 
                        
-- calculating revenue for every procedure performed 					
	c7 as	(	select     procedure_code_description, procedure_reason_description, 
					       visits, procedure_base_cost, 
					       (visits * procedure_base_cost) as revenue 
			    from c6 ) 
                                                                                 -- NOTE: Finally after joining the frquenct table with base cost table 
                                                                                 --       we r multiplying the base cost with its frequnecy to find the revenue for that procedure
                
         select  procedure_code_description, procedure_reason_description, revenue 
         from c7 
         order by revenue desc ;  