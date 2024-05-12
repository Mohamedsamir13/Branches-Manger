import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled3/Controller/branchController.dart';
import 'package:untitled3/Core/appSize.dart';
import 'package:untitled3/Core/appText.dart';
import 'package:untitled3/Data/localDataSource.dart';
import 'package:untitled3/View/Components/customField.dart';

// class SmallScreen extends StatefulWidget {
//   @override
//   _SmallScreenState createState() => _SmallScreenState();
// }
//
// class _SmallScreenState extends State<SmallScreen> {
//   final TextEditingController customNumberController = TextEditingController();
//   final TextEditingController arabicNameController = TextEditingController();
//   final TextEditingController arabicDescriptionController =
//   TextEditingController();
//   final TextEditingController englishNameController = TextEditingController();
//   final TextEditingController englishDescriptionController =
//   TextEditingController();
//   final TextEditingController noteController = TextEditingController();
//   final TextEditingController addressController = TextEditingController();
//
//   late final TextEditingController branchNumberController;
//
//   final branchController = Get.find<BranchController>();
//
//   String saveStatus = '';
//
//   @override
//   void initState() {
//     super.initState();
//     SharedPreferences.getInstance().then((prefs) {
//       bool isFirstLaunch = prefs.getBool('isFirstLaunch') ?? true;
//       if (isFirstLaunch) {
//         prefs.setBool('isFirstLaunch', false);
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             backgroundColor: Colors.blue,
//             content: Text('Please add the first branch'),
//             behavior: SnackBarBehavior.floating,
//           ),
//         );
//       }
//     });
//     branchNumberController = TextEditingController(
//       text: '${branchController.totalBranches.value}',
//     );
//     _loadBranchValues();
//   }
//
//   void _deleteBranch() async {
//     int currentBranchNumber = branchController.currentBranch.value;
//
//     if (branchController.totalBranches.value > 1) {
//       await LocalDataSource.deleteBranch(currentBranchNumber);
//
//       branchController.totalBranches.value--;
//       if (branchController.currentBranch.value > 1) {
//         branchController.currentBranch.value--;
//       } else if (branchController.totalBranches.value > 0) {
//         branchController.currentBranch.value = 1;
//       } else {
//         branchController.currentBranch.value = 0;
//         _clearAllFields();
//       }
//
//       _loadBranchValues();
//
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           backgroundColor: Colors.red,
//           content: Text('Branch deleted successfully'),
//           behavior: SnackBarBehavior.floating,
//         ),
//       );
//     }
//   }
//
//   void _clearAllFields() {
//     customNumberController.clear();
//     arabicNameController.clear();
//     arabicDescriptionController.clear();
//     englishNameController.clear();
//     englishDescriptionController.clear();
//     noteController.clear();
//     addressController.clear();
//     branchNumberController.clear();
//   }
//
//   void _loadBranchValues() async {
//     int currentBranchNumber = branchController.currentBranch.value;
//     List<Map<String, dynamic>> branches = await LocalDataSource.getBranches();
//     Map<String, dynamic>? branch = branches.firstWhere(
//             (b) => b['branchNumber'] == currentBranchNumber,
//         orElse: () => {});
//
//     customNumberController.text = branch['customNumber']?.toString() ?? '';
//     arabicNameController.text = branch['arabicName'] ?? '';
//     arabicDescriptionController.text = branch['arabicDescription'] ?? '';
//     englishNameController.text = branch['englishName'] ?? '';
//     englishDescriptionController.text = branch['englishDescription'] ?? '';
//     noteController.text = branch['note'] ?? '';
//     addressController.text = branch['address'] ?? '';
//     branchNumberController.text = '$currentBranchNumber';
//   }
//
//   void _addBranch() async {
//     int nextBranchNumber = branchController.totalBranches.value + 1;
//
//     Map<String, dynamic> branch = {
//       'branchNumber': nextBranchNumber,
//       'customNumber': int.tryParse(customNumberController.text) ?? 0,
//       'arabicName': arabicNameController.text,
//       'arabicDescription': arabicDescriptionController.text,
//       'englishName': englishNameController.text,
//       'englishDescription': englishDescriptionController.text,
//       'note': noteController.text,
//       'address': addressController.text,
//     };
//
//     await LocalDataSource.insertBranch(branch);
//     await LocalDataSource.updateBranch(branch);
//
//     branchController.currentBranch.value = nextBranchNumber;
//     branchController.totalBranches.value = nextBranchNumber;
//
//     branchNumberController.text = '$nextBranchNumber';
//
//     customNumberController.clear();
//     arabicNameController.clear();
//     arabicDescriptionController.clear();
//     englishNameController.clear();
//     englishDescriptionController.clear();
//     noteController.clear();
//     addressController.clear();
//
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         backgroundColor: Colors.green,
//         content: Text('Branch added successfully'),
//         behavior: SnackBarBehavior.floating,
//       ),
//     );
//   }
//
//   AppBar buildAppBar() {
//     bool isFormValid = [
//       arabicNameController.text,
//       arabicDescriptionController.text,
//       englishNameController.text,
//       englishDescriptionController.text,
//       addressController.text,
//     ].every((element) => element.isNotEmpty);
//     return AppBar(
//       backgroundColor: Colors.indigo,
//       title: Center(
//         child: AppText(
//           text: 'Branch/Store/Cashier',
//           color: Colors.white,
//           fontWeight: FontWeight.w400,
//           size: displayWidth(context) * 0.025,
//         ),
//       ),
//       actions: [
//         IconButton(
//           color: Colors.white,
//           onPressed: () {
//             _addBranch();
//           },
//           icon: Icon(Icons.add_circle),
//         ),
//         SizedBox(width: 12.0),
//         IconButton(
//           color: Colors.white,
//           onPressed: isFormValid ? () => _saveBranch() : null,
//           icon: Icon(Icons.save_rounded),
//         ),
//         IconButton(
//           color: Colors.white,
//           iconSize: 24,
//           onPressed: () {
//             _deleteBranch();
//           },
//           icon: Icon(
//             Icons.delete,
//           ),
//         ),
//         SizedBox(width: 16),
//         Obx(() => Text(
//           branchController.saveStatus.value,
//           style: TextStyle(color: Colors.white),
//         )),
//       ],
//     );
//   }
//
//   void _goToNextBranch() {
//     if (branchController.currentBranch.value <
//         branchController.totalBranches.value) {
//       branchController.goToNextBranch();
//       _loadBranchValues();
//     }
//   }
//
//   void _goToPreviousBranch() {
//     if (branchController.currentBranch.value > 1) {
//       branchController.goToPreviousBranch();
//       _loadBranchValues();
//     }
//   }
//
//   void _saveBranch() async {
//     Map<String, dynamic> branch = {
//       'branchNumber': int.tryParse(branchNumberController.text) ?? 0,
//       'customNumber': int.tryParse(customNumberController.text) ?? 0,
//       'arabicName': arabicNameController.text,
//       'arabicDescription': arabicDescriptionController.text,
//       'englishName': englishNameController.text,
//       'englishDescription': englishDescriptionController.text,
//       'note': noteController.text,
//       'address': addressController.text,
//     };
//
//     await LocalDataSource.insertBranch(branch);
//     await LocalDataSource.updateBranch(branch);
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text('Data saved successfully'),
//         backgroundColor: Colors.green,
//       ),
//     );
//   }
//
//
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       resizeToAvoidBottomInset: false,
//       appBar: buildAppBar(),
//       body: Padding(
//         padding: EdgeInsets.only(
//             left: displayWidth(context) * 0.02,
//             right: displayWidth(context) * 0.02),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             SizedBox(
//               height: displayHeight(context) * 0.03,
//             ),
//             Row(
//               children: [
//                 Container(
//                   width: displayWidth(context) * 0.6,
//                   // Increased width for branchNumber
//                   child: CustomTextField(
//                     readOnly: true,
//                     controller: branchNumberController,
//                     label: 'BranchNum',
//                     width: displayWidth(context) * 0.75,
//                     height: displayHeight(context) * 0.05,
//                   ),
//                 ),
//                 SizedBox(width: displayWidth(context) * 0.015),
//                 Expanded(
//                   child: Container(
//                     width: displayWidth(context) * 0.35,
//                     // Reduced width for customNumber
//                     child: CustomTextField(
//                       controller: customNumberController,
//                       label: 'CustomNum',
//                       width: displayWidth(context) * 0.25,
//                       height: displayHeight(context) * 0.05,
//                       validator: (value) {
//                         if (value == null || value.isEmpty) {
//                           return 'CustomNumber is required';
//                         }
//                         return null;
//                       },
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             SizedBox(height: displayHeight(context) * 0.03),
//             CustomTextField(
//               controller: arabicNameController,
//               label: 'Arabic name ',
//               validator: (value) {
//                 if (value == null || value.isEmpty) {
//                   return 'Arabic Name is required';
//                 }
//                 return null;
//               },
//               width: displayWidth(context) * 1,
//               height: displayHeight(context) * 0.05,
//             ),
//             SizedBox(height: displayHeight(context) * 0.03),
//             CustomTextField(
//               controller: arabicDescriptionController,
//               label: 'Arabic Descrption',
//               validator: (value) {
//                 if (value == null || value.isEmpty) {
//                   return 'Arabic Descrption is required';
//                 }
//                 return null;
//               },
//               width: displayWidth(context) * 1,
//               height: displayHeight(context) * 0.05,
//             ),
//             SizedBox(height: displayHeight(context) * 0.03),
//             CustomTextField(
//                 controller: englishNameController,
//                 label: 'English Name',
//                 width: displayWidth(context) * 1,
//                 height: displayHeight(context) * 0.05,
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'English Name is required';
//                   }
//                   return null;
//                 }),
//             SizedBox(height: displayHeight(context) * 0.03),
//             CustomTextField(
//               controller: englishDescriptionController,
//               label: 'English Descrption',
//               validator: (value) {
//                 if (value == null || value.isEmpty) {
//                   return 'English Descrption is required';
//                 }
//                 return null;
//               },
//               width: displayWidth(context) * 1,
//               height: displayHeight(context) * 0.05,
//             ),
//             SizedBox(height: displayHeight(context) * 0.03),
//             CustomTextField(
//               controller: noteController,
//               label: 'Note',
//               width: displayWidth(context) * 1,
//               height: displayHeight(context) * 0.05,
//             ),
//             SizedBox(height: displayHeight(context) * 0.03),
//             CustomTextField(
//               controller: addressController,
//               label: 'Adress',
//               validator: (value) {
//                 if (value == null || value.isEmpty) {
//                   return 'Adress is required';
//                 }
//                 return null;
//               },
//               width: displayWidth(context) * 1,
//               height: displayHeight(context) * 0.05,
//             ),
//             SizedBox(height: displayHeight(context) * 0.03),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 IconButton(
//                   onPressed: _goToPreviousBranch,
//                   icon: Icon(
//                     Icons.keyboard_double_arrow_left_outlined,
//                     color: Colors.indigo,
//                   ),
//                 ),
//                 Obx(() => Text(
//                   '${branchController.currentBranch.value}/${branchController.totalBranches.value}',
//                   style: TextStyle(fontSize: 24),
//                 )),
//                 IconButton(
//                   onPressed: _goToNextBranch,
//                   icon: Icon(
//                     Icons.keyboard_double_arrow_right_outlined,
//                     color: Colors.indigo,
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }}