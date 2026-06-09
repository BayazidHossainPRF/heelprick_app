import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../controllers/infant_controller.dart';
import '../../../../core/localDB/models/heel_prick_blood_infent_model.dart';
import '../../../../core/theme/app_pallete.dart';
import '../widgets/infant_card_widget.dart';

class InfantDoneListScreen extends StatefulWidget {
  const InfantDoneListScreen({super.key});

  @override
  State<InfantDoneListScreen> createState() => _InfantDoneListScreenState();
}

class _InfantDoneListScreenState extends State<InfantDoneListScreen> {
  final String? isReguseList = Get.arguments; // 'done' or 'refuse'
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _selectedFilter = 'All'; // All, Male, Female

  final List<String> _filterOptions = ['All', 'Male', 'Female', 'Enrollment', 'GF', 'Six_Month'];

  @override
  void initState() {
    super.initState();
    if (isReguseList == 'refuse') {
      InfantController.to.fetchRefusedInfants();
    } else {
      InfantController.to.fetchDoneInfants();
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  Text(
          isReguseList == 'refuse' ? 'Refused Child List' : 'Done Child List',
        ),
        actions: [
          Obx(
            () => Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Total : ',
                      style: TextStyle(fontSize: 14, color: Colors.white),
                    ),
                    Text(
                      '${_getFilteredList().length}    ',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(110),
          child: Column(
            children: [
              // Search Bar
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search by Infant ID, PID Baby, Sample ID...',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              _searchController.clear();
                              setState(() {
                                _searchQuery = '';
                              });
                            },
                          )
                        : null,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.grey.shade100,
                    contentPadding: const EdgeInsets.symmetric(vertical: 0),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value.toLowerCase();
                    });
                  },
                ),
              ),
              // Filter Chips
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Row(
                  children: [
                    const Text(
                      'Filter: ',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.white
                      ),
                    ),
                    const SizedBox(width: 8),
                    ..._filterOptions.map((filter) {
                      final isSelected = _selectedFilter == filter;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: FilterChip(
                          label: Text(filter),
                          selected: isSelected,
                          onSelected: (selected) {
                            setState(() {
                              _selectedFilter = filter;
                            });
                          },
                          backgroundColor: Colors.grey.shade200,
                          selectedColor: AppPallete.primary,
                          labelStyle: TextStyle(
                            color: isSelected ? Colors.white : Colors.black87,
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8),
        child: Obx(
          () => InfantController.to.isLoading
              ? const Center(child: CircularProgressIndicator())
              : InfantController.to.screenings.isEmpty
              ? const Center(
                  child: Text(
                    'No Child data found.',
                    style: TextStyle(fontSize: 18),
                  ),
                )
              : _getFilteredList().isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.search_off,
                        size: 64,
                        color: Colors.grey.shade400,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No results found for "$_searchQuery"',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  shrinkWrap: true,
                  itemCount: _getFilteredList().length,
                  itemBuilder: (context, index) {
                    final infant = _getFilteredList()[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: InfantCardWidget(
                        model: infant,
                        // isShort: true,
                        // onTap: () {
                        //   _navigateToDetail(infant);
                        // },
                        // onEdit: () {
                        //   _navigateToEdit(infant);
                        // },
                      ),
                    );
                  },
                ),
        ),
      ),
    );
  }

  List<HeelPrickBloodInfantModel> _getFilteredList() {
    var filteredList = InfantController.to.screenings;

    // Apply search filter
    if (_searchQuery.isNotEmpty) {
      filteredList = filteredList.where((infant) {
        return infant.infantId?.toLowerCase().contains(_searchQuery) == true ||
            infant.pidBaby?.toLowerCase().contains(_searchQuery) == true ||
            infant.sampleId?.toLowerCase().contains(_searchQuery) == true ||
            infant.cluster?.toLowerCase().contains(_searchQuery) == true ||
            infant.siteWomanId?.toLowerCase().contains(_searchQuery) == true;
      }).toList();
    }

    // Apply gender filter
    if (_selectedFilter != 'All') {
      filteredList = filteredList.where((infant) {
        return (infant.cSex?.toLowerCase() == _selectedFilter.toLowerCase()
        || infant.visitType?.toLowerCase() == _selectedFilter.toLowerCase());
      }).toList();
    }

    return filteredList;
  }

  // void _navigateToDetail(HeelPrickBloodInfantModel infant) {
  //   // Navigate to detail screen
  //   // Get.to(() => InfantDetailScreen(model: infant));
  //   print('Navigate to detail: ${infant.infantId}');
  // }

  // void _navigateToEdit(HeelPrickBloodInfantModel infant) {
  //   // Navigate to edit screen
  //   // Get.to(() => InfantEditScreen(model: infant));
  //   print('Navigate to edit: ${infant.infantId}');
  // }
}
