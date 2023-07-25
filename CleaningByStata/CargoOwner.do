cd C:/stata_learning 
use CargoOwner.dta,clear
tostring 订单ID,replace
rename 货主 NickName
rename 订单ID DealID
rename UID UserID
tostring UserID,replace
