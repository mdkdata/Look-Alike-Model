create table FCO_LOOKALIKE_GBM_RESULTS
(GROUP_LOYALTY_MEMBER_NUMBER varchar2(8),
N float,
Y float)
 compress for query high; 

select COUNT(a.GROUP_LOYALTY_MEMBER_NUMBER) from FCO_LOOKALIKE_GBM_RESULTS B,
Mmakosh1. liq_mbtb_vw A
where 
a.GROUP_LOYALTY_MEMBER_NUMBER = B.GROUP_LOYALTY_MEMBER_NUMBER
and B.Y >=0.08
and a.MBR_EMAILABLE = 'Y'
           and a.LIQ_FALLOW = 0
           and a.OPENER_6M = 'Y'
           and not(a.NO_TRANS = 0 and a.SURV_RESP_NONE = 1)
           and a.CAMP_TGT_BRAND in ('FC','FC - DT','Both')
           ;--AND fc_email_optout = 'N'