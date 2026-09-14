import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:get/get.dart';
import 'package:paysuite/util/dimensions.dart';
import '../../../controller/invoice_controller.dart';
import '../../../util/images.dart';
import '../../base/custom_app_bar.dart';
import '../../base/custom_appbar_action.dart';
import '../../base/loading_indicator.dart';

class InvoiceDetailsScreen extends StatefulWidget {
  const InvoiceDetailsScreen({super.key});

  @override
  State<InvoiceDetailsScreen> createState() => _InvoiceDetailsScreenState();
}

class _InvoiceDetailsScreenState extends State<InvoiceDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    Get.find<InvoiceController>().viewFile();
    return Scaffold(
      appBar: CustomAppBar(
        title: "invoice_details_key".tr,
        isBackButtonExist: true,
        actions: [
          CustomAppBarActionButton(
            onPressed: () => Get.find<InvoiceController>().shareFilePdf(),
            svgImagePath: Images.share,
            imagePaddingSize: 8,
          ),
          SizedBox(width: Dimensions.FREE_SIZE_DEFAULT),
        ],
      ),
      body: GetBuilder<InvoiceController>(
        builder: (invoiceController) {
          return invoiceController.isPdfLoading
              ? Center(child: LoadingIndicator())
              : invoiceController.localFilePath != null
              ? PDFView(
                  filePath: invoiceController.localFilePath,
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
