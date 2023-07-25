CD C:/stata_learning 
use Deal.dta,clear
drop 货盘是否交保证金 双方是否通过电话 操作
tostring 订单ID,replace
rename 所属船舶 ShipName
merge m:1 ShipName using DimShip.dta
drop if _merge==1|_merge==2
drop _merge
rename 订单ID DealID
rename 货主 NickName
merge m:1 NickName using CargoOwner.dta
drop _merge
duplicates drop DealID,force

rename 装货日期 ShipmentDateKey
gen Shipment=ShipmentDateKey
split Shipment,p(/)
rename Shipment1 ShipmentYear
rename Shipment2 ShipmentMonth
rename Shipment3 ShipmentDay

gen ShipmentSeason="枯水期" if ShipmentMonth=="11"|ShipmentMonth=="12"|ShipmentMonth=="1"|    ///
							ShipmentMonth=="2"|ShipmentMonth=="3"
							
replace ShipmentSeason="汛期" if ShipmentMonth=="7"|ShipmentMonth=="8"				
replace ShipmentSeason="正常期" if ShipmentSeason==""

drop Shipment

split 起运地,p(" ")
drop 起运地3
replace 起运地=subinstr(起运地,"起运地","",.)
replace 起运地=substr(起运地,1,length(起运地)-1)

replace 满载吨位=subinstr(满载吨位,"吨","",.)
tab1 满载吨位 MaximumLoadCapacity if 满载吨位!=MaximumLoadCapacity
drop if 满载吨位!=MaximumLoadCapacity
drop 满载吨位

replace 货物吨位=subinstr(货物吨位,"吨","",.)
rename 货物吨位 CargoAmount

rename 起运地 DepartureRegionKey
rename 起运地1 DepartureProvice
rename 起运地2 DepartureCityOrCounty

drop 船东 

rename 订单状态 DealState

rename 订单更新日期 CreateDateKey
split CreateDateKey,p(/)
rename CreateDateKey1 CreateYear
rename CreateDateKey2 CreateMonth
rename CreateDateKey3 CreateDay
gen CreateSeason="枯水期" if CreateMonth=="11"|CreateMonth=="12"|CreateMonth=="1"|    ///
							CreateMonth=="2"|CreateMonth=="3"
							
replace CreateSeason="汛期" if CreateMonth=="7"|CreateMonth=="8"				
replace CreateSeason="正常期" if CreateSeason==""

split 货物名称,p( ( ) )
drop 货物名称
rename 货物名称2 CargoID
rename 货物名称1 CargoName
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
								 
duplicates drop CargoName,force
duplicates drop ShipmentDateKey,force
duplicates drop UserID,force
duplicates drop ShipID,force						 
duplicates drop CreateDateKey,force						 
duplicates drop DepartureRegionKey,force					 
