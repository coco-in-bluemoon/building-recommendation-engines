# Environment Setting
library(recommenderlab)
data(Jester5k)

model_data <- Jester5k[rowCounts(Jester5k) < 80]
model_data <- model_data[rowMeans(model_data) >= -5 & rowMeans(model_data) <= 7]
dim(model_data)

# Train and Test Data
set.seed(2020)
which_train <- sample(
    x = c(TRUE, FALSE),
    size = nrow(model_data),
    replace = TRUE,
    prob = c(0.8, 0.2)
)
model_data_train <- model_data[which_train, ]
model_data_test <- model_data[!which_train, ]
dim(model_data_train)
dim(model_data_test)

# Modeling
model_to_evaluate <- "IBCF"
model_parameters <- NULL

model_recommender <- Recommender(
    data = model_data_train,
    method = model_to_evaluate,
    parameter = model_parameters
)
model_recommender
model_details <- getModel(model_recommender)
str(model_details)

# Recommendation
item_to_recommend <- 10

model_prediction <- predict(
    object = model_recommender,
    newdata = model_data_test,
    n = item_to_recommend
)
model_prediction
model_prediction@items[[1]]

recc_user_1 <- model_prediction@items[[1]]
jokes_user_1 <- model_prediction@itemLabels[recc_user_1]
jokes_user_1

# Evaluation using k fold
n_fold <- 4
items_to_keep <- 15 # 추천 시 사용되는 최소 아이템 수
rating_threshold <- 3

eval_sets <- evaluationScheme(
    data = model_data,
    method = "cross-validation",
    k = n_fold,
    given = items_to_keep,
    goodRating = rating_threshold
)
eval_sets

model_to_evaluate <- "IBCF"
model_parameters <- NULL

eval_recommender <- Recommender(
    data = getData(eval_sets, "train"),
    method = model_to_evaluate,
    parameter = model_parameters
)

items_to_recommend <- 10
eval_prediction <- predict(
    object = eval_recommender,
    newdata = getData(eval_sets, "known"),
    n = item_to_recommend,
    type = "ratings"
)

eval_accuracy <- calcPredictionAccuracy(
    x = eval_prediction,
    data = getData(eval_sets, "unknown"),
    byUser = TRUE
)
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
columns_to_sum <- c("TP", "FP", "FN", "TN", "precision", "recall")
indices_summed <- Reduce("+", getConfusionMatrix(results))[, columns_to_sum]
indices_summed
plot(results, annotate = TRUE, main = "ROC curve")
plot(results, "prec/rec", annotate = TRUE, main = "Precision-Recall")


# Parameter Tuning
vector_k <- c(5, 10, 20, 30, 40)
model1 <- lapply(
    vector_k,
    function(k, l) {
        list(name = "IBCF", param = list(method = "cosine", k = k))
    }
)
names(model1) <- paste0("IBCF_cos_k", vector_k)
names(model1)

model2 <- lapply(
    vector_k,
    function(k, l) {
        list(name = "IBCF", param = list(method = "pearson", k = k))
    }
)
names(model2) <- paste0("IBCF_pea_k", vector_k)
names(model2)

models <- append(model1, model2)

n_recommendations <- c(1, 5, seq(10, 100, 10))
list_results <- evaluate(
    x = eval_sets,
    method = models,
    n = n_recommendations
)
plot(list_results, annotate = c(1, 2), legend = "topleft")
title("ROC curve")

plot(list_results, "prec/rec", annotate = 1, legend = "bottomright")
title("Precision-Recall")