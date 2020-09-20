# K Means Clustering
library(cluster)
data(iris)

iris$Species <- as.numeric(iris$Species)
kmeans <- kmeans(x = iris, centers = 5)
clusplot(
    iris,
    kmeans$cluster,
    color = TRUE,
    shade = TRUE,
    labels = 13,
    lines = 0
)

# Elbow Method
library(cluster)
library(ggplot2)
data(iris)

iris$Species <- as.numeric(iris$Species)
cost_df <- data.frame()
for (i in 1:100) {
    kmeans <- kmeans(x = iris, centers = i, iter.max = 50)
    cost_df <- rbind(cost_df, cbind(i, kmeans$tot.withinss))
}
names(cost_df) <- c("cluster", "cost")
cost_df

ggplot(data = cost_df, aes(x = cluster, y = cost, group = 1)) +
    theme_bw(base_family = "D2Coding") +
    geom_line(colour = "darkgreen") +
    theme(text = element_text(size = 10)) +
    ggtitle("Reduction in cost for values of 'k'\n") +
    xlab("Clusters") +
    ylab("Within-Cluster Sum of Sqarea\n")
