class BranchModel {
  int branchNumber; // تم إضافة هذا الحقل
  int customNumber;
  String arabicName;
  String arabicDescription;
  String englishName;
  String englishDescription;
  String note;
  String address;

  BranchModel({
    required this.branchNumber, // تم تعديل هذا السطر
    required this.customNumber,
    required this.arabicName,
    required this.arabicDescription,
    required this.englishName,
    required this.englishDescription,
    required this.note,
    required this.address,
  });

  // تمت إضافة هذا الكود لإنشاء BranchModel بدون تحديد branchNumber
  factory BranchModel.withoutBranchNumber({
    required int customNumber,
    required String arabicName,
    required String arabicDescription,
    required String englishName,
    required String englishDescription,
    required String note,
    required String address,
  }) {
    return BranchModel(
      branchNumber: 0,
      customNumber: customNumber,
      arabicName: arabicName,
      arabicDescription: arabicDescription,
      englishName: englishName,
      englishDescription: englishDescription,
      note: note,
      address: address,
    );
  }

// الباقي كما هو
}
