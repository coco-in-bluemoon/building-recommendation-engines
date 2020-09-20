library(MASS)
data("Boston")

# Make train and test dataset
set.seed(0)
which_train <- sample(
    x = c(TRUE, FALSE),
    size = nrow(Boston),
    replace = TRUE,
    prob = c(0.8, 0.2)
)
train <- Boston[which_train, ]
test <- Boston[!which_train, ]

# Training
lm_fit <- lm(medv~., data = train)
summary(lm_fit)

# Prediction
pred <- predict(lm_fit, test[, -14])
error <- mean((pred - test[, 14]) ** 2)
error
