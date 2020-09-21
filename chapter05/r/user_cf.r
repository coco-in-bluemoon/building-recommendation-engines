library(recommenderlab)

# 사용 가능한 데이터
data_package <- data(package = "recommenderlab")
data_package$results[, c("Item", "Title")]

# Jester5k Load
data(Jester5k)
Jester5k
dim(Jester5k)

# EDA
## Distribution of Ratings
hist(
    getRatings(Jester5k),
    main = "Distribution of ratings"
)

# Distribution of Mean Ratings
table(rowCounts(Jester5k))
model_data <- Jester5k[rowCounts(Jester5k) < 80]
dim(model_data)
boxplot(rowMeans(model_data))
boxplot(
    rowMeans(
        model_data[rowMeans(model_data) >= -5 & rowMeans(model_data) <= 7]
    )
)

# Preprocess Dataset
model_data <- model_data[rowMeans(model_data) >= -5 & rowMeans(model_data) <= 7]
dim(model_data)
image(
    model_data[1:100, ],
    main = "Rating Distribution of 100 users"
)

# Modeling with Evaluation (k-fold): User Based CF
items_to_keep <- 30
rating_threshold <- 3
n_fold <- 5
precentage_training <- 0.8
eval_sets <- evaluationScheme(
    data = model_data,
    method = "cross-validation",
    train = precentage_training,
    given = items_to_keep,
    goodRating = rating_threshold,
    k = n_fold
)
eval_sets
getData(eval_sets, "train")
getData(eval_sets, "known")
getData(eval_sets, "unknown")

# Modeling
model_to_evaluate <- "UBCF"
model_parameters <- NULL

eval_recommender <- Recommender(
    data = getData(eval_sets, "train"),
    method = model_to_evaluate,
    parameter = model_parameters
)
eval_recommender

# Prediction
items_to_recommend <- 10
eval_prediction <- predict(
    object = eval_recommender,
    newdata = getData(eval_sets, "known"),
    n = items_to_recommend,
    type = "ratings"
)
eval_prediction

# Evaluation
eval_accuracy <- calcPredictionAccuracy(
    x = eval_prediction,
    data = getData(eval_sets, "unknown"),
    byUser = TRUE
)
head(eval_accuracy)
apply(eval_accuracy, 2, mean)

eval_accuracy <- calcPredictionAccuracy(
    x = eval_prediction,
    data = getData(eval_sets, "unknown"),
    byUser = FALSE
)
eval_accuracy

results <- evaluate(
    x = eval_sets,
    method = model_to_evaluate,
    n = seq(10, 100, 10)
)

head(getConfusionMatrix(results)[[1]])

columns_to_sum <- c("TP", "FP", "FN", "TN")
indices_summed <- Reduce("+", getConfusionMatrix(results))[, columns_to_sum]
indices_summed
plot(results, annotate = TRUE, main = "ROC curve")

############################################
# Modleing without Evaluation
# User Based CF Modeling
head(as(Jester5k, "matrix")[, 1:10])

## 1. Train Test Split
set.seed(1)
which_train <- sample(
    x = c(TRUE, FALSE),
    size = nrow(Jester5k),
    replace = TRUE,
    prob = c(0.8, 0.2)
)
rec_data_train <- Jester5k[which_train, ]
rec_data_test <- Jester5k[!which_train, ]
dim(rec_data_train)
dim(rec_data_test)

## 2. Modeling
recommender_models <- recommenderRegistry$get_entries(
    dataType = "realRatingMatrix"
)
names(recommender_models)
recommender_models

recc_model <- Recommender(
    data = rec_data_train,
    method = "UBCF"
)
recc_model

## 3. Prediction
n_recommended <- 10
recc_predicted <- predict(
    object = recc_model,
    newdata = rec_data_test,
    n = n_recommended
)
recc_predicted
rec_list <- sapply(
    recc_predicted@items,
    function(x) {
        colnames(Jester5k)[x]
    }
)
rec_list[100:101]
number_of_items <- sort(unlist(lapply(rec_list, length)), decreasing = TRUE)
table(number_of_items)
