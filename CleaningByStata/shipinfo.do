cd C:/stata_learning 
use shipschedule.dta
tostring 编号,replace
tostring mmsi,replace
drop 航线航行区域
drop 负责人userId
drop 下次沟通时间
drop 航线习惯
drop 货物偏好
drop 评价
drop 操作

replace 满载吨位=subinstr(满载吨位,"吨","",.)

gen createtime=添加时间
split createtime,p(" " / :)
rename createtime1 createyear
rename createtime2 createmonth
rename createtime3 createday
rename createtime4 createhour
rename createtime5 createminute

gen size=长x宽米
split size,p(x)
duplicates drop 所属船舶,force
