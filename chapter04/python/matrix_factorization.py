from sklearn.decomposition import NMF
import numpy as np
import pandas as pd


# 1. Matrix Factorization: NMF
print('========= 1. Matrix Factorization using NMF =========')
ratings = pd.read_csv('chapter04/data/ml-latest-small/ratings.csv')
ratings = pd.pivot_table(
    ratings,
    index='userId',
    columns='movieId'
)
ratings = ratings.fillna(0)
print(ratings.shape)

nmf = NMF(n_components=10)
p = nmf.fit_transform(ratings)
q = nmf.components_
r_hat = np.dot(p, q)

print(p.shape)
print(q.shape)
print(r_hat.shape)


# 2. Matrix Factorization: SVD
print('========= 2. Matrix Factorization using SVD =========')
sample_matrix = np.random.uniform(0, 5, size=(9, 6))
print('Original Matrix')
print(sample_matrix)

U, S, V = np.linalg.svd(sample_matrix)
print(U.shape)
print(S.shape)
print(V.shape)

k = 2
print(U[:, :k] @ np.diag(S[:k]) @ V[:k, :])
