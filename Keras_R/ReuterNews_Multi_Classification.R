# 로이터 데이터셋 multi-class Classification

library(keras)
reuters <- dataset_reuters(num_words=10000)
c(c(train_data,train_labels),c(test_data,test_labels)) %<-% reuters

length(train_data) # 8982
length(test_data)  # 2246

train_data[1]

word_index <- dataset_reuters_word_index()
reverse_word_index <- names(word_index)
names(reverse_word_index) <- word_index

train_data[[1]]

# 뉴스를 다시 문장으로 복호화
decoded_newswire <- sapply(train_data[[1]], function(index) {
  word <- if (index >= 3) reverse_word_index[[as.character(index - 3)]]
  if (!is.null(word)) word 
  else "?"
})

train_labels

# 데이터 부호화
vectorize_sequences <- function(sequences, dimension = 10000) {
  results <- matrix(0, nrow = length(sequences), ncol = dimension)
  for (i in 1:length(sequences))
    results[i, sequences[[i]]] <- 1
  results
}
x_train <- vectorize_sequences(train_data)
x_test <- vectorize_sequences(test_data)

# one-hot-encoding
to_one_hot <- function(labels, dimension=46) { # 46개 class
  results <- matrix(0,nrow=length(labels), ncol=dimension)
  for (i in 1:length(labels))
    results[i,labels[[i]] + 1] <- 1
  results
}

one_hot_train_labels <- to_one_hot(train_labels)
one_hot_test_labels <- to_one_hot(test_labels)

one_hot_train_labels <- to_categorical(train_labels)
one_hot_test_labels <- to_categorical(test_labels)


# 모델 정의
model <- keras_model_sequential() %>% 
  layer_dense(units=64, activation = 'relu', input_shape=c(10000)) %>% 
  layer_dense(units=64, activation = 'relu') %>%
  layer_dense(units=46, activation = 'softmax')

model %>% compile(
  optimizer ='rmsprop',
  loss='categorical_crossentropy',
  metrics = c('accuracy')
)

# Validation Set
val_indices <- 1:1000
x_val <- x_train[val_indices,]
partial_x_train <- x_train[-val_indices,]
y_val <- one_hot_train_labels[val_indices,]
partial_y_train <- one_hot_train_labels[-val_indices,]

history <- model %>%  fit(
  partial_x_train,
  partial_y_train,
  epochs=20,
  batch_size=512,
  validation_data = list(x_val,y_val)
)
plot(history)
# 9 epoch 이후 overfitting

results <- model %>% evaluate(x_test,one_hot_test_labels)
results

# 모델 처음부터 re-train
model <- keras_model_sequential() %>% 
  layer_dense(units = 64, activation = 'relu', input_shape = c(10000)) %>% 
  layer_dense(units = 64, activation = 'relu') %>% 
  layer_dense(units = 46, activation = 'softmax')

model %>%  compile(
  optimizer = 'adam',
  loss = 'categorical_crossentropy',
  metrics = c('accuracy')
)

history <- model %>% fit(
  partial_x_train,
  partial_y_train,
  epochs = 9,
  batch_size = 512,
  validation_data = list(x_val,y_val)
)

results <- model %>% evaluate(x_test,one_hot_test_labels)
results
# > results
# loss  accuracy 
# 0.9728372 0.7902939

# 정확도 79%

test_labels_copy <- test_labels
test_labels_copy <- sample(test_labels_copy)
length(which(test_labels == test_labels_copy))/length(test_labels)
# [1] 0.1821015 (이항 분류 시 정확도)


predictions <- model %>% predict(x_test)
dim(predictions)
which.max(predictions[1,])











# validation accuracy ( 은닉 계층 1개일 경우)
4 > 0.70 (0.05 감소)
32 > 0.79
64 > 0.80
128 >  0.80


model <- keras_model_sequential() %>% 
  layer_dense(units = 64, activation = 'relu', input_shape = c(10000)) %>% 
  layer_dense(units = 128, activation = 'relu') %>% 
  layer_dense(units = 46, activation = 'softmax')

model %>%  compile(
  optimizer = 'adam',
  loss = 'categorical_crossentropy',
  metrics = c('accuracy')
)

history <- model %>% fit(
  partial_x_train,
  partial_y_train,
  epochs = 20,
  batch_size = 512,
  validation_data = list(x_val,y_val)
)



# validation accuracy ( 은닉 계층 2개일 경우)
4*4 > 0.64
16*16 > 0.64
32*32  > 0.78
64*64 > 0.80
128*128 > 0.80
128*64 > 0.80
# >> 일정 수준 이후에는 깊어져도 증가하지 않는다.

model <- keras_model_sequential() %>% 
  layer_dense(units = 64, activation = 'relu', input_shape = c(10000)) %>% 
  layer_dense(units = 16, activation = 'relu') %>%
  layer_dense(units = 32, activation = 'relu') %>% 
  layer_dense(units = 46, activation = 'softmax')

model %>%  compile(
  optimizer = 'adam',
  loss = 'categorical_crossentropy',
  metrics = c('accuracy')
)

history <- model %>% fit(
  partial_x_train,
  partial_y_train,
  epochs = 20,
  batch_size = 512,
  validation_data = list(x_val,y_val)
)




