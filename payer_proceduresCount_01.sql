-- Finding no of procedures covers by each payer. 
-- To know in general- > which payer is covering more procedures 

with c1 as 	(	select    
						e.encounter_id, e.payer_id, 
                        p.procedure_code, p.procedure_code_description, 
                        p.procedure_reason_code, p.procedure_reason_description 
						   
				from 	encounters e  inner join procedures p 
						on e.encounter_id = p.encounter_id  ) ,         
																		-- First, got the whole table which consist of columns from both the tables(encounters & procedures) 
																		-- so that, we could have both payer & procedure columns ( which basically we need to answer this question)
              
          c2 as   ( select 	distinct payer_id, procedure_code, procedure_code_description,
						    procedure_reason_code, procedure_reason_description 
              from 	c1 ) ,
                                                                        -- Next, we need unique set of records, where evry set of payer is associated with one distinct procedure only.
                                                                        -- that way, we could determine how many procedures each payer is covering WITHOUT GETTING ANY DUPLICATED RESULTS ( it will not over in-flate) 
                                                                        
           c3 as    ( select   payer_id, count(procedure_code) as no_of_procedures  
				from c2
				group by payer_id )                           
                                                                         -- Then, counting no of procedures for each payer 
                
          select  	   p.payer_name,  c3.no_of_procedures
          from 		   c3 left join payers p 
					   on c3.payer_id = p.payer_id  
		   order by    c3.no_of_procedures desc              
                                                                         -- Finally, attaching the payer's names by joing the payers table with c3.
                                                                         -- that way, now I know which payer covers how many procedures in total, which being carried out by hospital