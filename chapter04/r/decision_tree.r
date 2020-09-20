library(tree)
data(iris)

# Dataset
sample <- iris[sample(nrow(iris)), ]
train <- sample[1:105, ]
test <- sample[106:150, ]

# Training
model <- tree(Species~., train)
summary(model)

plot(model)
text(model)

# Testing
pred <- predict(model, test[, -5], type = "class")
table(pred, test$Species)
