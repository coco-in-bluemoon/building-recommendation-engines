import numpy as np
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
def calcualte_norm(u):
    norm_u = 0.0
    for ui in u:
        if np.isnan(ui):
            continue
        norm_u += (ui ** 2)

    return np.sqrt(norm_u)


def calculate_cosine_similarity(u, v):
    norm_u = calcualte_norm(u)
    norm_v = calcualte_norm(v)
    denominator = norm_u * norm_v

    numerator = 0.0
    for ui, vi in zip(u, v):
        if np.isnan(ui) or np.isnan(vi):
            continue
        numerator += (ui * vi)

    similarity = numerator / denominator

    return similarity


titles = movie_ratings.index
sim_items = pd.DataFrame(0, columns=titles, index=titles, dtype=float)
for src in titles:
    for dst in titles:
        src_vec = movie_ratings.loc[src, :].values
        dst_vec = movie_ratings.loc[dst, :].values

        similarity = calculate_cosine_similarity(src_vec, dst_vec)
        sim_items.loc[src, dst] = similarity
print(sim_items)


# 3. Make Prediction & Recommendation
user_id = 5
ratings_critic = movie_ratings.loc[:, [movie_ratings.columns[user_id]]]
ratings_critic.columns = ['rating']
titles_na_critic = ratings_critic[pd.isna(ratings_critic.rating)].index

ratings_t = ratings.loc[ratings.critic == movie_ratings.columns[user_id]]
ratings_t = ratings_t.reset_index(drop=True)

x = sim_items.loc[:, titles_na_critic]

ratings_t = pd.merge(ratings_t, x, on='title')
print(ratings_t)

result_dict = {'title': list(), 'rating': list(), 'similarity': list()}
for row in ratings_t.iterrows():
    for title in titles_na_critic:
        result_dict['title'].append(title)
        result_dict['rating'].append(row[1]['rating'])
        result_dict['similarity'].append(row[1][title])
result = pd.DataFrame(result_dict)
result.loc[:, 'sim_rating'] = result.rating * result.similarity
result = result.groupby('title').sum()
result.loc[:, 'prediction'] = result.sim_rating / result.similarity
result = result.drop(columns=['rating', 'similarity', 'sim_rating'])
print(result)
