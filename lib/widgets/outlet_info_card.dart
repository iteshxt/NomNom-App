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

  @override
  Widget build(BuildContext context) {
    final statusColor =
        outlet.isOpen ? AppTheme.successColor : AppTheme.errorColor;

    return GestureDetector(
      onTap: onTap,
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with name and cuisine
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          outlet.name,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          outlet.cuisineType,
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: Colors.grey[600],
                                  ),
                        ),
                      ],
                    ),
                  ),
                  // Rating badge
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppTheme.secondaryColor,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.star_rounded,
                          size: 16,
                          color: AppTheme.primaryColor,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${outlet.rating}',
                          style:
                              Theme.of(context).textTheme.labelSmall?.copyWith(
                                    color: AppTheme.primaryColor,
                                    fontWeight: FontWeight.w600,
                                  ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Status and location
              Row(
                children: [
                  // Hours and status
                  Expanded(
                    flex: 3,
                    child: Row(
                      children: [
                        Icon(
                          Icons.access_time_rounded,
                          size: 16,
                          color: statusColor,
                        ),
                        const SizedBox(width: 6),
                        Flexible(
                          child: Text(
                            _getCurrentStatus(),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style:
                                Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: statusColor,
                                      fontWeight: FontWeight.w500,
                                    ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Location
                  Expanded(
                    flex: 2,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Icon(
                          Icons.location_on_rounded,
                          size: 16,
                          color: Colors.grey[600],
                        ),
                        const SizedBox(width: 4),
                        Flexible(
                          child: Text(
                            outlet.campusLocation,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style:
                                Theme.of(context).textTheme.bodySmall?.copyWith(
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
      ),
    );
  }
}
