import 'package:event_connect/views/screens/supplier/homeScreen/chechout_screen.dart';
import 'package:event_connect/views/widget/common_image_view_widget.dart';
import 'package:mobkit_dashed_border/mobkit_dashed_border.dart';

import '../../../../main_packages.dart';
import '../../../widget/appBars/profile_appbar.dart';
import '../../../widget/my_button.dart';
import '../../../widget/my_text_widget.dart';


import 'package:intl/intl.dart';

class AdvertisingScreen extends StatefulWidget {
  const AdvertisingScreen({super.key});

  @override
  State<AdvertisingScreen> createState() => _AdvertisingScreenState();
}

class _AdvertisingScreenState extends State<AdvertisingScreen> {
  DateTime? selectedDate;
  TextEditingController amountController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  String? selectedCategory;
  bool isPerAd = true;

  List<String> categories = [
    "Banner",
    "Popup",
    "Sidebar",
    "Sponsored Post",
    "Video"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: ProfileAppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MyText(
              text: "Upload Photo",
              size: 18,
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              height: 100,
              width: double.infinity,
              decoration: const BoxDecoration(
                  color: Color(0xFFDFF6DA),
                  border: DashedBorder.fromBorderSide(
                      side: BorderSide(color: kPrimaryColor), dashLength: 3)),
              child: Center(
                child: Icon(Icons.upload, color: Colors.green.shade400),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _datePickerField(),
                _amountField(),
              ],
            ),
            const SizedBox(height: 15),
            _label("Write details about service"),
            _descriptionField(),
            const SizedBox(height: 15),
            _label("Select"),
            _categoryDropdown(),
            const SizedBox(height: 20),
            Row(
              children: [
                const Text("Price is per one advertising",
                    style: TextStyle(fontSize: 14, color: Colors.black87)),
                const Spacer(),
                Switch(
                  value: isPerAd,
                  activeColor: Colors.green,
                  onChanged: (val) {
                    setState(() {
                      isPerAd = val;
                    });
                  },
                )
              ],
            ),
            const SizedBox(height: 20),
            MyButton(
                radius: 100,
                fontColor: kBlackColor1,
                onTap: () {
                  // Get.to(() => CheckoutScreen());
                },
                buttonText: "Post")
          ],
        ),
      ),
    );
  }

  Widget _label(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Text(text, style: const TextStyle(fontWeight: FontWeight.w500)),
    );
  }

  Widget _datePickerField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MyText(text: "Select Date"),
        GestureDetector(
          onTap: () async {
            DateTime? picked = await showDatePicker(
              context: context,
              initialDate: selectedDate ?? DateTime.now(),
              firstDate: DateTime.now(),
              lastDate: DateTime(2100),
            );
            if (picked != null) {
              setState(() {
                selectedDate = picked;
              });
            }
          },
          child: Container(
            width: Get.width * 0.3,
            height: 48,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Icon(Icons.calendar_today_outlined, color: Colors.green),
                const SizedBox(width: 10),
                Text(
                  selectedDate != null
                      ? DateFormat('yyyy-MM-dd').format(selectedDate!)
                      : "Date",
                  style: TextStyle(
                    fontSize: 16,
                    color: selectedDate != null ? Colors.black : Colors.grey,
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _amountField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MyText(text: "Amount"),
        Container(
          height: 48,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              CommonImageView(
                svgPath: Assets.imagesMoneyBagDollar,
              ),
              const SizedBox(width: 10),
              SizedBox(
                width: Get.width * 0.2,
                child: TextField(
                  controller: amountController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: "\$",
                  ),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget _descriptionField() {
    return TextField(
      controller: descriptionController,
      maxLines: 4,
      decoration: InputDecoration(
        hintText: "Description",
        filled: true,
        fillColor: Colors.grey.shade100,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
      ),
    );
  }

  Widget _categoryDropdown() {
    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          hint: Row(
            children: const [
              Icon(Icons.category_outlined, color: Colors.green),
              SizedBox(width: 10),
              Text("Select Category"),
            ],
          ),
          value: selectedCategory,
          isExpanded: true,
          items: categories
              .map((e) => DropdownMenuItem(value: e, child: Text(e)))
              .toList(),
          onChanged: (val) {
            setState(() {
              selectedCategory = val;
            });
          },
        ),
      ),
    );
  }

  Widget _postButton() {
    return Center(
      child: ElevatedButton(
        onPressed: () {
          // Handle post logic
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 14),
        ),
        child: const Text("Post", style: TextStyle(fontSize: 16)),
      ),
    );
  }
}
