import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:xpens/screens/home/components/ItemInput/calendar.dart';
import 'package:xpens/screens/home/components/ItemInput/cost.dart';
import 'package:xpens/services/creditPaymentDatabase.dart';
import 'package:xpens/shared/constants.dart';
import 'package:xpens/shared/dataModals/dbModals/creditCard.dart';

class CardAddEdit extends StatefulWidget {
  final CreditCard? cardToEdit;
  final bool isEditMode;

  const CardAddEdit({super.key, required this.isEditMode, this.cardToEdit});

  @override
  State<CardAddEdit> createState() => _CardAddEditState();
}

class _CardAddEditState extends State<CardAddEdit> {
  final formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController creditLimitController = TextEditingController();
  TextEditingController annualFeeController = TextEditingController();
  TextEditingController statementDayController = TextEditingController();
  TextEditingController dueInDaysController = TextEditingController();
  DateTime joiningDate = DateTime.now();
  @override
  void initState() {
    if (widget.isEditMode) {
      nameController.text = widget.cardToEdit?.cardName ?? "";
      creditLimitController.text =
          widget.cardToEdit?.creditLimit.toString() ?? "";
      annualFeeController.text = widget.cardToEdit?.annualFee.toString() ?? "";
      statementDayController.text =
          widget.cardToEdit?.statementDay.toString() ?? "";
      dueInDaysController.text = widget.cardToEdit?.dueInDays.toString() ?? "";
      joiningDate = widget.cardToEdit?.joiningDate ?? DateTime.now();
    } else {
      // Set default values for add mode
      nameController.text = "";
      creditLimitController.text = "";
      annualFeeController.text = "";
      statementDayController.text = "";
      dueInDaysController.text = "";
      joiningDate = DateTime.now();
    }
    super.initState();
  }

  void onDateChanged(DateTime? date) {
    setState(() {
      joiningDate = date ?? DateTime.now();
    });
  }

  int getControllerValueAsInt(TextEditingController controller) =>
      int.tryParse(controller.text) ?? 0;

  double getControllerValueAsDouble(TextEditingController controller) =>
      double.tryParse(controller.text) ?? 0.0;
  void resetControllers() {
    nameController.text = "";
    creditLimitController.text = "";
    annualFeeController.text = "";
    statementDayController.text = "";
    dueInDaysController.text = "";
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User?>(context);
    double wt = MediaQuery.of(context).size.width;
    double ht = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.isEditMode ? "Edit Card" : "Add Card"),
        backgroundColor: primaryAppColor,
      ),
      body: Form(
        key: formKey,
        child: Center(
          child: SingleChildScrollView(
            child: Center(
              child: SizedBox(
                child: Column(
                  children: [
                    Container(
                        padding: const EdgeInsets.only(left: 10),
                        // margin: const EdgeInsets.only(right: 10),
                        decoration: addInputDecoration,
                        width: wt * 0.8,
                        height: ht * 0.055,
                        child: TextFormField(
                          validator: (value) =>
                              value!.isEmpty ? 'Name cannot be empty' : null,
                          cursorColor: primaryAppColor,
                          cursorWidth: 1,
                          controller: nameController,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintStyle:
                                TextStyle(color: Colors.grey.withOpacity(0.8)),
                            hintText: 'Enter card name',
                          ),
                        )),
                    const SizedBox(
                      height: 20,
                    ),
                    ItemQuantity(
                      costs: creditLimitController.text,
                      req: true,
                      enabled: true,
                      hint: 'Credit Limit',
                      onctrlchange: (val) {
                        setState(() {
                          creditLimitController = val;
                        });
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    ItemQuantity(
                      costs: annualFeeController.text,
                      req: true,
                      enabled: true,
                      hint: 'Annual Fee',
                      onctrlchange: (val) {
                        setState(() {
                          annualFeeController = val;
                        });
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    ItemQuantity(
                      validator: (value) {
                        int? day = int.tryParse(value!);
                        if (day == null || day < 1 || day > 31) {
                          return 'Please enter a valid day of the month (1-31)';
                        }
                        return null;
                      },
                      costs: statementDayController.text,
                      req: true,
                      enabled: true,
                      hint: 'Statement day of month(1-31)',
                      onctrlchange: (val) {
                        setState(() {
                          statementDayController = val;
                        });
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    ItemQuantity(
                      validator: (value) {
                        int? days = int.tryParse(value!);
                        if (days == null || days < 1 || days > 31) {
                          return 'Please enter valid a no fo days';
                        }
                        return null;
                      },
                      costs: dueInDaysController.text,
                      req: true,
                      enabled: true,
                      hint: 'Due in (days)',
                      onctrlchange: (val) {
                        setState(() {
                          dueInDaysController = val;
                        });
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Calendar(
                        onDateChanged: onDateChanged,
                        dateToDisplay: joiningDate,
                        isData: true),
                    const SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      height: ht * 0.055,
                      child: ElevatedButton(
                          style: buttonDecoration,
                          onPressed: () async {
                            if (formKey.currentState!.validate()) {
                              if (widget.isEditMode) {
                                await CreditPaymentDatabaseService(
                                        uid: user!.uid)
                                    .updateCreditCard(CreditCard(
                                  id: widget.cardToEdit!.id,
                                  cardName: nameController.text,
                                  creditLimit: getControllerValueAsDouble(
                                      creditLimitController),
                                  annualFee: getControllerValueAsDouble(
                                      annualFeeController),
                                  statementDay: getControllerValueAsInt(
                                      statementDayController),
                                  dueInDays: getControllerValueAsInt(
                                      dueInDaysController),
                                  joiningDate: joiningDate,
                                ));
                              } else {
                                await CreditPaymentDatabaseService(
                                        uid: user!.uid)
                                    .addCreditCard(CreditCard(
                                        id: "place_holder",
                                        cardName: nameController.text,
                                        creditLimit: getControllerValueAsDouble(
                                            creditLimitController),
                                        annualFee: getControllerValueAsDouble(
                                            annualFeeController),
                                        statementDay: getControllerValueAsInt(
                                            statementDayController),
                                        dueInDays: getControllerValueAsInt(
                                            dueInDaysController),
                                        joiningDate: joiningDate));
                              }
                              resetControllers();
                              Navigator.pop(context);
                            }
                          },
                          child: Text(widget.isEditMode ? "Edit" : "Add")),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
