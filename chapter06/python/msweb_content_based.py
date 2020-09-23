from sklearn.feature_extraction.text import TfidfVectorizer
from sklearn.metrics.pairwise import cosine_similarity
import numpy as np
import pandas as pd
import scipy as sp


path = 'chapter06/data/ms-webdata/anonymous-msweb.test'

raw_data = pd.read_csv(path, header=None, skiprows=7)
print(raw_data.head())


# 사용자 활동
user_activity = raw_data.loc[raw_data[0] != 'A', :1]
user_activity.columns = ['category', 'value']
print(user_activity.head())

n_web = len(user_activity.loc[user_activity.category == 'C'].value.unique())
n_user = len(user_activity.loc[user_activity.category == 'V'].value.unique())
print(f'Number of Web: {n_web}')
print(f'Number of User: {n_user}')

for row in user_activity.iterrows():
    index = row[0]
    category = row[1]['category']
    if category == 'C':
        userid = row[1]['value']
        user_activity.loc[index, 'userid'] = userid
        user_activity.loc[index, 'webid'] = userid
    elif category == 'V':
        webid = row[1]['value']
        user_activity.loc[index, 'userid'] = userid
        user_activity.loc[index, 'webid'] = webid

user_activity = user_activity.loc[
    user_activity.category == 'V', ['userid', 'webid']
]
user_activity = user_activity.astype('int')

user_activity = user_activity.sort_values('webid')
user_activity.loc[:, 'rating'] = 1

rating_matrix = user_activity.pivot(
    index='userid',
    columns='webid',
    values='rating'
).fillna(0)
rating_matrix = rating_matrix.astype('int')
rating_matrix = rating_matrix.to_numpy()
print(rating_matrix)

# Item Profile
items = raw_data.loc[raw_data[0] == 'A']
items.columns = ['record', 'webid', 'vote', 'desc', 'url']
items = items[['webid', 'desc']]
print(f'Size of Item: {items.shape}')

items_in_activity = items.loc[items.webid.isin(user_activity.webid.tolist())]
items_in_activity = items_in_activity.sort_values('webid')
print(items_in_activity.head())

vectorizer = TfidfVectorizer(
    stop_words='english',
    max_features=100,
    ngram_range=(0, 3),
    sublinear_tf=True
)
item_profile = vectorizer.fit_transform(items_in_activity.desc).todense()
print(item_profile)

# User Profile
user_profile =\
    np.dot(rating_matrix, item_profile) / sp.linalg.norm(item_profile)
print(user_profile)

# Cosine Similarity between Item Profile and User Profile
similarity = cosine_similarity(user_profile, item_profile)
print(similarity)

# Prediction
prediction = np.where(similarity > 0.6, 1, 0)
index_of_user = np.where(prediction[213] == 1)
print(index_of_user)
