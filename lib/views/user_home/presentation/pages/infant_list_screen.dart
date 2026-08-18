import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:heel_prick_blood_collection/core/routes/app_routes.dart';

import '../../../../controllers/infant_controller.dart';
import '../../../../core/localDB/models/heel_prick_blood_infent_model.dart';
import '../widgets/infant_card_widget.dart';

class InfantListScreen extends StatefulWidget {
  const InfantListScreen({super.key});

  @override
  State<InfantListScreen> createState() => _InfantListScreenState();
}

class _InfantListScreenState extends State<InfantListScreen> {
  final String listType = Get.arguments;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    InfantController.to.fetchTodoInfants(listType);
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
        title: Text('${listType} Child Pending List'),
        actions: [
          Obx(
            () => Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Center(
                child: Text(
                  'Total: ${_getFilteredList().length}',
                  style: const TextStyle(fontSize: 14, color: Colors.white),
                ),
              ),
            ),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                  itemBuilder: (context, index) => InfantCardWidget(
                    model: _getFilteredList()[index],
                    // isShort: true,
                    onTap: () {
                      // Navigate to detail view
                      _navigateToDetail(_getFilteredList()[index]);
                    },
                  ),
                ),
        ),
      ),
    );
  }

  List<HeelPrickBloodInfantModel> _getFilteredList() {
    if (_searchQuery.isEmpty) {
      return InfantController.to.screenings;
    }

    return InfantController.to.screenings.where((infant) {
      return infant.infantId?.toLowerCase().contains(_searchQuery) == true ||
          infant.pidBaby?.toLowerCase().contains(_searchQuery) == true ||
          infant.sampleId?.toLowerCase().contains(_searchQuery) == true ||
          infant.cluster?.toLowerCase().contains(_searchQuery) == true ||
          infant.siteWomanId?.toLowerCase().contains(_searchQuery) == true ||
          infant.cSex?.toLowerCase().contains(_searchQuery) == true;
    }).toList();
  }

  void _navigateToDetail(HeelPrickBloodInfantModel infant) {
    // Navigate to detail screen
    Get.toNamed(
      AppRoutes.HEELPRICKBLOODCOLLECTIONFORMSCREEN,
      arguments: infant,
    );
  //  print('Navigate to detail: ${infant.infantId}');
  }
}
