import 'package:event_connect/core/utils/app_lists.dart';
import 'package:event_connect/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

import '../../../../core/bindings/bindings.dart';
import '../../../../main_packages.dart';
import '../../../widget/select_category_tile.dart';
import '../../categoryScreens/category_screen.dart';

class SelectCategoryScreen extends StatefulWidget {
  const SelectCategoryScreen({Key? key}) : super(key: key);

  @override
  State<SelectCategoryScreen> createState() => _SelectCategoryScreenState();
}

class _SelectCategoryScreenState extends State<SelectCategoryScreen> {
  String selectedCategory = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.selectCategory),
          centerTitle: false,
          backgroundColor: Colors.white,
          elevation: 0,
          foregroundColor: Colors.black,
        ),
        body: ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: services.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final category = services[index];
            return CategoryItemTile(
              title: category,
              isSelected: selectedCategory == category,
              onTap: () {
                setState(() {

                  selectedCategory = category;
                });
                Get.to(() => CategoryScreen(title: category),
                    binding: CategoryBindings(), arguments: category);
              },
            );
          },
        ));
  }
}
