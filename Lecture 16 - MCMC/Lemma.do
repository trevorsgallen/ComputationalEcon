clear
set obs 10000000
generate x = invnormal(uniform())
generate y = x+invnormal(uniform())

regress x y
predict xgy , xb
predict err, xb

corr x y xgy err, cov
return list
matrix define temp = r(C)
local s_xx = temp[1,1]
local s_xy = temp[2,1]
local s_yy = temp[2,2]
local s_xgy = temp[3,3]

set trace on
di `s_xx'-`s_xy'*(`s_yy'^(-1))*`s_xy'
di `s_xgy'
