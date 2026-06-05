import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:xpens/screens/home/settings/creditPayments/cards/cardAddEdit.dart';
import 'package:xpens/shared/constants.dart';

import '../../../../../services/providers/UserInfoProvider.dart';

class CardsMain extends StatefulWidget {
  const CardsMain({super.key});

  @override
  State<CardsMain> createState() => _CardsMainState();
}

class _CardsMainState extends State<CardsMain> {
  @override
  Widget build(BuildContext context) {
    double wt = MediaQuery.of(context).size.width;
    double ht = MediaQuery.of(context).size.height;

    UserInfoProvider userInfo = Provider.of<UserInfoProvider>(context);

    return Stack(
      children: [
        // ListView.builder(
        //     physics: const BouncingScrollPhysics(),
        //     itemCount: cards.length,
        //     itemBuilder: (BuildContext context, int i) {
        //       double pointsPerRupee;
        //       double points = cards[i].points;
        //       double rupees = cards[i].rupees;
        //       if (rupees == 0) {
        //         pointsPerRupee = 0;
        //       } else {
        //         pointsPerRupee = points / rupees;
        //       }
        //       return InkWell(
        //         onTap: () {
        //           showDialog(
        //               context: context,
        //               builder: (_) {
        //                 return CardEdit(
        //                   card: cards[i],
        //                   sum: sums[i],
        //                 );
        //               });
        //         },
        //         child: Padding(
        //           padding:
        //               EdgeInsets.fromLTRB(wt * 0.05, ht * 0.01, wt * 0.05, 0),
        //           child: Container(
        //               padding: EdgeInsets.fromLTRB(wt * 0.05, 0, 0, 0),
        //               decoration: BoxDecoration(
        //                 borderRadius: BorderRadius.circular(15),
        //                 boxShadow: const [
        //                   BoxShadow(
        //                       blurRadius: 1,
        //                       color: Colors.grey,
        //                       offset: Offset(0.0, 2))
        //                 ],
        //                 color: Colors.white,
        //               ),
        //               width: wt,
        //               height: ht * 0.075,
        //               child: Row(
        //                 children: [
        //                   Column(
        //                     mainAxisAlignment: MainAxisAlignment.center,
        //                     crossAxisAlignment: CrossAxisAlignment.start,
        //                     children: [
        //                       Text(
        //                         cards[i].name,
        //                         style: const TextStyle(fontSize: 18),
        //                       ),
        //                       Text(
        //                         "${sums[i].toInt().toString()} points spent ≈ ${(sums[i] ~/ pointsPerRupee).toInt().toString()} ₹",
        //                         style: const TextStyle(
        //                             fontSize: 13,
        //                             color: Color.fromARGB(255, 143, 134, 134)),
        //                       ),
        //                     ],
        //                   ),
        //                   const Spacer(),
        //                   IconButton(

        //                       // onPressed:null,
        //                       onPressed: () async {
        //                         await showDialog(
        //                             context: context,
        //                             builder: (_) {
        //                               return ActionConfirm(
        //                                 cancel: () {
        //                                   Navigator.pop(context);
        //                                 },
        //                                 confirm: () async {
        //                                   await DatabaseService(uid: user!.uid)
        //                                       .deletePointSource(
        //                                           cards[i].selfId);

        //                                   Navigator.pop(context);
        //                                 },
        //                                 title: "Delete Card",
        //                                 msg:
        //                                     "Press Confirm to delete ${cards[i].name}  from the List.",
        //                               );
        //                             });
        //                         FocusManager.instance.primaryFocus!.unfocus();
        //                       },
        //                       icon: const Icon(Icons.delete))
        //                 ],
        //               )),
        //         ),
        //       );
        //     }),
        Positioned(
          bottom: 10,
          right: 10,
          child: InkWell(
            onTap: () => Navigator.push(
                context,
                CupertinoPageRoute(
                    builder: (context) =>
                        const CardAddEdit(isEditMode: false))),
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
        )
      ],
    );
  }
}
