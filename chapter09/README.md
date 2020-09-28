9장: 머하웃을 이용한 추천 엔진 구축하기
====================================

# 1. Apache Mahout
- 자바 라이브러리
- 협업 필터링과 같은 알고리즘을 Hadoop 위에서 효율적으로 분산 처리
- Apache Mahout은 Hadoop Map Reduce 기반으로 확장 가능한 알고리즘을 구축한 반면 Spark MLLib은 Spark 기반으로 처리
  - Spark MLLib으로 분산 처리하는 것으로 충분
  - Apache Mathout도 더이상 Map Reduce 기반이 아니라 스파크 기반으로 알고리즘 처리하는 것을 지향
- 메모리가 감당할 수 없을정도로 엄청나게 많은 데이터를 처리해야한다면 Apache Mahout은 괜찮은 선택
  - 확장 가능성이 최대 장점
