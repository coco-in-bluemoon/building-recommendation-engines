# 1. Matrix Factorization using NMF

# Load Data
library(recommenderlab)
data("MovieLense")
dim(MovieLense)

mat <- as(MovieLense, "matrix")
mat[is.na(mat)] <- 0
# Because of Biobase not supported in R 4.0.2
# nmf() is nor working
res <- nmf(mat, 10)
res

r.hat <- fitted(res)
dim(r.hat)
p <- basis(res)
dim(p)
q <- coef(res)
dim(q)


# 2. Matrix Factorization using SVD

# Load Data
simpleMat <- function(n) {
    i <- 1:n;
    1 / outer(i-1, i, "+")
}

original.mat <- simpleMat(9)[, 1:6]
original.mat
s <- svd(original.mat)
D <- diag(s$d)
s$u %*% D %*% t(s$v)
