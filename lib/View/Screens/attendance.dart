import 'package:ame_facedetector/View/Components/util.dart';
import 'package:ame_facedetector/View/Theme/style.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Attendance extends StatefulWidget {
  const Attendance({super.key});

  @override
  State<Attendance> createState() => _AttendanceState();
}

class _AttendanceState extends State<Attendance> {

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Attendance'),
      ),
      body: StreamBuilder(
        stream: _firestore.collection('attendance').orderBy('clockIn', descending: true).snapshots(),
        builder: (context, snapshot) {
          if(snapshot.hasData){
            var data = snapshot.data!.docs;
            return ListView.separated(
              shrinkWrap: true,
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              physics: BouncingScrollPhysics(),
              itemCount: data.length,
              itemBuilder: (context, index){
                return Container(
                  padding: EdgeInsets.all(8),
                  decoration: roundedShadedDesign(context),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      StreamBuilder(
                        stream: _firestore.collection('employee').doc('${data[index]['userID']}').snapshots(),
                        builder: (context, snapshot2) {
                          if(snapshot2.hasData){
                            var user = snapshot2.data!.data();
                            return Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  height: 80,
                                  width: 80,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    image: DecorationImage(
                                      image: NetworkImage('${user!['image']}'),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      kRowText('Name: ', '${user['name']}'),
                                      kRowText('UserID: ', '${data[index]['userID']}'),
                                      kRowText('Mobile: ', '${user['mobile']}'),
                                      kRowText('email: ', '${user['email']}'),
                                    ],
                                  ),
                                ),
                              ],
                            );
                          }
                          return Container();
                        }
                      ),
                      Text('Clock In: ${DateFormat('dd-MM-yyyy - hh:mm a').format(DateTime.parse('${data[index]['clockIn'].toDate()}'))}'),
                    ],
                  ),
                );
              },
              separatorBuilder: (BuildContext context, int index) {
                return kSpace();
              },
            );
          }
          return LoadingIcon();
        }
      ),
    );
  }
}
