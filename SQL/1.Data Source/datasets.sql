/* LL Online 3,679 */ 
DROP TABLE FCO_LookAlike_LLO;
create table FCO_LOOKALIKE_LLO compress for query high pctfree 0
as
select a.MBR_NO, a.MOSAIC, a.LIFESTAGE_HIGH_NAME, a.FES_SCORE_Y, a.MBR_AGE, a.MBR_GENDER, a.CUSTOMER_AFFLUENCE, a.POINTS_SEGMENT, B.ONLINESHOPPING_YR, B.PRE_MIXED, B.WHITE_WINE, B.RED_WINE, B.SPARKLING_WINE, B.SPIRITS, B.BEER, B.LIQUOR_NONE
,L.LONGITUDE, L.latitude
FROM dmteam_work.active_12m_mbr A,
COLESMKT.MEMBER_SURVEY_FLAT@COLESMKT.COLESMYER.COM.AU B
,DATA_INTEL.SDB_C06_CCD_GEOG_LOOKUPS L
where 
a.MBR_NO = B.GROUP_LOYALTY_MEMBER_NUMBER (+)
and a.LIQUORLAND_ONL_PTS>0
and a.CCD_NUMBER = L.CCD_2006 (+);


/* eShop 20,300 */
DROP TABLE FCO_LookAlike_eShop;
create table FCO_LOOKALIKE_ESHOP compress for query high pctfree 0
as
select a.mbr_no, a.mosaic, a.lifestage_high_name, a.fes_score_y, a.mbr_age, a.mbr_gender, a.customer_affluence, a.points_segment, b.onlineshopping_yr, b.pre_mixed, b.white_wine, b.red_wine, b.sparkling_wine, b.spirits, b.beer, b.liquor_none
,L.LONGITUDE, L.LATITUDE
FROM dmteam_work.active_12m_mbr A,
colesmkt.member_survey_flat@colesmkt.colesmyer.com.au b
,DATA_INTEL.SDB_C06_CCD_GEOG_LOOKUPS L
where 
a.MBR_NO = B.GROUP_LOYALTY_MEMBER_NUMBER (+)
and a.ESHOP_PTS>0
and a.CCD_NUMBER = L.CCD_2006 (+);


/* WebJet 116,543 */
DROP TABLE FCO_LookAlike_webjet;
create table FCO_LOOKALIKE_WEBJET compress for query high pctfree 0
as
select a.mbr_no, a.mosaic, a.lifestage_high_name, a.fes_score_y, a.mbr_age, a.mbr_gender, a.customer_affluence, a.points_segment, b.onlineshopping_yr, b.pre_mixed, b.white_wine, b.red_wine, b.sparkling_wine, b.spirits, b.beer, b.liquor_none
,L.LONGITUDE, L.LATITUDE
from DMTEAM_WORK.ACTIVE_12M_MBR a,
colesmkt.member_survey_flat@colesmkt.colesmyer.com.au b
,DATA_INTEL.SDB_C06_CCD_GEOG_LOOKUPS L
where 
a.MBR_NO = B.GROUP_LOYALTY_MEMBER_NUMBER (+)
and a.WEBJET_PTS>0
AND a.ccd_number = L.CCD_2006 (+);


/* Coles online 486,677 */
DROP TABLE FCO_LookAlike_CSO;
CREATE TABLE FCO_LookAlike_CSO COMPRESS FOR QUERY HIGH PCTFREE 0
AS
select a.mbr_no, a.mosaic, a.lifestage_high_name, a.fes_score_y, a.mbr_age, a.mbr_gender, a.customer_affluence, a.points_segment, b.onlineshopping_yr, b.pre_mixed, b.white_wine, b.red_wine, b.sparkling_wine, b.spirits, b.beer, b.liquor_none
,L.LONGITUDE, L.LATITUDE
FROM dmteam_work.active_12m_mbr A,
COLESMKT.MEMBER_SURVEY_FLAT@COLESMKT.COLESMYER.COM.AU B,
(SELECT distinct group_loyalty_member_number FROM cedwdm.transaction_vw WHERE POS_REGISTER_NUMBER=75) c
,DATA_INTEL.SDB_C06_CCD_GEOG_LOOKUPS L
where 
a.MBR_NO = B.GROUP_LOYALTY_MEMBER_NUMBER (+)
and a.MBR_NO = C.GROUP_LOYALTY_MEMBER_NUMBER
and a.CCD_NUMBER = L.CCD_2006 (+);


/* Target Online 419,624 */
DROP TABLE FCO_LookAlike_TargetO;
create table FCO_LOOKALIKE_TARGETO compress for query high pctfree 0
AS
select a.mbr_no, a.mosaic, a.lifestage_high_name, a.fes_score_y, a.mbr_age, a.mbr_gender, a.customer_affluence, a.points_segment, b.onlineshopping_yr, b.pre_mixed, b.white_wine, b.red_wine, b.sparkling_wine, b.spirits, b.beer, b.liquor_none
,L.LONGITUDE, L.LATITUDE
FROM dmteam_work.active_12m_mbr A,
colesmkt.member_survey_flat@colesmkt.colesmyer.com.au b,
(SELECT distinct group_loyalty_member_number FROM CEDWDM.transaction_vw 
where EDW_BUSINESS_BRAND_CODE = 'TG'
AND store_idnt = 5599) c
,DATA_INTEL.SDB_C06_CCD_GEOG_LOOKUPS L
where 
a.MBR_NO = B.GROUP_LOYALTY_MEMBER_NUMBER (+)
and a.MBR_NO = C.GROUP_LOYALTY_MEMBER_NUMBER
and a.CCD_NUMBER = L.CCD_2006 (+);


/* FC Online 12,356 */
DROP TABLE FCO_LookAlike_FCO;
create table FCO_LOOKALIKE_FCO compress for query high pctfree 0
as
select a.mbr_no, a.mosaic, a.lifestage_high_name, a.fes_score_y, a.mbr_age, a.mbr_gender, a.customer_affluence, a.points_segment, b.onlineshopping_yr, b.pre_mixed, b.white_wine, b.red_wine, b.sparkling_wine, b.spirits, b.beer, b.liquor_none
,L.LONGITUDE, L.LATITUDE
FROM dmteam_work.active_12m_mbr A,
colesmkt.member_survey_flat@colesmkt.colesmyer.com.au b
,DATA_INTEL.SDB_C06_CCD_GEOG_LOOKUPS L
where 
a.MBR_NO = B.GROUP_LOYALTY_MEMBER_NUMBER (+)
and a.FCHOICE_ONL_PTS>0
and a.CCD_NUMBER = L.CCD_2006 (+);


/* Other FC Liquor 1,394,574 */
DROP TABLE FCO_LookAlike_FC;
create table FCO_LookAlike_FC compress for query high pctfree 0
as
select a.mbr_no, a.mosaic, a.lifestage_high_name, a.fes_score_y, a.mbr_age, a.mbr_gender, a.customer_affluence, a.points_segment, b.onlineshopping_yr, b.pre_mixed, b.white_wine, b.red_wine, b.sparkling_wine, b.spirits, b.beer, b.liquor_none
,L.LONGITUDE, L.LATITUDE
FROM dmteam_work.active_12m_mbr A,
COLESMKT.MEMBER_SURVEY_FLAT@COLESMKT.COLESMYER.COM.AU B,
(select distinct GROUP_LOYALTY_MEMBER_NUMBER 
from MMAKOSH1.LIQ_MBTB_VW
where camp_tgt_brand IN ('FC','FC - DT','Both')
) c
,DATA_INTEL.SDB_C06_CCD_GEOG_LOOKUPS L
where 
a.MBR_NO = B.GROUP_LOYALTY_MEMBER_NUMBER (+)
and a.MBR_NO = C.GROUP_LOYALTY_MEMBER_NUMBER
and a.CCD_NUMBER = L.CCD_2006 (+);


/* Other LL Liquor 2,645,667 */
DROP TABLE FCO_LookAlike_LL;
create table FCO_LookAlike_LL compress for query high pctfree 0
as
select a.mbr_no, a.mosaic, a.lifestage_high_name, a.fes_score_y, a.mbr_age, a.mbr_gender, a.customer_affluence, a.points_segment, b.onlineshopping_yr, b.pre_mixed, b.white_wine, b.red_wine, b.sparkling_wine, b.spirits, b.beer, b.liquor_none
,L.LONGITUDE, L.LATITUDE
FROM dmteam_work.active_12m_mbr A,
COLESMKT.MEMBER_SURVEY_FLAT@COLESMKT.COLESMYER.COM.AU B,
(select distinct GROUP_LOYALTY_MEMBER_NUMBER 
from MMAKOSH1.LIQ_MBTB_VW
where camp_tgt_brand IN ('LL','LL - DT','Both')
) c
,DATA_INTEL.SDB_C06_CCD_GEOG_LOOKUPS L
where 
a.MBR_NO = B.GROUP_LOYALTY_MEMBER_NUMBER (+)
and a.MBR_NO = C.GROUP_LOYALTY_MEMBER_NUMBER
AND a.ccd_number = L.CCD_2006 (+);


/* ############# Store Dist ############## */
/* FC Online 12,356 */
DROP TABLE LookAlike_FCO;
create table LOOKALIKE_FCO compress for query high pctfree 0
as
select a.MBR_NO, a.MOSAIC, a.LIFESTAGE_HIGH_NAME, a.FES_SCORE_Y, a.MBR_AGE, a.MBR_GENDER, a.CUSTOMER_AFFLUENCE, a.POINTS_SEGMENT, B.ONLINESHOPPING_YR, B.PRE_MIXED, B.WHITE_WINE, B.RED_WINE, B.SPARKLING_WINE, B.SPIRITS, B.BEER, B.LIQUOR_NONE
,L.LONGITUDE, L.LATITUDE, LOC.FC_DT AS FC_DIST, LOC.LL_DT AS LL_DIST
FROM dmteam_work.active_12m_mbr A,
colesmkt.member_survey_flat@colesmkt.colesmyer.com.au b
,MMAKOSH1.LIQ_MBTB_VW LOC
,DATA_INTEL.SDB_C06_CCD_GEOG_LOOKUPS L
where 
a.MBR_NO = B.GROUP_LOYALTY_MEMBER_NUMBER (+)
and a.FCHOICE_ONL_PTS>0
and a.MBR_NO = LOC.GROUP_LOYALTY_MEMBER_NUMBER (+)
and a.CCD_NUMBER = L.CCD_2006 (+);


/* Other FC Liquor 1,394,574 */
DROP TABLE LookAlike_FC;
create table LookAlike_FC compress for query high pctfree 0
as
select a.mbr_no, a.mosaic, a.lifestage_high_name, a.fes_score_y, a.mbr_age, a.mbr_gender, a.customer_affluence, a.points_segment, b.onlineshopping_yr, b.pre_mixed, b.white_wine, b.red_wine, b.sparkling_wine, b.spirits, b.beer, b.liquor_none
,L.LONGITUDE, L.LATITUDE, LOC.FC_DT AS FC_DIST, LOC.LL_DT AS LL_DIST
FROM dmteam_work.active_12m_mbr A,
COLESMKT.MEMBER_SURVEY_FLAT@COLESMKT.COLESMYER.COM.AU B,
(select distinct GROUP_LOYALTY_MEMBER_NUMBER 
from MMAKOSH1.LIQ_MBTB_VW
where camp_tgt_brand IN ('FC','FC - DT','Both')
) c
,MMAKOSH1.LIQ_MBTB_VW LOC
,DATA_INTEL.SDB_C06_CCD_GEOG_LOOKUPS L
where 
a.MBR_NO = B.GROUP_LOYALTY_MEMBER_NUMBER (+)
and a.MBR_NO = C.GROUP_LOYALTY_MEMBER_NUMBER
and a.MBR_NO = LOC.GROUP_LOYALTY_MEMBER_NUMBER (+)
and a.CCD_NUMBER = L.CCD_2006 (+);


/* Other LL Liquor 2,645,667 */
DROP TABLE LookAlike_LL;
create table LookAlike_LL compress for query high pctfree 0
as
select a.mbr_no, a.mosaic, a.lifestage_high_name, a.fes_score_y, a.mbr_age, a.mbr_gender, a.customer_affluence, a.points_segment, b.onlineshopping_yr, b.pre_mixed, b.white_wine, b.red_wine, b.sparkling_wine, b.spirits, b.beer, b.liquor_none
,L.LONGITUDE, L.LATITUDE, LOC.FC_DT AS FC_DIST, LOC.LL_DT AS LL_DIST
FROM dmteam_work.active_12m_mbr A,
COLESMKT.MEMBER_SURVEY_FLAT@COLESMKT.COLESMYER.COM.AU B,
(select distinct GROUP_LOYALTY_MEMBER_NUMBER 
from MMAKOSH1.LIQ_MBTB_VW
where camp_tgt_brand IN ('LL','LL - DT','Both')
) c
,MMAKOSH1.LIQ_MBTB_VW LOC
,DATA_INTEL.SDB_C06_CCD_GEOG_LOOKUPS L
where 
a.MBR_NO = B.GROUP_LOYALTY_MEMBER_NUMBER (+)
and a.MBR_NO = C.GROUP_LOYALTY_MEMBER_NUMBER
and a.MBR_NO = LOC.GROUP_LOYALTY_MEMBER_NUMBER (+)
and a.CCD_NUMBER = L.CCD_2006 (+);



