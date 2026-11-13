import 'package:image_picker/image_picker.dart';

import 'package:runca/repository/photo_picker_repository.dart';

class ImagePickerPhotoPickerRepository implements PhotoPickerRepository {
  @override
  Future<String?> pickFromGallery() async {
    final file = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );

    return file?.path;
  }
}
