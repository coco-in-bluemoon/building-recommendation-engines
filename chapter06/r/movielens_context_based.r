# Import Data
raw_data <- read.csv(
    "chapter06/data/ml-100k/u.data",
    sep = "\t", header = FALSE
)
colnames(raw_data) = c("UserId", "MovieId", "Rating", "TimeStamp")

movies <- read.csv(
    "chapter06/data/ml-100k/u.item",
    sep = "|", header = FALSE
)
colnames(movies) <- c(
    "MovieId", "MovieTitle", "ReleaseDate", "VideoReleaseDate",
    "IMDbURL", "Unknown", "Action", "Adventure", "Animation",
    "Children", "Comedy", "Crime", "Documentary", "Drama",
    "Fantasy", "FilmNoir", "Horror", "Musical", "Mystery",
    "Romance", "SciFi", "Thriller", "War", "Western"
)
movies <- movies[, -c(2:5)]

ratings_ctx <- merge(
    x = raw_data,
    y = movies,
    by = "MovieId",
    all.x = TRUE
)

# Context Profile
ts <- ratings_ctx$TimeStamp
head(ts)
hours <- as.POSIXlt(ts, origin = "1960-10-01")$hour
head(hours)
ratings_ctx <- data.frame(cbind(ratings_ctx, hours))


# User Context Profile
ucp <- ratings_ctx[(ratings_ctx$UserId == 943), -c(2, 3, 4, 5)]
head(ucp)
ucp_pref <- aggregate(.~hours, ucp[, -1], sum)
head(ucp_pref)
ucp_pref_sc <- cbind(
    context = ucp_pref[, 1],
    t(apply(ucp_pref[, -1], 1, function(x) (x - min(x)) / (max(x) - min(x))))
)
head(ucp_pref_sc)
