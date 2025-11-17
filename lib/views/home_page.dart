import 'package:bio_pet/providers/classify_provider.dart';
import 'package:bio_pet/utils/color_const.dart';
import 'package:bio_pet/views/history_page.dart';
import 'package:bio_pet/views/loading.dart';
import 'package:bio_pet/views/result_page.dart';
import 'package:bio_pet/utils/text_style.dart';
import 'package:bio_pet/utils/responsive.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ClassifyProvider>().initHelper();

      context.read<ClassifyProvider>().getHistoryList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final paddingAll = Responsive.wp(context, 4); // dynamic padding
    return Scaffold(
      backgroundColor: darkBlueBackground,
      appBar: AppBar(
        backgroundColor: darkBlueBackground,
        elevation: 0,
        leading: Icon(
          Icons.pets,
          color: secondaryBlue,
          size: Responsive.wp(context, 6),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Pet Classifier', style: TextStyles.mainTitle),
            SizedBox(height: Responsive.hp(context, 0.4)),
            Text(
              'Advanced AI-powered pet identification',
              style: TextStyles.subTitle,
            ),
          ],
        ),
        actions: [
          Stack(
            clipBehavior:
                Clip.none, // Allows the badge to extend outside the container
            children: [
              // The main icon button container
              Container(
                width: 50, // Adjust size as needed
                height: 50,

                decoration: BoxDecoration(
                  color: primaryBlue,
                  // border: Border.all(color: Colors.white, width: 0.5),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: IconButton(
                  icon: const Icon(
                    Icons.history,
                    color: Colors.white,
                    size: 24,
                  ),
                  onPressed: () {
                    context.read<ClassifyProvider>().getHistoryList();
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => HistoryPage()),
                    );
                  },
                ),
              ),
              // The Badge Counter
              Positioned(
                right: -5,
                top: -5,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color:
                        Colors.red[400], // Use a distinct color for the badge
                    // borderRadius: BorderRadius.circular(10),
                    // border: Border.all(
                    //   color: darkBlueBackground,
                    //   width: 2,
                    // ), // To match the dark background border
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 20,
                    minHeight: 20,
                  ),
                  child: Text(
                    '${context.read<ClassifyProvider>().historyList.length}',
                    style: TextStyles.b3,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(width: 16),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(paddingAll),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: Responsive.hp(context, 4.5)),

              // --- Choose Image Source Section ---
              context.watch<ClassifyProvider>().isLoading
                  ? Loading()
                  : _buildImageSourceCard(context),

              SizedBox(height: Responsive.hp(context, 3.5)),

              // --- How It Works Section ---
              _buildHowItWorksCard(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImageSourceCard(BuildContext context) {
    // img.Image? image;
    return Container(
      padding: EdgeInsets.all(Responsive.wp(context, 4)),
      decoration: BoxDecoration(
        color: cardBackgroundColor,
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Choose Image Source',
            textAlign: TextAlign.center,
            style: TextStyles.b1,
          ),
          SizedBox(height: Responsive.hp(context, 0.6)),
          Text(
            'Take a photo or select from gallery',
            textAlign: TextAlign.center,
            style: TextStyles.b2,
          ),
          SizedBox(height: Responsive.hp(context, 2.5)),

          // Open Camera Button
          ElevatedButton.icon(
            onPressed: () async {
              await context.read<ClassifyProvider>().pickImage(
                ImageSource.gallery,
              );
              if (context.mounted) {
                if (context.read<ClassifyProvider>().imagePath != null &&
                    context.read<ClassifyProvider>().imagePath!.isNotEmpty) {
                  await context.read<ClassifyProvider>().processImage();
                  if (context.mounted) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ResultPage()),
                    );
                  }
                }
              }
            },
            icon: Icon(
              Icons.photo_library_outlined,
              size: Responsive.sp(context, 16),
            ),
            label: Text('Choose from Gallery'),
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryBlue,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(
                vertical: Responsive.hp(context, 1.8),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              textStyle: TextStyles.b1,
            ),
          ),
          SizedBox(height: Responsive.hp(context, 1.5)),

          // 'or' separator
          Row(
            children: [
              Expanded(child: Divider(color: const Color(0xFF334155))),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: Responsive.wp(context, 2.5),
                ),
                child: Text('or', style: TextStyles.b2),
              ),
              Expanded(child: Divider(color: const Color(0xFF334155))),
            ],
          ),
          SizedBox(height: Responsive.hp(context, 1.5)),

          // Choose from Gallery Button
          OutlinedButton.icon(
            onPressed: () async {
              await context.read<ClassifyProvider>().pickImage(
                ImageSource.camera,
              );
              if (context.mounted) {
                if (context.read<ClassifyProvider>().imagePath != null &&
                    context.read<ClassifyProvider>().imagePath!.isNotEmpty) {
                  await context.read<ClassifyProvider>().processImage();
                  if (context.mounted) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ResultPage()),
                    );
                  }
                }
              }
            },
            icon: Icon(
              Icons.camera_alt_outlined,
              color: primaryBlue,
              size: Responsive.sp(context, 15),
            ),
            label: Text('Open Camera'),
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: primaryBlue),
              foregroundColor: primaryBlue,
              backgroundColor: Colors.transparent,
              padding: EdgeInsets.symmetric(
                vertical: Responsive.hp(context, 1.8),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              textStyle: TextStyles.b1,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHowItWorksCard(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(Responsive.wp(context, 4)),
      decoration: BoxDecoration(
        color: cardBackgroundColor,
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.auto_awesome,
                color: secondaryBlue,
                size: Responsive.sp(context, 18),
              ),
              SizedBox(width: Responsive.wp(context, 2)),
              Text('How It Works', style: TextStyles.b1),
            ],
          ),
          SizedBox(height: Responsive.hp(context, 1.5)),

          // Steps
          _buildStep(
            context: context,
            stepNumber: 1,
            title: 'Capture or Upload',
            description: 'Take a photo with your camera or select from gallery',
          ),
          _buildStep(
            context: context,
            stepNumber: 2,
            title: 'AI Analysis',
            description: 'Our neural network analyzes the image features',
          ),
          _buildStep(
            context: context,
            stepNumber: 3,
            title: 'Get Results',
            description:
                'View breed classification with name and confidence scores',
          ),

          SizedBox(height: Responsive.hp(context, 1.5)),
          Divider(color: const Color(0xFF334155)),
          SizedBox(height: Responsive.hp(context, 1.5)),

          // Footer Text
          Text(
            'All classifications are saved to your history. You can search for more information about any classified breed.',
            style: TextStyles.b2,
          ),
        ],
      ),
    );
  }

  Widget _buildStep({
    required BuildContext context,
    required int stepNumber,
    required String title,
    required String description,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: Responsive.hp(context, 1.5)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Step Number Circle
          Container(
            width: Responsive.wp(context, 5),
            height: Responsive.wp(context, 5),
            decoration: BoxDecoration(
              color: primaryBlue,
              shape: BoxShape.circle,
            ),
            child: Center(child: Text('$stepNumber', style: TextStyles.b3)),
          ),
          SizedBox(width: Responsive.wp(context, 3)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyles.b1),
                Text(description, style: TextStyles.b2),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
