import 'package:ame_facedetector/View/Theme/colors.dart';
import 'package:ame_facedetector/View/Theme/style.dart';
import 'package:flutter/material.dart';

class KButton extends StatelessWidget {

  String title;
  Function() onClick;
  Color? color;
  KButton({Key? key, required this.title, required this.onClick, this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      height: 40,
      minWidth: MediaQuery.of(context).size.width*0.9,
      shape: materialButtonDesign(),
      color: color ?? kButtonColor,
      textColor: kBTextColor,
      onPressed: onClick,
      child: Text(title.toUpperCase(), style: k16Style(),),
    );
  }
}

class K2Button extends StatelessWidget {

  String title;
  Function() onClick;
  Color? color;
  K2Button({Key? key, required this.title, required this.onClick, this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      style: ButtonStyle(
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
        ),
        side: MaterialStateProperty.all(BorderSide(color: color ?? kRedColor)),
        foregroundColor: MaterialStateProperty.all(color ?? kRedColor),
      ),
      onPressed: onClick,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(title),
        ],
      ),
    );
  }
}

class LoadingButton extends StatelessWidget {

  Color? color;
  LoadingButton({Key? key, this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      height: 40,
      minWidth: MediaQuery.of(context).size.width*0.9,
      shape: materialButtonDesign(),
      color: color ?? kButtonColor,
      textColor: kBTextColor,
      onPressed: (){},
      child: CircularProgressIndicator(
        color: kWhiteColor,
      ),
    );
  }
}

class LoginButton extends StatelessWidget {

  String title, image;
  Function() onClick;
  LoginButton({required this.title, required this.image, required this.onClick,
    Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      height: 45,
      color: kButtonColor,
      textColor: kWhiteColor,
      shape: materialButtonDesign(),
      onPressed: onClick,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(title),
          SizedBox(width: 10.0),
          Image.asset(image, height: 25),
        ],
      ),
    );
  }
}

Widget paymentButton(BuildContext context, {
  IconData? leadingIcon,
  required String title,
  required String image,
  required Function() onClick,
}) {
  return Container(
    // decoration: roundedContainerDesign(context),
    // decoration: blurCurveDecor(context),
    decoration: containerDesign(context),
    child: ListTile(
      leading: leadingIcon != null ? Icon(leadingIcon,
          color: Theme.of(context).scaffoldBackgroundColor != Colors.black ?
          kMainColor : kWhiteColor) : Image.asset(image, height: 25,),
      title: Text(title),
      trailing: Icon(Icons.chevron_right_outlined, color: Theme.of(context).scaffoldBackgroundColor != Colors.black ? kMainColor : kWhiteColor),
      onTap: onClick,
    ),
  );
}

ListTile profileButton(IconData iconData, String title, Function() onClicked) {
  return ListTile(
    dense: true,
    leading: Icon(iconData, color: kMainColor),
    title: Text(title, style: TextStyle(fontSize: 16, fontFamily: 'Barlow'),),
    trailing: Icon(Icons.chevron_right_outlined),
    onTap: onClicked,
  );
}

Widget radioButton(context, {
  required Function() onClick, required String title, required IconData iconData
}) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
    child: Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.0),
        border: Border.all(width: 0.5),
        color: Theme.of(context).scaffoldBackgroundColor,
      ),
      child: MaterialButton(
        height: 45,
        shape: materialButtonDesign(),
        onPressed: onClick,
        child: Row(
          children: [
            Icon(iconData),
            SizedBox(width: 10.0),
            Text(title),
          ],
        ),
      ),
    ),
  );
}

class AvatarButton extends StatelessWidget {

  String title, image;
  Function() onClick;
  AvatarButton({super.key, required this.title, required this.image,
    required this.onClick});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onClick,
      child: Container(
        width: 90,
        padding: EdgeInsets.all(10.0),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: kMainColor.withOpacity(0.4),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: CircleAvatar(
                radius: 35,
                // backgroundImage: NetworkImage(image),
                backgroundImage: AssetImage(image),
                // child: Image.network(image),
              ),
            ),
            // Image.asset(image, height: 70),
            SizedBox(height: 8),
            Text(title.toUpperCase(),
              style: k12Text().copyWith(letterSpacing: 0.0, fontWeight: FontWeight.bold),
              // overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center, maxLines: 2,
            ),
          ],
        ),
      ),
    );
  }
}

Padding categoryButton(BuildContext context, {
  required String title,
  required Function() onClick,
}) {
  return Padding(
    padding: EdgeInsets.only(left: 10.0, right: 8.0),
    child: Row(
      children: [
        Text(title, style: kHeaderStyle()),
        SizedBox(width: 10.0),
        Expanded(child: Divider(thickness: 1,)),
        TextButton(
          onPressed: onClick,
          child: Text('See More'),
        ),
      ],
    ),
  );
}

