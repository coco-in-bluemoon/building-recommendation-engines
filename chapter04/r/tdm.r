library(tm)
data(crude)

tdm <- TermDocumentMatrix(
    crude,
    control = list(
        weight = function(x) weightTfIdf(x, normalize = TRUE),
        stopwords = TRUE
    )
)
inspect(tdm)