

import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class LocalDataSource {
  static const String _branchKey = 'branches';

  static Future<void> insertBranch(Map<String, dynamic> branch) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> branches = prefs.getStringList(_branchKey) ?? [];
    branches.add(jsonEncode(branch));
    await prefs.setStringList(_branchKey, branches);
  }

  static Future<void> updateBranch(Map<String, dynamic> branch) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> branches = prefs.getStringList(_branchKey) ?? [];
    int index = branches.indexWhere((b) => jsonDecode(b)['branchNumber'] == branch['branchNumber']);
    if (index != -1) {
      branches[index] = jsonEncode(branch);
      await prefs.setStringList(_branchKey, branches);
    }
  }

  static Future<void> deleteBranch(int branchNumber) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> branches = prefs.getStringList(_branchKey) ?? [];
    branches.removeWhere((b) => jsonDecode(b)['branchNumber'] == branchNumber);
    await prefs.setStringList(_branchKey, branches);
  }

  static Future<List<Map<String, dynamic>>> getBranches() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> branches = prefs.getStringList(_branchKey) ?? [];
    return branches.map<Map<String, dynamic>>((b) => jsonDecode(b)).toList();
  }

}
