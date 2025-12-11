import 'package:flutter/material.dart';
// Removed cached_network_image dependency; use native Image.network + builders

class CustomProfileImage extends StatelessWidget {
  final String? imageUrl;
  final String? username;
  final double radius;
  final bool showBorder;
  final Color? borderColor;
  final double borderWidth;

  const CustomProfileImage({
    super.key,
    this.imageUrl,
    this.username,
    this.radius = 40.0,
    this.showBorder = false,
    this.borderColor,
    this.borderWidth = 2.5,
  });

  // EXACT same 50 colors + identical hashing logic as your React version
  static const List<Color> _avatarColors = [
    Color(0xFF1A237E),
    Color(0xFF283593),
    Color(0xFF303F9F),
    Color(0xFF3949AB),
    Color(0xFF3F51B5),
    Color(0xFF4527A0),
    Color(0xFF512DA8),
    Color(0xFF5E35B1),
    Color(0xFF6A1B9A),
    Color(0xFF7B1FA2),
    Color(0xFF880E4F),
    Color(0xFFAD1457),
    Color(0xFFC2185B),
    Color(0xFFD81B60),
    Color(0xFFE91E63),
    Color(0xFF00695C),
    Color(0xFF00796B),
    Color(0xFF00897B),
    Color(0xFF009688),
    Color(0xFF26A69A),
    Color(0xFF004D40),
    Color(0xFF1B5E20),
    Color(0xFF2E7D32),
    Color(0xFF388E3C),
    Color(0xFF43A047),
    Color(0xFFBF360C),
    Color(0xFFD84315),
    Color(0xFFE64A19),
    Color(0xFFF4511E),
    Color(0xFFFF5722),
    Color(0xFF3E2723),
    Color(0xFF4E342E),
    Color(0xFF5D4037),
    Color(0xFF6D4C41),
    Color(0xFF795548),
    Color(0xFF263238),
    Color(0xFF37474F),
    Color(0xFF455A64),
    Color(0xFF546E7A),
    Color(0xFF607D8B),
    Color(0xFF0D47A1),
    Color(0xFF1565C0),
    Color(0xFF1976D2),
    Color(0xFF1E88E5),
    Color(0xFF2196F3),
    Color(0xFF01579B),
    Color(0xFF0277BD),
    Color(0xFF0288D1),
    Color(0xFF039BE5),
    Color(0xFF03A9F4),
  ];

  String _getInitials(String? name) {
    if (name == null || name.trim().isEmpty) return 'UK';
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty) return 'UK';
    if (parts.length == 1) {
      final first = parts[0];
      return first.length >= 2
          ? first.substring(0, 2).toUpperCase()
          : first.toUpperCase();
    }
    return (parts[0][0] + parts[1][0]).toUpperCase();
  }

  // Convert an unsigned 32-bit int to signed 32-bit (Dart int -> emulate JS Int32)
  int _toSigned32(int value) {
    value &= 0xFFFFFFFF;
    if ((value & 0x80000000) != 0) {
      return -((~value + 1) & 0xFFFFFFFF);
    }
    return value;
  }

  // Emulate JavaScript's per-operation ToInt32 behavior exactly
  int _jsHashExact(String text) {
    int hash = 0;

    for (int i = 0; i < text.length; i++) {
      final int code = text.codeUnitAt(i);

      // Simulate JS ToInt32(hash) before the bit-shift
      int h32 = hash & 0xFFFFFFFF;
      int shifted = ((h32 << 5) & 0xFFFFFFFF);
      int part = (shifted - h32) & 0xFFFFFFFF;
      int combined = (part + code) & 0xFFFFFFFF;

      // store back as signed 32-bit value (so subsequent operations behave same as JS)
      hash = _toSigned32(combined);
    }

    return hash;
  }

  Color _getColorFromName(String? name) {
    if (name == null || name.trim().isEmpty) return _avatarColors[0];

    final cleanName = name.trim();
    final int hash = _jsHashExact(cleanName);
    final int idx = hash.abs() % _avatarColors.length;
    return _avatarColors[idx];
  }

  @override
  Widget build(BuildContext context) {
    final String initials = _getInitials(username);
    final Color bgColor = _getColorFromName(username);
    final double diameter = radius * 2;

    Widget avatarContent;

    if (imageUrl != null && imageUrl!.trim().isNotEmpty) {
      avatarContent = Image.network(
        imageUrl!.trim(),
        fit: BoxFit.cover,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return _buildPlaceholder(initials, bgColor);
        },
        errorBuilder: (context, error, stackTrace) =>
            _buildInitialsAvatar(initials, bgColor),
      );
    } else {
      avatarContent = _buildInitialsAvatar(initials, bgColor);
    }

    return Container(
      width: diameter,
      height: diameter,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: showBorder
            ? Border.all(color: borderColor ?? Colors.white, width: borderWidth)
            : null,
      ),
      child: ClipOval(child: avatarContent),
    );
  }

  // Note: Using `Image.network` directly now — `_buildImageAvatar` removed.

  Widget _buildInitialsAvatar(String initials, Color bgColor) {
    return Container(
      color: bgColor,
      alignment: Alignment.center,
      child: Text(
        initials,
        style: TextStyle(
          color: Colors.white,
          fontSize:
              radius *
              0.75, // Matches React's ~text-lg + size*0.3 feel perfectly
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
          height: 1.0,
        ),
      ),
    );
  }

  Widget _buildPlaceholder(String initials, Color bgColor) {
    return Container(
      color: bgColor,
      alignment: Alignment.center,
      child: Stack(
        fit: StackFit.expand,
        children: [
          _buildInitialsAvatar(initials, bgColor),
          Center(
            child: CircularProgressIndicator(
              strokeWidth: 2.8,
              valueColor: AlwaysStoppedAnimation<Color>(
                Colors.white.withValues(alpha: .8),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
