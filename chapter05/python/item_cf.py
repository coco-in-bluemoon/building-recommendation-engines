from sklearn.metrics import mean_squared_error
from sklearn.model_selection import train_test_split
from sklearn.neighbors import NearestNeighbors
import numpy as np
import pandas as pd


def get_mse(pred, actual):
    pred = pred[actual.nonzero()].flatten()
    actual = actual[actual.nonzero()].flatten()
    mse = mean_squared_error(actual, pred)
    return mse


df = pd.read_csv('chapter05/data/ml-latest-small/ratings.csv')

user2idx = {user: idx for idx, user in enumerate(df.userId.unique())}
item2idx = {item: idx for idx, item in enumerate(df.movieId.unique())}

n_users = len(user2idx)
n_items = len(item2idx)

print(f'Number of User: {n_users}')
print(f'Number of Item: {n_items}')

ratings = np.zeros((n_users, n_items))

for row in df.itertuples():
    user = row[1]
    item = row[2]
    rating = row[3]

    uid = user2idx[user]
    iid = item2idx[item]

    ratings[uid, iid] = rating

print(f'Rating Matrix Size: {ratings.shape}')

# Train Test Split
ratings_train, ratings_test = train_test_split(
    ratings, test_size=0.33, random_state=2020
)
print(f'Rating Matrix Size (Train)\t: {ratings_train.shape}')
print(f'Rating Matrix Size (Test)\t: {ratings_test.shape}')

# Using ALL Data
k = n_items
neigh = NearestNeighbors(n_neighbors=k, metric='cosine')
neigh.fit(ratings_train.T)

top_k_distance, top_k_items =\
    neigh.kneighbors(ratings_train.T, return_distance=True)
top_k_similarity = 1 - top_k_distance

print('\n========== Train Data ==========')
pred_train =\
    np.dot(ratings_train, top_k_similarity) /\
    (np.sum(top_k_similarity, axis=0).reshape((1, -1)) + 1e-10)
mse = get_mse(pred_train, ratings_train)
print(f'MSE: {mse}')

print('========== Test Data ==========')
pred_test = \
    np.dot(ratings_test, top_k_similarity) /\
    (np.sum(top_k_similarity, axis=0).reshape((1, -1)) + 1e-10)
mse = get_mse(pred_test, ratings_test)
print(f'MSE: {mse}')
