data("iris")
library(dplyr)
library(caret)

# Train and Test Dataset
iris2 <- sample_n(iris, 150)
train <- iris2[1:120, ]
test <- iris2[121:150, ]

# Training
cl <- train$Species
fit <- knn3(Species~., data = train, k = 3)
predictions <- predict(fit, test[, -5], type = "class")
table(predictions, test$Species)
