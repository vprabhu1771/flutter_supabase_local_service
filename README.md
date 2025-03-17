# flutter_supabase_local_service

Flutter Role-Based Structure

To organize your Flutter project with different roles like Admin, Freelancer, and Customer, each having their own dashboard, you can structure the project by creating separate directories for each role. You can also make use of shared components and layouts to avoid redundancy. Here's an example folder structure:

```
lib/
├── main.dart
├── app/
│   ├── screens/
│   │   ├── common/
│   │   │   ├── login_screen.dart
│   │   │   ├── splash_screen.dart
│   │   │   └── profile_screen.dart
│   │   ├── customer/
│   │   │   ├── customer_dashboard.dart
│   │   │   ├── customer_profile.dart
│   │   │   └── customer_orders.dart
│   │   ├── freelancer/
│   │   │   ├── freelancer_dashboard.dart
│   │   │   ├── freelancer_projects.dart
│   │   │   └── freelancer_profile.dart
│   │   ├── admin/
│   │   │   ├── admin_dashboard.dart
│   │   │   ├── admin_users.dart
│   │   │   └── admin_settings.dart
│   ├── widgets/
│   │   ├── custom_drawer.dart
│   │   ├── app_bar.dart
│   │   └── role_based_widget.dart
│   ├── services/
│   │   ├── auth_service.dart
│   │   └── user_service.dart
│   └── models/
│       ├── user_model.dart
│       └── role_model.dart
├── utils/
│   ├── constants.dart
│   ├── theme.dart
│   └── navigation.dart
```

### Breakdown:
1. **`screens/`**: This folder contains role-specific screens:
    - **common/**: Contains shared screens like login, splash, and profile that can be used across all roles.
    - **customer/**: Contains screens specific to the Customer role (e.g., customer dashboard, orders).
    - **freelancer/**: Contains screens specific to the Freelancer role (e.g., freelancer dashboard, projects).
    - **admin/**: Contains screens specific to the Admin role (e.g., admin dashboard, user management).

2. **`widgets/`**: This folder contains reusable widgets like custom drawers, app bars, or role-based widgets to display role-specific content.

3. **`services/`**: Contains services to handle authentication, user data fetching, etc. The `auth_service.dart` could manage role-based authentication and user data.

4. **`models/`**: Contains the `UserModel` and `RoleModel` to define the structure of user data and roles.

5. **`utils/`**: Contains constants (e.g., role names) and utilities like navigation, themes, etc.

### Example of handling role-based navigation:
You could handle role-based navigation in your `main.dart` or a navigation utility file:

```dart
void navigateToRoleBasedDashboard(User user) {
  if (user.role == 'admin') {
    Navigator.pushNamed(context, '/admin_dashboard');
  } else if (user.role == 'freelancer') {
    Navigator.pushNamed(context, '/freelancer_dashboard');
  } else {
    Navigator.pushNamed(context, '/customer_dashboard');
  }
}
```

In your routing or navigation setup, you can then use these role-based paths to direct users to the correct screen after login.

This structure keeps the project clean, modular, and easy to manage with separate sections for each role.