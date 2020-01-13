class GoalModel {
  String id;
  String name;
  String owner;
  double goalAmount;
  double currentAmount;
  DateTime lastUpdated;
  DateTime createdAt;

  GoalModel({
    this.id,
    this.name,
    this.owner,
    this.goalAmount,
    this.currentAmount,
    this.lastUpdated,
    this.createdAt,
  });
}
