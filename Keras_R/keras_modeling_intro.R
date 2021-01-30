install.packages('keras')
install.packages('tensorflow')
library(keras)
library(tensorflow)

install_keras()
# install_keras(tensorflow='gpu') >> gpu가 있는 경우 에만
install_tensorflow()

use_condaenv("r-tensorflow")

mnist <- dataset_mnist()


# keras mnist data set
train_images <- mnist$train$x
train_labels <- mnist$train$y
test_images <- mnist$test$x
test_labels <- mnist$test$y

str(train_images)
# int [1:60000, 1:28, 1:28] # 6만개의 28x28 차원 데이터 ====
str(train_labels)
# int [1:60000(1d)] 5 0 4 1 9 2 1 3 1 4 ..

str(test_images) 
# int [1:10000, 1:28, 1:28] 0 0 0 0 0 0 0 0 0 0 ...
str(test_labels)
# int [1:10000, 1:28, 1:28] 0 0 0 0 0 0 0 0 0 0 ...


## model composing
network <- keras_model_sequential() %>% 
  layer_dense(units = 512, activation='relu',input_shape=c(28 * 28)) %>% 
  layer_dense(units = 10, activation = 'softmax')

## model compilie
network %>% compile(
  optimizer = "rmsprop",
  loss = "categorical_crossentropy",
  metrics=c('accuracy')
)

## With same API (functional API)

input_tensor <- layer_input(shape=c(784)) #28*28
output_tensor <- input_tensor %>% 
  layer_dense(units=32, activation = 'relu') %>% 
  layer_dense(units=10, activation= 'softmax')

model <- keras_model(inputs = input_tensor,outputs=output_tensor)

model %>% compile(
  optimizer = optimizer_rmsprop(lr=0.0001),
  loss = 'mse',
  metrics=c('accuracy')
)

model %>% fit(input_tensor, target_tensor, batch_size =128, epochs=10)
