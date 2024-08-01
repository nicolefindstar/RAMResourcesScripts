********************************************************************************
*                         WFP Standardized Scripts                             *
*                   Perceived Needs Indicators Calculation                     *
********************************************************************************

* NOTE: this syntax file assumes the use of all the questions included in the standard module.
* If any question is dropped, the corresponding variable names should be deleted from the syntax file.
* The sample data on which this syntax file is based can be found here:
* https://github.com/WFP-VAM/RAMResourcesScripts/tree/main/Static
* For more information on the Perceived Needs Indicators (including module), see the VAM Resource Center:
* https://resources.vam.wfp.org/data-analysis/quantitative/essential-needs/perceived-needs-indicators

*-------------------------------------------------------------------------------*
* Open dataset
*-------------------------------------------------------------------------------*

import delimited ".../Perceived_Needs.csv", bindquote(strict) case(preserve) ///
       numericcols(22 23 24) 
       
// change path to reflect where you save the sample dataset

*-------------------------------------------------------------------------------*
* Labels
*-------------------------------------------------------------------------------*

* Variable labels for all indicators
label var HHPercNeedWater      "Not enough water that is safe for drinking or cooking" 
label var HHPercNeedFood       "Not enough food, or good enough food, or not able to cook food" 
label var HHPercNeedHousing    "No suitable place to live in"
label var HHPercNeedToilet     "No easy and safe access to a clean toilet" 
label var HHPercNeedHygiene    "Not enough soap, sanitary materials, water or a suitable place to wash"
label var HHPercNeedClothTex   "Not enough or good enough, clothes, shoes, bedding or blankets"
label var HHPercNeedLivelihood "Not enough income, money or resources to live" 
label var HHPercNeedDisabIll   "Serious problem with physical health"
label var HHPercNeedHealth     "Not able to get adequate health care (including during pregnancy or childbirth - for women)"
label var HHPercNeedSafety     "Not safe or protected where you live now"
label var HHPercNeedEducation  "Children not in school, or not getting a good enough education"
label var HHPercNeedCaregive   "Difficult to care for family members who live with you"
label var HHPercNeedInfo       "Not have enough information (including on situation at home - for displaced)" 
label var HHPercNeedAsstInfo   "Inadequate aid"
label var CMPercNeedJustice    "Inadequate system for law and justice in community"
label var CMPercNeedGBViolence "Physical or sexual violence towards women in community" 
label var CMPercNeedSubstAbuse "People drink a lot of alcohol or use harmful drugs in community" 
label var CMPercNeedMentalCare "Mental illness in community"
label var CMPercNeedCaregiving "Not enough care for people who are on their own in community" 

* Value labels for indicators  
label def HHPercNeed_label 0    "No serious problem"    1 "Serious problem" ///
                           8888 "Don't know, not applicable, declines to answer"

foreach var of varlist HHPercNeedWater HHPercNeedFood HHPercNeedHousing         ///
                       HHPercNeedToilet HHPercNeedHygiene HHPercNeedClothTex    ///
                       HHPercNeedLivelihood HHPercNeedDisabIll HHPercNeedHealth ///
                       HHPercNeedSafety HHPercNeedEducation HHPercNeedCaregive  ///
                       HHPercNeedInfo HHPercNeedAsstInfo CMPercNeedJustice      ///
                       CMPercNeedGBViolence CMPercNeedSubstAbuse                ///
                       CMPercNeedMentalCare CMPercNeedCaregiving {
    label val `var' HHPercNeed_label
}

* Add value labels for the problems - make sure that all variables are nominal 
label def CMPercNeedR_label 1 "Drinking water" 2 "Food" 3 "Place to live in" ///
                            4 "Toilets" 5 "Keeping clean"                    ///
                            6 "Clothes, shoes, bedding or blankets"          ///
                            7 "Income or livelihood" 8 "Physical health"     ///
                            9 "Health care" 10 "Safety"                      ///
                            11 "Education for your children"                 ///
                            12 "Care for family members" 13 "Information"    ///
                            14 "The way aid is provided"                     ///
                            15 "Law and injustice in your community"         ///
                            16 "Safety or protection from violence for women in your community" ///
                            17 "Alcohol or drug use in your community"       ///
                            18 "Mental illness in your community"            ///
                            19 "Care for people in your community who are on their own" ///
                            20 "Other problem"

foreach var of varlist CMPercNeedRFirst CMPercNeedRSec CMPercNeedRThird {
    label val `var' CMPercNeedR_label
}

*------------------------------------------------------------------------------*
* For each aspect/question, report the share of households who indicated it as a "serious problem"
*------------------------------------------------------------------------------*

* Frequencies
table (var) (result), ///
    statistic(fvpercent HHPercNeedWater HHPercNeedFood HHPercNeedHousing ///
                      HHPercNeedToilet HHPercNeedHygiene HHPercNeedClothTex ///
                      HHPercNeedLivelihood HHPercNeedDisabIll HHPercNeedHealth ///
                      HHPercNeedSafety HHPercNeedEducation HHPercNeedCaregive ///
                      HHPercNeedInfo HHPercNeedAsstInfo CMPercNeedJustice ///
                      CMPercNeedGBViolence CMPercNeedSubstAbuse CMPercNeedMentalCare ///
                      CMPercNeedCaregiving) ///
    statistic(fvfrequency HHPercNeedWater HHPercNeedFood HHPercNeedHousing ///
                         HHPercNeedToilet HHPercNeedHygiene HHPercNeedClothTex ///
                         HHPercNeedLivelihood HHPercNeedDisabIll HHPercNeedHealth ///
                         HHPercNeedSafety HHPercNeedEducation HHPercNeedCaregive ///
                         HHPercNeedInfo HHPercNeedAsstInfo CMPercNeedJustice ///
                         CMPercNeedGBViolence CMPercNeedSubstAbuse CMPercNeedMentalCare ///
                         CMPercNeedCaregiving)

* Show only the share of households that reported an aspect as serious problem out of the total populations (including those that did not answer)
preserve
recode HHPercNeedWater HHPercNeedFood HHPercNeedHousing HHPercNeedToilet ///
       HHPercNeedHygiene HHPercNeedClothTex HHPercNeedLivelihood HHPercNeedDisabIll ///
       HHPercNeedHealth HHPercNeedSafety HHPercNeedEducation HHPercNeedCaregive ///
       HHPercNeedInfo HHPercNeedAsstInfo CMPercNeedJustice CMPercNeedGBViolence ///
       CMPercNeedSubstAbuse CMPercNeedMentalCare CMPercNeedCaregiving (8888=0)

tabstat HHPercNeedWater HHPercNeedFood HHPercNeedHousing HHPercNeedToilet ///
        HHPercNeedHygiene HHPercNeedClothTex HHPercNeedLivelihood HHPercNeedDisabIll ///
        HHPercNeedHealth HHPercNeedSafety HHPercNeedEducation HHPercNeedCaregive ///
        HHPercNeedInfo HHPercNeedAsstInfo CMPercNeedJustice CMPercNeedGBViolence ///
        CMPercNeedSubstAbuse CMPercNeedMentalCare CMPercNeedCaregiving, ///
        stats(mean) columns(statistics) varwidth(30)
restore

*-------------------------------------------------------------------------------------------------*
* For each aspect/question, report the share of households who indicated it among their top three problems
*-------------------------------------------------------------------------------------------------*

/* Tokenize and loop potential variables - Feel free to explore

	tokenize `""Water" "Food" "Housing" "Toilet" "Hygiene" "ClothTex" "Livelihood" "Disabil" "Health" "Safety" "Education" "Caregive" "Info" "AsstInfo" "Justice" "GBViolence" "SubstAbuse" "MentalCare" "Caregiving" "Other""'
	
	local i = 0
	while `"`*'"' ~= `""' {	
		egen Top3_`1' = anymatch(CMPercNeedRFirst CMPercNeedRSec CMPercNeedRThird), v(`++i') 
		macro shift
	}	
*/	

* For each problem generate a variable indicating if the respondent mentioned it among their top three problems
egen Top3_Water      = anymatch(CMPercNeedRFirst CMPercNeedRSec CMPercNeedRThird), v(1)
egen Top3_Food       = anymatch(CMPercNeedRFirst CMPercNeedRSec CMPercNeedRThird), v(2)
egen Top3_Housing    = anymatch(CMPercNeedRFirst CMPercNeedRSec CMPercNeedRThird), v(3)
egen Top3_Toilet     = anymatch(CMPercNeedRFirst CMPercNeedRSec CMPercNeedRThird), v(4)
egen Top3_Hygiene    = anymatch(CMPercNeedRFirst CMPercNeedRSec CMPercNeedRThird), v(5)
egen Top3_ClothTex   = anymatch(CMPercNeedRFirst CMPercNeedRSec CMPercNeedRThird), v(6)
egen Top3_Livelihood = anymatch(CMPercNeedRFirst CMPercNeedRSec CMPercNeedRThird), v(7)
egen Top3_Disabil    = anymatch(CMPercNeedRFirst CMPercNeedRSec CMPercNeedRThird), v(8)
egen Top3_Health     = anymatch(CMPercNeedRFirst CMPercNeedRSec CMPercNeedRThird), v(9)
egen Top3_Safety     = anymatch(CMPercNeedRFirst CMPercNeedRSec CMPercNeedRThird), v(10)
egen Top3_Education  = anymatch(CMPercNeedRFirst CMPercNeedRSec CMPercNeedRThird), v(11)
egen Top3_Caregive   = anymatch(CMPercNeedRFirst CMPercNeedRSec CMPercNeedRThird), v(12)
egen Top3_Info       = anymatch(CMPercNeedRFirst CMPercNeedRSec CMPercNeedRThird), v(13)
egen Top3_AsstInfo   = anymatch(CMPercNeedRFirst CMPercNeedRSec CMPercNeedRThird), v(14)
egen Top3_Justice    = anymatch(CMPercNeedRFirst CMPercNeedRSec CMPercNeedRThird), v(15)
egen Top3_GBViolence = anymatch(CMPercNeedRFirst CMPercNeedRSec CMPercNeedRThird), v(16)
egen Top3_SubstAbuse = anymatch(CMPercNeedRFirst CMPercNeedRSec CMPercNeedRThird), v(17)
egen Top3_MentalCare = anymatch(CMPercNeedRFirst CMPercNeedRSec CMPercNeedRThird), v(18)
egen Top3_Caregiving = anymatch(CMPercNeedRFirst CMPercNeedRSec CMPercNeedRThird), v(19)
egen Top3_Other      = anymatch(CMPercNeedRFirst CMPercNeedRSec CMPercNeedRThird), v(20)

* Report share of households who indicated an area among their top three problems
tabstat Top3_*, stats(mean) columns(statistics) varwidth(30)
 
*------------------------------------------------------------------------------*
* Mean/median number of aspects indicated as "serious problems"
*------------------------------------------------------------------------------*

egen Perceived_total = anycount(HHPercNeedWater HHPercNeedFood HHPercNeedHousing 	  	 ///
                                HHPercNeedToilet HHPercNeedHygiene HHPercNeedClothTex 	 ///
                                HHPercNeedLivelihood HHPercNeedDisabIll HHPercNeedHealth ///
                                HHPercNeedSafety HHPercNeedEducation HHPercNeedCaregive  ///
                                HHPercNeedInfo HHPercNeedAsstInfo CMPercNeedJustice 	 ///
                                CMPercNeedGBViolence CMPercNeedSubstAbuse 				 ///
                                CMPercNeedMentalCare CMPercNeedCaregiving), v(1) 
* The variable counts the number of aspects perceived as serious problems    
label var Perceived_total "Total number of problems identified"

tabstat Perceived_total, stats(mean median) columns(statistics)

* End of Scripts