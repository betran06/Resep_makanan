import 'package:flutter/material.dart';

class SettingsTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;
  final Color? color;
  final Widget? trailing;

  const SettingsTile({
    super.key,
    required this.icon,
    required this.label,
    this.onTap,
    this.color,
    this.trailing,
  });

  /// Variant switch
  factory SettingsTile.switcher({
    required IconData icon,
    required String label,
    required bool value,
    required ValueChanged<bool> onChanged,
    Color? color,
  }) {
    return SettingsTile(
      icon: icon,
      label: label,
      color: color,
      trailing: Switch(value: value, onChanged: onChanged),
    );
  }

  /// ✅ Variant dropdown (static generic builder; bukan constructor)
  static SettingsTile dropdown<T>({
    required IconData icon,
    required String label,
    required T value,
    required List<DropdownMenuItem<T>> items,
    required ValueChanged<T?> onChanged,
    Color? color,
  }) {
    return SettingsTile(
      icon: icon,
      label: label,
      color: color,
      trailing: DropdownButton<T>(
        value: value,
        items: items,
        onChanged: onChanged,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    final tileColor = Colors.white;
    final splashColor = (color ?? cs.primary).withOpacity(.08);

    return Material(
      color: tileColor,
      elevation: 2,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        splashColor: splashColor,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          child: Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: (color ?? cs.primary).withOpacity(.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: color ?? cs.primary),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  label,
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge
                      ?.copyWith(fontWeight: FontWeight.w600),
                ),
              ),
              trailing ??
                  Icon(Icons.chevron_right_rounded,
                      color: Colors.grey.shade600),
            ],
          ),
        ),
      ),
    );
  }
}
