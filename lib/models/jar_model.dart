class JarModel {
  String id;
  String name;
  String owner;
  List<String> sharedTo;
  double goalAmount;
  double currentAmount;
  DateTime lastUpdated;

  JarModel({
    this.id,
    this.name,
    this.owner,
    this.sharedTo,
    this.goalAmount,
    this.currentAmount,
    this.lastUpdated,
  });
}
