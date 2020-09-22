from sklearn.model_selection import train_test_split
from sklearn.metrics import mean_squared_error
from sklearn.metrics.pairwise import cosine_similarity
from sklearn.neighbors import NearestNeighbors
import numpy as np
import pandas as pd


def get_mse(pred, actual):
    pred = pred[actual.nonzero()].flatten()
    actual = actual[actual.nonzero()].flatten()
    mse = mean_squared_error(pred, actual)
    return mse


df = pd.read_csv('chapter05/data/ml-latest-small/ratings.csv')

print(df.head())

user2idx = {user: idx for idx, user in enumerate(df.userId.unique())}
item2idx = {item: idx for idx, item in enumerate(df.movieId.unique())}

n_users = len(user2idx)
n_items = len(item2idx)

print(f'{n_users} Users')
print(f'{n_items} Items')

ratings = np.zeros((n_users, n_items))
for row in df.itertuples():
    user = row[1]
    item = row[2]
    rating = row[3]

    uid = user2idx[user]
    iid = item2idx[item]

    ratings[uid, iid] = rating

print(f'Sahpe of Rating Matrix: {ratings.shape}')

# Calculate Sparsity
sparsity = len(ratings.nonzero()[0]) / (ratings.shape[0] * ratings.shape[1])
print(f'Sparsity: {sparsity:2%}')

# Train and Test Dataset
ratings_train, ratings_test = train_test_split(
    ratings, test_size=0.33, random_state=2020
)
print(f'Train Size: {ratings_train.shape}')
print(f'Test Size: {ratings_test.shape}')

# User Base CF
print('\n============== TRAIN Rating ==============')
user_sim = cosine_similarity(ratings_train)
print(f'Similarity Matrix Size: {user_sim.shape}')

# Prediction
train_pred = \
    np.dot(user_sim, ratings_train) / np.sum(user_sim, axis=1).reshape((-1, 1))

mse = get_mse(train_pred, ratings_train)
print(f'MSE: {mse}')

# Recommendation for test
print('============== Test Rating ==============')
user_sim = cosine_similarity(ratings_test, ratings_train)
print(f'Similarity Matrix Size: {user_sim.shape}')
test_pred = \
    np.dot(user_sim, ratings_train) / np.sum(user_sim, axis=1).reshape((-1, 1))
mse = get_mse(test_pred, ratings_test)
print(f'MSE: {mse}')


# Use K-NN
print('\n============== Performance Upgrade using KNN ==============')
print('============== TRAIN Rating ==============')
neigh = NearestNeighbors(n_neighbors=5, metric='cosine')
neigh.fit(ratings_train)
top_k_dist, top_k_users = neigh.kneighbors(ratings_train, return_distance=True)
print(f'Distance Matrix Size: {top_k_dist.shape}')
print(f'Similar User: {top_k_users.shape}')

train_pred_k = np.zeros(ratings_train.shape)
for i in range(ratings_train.shape[0]):
    neighbors = top_k_users[i]
    user_sim = (1 - top_k_dist[i]).reshape((1, -1))
    train_pred_k[i] =\
        np.dot(user_sim, ratings_train[neighbors, :]) /\
        np.sum(user_sim, axis=1)
mse = get_mse(train_pred_k, ratings_train)
print(f'MSE: {mse}')

print('============== Test Rating ==============')
top_k_dist, top_k_users = neigh.kneighbors(ratings_test, return_distance=True)
print(f'Distance Matrix Size: {top_k_dist.shape}')
print(f'Similar User: {top_k_users.shape}')

test_pred_k = np.zeros(ratings_test.shape)
for i in range(ratings_test.shape[0]):
    neighbors = top_k_users[i]
    user_sim = (1 - top_k_dist[i]).reshape((1, -1))
    test_pred_k[i] = \
        np.dot(user_sim, ratings_train[neighbors, :]) /\
        np.sum(user_sim, axis=1)
mse = get_mse(train_pred_k, ratings_train)
print(f'MSE: {mse}')
