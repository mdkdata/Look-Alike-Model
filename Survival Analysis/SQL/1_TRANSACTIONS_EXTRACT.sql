--==========basic table ===============
DROP TABLE FCO_LOOKALIKE_ALL;
create table FCO_LOOKALIKE_ALL compress for query high pctfree 0
as
SELECT a.GROUP_LOYALTY_MEMBER_NUMBER,
  SUBSTR(a.MOSAIC_DESC,1,3) as MOSAIC_DESC,
  NVL(SUBSTR(a.LIFESTAGE_HIGH_NAME,1,1),'G')as LIFESTAGE_HIGH_NAME,
  nvl(a.FES_Y,0.6) as FES_Y,
  NVL(a.AGE_BAND, '0-100') as AGE_BAND,
  nvl(a.OPENER_6M_ALL,'N') as OPENER_6M_ALL,
  A.SURV_RESP_WW,
  A.SURV_RESP_RW,
  A.SURV_RESP_SW,
  A.SURV_RESP_B,
  A.SURV_RESP_S,
  A.SURV_RESP_PM,
  a.SURV_RESP_NONE,
  case when C.MBR_GENDER = ' ' then 'N' else NVL(upper(C.MBR_GENDER), 'N') end as MBR_GENDER,
  NVL(C.CUSTOMER_AFFLUENCE, 'n/a') as CUSTOMER_AFFLUENCE,
  NVL(SUBSTR(C.POINTS_SEGMENT,1,1),1) as POINTS_SEGMENT,
  nvl(B.ONLINESHOPPING_YR, -1) as ONLINESHOPPING_YR,
  NVL(a.NO_TRANS, 0) as NO_TRANS,
  NVL(a.DAYS_SINCE_LAST_TRN, 366) DAYS_SINCE_LAST_TRN,
  nvl(a.TOTAL_SALES, 0) as TOTAL_SALES,
  a.SHOP_FC_ONLINE,
  nvl(a.LL_DT, 99) as LL_DT,
  NVL(a.FC_DT, 99) as FC_DT,
  
  NVL(BT.QUANTITY,0) as BEER_QTY,
  NVL(BT.SALES,0) as BEER_SALES,
  NVL(BT.TRANSACTIONS,0) as BEER_TRANS,
  cast(case when NVL(BT.TRANSACTIONS,0) <> 0 then NVL(BT.SALES,0)/NVL(BT.TRANSACTIONS,0)
  else 0 end as decimal(10,4)) as BEER_SALES_S,
  cast(case when NVL(BT.TRANSACTIONS,0) <> 0 then NVL(BT.QUANTITY,0)/NVL(BT.TRANSACTIONS,0)
  ELSE 0 END  as decimal(10,4)) AS BEER_QTY_S,
  
  NVL(WT.QUANTITY,0) as WINE_QTY,
  NVL(WT.SALES,0) as WINE_SALES,
  NVL(WT.TRANSACTIONS,0) as WINE_TRANS,
  cast(case when NVL(WT.TRANSACTIONS,0) <> 0 then NVL(WT.SALES,0)/NVL(WT.TRANSACTIONS,0)
  else 0 end  as decimal(10,4)) as WINE_SALES_S,
  cast(case when NVL(WT.TRANSACTIONS,0) <> 0 then NVL(WT.QUANTITY,0)/NVL(WT.TRANSACTIONS,0)
  else 0 end as decimal(10,4))  as WINE_QTY_S,
  
  NVL(ST.QUANTITY,0) as SPIRITS_QTY,
  NVL(ST.SALES,0) as SPIRITS_SALES,
  NVL(ST.TRANSACTIONS,0) as SPIRITS_TRANS,
  cast(case when NVL(ST.TRANSACTIONS,0) <> 0 then NVL(ST.SALES,0)/NVL(ST.TRANSACTIONS,0)
  else 0 end  as decimal(10,4)) as SPIRITS_SALES_S,
  cast(case when NVL(ST.TRANSACTIONS,0) <> 0 then NVL(ST.QUANTITY,0)/NVL(ST.TRANSACTIONS,0)
  else 0 end  as decimal(10,4)) as SPIRITS_QTY_S

FROM MMAKOSH1.LIQ_MBTB_VW a,
  COLESMKT.MEMBER_SURVEY_FLAT@COLESMKT.COLESMYER.COM.AU B,
  DMTEAM_WORK.ACTIVE_12M_MBR C,
  (select * from FCO_LOOKALIKE_TRANSACTION where ITEM_CAT = 'BEER') BT,
   (select * from FCO_LOOKALIKE_TRANSACTION where item_cat = 'WINE') wt,
    (select * from FCO_LOOKALIKE_TRANSACTION where ITEM_CAT = 'SPIRITS') ST
  
where a.GROUP_LOYALTY_MEMBER_NUMBER = B.GROUP_LOYALTY_MEMBER_NUMBER (+)
and a.GROUP_LOYALTY_MEMBER_NUMBER   = C.MBR_NO (+)
and a.GROUP_LOYALTY_MEMBER_NUMBER   = BT.GROUP_LOYALTY_MEMBER_NUMBER (+)
AND a.GROUP_LOYALTY_MEMBER_NUMBER   = Wt.GROUP_LOYALTY_MEMBER_NUMBER (+)
and a.GROUP_LOYALTY_MEMBER_NUMBER   = ST.GROUP_LOYALTY_MEMBER_NUMBER (+)
and a.mbr_emailable = 'Y';

--===============Complete dataset================
DROP TABLE FCO_LOOKALIKE_COMPLETE;
create table FCO_LOOKALIKE_COMPLETE compress for query high pctfree 0
as
select a.*,
case when LL.MBR_NO is not null then 'Y' else 'N' end as LL_CST,
case when FC.MBR_NO is not null then 'Y' else 'N' end as FC_CST,
case when LLO.MBR_NO is not null then 'Y' else 'N' end as LLO_CST,
case when (FCO.MBR_NO is not null OR SHOP_FC_ONLINE = 'Y') then 'Y' ELSE 'N' END AS FCO_CST
from FCO_LOOKALIKE_ALL a,
FCO_LOOKALIKE_LLO llo,
FCO_LOOKALIKE_FCO fco,
FCO_LOOKALIKE_FC fc,
FCO_LOOKALIKE_LL LL
where 
a.GROUP_LOYALTY_MEMBER_NUMBER = LLO.MBR_NO(+)
and a.GROUP_LOYALTY_MEMBER_NUMBER = fco.MBR_NO(+)
and a.GROUP_LOYALTY_MEMBER_NUMBER = ll.MBR_NO(+)
and a.GROUP_LOYALTY_MEMBER_NUMBER = fc.MBR_NO(+)
;

-- ================Imputation===============
select MBR_GENDER, COUNT(GROUP_LOYALTY_MEMBER_NUMBER) 
from FCO_LOOKALIKE_ALL  
group by MBR_GENDER;

-- ==========Transactions================
drop table FCO_SURVIVAL_TRANSACTION;
create table FCO_SURVIVAL_TRANSACTION compress for query high pctfree 0
as
select 
TRANSACTION_NUMBER, T.GROUP_LOYALTY_MEMBER_NUMBER, transaction_date,
count(distinct NVL(P.ITEM_CAT,S.ITEM_CAT)) as ITEM_CAT,
SUM(T.TOTAL_BASKET_QUANTITY) as QUANTITY,
SUM(T.TOTAL_SALES_AMOUNT) as SALES
from 
CEDWDM.TRANSACTION_PRODUCT_VW T,
MMAKOSH1.LIQ_M3_CAT_PLU P,
MMAKOSH1.LIQ_M3_CAT_SKU S
where
T.EDW_BUSINESS_BRAND_CODE in ('LL','1C')
and   t.transaction_date between '31 Aug 2014' and '29 Sep 2015'
and   T.PLU_KEY = P.PLU_KEY (+)
and   t.sku_key = s.sku_key (+)
and T.TOTAL_SALES_AMOUNT > 0
and T.TOTAL_BASKET_QUANTITY > 0
and NVL(P.ITEM_CAT,S.ITEM_CAT) in ('WINE', 'BEER', 'SPIRITS')
and GROUP_LOYALTY_MEMBER_NUMBER is not null
group by TRANSACTION_NUMBER, T.GROUP_LOYALTY_MEMBER_NUMBER, transaction_date;
      
       
--       select distinct EDW_BUSINESS_BRAND_CODE from CEDWDM.TRANSACTION_PRODUCT_VW
--       where transaction_date between '31 Aug 2015' and '29 Sep 2015';
       
       
       
       
       
       