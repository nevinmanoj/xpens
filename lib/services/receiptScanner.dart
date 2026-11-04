import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';

import '../shared/utils/receiptParser.dart';

/// Picks a receipt photo and runs on-device ML Kit text recognition on it.
/// Returns null if the user cancels the picker.
Future<ParsedReceipt?> scanReceipt(ImageSource source) async {
  final file = await ImagePicker().pickImage(source: source);
  if (file == null) return null;

  final recognizer = TextRecognizer(script: TextRecognitionScript.latin);
  try {
    final result =
        await recognizer.processImage(InputImage.fromFilePath(file.path));
    final lines = [
      for (final block in result.blocks)
        for (final line in block.lines)
          OcrLine(line.text,
              left: line.boundingBox.left,
              top: line.boundingBox.top,
              right: line.boundingBox.right,
              bottom: line.boundingBox.bottom)
    ];
    return parseReceipt(lines);
  } finally {
    recognizer.close();
  }
}
