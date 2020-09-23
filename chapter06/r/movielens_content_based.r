# Read Rating
raw_data <- read.csv(
    "chapter06/data/ml-100k/u.data",
    sep = "\t", header = FALSE
)
colnames(raw_data) <- c("UserId", "MovieId", "Rating", "TimeStamp")
ratings <- raw_data[, 1:3]
head(ratings)

movies <- read.csv(
    "chapter06/data/ml-100k/u.item",
    sep = "|", header = FALSE
)

# Read Movie
colnames(movies) <- c(
    "MovieId", "MovieTitle", "ReleaseDate", "VideoReleaseDate",
    "IMDbURL", "Unknown", "Action", "Adventure", "Animation",
    "Children", "Comedy", "Crime", "Documentary", "Drama",
    "Fantasy", "FilmNoir", "Horror", "Musical", "Mystery",
    "Romance", "SciFi", "Thriller", "War", "Western"
)
movies <- movies[, -c(2:5)]
head(movies)

# Merge Rating and Movie
ratings <- merge(
    x = ratings,
    y = movies,
    by = "MovieId",
    all.x = TRUE
)
head(ratings)
names(ratings)

# Scale 5 Rating to Binary
nrat <- unlist(lapply(ratings$Rating, function(x) {
    if (x > 3) {
        return (1)
    }
    else {
        return (0)
    }
}))
ratings <- cbind(ratings, nrat)
head(ratings)

# EDA
apply(ratings[, -c(1:3, 23)], 2, function(x) table(x))

# Remove Unknown and Original Rating
scaled_ratings <- ratings[, -c(3, 4)]

# Scaling Rating
scaled_ratings <- scale(scaled_ratings[, -c(1, 2, 21)])
scaled_ratings <- cbind(scaled_ratings, ratings[, c(1, 2, 23)])
head(scaled_ratings)

# Train/Test Split
set.seed(7)
which_train <- sample(
    x = c(TRUE, FALSE),
    size = nrow(scaled_ratings),
    replace = TRUE,
    prob = c(0.8, 0.2)
)
model_data_train <- scaled_ratings[which_train, ]
model_data_test <- scaled_ratings[!which_train, ]

dim(model_data_train)
dim(model_data_test)

# Modeling: Random Forest
library(randomForest)
fit <- randomForest(
    as.factor(nrat)~.,
    data = model_data_train[, -c(19, 20)]
)
summary(fit)
fit

# Prediction
predictions <- predict(fit, model_data_test[, -c(19, 20, 21)], type = "class")
predictions[0:20]

cm <- table(predictions, model_data_test$nrat)
accuracy <- sum(diag(cm)) / sum(cm)
precision <- diag(cm) / rowSums(cm)
recall <- diag(cm) / colSums(cm)
accuracy
precision
recall

# Recommendation for User
total_movie_ids <- unique(movies$MovieId)
non_rated_movie_df <- function(user_id) {
    rated_movies <- raw_data[raw_data$UserId == user_id, ]$MovieId
    non_rated_movies <- total_movie_ids[!total_movie_ids %in% rated_movies]
    df <- data.frame(cbind(rep(user_id), non_rated_movies, 0))
    names(df) <- c("UserId", "MovieId", "Rating")
    return(df)
}
active_user_non_rated_movie_df <- non_rated_movie_df(943)
active_user_ratings <- merge(
    x = active_user_non_rated_movie_df,
    y = movies,
    by = "MovieId",
    all.x = TRUE
)
head(active_user_ratings)

predictions <- predict(fit, active_user_ratings[, -c(1:4)], type = "class")
recommendation <- data.frame(
    movieId = active_user_ratings$MovieId,
    predictions
)
recommendation <- recommendation[which(recommendation$predictions == 1), ]
head(recommendation)