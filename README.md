<img src="https://github.com/arghanilhub/Hospital-patient-records/blob/main/hospital%20_logo.png" alt="hospital_logo" width="59" height="72"> 
<h1>Hospital-patient-records</h1> 

Analysis conducted on synthetic data of approximately 1,000 patients from **Massachusetts General Hospital** records, covering the years 2011–2022.    
<br> 

<h3>CONTENTS </h3> 
<hr> 

* Situation </br> 
* Data Structure </br> 
* Executive Summary </br>
* Detailed Findings </br>
* Recommandations </br>
<br>

<h3>Situation</h3> 
<hr> 

Massachusetts General Hospital has been observing a steady increase in patient admissions over the past decade, and hospital administrators are keen on understanding key trends in their **patient population**, **medical procedures**, and **insurance coverage**. As a data analyst, I have been brought in to conduct a deep dive into the hospital’s records from 2011 to 2022. </br> 
<br>  

**The Hospital’s Concern:** <br> 
Hospital leadership has identified several pressing concerns that require data-driven insights: </br> 

* **Insurance Coverage & Payer Analysis –** With multiple insurance companies covering patient procedures, the hospital wants to understand which insurers provide better coverage for critical treatments. Are there any gaps in coverage that patients frequently struggle with? </br>
  
* **Pressing medical issues -** Analyzing the most pressing medical issues bringing patients to the hospital—whether there’s been a recent surge or if it’s been a long-term trend. </br>

* **Procedure Trends & Future Planning –** The hospital needs to know which medical procedures generates the most revenue for the hospital and which one has been performed the most. What kind of medical procedures associated with some critical issues ? This helps identify the most common health concerns and what resources should be stocked accordingly. </br>

* **Patient Flow –** Were there any specific years when patient admissions spiked based on any perticular health issue? Is there any re-admission trends? </br> 

By uncovering key patterns in their patient records, hospital can make data-driven decisions for operational efficiency, financial planning, and future preparedness. My analysis will provide actionable insights, allowing them to : </br> 

:white_check_mark: Negotiate better deals with insurance companies. </br>
:white_check_mark: Analyzing critical threats for coming-days and resource planning based on that. </br>
:white_check_mark: Ensure adequate staffing and equipment availability for common medical procedures. </br>
:white_check_mark: Re-admission with same issue, could indicate gaps in care; if different, it may suggest strong patient trust in the hospital. </br>
<br> 

<h3>Data Structure</h3> 
<hr> 

The database consists of **five interconnected tables** categorized under healthcare, time series, and geospatial data. It contains detailed information on patient demographics, insurance coverage, medical encounters, and procedures recorded at Massachusetts General Hospital from 2011 to 2022. Each table captures a distinct aspect of hospital operations, allowing for comprehensive analysis. </br> 

**Below is a breakdown of the data stored in each table:** </br> 

**1. Encounters** </br> 
The dataset contains **27,000 unique hospital visit (encounter) records** from 2011 to 2022. Each patient may have multiple encounters over time, with each visit recorded as a separate entry. The table includes **duration** of each encounter, along with **total claim amount** and **payer coverage amount** for every visit. The number of unique patients in the dataset is **974**.

**2. Procedures** </br> 
This table records **procedures performed for each hospital encounter**. In a single visit, many different or same procedures have been performed, which are differentiated based on different days or hours of the day. Hence the total records in this table has **more than 44k**. It consist of issue(**46** unique procedure **reason**) for which that procedure has been performed and not all the procedures have reason/issue , which means they represent the critical issues. Base cost is also recorded for each distinct procedure, with some procedures having multiple base costs. While **no explicit primary key is defined**, unique records can be identified using a combination of :

&nbsp; &nbsp; &nbsp; &nbsp;  <blockquote>**encounter_id, start_day, start_time, and procedure_code**</blockquote>  </br>  

 **3. Patients** </br> 
Total of **974 unique patient** records are being given aongwith their demographic details and all patient have its encounter-id. </br> 

**4. Payers** </br> 
Total **9 insurance company** data are being provided and each companies payer coverage has been provided for ever patient respective to their encounters.  </br> 

**5. Organization** </br> 
Here the hospital name and its location details are being provided. </br>  
<br> 

![hospital_erd](https://github.com/arghanilhub/Hospital-patient-records/blob/main/hospital_erd.png) </br> 
<br>

data source : [syntheticMass](https://synthea.mitre.org)  </br> 
<br> 

<h3>Executive Summary</h3>
<hr>

hjgdss </br> 
<br> 

<h3>Detailed findinds</h3>
<hr> 

**1. Procedure Cost  VS  Payer Coverage** </br> 
<br>
We have patient records linked to **9 different insurance companies**. </br> 
Among them, I found that one or two companies stand out—not only because they cover the **highest number of procedures** performed at the hospital but also because they are the **preferred choice** for most patients. Interestingly, these insurers are primarily non-profit organizations operated by the government. </br> 
<br> 
![payer_01](https://github.com/arghanilhub/Hospital-patient-records/blob/main/payers.png) </br> 
<br> 
**a. Medicare vs Medicaid** </br> 
 
* **While both payers cover the highest number of procedures, there is a noticeable difference in the number of patients opting for them**. Medicaid is designed as an assistance program for individuals below the poverty level, whereas Medicare primarily serves those aged 65+ or individuals with certain disabilities. **In our hospital records, Medicare accounts for the highest number of patients, specifically 103 patients who are all above 80+, whereas Medicaid has significantly fewer. This suggests that we see more older patients covered by Medicare compared to those below the poverty line who are covered by Medicaid**. </br> 

* Both Medicare and Medicaid cover most critical issues, along with a few other payers. Based on coverage levels, I’d rate them:</br>
   <blockquote>Medicare > Medicaid > Dual Eligible > Blue Cross Blue Shield</blockquote> </br>
  
* Medicaid typically covers about **95% of costs**, with patients owing a small co-payment, while Medicare covers **around 80%**, requiring patients to pay a bit out-of-pocket. This is mainly due to billing differences—Medicaid bills tend to be lower, whereas Medicare bills are usually higher.</br> 
  These patterns are especially noticeable in the most **critical cases** the hospital frequently handles. </br>
  <br>
  ![payer_02](https://github.com/arghanilhub/Hospital-patient-records/blob/main/payers_02.png) </br>
  <br>
 Both **Humana** and **Aetna** provide no coverage for this issue, yet they are still widely preferred by patients. </br>
We see the same pattern for two types of **heart issues**—Cardiac Arrest and Myocardial Infarction (commonly known as a Heart Attack). Only Medicare and Medicaid provide coverage, while no for-profit insurers do. </br> 
* In fact, even for common medical occurrences like **normal pregnancy**, for-profit insurance companies like ```UnitedHeathCare```, do not cover procedures associated with it. This includes critical procedures such as vaginal birth or certain types of abortion, which can have significant physical and psychological impacts. </br>
<br>

![payer_03](https://github.com/arghanilhub/Hospital-patient-records/blob/main/payer_03.png) </br>
<br> 
Medicaid serves as a crucial safety net for BPL families, offering comprehensive coverage. Among private insurers, only ```Blue Cross Blue Shield``` offers coverage. And it’s no surprise that Medicare isn’t listed, as it’s exclusively for those aged 65+, which aligns with our data. </br> 
* Plus it’s not that they have only recently started providing full coverage—their **track record has been consistently strong over the years**. I verified their payout rates across multiple years, and the data confirms their steady commitment, which likely strengthens patient trust. </br>
<br>

![payer_04](https://github.com/arghanilhub/Hospital-patient-records/blob/main/payer_04_new.png) </br>
<br> 

**2. Revenue Trends & Operational Efficiency:** </br> 
<br> 
* Looking at the hospital's revenue trends, we've had **27,891 patient visits** from ```2011 to 2022```, with an average revenue of **$3664.76 per visit**. On a yearly basis, the hospital's total revenue averages around $84,595,31.29. Some years stand out - ```2014 saw the highest influx of patients```, while ```2012 was the year with the highest revenue```. </br>

* However, when analyzing the year-over-year cost differences, I noticed **significant fluctuations each year**. This suggests that patient volumes have also varied considerably over time, aligning with these cost shifts. </br>
<br>

&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; ![cost_01](https://github.com/arghanilhub/Hospital-patient-records/blob/main/cost_01.png) </br>
<br> 
