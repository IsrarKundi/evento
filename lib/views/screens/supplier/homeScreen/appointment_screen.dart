import 'package:event_connect/controllers/suppierControllers/appointments_controller.dart';
import 'package:event_connect/l10n/app_localizations.dart';
import 'package:event_connect/main.dart';
import 'package:event_connect/models/bookingModel/booking_model.dart';
import 'package:event_connect/views/widget/common_image_view_widget.dart';
import 'package:flutter/material.dart';

import '../../../../main_packages.dart';
import '../../categoryScreens/category_detail_screen.dart';

class AppointmentsScreen extends StatefulWidget {
  const AppointmentsScreen({super.key});

  @override
  State<AppointmentsScreen> createState() => _AppointmentsScreenState();
}

class _AppointmentsScreenState extends State<AppointmentsScreen> {
  // Track the selected tab
  String _selectedTab = '';

  AppointmentsController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    // Initialize selected tab with localized text if not set
    if (_selectedTab.isEmpty) {
      _selectedTab = AppLocalizations.of(context)!.upcoming;
    }
    
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.bookings,
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF9AD08F)),
          onPressed: () {
            Get.back();
            // Handle back button press
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
        child: Column(
          children: [
            // Tab bar for Upcoming, Completed, Cancel
            Container(
              height: 50,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 2,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: Row(
                children: [
                  _buildTab(AppLocalizations.of(context)!.upcoming),
                  _buildTab(AppLocalizations.of(context)!.completed),
                  _buildTab(AppLocalizations.of(context)!.cancelled),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Local / Online toggle
            // Row(
            //   children: [
            //     _buildLocationOption('Local', true),
            //     const SizedBox(width: 12),
            //     _buildLocationOption('Online', false),
            //   ],
            // ),

            const SizedBox(height: 20),

            // Tab content
            Expanded(
              child: _buildTabContent(),
            ),
          ],
        ),
      ),
    );
  }

  // Build the content based on the selected tab
  Widget _buildTabContent() {
    final localizations = AppLocalizations.of(context)!;
    if (_selectedTab == localizations.upcoming) {
      return _buildUpcomingContent();
    } else if (_selectedTab == localizations.completed) {
      return _buildCompletedContent();
    } else if (_selectedTab == localizations.cancelled) {
      return _buildCancelContent();
    } else {
      return _buildUpcomingContent();
    }
  }

  // Content for Upcoming tab
  Widget _buildUpcomingContent() {
    return Obx(() => ListView.separated(
          itemCount: controller.upcomingAppointments.length,
          itemBuilder: (context, index) {
            BookingModel bookingModel = controller.upcomingAppointments[index];
            return _buildAppointmentCard(
              bookingModel: bookingModel,
              url: bookingModel.userModel?.profileImage ?? dummyProfileUrl,
              name: bookingModel.userModel?.fullName ?? "",
              description: '${bookingModel.userModel?.email}',
              showActions: true,
            );
          },
          separatorBuilder: (context, index) {
            return SizedBox(
              height: 10,
            );
          },
        ));
  }

  // Content for Completed tab
  Widget _buildCompletedContent() {
    return Obx(() => ListView.separated(
          itemCount: controller.completedAppointments.length,
          itemBuilder: (context, index) {
            BookingModel bookingModel = controller.completedAppointments[index];
            return _buildAppointmentCard(
              bookingModel: bookingModel,
              url: bookingModel.userModel?.profileImage ?? dummyProfileUrl,
              name: bookingModel.userModel?.fullName ?? "",
              description: '${bookingModel.userModel?.email}',
              showActions: false,
            );
          },
          separatorBuilder: (context, index) {
            return SizedBox(
              height: 10,
            );
          },
        ));
  }

  // Content for Cancel tab
  Widget _buildCancelContent() {
    return Obx(() => ListView.separated(
          itemCount: controller.cancelAppointments.length,
          itemBuilder: (context, index) {
            BookingModel bookingModel = controller.cancelAppointments[index];
            return _buildAppointmentCard(
                bookingModel: bookingModel,
                url: bookingModel.userModel?.profileImage ?? dummyProfileUrl,
                name: bookingModel.userModel?.fullName ?? "",
                description: '${bookingModel.userModel?.email}',
                showActions: false,
                isCancelled: true);
          },
          separatorBuilder: (context, index) {
            return SizedBox(
              height: 10,
            );
          },
        ));
  }

  // Reusable appointment card
  Widget _buildAppointmentCard({
    String url = dummyProfileUrl,
    required BookingModel bookingModel,
    required String name,
    required String description,
    required bool showActions,
    bool isCancelled = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            // Profile picture
            ClipRRect(
              borderRadius: BorderRadius.circular(25),
              child: CommonImageView(
                url: url,
                // dummyAvatar,
                width: 50,
                height: 50,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 12),
            // Appointment details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: isCancelled ? Colors.grey : Colors.black,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            // Action buttons
            if (showActions)
              Row(
                children: [
                  GestureDetector(
                    onTap: () => Get.to(() => CategoryDetailScreen(
                          bookingModel: bookingModel,
                          serviceModel: bookingModel.serviceModel!,
                          isSupplierView: true,
                        )),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 5),
                      decoration: BoxDecoration(
                        color: const Color(0xFF9AD08F),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        AppLocalizations.of(context)!.view,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),

                ],
              ),
            if (!showActions && !isCancelled)
              InkWell(
                onTap: () => Get.to(() => CategoryDetailScreen(
                  bookingModel: bookingModel,
                  serviceModel: bookingModel.serviceModel!,
                  isSupplierView: true,
                )),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade100,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    AppLocalizations.of(context)!.completed,
                    style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.w500,
                      fontSize: 10,
                    ),
                  ),
                ),
              ),
            if (!showActions && isCancelled)
              InkWell(
                onTap: () => Get.to(() => CategoryDetailScreen(
                  bookingModel: bookingModel,
                  serviceModel: bookingModel.serviceModel!,
                  isSupplierView: true,
                )),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
                  decoration: BoxDecoration(
                    color: Colors.red.shade100,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    AppLocalizations.of(context)!.cancelled,
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.w500,
                      fontSize: 10,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildTab(String title) {
    bool isSelected = _selectedTab == title;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedTab = title;
          });
        },
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isSelected ? Colors.grey.shade100 : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
              color: isSelected ? Colors.black : Colors.grey,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLocationOption(String title, bool isSelected) {
    return Expanded(
      child: Container(
        height: 45,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFD3EACD) : Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color:
                isSelected ? const Color(0xFF2196F3) : const Color(0xFFD3EACD),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            color: Colors.black,
          ),
        ),
      ),
    );
  }

  Widget _buildIconButton(IconData icon) {
    return Container(
      width: 28,
      height: 28,
      margin: const EdgeInsets.only(left: 4),
      child: Center(
        child: Icon(
          icon,
          color: Colors.grey,
          size: 18,
        ),
      ),
    );
  }
}
