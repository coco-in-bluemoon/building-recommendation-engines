library(gbm)
data(iris)

# Dataset
sample <- iris[sample(nrow(iris))]
train <- sample[1:105, ]
test <- sample[106:150, ]


# Training
model <- gbm(
    Species~.,
    data = train,
    distribution = "multinomial",
    n.trees = 5000,
    interaction.depth = 4
)
summary(model)

# Test
pred <- predict(model, newdata = test[, -5], n.trees = 5000)
p_pred <- apply(pred, 1, which.max)
table(p_pred, test$Species)
