--webjet
SELECT count(*) FROM active_12m_mbr WHERE webjet_pts>0;   --116,490

--eShop
/*members who earnt points from eShop (but 3 month lagged)*/
SELECT count(*) FROM active_12m_mbr WHERE eshop_pts>0; --19,227
/*members who made purchase via eshop*/
SELECT count(*) FROM IT.PENDING_TRANSACTIONS@colesmkt.colesmyer.com.au; --104,322
/*members who logged-in eShop and explore around different online retail*/
SELECT count(DISTINCT SUBSTR(card_number,7,8)) FROM IT.eshops_web_capture_view@colesmkt.colesmyer.com.au; --953,523

--liquor online
SELECT count(*) FROM active_12m_mbr WHERE LIQUORLAND_ONL_PTS>0; --3,648

--Coles online transactions
SELECT count(distinct group_loyalty_member_number) FROM cedwdm.transaction_vw WHERE POS_REGISTER_NUMBER=75; --494,160

--survey information
SELECT * FROM colesmkt.member_survey_flat@colesmkt.colesmyer.com.au where onlineshopping_yr>0; --DISTINCT onlineshopping_yr

--first choice online
SELECT * FROM dmteam_work.active_12m_mbr WHERE FCHOICE_ONL_PTS>0; --12,356
-- FCO, Online transactions
SELECT count(distinct flybuys_card_no) FROM mlightow.core_web_sales_12m_vw where edw_business_brand_code IN ('1C'); --11,866
--SELECT * FROM mlightow.core_web_sales_12m_trans_vw ;
--SELECT * FROM mlightow.core_web_sales_072012_format ;

--Target Online
SELECT * FROM CEDWDM.transaction_vw 
WHERE edw_business_brand_code = 'TG'
AND store_idnt = 5599;

--Active 12m Customers
select * from ACTIVE_12M_MBR@COLESMKT.COLESMYER.COM.AU;


/* Select ALL Candidates excluded FCO in last 12m */
SELECT * FROM
active_12m_mbr m,
colesmkt.member_survey_flat@colesmkt.colesmyer.com.au s
WHERE m.mbr_no = s.group_loyalty_member_number (+)
AND 
(m.webjet_pts>0 --webjet
OR m.eshop_pts>0 --eshop
OR m.LIQUORLAND_ONL_PTS>0 --LL online
or m.mbr_no in (SELECT distinct group_loyalty_member_number FROM cedwdm.transaction_vw WHERE POS_REGISTER_NUMBER=75) --Coles online
)
AND m.mbr_no NOT IN (SELECT mbr_no FROM active_12m_mbr WHERE FCHOICE_ONL_PTS>0) --exclude FCO customers
--AND
--(                                                 -- members must:
--                m.mbr_emailable = 'Y'                             -- be emailable 
--                and liq_fallow = 0                                -- be non liquor fallow (liquor control group)
--                and opener_6m = 'Y'                               -- have opened an email within the past six months
--                and not(NO_TRANS = 0 and SURV_RESP_NONE = 1)      -- 
--                and camp_tgt_brand in ('LL','LL - DT','Both')     -- 
--                and ll_email_optout = 'N'                         -- not opted out of First Choice emails
--                and a.group_loyalty_member_number not in ('40553553','46017019','30999484','30117101','30280688','60167892','33025413','78853396','32785619',
--                                                          '46573644','37331066','64945357','41199815','46314658','31888975','30117138','42061562','40767649','48097714','30406110','40009521','34242219',
--                                                          '31531440','30589557','88656924','49756243','49762747','49755196','80417822','49759793','49759918','30736071','49759740','33354826','49761628',
--                                                          '41888130','48473681','36197386','30623439','48152696','32016251','48421742','49759947','40778615','41244868','49369488','32179257','49761190',
--                                                          '46185137','49749466','48182812','49102878','48446781','48106477','62394458','48888627','68479911','62834340','61904211','46929798','20534828',
--                                                          '46208978')  --Exclude due to beacon trial.
--               )
;




