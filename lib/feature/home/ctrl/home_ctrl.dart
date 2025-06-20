import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sewa_mitra/feature/home/model/category.dart';
import 'package:sewa_mitra/feature/home/model/provider_model.dart';
import 'package:sewa_mitra/feature/home/services/home_services.dart';

// State class to hold the home page data
class HomeState {
  final List<Category> categories;
  final List<ProviderModel> providers;
  final String selectedCategory;
  final String searchQuery;
  final bool isLoading;
  final String? error;

  HomeState({
    this.categories = const [],
    this.providers = const [],
    this.selectedCategory = 'All',
    this.searchQuery = '',
    this.isLoading = false,
    this.error,
  });

  HomeState copyWith({
    List<Category>? categories,
    List<ProviderModel>? providers,
    String? selectedCategory,
    String? searchQuery,
    bool? isLoading,
    String? error,
  }) {
    return HomeState(
      categories: categories ?? this.categories,
      providers: providers ?? this.providers,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      searchQuery: searchQuery ?? this.searchQuery,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

// Controller for managing home page state
class HomeController extends StateNotifier<HomeState> {
  final HomeServices _homeServices;

  HomeController(this._homeServices) : super(HomeState()) {
    fetchCategories();
  }

  // Fetch all categories
  Future<void> fetchCategories() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final category = await _homeServices.getAllCategories();
      state = state.copyWith(
        categories: [Category(id: 'all', name: 'All', createdAt: DateTime.now(), updatedAt: DateTime.now()), ...[category]],
        isLoading: false,
      );
      // Fetch providers for the default category
      await fetchProviders(state.selectedCategory);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  // Fetch providers by category
  Future<void> fetchProviders(String category) async {
    if (category == 'All') {
      state = state.copyWith(providers: [], isLoading: false);
      return;
    }
    state = state.copyWith(isLoading: true, error: null);
    try {
      final provider = await _homeServices.getAgentsByCategories(category: category);
      state = state.copyWith(providers: [provider], isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  // Update selected category
  void setSelectedCategory(String category) {
    state = state.copyWith(selectedCategory: category);
    fetchProviders(category);
  }

  // Update search query
  void setSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
  }
}

// Provider for HomeController
final homeControllerProvider = StateNotifierProvider<HomeController, HomeState>((ref) {
  final homeServices = ref.watch(authServiceProvider);
  return HomeController(homeServices);
});