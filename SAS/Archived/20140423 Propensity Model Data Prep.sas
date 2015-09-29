/****************************************************************************************************/
/* SAS Program Name    : 20140423 Propensity Model Medibank 001 Data Prep						    */
/* Program Description : Prepare the data for the propensity model								    */
/* Author              : Peter Meredith																*/
/* Date                : 23/04/2014																	*/
/****************************************************************************************************/

%include "\\swag\grpdata\flybuys Offers\03. Analytics\09. Partner Analytics\OTHERS\Points Allocation Automation\SAS Programs\Automatic Sequence Number\20140408 Assign Libraries.sas";


data medibank_prp;
	set dmteam.medibank_prp;
run;

/*Keep the members we're interested in matching to*/

data target_intdata;
	set medibank_prp;
	if match_segment='Linked - new to MB';
run;

proc freq data=medibank_prp noprint;
	tables match_segment / missing list out=test;
run;

libname ib771 '//Swag/Grpdata/FlyBuys Offers/03. Analytics/07. Insights Briefs/IB700-800/Insights Brief 771 - CS TR AGL linkage';

proc contents data=ib771.std_model_set out=contents;
run;



data model_set_restrict_sample (drop=group_loyalty_member_number);
	retain group_loyalty_member_no;
	set ib771.std_model_set
	(keep=ACTIVE_MEMBER_12W_FLAG
ACTIVE_MEMBER_1Y_FLAG
ACTIVE_MEMBER_2Y_FLAG
ACTIVE_MEMBER_4W_FLAG
ACTIVE_MEMBER_6M_FLAG
ACTIVE_MEMBER_6W_FLAG
ACTIVITY_SEGMENT
AFF_RANK
AGE_NUMBER
AGL_LINKED
AVERAGE_HOUSEHOLD_SIZE
AVERAGE_NUM_PSNS_PER_BEDROOM
BABY_CLUB_INDICATOR
CMCARD_PTS
COLESGEOG_CLASS
COLES_BNS_PTS
COLES_LTF_FLAG
COLES_ONLINE_SHOPPER_FLAG
COLES_PTS
CS_NUM_TXNS_12W_EX_DEC
CS_NUM_TXNS_6W_EX_DEC
CS_TOTAL_SALES_AMT_12W_EX_DEC
CS_TOTAL_SALES_AMT_6W_EX_DEC
CUSTOMER_AFFLUENCE
CUSTOMER_AFFLUENCE_RATING_NAME
CUSTOMER_KEY
DISTANCE_1
DISTANCE_2
FES_SCORE
GM_AREA_TYPE
GROUP_LOYALTY_CARD_NUMBER
GROUP_LOYALTY_MEMBER_NUMBER
GROUP_LOYALTY_PRIMARY_CARD_IND
GRP_LYLTY_PRMRY_CARD_GENDER_CD
LOYALTY_RANK_NUMBER
LOYALTY_SEGMENT
LOYALTY_SEGMENT_NAME
LOYALTY_SHARE_OF_WALLET_NUMBER
LPPL_EMAIL_FLAG
MAILABLE_FLAG
MEDIAN_AGE_PERSONS
MEDIAN_MORTGAGE_REPAY_MONTHLY
MEDIAN_RENT_WEEKLY
MEDIAN_TOT_FAM_INC_WEEKLY
MEDIAN_TOT_HHD_INC_WEEKLY
MEDIAN_TOT_PRSNL_INC_WEEKLY
MEDIBANK_LINKED
MEDIBANK_NOT_LINKED_FLG
MOSAIC_GROUP_NEW
NEW_ACTIVE_MEMBER_6W_FLAG
NEW_MEMBER_POST_RELAUNCH_FLAG
NON_OPENER_6M_FLAG
NO_VISITS_12MTHS
NO_VISITS_3MTHS
NO_VISITS_4WKS
NUMBER_OF_CARS_QUANTITY
NUMBER_OF_HOUSEHOLD_MBRS_QTY
NUMBER_OF_KIDS_0_TO_3_YR_QTY
NUMBER_OF_KIDS_13_TO_18_YR_QTY
NUMBER_OF_KIDS_4_TO_12_YR_QTY
NUM_ALL_FUEL_RDMPTN_LAST_6_CTM
PET_CAT_AND_DOG_INDICATOR
POINTS_SEGMENT
REGISTRATION_DATE
RFM_SEGMENT
SHARE_OF_WALLET
SHOPPINGCENTRETYPE
STATE_CODE
SURVEY_EVERYDAY_REWARDS_FLAG
SURVEY_LIQ_RESP_FLAG
TOTAL_POINTS
TOTAL_SALES_12MTHS
TOTAL_SALES_3MTHS
TOTAL_SALES_4WKS
WW_LOYALTY_PROGRAM_INDICATOR
ave_basket_size_12mths
ave_basket_size_3mths
ave_basket_size_4wks
coles_tenure_days
days_since_at_coles
last_3mths_sales_1C
last_3mths_sales_BL
last_3mths_sales_CE
last_3mths_sales_CS
last_3mths_sales_KM
last_3mths_sales_LL
last_3mths_sales_TG
last_3mths_sales_VC
ratio_bonus_std_pts
ratio_coles_partner_pts
total_bonus_pts
total_coles_pts
total_partner_pts
total_std_pts
);
group_loyalty_member_no=group_loyalty_member_number*1;
run;



/*Now flag up my medibank customers in here*/

data medibank_flag;
	set target_intdata (keep=group_loyalty_member_number);
	medibank_target=1;
run;


proc sql;
	create table mediflag_datalink as
	select * from
	model_set_restrict_sample a left join medibank_flag b
	on a.GROUP_LOYALTY_MEMBER_No=b.GROUP_LOYALTY_MEMBER_NUMBER;
quit;

proc freq data=mediflag_datalink noprint;
	tables medibank_target / missing list out=testfreq;
run;


/*Now put emailable and mailable flags onto this*/
proc sql;
	create table mediflag_datalink1 as
	select a.*, b.MBR_MAILABLE, b.MBR_EMAILABLE, b.mosaic from
	mediflag_datalink a left join lppl.ACTIVE_12M_MBR b
	on a.GROUP_LOYALTY_MEMBER_No=b.mbr_no;
quit;

proc freq data=mediflag_datalink1 noprint;
	tables mosaic / missing list out=test;
run;

data mediflag_datalink1 (drop=mosaic mosaic_hier);
	set mediflag_datalink1;
	mosaic_hier=substr(mosaic,1,1);
	format mosaic_Desc $40.;
	if mosaic_hier='A' then mosaic_desc='A - Exclusive Environs';
	else if mosaic_hier='B' then mosaic_desc='B - Knowledgeable Success';
	else if mosaic_hier='C' then mosaic_desc='C - Independence and Careers';
	else if mosaic_hier='D' then mosaic_desc='D - Affluent Acreage';
	else if mosaic_hier='E' then mosaic_desc='E - Distanced Existence';
	else if mosaic_hier='F' then mosaic_desc='F - New Homes and Hopes';
	else if mosaic_hier='G' then mosaic_desc='G - Middle Australia';
	else if mosaic_hier='H' then mosaic_desc='H - International Infusion';
	else if mosaic_hier='I' then mosaic_desc='I - Books and Boots';
	else if mosaic_hier='J' then mosaic_desc='J - Provincial Living';
	else if mosaic_hier='K' then mosaic_desc='K - Traditionally Grey';
	else if mosaic_hier='L' then mosaic_desc='L - Regional Endeavours';
	else if mosaic_hier='M' then mosaic_desc='M - Remotely Blue';
	else mosaic_Desc='Missing';

run;



/*Now run through pure profiles on the categorical vars to assign missings etc.*/

%macro profpure(variable,num);

proc sql;
	create table pureprof_&num. as
	select &variable., count(*) as mbrs, (calculated mbrs/ total) as percent format=percent8.2, total as total
	from mediflag_datalink1 as a, (select count(*) as total from mediflag_datalink) as b
	group by 1;
quit;

%mend;

%profpure(ACTIVE_MEMBER_12W_FLAG,1);
/*%profpure(ACTIVE_MEMBER_1Y_FLAG,2);*/
/*%profpure(ACTIVE_MEMBER_2Y_FLAG,3);*/
%profpure(ACTIVE_MEMBER_4W_FLAG,4);
/*%profpure(ACTIVE_MEMBER_6M_FLAG,5);*/
%profpure(ACTIVE_MEMBER_6W_FLAG,6);
%profpure(ACTIVITY_SEGMENT,7);
%profpure(AGL_LINKED,8);
%profpure(COLESGEOG_CLASS,9);
%profpure(COLES_LTF_FLAG,10);
%profpure(COLES_ONLINE_SHOPPER_FLAG,11);
%profpure(CUSTOMER_AFFLUENCE,12);
%profpure(CUSTOMER_AFFLUENCE_RATING_NAME,13);
%profpure(GM_AREA_TYPE,14);
/*%profpure(GROUP_LOYALTY_CARD_NUMBER,15);*/
/*%profpure(GROUP_LOYALTY_MEMBER_NUMBER,16);*/
%profpure(GRP_LYLTY_PRMRY_CARD_GENDER_CD,17);
%profpure(LOYALTY_SEGMENT,18);
/*%profpure(LOYALTY_SEGMENT_NAME,19);*/
%profpure(LPPL_EMAIL_FLAG,20);
%profpure(MAILABLE_FLAG,21);
%profpure(MEDIBANK_LINKED,22);
/*%profpure(MEDIBANK_NOT_LINKED_FLG,23);*/
%profpure(NEW_ACTIVE_MEMBER_6W_FLAG,24);
%profpure(NEW_MEMBER_POST_RELAUNCH_FLAG,25);
%profpure(NON_OPENER_6M_FLAG,26);
%profpure(POINTS_SEGMENT,27);
%profpure(RFM_SEGMENT,28);
%profpure(SHOPPINGCENTRETYPE,29);
%profpure(STATE_CODE,30);
%profpure(SURVEY_EVERYDAY_REWARDS_FLAG,31);
%profpure(SURVEY_LIQ_RESP_FLAG,32);

/*Link on customer segment  (Andy Ralphs team)*/
proc sql;
	create table mediflag_datalink1_1 as
	select a.*, b.lifestage_low_code, b.lifestage_high_code from
	mediflag_datalink1 a left join CEDWDM.LIF_SEG_CUSTOMER_VW b
	on a.customer_key=b.customer_key;
quit;

proc freq data=mediflag_datalink1_1 noprint;
	tables lifestage_low_code / missing list out=test;
run;
proc freq data=mediflag_datalink1_1 noprint;
	tables lifestage_high_code / missing list out=test1;
run;


/*Flag variables to impute*/
data mediflag_datalink2;
	set mediflag_datalink1_1;
	if agl_linked='' then imp_agl_linked=1; else imp_agl_linked=0;
	if COLESGEOG_CLASS='' then imp_COLESGEOG_CLASS=1; else imp_COLESGEOG_CLASS=0;
	if CUSTOMER_AFFLUENCE in ('n/a','') then imp_CUSTOMER_AFFLUENCE=1; else imp_CUSTOMER_AFFLUENCE=0;
	if GM_AREA_TYPE='' then imp_GM_AREA_TYPE=1; else imp_GM_AREA_TYPE=0;
	if LOYALTY_SEGMENT='' then imp_LOYALTY_SEGMENT=1; else imp_LOYALTY_SEGMENT=0;
	if LPPL_EMAIL_FLAG='U' then imp_LOYALTY_SEGMENT=1; else imp_LOYALTY_SEGMENT=0;
	if MEDIBANK_LINKED='' then imp_MEDIBANK_LINKED=1; else imp_MEDIBANK_LINKED=0;
	if POINTS_SEGMENT='' then imp_POINTS_SEGMENT=1; else imp_POINTS_SEGMENT=0;
	if RFM_SEGMENT='' then imp_RFM_SEGMENT=1; else imp_RFM_SEGMENT=0;
	if SHOPPINGCENTRETYPE='Bulky Goods' then imp_SHOPPINGCENTRETYPE=1; else imp_SHOPPINGCENTRETYPE=0;
	if state_code='' then imp_state_code=1; else imp_state_code=0;

	if lifestage_low_code='' then imp_lifestage_low_code=1; else imp_lifestage_low_code=0;
	if lifestage_high_code='' then imp_lifestage_high_code=1; else imp_lifestage_high_code=0;
	if mosaic_desc='Missing' then imp_mosaic_desc=1; else imp_mosaic_desc=0;
run;


data mediflag_datalink_imptchar;
	set mediflag_datalink2;

	if agl_linked='' then agl_linked='N';

	if COLESGEOG_CLASS='' then COLESGEOG_CLASS='Outer';

	if CUSTOMER_AFFLUENCE in ('n/a','') then CUSTOMER_AFFLUENCE='MISSING';

	if GM_AREA_TYPE='' then GM_AREA_TYPE='Urban';

	if LOYALTY_SEGMENT='' then LOYALTY_SEGMENT='MISSING';

	if LPPL_EMAIL_FLAG='U' then LOYALTY_SEGMENT='N';

	if MEDIBANK_LINKED='' then MEDIBANK_LINKED='N';

	if POINTS_SEGMENT='' then POINTS_SEGMENT='MISSING';

	if RFM_SEGMENT='' then RFM_SEGMENT='MISSING';

	if SHOPPINGCENTRETYPE='Bulky Goods' then SHOPPINGCENTRETYPE='Neighbourhood';

	if state_code='' then state_code='Missing';

	if lifestage_low_code='' then lifestage_low_code='Missing';

	if lifestage_high_code='' then lifestage_high_code='Missing';
run;


proc freq data=mediflag_datalink_imptchar noprint;
	tables AGE_NUMBER / missing list out=test;
run;


proc freq data=mediflag_datalink_imptchar noprint;
	tables registration_date / missing list out=testf1;
run;

data var_stats;
	set _null_;
run;

%macro numchecks(variable,num);

proc univariate data=mediflag_datalink_imptchar;
	var &variable.;
	output out=mean mean=mean;
	output out=miss nmiss=miss;
	output out=min min=min;
	output out=max max=max;
run;

data mrg_&num.;
	merge mean miss min max;
	format var $100.;
	var="&variable.";
run;

data var_stats;
	retain var;
	set var_stats mrg_&num.;
run;

%mend;


%numchecks(AFF_RANK,1);
%numchecks(AGE_NUMBER,2);
%numchecks(AVERAGE_HOUSEHOLD_SIZE,3);
%numchecks(AVERAGE_NUM_PSNS_PER_BEDROOM,4);
%numchecks(BABY_CLUB_INDICATOR,5);
%numchecks(CMCARD_PTS,6);
%numchecks(COLES_BNS_PTS,7);
%numchecks(COLES_PTS,8);
%numchecks(CS_NUM_TXNS_12W_EX_DEC,9);
%numchecks(CS_NUM_TXNS_6W_EX_DEC,10);
%numchecks(CS_TOTAL_SALES_AMT_12W_EX_DEC,11);
%numchecks(CS_TOTAL_SALES_AMT_6W_EX_DEC,12);
%numchecks(DISTANCE_1,13);
%numchecks(DISTANCE_2,14);
%numchecks(FES_SCORE,15);
%numchecks(GROUP_LOYALTY_PRIMARY_CARD_IND,16);
%numchecks(LOYALTY_RANK_NUMBER,17);
%numchecks(LOYALTY_SHARE_OF_WALLET_NUMBER,18);
%numchecks(MEDIAN_AGE_PERSONS,19);
%numchecks(MEDIAN_MORTGAGE_REPAY_MONTHLY,20);
%numchecks(MEDIAN_RENT_WEEKLY,21);
%numchecks(MEDIAN_TOT_FAM_INC_WEEKLY,22);
%numchecks(MEDIAN_TOT_HHD_INC_WEEKLY,23);
%numchecks(MEDIAN_TOT_PRSNL_INC_WEEKLY,24);
%numchecks(MOSAIC_GROUP_NEW,25);
%numchecks(NO_VISITS_12MTHS,26);
%numchecks(NO_VISITS_3MTHS,27);
%numchecks(NO_VISITS_4WKS,28);
%numchecks(NUMBER_OF_CARS_QUANTITY,29);
%numchecks(NUMBER_OF_HOUSEHOLD_MBRS_QTY,30);
%numchecks(NUMBER_OF_KIDS_0_TO_3_YR_QTY,31);
%numchecks(NUMBER_OF_KIDS_13_TO_18_YR_QTY,32);
%numchecks(NUMBER_OF_KIDS_4_TO_12_YR_QTY,33);
%numchecks(NUM_ALL_FUEL_RDMPTN_LAST_6_CTM,34);
%numchecks(PET_CAT_AND_DOG_INDICATOR,35);
%numchecks(SHARE_OF_WALLET,36);
%numchecks(TOTAL_POINTS,37);
%numchecks(TOTAL_SALES_12MTHS,38);
%numchecks(TOTAL_SALES_3MTHS,39);
%numchecks(TOTAL_SALES_4WKS,40);
%numchecks(WW_LOYALTY_PROGRAM_INDICATOR,41);
%numchecks(ave_basket_size_12mths,42);
%numchecks(ave_basket_size_3mths,43);
%numchecks(ave_basket_size_4wks,44);
%numchecks(coles_tenure_days,45);
%numchecks(days_since_at_coles,46);
%numchecks(last_3mths_sales_1C,47);
%numchecks(last_3mths_sales_BL,48);
%numchecks(last_3mths_sales_CE,49);
%numchecks(last_3mths_sales_CS,50);
%numchecks(last_3mths_sales_KM,51);
%numchecks(last_3mths_sales_LL,52);
%numchecks(last_3mths_sales_TG,53);
%numchecks(last_3mths_sales_VC,54);
%numchecks(ratio_bonus_std_pts,55);
%numchecks(ratio_coles_partner_pts,56);
%numchecks(total_bonus_pts,57);
%numchecks(total_coles_pts,58);
%numchecks(total_partner_pts,59);
%numchecks(total_std_pts,60);


data mediflag_datalink_imptnum;
	set mediflag_datalink_imptchar;
	/*Flag imputed vars*/

	if DISTANCE_1=. then imp_DISTANCE_1=1; else imp_DISTANCE_1=0;
	if DISTANCE_2=. then imp_DISTANCE_2=1; else imp_DISTANCE_2=0;
	if NUMBER_OF_CARS_QUANTITY=. then imp_NUMBER_OF_CARS_QUANTITY=1;else imp_NUMBER_OF_CARS_QUANTITY=0;
	if NUMBER_OF_HOUSEHOLD_MBRS_QTY=. then imp_NUMBER_OF_HOUSEHOLD_MBRS_QTY=1;else imp_NUMBER_OF_HOUSEHOLD_MBRS_QTY=0;
	if NUMBER_OF_KIDS_0_TO_3_YR_QTY=. then imp_NUMBER_OF_KIDS_0_TO_3_YR_QTY=1;else imp_NUMBER_OF_KIDS_0_TO_3_YR_QTY=0;
	if NUMBER_OF_KIDS_13_TO_18_YR_QTY=. then imp_NUMBER_OF_KIDS_13_TO_18=1;else imp_NUMBER_OF_KIDS_13_TO_18=0;
	if NUMBER_OF_KIDS_4_TO_12_YR_QTY=. then imp_NUMBER_OF_KIDS_4_TO_12=1;else imp_NUMBER_OF_KIDS_4_TO_12=0;
	if CMCARD_PTS=. then imp_CMCARD_PTS=1;else imp_CMCARD_PTS=0;
	if COLES_BNS_PTS=. then imp_COLES_BNS_PTS=1;else imp_COLES_BNS_PTS=0;
	if COLES_PTS=. then imp_COLES_PTS=1;else imp_COLES_PTS=0;
	if TOTAL_POINTS=. then imp_TOTAL_POINTS=1;else imp_TOTAL_POINTS=0;
	if total_bonus_pts=. then imp_total_bonus_pts=1;else imp_total_bonus_pts=0;
	if total_coles_pts=. then imp_total_coles_pts=1;else imp_total_coles_pts=0;
	if total_partner_pts=. then imp_total_partner_pts=1;else imp_total_partner_pts=0;
	if total_std_pts=. then imp_total_std_pts=1;else imp_total_std_pts=0;
	if ratio_bonus_std_pts=. then imp_ratio_bonus_std_pts=1;else imp_ratio_bonus_std_pts=0;
	if ratio_coles_partner_pts=. then imp_ratio_coles_partner_pts=1;else imp_ratio_coles_partner_pts=0;
	if AFF_RANK=. then imp_AFF_RANK=1;else imp_AFF_RANK=0;
	if LOYALTY_RANK_NUMBER=. then imp_LOYALTY_RANK_NUMBER=1;else imp_LOYALTY_RANK_NUMBER=0;
	if GROUP_LOYALTY_PRIMARY_CARD_IND=. then imp_GROUP_LOYALTY_PRIMARY_CARD=1;else imp_GROUP_LOYALTY_PRIMARY_CARD=0;
	if AVERAGE_HOUSEHOLD_SIZE=. then imp_AVERAGE_HOUSEHOLD_SIZE=1;else imp_AVERAGE_HOUSEHOLD_SIZE=0;
	if AVERAGE_NUM_PSNS_PER_BEDROOM=. then imp_AVERAGE_NUM_PSNS_PER_BEDROOM=1;else imp_AVERAGE_NUM_PSNS_PER_BEDROOM=0;
	if MEDIAN_AGE_PERSONS=. then imp_MEDIAN_AGE_PERSONS=1;else imp_MEDIAN_AGE_PERSONS=0;
	if MEDIAN_MORTGAGE_REPAY_MONTHLY=. then imp_MEDIAN_MORTGAGE_REPAY_MNTH=1;else imp_MEDIAN_MORTGAGE_REPAY_MNTH=0;
	if MEDIAN_RENT_WEEKLY=. then imp_MEDIAN_RENT_WEEKLY=1;else imp_MEDIAN_RENT_WEEKLY=0;
	if MEDIAN_TOT_FAM_INC_WEEKLY=. then imp_MEDIAN_TOT_FAM_INC_WEEKLY=1;else imp_MEDIAN_TOT_FAM_INC_WEEKLY=0;
	if MEDIAN_TOT_HHD_INC_WEEKLY=. then imp_MEDIAN_TOT_HHD_INC_WEEKLY=1;else imp_MEDIAN_TOT_HHD_INC_WEEKLY=0;
	if MEDIAN_TOT_PRSNL_INC_WEEKLY=. then imp_MEDIAN_TOT_PRSNL_INC_WEEKLY=1;else imp_MEDIAN_TOT_PRSNL_INC_WEEKLY=0;
	if NO_VISITS_4WKS=. then imp_NO_VISITS_4WKS=1;else imp_NO_VISITS_4WKS=0;
	if TOTAL_SALES_4WKS=. then imp_TOTAL_SALES_4WKS=1;else imp_TOTAL_SALES_4WKS=0;
	if ave_basket_size_4wks=. then imp_ave_basket_size_4wks=1;else imp_ave_basket_size_4wks=0;
	if NO_VISITS_3MTHS=. then imp_NO_VISITS_3MTHS=1;else imp_NO_VISITS_3MTHS=0;
	if TOTAL_SALES_3MTHS=. then imp_TOTAL_SALES_3MTHS=1;else imp_TOTAL_SALES_3MTHS=0;
	if ave_basket_size_3mths=. then imp_ave_basket_size_3mths=1;else imp_ave_basket_size_3mths=0;
	if last_3mths_sales_CS=. then imp_last_3mths_sales_CS=1;else imp_last_3mths_sales_CS=0;
	if PET_CAT_AND_DOG_INDICATOR=. then imp_PET_CAT_AND_DOG_INDICATOR=1;else imp_PET_CAT_AND_DOG_INDICATOR=0;
	if BABY_CLUB_INDICATOR=. then imp_BABY_CLUB_INDICATOR=1;else imp_BABY_CLUB_INDICATOR=0;
	if SHARE_OF_WALLET=. then imp_SHARE_OF_WALLET=1;else imp_SHARE_OF_WALLET=0;
	if LOYALTY_SHARE_OF_WALLET_NUMBER=. then imp_LOYALTY_SHARE_OF_WALLET_NUM=1;else imp_LOYALTY_SHARE_OF_WALLET_NUM=0;
	if NUM_ALL_FUEL_RDMPTN_LAST_6_CTM=. then imp_NUM_ALL_FL_RDMPT_LAST_6_CTM=1;else imp_NUM_ALL_FL_RDMPT_LAST_6_CTM=0;
	if WW_LOYALTY_PROGRAM_INDICATOR=. then imp_WW_LOYALTY_PROGRAM_INDICATOR=1;else imp_WW_LOYALTY_PROGRAM_INDICATOR=0;
	if FES_SCORE=. then imp_FES_SCORE=1;else imp_FES_SCORE=0;
	if days_since_at_coles=. then imp_days_since_at_coles=1;else imp_days_since_at_coles=0;
	if AGE_NUMBER<=15 then imp_AGE_NUMBER=1;else imp_AGE_NUMBER=0;


run;

/*Drop some variables I don't want*/
data mediflag_datalink_refinenums (drop=registration_date group_loyalty_member_number customer_key group_loyalty_card_number);
	set mediflag_datalink_imptchar (drop=MOSAIC_GROUP_NEW last_3mths_sales_KM last_3mths_sales_TG last_3mths_sales_LL last_3mths_sales_1C
			  							 last_3mths_sales_BL last_3mths_sales_CE last_3mths_sales_VC);
	if DISTANCE_1=. then DISTANCE_1=8.49;
	if DISTANCE_2=. then DISTANCE_2=12.72;
	if NUMBER_OF_CARS_QUANTITY=. then NUMBER_OF_CARS_QUANTITY=1.2;
	if NUMBER_OF_HOUSEHOLD_MBRS_QTY=. then NUMBER_OF_HOUSEHOLD_MBRS_QTY=1.94;
	if NUMBER_OF_KIDS_0_TO_3_YR_QTY=. then NUMBER_OF_KIDS_0_TO_3_YR_QTY=0.12;
	if NUMBER_OF_KIDS_13_TO_18_YR_QTY=. then NUMBER_OF_KIDS_13_TO_18_YR_QTY=0.13;
	if NUMBER_OF_KIDS_4_TO_12_YR_QTY=. then NUMBER_OF_KIDS_4_TO_12_YR_QTY=0.24;
	if CMCARD_PTS=. then CMCARD_PTS=620.95;
	if COLES_BNS_PTS=. then COLES_BNS_PTS=1675;
	if COLES_PTS=. then COLES_PTS=3038;
	if TOTAL_POINTS=. then TOTAL_POINTS=11550;
	if total_bonus_pts=. then total_bonus_pts=2130;
	if total_coles_pts=. then total_coles_pts=4714;
	if total_partner_pts=. then total_partner_pts=3476;
	if total_std_pts=. then total_std_pts=6060;
	if ratio_bonus_std_pts=. then ratio_bonus_std_pts=0.16;
	if ratio_coles_partner_pts=. then ratio_coles_partner_pts=0.63;
	if AFF_RANK=. then AFF_RANK=2;
	if LOYALTY_RANK_NUMBER=. then LOYALTY_RANK_NUMBER=0;
	if GROUP_LOYALTY_PRIMARY_CARD_IND=. then GROUP_LOYALTY_PRIMARY_CARD_IND=1;
	if AVERAGE_HOUSEHOLD_SIZE=. then AVERAGE_HOUSEHOLD_SIZE=2.64;
	if AVERAGE_NUM_PSNS_PER_BEDROOM=. then AVERAGE_NUM_PSNS_PER_BEDROOM=1;
	if MEDIAN_AGE_PERSONS=. then MEDIAN_AGE_PERSONS=38;
	if MEDIAN_MORTGAGE_REPAY_MONTHLY=. then MEDIAN_MORTGAGE_REPAY_MONTHLY=1909;
	if MEDIAN_RENT_WEEKLY=. then MEDIAN_RENT_WEEKLY=316;
	if MEDIAN_TOT_FAM_INC_WEEKLY=. then MEDIAN_TOT_FAM_INC_WEEKLY=1617;
	if MEDIAN_TOT_HHD_INC_WEEKLY=. then MEDIAN_TOT_HHD_INC_WEEKLY=1408;
	if MEDIAN_TOT_PRSNL_INC_WEEKLY=. then MEDIAN_TOT_PRSNL_INC_WEEKLY=628;
	if NO_VISITS_4WKS=. then NO_VISITS_4WKS=0;
	if TOTAL_SALES_4WKS=. then TOTAL_SALES_4WKS=0;
	if ave_basket_size_4wks=. then ave_basket_size_4wks=0;
	if NO_VISITS_3MTHS=. then NO_VISITS_3MTHS=0;
	if TOTAL_SALES_3MTHS=. then TOTAL_SALES_3MTHS=0;
	if ave_basket_size_3mths=. then ave_basket_size_3mths=0;
	if last_3mths_sales_CS=. then last_3mths_sales_CS=0;
	if PET_CAT_AND_DOG_INDICATOR=. then PET_CAT_AND_DOG_INDICATOR=0;
	if BABY_CLUB_INDICATOR=. then BABY_CLUB_INDICATOR=0;
	if SHARE_OF_WALLET=. then SHARE_OF_WALLET=0;
	if LOYALTY_SHARE_OF_WALLET_NUMBER=. then LOYALTY_SHARE_OF_WALLET_NUMBER=0;
	if NUM_ALL_FUEL_RDMPTN_LAST_6_CTM=. then NUM_ALL_FUEL_RDMPTN_LAST_6_CTM=0;
	if WW_LOYALTY_PROGRAM_INDICATOR=. then WW_LOYALTY_PROGRAM_INDICATOR=0;
	if FES_SCORE=. then FES_SCORE=0.6;
	if days_since_at_coles=. then days_since_at_coles=380;
	if AGE_NUMBER<=15 then AGE_NUMBER=43;

	/*Clean up registration date*/
	if registration_date=. then registered='N';
	else registered='Y';

	/*Clean up target*/
	if medibank_target=. then medibank_target=0;

run;

proc freq data=mediflag_datalink_refinenums noprint;
	tables medibank_target / missing list out=testfreq;
run;


/*Right - oversample from the targets and sample from the rest*/

/*Keep a random 50k sample*/

proc surveyselect data=mediflag_datalink_refinenums method=srs reps=1 sampsize=50000 seed=12345 out=sample_50k (drop=replicate) noprint;
	where medibank_target=0 and MBR_EMAILABLE='N' and mbr_mailable='Y';
run;

proc contents data=mediflag_datalink_refinenums out=contentsnow;
run;

data mediflag_trgs;
	set mediflag_datalink_refinenums;
	if medibank_target=1;
run;

/*Set together the sample and the full targets*/
data set_to_model;
	set mediflag_trgs sample_50k;
run;

proc freq data=set_to_model noprint;
	tables medibank_target / missing list out=testfre1;
run;


/*Profile all of the character variables first*/
proc contents data=set_to_model out=setmod_contents;
run;

data char_vars (keep=name) num_vars (keep=name);
	set setmod_contents ;
	if TYPE=2 then output char_vars;
	if TYPE=1 then output num_vars;
run;

data char_vars;
	set char_vars;
	name=compress(name);
	num=_N_;
run;
data num_vars;
	set num_vars;
	name=compress(name);
	num=compress(_N_);
run;

/*Profile chars first*/

%macro profiletrg(variable,num);

proc sql;
	create table _1_way_chr_&num. as
	select a.medibank_target, a.&variable., count(*) as count,
		   calculated count / subtotal as percent format=percent8.2, subtotal as subtotal
	from set_to_model as a, (select medibank_target, count(*) as subtotal from set_to_model group by 1) as b
	where a.medibank_target=b.medibank_target
	group by a.medibank_target, a.&variable.;
quit;


%mend profiletrg;

data _null_;
	set char_vars (keep=name num);
	call execute('%profiletrg('||name||','||num||')');
run;


/*Run information values*/

data significance;
	set _null_;
run;

%macro infov(var,num);

proc sql;
	create table p_&var. as select
	&var., count(*) as pop, sum(medibank_target) as event,
	calculated event / calculated pop as yield format percent8.2,
	(calculated pop / (select count(*) from set_to_model)) as pop_rate format percent8.2,
	(calculated event / (select sum(medibank_target) from set_to_model)) as targets format percent8.2, 
	((calculated pop - calculated event) / (select count(*) from set_to_model where medibank_target=0)) as non_targets format percent8.2,
	calculated targets / calculated non_targets as odds_ratio,
	log(calculated odds_ratio) as W_of_E,
	(calculated targets-calculated non_targets)*calculated W_of_E as info
	from set_to_model
	group by 1;

	create table p_&var. as select *, sum(info) as total_info
	from p_&var.;
quit;

data p_&var.;
	set p_&var.;
	if total_info lt 0.05 then significance='Not Sig';
	if total_info ge 0.05 then significance='Maybe';
	if total_info gt 0.1 then significance='Sig';
run;

data o_&var. (keep=variable significance);
	retain variable;
	set p_&var.;
	format variable $50.;
	variable="&var.";
	if _N_=1 then output;
run;

data significance;
	set significance o_&var.;
run;


%mend;


data _null_;
	set char_vars (keep=name num);
	call execute('%infov('||name||','||num||')');
run;

/*Run for the imputed variables too*/

data imp_vars;
	set num_vars;
	if substr(name,1,3)='imp' then output;
run;

data _null_;
	set imp_vars (keep=name num);
	call execute('%infov('||name||','||num||')');
run;


/*Quick and final clean up of some of char vars*/

data mediflag_datalink_clean1;
	set mediflag_datalink_refinenums;
	if GRP_LYLTY_PRMRY_CARD_GENDER_CD='' then GRP_LYLTY_PRMRY_CARD_GENDER_CD='F';
	if points_segment in ('1. 0 to 9,999','MISSING','x. <0') then points_segment_nw='1';
		else if points_segment='2. 10,000 to 19,999' then points_segment_nw='2';
		else points_segment_nw='3';
run;

libname pm '\\swag\grpdata\flybuys Offers\03. Analytics\09. Partner Analytics\OTHERS\Medibank Propensity Model';
data pm.mediflag_datalink_clean1;
	set mediflag_datalink_clean1;
run;
data mediflag_datalink_clean1;
	set pm.mediflag_datalink_clean1;
run;

/*Prepare for modelling*/
data modeltooall;
	set mediflag_datalink_clean1;
	where medibank_target=0 and MBR_EMAILABLE='N' and mbr_mailable='Y';
run;

/*Sample again 50k from the non-targets*/
proc surveyselect data=mediflag_datalink_clean1 method=srs reps=1 sampsize=50000 seed=12345 out=sample_50k_new (drop=replicate) noprint;
	where medibank_target=0 and MBR_EMAILABLE='N' and mbr_mailable='Y';
run;

data targets_all;
	set mediflag_datalink_clean1;
	if medibank_target=1 then output;
run;

data os_modelling_set_ttl;
	set targets_all (in=a) sample_50k_new (in=b);
run;

/*Hold out a validation set*/
proc surveyselect data=os_modelling_set_ttl method=srs reps=1 sampsize=15000 seed=12345 out=os_valid_set_15k (drop=replicate) noprint;
run;

proc freq data=os_valid_set_15k noprint;
	tables medibank_target / missing list out=t1_1;
run;

proc sort data=os_modelling_set_ttl;
	by group_loyalty_member_no;
run;
proc sort data=os_valid_set_15k;
	by group_loyalty_member_no;
run;

data os_training_set;
	merge os_modelling_set_ttl (in=a) os_valid_set_15k (in=b keep=group_loyalty_member_no);
	by group_loyalty_member_no;
	if a and not b;
run;



data full_set;
	set targets_all modeltooall;
run;


proc freq data=os_training_set noprint;
	tables medibank_target*MBR_EMAILABLE*mbr_mailable / missing list out=test;
run;

proc freq data=full_set noprint;
	tables medibank_target / missing list out=tesfq1;
run;


/*Model*/
ods trace on;
ods select  lackfitchisq fitstatistics
globaltests lackfitpartition parameterestimates Type3;

ods output lackfitchisq=lack_out;
ods output fitstatistics=fit_out;
ods output globaltests=global_out;
ods output lackfitpartition=lackfit_out;
ods output parameterestimates=ret_params_out;
ods output Association=assoc_out;

ods output Type3=Type3_out;


proc logistic data=os_training_set descending outest=coeff_;
	class mosaic_desc ACTIVITY_SEGMENT POINTS_SEGMENT_NW registered STATE_CODE GM_AREA_TYPE LIFESTAGE_HIGH_CODE;
	model medibank_target = FES_SCORE AGE_NUMBER mosaic_desc ACTIVITY_SEGMENT POINTS_SEGMENT_NW registered STATE_CODE GM_AREA_TYPE LIFESTAGE_HIGH_CODE

  / /*include= selection=backward fast*/
	lackfit rsq
	influence iplots  ;
	output out=out1 predprobs=(i);

	score data=os_valid_set_15k priorevent=0.0106  out=out_2;

	score data=full_set priorevent=0.0106 out=all_score;
run;

ods output close;

proc freq data=os_training_set noprint;
	tables GM_AREA_TYPE / missing list out=tef;
run;
proc freq data=os_training_set noprint;
	tables STATE_CODE / missing list out=tef1;
run;

proc freq data=os_training_set noprint;
	tables mosaic_desc / missing list out=tef1;
run;

ods graphics on;
proc logistic data=os_training_set descending outest=coeff_;
	class mosaic_desc ACTIVITY_SEGMENT POINTS_SEGMENT_NW registered STATE_CODE GM_AREA_TYPE LIFESTAGE_HIGH_CODE;
	model medibank_target = FES_SCORE AGE_NUMBER mosaic_desc ACTIVITY_SEGMENT POINTS_SEGMENT_NW registered STATE_CODE GM_AREA_TYPE LIFESTAGE_HIGH_CODE

  / /*include= selection=backward fast*/
	outroc=roc_out;
	output out=out1 predprobs=(i);

	score data=os_valid_set_15k priorevent=0.0106  out=out_2 outroc=vroc;
	roc; roccontrast;


run;



/*Who are the top 100k custs?*/

proc sort data=all_score out=srted_prospects;
	by descending p_1;
	where medibank_target=0;
run;

data srted_prospects;
	set srted_prospects;
	if _N_<=100000 then flag_select='Y';
	else flag_select='N';
run;

/*Profile differences between the target and non target*/


%macro proftarget(variable,num);

proc sql;
	create table _trg_1_&num. as
	select a.medibank_target, a.&variable., count(*) as count,
		   calculated count / subtotal as percent format=percent8.2, subtotal as subtotal
	from full_set as a, (select medibank_target, count(*) as subtotal from full_set group by 1) as b
	where a.medibank_target=b.medibank_target
	group by a.medibank_target, a.&variable.;
quit;


%mend;

%proftarget(mosaic_desc,1);
%proftarget(ACTIVITY_SEGMENT,2);
%proftarget(POINTS_SEGMENT_NW,3);
%proftarget(registered,4);
%proftarget(STATE_CODE,5);
%proftarget(GM_AREA_TYPE,6);
%proftarget(LIFESTAGE_HIGH_CODE,7);

proc summary data=full_set nway missing;
	class medibank_target;
	var FES_SCORE;
	output out=summ_1_trg (drop=_:) mean=mean median=med;
run;
proc summary data=full_set nway missing;
	class medibank_target;
	var AGE_NUMBER;
	output out=summ_2_trg (drop=_:) mean=mean median=med;
run;




/*Profile differences between the selection and non selection*/

%macro profselect(variable,num);

proc sql;
	create table _sel_1_&num. as
	select a.flag_select, a.&variable., count(*) as count,
		   calculated count / subtotal as percent format=percent8.2, subtotal as subtotal
	from srted_prospects as a, (select flag_select, count(*) as subtotal from srted_prospects group by 1) as b
	where a.flag_select=b.flag_select
	group by a.flag_select, a.&variable.;
quit;


%mend;

%profselect(mosaic_desc,1);
%profselect(ACTIVITY_SEGMENT,2);
%profselect(POINTS_SEGMENT_NW,3);
%profselect(registered,4);
%profselect(STATE_CODE,5);
%profselect(GM_AREA_TYPE,6);
%profselect(LIFESTAGE_HIGH_CODE,7);

proc summary data=srted_prospects nway missing;
	class flag_select;
	var FES_SCORE;
	output out=summ_1 (drop=_:) mean=mean median=med;
run;
proc summary data=srted_prospects nway missing;
	class flag_select;
	var AGE_NUMBER;
	output out=summ_2 (drop=_:) mean=mean median=med;
run;


proc freq data=srted_prospects noprint;
	tables flag_select*AGE_NUMBER / missing list out=summ_3;
run;



/*How does this interact with Geoffs selection?*/
data geoff_selection (rename=(GROUP_LOYALTY_MEMBER_NUMBER=GROUP_LOYALTY_MEMBER_No));
	set dmteam.MB0049_SOLUS_DM_TGT_WITH_CTRL;
run;


/*How many are in both - venn*/
proc sort data=geoff_selection;
	by GROUP_LOYALTY_MEMBER_No;
run;
proc sort data=srted_prospects out=peter_selection;
	by GROUP_LOYALTY_MEMBER_No;
	where flag_select='Y';
run;


data venn_merge;
	merge peter_selection (in=a keep=GROUP_LOYALTY_MEMBER_No) geoff_selection (in=b keep=GROUP_LOYALTY_MEMBER_No);
	by GROUP_LOYALTY_MEMBER_No;
	if a and b then venn_flag='Both';
	else if a then venn_flag='Pete';
	else if b then venn_flag='Geoff';
run;
proc freq data=venn_merge noprint;
	tables venn_flag / missing list out=venn_Freq;
run;

/*Check that peter's selection doesn't have any targets or emailable people*/
proc freq data=peter_selection noprint;
	tables mbr_emailable*mbr_mailable / missing list out=testfreq;
run;


/*Drop my selection into dmteam*/
data dmteam.MB0049_SOLUS_DM_TGT_MODEL (rename=(p_1=score));
	set peter_selection (keep=GROUP_LOYALTY_MEMBER_No p_1);
run;


proc sql;
	create table test as
	select count(*) as count1
	from dmteam.MB0049_SOLUS_DM_TGT_MODEL;
quit;