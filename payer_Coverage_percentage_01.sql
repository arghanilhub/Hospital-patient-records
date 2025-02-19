-- Payer coverage % share for each procedure & 
-- also to analyze payer's coverage % share for any perticluar issue.

with c1 as 	(	select    
						e.encounter_id, p.procedure_code, p.procedure_code_description, 
						e.payer_id, e.total_claim_cost, e.payer_coverage 
				from 	encounters e  inner join procedures p 
						on e.encounter_id = p.encounter_id  
			) ,                                  
																	     -- created a table, which consist of every encounters and their procedures ( via joining encounter table with procedure table)
           
      c2 as   (  select  procedure_code, payer_id, sum(total_claim_cost) as total_claim_cost , 
		                 sum(payer_coverage) as payer_coverage,  
                         round( (( sum(payer_coverage)/ sum(total_claim_cost) ) * 100 ), 1) as coverage_percent                           
                 from c1
                 group by procedure_code, payer_id ) ,  
																	      -- finding payer_coverage % for every procedure
           
	 c3 as	( 	select   c2.procedure_code, pa.payer_name, c2.total_claim_cost, 
						 c2.payer_coverage, coverage_percent
				from	 c2 left join payers pa 
						 on c2.payer_id = pa.payer_id ) ,      
																	       -- joining payer names, to get payer's name 
           
      c4 as    (	select  distinct procedure_code, procedure_code_description,
							procedure_reason_description 
					from 	procedures)  ,                   
																		    -- created a temp. table of unique procedure_codes and its respective descriptions   
           
        c5 as    ( select   c3.procedure_code, c4.procedure_code_description, 
							c4.procedure_reason_description,
                            c3.total_claim_cost, c3.payer_coverage,c3.payer_name,
                            c3.coverage_percent 
                   from 	c3  left join c4 
							on c3.procedure_code = c4.procedure_code) ,   
																			-- joining c3 with c4, to get the procedure code and reason description for each of its procedure code
                
		c6 as	( select * , COUNT(*) OVER (PARTITION BY procedure_code) AS code_count
			      from c5 )                               
																			-- this tells us the no of procudeure_code occured due to subdivition of futher code_description & payers
																			-- done this bcz, it tells if we take any perticular procedure than how many records we r dealing with, which also gives us the sence to know how mnay subdivitions r present. 
            
          select   -- procedure_reason_description,
					-- procedure_code_description, 
					payer_name, total_claim_cost, coverage_percent 
          from c6   
          where procedure_reason_description  = 'Normal pregnancy'  AND procedure_code_description = 'Childbirth'  
          
        --  where procedure_code = 447365002                        
                                                                           -- Also knowin the coverage share for any perticular procedure/issue 