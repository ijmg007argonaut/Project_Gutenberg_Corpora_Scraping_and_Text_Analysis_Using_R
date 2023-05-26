
install.packages(c("dplyr", "gutenbergr", "stringr", "tidytext", "tidyr",
                    "stopwords", "wordcloud", "rsample", "glmnet", 
                    "doMC", "forcats", "broom", "igraph", "ggraph", 
                    "RColorBrewer", "wordcloud2")) 

# 1. DATA IMPORT
cat("1. DATA IMPORT\n")
# Call needed libraries
library(gutenbergr)
library(dplyr)
library(dplyr)
library(tidytext)
# Import free corpora from Project Gutenberg after author search.
# Use two science authors and two science fiction authors.
# Experiments with Alternate Currents of High Potential and High Frequency by Nikola Tesla, Gutenberg ID: 13476.
# Relativity: The Special and General Theory by Albert Einstein, Gutenberg ID: 30155.
# A Journey to the Centre of the Earth by Jules Verne, Gutenberg ID: 18857.
# The Time Machine by H. G. Wells, Gutenberg ID: 35.
tesla <- gutenberg_download(c(13476), meta_fields = "author")
einstein <- gutenberg_download(c(30155), meta_fields = "author")
verne <- gutenberg_download(c(18857), meta_fields = "author")
wells <- gutenberg_download(c(35), meta_fields = "author")

# The gutenberg_download() function loads the book in R’s tabular tibble format, with each line from the book being read in as one row.
# Each tibble row contains corpus gutenberg ID, single row of text, author's name:
cat("TESLA:")
print(tesla)
cat("EINSTEIN:")
print(einstein)
cat("VERNE:")
print(verne)
cat("WELLS:")
print(wells)

# 2. DATA PROCESSING -TOKENIZATION
cat("2. DATA PROCESSING -TOKENIZATION\n")
# Use tidytext’s unnest_tokens() function to display one word (or observation) per row, remove punctuation and make all letters lowercase.
# Tidytext’s unnest_tokens() function gives each variable its own column, each observation its own row, and each value its own cell.
# Functions "group_by(word) %>% filter(n() > 10) %>% ungroup()" keep only words in the corpus dataset that occur more than 10 times.
# Use the "%>%" or "then" operator from the dplyr package to pipe the output of one function into the next.
tesla_words <- tesla %>% unnest_tokens(word, text) %>% group_by(word) %>% filter(n() > 10) %>% ungroup()
einstein_words <- einstein %>% unnest_tokens(word, text) %>% group_by(word) %>% filter(n() > 10) %>% ungroup()
verne_words <- verne %>% unnest_tokens(word, text) %>% group_by(word) %>% filter(n() > 10) %>% ungroup() 
wells_words <- wells %>% unnest_tokens(word, text) %>% group_by(word) %>% filter(n() > 10)  %>% ungroup()
cat("TESLA:")
print(tesla_words)
cat("EINSTEIN:")
print(einstein_words)
cat("VERNE:")
print(verne_words)
cat("WELLS:")
print(wells_words)

# 3. DATA PROCESSING - REMOVE STOP WORDS
cat("3. DATA PROCESSING - REMOVE STOP WORDS\n")
# Stop words are common words (“the”, “of”, “to”) that add nothing to the analysis
# Remove stop words using the list of english stop words ("en") provided in the package stopwords  
#   with an anti_join() function from the package dplyr.
library(stopwords) 
library(tibble)
stopword <- as_tibble(stopwords::stopwords("en")) # makes enlish stopword list into tibble
stopword <- rename(stopword, word=value) # change column name in stopword tibble from "value" to "word"
tesla_no_stopwords <- anti_join(tesla_words, stopword, by = 'word') # return words in tesla_words NOT FOUND in stopword's "word" column
einstein_no_stopwords <- anti_join(einstein_words, stopword, by = 'word') # return words in einstein_words NOT FOUND in stopword's "word" column
verne_no_stopwords <- anti_join(verne_words, stopword, by = 'word') # return words in verne_words NOT FOUND in stopword's "word" column
wells_no_stopwords <- anti_join(wells_words, stopword, by = 'word') # return words in wells_words NOT FOUND in stopword's "word" column
cat("TESLA:")
print(tesla_no_stopwords)
cat("EINSTEIN:")
print(einstein_no_stopwords)
cat("VERNE:")
print(verne_no_stopwords)
cat("WELLS:")
print(wells_no_stopwords)

# 4. EXPLORATORY DATA ANALYSIS - TERM OR WORD FREQUENCY
cat("4. EXPLORATORY DATA ANALYSIS - TERM OR WORD FREQUENCY\n")
tesla_count <- count(tesla_no_stopwords, word, sort = TRUE)
einstein_count <- count(einstein_no_stopwords, word, sort = TRUE)
verne_count <- count(verne_no_stopwords, word, sort = TRUE)
wells_count <- count(wells_no_stopwords, word, sort = TRUE)
cat("TESLA:")
print(tesla_count )
cat("EINSTEIN:")
print(einstein_count)
cat("VERNE:")
print(verne_count)
cat("WELLS:")
print(wells_count)

# 5. EXPLORATORY DATA ANALYSIS - TERM OR WORD FREQUENCY VISUALIZATION
cat("5. EXPLORATORY DATA ANALYSIS - TERM OR WORD FREQUENCY VISUALIZATION\n")
library(ggplot2)
tesla_top20 <- (ggplot(  top_n(tesla_count,20) %>% mutate(word = reorder(word, n)), 
                         aes(sort( word, decreasing = TRUE ), n))
      + geom_col(alpha = 0.8, show.legend = FALSE) 
      + coord_flip() + labs(title="Twenty Most frequent Words", 
                            subtitle="in Experiments with Alternate Currents of High Potential and High Frequency by Nikola Tesla",
                            x= "Word", 
                            y= "Word Count"))
print(tesla_top20)

einstein_top20 <- (ggplot(  top_n(einstein_count,20) %>% mutate(word = reorder(word, n)), 
                           aes(sort( word, decreasing = TRUE ), n))
                + geom_col(alpha = 0.8, show.legend = FALSE) 
                + coord_flip() + labs(title="Twenty Most frequent Words", 
                                      subtitle="in Relativity: The Special and General Theory by Albert Einstein",
                                      x= "Word", 
                                      y= "Word Count"))
print(einstein_top20)

verne_top20 <- (ggplot( top_n(verne_count,20) %>% mutate(word = reorder(word, n)), 
                        aes(sort( word, decreasing = TRUE ), n)) 
                + geom_col(alpha = 0.8, show.legend = FALSE) 
                + coord_flip() + labs(title="Twenty Most frequent Words", 
                                      subtitle="in A Journey to the Centre of the Earth by Jules Verne",
                                      x= "Word", 
                                      y= "Word Count"))
print(verne_top20)

wells_top20 <- (ggplot( top_n(wells_count,20) %>% mutate(word = reorder(word, n)), 
                        aes(sort( word, decreasing = TRUE ), n)) 
                + geom_col(alpha = 0.8, show.legend = FALSE) 
                + coord_flip() + labs(title="Twenty Most frequent Words", 
                                      subtitle="in The Time Machine by H.G. Wells",
                                      x= "Word", 
                                      y= "Word Count"))
print(wells_top20)

library(wordcloud)
library(RColorBrewer)
library(wordcloud2)
tesla_word <- wordcloud(words = tesla_count$word, freq = tesla_count$n, min.freq = 1, 
                        max.words=20, rot.per=0.45, random.order=TRUE, colors=brewer.pal(8, "Set1"))
einstein_word <- wordcloud(words = einstein_count$word, freq = einstein_count$n, min.freq = 1, 
                        max.words=20, rot.per=0.55, random.order=FALSE, colors=brewer.pal(8, "Dark2"))
verne_word <- wordcloud(words = verne_count$word, freq = verne_count$n, min.freq = 1, 
                        max.words=20, rot.per=0.35, random.order=TRUE, colors=brewer.pal(8, "Spectral"))
wells_word <- wordcloud(words = wells_count$word, freq = wells_count$n, min.freq = 1, 
                        max.words=20, rot.per=0.25, random.order=FALSE, colors=brewer.pal(8, "Accent"))