import 'package:flutter/material.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import '../../../../util/dimensions.dart';

class PaymentOverviewShimmer extends StatelessWidget {
  const PaymentOverviewShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(Dimensions.RADIUS_LARGE)),
      padding: const EdgeInsets.all(Dimensions.PADDING_SIZE_DEFAULT),
      child: Shimmer(
        duration: const Duration(seconds: 2),
        child: Column(
          children: [
            const SizedBox(
              height: Dimensions.PADDING_SIZE_EXTRA_SMALL,
            ),

            // Payment overview info section
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Container(
                      height: 16, width: 70, color: Colors.grey.shade200),
                ),
                const SizedBox(
                  width: 100,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                        height: 10, width: 70, color: Colors.grey.shade200),
                    const SizedBox(
                      height: Dimensions.PADDING_SIZE_SMALL - 3,
                    ),
                    Container(
                        height: 15, width: 70, color: Colors.grey.shade200),
                    const SizedBox(
                      height: Dimensions.PADDING_SIZE_SMALL - 3,
                    ),
                    Container(
                        height: 10, width: 70, color: Colors.grey.shade200),
                    const SizedBox(
                      height: Dimensions.PADDING_SIZE_SMALL - 3,
                    ),
                    Container(
                        height: 15, width: 70, color: Colors.grey.shade200),
                  ],
                )
              ],
            ),
            const SizedBox(
              height: Dimensions.PADDING_SIZE_EXTRA_OVER_LARGE +
                  Dimensions.PADDING_SIZE_DEFAULT,
            ),

            // Payment overview chart section
            Container(
              height: 200,
              width: 200,
              decoration: BoxDecoration(
                  color: Colors.grey.shade200, shape: BoxShape.circle),
            ),

            const SizedBox(
              height: Dimensions.PADDING_SIZE_EXTRA_OVER_LARGE,
            ),

            // Payment overview type section
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Due Indicator section
                Container(
                  height: 12,
                  width: 12,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.grey.shade200,
                  ),
                ),
                const SizedBox(
                  width: Dimensions.PADDING_SIZE_EXTRA_SMALL,
                ),
                Container(height: 10, width: 60, color: Colors.grey.shade200),
                const SizedBox(
                  width: Dimensions.PADDING_SIZE_SMALL,
                ),

                // Received Indicator section
                Container(
                  height: 12,
                  width: 12,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.grey.shade200,
                  ),
                ),
                const SizedBox(
                  width: Dimensions.PADDING_SIZE_EXTRA_SMALL,
                ),
                Container(height: 10, width: 60, color: Colors.grey.shade200),
              ],
            ),
            const SizedBox(
              height: Dimensions.PADDING_SIZE_EXTRA_SMALL,
            ),
          ],
        ),
      ),
    );
  }
}
