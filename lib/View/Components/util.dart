import 'package:ame_facedetector/View/Theme/colors.dart';
import 'package:ame_facedetector/View/Theme/style.dart';
import 'package:flutter/material.dart';

// void toastMessage({required String message, Color? colors}){
//   Fluttertoast.showToast(
//     msg: message,
//     toastLength: Toast.LENGTH_SHORT,
//     gravity: ToastGravity.BOTTOM,
//     timeInSecForIosWeb: 1,
//     backgroundColor: colors ?? Color(0xFF8DBF8B),
//     textColor: kWhiteColor,
//     fontSize: 16.0,
//   );
// }

GestureDetector kIconDesign(context, {
  required String image,
  required String title,
  Function()? onClick
}) {
  return GestureDetector(
    onTap: onClick,
    child: Column(
      children: [
        Expanded(
          child: Container(
            width: MediaQuery.of(context).size.width*0.3,
            padding: EdgeInsets.all(5.0),
            decoration: BoxDecoration(
              color: kMainColor.withOpacity(0.4),
              image: DecorationImage(
                image: NetworkImage(image),
                fit: BoxFit.cover,
              ),
            ),
            // child: image != '' ? Image.network(image) : SizedBox.shrink(),
          ),
        ),
        SizedBox(height: 3.0),
        Text(title, style: k12Text(), overflow: TextOverflow.ellipsis),
      ],
    ),
  );
}

GestureDetector productIconDesign(context, {
  required String image,
  required String title,
  Function()? onClick
}) {
  return GestureDetector(
    onTap: onClick,
    child: Column(
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor != Colors.black ? kMainColor.withOpacity(0.4) : kDarkColor,
              image: DecorationImage(
                image: NetworkImage(image),
                fit: BoxFit.cover,
              ),
            ),
            // child: image != '' ? Image.network(image) : SizedBox.shrink(),
          ),
        ),
        SizedBox(height: 3.0),
        Text(title, style: k12Text(), overflow: TextOverflow.ellipsis),
      ],
    ),
  );
}

Color toColor(String? boardColor){
  if (boardColor == null) {
    return Colors.red;
  }
  var t = int.tryParse(boardColor);
  if (t != null) {
    return Color(t);
  }
  return Colors.red;
}

class LoadingIcon extends StatelessWidget {
  const LoadingIcon({super.key});

  @override
  Widget build(BuildContext context) {
    // return Center(child: CircularProgressIndicator(color: kMainColor));
    return Center(child: Image.asset('images/khwahish_gif.gif'));
  }
}

Widget dashLines() {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 10.0),
    child: Row(
      children: List.generate(300~/5, (index) => Expanded(
        child: Container(
          color: index % 2 != 0? Colors.transparent :Colors.grey,
          height: 1,
        ),
      )),
    ),
  );
}

// String kAmount(num amount) {
//   NumberFormat indianCurrencyFormat = NumberFormat.currency(
//     locale: 'en_IN',
//     symbol: '₹',
//     decimalDigits: 0,
//   );
//   return indianCurrencyFormat.format(amount) ?? 'NAN';
// }
