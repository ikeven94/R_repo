## R review

# dplyr #
#########

library(ggplot2)
data(diamonds)
dim(head(diamonds))
# [1]  6 10

library(magrittr)
diamonds %>% head(., n=4) %>% dim()
# [1]  4 10
diamonds %>% .$price %>% .[1:10]
# [1] 326 326 327 334 335 336 336 337 337 338

library(dplyr)
diaTB <- as_tibble(diamonds[1:10, ]) # Tibble
diaDF <- as.data.frame(diamonds[1:10, ]) #Dataframe

# dataframe
diaDF$pri       # match
diaDF[,'pri']   # Error

# tibble은 열 이름 일부로 참조 불가 
# tibble
diaTB$pri       # NULL
diaTB[,'pri']   # Error

data(mtcars)
tb = as_tibble(mtcars)

tb[2:5,] # 2~5행
slice(tb,2:5)

tb %>%.[2:5,]
tb %>% slice(.,2:5)
tb %>% slice(c(2:3,4,5))

# tb$mpg 30 초과
tb[tb$mpg >30,]
filter(tb,mpg>30)
tb %>% filter(.,mpg > 30)
tb %>% filter(mpg > 30)

# 열 이름이나 번호로 부분참조
tb <- tb %>% slice(3:5)
tb[,c(1,3)] # 1,3열
select(tb,c(1,3))
tb %>% select(c(1,3))

tb[, c('cyl','hp')]
select(tb,c('cyl','hp'))
select(tb,c(cyl,hp))

# tb에서 4~7열 추출 
which(colnames(tb) == 'hp') # 4
which(colnames(tb) == 'qsec') # 7
tb[, which(colnames(tb) == 'hp'):which(colnames(tb) == 'qsec')]

tb %>% select(hp:qsec)
slice(tb, c(1,2))

tb3 <- tb %>% slice(1:3)
tb3

### 특정 조건 만족하는 열 이름 참조 
tb3 %>% select(starts_with('c')) # c로 시작하는 열
tb3 %>% select(starts_with('ca'))
tb3 %>% select(ends_with('p'))
tb3 %>% select(contains('c'))

coln <- c('drat','qsec')
# select 함수 내에서는 mpg는 열이름, mpg를 벡터로 쓴다면 one_of()
tb3 %>% select(one_of(coln))
# 2번째 문자가 s이거나 4개 문자로 이루어짐
tb3 %>% select(matches('^(.s|.{4})'))  

# dplyr vs 정규표현식
tb %>% select(starts_with('c'))
tb[, grep('^c',colnames(tb))]R

tb %>% select(ends_with('p'))
tb[, grep('p$',colnames(tb))]

tb %>% selelct(contains('c'))
tb[, grep('c',colnames('b'))]


### 특정 열 제외
tb %>% select(-cyl,-qsec)
tb %>% select(-c(cyl,qsec))

tb %>% select(-starts_with('c')) # c로 시작하는 열 제외
tb %>% select(-contains('c'))


### 새로운 열 추가
data(mtcars)
tb = as_tibble(mtcars)
tb2 <- tb %>% select(hp,cyl,qsec) %>% slice(1:3)
tb2 %>% mutate(hp/cyl)

tb2 %>% mutate(hpPerCyl = hp/cyl, V2 = hp*qsec)
tb2


