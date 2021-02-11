## Word level One Hot Encoding

samples <- c('The cat sat on the mat.','The dog ate my homework.')
token_index <- list()
for (sample in samples)
  for (word in strsplit(sample," ")[[1]])
    if (!word %in% names(token_index)) # token_index에 word가 없다면
      token_index[[word]] <- length(token_index) + 2
    max_length <- 10
    results <- array(0,dim = c(length(samples),
                               max_length,
                               max(as.integer(token_index))))



for (i in 1:length(samples)) {
  sample <- samples[[i]]
  words <- head(strsplit(sample," ")[[1]], n=max_length)
  
  for (j in 1:length(words)) {
    index <- token_index[[words[[j]]]]
    results[[i, j, index]] <- 1
  }
}    
    
results   

## word level One Hot encoding with Keras
library(keras)
samples <- c('The cat sat on the mat.','The dog ate my homework.')
tokenizer <- text_tokenizer(num_words = 1000) %>% #일반적인 1000개의 단어만 고려한 tokenizer 
  fit_text_tokenizer(samples)

# 문자열 -> 정수 인덱스 리스트
sequences <- texts_to_sequences(tokenizer,samples)
# [[1]]
# [1] 1 2 3 4 1 5
# 
# [[2]]
# [1] 1 6 7 8 9

one_hot_results <- texts_to_matrix(tokenizer, samples, mode='binary')
word_index <- tokenizer$word_index # 계산된 word index 복구

