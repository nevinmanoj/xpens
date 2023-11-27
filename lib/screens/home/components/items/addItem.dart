import 'package:flutter/material.dart';
import '../../../../../shared/constants.dart';

class AddItemWidget extends StatefulWidget {
  final String tag;
  final Function(String) addFunc;
  const AddItemWidget({super.key, required this.tag, required this.addFunc});

  @override
  State<AddItemWidget> createState() => _AddItemWidgetState();
}

class _AddItemWidgetState extends State<AddItemWidget> {
  Color backdropColor = Color(0x66C4C4C4);
  bool showFilter = false;
  double _height = 0;
  bool showError = false;
  TextEditingController nameController = TextEditingController();
  void toggleFilter() {
    if (showFilter) {
      //hide filter
      setState(() {
        backdropColor = Colors.white;
        _height = 0;
        showFilter = false;
      });
    } else {
      //show filter
      setState(() {
        backdropColor = Color(0x66C4C4C4);
        _height = 150;
        showFilter = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double ht = MediaQuery.of(context).size.height;
    double wt = MediaQuery.of(context).size.width;

    if (showFilter) {
      return SizedBox(
        height: ht,
        child: Stack(
          children: [
            InkWell(
              onTap: toggleFilter,
              child: AnimatedContainer(
                duration: Duration(milliseconds: 1000),
                curve: Curves.fastOutSlowIn,
                color: backdropColor,
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: AnimatedContainer(
                // padding: EdgeInsets.only(top: 20),
                decoration: const BoxDecoration(
                  // color: primaryAppColor,
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(40),
                      topLeft: Radius.circular(40)),
                ),
                height: _height,
                width: wt,
                duration: Duration(milliseconds: 1000),
                curve: Curves.fastOutSlowIn,
                child: Stack(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 60),
                      child: Column(
                        // crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                    padding: EdgeInsets.only(left: 10),
                                    margin: EdgeInsets.only(right: 10),
                                    decoration: addInputDecoration,
                                    width: wt * 0.7,
                                    height: ht * 0.055,
                                    child: TextFormField(
                                      cursorColor: primaryAppColor,
                                      cursorWidth: 1,
                                      controller: nameController,
                                      keyboardType: TextInputType.text,
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintStyle: TextStyle(
                                            color:
                                                Colors.grey.withOpacity(0.8)),
                                        hintText: 'Enter ${widget.tag} name',
                                      ),
                                    )),
                                SizedBox(
                                  height: ht * 0.055,
                                  child: ElevatedButton(
                                      style: buttonDecoration,
                                      onPressed: () async {
                                        if (nameController.text.isEmpty) {
                                          setState(() {
                                            showError = true;
                                          });
                                          Future.delayed(Duration(seconds: 2),
                                              () {
                                            setState(() {
                                              showError = false;
                                            });
                                          });
                                        } else {
                                          widget.addFunc(nameController.text);
                                          toggleFilter();
                                        }
                                      },
                                      child: Text("Add")),
                                ),
                              ]),
                          showError
                              ? Text(
                                  "Note: ${widget.tag} name cannot be empty",
                                  style: TextStyle(color: Colors.red),
                                )
                              : Container()
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(0, ht * 0.02, wt * 0.08, 0),
                      child: Align(
                        alignment: Alignment.topRight,
                        child: InkWell(
                          onTap: toggleFilter,
                          child: Icon(Icons.close),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      );
    }
    return Positioned(
      bottom: 10,
      right: 10,
      child: InkWell(
        onTap: toggleFilter,
        child: Container(
          height: 56,
          width: 56,
          decoration:
              BoxDecoration(color: primaryAppColor, shape: BoxShape.circle),
          child: Icon(
            Icons.add,
            color: secondaryAppColor,
          ),
        ),
      ),
    );
  }
}
