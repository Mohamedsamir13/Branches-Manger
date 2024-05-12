import 'package:get/get.dart';
import 'package:untitled3/Data/localDataSource.dart';


class BranchController extends GetxController {
  RxInt currentBranch = 0.obs;
  var totalBranches = 1.obs;
  var saveStatus = RxString('');
  final Map<int, Map<String, dynamic>> _branchData = {};

  void goToBranch(int branchNumber) {
    currentBranch.value = branchNumber;
  }

  void goToNextBranch() {
    if (currentBranch.value < totalBranches.value) {
      currentBranch.value++;
    }
  }

  void goToPreviousBranch() {
    if (currentBranch.value > 1) {
      currentBranch.value--;
    }
  }

  void updateBranchData(
      String arabicName,
      String arabicDescription,
      String englishName,
      String englishDescription,
      String note,
      String address,
      int branchNumber,
      ) {
    // Update branch data with new values
    _branchData[branchNumber] = {
      'arabicName': arabicName,
      'arabicDescription': arabicDescription,
      'englishName': englishName,
      'englishDescription': englishDescription,
      'note': note,
      'address': address,
      'branchNumber': branchNumber,
    };
  }

  Future<void> addBranch(Map<String, dynamic> branch) async {
    int nextBranchNumber = totalBranches.value + 1;
    branch['branchNumber'] = nextBranchNumber;

    await LocalDataSource.insertBranch(branch);
    await updateTotalBranches();
  }

  Future<void> updateBranch(Map<String, dynamic> branch) async {
    await LocalDataSource.updateBranch(branch);
  }

  Future<void> deleteBranch(int branchNumber) async {
    await LocalDataSource.deleteBranch(branchNumber);
    await updateTotalBranches();
  }

  Future<void> updateTotalBranches() async {
    totalBranches.value = (await LocalDataSource.getBranches()).length;
  }

  Future<void> initController() async {
    List<Map<String, dynamic>> branches = await LocalDataSource.getBranches();
    for (var branch in branches) {
      _branchData[branch['branchNumber']] = branch;
    }
    await updateTotalBranches();
  }

  @override
  void onInit() {
    super.onInit();
    initController();
  }

  Map<String, dynamic>? getBranchData(int branchNumber) {
    return _branchData[branchNumber];
  }
}