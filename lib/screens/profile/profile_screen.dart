import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../config/theme.dart';
import '../../providers/index.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  bool _isEditing = false;
  bool _isSaving = false;
  bool _pushNotificationsEnabled = true;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _phoneController = TextEditingController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final authState = ref.read(authStateProvider);
    if (authState != null) {
      _nameController.text = authState.name;
      _emailController.text = authState.email;
      _phoneController.text = authState.phone;
      _pushNotificationsEnabled = authState.pushNotificationsEnabled;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authStateProvider);
    final isGuest = ref.watch(isGuestModeProvider);

    // If neither logged in nor guest, show sign-in prompt
    if (authState == null && !isGuest) {
      return Scaffold(
        backgroundColor: AppTheme.backgroundColor,
        appBar: AppBar(
          title: const Text('Profile'),
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: false,
          titleTextStyle: const TextStyle(
            color: Colors.black,
            fontSize: 26,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.5,
          ),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppTheme.secondaryColor,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.person_outline_rounded,
                    size: 64,
                    color: AppTheme.primaryColor,
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Join UniBites!',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    color: AppTheme.primaryColor,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Sign in to save your orders, track history, and manage your preferences.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => context.go('/login'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: const Text(
                      'Sign In / Up',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final displayName = authState?.name ?? 'Guest User';
    final displayEmail = authState?.email ?? 'Browsing as Guest';
    final photoUrl = authState?.profilePhoto;

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: const TextStyle(
          color: Colors.black,
          fontSize: 26,
          fontWeight: FontWeight.w800,
          letterSpacing: -0.5,
        ),
        actions: [
          IconButton(
            onPressed: () => setState(() => _isEditing = !_isEditing),
            icon: Icon(
              _isEditing ? Icons.close : Icons.edit_outlined,
              color: AppTheme.primaryColor,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header Section
            Container(
              width: double.infinity,
              color: Colors.white,
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
              child: Column(
                children: [
                  // Avatar Section
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border:
                          Border.all(color: AppTheme.secondaryColor, width: 4),
                      image: photoUrl != null
                          ? DecorationImage(
                              image: NetworkImage(photoUrl),
                              fit: BoxFit.cover,
                            )
                          : null,
                      color: photoUrl == null ? AppTheme.secondaryColor : null,
                    ),
                    child: photoUrl == null
                        ? Center(
                            child: Text(
                              displayName[0].toUpperCase(),
                              style: const TextStyle(
                                fontSize: 40,
                                fontWeight: FontWeight.w800,
                                color: AppTheme.primaryColor,
                              ),
                            ),
                          )
                        : null,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    displayName,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    displayEmail,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  if (isGuest)
                    Padding(
                      padding: const EdgeInsets.only(top: 12),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: AppTheme.secondaryColor,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          'LIMITED MODE',
                          style: TextStyle(
                            fontSize: 10,
                            letterSpacing: 1.2,
                            color: AppTheme.primaryColor,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Personal Info Section
                  _buildSectionTitle('ACCOUNT INFORMATION'),
                  const SizedBox(height: 12),
                  _buildInfoCard(
                    icon: Icons.person_rounded,
                    label: 'Full Name',
                    controller: _nameController,
                    isEditing: _isEditing,
                  ),
                  _buildInfoCard(
                    icon: Icons.email_rounded,
                    label: 'Email Address',
                    controller: _emailController,
                    isEditing: false, // Email remains locked
                  ),

                  const SizedBox(height: 32),

                  // Preferences Section
                  _buildSectionTitle('PREFERENCES'),
                  const SizedBox(height: 12),
                  _buildPreferenceTile(
                    icon: Icons.notifications_active_rounded,
                    title: 'Push Notifications',
                    subtitle: 'Stay updated on your orders',
                    value: _pushNotificationsEnabled,
                    onChanged: (val) =>
                        setState(() => _pushNotificationsEnabled = val),
                  ),

                  const SizedBox(height: 48),

                  // Action Buttons
                  if (_isEditing)
                    _buildSolidButton(
                      label: 'SAVE CHANGES',
                      isLoading: _isSaving,
                      onPressed: () async {
                        setState(() => _isSaving = true);
                        await Future.delayed(const Duration(seconds: 1));
                        if (mounted) {
                          setState(() {
                            _isSaving = false;
                            _isEditing = false;
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Changes saved!')),
                          );
                        }
                      },
                    ),

                  const SizedBox(height: 8),

                  // Sign Out
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _handleSignOut,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red.withValues(alpha: 0.1),
                        foregroundColor: Colors.red,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: Text(
                        isGuest ? 'BACK TO LOGIN' : 'SIGN OUT',
                        style: const TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 14,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 80), // Padding for navbar
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w900,
        color: Colors.grey,
        letterSpacing: 1.2,
      ),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String label,
    required TextEditingController controller,
    required bool isEditing,
    String? hint,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppTheme.secondaryColor.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: AppTheme.primaryColor, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey[500],
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (!isEditing)
                  Text(
                    controller.text.isEmpty
                        ? (hint ?? 'Not set')
                        : controller.text,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: controller.text.isEmpty
                          ? Colors.grey
                          : Colors.black87,
                    ),
                  )
                else
                  TextField(
                    controller: controller,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                    decoration: const InputDecoration(
                      isDense: true,
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.only(top: 4),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPreferenceTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required Function(bool) onChanged,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(8),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.blue.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(Icons.notifications_active_rounded,
              color: Colors.blue, size: 20),
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(fontSize: 12, color: Colors.grey[500]),
        ),
        trailing: Switch.adaptive(
          value: value,
          onChanged: onChanged,
          activeTrackColor: AppTheme.primaryColor,
        ),
      ),
    );
  }

  Widget _buildSolidButton({
    required String label,
    required VoidCallback onPressed,
    bool isLoading = false,
  }) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.primaryColor,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 18),
          elevation: 2,
          shadowColor: AppTheme.primaryColor.withValues(alpha: 0.4),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: isLoading
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 3,
                ),
              )
            : Text(
                label,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.2,
                ),
              ),
      ),
    );
  }

  Future<void> _handleSignOut() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Sign Out'),
        content: const Text('Are you sure you want to exit your profile?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('CANCEL'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text(
              'SIGN OUT',
              style: TextStyle(
                  color: Colors.redAccent, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      await ref.read(authStateProvider.notifier).logout();
      if (mounted) {
        context.go('/login');
      }
    }
  }
}
