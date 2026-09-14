import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:get/get.dart';

import '../../../controller/estimate_controller.dart';
import '../../../util/dimensions.dart';
import '../../../util/images.dart';
import '../../base/custom_app_bar.dart';
import '../../base/custom_appbar_action.dart';
import '../../base/loading_indicator.dart';

class EstimateDetailsScreen extends StatefulWidget {
  const EstimateDetailsScreen({super.key});

  @override
  State<EstimateDetailsScreen> createState() => _EstimateDetailsScreenState();
}

class _EstimateDetailsScreenState extends State<EstimateDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    Get.find<EstimateController>().viewFile();
    return Scaffold(
      //  Custom App Bar Start
      appBar: CustomAppBar(
        isBackButtonExist: true,
        title: "estimate_details_key".tr,
        actions: [
          CustomAppBarActionButton(
            onPressed: () => Get.find<EstimateController>().shareFilePdf(),
            svgImagePath: Images.share,
            imagePaddingSize: 8,
          ),
          SizedBox(width: Dimensions.FREE_SIZE_DEFAULT),
        ],
      ),

      //  Body Start
      body: GetBuilder<EstimateController>(
        builder: (estimateController) {
          return estimateController.isPdfLoading
              ? Center(child: LoadingIndicator())
              : estimateController.localFilePath != null
              ? PDFView(
                  filePath: estimateController.localFilePath,
                  enableSwipe: true,
                  swipeHorizontal: true,
                  autoSpacing: false,
                  pageFling: false,
                )
              : Center(child: Text('Failed to load PDF'));
        },
      ),
    );
  }
}
