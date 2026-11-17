# TaskFlow

## How to Run Locally

TaskFlow is a Flutter/Dart mobile application using Material 3, GetX for routing and reactive state, Dio for REST communication, and ScreenUtil for responsive sizing; this stack was selected because it keeps a small two-screen app structured, testable, and quick to run on both Android and iOS.

Prerequisites: Flutter SDK compatible with Dart `^3.13.5`, Android Studio or Xcode, and an emulator, simulator, or connected device.

```bash
flutter pub get
flutter run
```

Run the quality checks with:

```bash
flutter analyze
flutter test
```

No environment variables are currently required. The assessment API base URL is configured in `lib/core/network/api_client.dart` as `https://taskflow-two-red.vercel.app/api/v1`; change `BaseOptions.baseUrl` there when using another backend. The app consumes `GET /tasks`, `POST /tasks`, and `PATCH /tasks/:id/toggle`, including combined `assignee` and `status` query parameters.

## Screen Structure

Task List → Task Detail → Back to Task List; the add-task form opens as a modal bottom sheet from the Task List.

The Task List includes loading, retryable error, filtered empty, and populated states; tasks with no due date show “No due date,” invalid dates fail safely, and only incomplete tasks with a due date before the device’s current local calendar day receive the red overdue treatment. Completed tasks are not labelled overdue because no action is required after completion. The add form validates the title locally, uses selectable priority chips, supplies a calendar date picker, submits dates as `YYYY-MM-DD`, and maps server field errors such as `errors.title` back to the title field.

## Decision 1 — Optimistic vs. Pessimistic

Task completion uses an optimistic update so the control responds immediately on mobile, while the previous value is restored and an error is shown if the server rejects the request.

## Decision 2 — Filter Persistence

Assignee and status filters remain applied after opening a task and returning because administrators commonly inspect several tasks within the same filtered work queue.

## Bug Hunt

- **Timezone handling:** `new Date().toISOString()` converts the device time to UTC, so near midnight its date can differ from the user’s local calendar date and incorrectly mark a task overdue or not overdue.
- **Missing or invalid data:** JavaScript comparison silently coerces `null`, `undefined`, or malformed `dueDate` values instead of validating them, producing a misleading `false` result without revealing bad or absent data.

## AI Usage

OpenAI Codex was used to interpret the assessment, propose and implement the Material 3 interface, refactor GetX state and API error handling, add edge-case tests, and draft this README. The submitted behavior was then checked against the assessment requirements and configured live API response shape, and the final source was verified with `flutter analyze` and `flutter test`; the implementation and trade-offs should still be reviewed and understood before the technical interview.
