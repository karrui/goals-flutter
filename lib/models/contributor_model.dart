import 'contribution_model.dart';
import 'user_model.dart';

class ContributorModel {
  final String uid;
  final String photoUrl;
  final String displayName;
  double totalContribution;

  ContributorModel({
    this.uid,
    this.photoUrl,
    this.displayName,
    this.totalContribution,
  });

  static List<ContributorModel> fromContributionList(
      List<ContributionModel> contributionList,
      Map<String, UserModel> userModelMap) {
    Map<String, ContributorModel> contributorMap = {};
    for (var key in userModelMap.keys) {
      var user = userModelMap[key];
      contributorMap[key] = ContributorModel(
          uid: key,
          photoUrl: user.photoUrl,
          totalContribution: 0,
          displayName: user.displayName);
    }
    Map<String, ContributorModel> uidToContributorMap = contributionList
        .fold(contributorMap,
            (Map<String, ContributorModel> acc, currentContribution) {
      var contributionAmount = currentContribution.type == ContributionType.ADD
          ? currentContribution.amount
          : -currentContribution.amount;
      acc[currentContribution.uid].totalContribution += contributionAmount;
      return acc;
    });
    return uidToContributorMap.entries.map((entry) => entry.value).toList();
  }
}
