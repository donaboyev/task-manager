import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_clone/controller/tasks_controller.dart';
import 'package:todo_clone/core/theme/app_colors.dart';
import 'package:todo_clone/core/theme/app_text_styles.dart';

class SearchAppBarWidget extends GetView<TasksController>
    implements PreferredSizeWidget {
  final Function(String value)? onChanged;
  final TextEditingController? searchController;
  final VoidCallback? onLeadingTap;
  final VoidCallback? onClearTap;
  final bool? clearButtonEnabled;

  const SearchAppBarWidget({
    super.key,
    this.onChanged,
    this.searchController,
    this.onLeadingTap,
    this.onClearTap,
    this.clearButtonEnabled,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TasksController>(
      builder: (tasksController) => AppBar(
        backgroundColor: clrWhite,
        elevation: 0,
        centerTitle: false,
        title: TextField(
          onChanged: onChanged,
          controller: searchController,
          style: stySearchText,
          autofocus: true,
          cursorColor: clrAccent,
          decoration: const InputDecoration(
            hintText: "Search...",
            hintStyle: stySearchHint,
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: clrTransparent),
            ),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: clrTransparent),
            ),
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: clrAccent),
          onPressed: onLeadingTap,
        ),
        actions: [
          Obx(
            () => Visibility(
              visible: controller.clearButtonEnabled,
              child: TextButton(
                onPressed: onClearTap,
                child: const Text('Clear', style: stySearchText),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
