--Features
--Survey
/*
nvl(NUMBER_OF_UNDER18,0) as NUMBER_OF_UNDER18,
NO_OF_CARS,
nvl(ONLINESHOPPING_YR,0) AS ONLINESHOPPING_YR,
HOME_INTERNET,MOBILE_INTERNET,PRE_MIXED,WHITE_WINE,RED_WINE,SPARKLING_WINE,SPIRITS,BEER,LIQUOR_NONE,BUSINESS_OWNER,
nvl(BABY_CLUB,0) as BABY_CLUB
*/
--Mbr
/*
MBR_NO,AGE_BAND,MBR_GENDER,MBR_RES_STATE,
nvl(SUBSTR(A.MOSAIC_DESC,1,1),'n/a') AS MOSAIC_DESC
,MBR_EMAILABLE,MBR_MAILABLE,ACTIVE_6M,ACTIVE_3M,ACTIVE_1M,REDM_12M,REDM_6M,REDM_3M,REDM_1M,OPENER_6M,COLES_PTS,AGL_PTS,WEBJET_PTS,CEXPRESS_PTS,FCHOICE_PTS,FCHOICE_ONL_PTS,
LIQUORLAND_PTS,LIQUORLAND_ONL_PTS,ESHOP_PTS,WW_PTS,COLES_BNS_PTS,AGL_BNS_PTS,WEBJET_BNS_PTS,CEXPRESS_BNS_PTS,FCHOICE_BNS_PTS,FCHOICE_O_BNS_PTS,LIQUORLAND_BNS_PTS,LIQUORLAND_O_BNSPTS,ESHOP_BNS_PTS,WW_BNS_PTS,TOTAL_PARTNERS_12M,
TOTAL_STD_PTS_1M,TOTAL_BNS_PTS_1M,TOTAL_STD_PTS_3M,TOTAL_BNS_PTS_3M,TOTAL_STD_PTS_6M,TOTAL_BNS_PTS_6M,TOTAL_STD_PTS_9M,TOTAL_BNS_PTS_9M,TOTAL_STD_PTS_12M,TOTAL_BNS_PTS_12M,TOTAL_REDMPTS_12M,TOTAL_REDMPTS_9M,TOTAL_REDMPTS_6M,
TOTAL_REDMPTS_3M,TOTAL_REDMPTS_1M,CUSTOMER_AFFLUENCE,FES_SCORE_Y,FES_SCORE_Q,
nvl(LOYALTY_SEGMENT_NAME,'n/a') AS LOYALTY_SEGMENT_NAME,
nvl(LOYALTY_SHARE_OF_WALLET_NUMBER,0) as LOYALTY_SHARE_OF_WALLET_NUMBER,
nvl(substr(A.lifestage_high_name,1,1),'n/a') AS lifestage_high_name,
*/


--LL Online
DROP TABLE FCO_LookAlike_LLO;
CREATE TABLE FCO_LookAlike_LLO COMPRESS FOR QUERY HIGH PCTFREE 0
as
SELECT MBR_NO,AGE_BAND,MBR_GENDER,MBR_RES_STATE,
nvl(SUBSTR(A.MOSAIC_DESC,1,1),'n/a') AS MOSAIC_DESC
,MBR_EMAILABLE,MBR_MAILABLE,ACTIVE_6M,ACTIVE_3M,ACTIVE_1M,REDM_12M,REDM_6M,REDM_3M,REDM_1M,OPENER_6M,COLES_PTS,AGL_PTS,WEBJET_PTS,CEXPRESS_PTS,FCHOICE_PTS,FCHOICE_ONL_PTS,
LIQUORLAND_PTS,LIQUORLAND_ONL_PTS,ESHOP_PTS,WW_PTS,COLES_BNS_PTS,AGL_BNS_PTS,WEBJET_BNS_PTS,CEXPRESS_BNS_PTS,FCHOICE_BNS_PTS,FCHOICE_O_BNS_PTS,LIQUORLAND_BNS_PTS,LIQUORLAND_O_BNSPTS,ESHOP_BNS_PTS,WW_BNS_PTS,TOTAL_PARTNERS_12M,
TOTAL_STD_PTS_1M,TOTAL_BNS_PTS_1M,TOTAL_STD_PTS_3M,TOTAL_BNS_PTS_3M,TOTAL_STD_PTS_6M,TOTAL_BNS_PTS_6M,TOTAL_STD_PTS_9M,TOTAL_BNS_PTS_9M,TOTAL_STD_PTS_12M,TOTAL_BNS_PTS_12M,TOTAL_REDMPTS_12M,TOTAL_REDMPTS_9M,TOTAL_REDMPTS_6M,
TOTAL_REDMPTS_3M,TOTAL_REDMPTS_1M,CUSTOMER_AFFLUENCE,FES_SCORE_Y,FES_SCORE_Q,
nvl(LOYALTY_SEGMENT_NAME,'n/a') AS LOYALTY_SEGMENT_NAME,
nvl(LOYALTY_SHARE_OF_WALLET_NUMBER,0) as LOYALTY_SHARE_OF_WALLET_NUMBER,
nvl(substr(A.lifestage_high_name,1,1),'n/a') AS lifestage_high_name,
nvl(NUMBER_OF_UNDER18,0) as NUMBER_OF_UNDER18,
NO_OF_CARS,
nvl(ONLINESHOPPING_YR,0) AS ONLINESHOPPING_YR,
HOME_INTERNET,MOBILE_INTERNET,PRE_MIXED,WHITE_WINE,RED_WINE,SPARKLING_WINE,SPIRITS,BEER,LIQUOR_NONE,BUSINESS_OWNER,
nvl(BABY_CLUB,0) as BABY_CLUB
FROM dmteam_work.active_12m_mbr A,
colesmkt.member_survey_flat@colesmkt.colesmyer.com.au b
WHERE 
A.mbr_no = b.group_loyalty_member_number (+)
AND A.LIQUORLAND_ONL_PTS>0;
select count(*),count(distinct mbr_no) from FCO_LookAlike_LLO; --3,636

--eShop
DROP TABLE FCO_LookAlike_eShop;
CREATE TABLE FCO_LookAlike_eShop COMPRESS FOR QUERY HIGH PCTFREE 0
as
SELECT MBR_NO,AGE_BAND,MBR_GENDER,MBR_RES_STATE,
nvl(SUBSTR(A.MOSAIC_DESC,1,1),'n/a') AS MOSAIC_DESC
,MBR_EMAILABLE,MBR_MAILABLE,ACTIVE_6M,ACTIVE_3M,ACTIVE_1M,REDM_12M,REDM_6M,REDM_3M,REDM_1M,OPENER_6M,COLES_PTS,AGL_PTS,WEBJET_PTS,CEXPRESS_PTS,FCHOICE_PTS,FCHOICE_ONL_PTS,
LIQUORLAND_PTS,LIQUORLAND_ONL_PTS,ESHOP_PTS,WW_PTS,COLES_BNS_PTS,AGL_BNS_PTS,WEBJET_BNS_PTS,CEXPRESS_BNS_PTS,FCHOICE_BNS_PTS,FCHOICE_O_BNS_PTS,LIQUORLAND_BNS_PTS,LIQUORLAND_O_BNSPTS,ESHOP_BNS_PTS,WW_BNS_PTS,TOTAL_PARTNERS_12M,
TOTAL_STD_PTS_1M,TOTAL_BNS_PTS_1M,TOTAL_STD_PTS_3M,TOTAL_BNS_PTS_3M,TOTAL_STD_PTS_6M,TOTAL_BNS_PTS_6M,TOTAL_STD_PTS_9M,TOTAL_BNS_PTS_9M,TOTAL_STD_PTS_12M,TOTAL_BNS_PTS_12M,TOTAL_REDMPTS_12M,TOTAL_REDMPTS_9M,TOTAL_REDMPTS_6M,
TOTAL_REDMPTS_3M,TOTAL_REDMPTS_1M,CUSTOMER_AFFLUENCE,FES_SCORE_Y,FES_SCORE_Q,
nvl(LOYALTY_SEGMENT_NAME,'n/a') AS LOYALTY_SEGMENT_NAME,
nvl(LOYALTY_SHARE_OF_WALLET_NUMBER,0) as LOYALTY_SHARE_OF_WALLET_NUMBER,
nvl(substr(A.lifestage_high_name,1,1),'n/a') AS lifestage_high_name,
nvl(NUMBER_OF_UNDER18,0) as NUMBER_OF_UNDER18,
NO_OF_CARS,
nvl(ONLINESHOPPING_YR,0) AS ONLINESHOPPING_YR,
HOME_INTERNET,MOBILE_INTERNET,PRE_MIXED,WHITE_WINE,RED_WINE,SPARKLING_WINE,SPIRITS,BEER,LIQUOR_NONE,BUSINESS_OWNER,
nvl(BABY_CLUB,0) as BABY_CLUB
FROM dmteam_work.active_12m_mbr A,
colesmkt.member_survey_flat@colesmkt.colesmyer.com.au b
WHERE 
A.mbr_no = b.group_loyalty_member_number (+)
AND A.eshop_pts>0;
select count(*),count(distinct mbr_no) from FCO_LookAlike_eShop; --19,612

--WebJet
DROP TABLE FCO_LookAlike_webjet;
CREATE TABLE FCO_LookAlike_webjet COMPRESS FOR QUERY HIGH PCTFREE 0
as
SELECT MBR_NO,AGE_BAND,MBR_GENDER,MBR_RES_STATE,
nvl(SUBSTR(A.MOSAIC_DESC,1,1),'n/a') AS MOSAIC_DESC
,MBR_EMAILABLE,MBR_MAILABLE,ACTIVE_6M,ACTIVE_3M,ACTIVE_1M,REDM_12M,REDM_6M,REDM_3M,REDM_1M,OPENER_6M,COLES_PTS,AGL_PTS,WEBJET_PTS,CEXPRESS_PTS,FCHOICE_PTS,FCHOICE_ONL_PTS,
LIQUORLAND_PTS,LIQUORLAND_ONL_PTS,ESHOP_PTS,WW_PTS,COLES_BNS_PTS,AGL_BNS_PTS,WEBJET_BNS_PTS,CEXPRESS_BNS_PTS,FCHOICE_BNS_PTS,FCHOICE_O_BNS_PTS,LIQUORLAND_BNS_PTS,LIQUORLAND_O_BNSPTS,ESHOP_BNS_PTS,WW_BNS_PTS,TOTAL_PARTNERS_12M,
TOTAL_STD_PTS_1M,TOTAL_BNS_PTS_1M,TOTAL_STD_PTS_3M,TOTAL_BNS_PTS_3M,TOTAL_STD_PTS_6M,TOTAL_BNS_PTS_6M,TOTAL_STD_PTS_9M,TOTAL_BNS_PTS_9M,TOTAL_STD_PTS_12M,TOTAL_BNS_PTS_12M,TOTAL_REDMPTS_12M,TOTAL_REDMPTS_9M,TOTAL_REDMPTS_6M,
TOTAL_REDMPTS_3M,TOTAL_REDMPTS_1M,CUSTOMER_AFFLUENCE,FES_SCORE_Y,FES_SCORE_Q,
nvl(LOYALTY_SEGMENT_NAME,'n/a') AS LOYALTY_SEGMENT_NAME,
nvl(LOYALTY_SHARE_OF_WALLET_NUMBER,0) as LOYALTY_SHARE_OF_WALLET_NUMBER,
nvl(substr(A.lifestage_high_name,1,1),'n/a') AS lifestage_high_name,
nvl(NUMBER_OF_UNDER18,0) as NUMBER_OF_UNDER18,
NO_OF_CARS,
nvl(ONLINESHOPPING_YR,0) AS ONLINESHOPPING_YR,
HOME_INTERNET,MOBILE_INTERNET,PRE_MIXED,WHITE_WINE,RED_WINE,SPARKLING_WINE,SPIRITS,BEER,LIQUOR_NONE,BUSINESS_OWNER,
nvl(BABY_CLUB,0) as BABY_CLUB 
FROM dmteam_work.active_12m_mbr A,
colesmkt.member_survey_flat@colesmkt.colesmyer.com.au b
WHERE 
A.mbr_no = b.group_loyalty_member_number (+)
AND A.webjet_pts>0;
SELECT count(*),count(DISTINCT mbr_no) FROM FCO_LookAlike_webjet; --116,525

--Coles online
DROP TABLE FCO_LookAlike_ColesO;
CREATE TABLE FCO_LookAlike_ColesO COMPRESS FOR QUERY HIGH PCTFREE 0
AS
SELECT MBR_NO,AGE_BAND,MBR_GENDER,MBR_RES_STATE,
nvl(SUBSTR(A.MOSAIC_DESC,1,1),'n/a') AS MOSAIC_DESC
,MBR_EMAILABLE,MBR_MAILABLE,ACTIVE_6M,ACTIVE_3M,ACTIVE_1M,REDM_12M,REDM_6M,REDM_3M,REDM_1M,OPENER_6M,COLES_PTS,AGL_PTS,WEBJET_PTS,CEXPRESS_PTS,FCHOICE_PTS,FCHOICE_ONL_PTS,
LIQUORLAND_PTS,LIQUORLAND_ONL_PTS,ESHOP_PTS,WW_PTS,COLES_BNS_PTS,AGL_BNS_PTS,WEBJET_BNS_PTS,CEXPRESS_BNS_PTS,FCHOICE_BNS_PTS,FCHOICE_O_BNS_PTS,LIQUORLAND_BNS_PTS,LIQUORLAND_O_BNSPTS,ESHOP_BNS_PTS,WW_BNS_PTS,TOTAL_PARTNERS_12M,
TOTAL_STD_PTS_1M,TOTAL_BNS_PTS_1M,TOTAL_STD_PTS_3M,TOTAL_BNS_PTS_3M,TOTAL_STD_PTS_6M,TOTAL_BNS_PTS_6M,TOTAL_STD_PTS_9M,TOTAL_BNS_PTS_9M,TOTAL_STD_PTS_12M,TOTAL_BNS_PTS_12M,TOTAL_REDMPTS_12M,TOTAL_REDMPTS_9M,TOTAL_REDMPTS_6M,
TOTAL_REDMPTS_3M,TOTAL_REDMPTS_1M,CUSTOMER_AFFLUENCE,FES_SCORE_Y,FES_SCORE_Q,
nvl(LOYALTY_SEGMENT_NAME,'n/a') AS LOYALTY_SEGMENT_NAME,
nvl(LOYALTY_SHARE_OF_WALLET_NUMBER,0) as LOYALTY_SHARE_OF_WALLET_NUMBER,
nvl(substr(A.lifestage_high_name,1,1),'n/a') AS lifestage_high_name,
nvl(NUMBER_OF_UNDER18,0) as NUMBER_OF_UNDER18,
NO_OF_CARS,
nvl(ONLINESHOPPING_YR,0) AS ONLINESHOPPING_YR,
HOME_INTERNET,MOBILE_INTERNET,PRE_MIXED,WHITE_WINE,RED_WINE,SPARKLING_WINE,SPIRITS,BEER,LIQUOR_NONE,BUSINESS_OWNER,
nvl(BABY_CLUB,0) as BABY_CLUB
FROM dmteam_work.active_12m_mbr A,
colesmkt.member_survey_flat@colesmkt.colesmyer.com.au b,
(SELECT distinct group_loyalty_member_number FROM cedwdm.transaction_vw WHERE POS_REGISTER_NUMBER=75) c
WHERE 
A.mbr_no = b.group_loyalty_member_number (+)
AND A.mbr_no = c.group_loyalty_member_number;
SELECT count(*),count(DISTINCT mbr_no) FROM FCO_LookAlike_ColesO; --483,655

--FC Online
DROP TABLE FCO_LookAlike_FCO;
CREATE TABLE FCO_LookAlike_FCO COMPRESS FOR QUERY HIGH PCTFREE 0
as
SELECT MBR_NO,AGE_BAND,MBR_GENDER,MBR_RES_STATE,
nvl(SUBSTR(A.MOSAIC_DESC,1,1),'n/a') AS MOSAIC_DESC
,MBR_EMAILABLE,MBR_MAILABLE,ACTIVE_6M,ACTIVE_3M,ACTIVE_1M,REDM_12M,REDM_6M,REDM_3M,REDM_1M,OPENER_6M,COLES_PTS,AGL_PTS,WEBJET_PTS,CEXPRESS_PTS,FCHOICE_PTS,FCHOICE_ONL_PTS,
LIQUORLAND_PTS,LIQUORLAND_ONL_PTS,ESHOP_PTS,WW_PTS,COLES_BNS_PTS,AGL_BNS_PTS,WEBJET_BNS_PTS,CEXPRESS_BNS_PTS,FCHOICE_BNS_PTS,FCHOICE_O_BNS_PTS,LIQUORLAND_BNS_PTS,LIQUORLAND_O_BNSPTS,ESHOP_BNS_PTS,WW_BNS_PTS,TOTAL_PARTNERS_12M,
TOTAL_STD_PTS_1M,TOTAL_BNS_PTS_1M,TOTAL_STD_PTS_3M,TOTAL_BNS_PTS_3M,TOTAL_STD_PTS_6M,TOTAL_BNS_PTS_6M,TOTAL_STD_PTS_9M,TOTAL_BNS_PTS_9M,TOTAL_STD_PTS_12M,TOTAL_BNS_PTS_12M,TOTAL_REDMPTS_12M,TOTAL_REDMPTS_9M,TOTAL_REDMPTS_6M,
TOTAL_REDMPTS_3M,TOTAL_REDMPTS_1M,CUSTOMER_AFFLUENCE,FES_SCORE_Y,FES_SCORE_Q,
nvl(LOYALTY_SEGMENT_NAME,'n/a') AS LOYALTY_SEGMENT_NAME,
nvl(LOYALTY_SHARE_OF_WALLET_NUMBER,0) as LOYALTY_SHARE_OF_WALLET_NUMBER,
nvl(substr(A.lifestage_high_name,1,1),'n/a') AS lifestage_high_name,
nvl(NUMBER_OF_UNDER18,0) as NUMBER_OF_UNDER18,
NO_OF_CARS,
nvl(ONLINESHOPPING_YR,0) AS ONLINESHOPPING_YR,
HOME_INTERNET,MOBILE_INTERNET,PRE_MIXED,WHITE_WINE,RED_WINE,SPARKLING_WINE,SPIRITS,BEER,LIQUOR_NONE,BUSINESS_OWNER,
nvl(BABY_CLUB,0) as BABY_CLUB 
FROM dmteam_work.active_12m_mbr A,
colesmkt.member_survey_flat@colesmkt.colesmyer.com.au b
WHERE 
A.mbr_no = b.group_loyalty_member_number (+)
AND A.FCHOICE_ONL_PTS>0;
SELECT count(*),count(DISTINCT mbr_no) FROM FCO_LookAlike_FCO; --12,309

--Target Online
DROP TABLE FCO_LookAlike_TargetO;
CREATE TABLE FCO_LookAlike_TargetO COMPRESS FOR QUERY HIGH PCTFREE 0
AS
SELECT MBR_NO,AGE_BAND,MBR_GENDER,MBR_RES_STATE,
nvl(SUBSTR(A.MOSAIC_DESC,1,1),'n/a') AS MOSAIC_DESC
,MBR_EMAILABLE,MBR_MAILABLE,ACTIVE_6M,ACTIVE_3M,ACTIVE_1M,REDM_12M,REDM_6M,REDM_3M,REDM_1M,OPENER_6M,COLES_PTS,AGL_PTS,WEBJET_PTS,CEXPRESS_PTS,FCHOICE_PTS,FCHOICE_ONL_PTS,
LIQUORLAND_PTS,LIQUORLAND_ONL_PTS,ESHOP_PTS,WW_PTS,COLES_BNS_PTS,AGL_BNS_PTS,WEBJET_BNS_PTS,CEXPRESS_BNS_PTS,FCHOICE_BNS_PTS,FCHOICE_O_BNS_PTS,LIQUORLAND_BNS_PTS,LIQUORLAND_O_BNSPTS,ESHOP_BNS_PTS,WW_BNS_PTS,TOTAL_PARTNERS_12M,
TOTAL_STD_PTS_1M,TOTAL_BNS_PTS_1M,TOTAL_STD_PTS_3M,TOTAL_BNS_PTS_3M,TOTAL_STD_PTS_6M,TOTAL_BNS_PTS_6M,TOTAL_STD_PTS_9M,TOTAL_BNS_PTS_9M,TOTAL_STD_PTS_12M,TOTAL_BNS_PTS_12M,TOTAL_REDMPTS_12M,TOTAL_REDMPTS_9M,TOTAL_REDMPTS_6M,
TOTAL_REDMPTS_3M,TOTAL_REDMPTS_1M,CUSTOMER_AFFLUENCE,FES_SCORE_Y,FES_SCORE_Q,
nvl(LOYALTY_SEGMENT_NAME,'n/a') AS LOYALTY_SEGMENT_NAME,
nvl(LOYALTY_SHARE_OF_WALLET_NUMBER,0) as LOYALTY_SHARE_OF_WALLET_NUMBER,
nvl(substr(A.lifestage_high_name,1,1),'n/a') AS lifestage_high_name,
nvl(NUMBER_OF_UNDER18,0) as NUMBER_OF_UNDER18,
NO_OF_CARS,
nvl(ONLINESHOPPING_YR,0) AS ONLINESHOPPING_YR,
HOME_INTERNET,MOBILE_INTERNET,PRE_MIXED,WHITE_WINE,RED_WINE,SPARKLING_WINE,SPIRITS,BEER,LIQUOR_NONE,BUSINESS_OWNER,
nvl(BABY_CLUB,0) as BABY_CLUB
FROM dmteam_work.active_12m_mbr A,
colesmkt.member_survey_flat@colesmkt.colesmyer.com.au b,
(SELECT distinct group_loyalty_member_number FROM CEDWDM.transaction_vw 
WHERE edw_business_brand_code = 'TG'
AND store_idnt = 5599) c
WHERE 
A.mbr_no = b.group_loyalty_member_number (+)
AND A.mbr_no = c.group_loyalty_member_number;
SELECT count(*),count(DISTINCT mbr_no) FROM FCO_LookAlike_TargetO; --417,022

--Transaction table -web
DROP TABLE FCO_LookAlike_WebTrans;
CREATE TABLE FCO_LookAlike_WebTrans COMPRESS FOR QUERY HIGH PCTFREE 0
AS
SELECT substr(FLYBUYS_CARD_NO,7,8) MBR_NUM, EDW_BUSINESS_BRAND_CODE,  CHANNEL, TOTAL_LINE_SALE, ITEM_QUANTITY, ITEM_CAT
FROM mlightow.core_web_sales_12m_vw
WHERE TRANSACTION_DATE BETWEEN '31 Jul 2014' AND '31 Aug 2015'
AND flybuys_card_no <>0 AND flybuys_card_no IS NOT NULL;

SELECT sum(total_line_sale), sum(item_quantity), mbr_num, edw_business_brand_code, item_cat 
FROM FCO_LookAlike_WebTrans
group by  mbr_num, edw_business_brand_code, item_cat order by mbr_num;


--Transaction table -all
DROP TABLE FCO_LookAlike_AllTrans;
CREATE TABLE FCO_LookAlike_AllTrans COMPRESS FOR QUERY HIGH PCTFREE 0
AS
SELECT t.group_loyalty_member_number,t.total_basket_quantity, t.edw_business_brand_code,t.day_hour_number,
t.total_sales_amount,t.gift_card_indicator, t.item_scan_timestamp,
nvl(nvl(p.item_name,s.item_name), 'Non liquor') AS product,
nvl(nvl(p.item_cat,s.item_cat), 'Non liquor') as category
FROM cedwdm.transaction_product_vw t,
     mmakosh1.liq_m3_cat_plu p,
     mmakosh1.liq_m3_cat_sku s
     WHERE  t.plu_key = p.plu_key (+)
AND   t.sku_key = s.sku_key (+)
AND t.group_loyalty_member_number IS NOT NULL
and  t.TRANSACTION_DATE BETWEEN '31 Jul 2014' AND '31 Aug 2015';

--Transaction table -all aggregated
SELECT t.group_loyalty_member_number, 
t.edw_business_brand_code,
t.gift_card_indicator,
nvl(nvl(p.item_name,s.item_name), 'Non liquor') AS product,
nvl(nvl(p.item_cat,s.item_cat), 'Non liquor') AS CATEGORY,

MAX( t.item_scan_timestamp) max_item_scan_timestamp,
min( t.item_scan_timestamp) min_item_scan_timestamp,
 avg(t.day_hour_number) day_hour_number,
sum(t.total_basket_quantity) total_basket_quantity,
avg(t.total_basket_quantity) avg_basket_quantity,
sum(t.total_sales_amount) total_sales_amount,
avg(t.total_sales_amount) avg_sales_amount

FROM cedwdm.transaction_product_vw t,
     mmakosh1.liq_m3_cat_plu p,
     mmakosh1.liq_m3_cat_sku s
     WHERE  t.plu_key = p.plu_key (+)
AND   t.sku_key = s.sku_key (+)
AND t.group_loyalty_member_number IS NOT NULL
AND  t.TRANSACTION_DATE BETWEEN '31 Jul 2014' AND '31 Aug 2015'
group by t.group_loyalty_member_number, 
t.edw_business_brand_code,
t.gift_card_indicator,
 nvl(nvl(p.item_name,s.item_name), 'Non liquor') ,
nvl(nvl(p.item_cat,s.item_cat), 'Non liquor');

--Transaction table -all -trans level aggregated
SELECT t.group_loyalty_member_number, 
t.edw_business_brand_code,
t.gift_card_indicator,
MAX( to_date(t.LAST_item_scan_timestamp)) max_item_scan_timestamp,
min(to_date( t.LAST_item_scan_timestamp)) min_item_scan_timestamp,
 avg(t.day_hour_number) day_hour_number,
sum(t.total_basket_quantity) total_basket_quantity,
avg(t.total_basket_quantity) avg_basket_quantity,
sum(t.total_sales_amount) total_sales_amount,
avg(t.total_sales_amount) avg_sales_amount
FROM cedwdm.transaction_vw t
     WHERE   t.group_loyalty_member_number IS NOT NULL
AND  t.TRANSACTION_DATE BETWEEN '31 Jul 2014' AND '31 Aug 2015'
group by t.group_loyalty_member_number, 
t.edw_business_brand_code,
t.gift_card_indicator
;

--All Mbr
DROP TABLE FCO_LookAlike_AllMbr;
CREATE TABLE FCO_LookAlike_AllMbr COMPRESS FOR QUERY HIGH PCTFREE 0
AS
SELECT mbr_no, eshop_pts, fchoice_pts, fchoice_onl_pts, webjet_pts, total_partners_12m, liquorland_onl_pts, white_wine, red_wine, lifestage_high_name,number_of_under18,fchoice_bns_pts,coles_pts,liquorland_pts,liquorland_bns_pts,pre_mixed,
mosaic_desc, 'fco' as Mbr_group FROM fco_lookalike_fco
union
SELECT mbr_no, eshop_pts, fchoice_pts, fchoice_onl_pts, webjet_pts, total_partners_12m, liquorland_onl_pts, white_wine, red_wine, lifestage_high_name,number_of_under18,fchoice_bns_pts,coles_pts,liquorland_pts,liquorland_bns_pts,pre_mixed,
mosaic_desc, 'other' as Mbr_group FROM fco_lookalike_coleso
union
SELECT mbr_no, eshop_pts, fchoice_pts, fchoice_onl_pts, webjet_pts, total_partners_12m, liquorland_onl_pts, white_wine, red_wine, lifestage_high_name,number_of_under18,fchoice_bns_pts,coles_pts,liquorland_pts,liquorland_bns_pts,pre_mixed,
mosaic_desc, 'eshop' AS Mbr_group FROM fco_lookalike_eshop
union
SELECT mbr_no, eshop_pts, fchoice_pts, fchoice_onl_pts, webjet_pts, total_partners_12m, liquorland_onl_pts, white_wine, red_wine, lifestage_high_name,number_of_under18,fchoice_bns_pts,coles_pts,liquorland_pts,liquorland_bns_pts,pre_mixed,
mosaic_desc, 'llo' AS Mbr_group FROM fco_lookalike_llo
union
SELECT mbr_no, eshop_pts, fchoice_pts, fchoice_onl_pts, webjet_pts, total_partners_12m, liquorland_onl_pts, white_wine, red_wine, lifestage_high_name,number_of_under18,fchoice_bns_pts,coles_pts,liquorland_pts,liquorland_bns_pts,pre_mixed,
mosaic_desc, 'targeto' AS Mbr_group FROM fco_lookalike_targeto
union
SELECT mbr_no, eshop_pts, fchoice_pts, fchoice_onl_pts, webjet_pts, total_partners_12m, liquorland_onl_pts, white_wine, red_wine, lifestage_high_name,number_of_under18,fchoice_bns_pts,coles_pts,liquorland_pts,liquorland_bns_pts,pre_mixed,
mosaic_desc, 'webjet' AS Mbr_group FROM fco_lookalike_webjet
; 

--Adhoc 
SELECT count(*) FROM FCO_LookAlike_AllMbr;
select distinct lifestage_high_name from FCO_LookAlike_AllMbr;

SELECT avg(eshop_pts) eshop_pts, 
avg(fchoice_pts) fchoice_pts, 
avg(fchoice_onl_pts) fchoice_onl_pts, 
avg(webjet_pts) webjet_pts, 
avg(total_partners_12m) total_partners_12m, 
avg(liquorland_onl_pts) liquorland_onl_pts, 
avg(white_wine) white_wine, 
avg(red_wine) red_wine, 
avg(number_of_under18) number_of_under18, 
avg(fchoice_bns_pts) fchoice_bns_pts, 
avg(coles_pts) coles_pts, 
avg(liquorland_pts) liquorland_pts, 
avg(liquorland_bns_pts) liquorland_bns_pts, 
avg(pre_mixed) pre_mixed, 
SUM(CASE  WHEN mosaic_desc = 'I' THEN 1 ELSE 0 END) AS mosaic_I,
SUM(CASE  WHEN mosaic_desc = 'K' THEN 1 ELSE 0 END) AS mosaic_K,
SUM(CASE  WHEN mosaic_desc = 'D' THEN 1 ELSE 0 END) AS mosaic_D,
SUM(CASE  WHEN mosaic_desc = 'M' THEN 1 ELSE 0 END) AS mosaic_M,
SUM(CASE  WHEN mosaic_desc = 'J' THEN 1 ELSE 0 END) AS mosaic_J,
SUM(CASE  WHEN mosaic_desc = 'A' THEN 1 ELSE 0 END) AS mosaic_A,
SUM(CASE  WHEN mosaic_desc = 'B' THEN 1 ELSE 0 END) AS mosaic_B,
SUM(CASE  WHEN mosaic_desc = 'C' THEN 1 ELSE 0 END) AS mosaic_C,
SUM(CASE  WHEN mosaic_desc = 'F' THEN 1 ELSE 0 END) AS mosaic_F,
SUM(CASE  WHEN mosaic_desc = 'E' THEN 1 ELSE 0 END) AS mosaic_E,
SUM(CASE  WHEN mosaic_desc = 'H' THEN 1 ELSE 0 END) AS mosaic_H,
SUM(CASE  WHEN mosaic_desc = 'L' THEN 1 ELSE 0 END) AS mosaic_L,
SUM(CASE  WHEN mosaic_desc = 'G' THEN 1 ELSE 0 END) AS mosaic_G,

SUM(CASE  WHEN lifestage_high_name = 'A' THEN 1 ELSE 0 END) AS lifestage_high_name_A,
SUM(CASE  WHEN lifestage_high_name = 'B' THEN 1 ELSE 0 END) AS lifestage_high_name_B,
SUM(CASE  WHEN lifestage_high_name = 'C' THEN 1 ELSE 0 END) AS lifestage_high_name_C,
SUM(CASE  WHEN lifestage_high_name = 'D' THEN 1 ELSE 0 END) AS lifestage_high_name_D,
SUM(CASE  WHEN lifestage_high_name = 'E' THEN 1 ELSE 0 END) AS lifestage_high_name_E,
SUM(CASE  WHEN lifestage_high_name = 'F' THEN 1 ELSE 0 END) AS lifestage_high_name_F,

Mbr_group

FROM FCO_LookAlike_AllMbr
group by 
Mbr_group;