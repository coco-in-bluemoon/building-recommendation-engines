7장: 스파크를 사용해 실시간 추천 엔진 구축하기
====================================

# 1. 스파크
- 인 메모리 기반의 분산 처리 시스템
- Hadoop Ecosystem 환경에서 실행가능
- Spark Core 위에 4가지 주요 기능이 올라옴
  - Spark SQL
  - Spark Streaming
  - Spark MLLib
  - Spark GraphX
- 스파크는 데이터를 RDD(Resilient Distributed Dataset)으로 관리한다
  - Spark 2.0에서는 DataFrame 형태로 변환 가능

## 스파크 설치
- 자바 설치 필요
- [Apache Spark](https://spark.apache.org/downloads.html)에서 하둡과 스칼라가 pre-built 된 스파크 버전 다운로드 가능
- Jupyter를 사용해서 pyspark와 연동할 경우 환경 변수 설정 필요
```
export SPARK_HOME=/opt/spark
export PATH=$SPARK_HOME/bin:$PATH
export PYSPARK_PYTHON=/usr/bin/python3
export PYSPARK_DRIVER_PYTHON=jupyter
export PYSPARK_DRIVER_PYTHON_OPTS='notebook --ip 0.0.0.0'
```

# 2. ALS 추천 시스템
- pyspark 기반의 [Jupyter Notebook 구현](./python-jupyter/ALS%20Spark%20MLLib.ipynb)
  - [nbviewer 링크](https://nbviewer.jupyter.org/github/coco-in-bluemoon/building-recommendation-engines/blob/master/chapter07/python-jupyter/ALS%20Spark%20MLLib.ipynb)
- map 연산으로 통해 RDD 처리
- ALS 모델 학습 및 평가

