import 'package:bio_pet/providers/classification_provider.dart';
import 'package:bio_pet/providers/history_provider.dart';
import 'package:bio_pet/utils/constants.dart';
import 'package:bio_pet/views/history/history_page.dart';
import 'package:bio_pet/widgets/loading_widget.dart';
import 'package:bio_pet/views/result/result_page.dart';
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
      context.read<ClassificationProvider>().initialize();
      context.read<HistoryProvider>().loadHistory();
    });
  }

  @override
  Widget build(BuildContext context) {
    final paddingAll = Responsive.wp(context, 4);

    return Scaffold(
      backgroundColor: AppColors.darkBlueBackground,
      appBar: _buildAppBar(context),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(paddingAll),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: Responsive.hp(context, 4.5)),
              context.watch<ClassificationProvider>().isLoading
                  ? const LoadingWidget()
                  : _buildImageSourceCard(context),
              SizedBox(height: Responsive.hp(context, 3.5)),
              _buildHowItWorksCard(context),
            ],
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.darkBlueBackground,
      elevation: 0,
      leading: Icon(
        Icons.pets,
        color: AppColors.secondaryBlue,
        size: Responsive.wp(context, 6),
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Pet Classifier', style: AppTextStyles.mainTitle),
          SizedBox(height: Responsive.hp(context, 0.4)),
          const Text(
            'Advanced AI-powered pet identification',
            style: AppTextStyles.subTitle,
          ),
        ],
      ),
      actions: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: AppColors.primaryBlue,
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: IconButton(
                icon: const Icon(Icons.history, color: Colors.white, size: 24),
                onPressed: () async {
                  await context.read<HistoryProvider>().loadHistory();
                  if (context.mounted) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const HistoryPage(),
                      ),
                    );
                  }
                },
              ),
            ),
            Positioned(
              right: -5,
              top: -5,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.red[400],
                ),
                constraints: const BoxConstraints(minWidth: 20, minHeight: 20),
                child: Text(
                  '${context.watch<HistoryProvider>().historyCount}',
                  style: AppTextStyles.smallText,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(width: 16),
      ],
    );
  }

  Widget _buildImageSourceCard(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(Responsive.wp(context, 4)),
      decoration: BoxDecoration(
        color: AppColors.cardBackgroundColor,
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Choose Image Source',
            textAlign: TextAlign.center,
            style: AppTextStyles.heading,
          ),
          SizedBox(height: Responsive.hp(context, 0.6)),
          const Text(
            'Take a photo or select from gallery',
            textAlign: TextAlign.center,
            style: AppTextStyles.bodyText,
          ),
          SizedBox(height: Responsive.hp(context, 2.5)),
          ElevatedButton.icon(
            onPressed: () => _handleImagePick(context, ImageSource.gallery),
            icon: Icon(
              Icons.photo_library_outlined,
              size: Responsive.sp(context, 16),
            ),
            label: const Text('Choose from Gallery'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryBlue,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(
                vertical: Responsive.hp(context, 1.8),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              textStyle: AppTextStyles.heading,
            ),
          ),
          SizedBox(height: Responsive.hp(context, 1.5)),
          Row(
            children: [
              const Expanded(child: Divider(color: Color(0xFF334155))),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: Responsive.wp(context, 2.5),
                ),
                child: const Text('or', style: AppTextStyles.bodyText),
              ),
              const Expanded(child: Divider(color: Color(0xFF334155))),
            ],
          ),
          SizedBox(height: Responsive.hp(context, 1.5)),
          OutlinedButton.icon(
            onPressed: () => _handleImagePick(context, ImageSource.camera),
            icon: Icon(
              Icons.camera_alt_outlined,
              color: AppColors.primaryBlue,
              size: Responsive.sp(context, 15),
            ),
            label: const Text('Open Camera'),
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: AppColors.primaryBlue),
              foregroundColor: AppColors.primaryBlue,
              backgroundColor: Colors.transparent,
              padding: EdgeInsets.symmetric(
                vertical: Responsive.hp(context, 1.8),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              textStyle: AppTextStyles.heading,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _handleImagePick(
    BuildContext context,
    ImageSource source,
  ) async {
    final provider = context.read<ClassificationProvider>();
    await provider.pickImage(source);

    if (provider.imagePath != null && provider.imagePath!.isNotEmpty) {
      await provider.classifyImage();

      if (context.mounted && provider.hasResult) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ResultPage()),
        );
      }
    }
  }

  Widget _buildHowItWorksCard(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(Responsive.wp(context, 4)),
      decoration: BoxDecoration(
        color: AppColors.cardBackgroundColor,
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.auto_awesome,
                color: AppColors.secondaryBlue,
                size: Responsive.sp(context, 18),
              ),
              SizedBox(width: Responsive.wp(context, 2)),
              const Text('How It Works', style: AppTextStyles.heading),
            ],
          ),
          SizedBox(height: Responsive.hp(context, 1.5)),
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
          const Divider(color: Color(0xFF334155)),
          SizedBox(height: Responsive.hp(context, 1.5)),
          const Text(
            'All classifications are saved to your history. You can search for more information about any classified breed.',
            style: AppTextStyles.bodyText,
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
          Container(
            width: Responsive.wp(context, 5),
            height: Responsive.wp(context, 5),
            decoration: const BoxDecoration(
              color: AppColors.primaryBlue,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text('$stepNumber', style: AppTextStyles.smallText),
            ),
          ),
          SizedBox(width: Responsive.wp(context, 3)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTextStyles.heading),
                Text(description, style: AppTextStyles.bodyText),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
