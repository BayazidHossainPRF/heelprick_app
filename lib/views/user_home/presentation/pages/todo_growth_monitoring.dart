import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:heel_prick_blood_collection/controllers/growth_and_outcome_controller.dart';
import 'package:heel_prick_blood_collection/core/localDB/models/enrollment_form_model.dart';
import 'package:heel_prick_blood_collection/core/routes/app_routes.dart';
import 'package:heel_prick_blood_collection/views/user_home/presentation/widgets/enrollment_card_widget.dart';

class TodoGrowthMonitoring extends StatefulWidget {
  const TodoGrowthMonitoring({super.key});

  @override
  State<TodoGrowthMonitoring> createState() => _TodoGrowthMonitoringState();
}

class _TodoGrowthMonitoringState extends State<TodoGrowthMonitoring> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  initState() {
    super.initState();
    GrowthAndOutcomeController.to.fetchTodoGrowthAndOutcome();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo Growth and Outcome'),
        actions: [
          SizedBox(
            child: Obx(
              () => GrowthAndOutcomeController.to.isLoading
                  ? const Center(
                      child: CircularProgressIndicator(color: Colors.white),
                    )
                  : Text(
                      _getFilteredList().length.toString(),
                      style: const TextStyle(fontSize: 16, color: Colors.white),
                    ),
            ),
          ),
          const SizedBox(width: 16),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search by mother pid or name...',
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
      body: Obx(() {
        if (GrowthAndOutcomeController.to.isLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (GrowthAndOutcomeController.to.infants.isEmpty) {
          return const Center(child: Text('No infants found.'));
        } else {
          return ListView.builder(
            itemCount: _getFilteredList().length,
            itemBuilder: (context, index) {
              final infant = _getFilteredList()[index];
              return EnrollmentCardWidget(
                model: infant,
                onTab: () {
                  Get.toNamed(
                    AppRoutes.GROWTHMONITORINGFORM,
                    arguments: infant,
                  )!.then((value) {
                    GrowthAndOutcomeController.to.fetchTodoGrowthAndOutcome();
                  });
                },
              );
            },
          );
        }
      }),
    );
  }

  List<EnrollmentFormModel> _getFilteredList() {
    if (_searchQuery.isEmpty) {
      return GrowthAndOutcomeController.to.infants;
    }

    return GrowthAndOutcomeController.to.infants.where((infant) {
      return infant.q602?.toLowerCase().contains(_searchQuery) == true ||
          infant.q103?.toLowerCase().contains(_searchQuery) == true ||
          infant.infantId.toLowerCase().contains(_searchQuery) == true;
    }).toList();
  }
}
