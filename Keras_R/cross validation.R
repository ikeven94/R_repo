### validation 

indices <- sample(1:nrow(data), 0.8*nrow(data))
training_data <- data[indices,] # train set
evaluation_data <- data[-indices,] # validation set

model <- get_model()
model %>% train(training_data)
validation_score <- model %>% evaluate(validation_data)

model <- get_model()
model %>%  train(data)
test_score <- model %>% evaluate(test_data)


### K-fold validation
indices <- sample(1:nrow(data))
folds <- cut(1:length(indices),breaks=k,labels=F)

validation_score <- c()
for(i in 1:k) {
  validaiton_indices <- which(folds=i,arr.ind=T)
  training_data <- data[-validaiontion_indices]
  validation_data <- data[validaiontion_indices]
  
  model <- get_model()
  model %>% train(training_data)
  results <- model %>% evaluate(validation_data)
  validation_score <- c(validation_scores, results$accuracy)
}
validation_score <- mean(validation_score)

model <- get_model()
model %>% train(data)
results <- model %>% evaluate(test_data)
