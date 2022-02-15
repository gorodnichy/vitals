<!-- Open Canada Vital Statistics Application Resources
Analysis of Official Data Related to COVID-19 Vaccine Efficacy and Safety
-->

Analysis of Official Data Related to COVID-19 Vaccine Efficacy and Safety
==================================================

Last updated: February 15, 2022

**Disclaimer**: The authoritative source for COVID-19 information is [Canada.ca/coronavirus](https://www.canada.ca/en/public-health/services/diseases/coronavirus-disease-covid-19.html). The results and views presented in this portal are those by the authors and are not to be misconstrued as representing  views of
any Canadian Agency, University, or Department. They were developed and gathered by the [R4GC Data Science community](https://open-canada.github.io/r4gc/index.html#r4gc-community) as part of the community training and socializing, mostly on authors' own time and using authors' own resources.
All codes behind the analysis and supporting documents are free, open and available in [GitHub](https://github.com/open-canada/vitals/).  

<!-- Comments and corrections are welcome and should be emailed to <opencanadadataanalysis @ ivim . ca -->





## Raison d'être

On March 31, 2021, just before COVID-19 vaccination of general public  commenced, the Chief Science Advisor of Canada in its ["*Scientific Considerations for Using COVID-19 Vaccination Certificates"*](https://science.gc.ca/eic/site/063.nsf/eng/h_98229.html) report has  expressed several concerns and recommendations related to the uncertanties associated with using new COVID-19 vaccines that were approved under Emergercy Act and did not go through all normally conducted testing stages, which include the following:

- Scientific uncertainties: *<u>Given the short time since the COVID-19 vaccines have become available, it is not surprising that many scientific uncertainties persist</u> and are the subject of intense ongoing studies*.
- Ethical and Social Considerations: *It should also be noted that while the anticipation of more freedom may be an incentive for some to get vaccinated, <u>vaccine acceptance could decrease in others if there was a sense of coercion tied to using vaccination certificates.</u>*
- Legal Considerations: *The processes by which vaccine certificates are issued and controlled <u>need to be fraud proof</u>*
- Conclusion: *\[All levels of government could work to develop a framework that\] Maximizes <u>consistent post-vaccine monitoring</u>*

Another report was issued by the Chief Science Advisor on July 16, 2021, just as the vaccination rates started to pick up (but still being low - less than 10%): ["*COVID-19 vaccine-associated myocarditis/pericarditis"*](https://science.gc.ca/eic/site/063.nsf/eng/h_98291.html), which -- in the light of the COVID-19 vaccine side effects that were just uncovered  half a year  after the vaccinae started to be used -- further emphasized the following:

- Priority actions moving forward: *<u>The emerging issue of vaccine associated heart disease requires attention</u> on two important levels:
    <u>addressing data and knowledge gaps</u> on the one hand, and <u>promoting awareness</u> and clinical care on the other.*

It could have been expected that there would  more reports produced from the Chief Science Advisor Office to follow up on their own recommendations of "addressing data and knowledge gaps" and "promoting awareness", as more and more data just stated to be avalailable after July (especially after October 2021, when vaccination rate reached 75% and vital statistics (deaths) data has finally become available),
<!-- , due to the several months delay in processing these data), -->
and yet there were none produced, as of Februarry 2020 -- more than half a year after the previous report was issued.
<!-- As of today  -- more than half a year later, with more than 80% Canadians now being vaccinated with  COVID-19 vaccines and with  numerous new Vital statistics and Vaccine Adverse Events data that hav been obtained since then (especially after October 2021, due to the average of three month delay in processing much of the data), -- this remains to be last report that the Chief Science Advisor of Canada has issued on the topic of COVID-19 vaccine safety and efficacy. -->
It is not clear why. Equally it is not clear, why there is still not a single other publication or COVID-19 vaccine training produced by the Goverment of Canada that would be based on  the data obtained *after* the commencement of general public vaccination (i.e., after May and which has become avialable in public domain after October 2021), not prior to it. Numerous requests for such information were made.

In the absense to the official published analysis of the latest data, a group of data scientists from across several Goverment of Canada departments decided to conduct such analysis themselves, as part of their weekly data science training  and driven by  the desire to apply their new skills for public good, while also helping each other, as some members of the group experienced long-lasting (albeit called "non-serious") vaccine side effects that, they found, very difficult to report.
This portal started as a result of these efforts.
<!-- This portal is designed to address this gap. -->
It provides links to  related  [Open Canada sources and datasets](), [Guidelines for reporting vaccine side-effects](https://ivi-m.github.io/vv/report-side-effect), an interactive [Open Canada Vital Statistics (Death) Tracking application](https://open-canada.github.io/Apps/vitals) built by the community, and the [Observations]() made from the analysis  --- for sharing with the general public and policy-makers for greater awareness and further validation, in line with the recommendations of the  Office of the Chief Science Advisor 
and the [Scientific Integrity Policy](https://science.gc.ca/eic/site/063.nsf/eng/h_98027.html)  they  developed.

<!-- 
Because of the [Code of Conduct](https://github.com/IVI-M/vv/raw/main/docs/legal/CBSA_conduct_code.pdf), which instructs Government of Canada employees to refrain from making  criticisms of  the Government of Canada, it has become very difficult to discuss anything in relationship to COVID-19 vaccine efficiency/safety.  Employees who experienced vaccine side effects or had  questions related to the above, would be afraid to express their concerns and seek for help, many wanted to remain anonymous. 

-->

<!-- ### Observations -->

## Summary of key observations


<!-- (as being over 90% efficient) and safety (as being "very safe"). -->

- Open Canada data that has become available *after* the start of general public vaccination <u>do not</u> support the COVID-19  vaccine manufacturers\' claims about  vaccine efficacy and safety. 

- Firstly, the number of serious COVID-19 adverse events already reported, including deaths and key organs failures,   appears to be much higher than what should be expected from a "safe" vaccine, being comparable to (and for certain populations higher than)  the number of COVID-19 deaths alone.

- Secondly, it is observed that certain reports produced by the Government of Canada (PHAC 'Cases following vaccination' reports) contain algorithmic bias that skews the results considerably in the favour of vaccine manufacturers' claims. When recomputed without the embedded bias,  the reported data  <u>do not support</u> the claims made in those reports that *“Fully vaccinated individuals diagnosed with COVID-19 were significantly protected from severe outcomes.”*. In fact, they show the opposite -- that *Fully vaccinated individuals diagnosed with COVID-19 (shown in violet colour in slide below) are <u>now twice less</u> protected from severe outcomes (deaaths and hospitlizationss), compared to unvaccinated individuals (shown in red colour in slide below)*

  - All codes, spreadsheets, and  archived PHAC reports (since July 2021, which is when PHAC they started  reporting 'Cases by vaccination status' statistics), from which the raw data were extracted, are available [here](https://github.com/IVI-M/vv/tree/main/docs/COVID-19%20epidemiology%20updates). 
  - Below is a one-slide summary of the result. A PDF version of it with clickable links is available  [here](One-Slide-update.pdf).



<a href="https://ivi-m.github.io/vv/One-Slide-update.png">
<img src="https://ivi-m.github.io/vv/One-Slide-update.png" width="100%">
</a>

 

<!-- , and for certain populations (children, people under thirty with no other health problems) even higher than, -->

The following tools and white papers have been prepared to facilitate the discussion.


### Interactive Apps:

- Interactive *Open Canada Vitals Statitistcs (Deaths) Tracker* App: <https://open-canada.github.io/Apps/vitals> (mirror: <https://o-canada.shinyapps.io/vitals>).
<!-- - ["One Year since Vaccination. What we have learnt - using Open Canada Data and Data Science"](https://github.com/open-canada/vitals/blob/main/docs/r4gc-meetu[ivi-m.github.io/vv](https://ivi-m.github.io/vv) p-2022-02-04-SpecialEdition(OneYearOfVaccineInCanada).pdf), 
Special Edition presentation for the R4GC Community 'Lunch and Learn' Meetup --> 
<!-- by the community lead, Senior Data Scientist, Dr. Dmitry Gorodnichy (4 February 2022) -->


<a href="https://ivi-m.github.io/vv/app.png" >
<img src="https://ivi-m.github.io/vv/app.png" width="100%"></a>



### Self-help tools:

- [Guide on how to report COVID-19 vaccine side-effects in Canada as a consumer](https://ivi-m.github.io/vv/report-side-effect)

- [Early COVID-19 Treatment Guidelines](https://worldcouncilforhealth.org/resources/early-covid-19-treatment-guidelines-a-practical-approach-to-home-based-care-for-healthy-families/)


### White Papers:

-  ["Additional  observations related to the 'Elephant in the Room' –  from the Government of Canada COVID-19 daily epidemiology updates.  Time to act!"](https://ivi-m.github.io/vv/comment2.pdf), White paper (10 February 2022) 

-  ["Some observations from Canadian Vital Statistics Death (CVSD) Database related to
    the 'Elephant in the Room'"](https://ivi-m.github.io/vv/comment.pdf), Comment submission to The Lancet Journal (6 January 2022)
   
-  ["Statistical analysis of the official data sources related to vaccine efficacy and  safety (NEW EVIDENCE SINCE OCTOBER     2021)"](https://ivi-m.github.io/vv/analysis), Additional details (14 January 2022)
  
- ["One Year since Vaccination. What we have learnt - using Open Canada Data and Data Science"](https://ivi-m.github.io/vv/OneYearOfVaccineInCanada-deck-meetup-2022-02-04.pdf), 
Special Edition presentation for the R4GC Community 'Lunch and Learn' Meetup  by the [R4GC Data Science community](https://open-canada.github.io/r4gc/index.html#r4gc-community)  lead, Senior Data Scientist, [Dr. Dmitry Gorodnichy](http://gorodnichy.ca) (4 February 2022).

<!--
- Shorter version of the above deck, modified for larger audience is [here]()

-->

<a href="https://ivi-m.github.io/vv/OneYearOfVaccineInCanada-deck-meetup-2022-02-04.pdf" style="text-align: center">
<img src="https://ivi-m.github.io/vv/OneYearOfVaccineInCanada-s1.png" width="500" align="center"></a>


 

## Sources:

<!-- Last Updated: 2022-02-11 -->



[gc1] **Cases following vaccination, COVID-19 Daily Epidemiology Update, Public Health Agency of Canada**,  <https://health-infobase.canada.ca/covid-19/epidemiological-summary-covid-19-cases.html#a9> ([archived reports](https://github.com/open-canada/vitals/tree/main/docs/COVID-19%20epidemiology%20updates))


 
<!-- 

- *Data extracted on January 28, 2022 for cases <u>from December 14, 2020</u>* <br>
  Unvaccinated 70.3%% vs. fully vaccinated **16.8%** (+3% increase since last week, +7.3% increase since last month) <p>
    

Fully vaccinated among COVID-19 deaths

Report Date (total cases)| Period reported for     | Reported deaths (with bias*)| Actual deaths (bias removed)   per week 
2022-02-10 (n=1,670,682) | 2020.12.14 - 2022.01.22 | 2,490 (19.5%) |  458  (80%)
2022-02-04 (n=1,458,433)| 2020.12.14 - 2022.01.15 | 2,032 (16.8%) |  


Unvaccinated among COVID-19 deaths

Report Date (total cases)| Period reported for     | Reported deaths (with bias*)| Actual deaths (bias removed)   per week 
2022-02-10 (n=1,670,682)| 2020.12.14 - 2022.01.22 | 2,490 (19.5%) |  458  (80%)
2022-02-04 (n=1,458,433)| 2020.12.14 - 2022.01.15 | 2,032 (16.8%) |  


* Significant bias is introduced in the reporting of Fully-vaccinated deaths by counting  Deaths since December 14, 2020 when there were very few fully-vaccinated  people back between than May.

-->

 
<a href="https://ivi-m.github.io/vv/OneYearOfVaccineInCanada-s19.png">
<img src="https://ivi-m.github.io/vv/OneYearOfVaccineInCanada-s19.png" width="500">
</a>



##### Death cases by vaccination status, biased reporting (from December 14, 2020 to present)
 
- *on February 10, 2022 for cases from December 14, 2020 up until January 22, 2022 (n=1,670,682)* <br> 
unvaccinated 68.1%% vs. fully vaccinated **19.5%** (+2.7% increase since last week)
- *on February 04,  2022 for cases from December 14, 2020 up until January 15, 2022 (n=1,458,433)* <br> 
unvaccinated 70.3% vs. fully vaccinated **16.8%** (+3% increase since last week)
- *on January 21, 2022 for cases from December 14, 2020 up until January 08, 2022 (n=1,341,192)*: <br> 
unvaccinated 72.8% vs. fully vaccinated **13.8%** (+4.3% increase since December 14)
- *on December 15, 2021 for cases from December 14, 2020 up until November 27, 2021 (n=882,988)*: <br> 
unvaccinated 76.1% vs. fully vaccinated **9.5%**



NB: The statistics above is quoted directly from the source, where it was computed using  death data *since December 2020*, when there were no fully vaccinated Canadians yet (more exactly: there were 0 fully-vaccinated in December, < 1% for most of January,  <3%  until May). This is known as *algorithmic bias*, which skews results favourably towards fully-vaccinated cases. This bias can be removed using the technique described in [this paper](https://ivi-m.github.io/vv/comment2.pdf). 
The unbiased statistics are shown below.
  
##### Infected cases by vaccination status, unbiased reporting (from December 04, 2021 to January 15, 2022) 
  

  
- The number of COVID-19 cases fully-vaccinated      vs.    unvaccinated and partially-vaccinated <br> 
87% 		vs.		 	11%     and   2%
- For comparison, the vaccination rates in the same period: 
fully vaccinated     vs.    unvaccinated and partially-vaccinated: <br> 
77%		vs.		 	18%    and   5%
  
  

<a href="https://ivi-m.github.io/vv/One-Slide-update-2022-02-11.png">
<img src="https://ivi-m.github.io/vv/One-Slide-update-2022-02-11.png" width="100%">
</a>

 
<a href="https://ivi-m.github.io/vv/One-Slide-update.png">
<img src="https://ivi-m.github.io/vv/One-Slide-update.png" width="100%">
</a>

 

<hr>






[ gc2 ]
**Reported side effects following COVID-19 vaccination in Canada, Canadian COVID-19 vaccination safety report, Public Health Agency of Canada**, <https://health-infobase.canada.ca/covid-19/vaccine-safety> (Figure 1, Table 1)

**Adverse reactions from COVID-19 vaccines**

Total (since Jan 2021):
- All reported adverse reactions: 36,164
- Serious adverse reactions: 	7,678.  (118 / week)

Between May 2021 and October 2021 (for benchnarking against  COVID-19 deaths in the same period - see below)
- Serious adverse reactions:  **5200** (NB: increased from 5038 posted in last month report)
-  Of these: 1,111 heart diseases (including 64 Cardiac arrests, 77 Heart Attacks, 970
    Myocarditis1/Pericarditis), 947 thrombosis, 781 central nervous system failures
    (including 594 Bell's Palsy), 487 Anaphylaxis, 166 Auto-immune diseases, 37 Acute
    kidney injury, 25 Liver injury, and 208 deaths (some under investigation). 
- Many are not reported or published yet. According to Health Canada , filing of a report takes three months (in practice, longer than that).


<!--
<a href="https://ivi-m.github.io/vv/gc2-reactions.png">
<img src="https://ivi-m.github.io/vv/gc2-reactions.png" width="500">
</a>
-->

<hr>


[ gc3 ] 
**Statistics Canada, Canadian Vital Statistics - Death database. Provisional weekly death counts, by selected grouped causes of death**,  <https://www150.statcan.gc.ca/t1/tbl1/en/tv.action?pid=1310081001>  ([App Calculator ](https://o-canada.shinyapps.io/vitals/#section-statistics), Last record: November 6, 2021):

<!-- 
[gc4]: **Deaths of COVID-19** (Source: GC
    [statcan.gc.ca](https://www150.statcan.gc.ca/t1/tbl1/en/tv.action?pid=1310081001), [App
    Calculator](https://o-canada.shinyapps.io/vitals/#section-statistics)) - (Last record: 6 NOV 2021):
-->

**Deaths of COVID-19**

Between December 2020 to  April 2021 (from the day first vaccination started to when vaccination rate reached 3%)
- COVID-19 deaths: : 13075 

Between May  2021 and October 2021 (for benchmarking against  health damages  caused by COVID-19 vaccine - see above) 
- COVID-19 deaths: **2975** 
- COVID-19 deaths without comorbidities: **404** (recomputed using [ukg1])
- COVID-19 deaths without comorbidities for \<65 : **89** (recomputed  using [ukg1])


- For comparison --- Cancer: 27805, Heart: 16605, Accidents: 3380, Suisides: 555	

<!-- 
- All COVID-19 since the start of pandemic: with comorbidities --, without comorbidities -- , without for \<65 years old -- 
- For comparison, since the start of pandemic other caueses of death: Cancer -- , ...
- For comparison, Deaths from Flu without comorbidities (10-year historical average): 
-->

<!-- 
<a href="https://ivi-m.github.io/vv/gc3-deaths.png">
<img src="https://ivi-m.github.io/vv/gc2-deaths.png" width="500">
</a>

-->

**Additional observations  of the anomalies (possibly, “new normals”)**:

- The total number of deaths in last two years is comparable to (and in some provinces lower  than) their five-year average
- At the start of pandemic, when policies among the provinces varies, there was practically no “first wave” observed in Western provinces
- Since the start of pandemic, the number of all non-COVID deaths started to decline
- Sharp increase in the number of unexplained deaths  since May 2021,  and finally
- Increased delay in reporting deaths: from 2 months to 3 (and in some provinces to 6) months

<!-- 
Multiple insights and anomalies (possibly, “new normals”) are observed:
- the total number of deaths over the entire period is comparable to (and in some provinces lower  than) five-year average;
- rather small number of COVID deaths – compared to the very large (x1000) number of COVID cases that have been reported,
- there was practically no “first wave” in Alberta and British Columbia at the start of pandemic);
- decrease in all non-covid causes, since the start of the pandemic (even those that have a trend to increase over time)
- sharp increase in the number of unexplained deaths, since April (which is when the vaccination was extended to general public), and finally,
- increased delay in reporting deaths: from 2 months to 3 and in some provinces to 6 months

-->
<hr>


[ gc4 ] 
**Recalls and safety alerts, Government of Canada**, <https://recalls-rappels.canada.ca/>: 
(for 
[[Moderna](https://recalls-rappels.canada.ca/en/search/site?search_api_fulltext=moderna)], 
[[Pfizer](https://recalls-rappels.canada.ca/en/search/site?search_api_fulltext=pfizer)], 
[[Astrazeneca](https://recalls-rappels.canada.ca/en/search/site?search_api_fulltext=astrazeneca)]
)

- Risk of Facial paralysis/Bell’s Palsy. Posted: 2021-08-06 
- Risk of Myocarditis and pericarditis. Posted: 2021-06-30 ([by over x 1000 for young men](https://www.youtube.com/watch?v=Hb1Xm1uaedU))
- Risk of Capillary Leak Syndrome. Posted: 2021-06-29
- Risk of Thrombosis with Thrombocytopenia. Posted: 2021-03-24


<!-- 
Another example of algorithmic bias:
Myocarditis after vaccination, firm data: https://www.youtube.com/watch?v=Hb1Xm1uaedU
After mRNA-based COVID-19 vaccine administration
Between December 2020 and August 2021 in 
n = 192,405,448 older than 12 years of age in the US
-->



### Other statistics

[gcA]  **Fully-Vaccinated rates** (Source:
    [canada.ca](https://health-infobase.canada.ca/covid-19/vaccination-coverage/)):
    
- Dec 2020 - Apr 2021 (High-risk population): 0 -- 2%
- May 2021 - Oct 2021 (General public vaccination): **2% -- 75%**

- Dec 2020 - present (Total): 80%
    - Of these, following employers' enforcement of vaccination mandates: 10% - 20%  

<!-- "coerced" (Estimated using the difference in rates between before and after mandatory vaccination job requirements) -->

[gcB] **COVID-19 cases vs. COVID-19 deaths** (source: [google1](https://www.google.com/search?q=canada+covid+cases&oq=canada+covid+cases)):

- Canada population: 38.246.108
- Total COVID Cases (since March 2020): 3.150.000
- Total COVID Deaths (since March 2020): 35.00 or 1.1% Cases
- Of these, Most are comorbidities (>90% based on UKG and USG data)
- Of these, Most are in people 65+ (>90% based on GC, UKG, USG data)
- COVID Deaths for people younger than 65 with no health problems: < 0.01% Cases

<!-- 
- About 0.0xxx% of COVID-19 cases result in hospitalizations, 0.00yy% result in ICU, and 0.000z% in deaths, about 10% of which  COVID-deaths only - TBC
-->




### Data from other governments:
 
 
[ukg1] **COVID deaths vs. COVID alone deaths** (Source: [gov.uk](https://www.ons.gov.uk/aboutus/transparencyandgovernance/freedomofinformationfoi/deathsfromcovid19withnootherunderlyingcauses) - [Explanation](https://www.youtube.com/watch?v=9UHvwWWcjYw)):

- Of all reported in UK COVID deaths, only 13.6%  are due to COVID alone. 
- 78% of all COVID alone deaths occurred in people with 65+ of age.
- Average age of death from COVID is 82.5 years, which is statistically equal to the average life expectancy in UK.

 
[usg1] **Natural immunity vs. vaccine-induced immunity** (Source: [cdc.gov](https://www.cdc.gov/mmwr/volumes/71/wr/mm7104e1.htm) - [Explanation](https://www.youtube.com/watch?v=eK83QqbNOmU)):


- COVID vaccine reduces the risk of hospitalization considerably (by x10-x20)
- However, natural immunity  reduces the risk of hospitalization even more (by x20-x50),  while the chance of having severe complication from COVID infection for people younger than 65 and in good health is very low (<0.01% Cases based on [ukg1])  and for  children under 12 even lower (<0.0001% Cases based on [ukg2]).


<a href="https://ivi-m.github.io/vv/OneYearOfVaccineInCanada-s13.png" >
<img src="https://ivi-m.github.io/vv/OneYearOfVaccineInCanada-s13.png" width="500" >
</a>


 

<!-- 
#### Additional  references:  
- [Justice Centre for Constitutional Freedoms](https://www.jccf.ca)
-->




<hr>

 
[www.IVIM.ca](http://www.IVIM.ca) (forked from [open-canada.github.io/vitals](https://open-canada.github.io/vitals))
 <!-- br>
 Corrections/Comments: [ dg @ ivim . ca ]     -->
 
 If you want to help with further development of this Portal and Open Canada Vaccine /  Vitals Statistics Tracking App development, 
 please send eTransfer to dg @ ivim . ca.  Comments and corrections should be sent to the same address.
 
 
 
<!-- https://covid-19.ontario.ca/data 


ONTARIO
Last updated: February 3, 2022 at 10:31 a.m. (EST): Hosp. 536 vs 1383,  ICU 179 vs 211
Last updated: February 6, 2022 at 10:31 a.m. (EST): Hosp. 484 + 100, vs. 1264, ICU: 158 +10 vs. 174



###### COVID-19 cases by Vaccination Status (December 4, 2021)


[ gc2a ] Hospitalizations by vaccination status, COVID-19 (coronavirus) in Ontario, <https://covid-19.ontario.ca/data/hospitalizations#hospitalizationsByVaccinationStatus>


[ gc2b ] Weekly epidemiology report (PDF) available on the [Government of Canada’s COVID-19 data trends](https://www.canada.ca/en/public-health/services/diseases/coronavirus-disease-covid-19/epidemiological-economic-research-data.html) page (Figure 6).


-  *“Incidence [of COVID-19 cases] among fully vaccinated cases has surpassed those among unvaccinated since mid-December 2021”*. 
-  In January 2022, close to 3/4 of hospitalized COVID patients in Ontario were fully vaccinated

page 12:
Incidence rates among fully vaccinated individualswere higher thanthose amongunvaccinated individuals betweenmid-December 2021and the beginning of January 2022. However as of early-January 2022, the incidence rate among fully vaccinated individuals has decreased to a lower rate than that of unvaccinated individuals, while the incidence rate among unvaccinated individuals declined since peaking in early-January 2022.
Hospitalization rates among unvaccinatedindividuals continue to be higher than those fully vaccinated.The hospitalization ratesamong both unvaccinated and fully vaccinated cases increased betweenmid-December 2021and early-January 2022, and have declined since mid-January 2020



<hr>

-->

