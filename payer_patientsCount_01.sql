-- Finding -> patients are preffering which payer/insurnce company more ? 

-- to do that, only one encounter table is enough, no need to join procedure table - bcz for this question we don't need any procedure data

with c1 as 		(select  distinct payer_id, patient_id 
				from encounters)  ,
																/* Reason behind of this 'distinct' is that : 
                                                               A patient has many visits, so a patient_id comeup many times. But we only need to know that patient with its corresponding payer only.
														       So, we need the unique pair of payer - and its corrosponding patient 
															   so that we can know, that patient is belong to that payer. 
                                                               and it needs be done only in this format: payer->patient , bcz patient may change payer over time. */  
                                                            
	c2 as		(	select payer_id, count(patient_id) as no_of_patients  
				from c1 
				group by payer_id 
				order by no_of_patients desc  ) 
                
             select		 p.payer_name, c2.no_of_patients  
             from 		 c2 left join payers p 
						 on c2.payer_id = p.payer_id      
                         
                                                             -- This gives the insight on, which payer is associated with most no of patients.
                                                             -- In the otherwords, patients r favoring which payer most 