import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

import '../theme/theme.dart';

class ImageService {
  factory ImageService() {
    return _singleton;
  }
  ImageService._internal();
  static final ImageService _singleton = ImageService._internal();

  Future<CroppedFile?> selectImage(
      {double ratioX = 5, double ratioY = 3}) async {
    final XFile? image =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image == null) return null;
    final cropped = await ImageCropper().cropImage(
      sourcePath: image.path,
      compressQuality: 10,
      aspectRatio: CropAspectRatio(ratioX: ratioX, ratioY: ratioY),
      uiSettings: [
        AndroidUiSettings(
            toolbarColor: secondaryColor,
            toolbarWidgetColor: primaryWhite,
            lockAspectRatio: true),
        IOSUiSettings(
            title: 'Cropper',
            aspectRatioLockEnabled: true,
            aspectRatioPickerButtonHidden: true,
            rotateButtonsHidden: true,
            rotateClockwiseButtonHidden: true,
            resetButtonHidden: true,
            cancelButtonTitle: 'Abbrechen',
            doneButtonTitle: 'Fertig'),
      ],
    );
    return cropped;
  }
}
