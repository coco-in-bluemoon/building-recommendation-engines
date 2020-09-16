import pandas as pd


# 1. load dataset
ratings = pd.read_csv('chapter02/data/movie_rating.csv')

movie_ratings = pd.pivot_table(
    ratings,
    values='rating',
    index='title',
    columns='critic'
)

# 2. calculate similarity
# for complete.all in R cor()
# movie_ratings = movie_ratings.dropna(axis=0)
sim_users = movie_ratings.corr(method='pearson')

# 3. Make Prediction & Recommendation
user_id = 2
ratings_critic = movie_ratings.loc[:, [movie_ratings.columns[2]]]
ratings_critic.columns = ['rating']
titles_na_critic = ratings_critic[pd.isna(ratings_critic.rating)].index

ratings_t = ratings.loc[ratings.title.isin(titles_na_critic)]
ratings_t = ratings_t.reset_index(drop=True)

x = sim_users[[sim_users.columns[2]]]
x.columns = ['similarity']
x = x.reset_index()

ratings_t = pd.merge(ratings_t, x, on='critic')
ratings_t.loc[:, 'sim_rating'] = ratings_t.rating * ratings_t.similarity

result = ratings_t.groupby('title').sum()
result.loc[:, 'prediction'] = result.sim_rating / result.similarity
result = result.drop(columns=['rating', 'sim_rating', 'similarity'])
print(result)
