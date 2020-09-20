# Make Dataset
set.seed(0)
x1 <- rnorm(1000)
x2 <- rnorm(1000)
z <- 1 + 4 * x1 + 3 * x2
pr <- 1 / (1 + exp(-z))

y <- rbinom(1000, 1, pr)

# Training
df <- data.frame(
    y = y,
    x1 = x1,
    x2 = x2
)
glm(y~x1+x2, data = df, family = "binomial")
