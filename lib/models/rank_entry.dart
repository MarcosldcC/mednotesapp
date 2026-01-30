/// Entrada do ranking (por tier com pontos 0–100 ou legado com exp).
class RankEntry {
  const RankEntry({
    required this.name,
    required this.exp,
    required this.rank,
    this.isUser = false,
    this.points,
  });

  final String name;
  final int exp;
  /// Pontos no tier atual (0–100). Se não null, usado para exibição no ranking por tier.
  final int? points;
  final int rank;
  final bool isUser;
}
