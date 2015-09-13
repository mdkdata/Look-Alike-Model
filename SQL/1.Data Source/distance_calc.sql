/* LL Online 3,679 */ 
create table LOOKALIKE_LLO compress for query high pctfree 0
as
select MBR_NO, MOSAIC, LIFESTAGE_HIGH_NAME, FES_SCORE_Y, MBR_AGE, MBR_GENDER, CUSTOMER_AFFLUENCE, POINTS_SEGMENT, ONLINESHOPPING_YR, PRE_MIXED, WHITE_WINE, RED_WINE, SPARKLING_WINE, SPIRITS, BEER, LIQUOR_NONE
,LONGITUDE, latitude,FC_DIST, LL_DIST
from (
  select M.*,
  cast( SQRT( power(((M.LATITUDE - S.Y_COORD) * 111.1),2) + ( power( ((M.LONGITUDE - S.X_COORD) * 111.3 * COS(((M.LATITUDE + S.Y_COORD) / 2) * ACOS(-1) / 180)) ,2) ) ) as decimal(10,4))
  as LL_DIST,
  ROW_NUMBER() over (PARTITION BY M.MBR_NO
  order by cast( SQRT( power(((M.LATITUDE - S.Y_COORD) * 111.1),2) + ( power( ((M.LONGITUDE - S.X_COORD) * 111.3 * COS(((M.LATITUDE + S.Y_COORD) / 2) * ACOS(-1) / 180)) ,2) ) ) as decimal(10,4)) asc nulls last) as ROW_NUM
  from 
  (select MBR_NO, MOSAIC, LIFESTAGE_HIGH_NAME, FES_SCORE_Y, MBR_AGE, MBR_GENDER, CUSTOMER_AFFLUENCE, POINTS_SEGMENT, ONLINESHOPPING_YR, PRE_MIXED, WHITE_WINE, RED_WINE, SPARKLING_WINE, SPIRITS, BEER, LIQUOR_NONE
    ,LONGITUDE, latitude,FC_DIST
    from (
      select M.*,
      cast( SQRT( power(((M.LATITUDE - S.Y_COORD) * 111.1),2) + ( power( ((M.LONGITUDE - S.X_COORD) * 111.3 * COS(((M.LATITUDE + S.Y_COORD) / 2) * ACOS(-1) / 180)) ,2) ) ) as decimal(10,4))
      as FC_DIST,
      ROW_NUMBER() over (PARTITION BY M.MBR_NO
      order by cast( SQRT( power(((M.LATITUDE - S.Y_COORD) * 111.1),2) + ( power( ((M.LONGITUDE - S.X_COORD) * 111.3 * COS(((M.LATITUDE + S.Y_COORD) / 2) * ACOS(-1) / 180)) ,2) ) ) as decimal(10,4)) asc nulls last) as ROW_NUM
      from FCO_LOOKALIKE_LLO M,
      FCO_LOOKALIKE_FCSTORE_LOC S
    )
    where ROW_NUM = 1) M,
  FCO_LOOKALIKE_LLSTORE_LOC S
)
where ROW_NUM = 1;

/* eShop 20,300 */
create table LookAlike_eShop compress for query high pctfree 0 --change table name
as
select MBR_NO, MOSAIC, LIFESTAGE_HIGH_NAME, FES_SCORE_Y, MBR_AGE, MBR_GENDER, CUSTOMER_AFFLUENCE, POINTS_SEGMENT, ONLINESHOPPING_YR, PRE_MIXED, WHITE_WINE, RED_WINE, SPARKLING_WINE, SPIRITS, BEER, LIQUOR_NONE
,LONGITUDE, latitude,FC_DIST, LL_DIST
from (
  select M.*,
  cast( SQRT( power(((M.LATITUDE - S.Y_COORD) * 111.1),2) + ( power( ((M.LONGITUDE - S.X_COORD) * 111.3 * COS(((M.LATITUDE + S.Y_COORD) / 2) * ACOS(-1) / 180)) ,2) ) ) as decimal(10,4))
  as LL_DIST,
  ROW_NUMBER() over (PARTITION BY M.MBR_NO
  order by cast( SQRT( power(((M.LATITUDE - S.Y_COORD) * 111.1),2) + ( power( ((M.LONGITUDE - S.X_COORD) * 111.3 * COS(((M.LATITUDE + S.Y_COORD) / 2) * ACOS(-1) / 180)) ,2) ) ) as decimal(10,4)) asc nulls last) as ROW_NUM
  from 
  (select MBR_NO, MOSAIC, LIFESTAGE_HIGH_NAME, FES_SCORE_Y, MBR_AGE, MBR_GENDER, CUSTOMER_AFFLUENCE, POINTS_SEGMENT, ONLINESHOPPING_YR, PRE_MIXED, WHITE_WINE, RED_WINE, SPARKLING_WINE, SPIRITS, BEER, LIQUOR_NONE
    ,LONGITUDE, latitude,FC_DIST
    from (
      select M.*,
      cast( SQRT( power(((M.LATITUDE - S.Y_COORD) * 111.1),2) + ( power( ((M.LONGITUDE - S.X_COORD) * 111.3 * COS(((M.LATITUDE + S.Y_COORD) / 2) * ACOS(-1) / 180)) ,2) ) ) as decimal(10,4))
      as FC_DIST,
      ROW_NUMBER() over (PARTITION BY M.MBR_NO
      order by cast( SQRT( power(((M.LATITUDE - S.Y_COORD) * 111.1),2) + ( power( ((M.LONGITUDE - S.X_COORD) * 111.3 * COS(((M.LATITUDE + S.Y_COORD) / 2) * ACOS(-1) / 180)) ,2) ) ) as decimal(10,4)) asc nulls last) as ROW_NUM
      from FCO_LookAlike_eShop M, -- Change Dataset
      FCO_LOOKALIKE_FCSTORE_LOC S
    )
    where ROW_NUM = 1) M,
  FCO_LOOKALIKE_LLSTORE_LOC S
)
where ROW_NUM = 1;

/* WebJet 116,543 */
create table LookAlike_webjet compress for query high pctfree 0 --change table name
as
select MBR_NO, MOSAIC, LIFESTAGE_HIGH_NAME, FES_SCORE_Y, MBR_AGE, MBR_GENDER, CUSTOMER_AFFLUENCE, POINTS_SEGMENT, ONLINESHOPPING_YR, PRE_MIXED, WHITE_WINE, RED_WINE, SPARKLING_WINE, SPIRITS, BEER, LIQUOR_NONE
,LONGITUDE, latitude,FC_DIST, LL_DIST
from (
  select M.*,
  cast( SQRT( power(((M.LATITUDE - S.Y_COORD) * 111.1),2) + ( power( ((M.LONGITUDE - S.X_COORD) * 111.3 * COS(((M.LATITUDE + S.Y_COORD) / 2) * ACOS(-1) / 180)) ,2) ) ) as decimal(10,4))
  as LL_DIST,
  ROW_NUMBER() over (PARTITION BY M.MBR_NO
  order by cast( SQRT( power(((M.LATITUDE - S.Y_COORD) * 111.1),2) + ( power( ((M.LONGITUDE - S.X_COORD) * 111.3 * COS(((M.LATITUDE + S.Y_COORD) / 2) * ACOS(-1) / 180)) ,2) ) ) as decimal(10,4)) asc nulls last) as ROW_NUM
  from 
  (select MBR_NO, MOSAIC, LIFESTAGE_HIGH_NAME, FES_SCORE_Y, MBR_AGE, MBR_GENDER, CUSTOMER_AFFLUENCE, POINTS_SEGMENT, ONLINESHOPPING_YR, PRE_MIXED, WHITE_WINE, RED_WINE, SPARKLING_WINE, SPIRITS, BEER, LIQUOR_NONE
    ,LONGITUDE, latitude,FC_DIST
    from (
      select M.*,
      cast( SQRT( power(((M.LATITUDE - S.Y_COORD) * 111.1),2) + ( power( ((M.LONGITUDE - S.X_COORD) * 111.3 * COS(((M.LATITUDE + S.Y_COORD) / 2) * ACOS(-1) / 180)) ,2) ) ) as decimal(10,4))
      as FC_DIST,
      ROW_NUMBER() over (PARTITION BY M.MBR_NO
      order by cast( SQRT( power(((M.LATITUDE - S.Y_COORD) * 111.1),2) + ( power( ((M.LONGITUDE - S.X_COORD) * 111.3 * COS(((M.LATITUDE + S.Y_COORD) / 2) * ACOS(-1) / 180)) ,2) ) ) as decimal(10,4)) asc nulls last) as ROW_NUM
      from FCO_LookAlike_webjet M, -- Change Dataset
      FCO_LOOKALIKE_FCSTORE_LOC S
    )
    where ROW_NUM = 1) M,
  FCO_LOOKALIKE_LLSTORE_LOC S
)
where ROW_NUM = 1;

/* Coles online 486,677 */
create table LookAlike_CSO compress for query high pctfree 0 --change table name
as
select MBR_NO, MOSAIC, LIFESTAGE_HIGH_NAME, FES_SCORE_Y, MBR_AGE, MBR_GENDER, CUSTOMER_AFFLUENCE, POINTS_SEGMENT, ONLINESHOPPING_YR, PRE_MIXED, WHITE_WINE, RED_WINE, SPARKLING_WINE, SPIRITS, BEER, LIQUOR_NONE
,LONGITUDE, latitude,FC_DIST, LL_DIST
from (
  select M.*,
  cast( SQRT( power(((M.LATITUDE - S.Y_COORD) * 111.1),2) + ( power( ((M.LONGITUDE - S.X_COORD) * 111.3 * COS(((M.LATITUDE + S.Y_COORD) / 2) * ACOS(-1) / 180)) ,2) ) ) as decimal(10,4))
  as LL_DIST,
  ROW_NUMBER() over (PARTITION BY M.MBR_NO
  order by cast( SQRT( power(((M.LATITUDE - S.Y_COORD) * 111.1),2) + ( power( ((M.LONGITUDE - S.X_COORD) * 111.3 * COS(((M.LATITUDE + S.Y_COORD) / 2) * ACOS(-1) / 180)) ,2) ) ) as decimal(10,4)) asc nulls last) as ROW_NUM
  from 
  (select MBR_NO, MOSAIC, LIFESTAGE_HIGH_NAME, FES_SCORE_Y, MBR_AGE, MBR_GENDER, CUSTOMER_AFFLUENCE, POINTS_SEGMENT, ONLINESHOPPING_YR, PRE_MIXED, WHITE_WINE, RED_WINE, SPARKLING_WINE, SPIRITS, BEER, LIQUOR_NONE
    ,LONGITUDE, latitude,FC_DIST
    from (
      select M.*,
      cast( SQRT( power(((M.LATITUDE - S.Y_COORD) * 111.1),2) + ( power( ((M.LONGITUDE - S.X_COORD) * 111.3 * COS(((M.LATITUDE + S.Y_COORD) / 2) * ACOS(-1) / 180)) ,2) ) ) as decimal(10,4))
      as FC_DIST,
      ROW_NUMBER() over (PARTITION BY M.MBR_NO
      order by cast( SQRT( power(((M.LATITUDE - S.Y_COORD) * 111.1),2) + ( power( ((M.LONGITUDE - S.X_COORD) * 111.3 * COS(((M.LATITUDE + S.Y_COORD) / 2) * ACOS(-1) / 180)) ,2) ) ) as decimal(10,4)) asc nulls last) as ROW_NUM
      from FCO_LookAlike_CSO M, -- Change Dataset
      FCO_LOOKALIKE_FCSTORE_LOC S
    )
    where ROW_NUM = 1) M,
  FCO_LOOKALIKE_LLSTORE_LOC S
)
where ROW_NUM = 1;

/* FC Online 12,356 */
create table LookAlike_FCO compress for query high pctfree 0 --change table name
as
select MBR_NO, MOSAIC, LIFESTAGE_HIGH_NAME, FES_SCORE_Y, MBR_AGE, MBR_GENDER, CUSTOMER_AFFLUENCE, POINTS_SEGMENT, ONLINESHOPPING_YR, PRE_MIXED, WHITE_WINE, RED_WINE, SPARKLING_WINE, SPIRITS, BEER, LIQUOR_NONE
,LONGITUDE, latitude,FC_DIST, LL_DIST
from (
  select M.*,
  cast( SQRT( power(((M.LATITUDE - S.Y_COORD) * 111.1),2) + ( power( ((M.LONGITUDE - S.X_COORD) * 111.3 * COS(((M.LATITUDE + S.Y_COORD) / 2) * ACOS(-1) / 180)) ,2) ) ) as decimal(10,4))
  as LL_DIST,
  ROW_NUMBER() over (PARTITION BY M.MBR_NO
  order by cast( SQRT( power(((M.LATITUDE - S.Y_COORD) * 111.1),2) + ( power( ((M.LONGITUDE - S.X_COORD) * 111.3 * COS(((M.LATITUDE + S.Y_COORD) / 2) * ACOS(-1) / 180)) ,2) ) ) as decimal(10,4)) asc nulls last) as ROW_NUM
  from 
  (select MBR_NO, MOSAIC, LIFESTAGE_HIGH_NAME, FES_SCORE_Y, MBR_AGE, MBR_GENDER, CUSTOMER_AFFLUENCE, POINTS_SEGMENT, ONLINESHOPPING_YR, PRE_MIXED, WHITE_WINE, RED_WINE, SPARKLING_WINE, SPIRITS, BEER, LIQUOR_NONE
    ,LONGITUDE, latitude,FC_DIST
    from (
      select M.*,
      cast( SQRT( power(((M.LATITUDE - S.Y_COORD) * 111.1),2) + ( power( ((M.LONGITUDE - S.X_COORD) * 111.3 * COS(((M.LATITUDE + S.Y_COORD) / 2) * ACOS(-1) / 180)) ,2) ) ) as decimal(10,4))
      as FC_DIST,
      ROW_NUMBER() over (PARTITION BY M.MBR_NO
      order by cast( SQRT( power(((M.LATITUDE - S.Y_COORD) * 111.1),2) + ( power( ((M.LONGITUDE - S.X_COORD) * 111.3 * COS(((M.LATITUDE + S.Y_COORD) / 2) * ACOS(-1) / 180)) ,2) ) ) as decimal(10,4)) asc nulls last) as ROW_NUM
      from FCO_LookAlike_FCO M, -- Change Dataset
      FCO_LOOKALIKE_FCSTORE_LOC S
    )
    where ROW_NUM = 1) M,
  FCO_LOOKALIKE_LLSTORE_LOC S
)
where ROW_NUM = 1;

/* Target Online 419,624 */
create table LookAlike_TargetO compress for query high pctfree 0 --change table name
as
select MBR_NO, MOSAIC, LIFESTAGE_HIGH_NAME, FES_SCORE_Y, MBR_AGE, MBR_GENDER, CUSTOMER_AFFLUENCE, POINTS_SEGMENT, ONLINESHOPPING_YR, PRE_MIXED, WHITE_WINE, RED_WINE, SPARKLING_WINE, SPIRITS, BEER, LIQUOR_NONE
,LONGITUDE, latitude,FC_DIST, LL_DIST
from (
  select M.*,
  cast( SQRT( power(((M.LATITUDE - S.Y_COORD) * 111.1),2) + ( power( ((M.LONGITUDE - S.X_COORD) * 111.3 * COS(((M.LATITUDE + S.Y_COORD) / 2) * ACOS(-1) / 180)) ,2) ) ) as decimal(10,4))
  as LL_DIST,
  ROW_NUMBER() over (PARTITION BY M.MBR_NO
  order by cast( SQRT( power(((M.LATITUDE - S.Y_COORD) * 111.1),2) + ( power( ((M.LONGITUDE - S.X_COORD) * 111.3 * COS(((M.LATITUDE + S.Y_COORD) / 2) * ACOS(-1) / 180)) ,2) ) ) as decimal(10,4)) asc nulls last) as ROW_NUM
  from 
  (select MBR_NO, MOSAIC, LIFESTAGE_HIGH_NAME, FES_SCORE_Y, MBR_AGE, MBR_GENDER, CUSTOMER_AFFLUENCE, POINTS_SEGMENT, ONLINESHOPPING_YR, PRE_MIXED, WHITE_WINE, RED_WINE, SPARKLING_WINE, SPIRITS, BEER, LIQUOR_NONE
    ,LONGITUDE, latitude,FC_DIST
    from (
      select M.*,
      cast( SQRT( power(((M.LATITUDE - S.Y_COORD) * 111.1),2) + ( power( ((M.LONGITUDE - S.X_COORD) * 111.3 * COS(((M.LATITUDE + S.Y_COORD) / 2) * ACOS(-1) / 180)) ,2) ) ) as decimal(10,4))
      as FC_DIST,
      ROW_NUMBER() over (PARTITION BY M.MBR_NO
      order by cast( SQRT( power(((M.LATITUDE - S.Y_COORD) * 111.1),2) + ( power( ((M.LONGITUDE - S.X_COORD) * 111.3 * COS(((M.LATITUDE + S.Y_COORD) / 2) * ACOS(-1) / 180)) ,2) ) ) as decimal(10,4)) asc nulls last) as ROW_NUM
      from FCO_LookAlike_TargetO M, -- Change Dataset
      FCO_LOOKALIKE_FCSTORE_LOC S
    )
    where ROW_NUM = 1) M,
  FCO_LOOKALIKE_LLSTORE_LOC S
)
where ROW_NUM = 1;

/* Other FC Liquor 1,394,574 */
create table LookAlike_FC compress for query high pctfree 0 --change table name
as
select MBR_NO, MOSAIC, LIFESTAGE_HIGH_NAME, FES_SCORE_Y, MBR_AGE, MBR_GENDER, CUSTOMER_AFFLUENCE, POINTS_SEGMENT, ONLINESHOPPING_YR, PRE_MIXED, WHITE_WINE, RED_WINE, SPARKLING_WINE, SPIRITS, BEER, LIQUOR_NONE
,LONGITUDE, latitude,FC_DIST, LL_DIST
from (
  select M.*,
  cast( SQRT( power(((M.LATITUDE - S.Y_COORD) * 111.1),2) + ( power( ((M.LONGITUDE - S.X_COORD) * 111.3 * COS(((M.LATITUDE + S.Y_COORD) / 2) * ACOS(-1) / 180)) ,2) ) ) as decimal(10,4))
  as LL_DIST,
  ROW_NUMBER() over (PARTITION BY M.MBR_NO
  order by cast( SQRT( power(((M.LATITUDE - S.Y_COORD) * 111.1),2) + ( power( ((M.LONGITUDE - S.X_COORD) * 111.3 * COS(((M.LATITUDE + S.Y_COORD) / 2) * ACOS(-1) / 180)) ,2) ) ) as decimal(10,4)) asc nulls last) as ROW_NUM
  from 
  (select MBR_NO, MOSAIC, LIFESTAGE_HIGH_NAME, FES_SCORE_Y, MBR_AGE, MBR_GENDER, CUSTOMER_AFFLUENCE, POINTS_SEGMENT, ONLINESHOPPING_YR, PRE_MIXED, WHITE_WINE, RED_WINE, SPARKLING_WINE, SPIRITS, BEER, LIQUOR_NONE
    ,LONGITUDE, latitude,FC_DIST
    from (
      select M.*,
      cast( SQRT( power(((M.LATITUDE - S.Y_COORD) * 111.1),2) + ( power( ((M.LONGITUDE - S.X_COORD) * 111.3 * COS(((M.LATITUDE + S.Y_COORD) / 2) * ACOS(-1) / 180)) ,2) ) ) as decimal(10,4))
      as FC_DIST,
      ROW_NUMBER() over (PARTITION BY M.MBR_NO
      order by cast( SQRT( power(((M.LATITUDE - S.Y_COORD) * 111.1),2) + ( power( ((M.LONGITUDE - S.X_COORD) * 111.3 * COS(((M.LATITUDE + S.Y_COORD) / 2) * ACOS(-1) / 180)) ,2) ) ) as decimal(10,4)) asc nulls last) as ROW_NUM
      from FCO_LookAlike_FC M, -- Change Dataset
      FCO_LOOKALIKE_FCSTORE_LOC S
    )
    where ROW_NUM = 1) M,
  FCO_LOOKALIKE_LLSTORE_LOC S
)
where ROW_NUM = 1;

/* Other LL Liquor 2,645,667 */
create table LookAlike_LL compress for query high pctfree 0 --change table name
as
select MBR_NO, MOSAIC, LIFESTAGE_HIGH_NAME, FES_SCORE_Y, MBR_AGE, MBR_GENDER, CUSTOMER_AFFLUENCE, POINTS_SEGMENT, ONLINESHOPPING_YR, PRE_MIXED, WHITE_WINE, RED_WINE, SPARKLING_WINE, SPIRITS, BEER, LIQUOR_NONE
,LONGITUDE, latitude,FC_DIST, LL_DIST
from (
  select M.*,
  cast( SQRT( power(((M.LATITUDE - S.Y_COORD) * 111.1),2) + ( power( ((M.LONGITUDE - S.X_COORD) * 111.3 * COS(((M.LATITUDE + S.Y_COORD) / 2) * ACOS(-1) / 180)) ,2) ) ) as decimal(10,4))
  as LL_DIST,
  ROW_NUMBER() over (PARTITION BY M.MBR_NO
  order by cast( SQRT( power(((M.LATITUDE - S.Y_COORD) * 111.1),2) + ( power( ((M.LONGITUDE - S.X_COORD) * 111.3 * COS(((M.LATITUDE + S.Y_COORD) / 2) * ACOS(-1) / 180)) ,2) ) ) as decimal(10,4)) asc nulls last) as ROW_NUM
  from 
  (select MBR_NO, MOSAIC, LIFESTAGE_HIGH_NAME, FES_SCORE_Y, MBR_AGE, MBR_GENDER, CUSTOMER_AFFLUENCE, POINTS_SEGMENT, ONLINESHOPPING_YR, PRE_MIXED, WHITE_WINE, RED_WINE, SPARKLING_WINE, SPIRITS, BEER, LIQUOR_NONE
    ,LONGITUDE, latitude,FC_DIST
    from (
      select M.*,
      cast( SQRT( power(((M.LATITUDE - S.Y_COORD) * 111.1),2) + ( power( ((M.LONGITUDE - S.X_COORD) * 111.3 * COS(((M.LATITUDE + S.Y_COORD) / 2) * ACOS(-1) / 180)) ,2) ) ) as decimal(10,4))
      as FC_DIST,
      ROW_NUMBER() over (PARTITION BY M.MBR_NO
      order by cast( SQRT( power(((M.LATITUDE - S.Y_COORD) * 111.1),2) + ( power( ((M.LONGITUDE - S.X_COORD) * 111.3 * COS(((M.LATITUDE + S.Y_COORD) / 2) * ACOS(-1) / 180)) ,2) ) ) as decimal(10,4)) asc nulls last) as ROW_NUM
      from FCO_LookAlike_LL M, -- Change Dataset
      FCO_LOOKALIKE_FCSTORE_LOC S
    )
    where ROW_NUM = 1) M,
  FCO_LOOKALIKE_LLSTORE_LOC S
)
where ROW_NUM = 1;