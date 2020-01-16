import 'contribution_model.dart';

class ContributorModel {
  final String uid;
  final String displayName;
  double totalContribution;

  ContributorModel({
    this.uid,
    this.displayName,
    this.totalContribution,
  });

  static List<ContributorModel> fromContributionList(
      List<ContributionModel> contributionList) {
    Map<String, ContributorModel> uidToContributorMap = contributionList
        .fold({}, (Map<String, ContributorModel> acc, currentContribution) {
      var contributionAmount = currentContribution.type == ContributionType.ADD
          ? currentContribution.amount
          : -currentContribution.amount;
      if (acc.containsKey(currentContribution.uid)) {
        acc[currentContribution.uid].totalContribution += contributionAmount;
      } else {
        acc[currentContribution.uid] = ContributorModel(
            displayName: currentContribution.createdByName,
            totalContribution: contributionAmount,
            uid: currentContribution.uid);
      }
      return acc;
    });
    return uidToContributorMap.entries.map((entry) => entry.value).toList();
  }
}
