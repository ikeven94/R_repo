install.packages('reshape')
library(reshape)

### reshape package
# 1. rename
# 2. reshape
# 3. melt / cast
# 4
###

path <- 'C:/Users/USER/R_repo/'
result <- read.csv('C:/Users/USER/R_repo/reshape.csv',header=F)
head(result)

### rename 
result <- rename(result, c(V1="total",V2="num1",V3="num2",V4="num3"))
data('Indometh')
str(Indometh)
# conc ~ time | Subject >> time과 subject에 의해 conc 분류

### reshape
Indometh
wide <-reshape(Indometh,
               v.name='conc',
               timevar ='time',idvar='Subject',
               direction='wide')
reshape(wide,direction = 'long')

### melt
smiths
#      subject time age weight height
# 1 John Smith    1  33     90   1.87
# 2 Mary Smith    1  NA     NA   1.54


melt(smiths, id=c('subject','time')) # id : 기준변수 / meaured : 측정변수
melt(smiths, id=c('subject','time'),meaured=c('age'))
#      subject time variable value
# 1 John Smith    1      age 33.00
# 2 Mary Smith    1      age    NA
# 3 John Smith    1   weight 90.00
# 4 Mary Smith    1   weight    NA
# 5 John Smith    1   height  1.87
# 6 Mary Smith    1   height  1.54

melt(smiths, id=1:2,na.rm=T) # 기준변수를 1,2로 

### cast

# subject와 time (기준변수)을 이용한 측정변수 분류 
cast(smithsm, subject+time ~variable)








### reshape2 package
# 1. 