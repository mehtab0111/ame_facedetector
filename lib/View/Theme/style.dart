import 'package:ame_facedetector/View/Theme/colors.dart';
import 'package:flutter/material.dart';

TextStyle kHeaderStyle() => TextStyle(fontSize: 18, fontWeight: FontWeight.bold);
TextStyle kWhiteHeaderStyle() => TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white);
TextStyle kBoldStyle() => TextStyle(fontSize: 16, fontWeight: FontWeight.w600);
TextStyle k14BoldStyle() => TextStyle(fontSize: 14, fontWeight: FontWeight.w600);
TextStyle kSmallText() => TextStyle(fontSize: 14);
TextStyle k12Text() => TextStyle(fontSize: 12);
TextStyle k10Text() => TextStyle(fontSize: 10);
TextStyle k16Style() => TextStyle(fontSize: 16);
TextStyle kLargeStyle() => TextStyle(fontSize: 22, fontWeight: FontWeight.bold);
TextStyle linkTextStyle() => TextStyle(color: Colors.black54, fontWeight: FontWeight.bold, fontSize: 16);
TextStyle kWhiteTextStyle() => TextStyle(color: kWhiteColor);
TextStyle tagTextStyle() => TextStyle(fontSize: 12, color: kWhiteColor);

double kIconSize() => 18.0;
SizedBox kSpace() => SizedBox(height: 15.0);
Divider kDivider() => Divider(thickness: 1);
SizedBox kBottomSpace() => SizedBox(height: 90.0);

RoundedRectangleBorder materialButtonDesign() {
  return RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0));
}

RoundedRectangleBorder bottomSheetRoundedDesign() {
  return RoundedRectangleBorder(
    borderRadius: BorderRadius.vertical(
      top: Radius.circular(15.0),
    ),
  );
}

BoxDecoration containerDesign(context) {
  return BoxDecoration(
    color: Theme.of(context).scaffoldBackgroundColor != Colors.black ? Colors.white : kDarkColor,
  );
}

BoxDecoration roundedContainerDesign(context) {
  return BoxDecoration(
    color: Theme.of(context).scaffoldBackgroundColor != Colors.black ? Colors.white : kDarkColor,
    borderRadius: BorderRadius.circular(10.0),
  );
}

BoxDecoration roundedShadedDesign(context) {
  return BoxDecoration(
    color: Theme.of(context).scaffoldBackgroundColor != Colors.black ? Colors.white : kDarkColor,
    borderRadius: BorderRadius.circular(10.0),
    boxShadow: boxShadowDesign(),
  );
}

BoxDecoration blurCurveDecor(BuildContext context) {
  return BoxDecoration(
    color: Theme.of(context).scaffoldBackgroundColor != Colors.black ?
    Colors.white.withOpacity(0.6) : kDarkColor.withOpacity(0.7),
    borderRadius: BorderRadius.circular(0.0),
  );
}

List<BoxShadow> boxShadowDesign() {
  return [
    BoxShadow(
      color: kMainColor.withOpacity(0.4),
      spreadRadius: 2.0,
      blurRadius: 2.0,
      offset: Offset(1,2),
    ),
  ];
}

LinearGradient kBottomShadedShadow() {
  return LinearGradient(
    colors: [Colors.black.withOpacity(0.6), Colors.transparent],
    begin: Alignment.bottomCenter,
    end: Alignment.topCenter,
    stops: const [0.0, 1.0],
    tileMode: TileMode.clamp,
  );
}

BoxDecoration dropTextFieldDesign(context) {
  return BoxDecoration(
    // color: Theme.of(context).scaffoldBackgroundColor,
    borderRadius: BorderRadius.circular(5.0),
    border: Border.all(width: 0.5, color: Colors.grey.shade400),
  );
}

Widget kWhiteRowText(String title, String detail) {
  return Column(
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: kWhiteTextStyle()),
          Spacer(),
          Text(detail, style: kWhiteTextStyle()),
        ],
      ),
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 5.0),
        child: Divider(
          thickness: 1,
          color: kWhiteColor,
        ),
      ),
    ],
  );
}

Column kColumnText(context, String title, String desc) {
  return Column(
    children: [
      Text(title, style: kBoldStyle()),
      Container(
        padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 3.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: Colors.grey.withOpacity(0.4),
        ),
        child: Text(desc),
      ),
    ],
  );
}

Row kRowText(String title, String desc){
  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(title, style: kBoldStyle()),
      Expanded(child: Text(desc)),
    ],
  );
}

Row kRowSpaceText(String title, String desc){
  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(title, style: k14BoldStyle()),
      SizedBox(width: 10.0),
      Expanded(child: Text(desc, style: kSmallText(), textAlign: TextAlign.end)),
    ],
  );
}

LinearGradient shadedTopGradient() {
  return LinearGradient(
    begin: Alignment.topCenter,
    end: FractionalOffset.bottomCenter,
    stops: const [0.0, 1.0],
    // colors: [Color(0xffA66DD4).withOpacity(0.5), Colors.transparent],
    colors: [kMainColor.withOpacity(0.5), Colors.transparent],
  );
}

BoxDecoration kBackgroundDesign(BuildContext context) {
  return BoxDecoration(
    image: DecorationImage(
      image: AssetImage('images/bg2.png'),
      fit: BoxFit.cover,
      colorFilter: ColorFilter.mode(
        Theme.of(context).scaffoldBackgroundColor != Colors.black ?
        Colors.white.withOpacity(0.4) : Colors.black.withOpacity(0.4),
        BlendMode.srcATop,
      ),
    ),
  );
}

// EdgeInsets kResponsivePadding(BuildContext context) {
//   return EdgeInsets.symmetric(
//     horizontal: Responsive.isMobile(context) ? 10 :
//     Responsive.isTablet(context) ? 80 : 200,
//   );
// }
//
// EdgeInsets kResponsive(BuildContext context) {
//   return EdgeInsets.symmetric(
//     horizontal: Responsive.isMobile(context) ? 0 :
//     Responsive.isTablet(context) ? 80 : 200,
//   );
// }
