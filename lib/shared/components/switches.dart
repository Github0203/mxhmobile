// import 'package:flutter/material.dart';
// import 'package:slide_switcher/slide_switcher.dart';
// import 'package:socialapp/modules/albums/loadalbums.dart';



// class SwticherComponent extends StatefulWidget {
//   @override
//   State<SwticherComponent> createState() => _SwticherComponentState();
// }

// class _SwticherComponentState extends State<SwticherComponent> {
//   int switcherIndex = 0;

//   @override
//   Widget build(BuildContext context) {
//     return 
//       Center(
//         child: SlideSwitcher(
//           children: [
//             Text(
//               switcherIndex.toString(),
//               style: TextStyle(
//                   fontSize: 15,
//                   color: switcherIndex == 0
//                       ? Colors.white.withOpacity(0.9)
//                       : Colors.grey),
//             ),
//             Text(
//               switcherIndex.toString(),
//               style: TextStyle(
//                   fontSize: 15,
//                   color: switcherIndex == 1
//                       ? Colors.white.withOpacity(0.9)
//                       : Colors.grey),
//             ),
//             // Text(
//             //   'Third',
//             //   style: TextStyle(
//             //       fontSize: 15,
//             //       color: switcherIndex == 2
//             //           ? Colors.white.withOpacity(0.9)
//             //           : Colors.grey),
//             // ),
//           ],
//           onSelect: (int index) => {
//             setState(() => switcherIndex = index),
//             LoadAlbums(),
//             },
//           containerColor: Colors.transparent,
//           containerBorder: Border.all(color: Color.fromARGB(255, 3, 119, 165)),
//           slidersGradients: const [
//             LinearGradient(
//               colors: [
//                 Color.fromRGBO(47, 105, 255, 1),
//                 Color.fromRGBO(188, 47, 255, 1),
//               ],
//             ),
//             LinearGradient(
//               colors: [
//                 Color.fromRGBO(47, 105, 255, 1),
//                 Color.fromRGBO(0, 192, 169, 1),
//               ],
//             ),
//             // LinearGradient(
//             //   colors: [
//             //     Color.fromRGBO(255, 105, 105, 1),
//             //     Color.fromRGBO(255, 62, 62, 1),
//             //   ],
//             // ),
//           ],
//           indents: 3,
//           containerHeight: 50,
//           containerWight: 315,
//         ),
//       );
   
   
//   }
// }