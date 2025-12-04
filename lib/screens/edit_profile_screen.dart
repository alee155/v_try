import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vtry/utils/app_colors.dart';
import 'package:vtry/widgets/custom_button.dart';
import 'package:vtry/widgets/edit_text_field.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('Edit Profile'),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            20.h.verticalSpace,

            // ---------------- Avatar with camera icon ----------------
            Center(
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 70.r,
                    backgroundColor: Colors.blue,
                    backgroundImage: NetworkImage(
                      "https://images.unsplash.com/photo-1506794778202-cad84cf45f1a?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=870&q=80",
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 10.w,
                    child: GestureDetector(
                      onTap: () {
                        // Handle avatar change
                        print("Camera icon tapped");
                      },
                      child: Container(
                        padding: EdgeInsets.all(5.w),
                        decoration: BoxDecoration(
                          color: AppColors.primaryBlue,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.camera_alt,
                          size: 20.sp,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            20.h.verticalSpace,

            // ---------------- Name field ----------------
            Text(
              "Name",
              style: TextStyle(
                color: Colors.black,
                fontSize: 15.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            EditTextField(
              hintText: "Enter your name",
              controller: nameController,
            ),

            10.h.verticalSpace,

            // ---------------- Phone field ----------------
            Text(
              "Phone",
              style: TextStyle(
                color: Colors.black,
                fontSize: 15.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            EditTextField(
              hintText: "Enter your phone number",
              controller: phoneController,
              keyboardType: TextInputType.phone,
            ),

            50.h.verticalSpace,

            // ---------------- Save button ----------------
            Center(
              child: CustomButton(
                text: "Save",
                onPressed: () {
                  print("Name: ${nameController.text}");
                  print("Phone: ${phoneController.text}");
                },
                backgroundColor: AppColors.primaryBlue,
                textColor: Colors.white,
                textSize: 15.sp,
                fontWeight: FontWeight.bold,
                fontFamily: 'Roboto',
                borderRadius: 20.r,
                height: 55.h,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
