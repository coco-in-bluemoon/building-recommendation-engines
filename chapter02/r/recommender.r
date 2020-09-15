library(reshape2)
library(data.table)
library(dplyr)

# 1. 데이터 로드 및 형식 변환하기
# 데이터 로드
ratings = read.csv('chapter02/data/movie_rating.csv')
# head(ratings)
# dim(ratings)
# str(ratings)

# 데이터 처리 및 형식 변환
movie_ratings = as.data.frame(acast(
    ratings, title~critic, value.var='rating'
))

# 2. 사용자 사이의 유사도 계산하기
# 유사도 계산
sim_users = cor(movie_ratings[, 1:6], use='complete.obs')
# sim_users
sim_users[colnames(sim_users) == 'Toby']

# 3. 사용자의 등급 예측하기
# 미지 값 예측하기
# Toby가 등급을 매기지 않은 영화 선정
rating_critic = setDT(movie_ratings[colnames(movie_ratings)[6]], keep.rownames=TRUE)[]
names(rating_critic) = c('title', 'rating')
titles_na_critic = rating_critic$title[is.na(rating_critic$rating)]
ratings_t = ratings[ratings$title %in% titles_na_critic, ]
ratings_t

# 각 사용자의 유사도 값을 새로운 변수로 추가
x = setDT(data.frame(sim_users[, 6]), keep.rownames=TRUE)[]
names(x) = c('critic', 'similarity')
ratings_t = merge(x=ratings_t, y=x, by='critic', all.x=TRUE)
ratings_t

# 등급과 유사도 값 곱하기
ratings_t$sim_rating = ratings_t$rating * ratings_t$similarity

# 4. 사용자 유사도 점수를 기반으로 사용자에게 아이템 추천하기
# 평가하지 않은 영화 추측
result = ratings_t %>% group_by(title) %>% summarise(sum(sim_rating) / sum(similarity))
names(result) = c('title', 'pred_rating')
result

# 추천 함수 생성
generateRecommendations <- function(userId) {
    rating_critic = setDT(movie_ratings[colnames(movie_ratings)[userId]], keep.rownames=TRUE)[]
    names(rating_critic) = c('title', 'rating')
    titles_na_critic = rating_critic$title[is.na(rating_critic$rating)]
    ratings_t = ratings[ratings$title %in% titles_na_critic,]
    x = (setDT(data.frame(sim_users[,userId]), keep.rownames=TRUE)[])
    names(x) = c('critic', 'similarity')
    ratings_t = merge(x=ratings_t, y=x, by='critic', all.x=TRUE)
    ratings_t$sim_rating = ratings_t$rating * ratings_t$similarity
    result = ratings_t %>% group_by(title) %>% summarise(sum(sim_rating)/sum(similarity))
    names(result) = c('title', 'pred_rating')
    return(result)
}

generateRecommendations(1)
generateRecommendations(3)
generateRecommendations(6)