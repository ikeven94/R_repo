# 영화 감상평 분류 : 이항 분류 예제 (Binary Classification) #
### 0은 부정 1은 긍정


#### 1. IMDB 데이터 셋

library(keras)
imdb <- dataset_imdb(num_words = 10000) # 출현 빈도 기준 상위 1만개 단어
str(imdb)


# 영어단어 복호화
c(c(train_data,train_labels),c(test_data,test_labels)) %<-% imdb # keras 패키지에서 이용가능한 다중 할당
 
str(train_data[[1]])
train_labels[[1]]

max(sapply(train_data,max)) #9999

word_index <- dataset_imdb_word_index()  # 단어 - 인덱스 번호
reverse_word_index <- names(word_index)
names(reverse_word_index) <- word_index  # 인덱스번호 - 단어
head(word_index)
head(reverse_word_index)

# 감상평 1개 복호화
train_data[[1]] 
decoded_review <- sapply(train_data[[1]],function(index){
  word <- if (index > 3)reverse_word_index[[as.character(index-3)]]
  if(!is.null(word)) word
  else "?"
})
decoded_review

#### 2. 신경망에 넣기 위한 데이터 변환

# 정수 sequence -> Binary Matrix로 부호화
vectorize_sequences <- function(sequences, dimension=10000) {
  results <- matrix(0,nrow = length(sequences),ncol = dimension) #(25000x10000) 0행렬
  for (i in length(sequences))
    results[i,sequences[[i]]] <- 1
  results
}

str(train_data) # train_data -> 제각각 길이가 다른25000개의 감상평

x_train <- vectorize_sequences(train_data) # 각 감상평 10000개를 이진화
x_test <- vectorize_sequences(test_data)
str(x_train[1,])

y_train <- as.numeric(train_labels)
y_test <- as.numeric(test_labels)

#### 3. 망 구축

### 3.1 모델 정의
model <- keras_model_sequential() %>% 
  layer_dense(units=16, activation='relu',input_shape =c(10000)) %>% 
  layer_dense(units=16, activation='relu') %>% 
  layer_dense(units=1, activation='sigmoid') 

### 3.2 모델 compile
model %>% compile(
  optimizer = 'rmsprop',
  loss ='binary_crossentropy',
  metrics = c('accuracy')
)
#######

### 3.3 최적화기 구성
model %>% compile(
  optimizer = optimizer_rmsprop(lr=0.001),
  loss ='binary_crossentropy',
  metrics = c('accuracy')
)

model %>% compile(
  optimizer = optimizer_rmsprop(lr=0.001),
  loss ='binary_crossentropy',
  metrics = metric_binary_accuracy  # 사용자 정의된 손실, 계량 사용
)
#######

### 3.4 validation set 설정
val_indices <- 1:10000

x_val <- x_train[val_indices,] # 기존 25000개중 10000개 (validation set)
partial_x_train <- x_train[-val_indices,] # 나머지 15000개
y_val <- y_train[val_indices]
partial_y_train <- y_train[-val_indices]

### 3.4 모델 Training

model %>% compile(
  optimizer = 'rmsprop',
  loss ='binary_crossentropy',
  metrics = c('accuracy')
)

history <- model %>% fit(
  partial_x_train,
  partial_y_train,
  epochs = 20,
  batch_size = 512,
  validation_data = list(x_val,y_val)
)

str(history)
# $ params :List of 3
# ..$ verbose: int 1
# ..$ epochs : int 20
# ..$ steps  : int 30
# $ metrics:List of 4
# ..$ loss        : num [1:20] 0.693 0.693 0.693 0.693 0.693 ...
# ..$ accuracy    : num [1:20] 0.504 0.504 0.504 0.504 0.504 ...
# ..$ val_loss    : num [1:20] 0.693 0.693 0.693 0.693 0.693 ...
# ..$ val_accuracy: num [1:20] 0.495 0.495 0.495 0.495 0.495 ...
# - attr(*, "class")= chr "keras_training_history"

plot(history)

#### 4. 모델 밑바닥부터 re-train

model <- keras_model_sequential() %>% 
  layer_dense(units=16, activation='relu',input_shape =c(10000)) %>% 
  layer_dense(units=16, activation='relu') %>% 
  layer_dense(units=1, activation='sigmoid') 

model %>% compile(
  optimizer = 'rmsprop',
  loss ='binary_crossentropy',
  metrics = c('accuracy')
)

model %>% fit(x_train, y_train, epochs=4, batch_size= 512)

results <- model %>% evaluate(x_test,y_test)
results

#### 5. 신규 데이터 예측
model %>% predict(x_test[1:10,])
