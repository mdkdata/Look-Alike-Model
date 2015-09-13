SELECT *
from
  (select Z.mbr_no,
    z.sa1_number AS mem_sal_code,
    x.store_name,
    x.storebrand,
    x.store_no,
    x.ciw_store_no,
    x.dt_mins,
    x.state,
    row_number() over (partition BY z.mbr_no, x.storebrand order by x.dt_mins ASC nulls last) AS row_num
  FROM dmteam_work.active_12m_mbr z,
    /*                --find all the DT for all the stores for each SA1*/
    (
    SELECT a.store_name,
      a.storebrand,
      a.store_no,
      a.ciw_store_no,
      a.state,
      b.sa1_code,
      b.dt_mins,
      b.store_key
    FROM DATA_INTEL.ALL_LATEST_STORE_INFO a,
      DATA_INTEL.GRAVITYMODEL_DT_SA1 b
    WHERE a.id        = b.store_id
    AND a.storebrand IN ('1st Choice','Liquorland','Liquorland Express','Liquorland Warehouse')
    AND (a.status     = 'Open'
    OR a.store_no     = '3848')
    ) x
  WHERE z.sa1_number = x.sa1_code(+)
  )
WHERE ROW_NUM = 1;


-- =========================
SELECT *
from
  (select Z.MBR_NO,
    x.dt_mins,
    row_number() over (partition BY z.mbr_no, x.storebrand order by x.dt_mins ASC nulls last) AS row_num
  FROM dmteam_work.active_12m_mbr z,
    /*                --find all the DT for all the stores for each SA1*/
    (
    SELECT a.store_name,
      a.storebrand,
      a.ciw_store_no,
      b.sa1_code,
      b.dt_mins
    FROM DATA_INTEL.ALL_LATEST_STORE_INFO a,
      DATA_INTEL.GRAVITYMODEL_DT_SA1 b
    WHERE a.id        = b.store_id
    AND a.storebrand IN ('1st Choice','Liquorland','Liquorland Express','Liquorland Warehouse')
    AND (a.status     = 'Open'
    OR a.store_no     = '3848')
    ) x
  WHERE z.sa1_number = x.sa1_code(+)
  )
where ROW_NUM = 1;


--==========================
create table FCO_LOOKALIKE_SA1_DT compress for query high pctfree 0
as
 SELECT a.store_name,
      a.storebrand,
      a.ciw_store_no,
      b.sa1_code,
      b.dt_mins
    FROM DATA_INTEL.ALL_LATEST_STORE_INFO a,
      DATA_INTEL.GRAVITYMODEL_DT_SA1 b
    WHERE a.id        = b.store_id
    AND a.storebrand IN ('1st Choice','Liquorland','Liquorland Express','Liquorland Warehouse')
    and (a.STATUS     = 'Open'
    OR a.store_no     = '3848');