import pandas as pd

# 1. Load Dataset
ratings = pd.read_csv('chapter02/data/movie_rating.csv')

# 2. Calculate Similairty between critics
movie_rating = pd.pivot_table(
    data=ratings,
    values='rating',
    index='title',
    columns='critic'
)

sim_users = movie_rating.corr()

rating_critic = movie_rating.loc[:, [movie_rating.columns[5]]]
rating_critic.columns = ['rating']
titles_na_critic = rating_critic[pd.isna(rating_critic.rating)].index
ratings_t = ratings.loc[ratings.title.isin(titles_na_critic)]
ratings_t = ratings_t.reset_index(drop=True)

# 3. Calculate Prediction
x = sim_users[sim_users.columns[5]]
x = x.reset_index()
x.columns = ['critic', 'similarity']

ratings_t = pd.merge(left=ratings_t, right=x, on='critic')
ratings_t.loc[:, 'sim_rating'] = ratings_t.rating * ratings_t.similarity

# 4. Make Recommendations
result = ratings_t.groupby(by='title').sum()
result.loc[:, 'pred_rating'] = result.sim_rating / result.similarity
result = result.drop(columns=['rating', 'similarity', 'sim_rating'])


def generate_recommendation(user_id):
    rating_critic = movie_rating.loc[:, [movie_rating.columns[user_id]]]
    rating_critic.columns = ['rating']
    titles_na_critic = rating_critic[pd.isna(rating_critic.rating)].index

    ratings_t = ratings.loc[ratings.title.isin(titles_na_critic)]
    ratings_t = ratings_t.reset_index(drop=True)

    x = sim_users[sim_users.columns[user_id]]
    x = x.reset_index()
    x.columns = ['critic', 'similarity']

    ratings_t = pd.merge(left=ratings_t, right=x, on='critic')
    ratings_t.loc[:, 'sim_rating'] = ratings_t.rating * ratings_t.similarity

    result = ratings_t.groupby(by='title').sum()
    result.loc[:, 'pred_rating'] = result.sim_rating / result.similarity
    result = result.drop(columns=['rating', 'similarity', 'sim_rating'])

    return result


for user_id in [0, 2, 5]:
    print(f'=====Recommendations for {user_id}=====')
    print(generate_recommendation(user_id))
    print()
