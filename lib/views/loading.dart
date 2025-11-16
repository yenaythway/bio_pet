import 'package:bio_pet/utils/color_const.dart';
import 'package:flutter/material.dart';

class Loading extends StatefulWidget {
  const Loading({super.key});

  @override
  State<Loading> createState() => _LoadingState();
}

class _LoadingState extends State<Loading> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(); // makes it rotate forever
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Added a boolean parameter to control loading state
    return Container(
      decoration: BoxDecoration(
        color: primaryBlue, // Use cardColor for the container background
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // This section will now conditionally show either the image or the loading UI
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(12.0),
              topRight: Radius.circular(12.0),
            ),
            child: Stack(
              children: [
                Image.asset(
                  'assets/images/logo1.png',
                  height: 300,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
                Opacity(
                  opacity: 0.8,
                  child: Container(
                    height: 300, // Maintain the same height as the image
                    width: double.infinity,
                    color:
                        secondaryBlue, // A specific purplish-blue color for the loading area, derived from your screenshot
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        RotationTransition(
                          turns: _controller,
                          child: const Icon(
                            Icons.sync, // Or Icons.autorenew for a similar look
                            color: lightTextColor,
                            size: 40,
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          'Classifying Image...',
                          style: TextStyle(
                            color: lightTextColor,
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 10),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // The status bar or a loading-specific bottom section
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Container(
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.hourglass_bottom, size: 16, color: Colors.white),
                  const Text(
                    ' Analyzing data...',
                    style: TextStyle(color: Colors.white, fontSize: 14),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
