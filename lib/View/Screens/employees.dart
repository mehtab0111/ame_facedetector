import 'package:ame_facedetector/View/Components/textField.dart';
import 'package:ame_facedetector/View/Theme/style.dart';
import 'package:flutter/material.dart';

class Employees extends StatefulWidget {
  const Employees({super.key});

  @override
  State<Employees> createState() => _EmployeesState();
}

class _EmployeesState extends State<Employees> {

  // final StreamController _streamController = StreamController();
  final ScrollController _scrollController = ScrollController();
  TextEditingController searchText = TextEditingController();

  bool search = false;
  int userLength = 10;

  @override
  void initState() {
    super.initState();
    // getEmployeeList();
  }

  void getEmployeeList() async {
    // String url = APIData.employeeList;
    // var res = await http.post(Uri.parse(url), headers: {
    //   'Authorization': 'Bearer ${ServiceManager.tokenID}',
    // });
    // if(res.statusCode == 200){
    //   var data = jsonDecode(res.body);
    //   _streamController.add(data['Employee_list']);
    // } else {
    //   // print(res.statusCode);
    //   // print(res.body);
    // }
  }

  var docs;
  List _filteredItem = [];
  List results = [];
  void _runFilter(String enteredKeyword) {
    if (enteredKeyword.isEmpty) {
      setState(() {
        results = docs;
      });
    } else {
      results = docs.where((data) =>
          data['first_name'].toString().toLowerCase().contains(enteredKeyword.toLowerCase())).toList();
    }
    setState(() {
      _filteredItem = results;
    });
  }

  @override
  void dispose() {
    // _streamController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // final employeeProvider = Provider.of<EmployeeProvider>(context);
    return Scaffold(
      appBar: AppBar(
        // backgroundColor: k2MainColor,
        // centerTitle: true,
        titleSpacing: 0.0,
        // title: Text('Users'.toUpperCase()),
        title: search == true ? SearchTextField(
          controller: searchText,
          hintText: 'Search',
        ) : Text('Employees'),
        actions: [
          search != true ? IconButton(
            onPressed: (){
              setState(() {
                search = !search;
              });
            },
            icon: Icon(Icons.search),
          ) : IconButton(
            onPressed: (){
              setState(() {
                search = !search;
                searchText.clear();
              });
            },
            icon: Icon(Icons.close),
          ),
        ],
      ),
      body: NotificationListener<ScrollNotification>(
        onNotification: (notification) {
          if (notification is ScrollEndNotification &&
              _scrollController.position.extentAfter == 0) {
            userLength = userLength+10;
            setState(() {});
            return true;
          }
          return false;
        },
        child: SingleChildScrollView(
          controller: _scrollController,
          child: Column(
            children: [
              // _filteredItem.isNotEmpty ?
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: userLength < _filteredItem.length ? userLength : _filteredItem.length,
                // itemCount: employeeProvider.employeeList.length,
                itemBuilder: (context , index){
                  // final data = employeeProvider.employeeList;
                  final data = _filteredItem;
                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
                    child: Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 10.0, left: 30.0),
                          child: Container(
                            padding: EdgeInsets.all(10.0),
                            decoration: roundedContainerDesign(context).copyWith(
                              boxShadow: boxShadowDesign(),
                            ),
                            child: Row(
                              children: [
                                SizedBox(width: 75.0),
                                Flexible(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      // Text('ID: ${docs[index]['employee_id']}'),
                                      kRowText('Name: ', data[index].name),
                                      kRowText('Mobile: ', data[index].mobile),
                                      kRowText('Email: ', data[index].email),
                                    ],
                                  ),
                                ),
                                IconButton(
                                  onPressed: (){
                                    // Navigator.push(context, MaterialPageRoute(builder: (context) => EditEmployee(
                                    //   employeeID: '${data[index].id}',
                                    // )));
                                  },
                                  icon: Icon(Icons.edit_outlined),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          height: 100,
                          width: 100,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            boxShadow: boxShadowDesign(),
                            image: data[index].image != '' ? DecorationImage(
                              image: NetworkImage(data[index].image),
                              fit: BoxFit.cover,
                            ) : DecorationImage(
                              image: AssetImage('images/img_blank_profile.png'),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ) ,
              //     : Center(child: Container(
              //   decoration: blurCurveDecor(context),
              //   padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
              //   child: Text('No User Found', style: kHeaderStyle()),
              // )),
              if(userLength < _filteredItem.length)
                Center(child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: CircularProgressIndicator(),
                )),
              kBottomSpace(),
            ],
          ),
        ),
      ),
      // floatingActionButton: KButton(
      //   title: 'Add Employee',
      //   onClick: (){
      //     // Navigator.push(context, MaterialPageRoute(builder: (context) => AddUser()));
      //   },
      // ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
