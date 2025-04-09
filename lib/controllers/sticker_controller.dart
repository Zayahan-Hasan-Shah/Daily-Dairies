// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:get/get.dart';
// import 'package:daily_dairies/models/sticker_model.dart';

// class StickerController extends GetxController {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   final FirebaseAuth _auth = FirebaseAuth.instance;

//   final RxList<Sticker> stickers = <Sticker>[].obs;
//   final RxList<String> selectedStickerIds = <String>[].obs;
//   final RxBool isLoading = false.obs;

//   @override
//   void onInit() {
//     super.onInit();
//     fetchStickers();
//   }

//   Future<void> fetchStickers() async {
//     try {
//       isLoading.value = true;
//       final QuerySnapshot snapshot =
//           await _firestore.collection('stickers').get();
//       stickers.value = snapshot.docs
//           .map((doc) => Sticker.fromMap(doc.data() as Map<String, dynamic>))
//           .toList();
//     } catch (e) {
//       print('Error fetching stickers: $e');
//     } finally {
//       isLoading.value = false;
//     }
//   }

//   Future<void> addStickerToDiary(
//       String diaryId, List<String> stickerIds) async {
//     try {
//       final userId = _auth.currentUser?.uid;
//       if (userId == null) return;

//       await _firestore
//           .collection('users')
//           .doc(userId)
//           .collection('diaries')
//           .doc(diaryId)
//           .update({
//         'stickers': stickerIds,
//       });
//     } catch (e) {
//       print('Error adding stickers to diary: $e');
//     }
//   }

//   Future<void> removeStickerFromEntry(String diaryId, String stickerId) async {
//     try {
//       final userId = _auth.currentUser?.uid;
//       if (userId == null) return;

//       await _firestore
//           .collection('users')
//           .doc(userId)
//           .collection('diaries')
//           .doc(diaryId)
//           .update({
//         'stickers': FieldValue.arrayRemove([stickerId]),
//       });
//     } catch (e) {
//       print('Error removing sticker from diary: $e');
//     }
//   }

//   void toggleStickerSelection(String stickerId) {
//     if (selectedStickerIds.contains(stickerId)) {
//       selectedStickerIds.remove(stickerId);
//     } else {
//       selectedStickerIds.add(stickerId);
//     }
//   }

//   void clearSelectedStickers() {
//     selectedStickerIds.clear();
//   }
// }
