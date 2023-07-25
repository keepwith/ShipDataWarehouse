cd C:/stata_learning
use cargo.dta,clear

drop 手机号 负责人 评价 操作 var17 var18

gen loaddate=装货日期
split loaddate,p(/)

gen createtime=创建时间
split createtime,p(" " / :)
rename createtime1 createyear
rename createtime2 createmonth
rename createtime3 createday
rename createtime4 createhour
rename createtime5 createminute

gen fromdock=起运地码头
split fromdock,p(" " - )
drop fromdock3
drop fromdock4
drop fromdock6
drop fromdock7
rename fromdock5 fromdock3 

gen todock=目的地码头
split todock,p(" " - )
drop todock3
drop todock4
drop todock6
rename todock5 todock3

gen highestprice=最高价
replace highestprice=subinstr(highestprice,"元/吨","",.)
replace highestprice=subinstr(highestprice,"未填写",".",.)
destring highestprice,replace

rename 货盘ID CargoID
tostring CargoID,replace
drop createhour
drop createminute

drop 装货日期
rename loaddate ShipmentDateKey
rename loaddate1 ShipmentYear
rename loaddate2 ShipmentMonth
rename loaddate3 ShipmentDay
gen ShipmentSeason="枯水期" if ShipmentMonth=="11"|ShipmentMonth=="12"|ShipmentMonth=="1"|    ///
							ShipmentMonth=="2"|ShipmentMonth=="3"
							
replace ShipmentSeason="汛期" if ShipmentMonth=="7"|ShipmentMonth=="8"				
replace ShipmentSeason="正常期" if ShipmentSeason==""

split createtime,p(" ")
drop createtime2
rename createtime1 CreateDateKey
rename createyear CreateYear
rename createmonth CreateMonth
rename createday CreateDay
gen CreateSeason="枯水期" if CreateMonth=="11"|CreateMonth=="12"|CreateMonth=="1"|    ///
							CreateMonth=="2"|CreateMonth=="3"
							
replace CreateSeason="汛期" if CreateMonth=="7"|CreateMonth=="8"				
replace CreateSeason="正常期" if CreateSeason==""

drop todock3 fromdock3
drop 最高价

rename 货物 CargoName
gen SubCategory=CargoName

gen Category="建筑材料" if CargoName=="水泥"|CargoName=="青沙"|CargoName=="黄沙"|      ///
                           CargoName=="水泥熟料"|CargoName=="碎石"|CargoName=="瓜子片"|      ///
						   CargoName=="卵石"|CargoName=="道渣"|CargoName=="石灰"|		///
						   CargoName=="毛石头"|CargoName=="毛石"|CargoName=="大理石"|		///
						   CargoName=="煤灰"|CargoName=="泥土"|CargoName=="水泥管桩"|		///
						   CargoName=="石膏板"|CargoName=="机制砂"|CargoName=="烘干沙"|		///
						   CargoName=="矿渣"|CargoName=="石粉"|CargoName=="炉渣"|		///
						   CargoName=="石粉"|CargoName=="炉渣"|CargoName=="瓷砖"|		///
						   CargoName=="窑泥"|CargoName=="渣土"|CargoName=="石子"
						   
replace Category="钢材"  if CargoName=="冷卷"|CargoName=="热卷"|CargoName=="线材"|		///
							CargoName=="盘螺"|CargoName=="螺纹钢"|CargoName=="钢筋"|	///
							CargoName=="钢板"|CargoName=="带钢"|CargoName=="角钢"|		///
							CargoName=="钢结构"|CargoName=="废铁"|CargoName=="卷板"|		///
							CargoName=="钢材"|CargoName=="废钢"|CargoName=="铁块"|		///
							CargoName=="钢角线"|CargoName=="型钢"|CargoName=="钢坯"
							
replace Category="木材及纸类" if CargoName=="方木"|CargoName=="圆木"|CargoName=="木片"|		///
								 CargoName=="纸浆"|CargoName=="卷筒纸"|CargoName=="废纸"|		///
								 CargoName=="木材"
								 
replace Category="粮食及饲料" if CargoName=="大米"|CargoName=="稻谷"|CargoName=="高粱"|		///
								 CargoName=="大麦"|CargoName=="大豆"|CargoName=="玉米"|		///
								 CargoName=="豆粕"|CargoName=="玉米粕"|CargoName=="小麦"
				
replace Category="化肥化工"  if CargoName=="钾肥"|CargoName=="复合肥"|CargoName=="碳铵"|	///
								CargoName=="硫酸铵"|CargoName=="磷肥"|CargoName=="轻碱"|	///
								CargoName=="塑料粒子"|CargoName=="散装二胺"|CargoName=="化肥"
								 
replace Category="矿类"   if CargoName=="硫酸亚铁"|CargoName=="钢渣"|CargoName=="石灰石/陶土"|			///
							 CargoName=="石膏粉"|CargoName=="石膏"|CargoName=="硫精砂"|		///
							 CargoName=="煤矸石"|CargoName=="矿粉"|CargoName=="硫磺"|		///
							 CargoName=="磷矿"|CargoName=="氧化铁"|CargoName=="铜精矿"|		///
							 CargoName=="铁矿"|CargoName=="矿"|CargoName=="钛矿"|			///
							 CargoName=="石英砂"|CargoName=="煤炭"|CargoName=="石油焦"|		///
							 CargoName=="盐巴"|CargoName=="尾矿"|CargoName=="水渣"|			///
							 CargoName=="黑渣"

replace Category="吨包"   if CargoName=="吨包化肥"|CargoName=="吨包矿"|CargoName=="吨袋"|	///
							 CargoName=="吨包碱"
							 
replace Category="液体"   if CargoName=="纯碱"|CargoName=="硫酸"
								 
replace Category="大件设备"   if CargoName=="钢管"|CargoName=="箱梁"|		///
								 CargoName=="机器设备"|CargoName=="大件物品"
								 
replace Category="其它"   if CargoName=="其它"

rename todock1 ArrivalProvince
rename todock2 ArrivalCityOrCounty
rename fromdock1 DepartureProvince
rename fromdock2 DepartureCityOrCounty

rename 吨位 CargoAmount
drop 装货日期
rename 是否过期 IsDue
drop 创建时间
drop createtime
rename 货盘状态 CargoState
split fromdock,p(-)
split todock,p(-)
drop 目的地码头 起运地码头
drop fromdock todock
drop fromdock2 fromdock3 fromdock4 todock2 
rename fromdock DepartureRegionKey
rename todock ArrivalRegionKey
replace DepartureRegionKey=substr(DepartureRegionKey,1,length(DepartureRegionKey)-1)
replace ArrivalRegionKey=substr(ArrivalRegionKey,1,length(ArrivalRegionKey)-1)

rename 报价 NumberOfQuote
replace NumberOfQuote=subinstr(NumberOfQuote,"暂无","0",.)
replace NumberOfQuote=subinstr(NumberOfQuote,"个报价","",.)

rename 封舱设备 SealRequirementKey

duplicates drop CargoID,force
duplicates drop CargoName,force
duplicates drop DepartureRegionKey,force
duplicates drop ArrivalRegionKey,force
duplicates drop SealRequirementKey,force
duplicates drop ShipmentDateKey,force
duplicates drop CreateDateKey,force

use DimArrivalRegion.dta,clear
replace ArrivalRegionKey=substr(ArrivalRegionKey,2,length(ArrivalRegionKey))
append using DimArrivalRegion1.dta
duplicates drop ArrivalRegionKey,force

append using DimCreateDate1.dta
append using DimCreateDate2.dta
duplicates drop CreateDateKey,force

rename DepartureProvice DepartureProvince
replace DepartureRegionKey=substr(DepartureRegionKey,1,length(DepartureRegionKey)-1)
append using DimDepartureRegion1.dta
append using DimDepartureRegion2.dta
duplicates drop DepartureRegionKey,force

append using DimShip1.dta
duplicates drop ShipID,force
duplicates drop ShipName,force

append using DimCargoCategory1.dta
duplicates drop CargoName,force

append using DimShipmentDate1.dta
duplicates drop ShipmentDateKey,force





