import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:inovant/core/constants/app_colors.dart';
import 'package:inovant/core/util/responsive_helper.dart';
import 'package:inovant/models/influencer.dart';
import 'package:inovant/screens/influencer_detail.dart';

class InfluencerCard extends StatelessWidget {
  final Influencer influencer;

  const InfluencerCard({super.key, required this.influencer});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: ResponsiveHelper.scalePadding(
        context,
        vertical: 8,
        horizontal: 12,
      ),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return InfluencerDetailPage(influencerId: influencer.id);
              },
            ),
          );
        },
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: AppColors.background,
            border: Border.all(color: AppColors.glassAppBarBorder),
            borderRadius: BorderRadius.circular(
              ResponsiveHelper.scaleRadius(context, 12),
            ),
          ),
          child: Padding(
            padding: ResponsiveHelper.scalePadding(
              context,
              vertical: 12,
              horizontal: 12,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Profile Image as CircleAvatar
                CircleAvatar(
                  radius: ResponsiveHelper.scaleWidth(context, 30),
                  backgroundColor: Colors.grey.shade800,
                  backgroundImage: null, // remove this
                  child: ClipOval(
                    child: Image.network(
                      influencer.image,
                      fit: BoxFit.cover,
                      width: ResponsiveHelper.scaleWidth(context, 60),
                      height: ResponsiveHelper.scaleWidth(context, 60),
                      errorBuilder: (context, error, stackTrace) {
                        return Icon(
                          Icons.person,
                          size: ResponsiveHelper.scaleWidth(context, 28),
                          color: Colors.white70,
                        );
                      },
                    ),
                  ),
                ),

                SizedBox(width: ResponsiveHelper.scaleGap(context, 12)),

                // Info Section
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Name + Gender Dot
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              influencer.name,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16.sp,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          GenderDot(gender: influencer.gender),
                        ],
                      ),
                      SizedBox(height: ResponsiveHelper.scaleGap(context, 6)),

                      // Phone
                      Text(
                        "+${influencer.phoneCode} ${influencer.phone}",
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Small dot widget to represent gender
class GenderDot extends StatelessWidget {
  final String gender;

  const GenderDot({super.key, required this.gender});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: ResponsiveHelper.scaleHeight(context, 12),
      width: ResponsiveHelper.scaleWidth(context, 12),
      decoration: BoxDecoration(
        color: gender == "M" ? Colors.blue : Colors.pink,
        shape: BoxShape.circle,
      ),
    );
  }
}
