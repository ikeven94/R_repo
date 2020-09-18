# Topic modeling examples

#install.packages("topicmodels")
#install.packages("RTextTools")

library(topicmodels)
data("AssociatedPress")

ap_lda <- LDA(AssociatedPress, k = 2, control = list(seed = 1234))
ap_lda

library(tidytext)

ap_topics <- tidy(ap_lda, matrix = "beta")
ap_topics

library(ggplot2)
library(dplyr)

ap_top_terms <- ap_topics %>%
  group_by(topic) %>%
  top_n(10, beta) %>%
  ungroup() %>%
  arrange(topic, -beta)

print(ap_top_terms[ap_top_terms$topic==1,])

ap_top_terms %>%
  mutate(term = reorder(term, beta)) %>%
  ggplot(aes(term, beta, fill = factor(topic))) +
  geom_col(show.legend = FALSE) +
  facet_wrap(~ topic, scales = "free") +
  coord_flip()

library(tidyr)

beta_spread <- ap_topics %>%
  mutate(topic = paste0("topic", topic)) %>%
  spread(topic, beta) %>%
  filter(topic1 > .001 | topic2 > .001) %>%
  mutate(log_ratio = log2(topic2 / topic1))

beta_spread %>%
  mutate(term = reorder(term, log_ratio)) %>%
  filter(log_ratio > 10.0 | log_ratio < -10.0) %>%
  ggplot(aes(term, log_ratio)) +
  geom_col(show.legend = FALSE) +
  coord_flip()

topics(ap_lda)



library(KoNLP)
useSejongDic()
library(rjson)

filepath = "/home/fantasm/Desktop/twitter/20140213230000-20140214000000.txt"
json_data = lapply(readLines(filepath), fromJSON)
only_text = c()
for(i in 1:length(json_data)){
  text = json_data[[i]]$text
  only_text[i] = text
}

only_noun = c()
l = 1
for(i in 1:100){
  if( nchar(only_text[i]) < 2 ){
    next
  }

  candi_noun = extractNoun(only_text[i])
  if( length(candi_noun) < 1){
    next
  }
  noun = c()
  k = 1
  for (j in 1:length(candi_noun)){
    token = gsub("[^ㄱ-힣]", "", candi_noun[j])
    if( nchar(token) >= 2){
      noun[k] = token
      k = k + 1
    }
  }
  if( length(noun) < 1){
    next
  }
  noun = paste(noun, collapse=' ')
  
  only_noun[l] = noun
  l = l+1
}

print(only_noun[1])

library(tm)

matrix <- create_matrix(only_noun, weighting=weightTf)
my_lda3 = LDA(matrix, 3)
my_lda5 = LDA(matrix, 5)
my_lda10 = LDA(matrix, 10)

my_lda = my_lda3


my_topics <- tidy(my_lda, matrix = "beta")
my_topics

my_top_terms <- my_topics %>%
  group_by(topic) %>%
  top_n(10, beta) %>%
  ungroup() %>%
  arrange(topic, -beta)

print(my_top_terms[my_top_terms$topic==1,])

my_top_terms %>%
  mutate(term = reorder(term, beta)) %>%
  ggplot(aes(term, beta, fill = factor(topic))) +
  geom_col(show.legend = FALSE) +
  facet_wrap(~ topic, scales = "free") +
  coord_flip()

library(tidyr)

my_beta_spread <- my_topics %>%
  mutate(topic = paste0("topic", topic)) %>%
  spread(topic, beta) %>%
  filter(topic1 > .001 | topic2 > .001) %>%
  mutate(log_ratio = log2(topic2 / topic1))

my_beta_spread

perplexity(my_lda3)
perplexity(my_lda5)
perplexity(my_lda10)

topics(my_lda)
