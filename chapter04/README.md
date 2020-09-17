4장: 추천 엔진에서 사용되는 데이터 마이닝 기법
====================================

# 1. 이웃 기반 기법
[R 구현](./r/neighbor_method.r)
- 데이터의 유사도 및 거리를 계산하는 방법
- 유클리드 거리, 코사인 유사도, 자카드 유사도, 피어슨 상관계수

## 1) 유클리드 거리
- 두 점이나 벡터 사이의 거리를 구하는 방법

![](./equations/euclidean_distance.png)

## 2) 코사인 유사도
- 두 벡터의 내적을 활용한 유사도 계산
- 벡터가 이루는 각을 기준으로 유사한 정도를 구한다.
  - 유사한 벡터: 벡터가 이루는 각이 작다. 코사인 유사도 값이 1
  - 두 벡터가 직교하는 경우 코사인 유사도는 0이 된다.
  - 두 벡터가 반대 방향인 경우 코사인 유사도는 음수가 될 수 있다.

![](./equations/cosine_similarity.png)

## 3) 자카드 유사도
- 아이템의 합집합과 교집합의 비율로 계산한다.

![](./equations/jaccard_similarity.png)

## 4) 피어슨 상관 계수
- 두 벡터의 상관관계를 구하는 대표적인 방법이 피어슨 상관계수이다.
- 두 벡터의 공분산을 사용해서 상관계수를 구한다.
  - 커질때 같이 커지고, 작아질때 같이 작아지면(공분산이 크면) 상관 계수 값이 커진다.

![](./equations/pearson_correlation.png)

# 2. 수학적 모델 기법
[Python 구현](./python/matrix_factorization.py) [R 구현](./r/matrix_factorization.r)
- Matrix Factorization을 통해서 저차원의 Latent Feature를 찾는다.
  - 사람들이 영화를 평가하는데 기준이 되는 숨겨진 특징을 Latent Feature라고 한다.
- 저차원의 Latent Feature를 기반으로 유사도 방식의 추천 시스템의 성능을 개선할 수 있다.
- Matrix Factorization의 방법으로는 Gradient Descent, ALS, Singular Vector Decomposition이 있다

## 1) (Stochastic) Gradient Descent
- 사용자x아이템 행렬의 빈 값을 예측하기 위해서 사용자xFeature와 아이템xFeature 행렬로 분해
- 추측한 평가와 원래 평가의 차이가 최소가 되도록 학습을 진행

![](./equations/optimization.png)

## 2) ALS (Alternate, Least Square)
- Gradient Descent 처럼 추측한 평가와 원래 평가의 차이가 최호가 되도록 학습을 진행
- ALS는 사용자 또는 아이템을 상수항으로 간주하여서 Loss Function이 이차식의 간단한 형태로 구성
  - 빠른 미분 계산 가능
- 일반적으로 Matrix Factorization은 일반적인 Gradient Descent 보다 ALS 사용해서 최적해 도달

## 3)SVD(Singular Vector Decomposition)
- 행렬을 U, S, V로 분해. 사용자의 크기가 m이고 아이템의 크기가 n일 때 k개의 Singular Value를 선택할 경우
  - U: mxk 행렬
  - S: kxk 대각행렬
  - VT: kxn 행렬

![](./equations/svd.png)
