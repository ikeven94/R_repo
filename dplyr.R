# plyr

library(plyr)
x = data.frame(id=c(1,2,3,4,5), height=c(160,171,173,162,165))
y = data.frame(id=c(5,4,1,3,2), weight=c(55,73,60,57,80))

join(x,y,by='id')

# id height weight
# 1  1    160     60
# 2  2    171     80
# 3  3    173     57
# 4  4    162     73
# 5  5    165     55

### Left Join ###
x = data.frame(id=c(1,2,3,4,6), height=c(160,171,173,162,165))
y = data.frame(id=c(5,4,1,3,2), weight=c(55,73,60,57,80))
join(x,y,by='id')

# id height weight
# 1  1    160     60
# 2  2    171     80
# 3  3    173     57
# 4  4    162     73
# 5  6    165     NA

### Inner Join ###
x = data.frame(id=c(1,2,3,4,5), height=c(160,171,173,162,165))
y = data.frame(id=c(5,4,1,3,2), weight=c(55,73,60,57,80))
join(x,y,by='id',type='inner')

# id height weight
# 1  1    160     60
# 2  2    171     80
# 3  3    173     57
# 4  4    162     73
# 5  5    165     55

### Full Join ###
x = data.frame(id=c(1,2,3,4,6), height=c(160,171,173,162,165))
y = data.frame(id=c(5,4,1,3,2), weight=c(55,73,60,57,80))
join(x,y,by='id',type='full')

# id height weight
# 1  1    160     60
# 2  2    171     80
# 3  3    173     57
# 4  4    162     73
# 5  6    165     NA
# 6  5     NA     55


### merge with 2 key ###
x = data.frame(key1 = c(1,1,2,2,3),
               key2 = c('a','b','c','d','e'),
               val1 = c(10,20,30,40,50))

y = data.frame(key1 = c(3,3,2,1,1),
               key2 = c('e','d','c','b','a'),
               val2 = c(500, 400, 300, 200, 100))

join(x,y, by=c('key1','key2'))

# key1 key2 val1 val2
# 1    1    a   10  100
# 2    1    b   20  200
# 3    2    c   30  300
# 4    2    d   40   NA
# 5    3    e   50  500

### tapply ###
# 꽃의 종류별 꽃받침 길이 평균
tapply(iris$Sepal.Length, iris$Species,mean)

# tapply는 한개의 통계치, ddply는 여러개의 통계치 가능
ddply(iris,.(Species), summarise, avg=mean(Sepal.Length))

ddply(iris, .(Species),summarise, avg=round(mean(Sepal.Length),2),
                                  std=round(sd(Sepal.Length),2))


### dplyr ###
# 1. filter
# 2. arrange
# 3. select
# 4. mutate
# 5. summarise
# 6. groupby

library(dplyr)
library(hflights)
str(hflights)
hflights_df <- tbl_df(hflights)

# 조건 추출
filter(hflights,Month==1|Month==2)
# 정렬 (오름차순)
arrange(hflights_df, Year,Month,DepTime, ArrTime)
arrange(hflights_df,Year,Month,desc(DepTime),ArrTime)
# 검색
select(hflights_df,Year:ArrTime) #column 지정 범위
# 컬럼추가
mutate(hflights_df,gain=ArrDelay-DepDelay, gain_per_hour=gain/(AirTime/60)) %>% 
  select(Year,Month,ArrDelay,DepDelay,gain,gain_per_hour)
# 요약 통계치
summarise(hflights_df,avgAirTime = mean(AirTime,na.rm=TRUE))
summarise(hflights_df, cnt=n(), delay=mean(AirTime,na.rm=T)) # n() > 관측치 길이
summarise(hflights_df, arrTimesd = sd(AirTime,na.rm=T), arrTimeVar=var(AirTime,na.rm=T))
# 그룹화
species <- group_by(iris,Species)
str(species)














