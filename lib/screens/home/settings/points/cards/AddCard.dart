import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:xpens/screens/home/components/ItemInput/cost.dart';
import 'package:xpens/screens/home/settings/dev/injectData.dart';
import 'package:xpens/services/database.dart';
import 'package:xpens/shared/constants.dart';
import 'package:xpens/shared/dataModals/dbModals/pointSource.dart';

class AddCard extends StatefulWidget {
  const AddCard({
    super.key,
  });

  @override
  State<AddCard> createState() => _AddCardState();
}

class _AddCardState extends State<AddCard> {
  Color backdropColor = const Color(0x66C4C4C4);
  bool showFilter = false;
  double _height = 0;
  bool showError = false;
  final formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController pointController = TextEditingController();
  TextEditingController rupeeController = TextEditingController();
  double getControllerValueasDouble(TextEditingController controller) {
    double val = 0;
    if (controller.text.isNotEmpty) {
      val = double.parse(controller.text);
    }
    return val;
  }

  void toggleFilter() {
    pointController.text = "";
    rupeeController.text = "";
    nameController.text = "";
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
        backdropColor = const Color(0x66C4C4C4);
        _height = 300;
        showFilter = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double ht = MediaQuery.of(context).size.height;
    double wt = MediaQuery.of(context).size.width;
    final user = Provider.of<User?>(context);
    double pointsPerRupee;
    double points = getControllerValueasDouble(pointController);
    double rupees = getControllerValueasDouble(rupeeController);
    if (rupees == 0) {
      pointsPerRupee = 0;
    } else {
      pointsPerRupee = points / rupees;
    }

    if (showFilter) {
      return SizedBox(
        height: ht,
        child: Stack(
          children: [
            InkWell(
              onTap: toggleFilter,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 1000),
                curve: Curves.fastOutSlowIn,
                color: backdropColor,
              ),
            ),
            Positioned(
              bottom: 0,
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
                duration: const Duration(milliseconds: 1000),
                curve: Curves.fastOutSlowIn,
                child: Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 60),
                      child: Form(
                        key: formKey,
                        child: Column(
                          // crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                                padding: const EdgeInsets.only(left: 10),
                                // margin: const EdgeInsets.only(right: 10),
                                decoration: addInputDecoration,
                                width: wt * 0.8,
                                height: ht * 0.055,
                                child: TextFormField(
                                  validator: (value) => value!.isEmpty
                                      ? 'name cannot be empty'
                                      : null,
                                  cursorColor: primaryAppColor,
                                  cursorWidth: 1,
                                  controller: nameController,
                                  keyboardType: TextInputType.text,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintStyle: TextStyle(
                                        color: Colors.grey.withOpacity(0.8)),
                                    hintText: 'Enter card name',
                                  ),
                                )),
                            showError
                                ? const Text(
                                    "Note: card name cannot be empty",
                                    style: TextStyle(color: Colors.red),
                                  )
                                : Container(),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                SizedBox(
                                  width: wt * 0.3,
                                  child: ItemQuantity(
                                    costs: '',
                                    req: true,
                                    enabled: true,
                                    hint: 'Points',
                                    onctrlchange: (val) {
                                      setState(() {
                                        pointController = val;
                                      });
                                    },
                                  ),
                                ),
                                SizedBox(
                                  width: wt * 0.1,
                                  child: const Center(
                                    child: Text(
                                      "≈",
                                      style: TextStyle(fontSize: 20),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: wt * 0.3,
                                  child: ItemQuantity(
                                    costs: '',
                                    req: true,
                                    enabled: true,
                                    hint: 'Rupees',
                                    onctrlchange: (val) {
                                      setState(() {
                                        rupeeController = val;
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),
                            Text(
                                "Average: ${pointsPerRupee.toStringAsFixed(2)} points/₹"),
                            const SizedBox(
                              height: 10,
                            ),
                            SizedBox(
                              height: ht * 0.055,
                              child: ElevatedButton(
                                  style: buttonDecoration,
                                  onPressed: () async {
                                    if (formKey.currentState!.validate()) {
                                      await DatabaseService(uid: user!.uid)
                                          .addPointSource(PointSource(
                                              name: nameController.text,
                                              rupees: rupees,
                                              points: points,
                                              selfId: "palce_holder"));
                                      pointController.text = "";
                                      rupeeController.text = "";
                                      nameController.text = "";
                                      toggleFilter();
                                    }
                                  },
                                  child: const Text("Add")),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(0, ht * 0.02, wt * 0.08, 0),
                      child: Align(
                        alignment: Alignment.topRight,
                        child: InkWell(
                          onTap: toggleFilter,
                          child: const Icon(Icons.close),
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
          decoration: const BoxDecoration(
              color: primaryAppColor, shape: BoxShape.circle),
          child: const Icon(
            Icons.add_card,
            color: secondaryAppColor,
          ),
        ),
      ),
    );
  }
}
