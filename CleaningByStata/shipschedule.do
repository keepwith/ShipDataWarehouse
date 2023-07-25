cd C:/stata_learning 
use shipschedule.dta,clear
tostring 船期ID,replace
split 吨位范围,p(-)
replace 吨位范围2=吨位范围1 if 吨位范围2==""
replace 吨位范围1=subinstr(吨位范围1,"吨","",.)
replace 吨位范围2=subinstr(吨位范围2,"吨","",.)
replace 停留天数=subinstr(停留天数,"天","",.)

split 航行计划,p(- " ")
drop 航行计划3 航行计划4
gen plan=航行计划
split plan,p("-")
split 空船日期,p(/)
split 创建时间,p(/)
gen 空船季度="正常" if 空船日期2==4 
drop 补充说明可滚动
drop 负责人userId 
drop 评价
drop 操作
merge m:1 所属船舶 using shipinfo.dta
drop _merge

gen EmptySeason="枯水期" if EmptyMonth=="11"|EmptyMonth=="12"|EmptyMonth=="1"|    ///
							EmptyMonth=="2"|EmptyMonth=="3"
							
replace EmptySeason="汛期" if EmptyMonth=="7"|EmptyMonth=="8"				
replace EmptySeason="正常期" if EmptySeason==""

gen CreateSeason="枯水期" if CreateMonth=="11"|CreateMonth=="12"|CreateMonth=="1"|    ///
							CreateMonth=="2"|CreateMonth=="3"
							
replace CreateSeason="汛期" if CreateMonth=="7"|CreateMonth=="8"				
replace CreateSeason="正常期" if CreateSeason==""

tostring ShipScheduleID,replace 
tostring mmsi,replace
tostring ShipID,replace

gen Load=MinimumScheduleCapacity if MinimumScheduleCapacity>MaximumScheduleCapacity
replace MinimumScheduleCapacity=MaximumScheduleCapacity if MinimumScheduleCapacity>MaximumScheduleCapacity

replace MaximumScheduleCapacity=Load if Load!=""
drop Load


