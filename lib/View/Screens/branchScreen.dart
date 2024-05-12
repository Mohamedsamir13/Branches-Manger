import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled3/Controller/branchController.dart';
import 'package:untitled3/Core/appSize.dart';
import 'package:untitled3/Core/appText.dart';
import 'package:untitled3/Data/localDataSource.dart';
import 'package:untitled3/View/Components/customField.dart';

class BranchScreen extends StatefulWidget {
  @override
  _BranchScreenState createState() => _BranchScreenState();
}

class _BranchScreenState extends State<BranchScreen> {
  final TextEditingController customNumberController = TextEditingController();
  final TextEditingController arabicNameController = TextEditingController();
  final TextEditingController arabicDescriptionController =
      TextEditingController();
  final TextEditingController englishNameController = TextEditingController();
  final TextEditingController englishDescriptionController =
      TextEditingController();
  final TextEditingController noteController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  late final TextEditingController branchNumberController;

  final branchController = Get.find<BranchController>();

  String saveStatus = '';

  @override
  void initState() {
    super.initState();
    // Initialize the TextEditingController here without a value
    branchNumberController = TextEditingController();

    SharedPreferences.getInstance().then((prefs) {
      bool isFirstLaunch = prefs.getBool('isFirstLaunch') ?? true;
      if (isFirstLaunch) {
        prefs.setBool('isFirstLaunch', false);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.blue,
              content: Text('Welcome! Please add your first branch.'),
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      }

      // Determine the last branch index or default to 1 if not found
      int lastBranchIndex = prefs.getInt('currentBranchIndex') ?? 1;
      branchController.currentBranch.value = lastBranchIndex;

      // Set the text of the already initialized controller
      branchNumberController.text = '${branchController.currentBranch.value}';

      // Load the branch values after everything is initialized and set
      _loadBranchValues();
    }).catchError((error) {
      // Handle errors here if SharedPreferences fails
      print("Error loading SharedPreferences: $error");
    });
  }

  void _deleteBranch() async {
    int currentBranchNumber = branchController.currentBranch.value;

    if (currentBranchNumber == 1) {
      // If it's the first branch, just clear fields except branch number and notify
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.red,
          content: Text(
              'Cannot delete the first branch.bu can you edit the fields as you want'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } else {
      // Proceed with deletion for other branches
      await LocalDataSource.deleteBranch(currentBranchNumber);
      branchController.totalBranches.value--;

      if (branchController.currentBranch.value > 1) {
        branchController.currentBranch.value--;
      } else if (branchController.totalBranches.value > 0) {
        branchController.currentBranch.value = 1;
      } else {
        branchController.currentBranch.value = 0;
      }

      _loadBranchValues();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text('Branch deleted successfully'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  void _clearAllFields() {
    customNumberController.clear();
    arabicNameController.clear();
    arabicDescriptionController.clear();
    englishNameController.clear();
    englishDescriptionController.clear();
    noteController.clear();
    addressController.clear();
    branchNumberController.clear();
  }

  void _loadBranchValues() async {
    int currentBranchNumber = branchController.currentBranch.value;
    List<Map<String, dynamic>> branches = await LocalDataSource.getBranches();
    Map<String, dynamic>? branch = branches.firstWhere(
        (b) => b['branchNumber'] == currentBranchNumber,
        orElse: () => {});

    customNumberController.text = branch['customNumber']?.toString() ?? '';
    arabicNameController.text = branch['arabicName'] ?? '';
    arabicDescriptionController.text = branch['arabicDescription'] ?? '';
    englishNameController.text = branch['englishName'] ?? '';
    englishDescriptionController.text = branch['englishDescription'] ?? '';
    noteController.text = branch['note'] ?? '';
    addressController.text = branch['address'] ?? '';
    branchNumberController.text = '$currentBranchNumber';
  }

  void _addBranch() async {
    int nextBranchNumber = branchController.totalBranches.value + 1;

    Map<String, dynamic> branch = {
      'branchNumber': nextBranchNumber,
      'customNumber': int.tryParse(customNumberController.text) ?? 0,
      'arabicName': arabicNameController.text,
      'arabicDescription': arabicDescriptionController.text,
      'englishName': englishNameController.text,
      'englishDescription': englishDescriptionController.text,
      'note': noteController.text,
      'address': addressController.text,
    };

    await LocalDataSource.insertBranch(branch);
    await LocalDataSource.updateBranch(branch);

    branchController.currentBranch.value = nextBranchNumber;
    branchController.totalBranches.value = nextBranchNumber;

    branchNumberController.text = '$nextBranchNumber';

    customNumberController.clear();
    arabicNameController.clear();
    arabicDescriptionController.clear();
    englishNameController.clear();
    englishDescriptionController.clear();
    noteController.clear();
    addressController.clear();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.green,
        content: Text('Branch added successfully'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _saveCurrentBranchIndex() {
    SharedPreferences.getInstance().then((prefs) {
      prefs.setInt('currentBranchIndex', branchController.currentBranch.value);
    });
  }

  AppBar buildAppBar() {
    return AppBar(
      backgroundColor: Colors.indigo,
      title: Center(
        child: AppText(
          text: 'Branch/Store/Cashier',
          color: Colors.white,
          fontWeight: FontWeight.w400,
          size: displayWidth(context) * 0.025,
        ),
      ),
      actions: [
        IconButton(
          color: Colors.white,
          onPressed: () {
            _addBranch();
          },
          icon: Icon(Icons.add_circle),
        ),
        SizedBox(width: displayWidth(context) * 0.03),
        IconButton(
          color: Colors.white,
          onPressed: () => _saveBranch(),
          icon: Icon(Icons.save_rounded),
        ),
        SizedBox(width: displayWidth(context) * 0.03),
        IconButton(
          color: Colors.white,
          iconSize: 24,
          onPressed: () {
            _deleteBranch();
          },
          icon: Icon(
            Icons.delete,
          ),
        ),
        SizedBox(width: 16),
        Obx(() => Text(
              branchController.saveStatus.value,
              style: TextStyle(color: Colors.white),
            )),
      ],
    );
  }

  void _goToNextBranch() {
    if (branchController.currentBranch.value <
        branchController.totalBranches.value) {
      branchController.goToNextBranch();
      _loadBranchValues();
    }
  }

  void _goToPreviousBranch() {
    if (branchController.currentBranch.value > 1) {
      branchController.goToPreviousBranch();
      _loadBranchValues();
    }
  }

  void _saveBranch() {
    // Validate all fields are filled
    if (customNumberController.text.isEmpty ||
        arabicNameController.text.isEmpty ||
        arabicDescriptionController.text.isEmpty ||
        englishNameController.text.isEmpty ||
        englishDescriptionController.text.isEmpty ||
        noteController.text.isEmpty ||
        addressController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please fill all fields'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // If all fields are filled, save the branch
    Map<String, dynamic> branch = {
      'branchNumber': int.tryParse(branchNumberController.text) ?? 0,
      'customNumber': int.tryParse(customNumberController.text) ?? 0,
      'arabicName': arabicNameController.text,
      'arabicDescription': arabicDescriptionController.text,
      'englishName': englishNameController.text,
      'englishDescription': englishDescriptionController.text,
      'note': noteController.text,
      'address': addressController.text,
    };
    LocalDataSource.insertBranch(branch);

    LocalDataSource.updateBranch(branch);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Data saved successfully'),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isLargeScreen = displayWidth(context) > 600;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: buildAppBar(),
      body: Padding(
        padding: EdgeInsets.only(
            right: displayWidth(context) * 0.03,
            left: displayWidth(context) * 0.03,
            top: displayHeight(context) * 0.03),
        child: Column(
          children: [
            // Conditional layout for large or small screens
            isLargeScreen ? buildLargeScreenLayout() : buildSmallScreenLayout(),
            SizedBox(height: displayHeight(context) * 0.06),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  IconButton(
                    onPressed: _goToPreviousBranch,
                    icon: Icon(
                      Icons.keyboard_double_arrow_left_outlined,
                      color: Colors.indigo,
                      size: displayWidth(context) * 0.04,
                    ),
                  ),
                  Obx(() => Text(
                        '${branchController.currentBranch.value}/${branchController.totalBranches.value}',
                        style: TextStyle(fontSize: 24),
                      )),
                  IconButton(
                    onPressed: _goToNextBranch,
                    icon: Icon(
                      Icons.keyboard_double_arrow_right_outlined,
                      color: Colors.indigo,
                      size: displayWidth(context) * 0.04,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildLargeScreenLayout() {
    double width = displayWidth(context);
    return Column(
      children: [
        Row(
          children: [
            CustomTextField(
              label: 'Branch Number',
              controller: branchNumberController,
              width: width * 0.45,
              height: displayHeight(context) * 0.09,
              readOnly: true,
            ),
            SizedBox(width: displayWidth(context) * 0.04),
            CustomTextField(
              label: 'Custom Number',
              controller: customNumberController,
              width: width * 0.45,
              height: displayHeight(context) * 0.09,
            ),
          ],
        ),
        SizedBox(height: displayHeight(context) * 0.03),
        Row(
          children: [
            CustomTextField(
              label: 'Arabic Name',
              controller: arabicNameController,
              width: width * 0.45,
              height: displayHeight(context) * 0.09,
            ),
            SizedBox(width: displayWidth(context) * 0.04),
            CustomTextField(
              label: 'Arabic Description',
              controller: arabicDescriptionController,
              width: width * 0.45,
              height: displayHeight(context) * 0.09,
            ),
          ],
        ),
        SizedBox(height: displayHeight(context) * 0.03),
        Row(
          children: [
            CustomTextField(
              label: 'English Name',
              controller: englishNameController,
              width: width * 0.45,
              height: displayHeight(context) * 0.09,
            ),
            SizedBox(width: displayWidth(context) * 0.04),
            CustomTextField(
              label: 'English Description',
              controller: englishDescriptionController,
              width: width * 0.45,
              height: displayHeight(context) * 0.09,
            ),
          ],
        ),
        SizedBox(height: displayHeight(context) * 0.03),
        Row(
          children: [
            CustomTextField(
              label: 'Note',
              controller: noteController,
              width: width * 0.45,
              height: displayHeight(context) * 0.12,
            ),
            SizedBox(width: displayWidth(context) * 0.04),
            CustomTextField(
              label: 'Address',
              controller: addressController,
              width: width * 0.45,
              height: displayHeight(context) * 0.12,
            ),
          ],
        ),
      ],
    );
  }

  Widget buildSmallScreenLayout() {
    double width = displayWidth(context);
    return Column(
      children: [
        SizedBox(
          height: displayHeight(context) * 0.02,
        ),
        Row(
          children: [
            Container(
              width: displayWidth(context) * 0.64,
              // Increased width for branchNumber
              child: CustomTextField(
                readOnly: true,
                controller: branchNumberController,
                label: 'BranchNum',
                height: displayHeight(context) * 0.05,
              ),
            ),
            SizedBox(width: displayWidth(context) * 0.015),
            Expanded(
              child: Container(
                width: displayWidth(context) * 0.40,
                // Reduced width for customNumber
                child: CustomTextField(
                  controller: customNumberController,
                  label: 'CustomNum',
                  height: displayHeight(context) * 0.05,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'CustomNumber is required';
                    }
                    return null;
                  },
                ),
              ),
            ),
          ],
        ),
        SizedBox(
          height: displayHeight(context) * 0.03,
        ),
        CustomTextField(
          label: 'Arabic Name',
          controller: arabicNameController,
          width: width,
          height: displayHeight(context) * 0.05,
        ),
        SizedBox(
          height: displayHeight(context) * 0.03,
        ),
        CustomTextField(
          label: 'Arabic Description',
          controller: arabicDescriptionController,
          width: width,
          height: displayHeight(context) * 0.05,
        ),
        SizedBox(
          height: displayHeight(context) * 0.03,
        ),
        CustomTextField(
          label: 'English Name',
          controller: englishNameController,
          width: width,
          height: displayHeight(context) * 0.05,
        ),
        SizedBox(
          height: displayHeight(context) * 0.03,
        ),
        CustomTextField(
          label: 'English Description',
          controller: englishDescriptionController,
          width: width,
          height: displayHeight(context) * 0.05,
        ),
        SizedBox(
          height: displayHeight(context) * 0.03,
        ),
        CustomTextField(
          label: 'Note',
          controller: noteController,
          width: width,
          height: displayHeight(context) * 0.05,
        ),
        SizedBox(
          height: displayHeight(context) * 0.03,
        ),
        CustomTextField(
          label: 'Address',
          controller: addressController,
          width: width,
          height: displayHeight(context) * 0.05,
        ),
      ],
    );
  }
}
