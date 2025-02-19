-- PATIENT INFLUX & AVG. COST PER VISIT ( 2 things I'm calculating ) 

/* 1. Calculating PATIENT INFLUX per year and then finding - Does the patient incoming has inc/dec within 3 year 
      window , in all these 12 year time period */ 
/*
with c1 as 		(	select 
					year(encounter_start_date) as year,
					 encounter_id
			from encounters ) ,

		c2 as	(	select year, 
						count(encounter_id) as no_of_visits          -- -- no of visits per year 
				from c1 
				group by year 
				order by year )       
																			-- same thing we r doing as down code 
                                                                            -- only couting the number of patient in each year 
                                                                            -- and then finding its mov avg of 3 year to get the smmoth trend of patient influx within a 3 year window
			select year, no_of_visits, 
			   round(avg(no_of_visits) over (order by year rows between 2 preceding and current row), 1) as mov_avg   
			from c2 
*/                                                          
-- ----------------------------------------------------------------------------------------------------  
 
 /* 
2.   Calculating AVG. COST PER VISIT for each year and then finding whrther the cost has dec or inc 
     within these 3 year window , in all these 12year period */ 
 
/* 
with c1 as 		(	select 
					year(encounter_start_date) as year,
					total_claim_cost 
			from encounters ) , 

	c2 as  (	select year, 
						round(AVG(total_claim_cost), 2) as avg_cost        
				from c1 
				group by year 
				order by year )            
																			-- here after finding avg cost in each year 
                                                                            -- I need ti find moving avg for 3 years, so that i get smooth trend line which helps me to detect does the cost is inc or dec over the years
                                                                            -- hence I used window fucntion for avg of 3 years 
		 select year, avg_cost,                                      
			   round(avg(avg_cost) over (order by year rows between 2 preceding and current row), 1) as mov_avg   
			 from c2                                           
*/             

-- ----------------------------------------------------------------------------------------
-- 3. seeing YEAR-OVER-YEAR cost differnce in visits.  Basically to see year wise cost deflections 


with c1 as 		(	select 
							year(encounter_start_date) as year,
							total_claim_cost 
					from 	encounters ) , 

	c2 as  (			select  year, 
								round(AVG(total_claim_cost), 2) as avg_cost        
						from    c1 
						group by year 
						order by year ) , 
                
		c3 as		(	select 	year, avg_cost,                                        
								lag(avg_cost) over (order by year)  as lag_val    
						from 	c2   )    
                                                                        -- here i just used LAG window function
                                                                        -- so that, i can get the prev record of avg cost coloumn and then be able to subtract it
                                                                        -- in that way, we know the year over year differnce 
                select 	year, (avg_cost - lag_val) as yoy 
                from 	c3               