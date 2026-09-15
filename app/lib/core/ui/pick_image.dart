import 'package:image_picker/image_picker.dart';

import '../network/uploads.dart';

/// Galeria do dispositivo (ou seletor de arquivos no web) → bytes.
Future<PickedImage?> pickImage() async {
  final file = await ImagePicker().pickImage(source: ImageSource.gallery, maxWidth: 2400, imageQuality: 88);
  if (file == null) return null;
  return PickedImage(bytes: await file.readAsBytes(), filename: file.name);
}

Future<List<PickedImage>> pickImages() async {
  final files = await ImagePicker().pickMultiImage(maxWidth: 2400, imageQuality: 88);
  return [for (final f in files) PickedImage(bytes: await f.readAsBytes(), filename: f.name)];
}
