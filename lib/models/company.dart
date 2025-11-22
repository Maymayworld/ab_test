class Company {
  final String id;
  final String name;
  final String industry;
  final String description;
  final Map<String, int> tags;

  const Company({
    required this.id,
    required this.name,
    required this.industry,
    required this.description,
    required this.tags,
  });

  // Jaccard係数を使った類似度計算
  double calculateSimilarity(Map<String, int> userTags) {
    double minSum = 0;
    double maxSum = 0;
    
    // すべてのタグ（ユーザーと企業の両方）を集める
    final allTags = <String>{...userTags.keys, ...tags.keys};
    
    for (final tagName in allTags) {
      final userValue = userTags[tagName] ?? 0;
      final companyValue = tags[tagName] ?? 0;
      
      // 最小値と最大値を計算
      final minValue = userValue < companyValue ? userValue : companyValue;
      final maxValue = userValue > companyValue ? userValue : companyValue;
      
      minSum += minValue;
      maxSum += maxValue;
    }
    
    // Jaccard係数 = min の総和 / max の総和
    return maxSum == 0 ? 0 : minSum / maxSum;
  }
  
  // マッチ理由となるトップタグを取得
  List<String> getTopMatchTags(Map<String, int> userTags, int count) {
    final tagScores = <MapEntry<String, double>>[];
    
    for (final entry in userTags.entries) {
      final tagName = entry.key;
      final userValue = entry.value;
      final companyValue = tags[tagName] ?? 0;
      
      if (companyValue > 0) {
        final contribution = userValue * companyValue;
        tagScores.add(MapEntry(tagName, contribution.toDouble()));
      }
    }
    
    tagScores.sort((a, b) => b.value.compareTo(a.value));
    return tagScores.take(count).map((e) => e.key).toList();
  }
}