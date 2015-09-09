/* STORE FC LOCATION 100 */
DROP TABLE FCO_LookAlike_FCStore_Loc;
create table FCO_LookAlike_FCStore_Loc compress for query high pctfree 0
as
select STORE_NO, storebrand, STATUS, X_COORD, Y_COORD from DATA_INTEL.ALL_LATEST_STORE_INFO
where (STATUS = 'Open'
or CLOSEDDATE between '31 Aug 2014' and '31 Aug 2015')
and STOREBRAND in ('1st Choice');

/* STORE LL LOCATION 690 */
DROP TABLE FCO_LookAlike_LLStore_Loc;
create table FCO_LookAlike_LLStore_Loc compress for query high pctfree 0
as
select STORE_NO, storebrand, STATUS, X_COORD, Y_COORD from DATA_INTEL.ALL_LATEST_STORE_INFO
where (STATUS = 'Open'
or CLOSEDDATE between '31 Aug 2014' and '31 Aug 2015')
and STOREBRAND in ('Liquorland');

/* STORE LQ LOCATION 7,548 */
DROP TABLE FCO_LookAlike_LQStore_Loc;
create table FCO_LookAlike_LQStore_Loc compress for query high pctfree 0
as
select STORE_NO, storebrand, STATUS, X_COORD, Y_COORD from DATA_INTEL.ALL_LATEST_STORE_INFO
where (STATUS = 'Open'
or CLOSEDDATE between '31 Aug 2014' and '31 Aug 2015')
and (UPPER(STOREBRAND) like '%LIQUOR%'
OR upper(STOREBRAND) like '%1ST CHOICE%');


/* MEMBER_LOCATION */
select a.mbr_no, B.LONGITUDE, b.latitude from DMTEAM_WORK.ACTIVE_12M_MBR a,
DATA_INTEL.SDB_C06_CCD_GEOG_LOOKUPS B
where a.ccd_number = B.CCD_2006 (+);

