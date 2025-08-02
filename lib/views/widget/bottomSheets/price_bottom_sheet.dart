import 'package:event_connect/views/widget/my_button.dart';

import '../../../controllers/categoryControllers/category_controller.dart';
import '../../../main_packages.dart';

void showPriceFilterBottomSheet({
  required BuildContext context,
  required double minPrice,
  required double maxPrice,
  required void Function(double min, double max) onApply,
}) {

  final CategoryController controller = Get.find<CategoryController>();

  RangeValues selectedRange = RangeValues(controller.minPrice.value, controller.maxPrice.value);

  showModalBottomSheet(
    context: context,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Select Price Range",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),

                /// Range Slider
                RangeSlider(
                  activeColor: kPrimaryColor,
                  values: selectedRange,
                  min: minPrice,
                  max: maxPrice,
                  divisions: (maxPrice - minPrice).toInt(),
                  labels: RangeLabels(
                    "\$ ${selectedRange.start.toStringAsFixed(0)}",
                    "\$ ${selectedRange.end.toStringAsFixed(0)}",
                  ),
                  onChanged: (RangeValues values) {
                    setState(() {
                      selectedRange = values;
                    });
                  },
                ),

                SizedBox(height: 10),

                /// Value display
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Min: \$${selectedRange.start.toStringAsFixed(0)}"),
                    Text("Max: \$${selectedRange.end.toStringAsFixed(0)}"),
                  ],
                ),

                SizedBox(height: 20),

                /// Apply Button
                MyButton(onTap: () {
                  Navigator.pop(context);
                  onApply(selectedRange.start, selectedRange.end);
                } , buttonText: "Apply Filter"),

              ],
            ),
          );
        },
      );
    },
  );
}
