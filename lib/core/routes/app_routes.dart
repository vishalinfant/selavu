import 'package:go_router/go_router.dart';
import 'package:selavu/core/routes/route_names.dart';
import 'package:selavu/models/expense_model.dart';
import 'package:selavu/screens/bottomMenu/bottom_menu.dart';
import 'package:selavu/screens/categories/manage_category_screen.dart';
import 'package:selavu/screens/expenses/add_expense_screen.dart';
import 'package:selavu/screens/expenses/category_based_expenses_screen.dart';

import '../../screens/expenses/edit_expense_screen.dart';
import '../../screens/splash_screen.dart';

final appRouter = GoRouter(
    routes: [
      GoRoute(
        path: RouteNames.splashScreen,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: RouteNames.bottomMenu,
        builder: (context, state) => BottomMenu(),
      ),
      GoRoute(
        path: RouteNames.addExpenseScreen,
        builder: (context, state) => const AddExpenseScreen(),
      ),
      GoRoute(
        path: RouteNames.editExpenseScreen,
        builder: (context, state) {
          final data = state.extra as Expense;
          return EditExpenseScreen(expense: data);
        },
      ),
      GoRoute(
        path: RouteNames.manageCategoryScreen,
        builder: (context, state) => const ManageCategoryScreen(),
      ),
      GoRoute(
        path: RouteNames.categoryBasedExpensesScreen,
        builder: (context, state) {
          final data = state.extra as Map<String, dynamic>;
          return CategoryBasedExpensesScreen(category: data["category"]);
        },
      ),
    ]
);