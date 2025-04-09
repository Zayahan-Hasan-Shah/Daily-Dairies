// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:daily_dairies/controllers/sticker_controller.dart';
// import 'package:daily_dairies/core/colorPallete.dart';
// import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
// import 'package:cached_network_image/cached_network_image.dart';

// class StickerSelector extends StatelessWidget {
//   final StickerController controller = Get.put(StickerController());

//   StickerSelector({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: 200,
//       decoration: BoxDecoration(
//         color: Colorpallete.backgroundColor,
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text(
//                   'Select Stickers',
//                   style: TextStyle(
//                     color: Colorpallete.textColor,
//                     fontSize: 18,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 TextButton(
//                   onPressed: () {
//                     controller.clearSelectedStickers();
//                   },
//                   child: Text(
//                     'Clear',
//                     style: TextStyle(color: Colorpallete.bottomNavigationColor),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           Expanded(
//             child: Obx(() {
//               if (controller.isLoading.value) {
//                 return const Center(child: CircularProgressIndicator());
//               }

//               return MasonryGridView.count(
//                 crossAxisCount: 4,
//                 mainAxisSpacing: 8,
//                 crossAxisSpacing: 8,
//                 itemCount: controller.stickers.length,
//                 itemBuilder: (context, index) {
//                   final sticker = controller.stickers[index];
//                   final isSelected =
//                       controller.selectedStickerIds.contains(sticker.id);

//                   return GestureDetector(
//                     onTap: () => controller.toggleStickerSelection(sticker.id),
//                     child: Container(
//                       decoration: BoxDecoration(
//                         border: Border.all(
//                           color: isSelected
//                               ? Colorpallete.bottomNavigationColor
//                               : Colors.transparent,
//                           width: 2,
//                         ),
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                       child: CachedNetworkImage(
//                         imageUrl: sticker.imageUrl,
//                         fit: BoxFit.contain,
//                         placeholder: (context, url) => const Center(
//                           child: CircularProgressIndicator(),
//                         ),
//                         errorWidget: (context, url, error) => const Icon(
//                           Icons.error,
//                           color: Colors.red,
//                         ),
//                       ),
//                     ),
//                   );
//                 },
//               );
//             }),
//           ),
//         ],
//       ),
//     );
//   }
// }
