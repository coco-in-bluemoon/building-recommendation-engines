library(randomForest)
data(iris)

# Dataset
sample <- iris[sample(nrow(iris)), ]
train <- sample[1:105, ]
test <- sample[106:150, ]

# Training
model <- randomForest(
    Species~.,
    data = train,
    mtry = 2,
    importance = TRUE,
    proximity = TRUE
)

# Test
pred <- predict(model, test[, -5])
table(pred, test$Species)
