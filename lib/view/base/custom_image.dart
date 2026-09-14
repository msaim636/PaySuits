import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../util/images.dart';

class CustomImage extends StatelessWidget {
  final String image;
  final double? height;
  final double? width;
  final BoxFit? fit;
  final String? placeholder;

  const CustomImage({
    super.key,
    required this.image,
    this.height,
    this.width,
    this.fit,
    this.placeholder,
  });

  bool get isSvg => image.toLowerCase().endsWith('.svg');

  @override
  Widget build(BuildContext context) {
    if (isSvg) {
      return FutureBuilder(
        future: _loadSvg(image),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.hasData) {
            return SvgPicture.network(
              image,
              height: height,
              width: width,
              fit: fit ?? BoxFit.contain,
              placeholderBuilder: (context) => Image.asset(
                placeholder ?? Images.placeholder,
                height: height,
                width: width,
                fit: fit,
              ),
            );
          } else {
            return Image.asset(
              placeholder ?? Images.placeholder,
              height: height,
              width: width,
              fit: fit,
            );
          }
        },
      );
    } else {
      return FadeInImage.assetNetwork(
        placeholder: Images.placeholder,
        height: height,
        width: width,
        fit: fit,
        image: image,
        imageErrorBuilder: (context, error, stackTrace) => Image.asset(
          placeholder ?? Images.placeholder,
          height: height,
          width: width,
          fit: fit,
        ),
      );
    }
  }

  Future<bool> _loadSvg(String url) async {
    try {
      final response = await NetworkAssetBundle(Uri.parse(url)).load(url);
      return response.lengthInBytes > 0;
    } catch (e) {
      return false;
    }
  }
}
