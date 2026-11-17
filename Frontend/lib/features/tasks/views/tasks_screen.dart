// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';
// import 'package:taskflow/core/consts/colours.dart';
// import 'package:taskflow/core/consts/lists.dart';
// import 'package:taskflow/core/router/app_routes.dart';
// import 'package:taskflow/features/tasks/models/task.dart';

// import '../controllers/tasks_controller.dart';

// class TasksScreen extends GetView<TasksController> {
//   const TasksScreen({super.key});

//   Future<void> _openAddTaskSheet(BuildContext context) async {
//     final titleController = TextEditingController();
//     final descriptionController = TextEditingController();
//     final formKey = GlobalKey<FormState>();
//     DateTime? dueDate;
//     String priority = AppLists.priorities.first;
//     String assignee = AppLists.assignees.first;

//     await showModalBottomSheet<void>(
//       context: context,
//       isScrollControlled: true,
//       useSafeArea: true,
//       backgroundColor: Colours.surface,
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
//       ),
//       builder: (sheetContext) => StatefulBuilder(
//         builder: (context, setSheetState) => Padding(
//           padding: EdgeInsets.only(
//             left: 20.w,
//             right: 20.w,
//             top: 12.h,
//             bottom: MediaQuery.viewInsetsOf(context).bottom + 20.h,
//           ),
//           child: SingleChildScrollView(
//             child: Form(
//               key: formKey,
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   Center(
//                     child: Container(
//                       width: 42.w,
//                       height: 4.h,
//                       decoration: BoxDecoration(
//                         color: Colours.border,
//                         borderRadius: BorderRadius.circular(20),
//                       ),
//                     ),
//                   ),
//                   SizedBox(height: 22.h),
//                   const Text(
//                     'Create a new task',
//                     style: TextStyle(
//                       color: Colours.text,
//                       fontSize: 22,
//                       fontWeight: FontWeight.w800,
//                     ),
//                   ),
//                   SizedBox(height: 6.h),
//                   const Text(
//                     'Add the details and assign it to your team.',
//                     style: TextStyle(color: Colours.mutedText, fontSize: 14),
//                   ),
//                   SizedBox(height: 22.h),
//                   const _FieldLabel('Task title'),
//                   TextFormField(
//                     controller: titleController,
//                     onChanged: (_) => controller.clearSubmissionError(),
//                     textCapitalization: TextCapitalization.sentences,
//                     decoration: const InputDecoration(
//                       hintText: 'e.g. Prepare launch report',
//                       prefixIcon: Icon(Icons.task_alt_rounded),
//                     ),
//                     validator: (value) {
//                       if (value == null || value.trim().isEmpty) {
//                         return 'Please enter a task title';
//                       }
//                       final fieldError =
//                           controller.submissionFieldErrors['title'];
//                       if (fieldError != null) return fieldError;
//                       return null;
//                     },
//                   ),
//                   SizedBox(height: 16.h),
//                   const _FieldLabel('Description'),
//                   TextFormField(
//                     controller: descriptionController,
//                     textCapitalization: TextCapitalization.sentences,
//                     minLines: 3,
//                     maxLines: 5,
//                     decoration: const InputDecoration(
//                       hintText: 'What needs to be done?',
//                       alignLabelWithHint: true,
//                     ),
//                   ),
//                   SizedBox(height: 16.h),
//                   const _FieldLabel('Due date'),
//                   InkWell(
//                     borderRadius: BorderRadius.circular(14),
//                     onTap: () async {
//                       final selected = await showDatePicker(
//                         context: context,
//                         initialDate: dueDate ?? DateTime.now(),
//                         firstDate: DateTime.now(),
//                         lastDate: DateTime.now().add(
//                           const Duration(days: 3650),
//                         ),
//                       );
//                       if (selected != null) {
//                         setSheetState(() => dueDate = selected);
//                       }
//                     },
//                     child: InputDecorator(
//                       decoration: const InputDecoration(
//                         prefixIcon: Icon(Icons.calendar_today_rounded),
//                         suffixIcon: Icon(Icons.keyboard_arrow_down_rounded),
//                       ),
//                       child: Text(
//                         dueDate == null
//                             ? 'Select a date'
//                             : _formatDate(dueDate!),
//                         style: TextStyle(
//                           color: dueDate == null
//                               ? Colours.mutedText
//                               : Colours.text,
//                           fontWeight: FontWeight.w500,
//                         ),
//                       ),
//                     ),
//                   ),
//                   SizedBox(height: 16.h),
//                   const _FieldLabel('Priority'),
//                   Row(
//                     children: AppLists.priorities
//                         .map(
//                           (item) => Expanded(
//                             child: Padding(
//                               padding: EdgeInsets.only(
//                                 right: item == AppLists.priorities.last
//                                     ? 0
//                                     : 8.w,
//                               ),
//                               child: ChoiceChip(
//                                 label: SizedBox(
//                                   width: double.infinity,
//                                   child: Text(
//                                     _capitalize(item),
//                                     textAlign: TextAlign.center,
//                                   ),
//                                 ),
//                                 selected: priority == item,
//                                 onSelected: (_) => setSheetState(() {
//                                   priority = item;
//                                   controller.clearSubmissionError();
//                                 }),
//                                 selectedColor: _priorityBackground(item),
//                                 checkmarkColor: _priorityColor(item),
//                                 labelStyle: TextStyle(
//                                   color: priority == item
//                                       ? _priorityColor(item)
//                                       : Colours.mutedText,
//                                   fontWeight: FontWeight.w700,
//                                 ),
//                                 side: BorderSide(
//                                   color: priority == item
//                                       ? _priorityColor(item)
//                                       : Colours.border,
//                                 ),
//                                 shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(12),
//                                 ),
//                               ),
//                             ),
//                           ),
//                         )
//                         .toList(),
//                   ),
//                   SizedBox(height: 16.h),
//                   const _FieldLabel('Assign to'),
//                   DropdownButtonFormField<String>(
//                     initialValue: assignee,
//                     decoration: const InputDecoration(
//                       prefixIcon: Icon(Icons.person_outline_rounded),
//                     ),
//                     items: AppLists.assignees
//                         .map(
//                           (item) => DropdownMenuItem(
//                             value: item,
//                             child: Text(_capitalize(item)),
//                           ),
//                         )
//                         .toList(),
//                     onChanged: (value) {
//                       assignee = value ?? assignee;
//                       controller.clearSubmissionError();
//                     },
//                   ),
//                   Obx(() {
//                     final message = controller.submissionError.value;
//                     if (message == null ||
//                         message.toLowerCase().contains('title')) {
//                       return const SizedBox.shrink();
//                     }
//                     return _FormError(message: message);
//                   }),
//                   SizedBox(height: 24.h),
//                   SizedBox(
//                     width: double.infinity,
//                     child: Obx(
//                       () => FilledButton.icon(
//                         onPressed: controller.isSubmitting.value
//                             ? null
//                             : () async {
//                                 if (!formKey.currentState!.validate()) return;
//                                 final created = await controller.addTask(
//                                   title: titleController.text.trim(),
//                                   description: descriptionController.text
//                                       .trim(),
//                                   dueDate: dueDate == null
//                                       ? null
//                                       : _apiDate(dueDate!),
//                                   priority: priority,
//                                   assignedId: assignee,
//                                 );
//                                 if (!created) {
//                                   formKey.currentState!.validate();
//                                 }
//                                 if (created && sheetContext.mounted) {
//                                   Navigator.pop(sheetContext);
//                                   Get.snackbar(
//                                     'Task created',
//                                     'The task was added to your workflow.',
//                                     snackPosition: SnackPosition.BOTTOM,
//                                     margin: const EdgeInsets.all(16),
//                                     backgroundColor: Colours.text,
//                                     colorText: Colors.white,
//                                   );
//                                 }
//                               },
//                         icon: controller.isSubmitting.value
//                             ? const SizedBox.square(
//                                 dimension: 18,
//                                 child: CircularProgressIndicator(
//                                   strokeWidth: 2,
//                                   color: Colors.white,
//                                 ),
//                               )
//                             : const Icon(Icons.add_rounded),
//                         label: Text(
//                           controller.isSubmitting.value
//                               ? 'Creating task...'
//                               : 'Create task',
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );

//     titleController.dispose();
//     descriptionController.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       floatingActionButton: FloatingActionButton.extended(
//         onPressed: () => _openAddTaskSheet(context),
//         backgroundColor: Colours.primary,
//         foregroundColor: Colors.white,
//         elevation: 3,
//         icon: const Icon(Icons.add_rounded),
//         label: const Text(
//           'New task',
//           style: TextStyle(fontWeight: FontWeight.w700),
//         ),
//       ),
//       body: SafeArea(
//         child: Center(
//           child: ConstrainedBox(
//             constraints: const BoxConstraints(maxWidth: 900),
//             child: RefreshIndicator(
//               color: Colours.primary,
//               onRefresh: controller.getAllTasks,
//               child: CustomScrollView(
//                 physics: const AlwaysScrollableScrollPhysics(),
//                 slivers: [
//                   SliverPadding(
//                     padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 0),
//                     sliver: SliverToBoxAdapter(child: _Header(controller)),
//                   ),
//                   SliverPadding(
//                     padding: EdgeInsets.fromLTRB(20.w, 22.h, 20.w, 10.h),
//                     sliver: SliverToBoxAdapter(
//                       child: _Filters(controller: controller),
//                     ),
//                   ),
//                   Obx(() => _taskContent()),
//                   SliverToBoxAdapter(child: SizedBox(height: 100.h)),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _taskContent() {
//     if (controller.isLoading.value && controller.tasks.isEmpty) {
//       return const SliverFillRemaining(
//         hasScrollBody: false,
//         child: Center(child: CircularProgressIndicator()),
//       );
//     }
//     if (controller.loadError.value != null && controller.tasks.isEmpty) {
//       return SliverFillRemaining(
//         hasScrollBody: false,
//         child: _ErrorState(
//           message: controller.loadError.value!,
//           onRetry: controller.getAllTasks,
//         ),
//       );
//     }
//     if (controller.tasks.isEmpty) {
//       return SliverFillRemaining(
//         hasScrollBody: false,
//         child: _EmptyState(onClear: controller.clearFilters),
//       );
//     }
//     return SliverPadding(
//       padding: EdgeInsets.symmetric(horizontal: 20.w),
//       sliver: SliverList.separated(
//         itemCount: controller.tasks.length,
//         separatorBuilder: (_, _) => SizedBox(height: 12.h),
//         itemBuilder: (context, index) {
//           final task = controller.tasks[index];
//           return _TaskCard(
//             task: task,
//             isToggling:
//                 task.id != null && controller.togglingTaskIds.contains(task.id),
//             onToggle: () => controller.toggleTask(task),
//             onTap: () => Get.toNamed(
//               Routes.taskDetailsScreen,
//               arguments: task,
//             )?.then((_) => controller.getAllTasks()),
//           );
//         },
//       ),
//     );
//   }
// }

// class _Header extends StatelessWidget {
//   const _Header(this.controller);
//   final TasksController controller;

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Row(
//           children: [
//             Container(
//               width: 44.w,
//               height: 44.w,
//               decoration: BoxDecoration(
//                 color: Colours.primary,
//                 borderRadius: BorderRadius.circular(14),
//               ),
//               child: const Icon(Icons.check_rounded, color: Colors.white),
//             ),
//             SizedBox(width: 12.w),
//             const Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     'TaskFlow',
//                     style: TextStyle(
//                       color: Colours.text,
//                       fontSize: 22,
//                       height: 1,
//                       fontWeight: FontWeight.w800,
//                     ),
//                   ),
//                   SizedBox(height: 5),
//                   Text(
//                     'Team workspace',
//                     style: TextStyle(color: Colours.mutedText, fontSize: 12),
//                   ),
//                 ],
//               ),
//             ),
//             IconButton.filledTonal(
//               onPressed: controller.getAllTasks,
//               tooltip: 'Refresh tasks',
//               icon: const Icon(Icons.refresh_rounded),
//             ),
//           ],
//         ),
//         SizedBox(height: 28.h),
//         const Text(
//           'Good day, Admin 👋',
//           style: TextStyle(
//             color: Colours.text,
//             fontSize: 26,
//             fontWeight: FontWeight.w800,
//             letterSpacing: -0.5,
//           ),
//         ),
//         SizedBox(height: 6.h),
//         const Text(
//           'Keep your team focused and work moving forward.',
//           style: TextStyle(color: Colours.mutedText, fontSize: 14),
//         ),
//         SizedBox(height: 20.h),
//         Obx(
//           () => Row(
//             children: [
//               Expanded(
//                 child: _SummaryCard(
//                   label: 'All tasks',
//                   value: controller.totalTasks,
//                   icon: Icons.layers_rounded,
//                   color: Colours.primary,
//                   background: Colours.primaryLight,
//                 ),
//               ),
//               SizedBox(width: 10.w),
//               Expanded(
//                 child: _SummaryCard(
//                   label: 'In progress',
//                   value: controller.activeTasks,
//                   icon: Icons.timelapse_rounded,
//                   color: Colours.warning,
//                   background: Colours.warningLight,
//                 ),
//               ),
//               SizedBox(width: 10.w),
//               Expanded(
//                 child: _SummaryCard(
//                   label: 'Completed',
//                   value: controller.completedTasks,
//                   icon: Icons.task_alt_rounded,
//                   color: Colours.success,
//                   background: Colours.successLight,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }

// class _SummaryCard extends StatelessWidget {
//   const _SummaryCard({
//     required this.label,
//     required this.value,
//     required this.icon,
//     required this.color,
//     required this.background,
//   });
//   final String label;
//   final int value;
//   final IconData icon;
//   final Color color;
//   final Color background;

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: EdgeInsets.all(12.w),
//       decoration: BoxDecoration(
//         color: Colours.surface,
//         borderRadius: BorderRadius.circular(18),
//         border: Border.all(color: Colours.border),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Container(
//             width: 32.w,
//             height: 32.w,
//             decoration: BoxDecoration(
//               color: background,
//               borderRadius: BorderRadius.circular(10),
//             ),
//             child: Icon(icon, size: 17, color: color),
//           ),
//           SizedBox(height: 12.h),
//           Text(
//             '$value',
//             style: const TextStyle(
//               color: Colours.text,
//               fontSize: 22,
//               fontWeight: FontWeight.w800,
//             ),
//           ),
//           Text(
//             label,
//             maxLines: 1,
//             overflow: TextOverflow.ellipsis,
//             style: const TextStyle(color: Colours.mutedText, fontSize: 11),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class _Filters extends StatelessWidget {
//   const _Filters({required this.controller});
//   final TasksController controller;

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Row(
//           children: [
//             const Expanded(
//               child: Text(
//                 'Tasks',
//                 style: TextStyle(
//                   color: Colours.text,
//                   fontSize: 20,
//                   fontWeight: FontWeight.w800,
//                 ),
//               ),
//             ),
//             Obx(
//               () => AnimatedSwitcher(
//                 duration: const Duration(milliseconds: 180),
//                 child:
//                     controller.assigned.value != null ||
//                         controller.status.value != null
//                     ? TextButton(
//                         key: const ValueKey('clear'),
//                         onPressed: controller.clearFilters,
//                         child: const Text('Clear filters'),
//                       )
//                     : const SizedBox.shrink(key: ValueKey('empty')),
//               ),
//             ),
//           ],
//         ),
//         SizedBox(height: 10.h),
//         Row(
//           children: [
//             Expanded(
//               child: Obx(
//                 () => _FilterMenu(
//                   icon: Icons.person_outline_rounded,
//                   hint: 'Assignee',
//                   value: controller.assigned.value,
//                   values: AppLists.assignees,
//                   onChanged: (value) => controller.assigned.value = value,
//                 ),
//               ),
//             ),
//             SizedBox(width: 10.w),
//             Expanded(
//               child: Obx(
//                 () => _FilterMenu(
//                   icon: Icons.tune_rounded,
//                   hint: 'Status',
//                   value: controller.status.value,
//                   values: AppLists.statuses,
//                   onChanged: (value) => controller.status.value = value,
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ],
//     );
//   }
// }

// class _FilterMenu extends StatelessWidget {
//   const _FilterMenu({
//     required this.icon,
//     required this.hint,
//     required this.value,
//     required this.values,
//     required this.onChanged,
//   });
//   final IconData icon;
//   final String hint;
//   final String? value;
//   final List<String> values;
//   final ValueChanged<String?> onChanged;

//   @override
//   Widget build(BuildContext context) {
//     return PopupMenuButton<String?>(
//       onSelected: onChanged,
//       itemBuilder: (_) => [
//         PopupMenuItem<String?>(value: null, child: Text('All $hint')),
//         ...values.map(
//           (item) => PopupMenuItem<String?>(
//             value: item,
//             child: Text(_capitalize(item)),
//           ),
//         ),
//       ],
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
//       child: Container(
//         height: 46.h,
//         padding: EdgeInsets.symmetric(horizontal: 13.w),
//         decoration: BoxDecoration(
//           color: value == null ? Colours.surface : Colours.primaryLight,
//           borderRadius: BorderRadius.circular(13),
//           border: Border.all(
//             color: value == null ? Colours.border : Colours.primary,
//           ),
//         ),
//         child: Row(
//           children: [
//             Icon(
//               icon,
//               size: 18,
//               color: value == null ? Colours.mutedText : Colours.primary,
//             ),
//             SizedBox(width: 8.w),
//             Expanded(
//               child: Text(
//                 value == null ? hint : _capitalize(value!),
//                 overflow: TextOverflow.ellipsis,
//                 style: TextStyle(
//                   color: value == null ? Colours.mutedText : Colours.primary,
//                   fontSize: 13,
//                   fontWeight: FontWeight.w600,
//                 ),
//               ),
//             ),
//             const Icon(
//               Icons.keyboard_arrow_down_rounded,
//               size: 18,
//               color: Colours.mutedText,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class _TaskCard extends StatelessWidget {
//   const _TaskCard({
//     required this.task,
//     required this.isToggling,
//     required this.onToggle,
//     required this.onTap,
//   });
//   final Task task;
//   final bool isToggling;
//   final VoidCallback onToggle;
//   final VoidCallback onTap;

//   @override
//   Widget build(BuildContext context) {
//     final completed = task.completed ?? false;
//     final priority = task.priority?.toLowerCase() ?? 'low';
//     final priorityColor = _priorityColor(priority);
//     final priorityBackground = _priorityBackground(priority);
//     final overdue = task.isOverdue();
//     return Material(
//       color: overdue
//           ? Colours.errorLight.withValues(alpha: .32)
//           : Colours.surface,
//       borderRadius: BorderRadius.circular(18),
//       child: InkWell(
//         onTap: onTap,
//         borderRadius: BorderRadius.circular(18),
//         child: Container(
//           padding: EdgeInsets.all(16.w),
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(18),
//             border: Border.all(
//               color: overdue
//                   ? Colours.error.withValues(alpha: .35)
//                   : Colours.border,
//             ),
//           ),
//           child: Row(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Semantics(
//                 label: completed ? 'Mark task active' : 'Mark task complete',
//                 button: true,
//                 child: InkWell(
//                   onTap: isToggling ? null : onToggle,
//                   borderRadius: BorderRadius.circular(12),
//                   child: AnimatedContainer(
//                     duration: const Duration(milliseconds: 180),
//                     width: 28.w,
//                     height: 28.w,
//                     decoration: BoxDecoration(
//                       color: completed ? Colours.success : Colors.transparent,
//                       borderRadius: BorderRadius.circular(9),
//                       border: Border.all(
//                         color: completed ? Colours.success : Colours.border,
//                         width: 1.5,
//                       ),
//                     ),
//                     child: isToggling
//                         ? Padding(
//                             padding: const EdgeInsets.all(6),
//                             child: CircularProgressIndicator(
//                               strokeWidth: 2,
//                               color: completed ? Colors.white : Colours.primary,
//                             ),
//                           )
//                         : completed
//                         ? const Icon(
//                             Icons.check_rounded,
//                             size: 18,
//                             color: Colors.white,
//                           )
//                         : null,
//                   ),
//                 ),
//               ),
//               SizedBox(width: 13.w),
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Row(
//                       children: [
//                         Expanded(
//                           child: Text(
//                             task.title ?? 'Untitled task',
//                             maxLines: 2,
//                             overflow: TextOverflow.ellipsis,
//                             style: TextStyle(
//                               color: completed
//                                   ? Colours.mutedText
//                                   : Colours.text,
//                               fontSize: 16,
//                               height: 1.25,
//                               fontWeight: FontWeight.w700,
//                               decoration: completed
//                                   ? TextDecoration.lineThrough
//                                   : null,
//                             ),
//                           ),
//                         ),
//                         SizedBox(width: 8.w),
//                         Container(
//                           padding: const EdgeInsets.symmetric(
//                             horizontal: 9,
//                             vertical: 5,
//                           ),
//                           decoration: BoxDecoration(
//                             color: priorityBackground,
//                             borderRadius: BorderRadius.circular(20),
//                           ),
//                           child: Text(
//                             _capitalize(priority),
//                             style: TextStyle(
//                               color: priorityColor,
//                               fontSize: 10,
//                               fontWeight: FontWeight.w800,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                     if ((task.description ?? '').trim().isNotEmpty) ...[
//                       SizedBox(height: 7.h),
//                       Text(
//                         task.description!,
//                         maxLines: 2,
//                         overflow: TextOverflow.ellipsis,
//                         style: const TextStyle(
//                           color: Colours.mutedText,
//                           fontSize: 13,
//                           height: 1.35,
//                         ),
//                       ),
//                     ],
//                     SizedBox(height: 13.h),
//                     Wrap(
//                       spacing: 14.w,
//                       runSpacing: 7.h,
//                       children: [
//                         if (overdue)
//                           const _MetaItem(
//                             icon: Icons.warning_amber_rounded,
//                             label: 'Overdue',
//                             color: Colours.error,
//                           ),
//                         _MetaItem(
//                           icon: Icons.calendar_today_rounded,
//                           label: _displayDueDate(task.dueDate),
//                         ),
//                         _MetaItem(
//                           icon: Icons.person_outline_rounded,
//                           label: _capitalize(task.assignedId ?? 'Unassigned'),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//               const Padding(
//                 padding: EdgeInsets.only(top: 2),
//                 child: Icon(
//                   Icons.chevron_right_rounded,
//                   color: Colours.mutedText,
//                   size: 21,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// class _MetaItem extends StatelessWidget {
//   const _MetaItem({
//     required this.icon,
//     required this.label,
//     this.color = Colours.mutedText,
//   });
//   final IconData icon;
//   final String label;
//   final Color color;

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         Icon(icon, size: 14, color: color),
//         const SizedBox(width: 5),
//         Text(
//           label,
//           style: TextStyle(
//             color: color,
//             fontSize: 11,
//             fontWeight: FontWeight.w500,
//           ),
//         ),
//       ],
//     );
//   }
// }

// class _EmptyState extends StatelessWidget {
//   const _EmptyState({required this.onClear});
//   final VoidCallback onClear;

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(36),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Container(
//             width: 72,
//             height: 72,
//             decoration: const BoxDecoration(
//               color: Colours.primaryLight,
//               shape: BoxShape.circle,
//             ),
//             child: const Icon(
//               Icons.assignment_turned_in_outlined,
//               color: Colours.primary,
//               size: 32,
//             ),
//           ),
//           const SizedBox(height: 18),
//           const Text(
//             'No tasks found',
//             style: TextStyle(
//               color: Colours.text,
//               fontSize: 18,
//               fontWeight: FontWeight.w800,
//             ),
//           ),
//           const SizedBox(height: 7),
//           const Text(
//             'Create a task or change your filters to see more work.',
//             textAlign: TextAlign.center,
//             style: TextStyle(color: Colours.mutedText, height: 1.4),
//           ),
//           const SizedBox(height: 12),
//           TextButton(onPressed: onClear, child: const Text('Reset filters')),
//         ],
//       ),
//     );
//   }
// }

// class _ErrorState extends StatelessWidget {
//   const _ErrorState({required this.message, required this.onRetry});

//   final String message;
//   final VoidCallback onRetry;

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(36),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Container(
//             width: 72,
//             height: 72,
//             decoration: const BoxDecoration(
//               color: Colours.errorLight,
//               shape: BoxShape.circle,
//             ),
//             child: const Icon(
//               Icons.cloud_off_rounded,
//               color: Colours.error,
//               size: 32,
//             ),
//           ),
//           const SizedBox(height: 18),
//           const Text(
//             'Could not load tasks',
//             style: TextStyle(
//               color: Colours.text,
//               fontSize: 18,
//               fontWeight: FontWeight.w800,
//             ),
//           ),
//           const SizedBox(height: 7),
//           Text(
//             message,
//             textAlign: TextAlign.center,
//             style: const TextStyle(color: Colours.mutedText, height: 1.4),
//           ),
//           const SizedBox(height: 16),
//           FilledButton.icon(
//             onPressed: onRetry,
//             icon: const Icon(Icons.refresh_rounded),
//             label: const Text('Try again'),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class _FormError extends StatelessWidget {
//   const _FormError({required this.message});

//   final String message;

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: double.infinity,
//       margin: const EdgeInsets.only(top: 12),
//       padding: const EdgeInsets.all(12),
//       decoration: BoxDecoration(
//         color: Colours.errorLight,
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: Colours.error.withValues(alpha: .25)),
//       ),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const Icon(
//             Icons.error_outline_rounded,
//             color: Colours.error,
//             size: 19,
//           ),
//           const SizedBox(width: 9),
//           Expanded(
//             child: Text(
//               message,
//               style: const TextStyle(
//                 color: Colours.error,
//                 fontSize: 12,
//                 height: 1.35,
//                 fontWeight: FontWeight.w600,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class _FieldLabel extends StatelessWidget {
//   const _FieldLabel(this.label);
//   final String label;

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.only(left: 2, bottom: 7),
//       child: Text(
//         label,
//         style: const TextStyle(
//           color: Colours.text,
//           fontSize: 13,
//           fontWeight: FontWeight.w700,
//         ),
//       ),
//     );
//   }
// }

// String _capitalize(String value) {
//   if (value.isEmpty) return value;
//   return '${value[0].toUpperCase()}${value.substring(1)}';
// }

// String _displayDueDate(String? rawDate) {
//   if (rawDate == null || rawDate.isEmpty) return 'No due date';
//   final date = DateTime.tryParse(rawDate);
//   return date == null ? rawDate : _formatDate(date);
// }

// String _formatDate(DateTime date) {
//   const months = [
//     'Jan',
//     'Feb',
//     'Mar',
//     'Apr',
//     'May',
//     'Jun',
//     'Jul',
//     'Aug',
//     'Sep',
//     'Oct',
//     'Nov',
//     'Dec',
//   ];
//   return '${date.day} ${months[date.month - 1]}, ${date.year}';
// }

// String _apiDate(DateTime date) {
//   final month = date.month.toString().padLeft(2, '0');
//   final day = date.day.toString().padLeft(2, '0');
//   return '${date.year}-$month-$day';
// }

// Color _priorityColor(String priority) {
//   switch (priority) {
//     case 'high':
//       return Colours.highPriority;
//     case 'medium':
//       return Colours.mediumPriority;
//     default:
//       return Colours.lowPriority;
//   }
// }

// Color _priorityBackground(String priority) {
//   switch (priority) {
//     case 'high':
//       return Colours.highPriorityLight;
//     case 'medium':
//       return Colours.mediumPriorityLight;
//     default:
//       return Colours.lowPriorityLight;
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:taskflow/core/consts/colours.dart';
import 'package:taskflow/core/consts/lists.dart';
import 'package:taskflow/core/router/app_routes.dart';
import 'package:taskflow/features/tasks/models/task.dart';

import '../controllers/tasks_controller.dart';

class TasksScreen extends GetView<TasksController> {
  const TasksScreen({super.key});

  Future<void> _openAddTaskSheet(BuildContext context) async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colours.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (_) => _AddTaskSheet(controller: controller),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openAddTaskSheet(context),
        backgroundColor: Colours.primary,
        foregroundColor: Colors.white,
        elevation: 3,
        icon: const Icon(Icons.add_rounded),
        label: const Text(
          'New task',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 900),
            child: RefreshIndicator(
              color: Colours.primary,
              onRefresh: controller.getAllTasks,
              child: CustomScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                slivers: [
                  SliverPadding(
                    padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 0),
                    sliver: SliverToBoxAdapter(child: _Header(controller)),
                  ),
                  SliverPadding(
                    padding: EdgeInsets.fromLTRB(20.w, 22.h, 20.w, 10.h),
                    sliver: SliverToBoxAdapter(
                      child: _Filters(controller: controller),
                    ),
                  ),
                  Obx(() => _taskContent()),
                  SliverToBoxAdapter(child: SizedBox(height: 100.h)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _taskContent() {
    if (controller.isLoading.value && controller.tasks.isEmpty) {
      return const SliverFillRemaining(
        hasScrollBody: false,
        child: Center(child: CircularProgressIndicator()),
      );
    }
    if (controller.loadError.value != null && controller.tasks.isEmpty) {
      return SliverFillRemaining(
        hasScrollBody: false,
        child: _ErrorState(
          message: controller.loadError.value!,
          onRetry: controller.getAllTasks,
        ),
      );
    }
    if (controller.tasks.isEmpty) {
      return SliverFillRemaining(
        hasScrollBody: false,
        child: _EmptyState(onClear: controller.clearFilters),
      );
    }
    return SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      sliver: SliverList.separated(
        itemCount: controller.tasks.length,
        separatorBuilder: (_, _) => SizedBox(height: 12.h),
        itemBuilder: (context, index) {
          final task = controller.tasks[index];
          return _TaskCard(
            task: task,
            isToggling:
                task.id != null && controller.togglingTaskIds.contains(task.id),
            onToggle: () => controller.toggleTask(task),
            onTap: () => Get.toNamed(
              Routes.taskDetailsScreen,
              arguments: task,
            )?.then((_) => controller.getAllTasks()),
          );
        },
      ),
    );
  }
}

/// Owns the text controllers so they are disposed only after the bottom sheet
/// has been fully removed from the tree (after its exit animation).
class _AddTaskSheet extends StatefulWidget {
  const _AddTaskSheet({required this.controller});
  final TasksController controller;

  @override
  State<_AddTaskSheet> createState() => _AddTaskSheetState();
}

class _AddTaskSheetState extends State<_AddTaskSheet> {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  DateTime? dueDate;
  String priority = AppLists.priorities.first;
  String assignee = AppLists.assignees.first;

  TasksController get controller => widget.controller;

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 20.w,
        right: 20.w,
        top: 12.h,
        bottom: MediaQuery.viewInsetsOf(context).bottom + 20.h,
      ),
      child: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: Container(
                  width: 42.w,
                  height: 4.h,
                  decoration: BoxDecoration(
                    color: Colours.border,
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
              SizedBox(height: 22.h),
              const Text(
                'Create a new task',
                style: TextStyle(
                  color: Colours.text,
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                ),
              ),
              SizedBox(height: 6.h),
              const Text(
                'Add the details and assign it to your team.',
                style: TextStyle(color: Colours.mutedText, fontSize: 14),
              ),
              SizedBox(height: 22.h),
              const _FieldLabel('Task title'),
              TextFormField(
                controller: titleController,
                onChanged: (_) => controller.clearSubmissionError(),
                textCapitalization: TextCapitalization.sentences,
                decoration: const InputDecoration(
                  hintText: 'e.g. Prepare launch report',
                  prefixIcon: Icon(Icons.task_alt_rounded),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a task title';
                  }
                  final fieldError = controller.submissionFieldErrors['title'];
                  if (fieldError != null) return fieldError;
                  return null;
                },
              ),
              SizedBox(height: 16.h),
              const _FieldLabel('Description'),
              TextFormField(
                controller: descriptionController,
                textCapitalization: TextCapitalization.sentences,
                minLines: 3,
                maxLines: 5,
                decoration: const InputDecoration(
                  hintText: 'What needs to be done?',
                  alignLabelWithHint: true,
                ),
              ),
              SizedBox(height: 16.h),
              const _FieldLabel('Due date'),
              InkWell(
                borderRadius: BorderRadius.circular(14),
                onTap: () async {
                  final selected = await showDatePicker(
                    context: context,
                    initialDate: dueDate ?? DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 3650)),
                  );
                  if (selected != null && mounted) {
                    setState(() => dueDate = selected);
                  }
                },
                child: InputDecorator(
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.calendar_today_rounded),
                    suffixIcon: Icon(Icons.keyboard_arrow_down_rounded),
                  ),
                  child: Text(
                    dueDate == null ? 'Select a date' : _formatDate(dueDate!),
                    style: TextStyle(
                      color: dueDate == null ? Colours.mutedText : Colours.text,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16.h),
              const _FieldLabel('Priority'),
              Row(
                children: AppLists.priorities
                    .map(
                      (item) => Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(
                            right: item == AppLists.priorities.last ? 0 : 8.w,
                          ),
                          child: ChoiceChip(
                            label: SizedBox(
                              width: double.infinity,
                              child: Text(
                                _capitalize(item),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            selected: priority == item,
                            onSelected: (_) => setState(() {
                              priority = item;
                              controller.clearSubmissionError();
                            }),
                            selectedColor: _priorityBackground(item),
                            checkmarkColor: _priorityColor(item),
                            labelStyle: TextStyle(
                              color: priority == item
                                  ? _priorityColor(item)
                                  : Colours.mutedText,
                              fontWeight: FontWeight.w700,
                            ),
                            side: BorderSide(
                              color: priority == item
                                  ? _priorityColor(item)
                                  : Colours.border,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
              SizedBox(height: 16.h),
              const _FieldLabel('Assign to'),
              DropdownButtonFormField<String>(
                initialValue: assignee,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.person_outline_rounded),
                ),
                items: AppLists.assignees
                    .map(
                      (item) => DropdownMenuItem(
                        value: item,
                        child: Text(_capitalize(item)),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  setState(() => assignee = value ?? assignee);
                  controller.clearSubmissionError();
                },
              ),
              Obx(() {
                final message = controller.submissionError.value;
                if (message == null ||
                    message.toLowerCase().contains('title')) {
                  return const SizedBox.shrink();
                }
                return _FormError(message: message);
              }),
              SizedBox(height: 24.h),
              SizedBox(
                width: double.infinity,
                child: Obx(
                  () => FilledButton.icon(
                    onPressed: controller.isSubmitting.value
                        ? null
                        : () async {
                            if (!formKey.currentState!.validate()) return;
                            final created = await controller.addTask(
                              title: titleController.text.trim(),
                              description: descriptionController.text.trim(),
                              dueDate: dueDate == null
                                  ? null
                                  : _apiDate(dueDate!),
                              priority: priority,
                              assignedId: assignee,
                            );
                            if (!mounted) return;
                            if (!created) {
                              formKey.currentState!.validate();
                            }
                            if (created) {
                              Navigator.pop(context);
                              Get.snackbar(
                                'Task created',
                                'The task was added to your workflow.',
                                snackPosition: SnackPosition.BOTTOM,
                                margin: const EdgeInsets.all(16),
                                backgroundColor: Colours.text,
                                colorText: Colors.white,
                              );
                            }
                          },
                    icon: controller.isSubmitting.value
                        ? const SizedBox.square(
                            dimension: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Icon(Icons.add_rounded),
                    label: Text(
                      controller.isSubmitting.value
                          ? 'Creating task...'
                          : 'Create task',
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header(this.controller);
  final TasksController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 44.w,
              height: 44.w,
              decoration: BoxDecoration(
                color: Colours.primary,
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Icon(Icons.check_rounded, color: Colors.white),
            ),
            SizedBox(width: 12.w),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'TaskFlow',
                    style: TextStyle(
                      color: Colours.text,
                      fontSize: 22,
                      height: 1,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    'Team workspace',
                    style: TextStyle(color: Colours.mutedText, fontSize: 12),
                  ),
                ],
              ),
            ),
            IconButton.filledTonal(
              onPressed: controller.getAllTasks,
              tooltip: 'Refresh tasks',
              icon: const Icon(Icons.refresh_rounded),
            ),
          ],
        ),
        SizedBox(height: 28.h),
        const Text(
          'Good day, Admin 👋',
          style: TextStyle(
            color: Colours.text,
            fontSize: 26,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.5,
          ),
        ),
        SizedBox(height: 6.h),
        const Text(
          'Keep your team focused and work moving forward.',
          style: TextStyle(color: Colours.mutedText, fontSize: 14),
        ),
        SizedBox(height: 20.h),
        Obx(
          () => Row(
            children: [
              Expanded(
                child: _SummaryCard(
                  label: 'All tasks',
                  value: controller.totalTasks,
                  icon: Icons.layers_rounded,
                  color: Colours.primary,
                  background: Colours.primaryLight,
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: _SummaryCard(
                  label: 'In progress',
                  value: controller.activeTasks,
                  icon: Icons.timelapse_rounded,
                  color: Colours.warning,
                  background: Colours.warningLight,
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: _SummaryCard(
                  label: 'Completed',
                  value: controller.completedTasks,
                  icon: Icons.task_alt_rounded,
                  color: Colours.success,
                  background: Colours.successLight,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
    required this.background,
  });
  final String label;
  final int value;
  final IconData icon;
  final Color color;
  final Color background;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Colours.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colours.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32.w,
            height: 32.w,
            decoration: BoxDecoration(
              color: background,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 17, color: color),
          ),
          SizedBox(height: 12.h),
          Text(
            '$value',
            style: const TextStyle(
              color: Colours.text,
              fontSize: 22,
              fontWeight: FontWeight.w800,
            ),
          ),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: Colours.mutedText, fontSize: 11),
          ),
        ],
      ),
    );
  }
}

class _Filters extends StatelessWidget {
  const _Filters({required this.controller});
  final TasksController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            const Expanded(
              child: Text(
                'Tasks',
                style: TextStyle(
                  color: Colours.text,
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            Obx(
              () => AnimatedSwitcher(
                duration: const Duration(milliseconds: 180),
                child:
                    controller.assigned.value != null ||
                        controller.status.value != null
                    ? TextButton(
                        key: const ValueKey('clear'),
                        onPressed: controller.clearFilters,
                        child: const Text('Clear filters'),
                      )
                    : const SizedBox.shrink(key: ValueKey('empty')),
              ),
            ),
          ],
        ),
        SizedBox(height: 10.h),
        Row(
          children: [
            Expanded(
              child: Obx(
                () => _FilterMenu(
                  icon: Icons.person_outline_rounded,
                  hint: 'Assignee',
                  value: controller.assigned.value,
                  values: AppLists.assignees,
                  onChanged: (value) => controller.assigned.value = value,
                ),
              ),
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: Obx(
                () => _FilterMenu(
                  icon: Icons.tune_rounded,
                  hint: 'Status',
                  value: controller.status.value,
                  values: AppLists.statuses,
                  onChanged: (value) => controller.status.value = value,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _FilterMenu extends StatelessWidget {
  const _FilterMenu({
    required this.icon,
    required this.hint,
    required this.value,
    required this.values,
    required this.onChanged,
  });
  final IconData icon;
  final String hint;
  final String? value;
  final List<String> values;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String?>(
      onSelected: onChanged,
      itemBuilder: (_) => [
        PopupMenuItem<String?>(value: null, child: Text('All $hint')),
        ...values.map(
          (item) => PopupMenuItem<String?>(
            value: item,
            child: Text(_capitalize(item)),
          ),
        ),
      ],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Container(
        height: 46.h,
        padding: EdgeInsets.symmetric(horizontal: 13.w),
        decoration: BoxDecoration(
          color: value == null ? Colours.surface : Colours.primaryLight,
          borderRadius: BorderRadius.circular(13),
          border: Border.all(
            color: value == null ? Colours.border : Colours.primary,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 18,
              color: value == null ? Colours.mutedText : Colours.primary,
            ),
            SizedBox(width: 8.w),
            Expanded(
              child: Text(
                value == null ? hint : _capitalize(value!),
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: value == null ? Colours.mutedText : Colours.primary,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const Icon(
              Icons.keyboard_arrow_down_rounded,
              size: 18,
              color: Colours.mutedText,
            ),
          ],
        ),
      ),
    );
  }
}

class _TaskCard extends StatelessWidget {
  const _TaskCard({
    required this.task,
    required this.isToggling,
    required this.onToggle,
    required this.onTap,
  });
  final Task task;
  final bool isToggling;
  final VoidCallback onToggle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final completed = task.completed ?? false;
    final priority = task.priority?.toLowerCase() ?? 'low';
    final priorityColor = _priorityColor(priority);
    final priorityBackground = _priorityBackground(priority);
    final overdue = task.isOverdue();
    return Material(
      color: overdue
          ? Colours.errorLight.withValues(alpha: .32)
          : Colours.surface,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Container(
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: overdue
                  ? Colours.error.withValues(alpha: .35)
                  : Colours.border,
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Semantics(
                label: completed ? 'Mark task active' : 'Mark task complete',
                button: true,
                child: InkWell(
                  onTap: isToggling ? null : onToggle,
                  borderRadius: BorderRadius.circular(12),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    width: 28.w,
                    height: 28.w,
                    decoration: BoxDecoration(
                      color: completed ? Colours.success : Colors.transparent,
                      borderRadius: BorderRadius.circular(9),
                      border: Border.all(
                        color: completed ? Colours.success : Colours.border,
                        width: 1.5,
                      ),
                    ),
                    child: isToggling
                        ? Padding(
                            padding: const EdgeInsets.all(6),
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: completed ? Colors.white : Colours.primary,
                            ),
                          )
                        : completed
                        ? const Icon(
                            Icons.check_rounded,
                            size: 18,
                            color: Colors.white,
                          )
                        : null,
                  ),
                ),
              ),
              SizedBox(width: 13.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            task.title ?? 'Untitled task',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: completed
                                  ? Colours.mutedText
                                  : Colours.text,
                              fontSize: 16,
                              height: 1.25,
                              fontWeight: FontWeight.w700,
                              decoration: completed
                                  ? TextDecoration.lineThrough
                                  : null,
                            ),
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 9,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: priorityBackground,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            _capitalize(priority),
                            style: TextStyle(
                              color: priorityColor,
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ],
                    ),
                    if ((task.description ?? '').trim().isNotEmpty) ...[
                      SizedBox(height: 7.h),
                      Text(
                        task.description!,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colours.mutedText,
                          fontSize: 13,
                          height: 1.35,
                        ),
                      ),
                    ],
                    SizedBox(height: 13.h),
                    Wrap(
                      spacing: 14.w,
                      runSpacing: 7.h,
                      children: [
                        if (overdue)
                          const _MetaItem(
                            icon: Icons.warning_amber_rounded,
                            label: 'Overdue',
                            color: Colours.error,
                          ),
                        _MetaItem(
                          icon: Icons.calendar_today_rounded,
                          label: _displayDueDate(task.dueDate),
                        ),
                        _MetaItem(
                          icon: Icons.person_outline_rounded,
                          label: _capitalize(task.assignedId ?? 'Unassigned'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(top: 2),
                child: Icon(
                  Icons.chevron_right_rounded,
                  color: Colours.mutedText,
                  size: 21,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MetaItem extends StatelessWidget {
  const _MetaItem({
    required this.icon,
    required this.label,
    this.color = Colours.mutedText,
  });
  final IconData icon;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: color),
        const SizedBox(width: 5),
        Text(
          label,
          style: TextStyle(
            color: color,
            fontSize: 11,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.onClear});
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(36),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: const BoxDecoration(
              color: Colours.primaryLight,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.assignment_turned_in_outlined,
              color: Colours.primary,
              size: 32,
            ),
          ),
          const SizedBox(height: 18),
          const Text(
            'No tasks found',
            style: TextStyle(
              color: Colours.text,
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 7),
          const Text(
            'Create a task or change your filters to see more work.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colours.mutedText, height: 1.4),
          ),
          const SizedBox(height: 12),
          TextButton(onPressed: onClear, child: const Text('Reset filters')),
        ],
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(36),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: const BoxDecoration(
              color: Colours.errorLight,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.cloud_off_rounded,
              color: Colours.error,
              size: 32,
            ),
          ),
          const SizedBox(height: 18),
          const Text(
            'Could not load tasks',
            style: TextStyle(
              color: Colours.text,
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 7),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colours.mutedText, height: 1.4),
          ),
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh_rounded),
            label: const Text('Try again'),
          ),
        ],
      ),
    );
  }
}

class _FormError extends StatelessWidget {
  const _FormError({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colours.errorLight,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colours.error.withValues(alpha: .25)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.error_outline_rounded,
            color: Colours.error,
            size: 19,
          ),
          const SizedBox(width: 9),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                color: Colours.error,
                fontSize: 12,
                height: 1.35,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  const _FieldLabel(this.label);
  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 2, bottom: 7),
      child: Text(
        label,
        style: const TextStyle(
          color: Colours.text,
          fontSize: 13,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

String _capitalize(String value) {
  if (value.isEmpty) return value;
  return '${value[0].toUpperCase()}${value.substring(1)}';
}

String _displayDueDate(String? rawDate) {
  if (rawDate == null || rawDate.isEmpty) return 'No due date';
  final date = DateTime.tryParse(rawDate);
  return date == null ? rawDate : _formatDate(date);
}

String _formatDate(DateTime date) {
  const months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];
  return '${date.day} ${months[date.month - 1]}, ${date.year}';
}

String _apiDate(DateTime date) {
  final month = date.month.toString().padLeft(2, '0');
  final day = date.day.toString().padLeft(2, '0');
  return '${date.year}-$month-$day';
}

Color _priorityColor(String priority) {
  switch (priority) {
    case 'high':
      return Colours.highPriority;
    case 'medium':
      return Colours.mediumPriority;
    default:
      return Colours.lowPriority;
  }
}

Color _priorityBackground(String priority) {
  switch (priority) {
    case 'high':
      return Colours.highPriorityLight;
    case 'medium':
      return Colours.mediumPriorityLight;
    default:
      return Colours.lowPriorityLight;
  }
}
