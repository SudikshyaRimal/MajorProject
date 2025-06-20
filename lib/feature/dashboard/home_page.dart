import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sewa_mitra/feature/dashboard/profile_page.dart';
import 'package:sewa_mitra/feature/home/model/provider_model.dart';
import 'package:sewa_mitra/feature/home/view/service_card.dart';
import 'package:sewa_mitra/feature/home/view/service_details_sheet.dart';

import '../home/ctrl/home_ctrl.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homeState = ref.watch(homeControllerProvider);
    final homeController = ref.read(homeControllerProvider.notifier);
    final TextEditingController searchController = TextEditingController();

    // Filtered providers based on search query
    List<ProviderModel> filteredProviders = homeState.providers.where((provider) {
      final query = homeState.searchQuery.toLowerCase();
      return provider.firstname.toLowerCase().contains(query) ||
          provider.lastname.toLowerCase().contains(query) ||
          provider.serviceType.toLowerCase().contains(query);
    }).toList();

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: CustomScrollView(
        slivers: [
          // Modified header with status bar integration
          SliverAppBar(
            automaticallyImplyLeading: false,
            backgroundColor: Colors.blue[600],
            expandedHeight: 180,
            flexibleSpace: FlexibleSpaceBar(
              background: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Good Morning!',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 14,
                                ),
                              ),
                              Text(
                                'Find Your Service',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              IconButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => const ProfilePage()),
                                  );
                                },
                                icon: const Icon(
                                  Icons.person_rounded,
                                  color: Colors.white,
                                  size: 24,
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  // Handle notifications
                                },
                                icon: const Icon(
                                  Icons.notifications_outlined,
                                  color: Colors.white,
                                  size: 24,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: TextField(
                          controller: searchController,
                          onChanged: (value) => homeController.setSearchQuery(value),
                          decoration: const InputDecoration(
                            hintText: 'Search for services...',
                            prefixIcon: Icon(Icons.search, color: Colors.grey),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Categories Section
          SliverToBoxAdapter(
            child: Container(
              height: 40,
              margin: const EdgeInsets.symmetric(vertical: 12),
              child: homeState.isLoading
                  ? Center(child: CircularProgressIndicator())
                  : ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: homeState.categories.length,
                itemBuilder: (context, index) {
                  final category = homeState.categories[index];
                  final isSelected = homeState.selectedCategory == category.name;

                  return GestureDetector(
                    onTap: () {
                      homeController.setSelectedCategory(category.name);
                    },
                    child: Container(
                      margin: const EdgeInsets.only(right: 8),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.blue[600] : Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isSelected ? Colors.blue[600]! : Colors.grey[300]!,
                        ),
                      ),
                      child: Text(
                        category.name,
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.grey[700],
                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),

          // Providers List
          homeState.isLoading
              ? SliverFillRemaining(child: Center(child: CircularProgressIndicator()))
              : homeState.error != null
              ? SliverFillRemaining(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 48,
                    color: Colors.red[400],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    homeState.error!,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 6),
                  ElevatedButton(
                    onPressed: () => homeController.fetchCategories(),
                    child: Text('Retry'),
                  ),
                ],
              ),
            ),
          )
              : filteredProviders.isEmpty
              ? SliverFillRemaining(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.search_off,
                    size: 48,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'No services found',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Try adjusting your search or category',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ),
            ),
          )
              : SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                    (context, index) {
                  final provider = filteredProviders[index];
                  return ServiceCard(
                    service: provider,
                    onTap: () => _showServiceDetails(context, provider),
                  );
                },
                childCount: filteredProviders.length,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showServiceDetails(BuildContext context, ProviderModel provider) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ServiceDetailsSheet(service: provider),
    );
  }
}