import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sewa_mitra/feature/home/model/category.dart';
import 'package:sewa_mitra/feature/home/model/provider_model.dart';
import 'package:sewa_mitra/feature/home/services/home_services.dart';
// State class to hold the home page data
class HomeState {
  final List<Category> categories;
  final List<ProviderModel> providers;
  final String selectedCategory;
  final bool isLoadingCategories;
  final bool isLoadingProviders;
  final String? categoryError;
  final String? providerError;

  HomeState({
    this.categories = const [],
    this.providers = const [],
    this.selectedCategory = 'All',
    this.isLoadingCategories = false,
    this.isLoadingProviders = false,
    this.categoryError,
    this.providerError,
  });

  HomeState copyWith({
    List<Category>? categories,
    List<ProviderModel>? providers,
    String? selectedCategory,
    bool? isLoadingCategories,
    bool? isLoadingProviders,
    String? categoryError,
    String? providerError,
  }) {
    return HomeState(
      categories: categories ?? this.categories,
      providers: providers ?? this.providers,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      isLoadingCategories: isLoadingCategories ?? this.isLoadingCategories,
      isLoadingProviders: isLoadingProviders ?? this.isLoadingProviders,
      categoryError: categoryError ?? this.categoryError,
      providerError: providerError ?? this.providerError,
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
    state = state.copyWith(isLoadingCategories: true, categoryError: null);
    try {
      final category = await _homeServices.getAllCategories();
      state = state.copyWith(
        categories: [Category(id: 'all', name: 'All', createdAt: DateTime.now(), updatedAt: DateTime.now(), v: 0), ...[category]],
        isLoadingCategories: false,
      );
      // Fetch providers for the default category
      await fetchProviders(state.selectedCategory);
    } catch (e) {
      state = state.copyWith(isLoadingCategories: false, categoryError: 'Failed to load categories');
    }
  }

  // Fetch providers by category
  Future<void> fetchProviders(String category) async {
    if (category == 'All') {
      state = state.copyWith(providers: [], isLoadingProviders: false, providerError: 'No agents available');
      return;
    }
    state = state.copyWith(isLoadingProviders: true, providerError: null);
    try {
      final provider = await _homeServices.getAgentsByCategories(category: category);
      state = state.copyWith(
        providers: provider != null ? [provider] : [],
        isLoadingProviders: false,
        providerError: provider == null ? 'No agents available' : null,
      );
    } catch (e) {
      state = state.copyWith(
        providers: [],
        isLoadingProviders: false,
        providerError: 'No agents available',
      );
    }
  }

  // Update selected category
  void setSelectedCategory(String category) {
    state = state.copyWith(selectedCategory: category);
    fetchProviders(category);
  }
}

// Provider for HomeController
final homeControllerProvider = StateNotifierProvider<HomeController, HomeState>((ref) {
  final homeServices = ref.watch(authServiceProvider);
  return HomeController(homeServices);
});