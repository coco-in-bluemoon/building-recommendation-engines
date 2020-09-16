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
print(movie_ratings.T)

# 2. Item Profile with Tf-idf
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


# 3. User Profile: dot product
user_profile = np.dot(np.transpose(movie_ratings.fillna(0)), item_profile)
user_profile = pd.DataFrame(
    user_profile,
    index=movie_ratings.columns,
    columns=item_profile.columns
)
print(user_profile)


# 4. Calculate Similarity
def calculate_norm(u):
    norm_u = 0.0
    for ui in u:
        if np.isnan(ui):
            continue
        norm_u += (ui ** 2)
    return np.sqrt(norm_u)


def calculate_cosine_similarity(u, v):
    norm_u = calculate_norm(u)
    norm_v = calculate_norm(v)
    denominator = norm_u * norm_v

    nominator = 0.0
    for ui, vi in zip(u, v):
        if np.isnan(ui) or np.isnan(vi):
            continue
        nominator += (ui * vi)
    return nominator / denominator


result = pd.DataFrame(index=user_profile.index, columns=item_profile.index)
for u in user_profile.index:
    for i in item_profile.index:
        user_vec = user_profile.loc[u, :].values
        item_vec = item_profile.loc[i, :].values

        similarity = calculate_cosine_similarity(user_vec, item_vec)
        result.loc[u, i] = similarity
print(result)
