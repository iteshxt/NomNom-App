import 'package:flutter/material.dart';
import '../../models/index.dart';
import '../../config/theme.dart';

/// Displays outlet info card with rating, hours, location, cuisine
class OutletInfoCard extends StatelessWidget {
  final Outlet outlet;
  final VoidCallback onTap;

  const OutletInfoCard({
    required this.outlet,
    required this.onTap,
    super.key,
  });

  String _getCurrentStatus() {
    if (!outlet.isOpen) return 'Currently Closed';

    try {
      return 'Open • ${outlet.hoursOfOperation}';
    } catch (e) {
      return 'Open now';
    }
  }

  Color _getRatingColor(double rating) {
    if (rating >= 4.0) return Colors.green[700]!;
    if (rating >= 3.0) return Colors.amber[700]!;
    return Colors.red[700]!;
  }

  @override
  Widget build(BuildContext context) {
    final statusColor =
        outlet.isOpen ? AppTheme.successColor : AppTheme.errorColor;
    final ratingColor = _getRatingColor(outlet.rating);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header: Name & Rating
            Row(
              children: [
                // Logo Container
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: AppTheme.secondaryColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(16),
                    image: outlet.logo.isNotEmpty
                        ? DecorationImage(
                            image: NetworkImage(outlet.logo),
                            fit: BoxFit.cover,
                          )
                        : null,
                  ),
                  child: outlet.logo.isEmpty
                      ? const Icon(Icons.restaurant_rounded,
                          color: AppTheme.primaryColor, size: 24)
                      : null,
                ),
                const SizedBox(width: 16),
                // Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        outlet.name,
                        style: const TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFF1F2937),
                          letterSpacing: -0.5,
                          height: 1.1,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        outlet.cuisineType,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[500],
                        ),
                      ),
                    ],
                  ),
                ),
                // Premium Rating Badge
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: ratingColor.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: ratingColor.withValues(alpha: 0.15),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        outlet.rating.toStringAsFixed(1),
                        style: TextStyle(
                          color: ratingColor,
                          fontWeight: FontWeight.w900,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(width: 2),
                      Icon(
                        Icons.star_rounded,
                        size: 14,
                        color: ratingColor,
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Info Row: Status Pill & Location
            Row(
              children: [
                // Status Pill
                Flexible(
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: statusColor.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.circle,
                          size: 8,
                          color: statusColor,
                        ),
                        const SizedBox(width: 8),
                        Flexible(
                          child: Text(
                            _getCurrentStatus(),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: statusColor,
                              fontWeight: FontWeight.w800,
                              fontSize: 11,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                // Location Info
                Flexible(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Icon(
                        Icons.location_on_rounded,
                        size: 16,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(width: 4),
                      Flexible(
                        child: Text(
                          outlet.campusLocation,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[600],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
