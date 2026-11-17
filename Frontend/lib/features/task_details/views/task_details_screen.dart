import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:taskflow/core/consts/colours.dart';
import 'package:taskflow/features/tasks/models/task.dart';

import '../controllers/task_details_controller.dart';

class TaskDetailsScreen extends GetView<TaskDetailsController> {
  const TaskDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(8),
          child: IconButton.filledTonal(
            onPressed: Get.back,
            tooltip: 'Back',
            icon: const Icon(Icons.arrow_back_rounded),
          ),
        ),
        title: const Text(
          'Task details',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 720),
            child: Obx(() {
              final task = controller.task.value;
              if (task == null) {
                return const Center(
                  child: Text('Task information unavailable'),
                );
              }
              return _DetailsBody(task: task, controller: controller);
            }),
          ),
        ),
      ),
    );
  }
}

class _DetailsBody extends StatelessWidget {
  const _DetailsBody({required this.task, required this.controller});

  final Task task;
  final TaskDetailsController controller;

  @override
  Widget build(BuildContext context) {
    final completed = task.completed ?? false;
    final priority = task.priority?.toLowerCase() ?? 'low';
    final priorityColor = _priorityColor(priority);

    return ListView(
      padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 28.h),
      children: [
        Container(
          padding: EdgeInsets.all(20.w),
          decoration: BoxDecoration(
            color: Colours.surface,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: Colours.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: _priorityBackground(priority),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 6,
                          height: 6,
                          decoration: BoxDecoration(
                            color: priorityColor,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          '${_capitalize(priority)} priority',
                          style: TextStyle(
                            color: priorityColor,
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: completed
                          ? Colours.successLight
                          : Colours.warningLight,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      completed ? 'Completed' : 'In progress',
                      style: TextStyle(
                        color: completed ? Colours.success : Colours.warning,
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20.h),
              Text(
                task.title ?? 'Untitled task',
                style: const TextStyle(
                  color: Colours.text,
                  fontSize: 25,
                  height: 1.22,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.4,
                ),
              ),
              SizedBox(height: 13.h),
              Text(
                (task.description ?? '').trim().isEmpty
                    ? 'No description was added for this task.'
                    : task.description!,
                style: const TextStyle(
                  color: Colours.mutedText,
                  fontSize: 14,
                  height: 1.55,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 16.h),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 4.h),
          decoration: BoxDecoration(
            color: Colours.surface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colours.border),
          ),
          child: Column(
            children: [
              _DetailRow(
                icon: Icons.person_outline_rounded,
                iconColor: Colours.primary,
                iconBackground: Colours.primaryLight,
                label: 'Assigned to',
                value: _capitalize(task.assignedId ?? 'Unassigned'),
              ),
              const Divider(height: 1),
              _DetailRow(
                icon: Icons.calendar_today_rounded,
                iconColor: Colours.mediumPriority,
                iconBackground: Colours.mediumPriorityLight,
                label: 'Due date',
                value: _displayDate(task.dueDate),
              ),
              const Divider(height: 1),
              _DetailRow(
                icon: Icons.flag_outlined,
                iconColor: priorityColor,
                iconBackground: _priorityBackground(priority),
                label: 'Priority',
                value: _capitalize(priority),
              ),
            ],
          ),
        ),
        SizedBox(height: 24.h),
        Obx(
          () => SizedBox(
            height: 54.h,
            child: FilledButton.icon(
              onPressed: controller.isToggling.value
                  ? null
                  : controller.toggleStatus,
              style: FilledButton.styleFrom(
                backgroundColor: completed ? Colours.surface : Colours.primary,
                foregroundColor: completed ? Colours.primary : Colors.white,
                side: completed
                    ? const BorderSide(color: Colours.primary)
                    : BorderSide.none,
              ),
              icon: controller.isToggling.value
                  ? SizedBox.square(
                      dimension: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: completed ? Colours.primary : Colors.white,
                      ),
                    )
                  : Icon(
                      completed
                          ? Icons.restart_alt_rounded
                          : Icons.check_circle_outline_rounded,
                    ),
              label: Text(completed ? 'Mark as active' : 'Mark as completed'),
            ),
          ),
        ),
      ],
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({
    required this.icon,
    required this.iconColor,
    required this.iconBackground,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final Color iconColor;
  final Color iconBackground;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 14.h),
      child: Row(
        children: [
          Container(
            width: 40.w,
            height: 40.w,
            decoration: BoxDecoration(
              color: iconBackground,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: iconColor, size: 19),
          ),
          SizedBox(width: 13.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    color: Colours.mutedText,
                    fontSize: 11,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  value,
                  style: const TextStyle(
                    color: Colours.text,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

String _capitalize(String value) {
  if (value.isEmpty) return value;
  return '${value[0].toUpperCase()}${value.substring(1)}';
}

String _displayDate(String? rawDate) {
  if (rawDate == null || rawDate.isEmpty) return 'No due date';
  final date = DateTime.tryParse(rawDate);
  if (date == null) return rawDate;
  const months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];
  return '${date.day} ${months[date.month - 1]} ${date.year}';
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
