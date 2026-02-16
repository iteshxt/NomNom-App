class Outlet {
  final String id;
  final String name;
  final String imageUrl;
  final bool isActive;
  final List<String> categories;

  const Outlet({
    required this.id,
    required this.name,
    required this.imageUrl,
    this.isActive = true,
    required this.categories,
  });
}
