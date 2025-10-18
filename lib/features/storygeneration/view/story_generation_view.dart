
import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';

@RoutePage(
  name: 'StoryGenerationRoute',
)
class StoryGenerationView extends StatefulWidget {
  const StoryGenerationView({super.key});

  @override
  State<StoryGenerationView> createState() => _StoryGenerationViewState();
}

class _StoryGenerationViewState extends State<StoryGenerationView> {
  int selectedLength = 0; // 0: Short, 1: Mid, 2: Long
  double sliderValue = 0; // -1: Standard, 0: Complex, 1: Creative
  bool isExpanded1 = false;
  bool isExpanded2 = false;
  bool isExpanded3 = false;
  bool isExpanded4 = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F0F),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Result Image',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),

              // Length Selection Buttons
              Row(
                children: [
                  _buildLengthButton('Short', 0),
                  const SizedBox(width: 8),
                  _buildLengthButton('Mid', 1),
                  const SizedBox(width: 8),
                  _buildLengthButton('Long', 2),
                ],
              ),

              const SizedBox(height: 30),

              // Expandable Sections
              _buildExpandableSection(
                'character details',
                'Name, age, personality, appearance.',
                isExpanded1,
                () => setState(() => isExpanded1 = !isExpanded1),
              ),

              const SizedBox(height: 16),

              _buildExpandableSection(
                'setting and environment',
                'Location, atmosphere.',
                isExpanded2,
                () => setState(() => isExpanded2 = !isExpanded2),
              ),

              const SizedBox(height: 16),

              _buildExpandableSection(
                'plot structure',
                'Beginning, development, conflict, resolution.',
                isExpanded3,
                () => setState(() => isExpanded3 = !isExpanded3),
              ),

              const SizedBox(height: 16),

              _buildExpandableSection(
                'emotions and tone',
                "Character's feeling, overall mood of the story.",
                isExpanded4,
                () => setState(() => isExpanded4 = !isExpanded4),
              ),

              const SizedBox(height: 40),

              // Slider Section
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Standard',
                        style: TextStyle(
                          color: sliderValue <= -0.3 ? Colors.white : Colors.grey,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        'Complex',
                        style: TextStyle(
                          color: sliderValue.abs() <= 0.3 ? Colors.white : Colors.grey,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        'Creative',
                        style: TextStyle(
                          color: sliderValue >= 0.3 ? Colors.white : Colors.grey,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  SliderTheme(
                    data: SliderThemeData(
                      trackHeight: 6,
                      thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10),
                      activeTrackColor: Colors.white,
                      inactiveTrackColor: Colors.grey.shade800,
                      thumbColor: Colors.white,
                      overlayColor: Colors.white.withOpacity(0.2),
                    ),
                    child: Slider(
                      value: sliderValue,
                      min: -1,
                      max: 1,
                      divisions: 2,
                      onChanged: (value) {
                        setState(() {
                          sliderValue = value;
                        });
                      },
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 40),

              // Generate Button
              SizedBox(
                width: double.infinity,
                height: 60,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF24FF00),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text(
                    'Generate',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLengthButton(String text, int index) {
    return Expanded(
      child: ElevatedButton(
        onPressed: () {
          setState(() {
            selectedLength = index;
          });
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: selectedLength == index
              ? const Color(0xFF24FF00)
              : Colors.grey.shade800,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
          padding: const EdgeInsets.symmetric(vertical: 12),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: selectedLength == index ? Colors.black : Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildExpandableSection(String title, String subtitle, bool isExpanded, VoidCallback onTap) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isExpanded ? const Color(0xFF24FF00) : Colors.grey.shade800,
          width: 1,
        ),
      ),
      child: Column(
        children: [
          GestureDetector(
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          subtitle,
                          style: TextStyle(
                            color: Colors.grey.shade400,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    isExpanded ? Icons.expand_less : Icons.expand_more,
                    color: isExpanded ? const Color(0xFF24FF00) : Colors.grey,
                  ),
                ],
              ),
            ),
          ),
          if (isExpanded)
            Container(
              width: double.infinity,
              height: 100,
              margin: const EdgeInsets.only(bottom: 16, left: 16, right: 16),
              decoration: BoxDecoration(
                color: Colors.grey.shade900,
                borderRadius: BorderRadius.circular(8),
              ),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Enter $title details...',
                  hintStyle: TextStyle(color: Colors.grey.shade500),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.all(16),
                ),
                style: const TextStyle(color: Colors.white),
                maxLines: 3,
              ),
            ),
        ],
      ),
    );
  }
}