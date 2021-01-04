# Regular expression with gsub

gsub
?lapply


aa <- c("22,300","4,400,100")
k <- strsplit(aa,",")
l <- lapply(k,paste,collapse="")
num <- as.numeric(unlist(l))

as.numeric(gsub("[^0-9]","",aa)) # 숫자빼고 공백으로 바꿈 


# [0-9] 모든 숫자 중 1개 
# 
num
num[1];num[2]

# grep
# grep (Globally search a Regular Expression & Print)

char1 <- c('apple','Apple','APPLE','banana','grape')
grep('pp',char1) # pattern을 포함하고 있는 단어의 결과값의 위치를 반환

grepl('pp',char1) # logical
grep('pp',char1,value=T) # pattern을 포함하고 있는 문자열 반환
d
char2 <- c('apple','banana')
paste(char2,collapse="|")

grep('^A',char1,value=T)  #^을 사용하여 대문자 'A' 로 시작하는 단어 찾기 
char1[-1]

grep('e$',char1,value=T)  #$을 사용하여 소문자 'e' 로 끝나는 단어 찾기
char3 <- c('grape1','apple1','apple','orange','Apple','grape0')
grep('ap',char3,value=T)  #ap 가 포함된 단어 찾기
grep('[1-9]',char3,value=T)  #1~9사이숫자가 포함된 단어 찾기 
grep('[0-9]',char3,value=T)  #모든숫자중 어느 것이 포함된 단어 찾기 
grep('[[:upper:]]',char3,value=T)  #대문자가 포함된 단어 찾기
grep('[A-Z]',char3,value=T)  #대문자가 포함된 단어 찾기
grep('[A-z]',char3,value=T)  #영어가 포함된 모든 단어 찾기 small z 
# 모든 한글은 [ㄱ-힣] or [가-힣]


# Escape
# 약속된 언어를 지우는 역할 \
paste('I','m',"Hungry")
paste('I','\'m','Hungry')  #특수문자가 있을 경우 Escape character "\" 주의
paste("I'm","Hungry")

paste('I','\'m','hungry')

# regexpr(), gregexpr()
# 문자열에서 문자 위치 찾기
grep('-','010-8706-4712')  # grep으로는 위치를 찾을 수 없음.
regexpr('-','010-8706-4712')  # 처음 나오는 '-' 문자 위치 찾기 

# sub(), gsub()
# 문자열에서 문자 바꾸기
sub("l","p","alple") # substitute 대체하다 
gsub("p","*","apple") # global

library(e1071)

