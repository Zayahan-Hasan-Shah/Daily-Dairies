// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:daily_dairies/controllers/sticker_controller.dart';
// import 'package:daily_dairies/core/colorPallete.dart';
// import 'package:cached_network_image/cached_network_image.dart';

// class DiaryStickers extends StatelessWidget {
//   final List<String> stickerIds;
//   final String diaryId;
//   final bool isEditable;

//   const DiaryStickers({
//     Key? key,
//     required this.stickerIds,
//     required this.diaryId,
//     this.isEditable = true,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final StickerController stickerController = Get.find<StickerController>();

//     return Obx(() {
//       if (stickerController.isLoading.value) {
//         return const Center(child: CircularProgressIndicator());
//       }

//       final stickers = stickerController.stickers
//           .where((sticker) => stickerIds.contains(sticker.id))
//           .toList();

//       if (stickers.isEmpty) {
//         return const SizedBox.shrink();
//       }

//       return Container(
//         padding: const EdgeInsets.all(8),
//         decoration: BoxDecoration(
//           color: Colorpallete.backgroundColor.withOpacity(0.1),
//           borderRadius: BorderRadius.circular(12),
//         ),
//         child: Wrap(
//           spacing: 8,
//           runSpacing: 8,
//           children: stickers.map((sticker) {
//             return Stack(
//               children: [
//                 CachedNetworkImage(
//                   imageUrl: sticker.imageUrl,
//                   width: 40,
//                   height: 40,
//                   fit: BoxFit.contain,
//                   placeholder: (context, url) => const SizedBox(
//                     width: 40,
//                     height: 40,
//                     child: Center(
//                       child: CircularProgressIndicator(),
//                     ),
//                   ),
//                   errorWidget: (context, url, error) => const SizedBox(
//                     width: 40,
//                     height: 40,
//                     child: Icon(
//                       Icons.error,
//                       color: Colors.red,
//                     ),
//                   ),
//                 ),
//                 if (isEditable)
//                   Positioned(
//                     right: 0,
//                     top: 0,
//                     child: GestureDetector(
//                       onTap: () {
//                         stickerController.removeStickerFromEntry(
//                             diaryId, sticker.id);
//                       },
//                       child: Container(
//                         padding: const EdgeInsets.all(2),
//                         decoration: BoxDecoration(
//                           color: Colors.red,
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                         child: const Icon(
//                           Icons.close,
//                           size: 12,
//                           color: Colors.white,
//                         ),
//                       ),
//                     ),
//                   ),
//               ],
//             );
//           }).toList(),
//         ),
//       );
//     });
//   }
// }
