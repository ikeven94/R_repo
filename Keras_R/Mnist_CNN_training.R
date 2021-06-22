# CH5 Deep Learning for Couputer Vision Processing

# Convolution Layer
library(keras)

model <- keras_model_sequential() %>% 
  layer_conv_2d(filters = 32, kernel_size=c(3,3), activation = "relu",
                input_shape= c(28,28,1)) %>% 
  layer_max_pooling_2d(pool_size = c(2,2)) %>% 
  layer_conv_2d(filters = 64, kernel_size = c(3,3), activation = "relu") %>% 
  layer_max_pooling_2d(pool_size = c(2,2)) %>% 
  layer_conv_2d(filters = 64, kernel_size = c(3,3), activation = "relu")

model

model <- model %>% 
  layer_flatten() %>% 
  layer_dense(units = 64, activation = "relu") %>% 
  layer_dense(units = 10, activation = "softmax") # 10 classification output

## MNISt number training

mnist <- dataset_mnist()
summary(mnist)
c(c(train_images,train_labels),c(test_images,test_labels)) %<-% mnist


train_images <- array_reshape(train_images, c(60000, 28, 28, 1))
train_images <- train_images/255 
test_images <- array_reshape(test_images, c(10000, 28, 28, 1))
test_images <- test_images/255

train_labels <- to_categorical(train_labels)
test_labels <- to_categorical(test_labels)

model %>% compile(
  optimizer ="rmsprop",
  loss = 'categorical_crossentropy',
  metrics = c('accuracy')
)

model %>% fit(
  train_images, train_labels,
  epochs = 5, batch_size=64
)

results <- model %>% evaluate(test_images, test_labels)
results


# Epoch 1/5
# 938/938 [==============================] - 37s 39ms/step - loss: 0.1708 - accuracy: 0.9473
# Epoch 2/5
# 938/938 [==============================] - 38s 41ms/step - loss: 0.0463 - accuracy: 0.9852
# Epoch 3/5
# 938/938 [==============================] - 38s 41ms/step - loss: 0.0318 - accuracy: 0.9901
# Epoch 4/5
# 938/938 [==============================] - 42s 45ms/step - loss: 0.0244 - accuracy: 0.9925
# Epoch 5/5
# 938/938 [==============================] - 40s 42ms/step - loss: 0.0197 - accuracy: 0.9937
