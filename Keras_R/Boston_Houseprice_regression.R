# Predict Boston House data set with Regression

library(keras)
dataset <- dataset_boston_housing()
c(c(train_data,train_targets),c(test_data,test_targets)) %<-% dataset

str(train_data) #404 개 train set / 13개의 numeric feature
#  num [1:404, 1:13] 1.2325 0.0218 4.8982 0.0396 3.6931 ...
str(test_data)

str(train_targets)
# num [1:404(1d)] 15.2 42.3 50 21.1 17.7 18.5 11.3 15.6 15.6 14.4 ...

## 데이터 정규화
mean <- apply(train_data,2,mean)
std <- apply(train_data,2,sd)
train_data <- scale(train_data, center=mean, scale=std)
test_data <- scale(test_data, center=mean, scale=std)


## 모델 정의

build_model <- function() {
  model <- keras_model_sequential() %>% 
    layer_dense(units = 64, activation = "relu", 
                input_shape = dim(train_data)[[2]]) %>% 
    layer_dense(units = 64, activation = "relu") %>% 
    layer_dense(units = 1) # 활성함수 없는 단일 계층 >> 선형 계층
  
  model %>% compile(
    optimizer = "rmsprop", 
    loss = "mse",  # loss function : mse for regression
    metrics = c("mae")# MAE : 평균절대오차
  )
}

## K-Fold Validation
k <- 4
indices <- sample(1:nrow(train_data))
folds <- cut(1:length(indices), breaks = k, labels = FALSE) 
num_epochs <- 100
all_scores <- c()

for (i in 1:k) {
  cat("processing fold #", i, "\n")
  # validation data
  val_indices <- which(folds == i, arr.ind = TRUE) 
  val_data <- train_data[val_indices,]
  val_targets <- train_targets[val_indices]
  
  # train data
  partial_train_data <- train_data[-val_indices,]
  partial_train_targets <- train_targets[-val_indices]
  
  # Build Keras model / Train the model 
  model <- build_model()
  model %>% fit(partial_train_data, partial_train_targets,
                epochs = num_epochs, batch_size = 1, verbose = 0)
  
  # Evaluate model on validation data
  results <- model %>% evaluate(val_data, val_targets, verbose = 0)
  all_scores <- c(all_scores, results['mae'])
}

all_scores
#     mae      mae      mae      mae 
# 1.945471 2.399976 2.637524 2.477696 


mean(all_scores) # [1] 2.365167 # 예측이 평균적으로 약 2316달러 차이


## 각 Fold에 log save
num_epochs <- 500
all_mae_histories <- NULL
for (i in 1:k) {
  cat("processing fold #", i, "\n")
  # validation data
  val_indices <- which(folds == i, arr.ind = TRUE) 
  val_data <- train_data[val_indices,]
  val_targets <- train_targets[val_indices]
  
  # train data
  partial_train_data <- train_data[-val_indices,]
  partial_train_targets <- train_targets[-val_indices]
  
  # Build Keras model / Train the model 
  model <- build_model()
  
  history <- model %>% fit(
    partial_train_data, partial_train_targets,
    validation_data = list(val_data,val_targets),
    epochs = num_epochs, batch_size = 1, verbose = 0)
  
  # Evaluate model on validation data
  mae_history <- history$metrics$val_mae
  all_mae_histories <- rbind(all_mae_histories,mae_history)
}


average_mae_history <- data.frame(
  epoch = seq(1:ncol(all_mae_histories)),
  validation_mae = apply(all_mae_histories,2,mean)
  
)

library(ggplot2)
ggplot(average_mae_history, aes(x=epoch, y=validation_mae))+geom_line()

ggplot(average_mae_history, aes(x=epoch, y=validation_mae))+geom_smooth()



## Final Model Training

model <- build_model()
model %>%  fit(train_data,train_targets,
               epochs=90, batch_size=16, verbose=0)
results <- model %>% evaluate(test_data,test_targets)

results
# loss       mae 
# 18.475622  2.747854 

# 아직 2747달러 정도 빗나간다.











