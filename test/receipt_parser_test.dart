import 'package:flutter_test/flutter_test.dart';
import 'package:xpens/shared/utils/receiptParser.dart';

/// Builds OCR lines from a simple layout: each row is a list of
/// (text, left-x) cells, rows are 30px apart, cells are 20px tall.
/// [skew] shifts every cell down by that many px per 100px of x, to mimic
/// a slightly tilted photo.
List<OcrLine> layout(List<List<(String, double)>> rows, {double skew = 0}) => [
      for (var r = 0; r < rows.length; r++)
        for (final (text, x) in rows[r])
          OcrLine(text,
              left: x,
              right: x + text.length * 8,
              top: r * 30 + x * skew / 100,
              bottom: r * 30 + 20 + x * skew / 100),
    ];

/// One OCR line per row, everything already joined.
List<OcrLine> flat(List<String> rows) => layout([
      for (final r in rows) [(r, 0)]
    ]);

List<(String, int)> items(ParsedReceipt r) =>
    [for (final l in r.lines) (l.name, l.pricePaise)];

void main() {
  test("restaurant bill with name and price columns as separate blocks", () {
    final r = parseReceipt(layout([
      [("SPICE GARDEN RESTAURANT", 40)],
      [("GSTIN: 32ABCDE1234F1Z5", 40)],
      [("Bill No: 1042", 0), ("Table: 7", 200)],
      [("Date: 01/11/2026", 0), ("Time: 20:45", 200)],
      [("Item", 0), ("Qty", 160), ("Rate", 200), ("Amount", 260)],
      [("Paneer Tikka", 0), ("2", 160), ("125.00", 200), ("250.00", 260)],
      [("Butter Naan", 0), ("4", 160), ("40.00", 200), ("160.00", 260)],
      [("Vegetable Biryani", 0), ("1", 160), ("220.00", 200), ("220.00", 260)],
      [("Sub Total", 0), ("630.00", 260)],
      [("CGST @ 2.5%", 0), ("15.75", 260)],
      [("SGST @ 2.5%", 0), ("15.75", 260)],
      [("Round Off", 0), ("-0.50", 260)],
      [("Grand Total", 0), ("661.00", 260)],
      [("Thank you! Visit again", 40)],
    ]));

    expect(items(r), [
      ("Paneer Tikka ×2", 25000),
      ("Butter Naan ×4", 16000),
      ("Vegetable Biryani", 22000),
      ("CGST @ 2.5%", 1575),
      ("SGST @ 2.5%", 1575),
      ("Round Off", -50),
    ]);
    expect(r.lines.where((l) => l.kind == ReceiptLineKind.charge).length, 3);
    expect(r.subtotalPaise, 63000);
    expect(r.totalPaise, 66100);
    // Lines add up to the total.
    expect(r.lines.fold<int>(0, (a, l) => a + l.pricePaise), 66100);
  });

  test("tilted photo still pairs names with prices", () {
    final r = parseReceipt(layout([
      [("Masala Dosa", 0), ("90.00", 260)],
      [("Filter Coffee", 0), ("40.00", 260)],
      [("Total", 0), ("130.00", 260)],
    ], skew: 3));
    expect(items(r), [("Masala Dosa", 9000), ("Filter Coffee", 4000)]);
    expect(r.totalPaise, 13000);
  });

  test("qty x rate, currency symbols, Indian grouping, discount", () {
    final r = parseReceipt(flat([
      "Coke 2 x 60.00 120.00",
      "Family Pack ₹1,250.00",
      "Rs. 45 Water Bottle 45.00",
      "Discount 10% -137.00",
      "Net Amount 1,278.00",
    ]));
    expect(items(r), [
      ("Coke ×2", 12000),
      ("Family Pack", 125000),
      ("Water Bottle", 4500),
      ("Discount 10%", -13700),
    ]);
    expect(r.lines.last.kind, ReceiptLineKind.discount);
    expect(r.totalPaise, 127800);
  });

  test("strong total wins over plain total and item counts", () {
    final r = parseReceipt(flat([
      "Tea 20.00",
      "Total Qty 1",
      "Total 20.00",
      "Service Charge 2.00",
      "Amount Payable 22.00",
      "Cash 50.00",
      "Change 28.00",
    ]));
    expect(items(r), [("Tea", 2000), ("Service Charge", 200)]);
    expect(r.totalPaise, 2200);
  });

  test("ignores phone numbers, times and IDs", () {
    final r = parseReceipt(flat([
      "Ph: 9876543210",
      "Order ID 55821",
      "12:45",
      "01/11/2026",
      "Idli 30",
    ]));
    expect(items(r), [("Idli", 3000)]);
  });

  test("leading serial numbers are stripped, short names kept", () {
    final r = parseReceipt(flat([
      "1. Chicken Fried Rice 180.00",
      "2 Gobi Manchurian 150.00",
      "7 Up 40.00",
    ]));
    expect(items(r).map((e) => e.$1),
        ["Chicken Fried Rice", "Gobi Manchurian", "7 Up"]);
  });

  test("wrapped name uses the line above when the price row has no name", () {
    final r = parseReceipt(flat([
      "Hyderabadi Chicken Dum Biryani",
      "  320.00",
    ]));
    expect(items(r), [("Hyderabadi Chicken Dum Biryani", 32000)]);
  });

  test("label colon before an amount still counts", () {
    final r = parseReceipt(flat(["Juice: 80.00", "Grand Total:80.00"]));
    expect(items(r), [("Juice", 8000)]);
    expect(r.totalPaise, 8000);
  });

  test("comma as decimal separator", () {
    final r = parseReceipt(flat(["Croissant 3,50"]));
    expect(items(r), [("Croissant", 350)]);
  });

  test("odd lines are kept but not ticked", () {
    final r = parseReceipt(flat(["%% 99.00", "Lassi 60.00"]));
    expect(r.lines.first.suggested, isFalse);
    expect(r.lines.last.suggested, isTrue);
  });

  // Transcribed from real receipts in test/fixtures/receipts/ (git-ignored),
  // laid out the way ML Kit splits them into blocks. Phone numbers and GST
  // IDs are replaced with dummies; handwriting is left out.
  group("real receipts", () {
    test("name on its own line, '1NO' qty, stacked labels (Shifu Momos)", () {
      final r = parseReceipt(layout([
        [("SHIFU MOMOS", 60)],
        [("PANAMPILLY NAGAR", 40)],
        [("9000000000", 60)],
        [("0", 100)],
        [("A23/24 : 58552", 0), ("31/10/26 09:5", 160)],
        [("ITEM", 0), ("QTY", 60), ("PRICE", 160), ("AMOUNT", 240)],
        [("MANCHURIAN CHK F", 0)],
        [("1NO", 60), ("130.00", 160), ("130.00", 240)],
        [("ICED TEA", 0)],
        [("1NO", 60), ("40.00", 160), ("40.00", 240)],
        [("CLASSIC CHK F", 0)],
        [("1NO", 60), ("120.00", 160), ("120.00", 240)],
        [("PARCEL", 0), ("1NO", 60), ("10.00", 160), ("10.00", 240)],
        [("COLD COFFEE", 0)],
        [("1NO", 60), ("90.00", 160), ("90.00", 240)],
        [("ITEM: 5 QTY: 5", 0)],
        [("AMOUNT", 0), (":", 160), ("390.00", 240)],
        [("INCLUSIVE OF ALL TAXES", 40)],
        [("GRAND TOTAL : ₹", 0), ("390.00", 240)],
        [("THANK YOU", 60)],
        [("VISIT AGAIN", 60)],
        [("SHIFU MOMOS", 60)],
      ]));
      expect(items(r), [
        ("MANCHURIAN CHK F", 13000),
        ("ICED TEA", 4000),
        ("CLASSIC CHK F", 12000),
        ("PARCEL", 1000),
        ("COLD COFFEE", 9000),
      ]);
      expect(r.totalPaise, 39000);
    });

    test("serials without a space, whole rupees, wrapped name (Gesmo)", () {
      final r = parseReceipt(layout([
        [("Leh", 80)],
        [("Contact No: 9000000000", 20)],
        [("GST No:-00AAAAA0000A1Z5", 20)],
        [("18 October 2026 04:30 PM", 20)],
        [("Customer Copy", 60)],
        [("Dine In", 80)],
        [("KOT No: 70, 71, 73", 40)],
        [("Table: Table 3", 0), ("User: GesmoR", 200)],
        [("Item", 30), ("Qty", 160), ("Rate", 200), ("Total", 250)],
        [("1.pad thai kai", 0), ("1", 165), ("310", 205), ("310", 255)],
        [("2.Chicken Thukpa", 0), ("1", 165), ("280", 205), ("280", 255)],
        [("3.Penne Bolognase", 0), ("1", 165), ("390", 205), ("390", 255)],
        [("4.Chicken Tikka", 0)],
        [("1", 165), ("380", 205), ("380", 255)],
        [("Laffa", 0)],
        [("5.Mutton Momos", 0), ("1", 165), ("260", 205), ("260", 255)],
        [("6.Sweet Lassi", 0), ("1", 165), ("170", 205), ("170", 255)],
        [("7.MINERAL WATER", 0), ("2", 165), ("20", 205), ("40", 255)],
        [("Total Qty : 8", 0), ("Total Amount : Rs 1830.00", 110)],
        [("CGST (2.5%) : Rs 45.75", 130)],
        [("SGST (2.5%) : Rs 45.75", 130)],
        [("Grand Total : Rs 1921.50", 60)],
        [("TMBill v7.2.95", 100)],
      ]));
      expect(items(r), [
        ("pad thai kai", 31000),
        ("Chicken Thukpa", 28000),
        ("Penne Bolognase", 39000),
        ("Chicken Tikka Laffa", 38000),
        ("Mutton Momos", 26000),
        ("Sweet Lassi", 17000),
        ("MINERAL WATER ×2", 4000),
        ("CGST (2.5%)", 4575),
        ("SGST (2.5%)", 4575),
      ]);
      expect(r.totalPaise, 192150);
    });

    test("words broken across lines, payment footer (Ezo)", () {
      final r = parseReceipt(layout([
        [("Created On: 15/10/26 10:45 AM", 0)],
        [("Bill To: Cash Sale", 0)],
        [("Item Name", 10), ("Qty", 130), ("Rate", 180), ("Total", 240)],
        [("Aloo Paratha", 10), ("5", 140), ("100", 180), ("500", 240)],
        [("Bread Omelett", 10), ("1", 140), ("150", 180), ("150", 240)],
        [("e", 10)],
        [("Mineral Water", 10), ("1", 140), ("30", 180), ("30", 240)],
        [("Paneer Parath", 10), ("2", 140), ("150", 180), ("300", 240)],
        [("a", 10)],
        [("Plain Omelett", 10), ("3", 140), ("110", 180), ("330", 240)],
        [("e", 10)],
        [("Total Items: 5", 0)],
        [("Total Quantity: 12", 0)],
        [("Sub Total", 50), ("1310", 240)],
        [("Total 1310", 90)],
        [("Mode of Payment", 0), ("cash", 240)],
        [("Received", 60), ("1310", 240)],
        [("Prv. Balance", 30), ("-1530", 230)],
        [("Thank You! Visit Again!", 40)],
        [("Powered by Ezo", 70)],
      ]));
      expect(items(r), [
        ("Aloo Paratha ×5", 50000),
        ("Bread Omelette", 15000),
        ("Mineral Water", 3000),
        ("Paneer Paratha ×2", 30000),
        ("Plain Omelette ×3", 33000),
      ]);
      expect(r.subtotalPaise, 131000);
      expect(r.totalPaise, 131000);
    });

    test("stacked Sub/Total label, GST lines (Pathirakozhi 1)", () {
      final r = parseReceipt(layout([
        [("*PATHIRAKOZHI*", 60)],
        [("CYBER TOWER , INFOPARK", 20)],
        [("CAMPUS, KOCHI, KAKKANAD", 20)],
        [("682042, G.S.T No:", 40)],
        [("00AAAAA0000A1ZS, MOB:", 30)],
        [("9000000000", 60)],
        [("Name:", 0)],
        [("Date: 22/09/26", 0), ("Pick Up", 150)],
        [("12:35", 0)],
        [("Cashier: CASHIER Bill No.: 522", 0)],
        [("Token No.: 52", 0)],
        [("Item", 0), ("Qty.", 150), ("Price Amount", 190)],
        [("Malabari Bbq", 0), ("2", 160), ("180.00", 180), ("360.00", 240)],
        [("Eri-eri Bbq", 0), ("1", 160), ("190.00", 180), ("190.00", 240)],
        [("Peri-peri Bbq", 0), ("1", 160), ("190.00", 180), ("190.00", 240)],
        [("Sub", 200)],
        [("Total Qty: 4", 90), ("740.00", 240)],
        [("Total", 200)],
        [("CGST@2.5 2.5%", 100), ("18.50", 240)],
        [("SGST@2.5 2.5%", 100), ("18.50", 240)],
        [("Grand Total", 90), ("₹777.00", 210)],
        [("*Thanks*", 100)],
      ]));
      expect(items(r), [
        ("Malabari Bbq ×2", 36000),
        ("Eri-eri Bbq", 19000),
        ("Peri-peri Bbq", 19000),
        ("CGST@2.5 2.5%", 1850),
        ("SGST@2.5 2.5%", 1850),
      ]);
      expect(r.totalPaise, 77700);
    });

    test("two-line item names, +0.50 round off (Pathirakozhi 2)", () {
      final r = parseReceipt(layout([
        [("ATHIRAKOZHI*", 60)],
        [("ER TOWER , INFOPARK", 30)],
        [("US, KOCHI, KAKKANAD", 30)],
        [("682042, G.S.T No:", 40)],
        [("2AAAAA0000A1ZS, MOB:", 30)],
        [("9000000000", 60)],
        [("Name:", 0)],
        [("Date: 21/09/26", 0), ("Pick Up", 150)],
        [("13:03", 0)],
        [("Cashier: biller", 0), ("Bill No.: 227", 150)],
        [("Token No.: 78", 0)],
        [("Item", 0), ("Qty.", 150), ("Price Amount", 190)],
        [("Spicy Kanthari", 0), ("1", 160), ("210.00", 180), ("210.00", 240)],
        [("Chicken Mandi", 0)],
        [("Inji Puliyan Bbq", 0), ("1", 160), ("190.00", 180), ("190.00", 240)],
        [("Chicken", 0), ("1", 160), ("150.00", 180), ("150.00", 240)],
        [("Shawarma", 0)],
        [("Sub", 200)],
        [("Total Qty: 3", 90), ("550.00", 240)],
        [("Total", 200)],
        [("CGST@2.5 2.5%", 100), ("13.75", 240)],
        [("SGST@2.5 2.5%", 100), ("13.75", 240)],
        [("Round off", 120), ("+0.50", 240)],
        [("Grand Total", 90), ("₹578.00", 210)],
        [("*Thanks*", 100)],
      ]));
      expect(items(r), [
        ("Spicy Kanthari Chicken Mandi", 21000),
        ("Inji Puliyan Bbq", 19000),
        ("Chicken Shawarma", 15000),
        ("CGST@2.5 2.5%", 1375),
        ("SGST@2.5 2.5%", 1375),
        ("Round off", 50),
      ]);
      expect(r.totalPaise, 57800);
      expect(r.lines.fold<int>(0, (a, l) => a + l.pricePaise), 57800);
    });

    test("decimal qty, TOTAL GST, total on the next row (Vasantha Bhavan)", () {
      final r = parseReceipt(layout([
        [("UASANTHA BHAUAN", 40)],
        [("NEAR PALLINADA. ATTINKUZHI", 20)],
        [("GSTIN 00AAAAA0000A1ZN", 40)],
        [("FSSAI:11320001001282", 40)],
        [("CASH/BILL", 60)],
        [("TBL 0000", 0), ("CUR 01", 140), ("WTR 03", 210)],
        [("NO.046696", 0), ("12-09-2026", 190)],
        [("ESCRIPTION", 0), ("QTY", 130), ("RATE", 180), ("AMOUNT", 230)],
        [("MASAL DOSA", 0), ("2.00", 120), ("90.00", 170), ("180.00", 230)],
        [("GHEE ROAST", 0), ("1.00", 120), ("95.00", 170), ("95.00", 230)],
        [("PLANE DOSA", 0), ("1.00", 120), ("60.00", 170), ("60.00", 230)],
        [("UZHUNNU VADA", 0), ("4.00", 120), ("18.00", 170), ("72.00", 230)],
        [("PLAIN POORI", 0), ("2.00", 120), ("18.00", 170), ("36.00", 230)],
        [("FILTER COFFEE", 0), ("2.00", 120), ("30.00", 170), ("60.00", 230)],
        [("TEA", 0), ("1.00", 120), ("18.00", 170), ("18.00", 230)],
        [("CGST", 0), ("@ 2.50% ON", 80), ("521.00", 170), ("13.03", 230)],
        [("SGST", 0), ("@ 2.50% ON", 80), ("521.00", 170), ("13.03", 230)],
        [("TOTAL GST", 40), ("26.06", 200)],
        [("BL.TOT", 0), ("(ROUNDED)", 80)],
        [("CASH", 0), ("₹ 547-00", 170)],
        [("THANK YOU COME AGAIN", 50)],
        [("10:02:48", 120), ("M/C NO", 190), ("18", 250)],
      ]));
      expect(items(r), [
        ("MASAL DOSA ×2", 18000),
        ("GHEE ROAST", 9500),
        ("PLANE DOSA", 6000),
        ("UZHUNNU VADA ×4", 7200),
        ("PLAIN POORI ×2", 3600),
        ("FILTER COFFEE ×2", 6000),
        ("TEA", 1800),
        ("CGST @ 2.50% ON 521.00", 1303),
        ("SGST @ 2.50% ON 521.00", 1303),
      ]);
      expect(r.totalPaise, 54700);
    });
  });
}
