-- Analyzing Medicare(payer) coverage trend year-wise to see any kind of deflections in there payment is happeing or not

with c1 as 	(	select    
						e.encounter_id, p.procedure_code, p.procedure_code_description, 
						e.payer_id, e.total_claim_cost, e.payer_coverage, e.encounter_start_date  
				from 	encounters e  inner join procedures p 
						on e.encounter_id = p.encounter_id  
			 ) ,
           
      c2 as   (  select  procedure_code, payer_id, encounter_start_date, 
                         sum(total_claim_cost) as total_claim_cost , 
		                 sum(payer_coverage) as payer_coverage,  
                         round( (( sum(payer_coverage)/ sum(total_claim_cost) ) * 100 ), 1) as coverage_percent                           
                 from c1
                 group by procedure_code, payer_id, encounter_start_date ) ,  
														-- grouping by : procedure ->payer->start_date
           
	   c3 as    ( 	select 	c2.procedure_code, pa.payer_name, c2.encounter_start_date, c2.total_claim_cost, 
							c2.payer_coverage, coverage_percent
					from 	c2 left join payers pa 
							on c2.payer_id = pa.payer_id ) , 
													-- joining payer table for getting payer's name 
			                                       
       c4 as   ( 	select 	procedure_code, payer_name, year(encounter_start_date) as year,  
							total_claim_cost, payer_coverage, coverage_percent
					from 	c3
					where 	procedure_code IN ( '232717009', '43075005', '447365002')  AND  payer_name = 'Medicare' ) ,
														-- calculating coverage trend on years for only Medicare on top 3 issues

		c5 as ( select  distinct procedure_code, procedure_reason_description 
				from procedures 
				where procedure_code IN ( '232717009', '43075005', '447365002') )   
														-- temp  table of procedures, so that we can get only distinct p_code
                                                        -- we created temp table , so that we could get decription names for each p_code 
                                                        -- and safe from getting DUPLICATED records. 
                
            select  c5.procedure_reason_description, c4.payer_name, 
                    c4.year, 
                    -- c4.total_claim_cost, c4.payer_coverage, 
                    c4.coverage_percent 
            from    c4 left join c5 
                  on c4.procedure_code = c5.procedure_code  
			                                    -- we joined, c4 and c5 
                                                -- and get to see the coverage for medicare year-wise for  those 3 selected issues.
                                                -- reason behind this is to see that- does medicare paying rate has been same or is ther any defelction year-wise. 