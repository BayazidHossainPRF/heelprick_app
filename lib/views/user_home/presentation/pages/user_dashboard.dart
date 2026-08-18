import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:heel_prick_blood_collection/controllers/growth_and_outcome_controller.dart';
import 'package:heel_prick_blood_collection/controllers/server_query_controller%20copy.dart';
import 'package:heel_prick_blood_collection/core/const/visit_type_enum.dart';
import 'package:intl/intl.dart';
import '../../../../controllers/home_controller.dart';
import '../../../../core/prefs/user_prefs.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/utils/loader.dart';
import '../utils/dashboard_items.dart';
import '../widgets/real_time_clock.dart';
import '../widgets/summary_widget.dart';

class UserDashboard extends StatefulWidget {
  const UserDashboard({super.key});

  @override
  State<UserDashboard> createState() => _UserDashboardState();
}

class _UserDashboardState extends State<UserDashboard> {
  final List<DashboardItems> allOverviewList = [];
  final List<DashboardItems> childAndOldOverviewList = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
        actions: [
          Text(
            'User Id : ${UserPrefs.userModel.userId}    ',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          IconButton(
            onPressed: () {
              Get.offAllNamed(AppRoutes.SIGNINSCREEN);
            },
            icon: Icon(Icons.logout),
          ),
        ],
      ),
      // drawer:
      drawer: Drawer(
        child: SingleChildScrollView(
          child: Column(
            spacing: 16,
            children: [
              Container(
                padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.05,
                  left: 32,
                  right: 32,
                  bottom: 32,
                ),
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.25,
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Image.asset('assets/app_logo.png'),
                ),
              ),
              const SizedBox(height: 8),
              Obx(() => Text('Version: ${HomeController.to.appVersion}')),
              const SizedBox(height: 16),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  spacing: 16,
                  children: [
                    Obx(
                      () => HomeController.to.isExporting
                          ? Center(child: CircularProgressIndicator())
                          : ElevatedButton(
                              onPressed: () async {
                                HomeController.to.exportDbFile();
                              },
                              child: Row(
                                children: [
                                  Icon(Icons.import_export),
                                  Text('Export DB'),
                                ],
                              ),
                            ),
                    ),
                    Obx(
                      () => HomeController.to.isMerging
                          ? Center(child: CircularProgressIndicator())
                          : GestureDetector(
                              onLongPress: () async {
                                HomeController.to.mergeDbFile();
                              },
                              child: Row(
                                children: [
                                  Icon(Icons.import_export),
                                  Text('Merge DB'),
                                ],
                              ),
                            ),
                    ),
                    Obx(
                      () => HomeController.to.isChildDownloading
                          ? Center(child: CircularProgressIndicator())
                          : ElevatedButton(
                              onPressed: () async {
                                showLoader(context: context);
                                await HomeController.to
                                    .uploadFollowupToServer();
                                // await HomeController.to
                                //     .uploadAddmissionDetailsToServer();
                                await HomeController.to.downloadScreeningList();

                                Navigator.pop(context);
                              },
                              child: Row(
                                children: [
                                  Icon(Icons.download_outlined),
                                  Text('Sync Data'),
                                ],
                              ),
                            ),
                    ),

                    Obx(
                      () => HomeController.to.isDataUploading
                          ? Center(child: CircularProgressIndicator())
                          : ElevatedButton(
                              onPressed: () async {
                                await HomeController.to
                                    .uploadFollowupToServer();
                                await GrowthAndOutcomeController.to
                                    .backupEnrollmentData();
                                await GrowthAndOutcomeController.to
                                    .backupGrowthData();
                                await GrowthAndOutcomeController.to
                                    .backupSESData();
                                // HomeController.to.exportDbFile();
                              },
                              child: Row(
                                children: [
                                  Icon(Icons.upload_outlined),
                                  Text('Data Backup'),
                                ],
                              ),
                            ),
                    ),
                    Obx(
                      () => ServerQueryController.to.isLoading.value
                          ? Center(child: CircularProgressIndicator())
                          : ElevatedButton(
                              onPressed: () async {
                                ServerQueryController.to.getServerQuery();
                              },
                              child: Row(
                                children: [
                                  Icon(Icons.upload_outlined),
                                  Text('Server Query'),
                                ],
                              ),
                            ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),

      body: RefreshIndicator(
        onRefresh: () async => HomeController.to.refreshData(),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome Section
              _buildWelcomeSection(),
              const SizedBox(height: 12),
              _BuildSummarySection(),
              const SizedBox(height: 24),

              Obx(
                () =>
                    HomeController.to.lastDownloadDate ==
                        DateFormat('yyyy-MM-dd').format(DateTime.now())
                    ? const SizedBox()
                    : Center(
                        child: ElevatedButton(
                          onPressed: () async {
                            showLoader(context: context);
                            await HomeController.to.uploadFollowupToServer();

                            await HomeController.to.downloadScreeningList();
                            Navigator.pop(context);
                          },
                          child: Text('Download New Screening Data'),
                        ),
                      ),
              ),
              const SizedBox(height: 16),
              // Statistics Grid
              _buildStatisticsGrid(),
              const SizedBox(height: 24),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWelcomeSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Image.asset('assets/app_logo.png'),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Obx(
                    () => HomeController.to.isLoading.value
                        ? Center(child: CircularProgressIndicator())
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Welcome, ${HomeController.to.currentUser.name ?? 'User'}',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF1A237E),
                                ),
                              ),

                              const SizedBox(height: 4),
                              Text(
                                '${HomeController.to.totalChild} childs across ${HomeController.to.todoChild} children visits for today',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
              ],
            ),
          ),
          RealTimeClock(),
        ],
      ),
    );
  }

  Widget _buildStatisticsGrid() {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: 1.8,
      children: [
        if (UserPrefs.userModel.userLevel == '2') ...[
          Obx(
            () => HomeController.to.todoChild == -1
                ? Center(child: CircularProgressIndicator())
                : _buildStatCard(
                    title:
                        '${HomeController.to.todoChild.toString()} Out of ${HomeController.to.totalChild.toString()}',
                    value: 'Enrollment Visit',
                    icon: Icons.check_circle,
                    color: Colors.lightBlue,
                    onTap: () {
                      Get.toNamed(
                        AppRoutes.INFANTLISTSCREEN,
                        arguments: VisitTypeEnum.Enrollment.name,
                      );
                    },
                  ),
          ),
          _buildStatCard(
            title:
                '${HomeController.to.todoChild.toString()} Out of ${HomeController.to.totalChild.toString()}',
            value: 'Growth Falter Visit',
            icon: Icons.check_circle,
            color: Colors.lightBlueAccent,
            onTap: () {
              Get.toNamed(
                AppRoutes.INFANTLISTSCREEN,
                arguments: VisitTypeEnum.GF.name,
              );
            },
          ),
          _buildStatCard(
            title:
                '${HomeController.to.todoChild.toString()} Out of ${HomeController.to.totalChild.toString()}',
            value: '6th Month Visit',
            icon: Icons.check_circle,
            color: Colors.blueAccent,
            onTap: () {
              Get.toNamed(
                AppRoutes.INFANTLISTSCREEN,
                arguments: VisitTypeEnum.Six_Month.name,
              );
            },
          ),
          _buildStatCard(
            title: 'Visit Done List',
            value: 'Visit Done List',
            icon: Icons.done_all,
            color: Colors.green,
            onTap: () {
              Get.toNamed(AppRoutes.INFANTDONELISTSCREEN);
            },
          ),

          _buildStatCard(
            title: 'Refuse List',
            value: 'Refuse List',
            icon: Icons.remove_circle,
            color: Colors.red,
            onTap: () {
              Get.toNamed(AppRoutes.INFANTDONELISTSCREEN, arguments: 'refuse');
            },
          ),
        ],
        if (UserPrefs.userModel.userLevel == '1') ...[
          _buildStatCard(
            title: 'Pending Infant List',
            value: 'Pending Infant List',
            icon: Icons.remove_circle,
            color: Colors.red,
            onTap: () {
              Get.toNamed(AppRoutes.PENDINGINFANTLIST, arguments: 'pending');
            },
          ),

          _buildStatCard(
            title: 'Todo Enrollment',
            value: 'Todo Enrollment',
            icon: Icons.remove_circle,
            color: Colors.red,
            onTap: () {
              Get.toNamed(AppRoutes.TODOENROLLMENT);
            },
          ),
          _buildStatCard(
            title: 'Todo Growth And Outcome',
            value: 'Todo Growth And Outcome',
            icon: Icons.remove_circle,
            color: Colors.red,
            onTap: () {
              Get.toNamed(AppRoutes.TODOGROWTHMONITORING);
            },
          ),
        ],
      ],
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
    String subtitle = '',
    Function()? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade200,
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(icon, color: color, size: 24),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                value,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
              Text(
                title,
                style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
              ),
              if (subtitle.isNotEmpty)
                Text(
                  subtitle,
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                ),
            ],
          ),
        ),
      ),
    );
  }

  // ignore: non_constant_identifier_names
  Widget _BuildSummarySection() {
    return Obx(
      () => HomeController.to.isLoading.value
          ? Center(child: CircularProgressIndicator())
          : Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade200,
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                spacing: 32,
                children: [
                  SummaryWidget(
                    label: 'Enrollment',
                    count:
                        '${HomeController.to.syncEn}/${HomeController.to.totalEn}',
                    color: Colors.blue,
                  ),
                  SummaryWidget(
                    label: 'Asset',
                    count:
                        '${HomeController.to.syncAs}/${HomeController.to.totalAs}',
                    color: Colors.orangeAccent,
                  ),
                  SummaryWidget(
                    label: 'P. Handover',
                    count:
                        '${HomeController.to.syncGf}/${HomeController.to.totalGf}',
                    color: Colors.pink,
                  ),
                ],
              ),
            ),
    );
  }
}
