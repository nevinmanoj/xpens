# google_mlkit_text_recognition references the optional non-Latin recognizers,
# which ship as separate dependencies. The app only uses the Latin script
# (lib/services/receiptScanner.dart), so these classes are never loaded.
# If another script is ever needed, add its dependency and remove its line here.
-dontwarn com.google.mlkit.vision.text.chinese.**
-dontwarn com.google.mlkit.vision.text.devanagari.**
-dontwarn com.google.mlkit.vision.text.japanese.**
-dontwarn com.google.mlkit.vision.text.korean.**
