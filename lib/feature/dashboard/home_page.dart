// Home Page
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sewamitraapp/config/services/remote_services/api_endpoints.dart';
import 'package:sewamitraapp/feature/home/model/category.dart';
import 'package:sewamitraapp/feature/home/model/provider_model.dart';

import '../../core/const/app_strings.dart';
import '../home/model/service.dart';
import '../home/view/service_card.dart';
import '../home/view/service_details_sheet.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _searchController = TextEditingController();
  //String 
 Category? 
 _selectedCategory 
 ;
 //= 'All';
  //fetch category list 
@override
void initState() {
  super.initState();
  _futureCategories = fetchCategories();
               //       _futureServices = fetchProvidersByCategory('all');

}
 
late Future<List<Category>> _futureCategories;
Future<List<Category>> fetchCategories() async {
  final url = Uri.parse('${ApiEndPoints.baseUrl}${ApiEndPoints.getAllCategory}');
  final response = await http.get(url);

  if (response.statusCode == 200) {
    List data = json.decode(response.body);
    return data.map((json) => Category.fromJson(json)).toList();
  } else {
    throw Exception('Failed to load categories');
  }
}
//List<ProviderModel> _filteredService = [];
Future<List<ProviderModel>>? _futureServices;

Future<List<ProviderModel>> fetchProvidersByCategory(String category) async {
  print(category);
  final url = Uri.parse('${ApiEndPoints.baseUrl}provider/getWorkers?category=$category');

  final response = await http.get(url);
print(response.body);
  if (response.statusCode == 200) {
    final List<dynamic> data = json.decode(response.body);
    return data.map((item) => ProviderModel.fromJson(item)).toList();
  } else {
    throw Exception('Failed to load providers');
  }
}


  List<Service> get _filteredServices {
    List<Service> filtered = services;

    if (_selectedCategory != 'All') {
      filtered = filtered.where((service) => service.category == _selectedCategory).toList();
    }

    if (_searchController.text.isNotEmpty) {
      filtered = filtered.where((service) =>
      service.name.toLowerCase().contains(_searchController.text.toLowerCase()) ||
          service.description.toLowerCase().contains(_searchController.text.toLowerCase())).toList();
    }

    return filtered;
  }
List<Category> _categories = [];
//Category? _selectedCategory;
  @override
  Widget build(BuildContext context) {
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
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 8), // Reduced horizontal padding
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
                                  fontSize: 14, // Slightly smaller font
                                ),
                              ),
                              Text(
                                'Find Your Service',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20, // Slightly smaller font
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          IconButton(
                            onPressed: () {
                              // Handle notifications
                            },
                            icon: const Icon(
                              Icons.notifications_outlined,
                              color: Colors.white,
                              size: 24, // Slightly smaller icon
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12), // Reduced spacing
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
                          controller: _searchController,
                          onChanged: (value) => setState(() {}),
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

   FutureBuilder<List<Category>>(
  future: _futureCategories,
  builder: (context, snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const SliverToBoxAdapter(
        child: Center(child: CircularProgressIndicator()),
      );
    } else if (snapshot.hasError) {
      return SliverToBoxAdapter(
        child: Center(child: Text('Error: ${snapshot.error}')),
      );
    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
      return const SliverToBoxAdapter(
        child: Center(child: Text('No categories available')),
      );
    } else {
      _categories = snapshot.data!;
      return SliverToBoxAdapter(
        child: Container(
          height: 40,
          margin: const EdgeInsets.symmetric(vertical: 12),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: _categories.length,
            itemBuilder: (context, index) {
              final category = _categories[index];
final isSelected = _selectedCategory?.id == category.id;

              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedCategory = category;
                    _futureServices = fetchProvidersByCategory(category.name);
                  });
                  print(isSelected);
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
      );
    }
  },
)

,
          // SliverToBoxAdapter(
          //   child: Container(
          //     height: 40, // Reduced height
          //     margin: const EdgeInsets.symmetric(vertical: 12),
          //     child: ListView.builder(
          //       scrollDirection: Axis.horizontal,
          //       padding: const EdgeInsets.symmetric(horizontal: 16), // Reduced padding
          //       itemCount: categories.length,
          //       itemBuilder: (context, index) {
          //         final category = categories[index];
          //         final isSelected = _selectedCategory == category;

          //         return GestureDetector(
          //           onTap: () {
          //             setState(() {
          //               _selectedCategory = category;
          //             });
          //           },
          //           child: Container(
          //             margin: const EdgeInsets.only(right: 8), // Reduced margin
          //             padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8), // Reduced padding
          //             decoration: BoxDecoration(
          //               color: isSelected ? Colors.blue[600] : Colors.white,
          //               borderRadius: BorderRadius.circular(20),
          //               border: Border.all(
          //                 color: isSelected ? Colors.blue[600]! : Colors.grey[300]!,
          //               ),
          //             ),
          //             child: Text(
          //               category,
          //               style: TextStyle(
          //                 color: isSelected ? Colors.white : Colors.grey[700],
          //                 fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          //                 fontSize: 14, // Smaller font
          //               ),
          //             ),
          //           ),
          //         );
          //       },
          //     ),
          //   ),
          // ),

//_filteredServices.isEmpty?Center(child: Text('Please select category'),):

 SliverToBoxAdapter(
      child: FutureBuilder<List<ProviderModel>>(
        future: _futureServices,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text("No providers found or please select a category"));
          }

          final services = snapshot.data!;

          return ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: services.length,
            itemBuilder: (context, index) {
              final service = services[index];
              return ServiceCard(
                service: service,
                onTap: () =>{
                  _showServiceDetails(service),   
                }
                
              
              );
            },
          );
        },
      ),
    )  ,

          // Services List
  //         _filteredServices.isEmpty
  //             ? SliverFillRemaining(
  //           child: Center(
  //             child: Column(
  //               mainAxisAlignment: MainAxisAlignment.center,
  //               children: [
  //                 Icon(
  //                   Icons.search_off,
  //                   size: 48, // Smaller icon
  //                   color: Colors.grey[400],
  //                 ),
  //                 const SizedBox(height: 12),
  //                 Text(
  //                   'No services found',
  //                   style: TextStyle(
  //                     fontSize: 16,
  //                     color: Colors.grey[600],
  //                     fontWeight: FontWeight.w500,
  //                   ),
  //                 ),
  //                 const SizedBox(height: 6),
  //                 Text(
  //                   'Try adjusting your search or category',
  //                   style: TextStyle(
  //                     fontSize: 12,
  //                     color: Colors.grey[500],
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           ),
  //         )
  //             : 
              
  //           _futureServices == null
  // ? SliverFillRemaining(
  //     child: Center(child: Text("Please select a category")),
  //   )
  // : SliverToBoxAdapter(
  //     child: FutureBuilder<List<ProviderModel>>(
  //       future: _futureServices,
  //       builder: (context, snapshot) {
  //         if (snapshot.connectionState == ConnectionState.waiting) {
  //           return const Center(child: CircularProgressIndicator());
  //         } else if (snapshot.hasError) {
  //           return Center(child: Text("Error: ${snapshot.error}"));
  //         } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
  //           return Center(child: Text("No providers found"));
  //         }

  //         final services = snapshot.data!;

  //         return ListView.builder(
  //           shrinkWrap: true,
  //           physics: NeverScrollableScrollPhysics(),
  //           itemCount: services.length,
  //           itemBuilder: (context, index) {
  //             final service = services[index];
  //             return ServiceCard(
  //               service: service,
  //               onTap: () =>{}
                
  //               // _showServiceDetails(service),
  //             );
  //           },
  //         );
  //       },
  //     ),
  //   )  
              
           //  ,Text(await _futureServices.toString()), 
              
          //     SliverPadding(
          //   padding: const EdgeInsets.symmetric(horizontal: 16), // Reduced padding
          //   sliver: SliverList(
          //     delegate: SliverChildBuilderDelegate(
          //           (context, index) {
          //         final service = _filteredServices[index];
          //         return ServiceCard(
          //           service: service,
          //           onTap: () => _showServiceDetails(service),
          //         );
          //       },
          //       childCount: _filteredServices.length,
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }

  void _showServiceDetails(ProviderModel service) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ServiceDetailsSheet(service: service),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}


