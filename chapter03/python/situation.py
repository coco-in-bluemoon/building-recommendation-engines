from sklearn.metrics.pairwise import cosine_similarity
import numpy as np
import pandas as pd


# 1. Load Data and Item Profile
ratings = pd.read_csv('chapter03/data/movie_rating.csv')
movie_ratings = pd.pivot_table(
    ratings,
    values='rating',
    index='title',
    columns='critic'
)
print(movie_ratings)


# 2. Consturct profiles
profile_dict = {
    'Romance': [0.3, 0.4, 0],
    'Thriller': [0, 0, 0.5],
    'Action': [0.2, 0, 0],
    'Sci-fi': [0, 0.3, 0.4],
    'Mystery': [0, 0, 0],
    'Comedy': [0.5, 0, 0],
    'Fantasy': [0, 0.3, 0.1],
    'Crime': [0, 0, 0]
}
situation_profile = pd.DataFrame(
    profile_dict,
    index=['weekday', 'weekend', 'holiday']
)
print(situation_profile)

profile_dict = {
    'Romance': [1, 0, 0, 0, 0, 1],
    'Thriller': [0, 1, 1, 0, 0, 0],
    'Action': [0, 0, 1, 0, 0, 0],
    'Sci-fi': [0, 0, 0, 1, 0, 0],
    'Mystery': [0, 0, 0, 0, 1, 0],
    'Comedy': [0, 0, 0, 0, 0, 1],
    'Fantasy': [1, 1, 0, 1, 0, 0],
    'Crime': [0, 0, 0, 0, 1, 0]
}
item_profile = pd.DataFrame(profile_dict, index=movie_ratings.index)

idf = dict()
N = len(item_profile)
for feature in item_profile.columns:
    df = item_profile[feature].value_counts()[1]
    idf[feature] = np.log(N / df)

    item_profile.loc[:, feature] =\
        [tf * idf[feature] for tf in item_profile.loc[:, feature]]
print(item_profile)

user_profile = np.dot(np.transpose(movie_ratings.fillna(0)), item_profile)
user_profile = pd.DataFrame(
    user_profile,
    index=movie_ratings.columns,
    columns=item_profile.columns
)
print(user_profile)

user_id = 5
user_5_profile = user_profile.loc[user_profile.index[5]]
user_situation_profile = situation_profile * user_5_profile
print(user_situation_profile)


# 3. calculate similarity
result = cosine_similarity(user_situation_profile, item_profile)
result = pd.DataFrame(
    result,
    index=user_situation_profile.index,
    columns=item_profile.index
)
print(result)
