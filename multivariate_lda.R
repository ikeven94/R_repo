hemo = read.table("C:/전공 자료/T11-8.DAT")
head(hemo)
names(hemo)= c("group","x1","x2")
# group 1이 정상 그룹으로  pch가 16인 속이 찬 원 
pch.vec = (hemo[,1]-2)*(-15)+1
plot(hemo[,2:3],pch=pch.vec,xlim=c(-0.7,0.4),ylim=c(-0.4,0.4))

hemo[hemo$group==1,2]
mean(hemo[hemo$group==1,2])
# group1의 평균 표본 벡터(파) # 속 찬원 쪽
# group1인것중 2열(x1열)을 뽑겠다 
(mean1 = c(mean(hemo[hemo$group==1,2]),mean(hemo[hemo$group==1,3])))
points(x=mean1[1],y=mean1[2],pch=4, cex=1.4, col="blue")

# group2의 평균 표본 벡터(파) # 속 빈원 쪽
(mean2 = c(mean(hemo[hemo$group==2,2]),mean(hemo[hemo$group==2,3])))
points(x=mean2[1],y=mean2[2],pch=4, cex=1.4, col="blue")

# 분류 필요한 새로운 관측값
points(x=-0.210,y=-0.044,pch=8,cex=1.4,col="red")

require(MASS)
(lda.obj = lda(group ~ x1+x2, data= hemo, prior =c(0.5,0.5)))
l.vec = lda.obj$scaling # 열벡터 l
m = (lda.obj$means[1,]%*%l.vec + lda.obj$means[2,]%*%l.vec)/2 #m

# 직선 식 = l[1]x1 + l[2]x2 -m =0 / 기울기 = -l[1]/l[2] , 절편 = m/l[2]
abline(a=m/l.vec[2], b=-l.vec[1]/l.vec[2],col=3)


# 소속 모집단 모르는 새로운 관측값 분류 (predict함수 이용 )
lda.obj = lda(group ~ x1+x2, data= hemo, prior =c(0.5,0.5))
newdata = data.frame(-0.210,y=-0.044)
names(newdata) = c("x1","x2")
predict(lda.obj,newdata)
# 결과 1group에 속하고 사후 확률은 0.56,0.43