import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:heel_prick_blood_collection/core/localDB/models/pending_infant_model.dart';
import 'package:heel_prick_blood_collection/core/utils/snackbar.dart';
import '../../../../controllers/pending_infant_controller.dart';
import '../../../../core/routes/app_routes.dart';
import '../widgets/pending_infant_card_widget.dart';

class TodoEnrollment extends StatefulWidget {
  const TodoEnrollment({super.key});

  @override
  State<TodoEnrollment> createState() => _TodoEnrollmentState();
}

class _TodoEnrollmentState extends State<TodoEnrollment> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  initState() {
    super.initState();
    PendingInfantController.to.fetchTodoEnrollmentList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo Enrollment List'),
        actions: [
          SizedBox(
            child: Obx(
              () => PendingInfantController.to.isLoading
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
        if (PendingInfantController.to.isLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (PendingInfantController.to.infants.isEmpty) {
          return const Center(child: Text('No infants found.'));
        } else {
          return ListView.builder(
            itemCount: _getFilteredList().length,
            itemBuilder: (context, index) {
              final infant = _getFilteredList()[index];
              return PendingInfantCard(
                pendingInfant: infant,
                onPressed: () {
                   if((DateTime.tryParse(infant.dob.toString()) ?? DateTime.parse('1909-09-09')).add(Duration(days: 13)).difference(DateTime.now()).inDays<6){
                     Get.toNamed(
                       AppRoutes.ENROLLMENTFORM,
                       arguments: infant,
                     )!.then((value) async {
                       await Future.delayed(const Duration(seconds: 1));
                       PendingInfantController.to.fetchTodoEnrollmentList();
                     });
                   }else{
                     Snackbar.show_e(message: 'Not in window period. Please follow the valid window period.');
                   }

                },
              );
            },
          );
        }
      }),
    );
  }

  List<PendingInfantModel> _getFilteredList() {
    if (_searchQuery.isEmpty) {
      return PendingInfantController.to.infants;
    }

    return PendingInfantController.to.infants.where((infant) {
      return infant.siteWomanId?.toLowerCase().contains(_searchQuery) == true ||
          infant.womanName?.toLowerCase().contains(_searchQuery) == true;
    }).toList();
  }
}
