/// Memilih foto dari galeri. Null berarti pengguna membatalkan pemilihan.
abstract class PhotoPickerRepository {
  Future<String?> pickFromGallery();
}
