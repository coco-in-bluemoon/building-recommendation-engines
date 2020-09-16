# 1. Eucldian Distance
x1 <- rnorm(30)
x2 <- rnorm(30)
euc_dist <- dist(rbind(x1, x2), method = "euclidian")
x1
x2
euc_dist


# 2. Cosine Similarity
library(lsa)
vec1 <- c(1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0)
vec2 <- c(0, 0, 1, 1, 1, 1, 1, 0, 1, 0, 0, 0)
cosine_similarity <- cosine(vec1, vec2)
cosine_similarity


# 3. Jaccard Similarity
library(clusteval)
vec1 <- c(1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0)
vec2 <- c(0, 0, 1, 1, 1, 1, 1, 0, 1, 0, 0, 0)
jaccard_similarity <- cluster_similarity(vec1, vec2, similarity = "jaccard")
jaccard_similarity


# 4. Pearson Correlation
cor(mtcars, method = "pearson")