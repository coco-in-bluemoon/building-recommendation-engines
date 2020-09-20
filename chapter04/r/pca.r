data(USArrests)

# 분산(Variance) 확인
apply(USArrests, 2, var)

# PCA 차원 축소
pca <- prcomp(USArrests, scale = TRUE)
pca
names(pca)

pca$rotation <- -pca$rotation
pca$x <- -pca$x
biplot(pca, scale = 0)
