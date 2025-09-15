import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import '../_harness/golden_config.dart';
import '../../../lib/design/theme.dart';
import '../../../lib/design/typography.dart';
import '../../../lib/design/tokens.dart';

/// Golden tests for Theme Gallery
///
/// Tests the complete theme system including:
/// - Typography styles (headings, body, labels, buttons)
/// - Button variants (elevated, filled, outlined, text)
/// - Chip variants (assist, filter, input, suggestion)
/// - Input fields and form elements
/// - Cards and surfaces
/// - Both light and dark theme variants
void main() {
  group('Theme Gallery Golden Tests', () {
    setUpAll(GoldenTestBase.setUpAll);

    testGoldens('Theme Gallery - Complete', (tester) async {
      final widget = _buildThemeGallery();

      await GoldenConfig.pumpMultiGolden(
        tester,
        (brightness) => widget,
        name: 'screens/theme_gallery',
      );
    });

    testGoldens('Theme Gallery - Typography Only', (tester) async {
      final widget = _buildTypographyGallery();

      await GoldenConfig.pumpMultiGolden(
        tester,
        (brightness) => widget,
        name: 'screens/theme_gallery_typography',
      );
    });

    testGoldens('Theme Gallery - Buttons Only', (tester) async {
      final widget = _buildButtonGallery();

      await GoldenConfig.pumpMultiGolden(
        tester,
        (brightness) => widget,
        name: 'screens/theme_gallery_buttons',
      );
    });

    testGoldens('Theme Gallery - Form Elements', (tester) async {
      final widget = _buildFormElementsGallery();

      await GoldenConfig.pumpMultiGolden(
        tester,
        (brightness) => widget,
        name: 'screens/theme_gallery_forms',
      );
    });
  });
}

/// Build complete theme gallery
Widget _buildThemeGallery() {
  return Scaffold(
    appBar: AppBar(
      title: const Text('Theme Gallery'),
      actions: [IconButton(icon: const Icon(Icons.palette), onPressed: () {})],
    ),
    body: SingleChildScrollView(
      padding: DesignTokens.spacingLgAll,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Typography Section
          _buildSection(title: 'Typography', child: _buildTypographySection()),

          const SizedBox(height: 32),

          // Buttons Section
          _buildSection(title: 'Buttons', child: _buildButtonSection()),

          const SizedBox(height: 32),

          // Chips Section
          _buildSection(title: 'Chips', child: _buildChipSection()),

          const SizedBox(height: 32),

          // Form Elements Section
          _buildSection(
            title: 'Form Elements',
            child: _buildFormElementsSection(),
          ),

          const SizedBox(height: 32),

          // Cards Section
          _buildSection(title: 'Cards', child: _buildCardSection()),

          const SizedBox(height: 32),

          // Interactive Elements Section
          _buildSection(
            title: 'Interactive Elements',
            child: _buildInteractiveElementsSection(),
          ),
        ],
      ),
    ),
  );
}

/// Build typography gallery
Widget _buildTypographyGallery() {
  return Scaffold(
    appBar: AppBar(title: const Text('Typography Gallery')),
    body: SingleChildScrollView(
      padding: DesignTokens.spacingLgAll,
      child: _buildTypographySection(),
    ),
  );
}

/// Build button gallery
Widget _buildButtonGallery() {
  return Scaffold(
    appBar: AppBar(title: const Text('Button Gallery')),
    body: SingleChildScrollView(
      padding: DesignTokens.spacingLgAll,
      child: _buildButtonSection(),
    ),
  );
}

/// Build form elements gallery
Widget _buildFormElementsGallery() {
  return Scaffold(
    appBar: AppBar(title: const Text('Form Elements Gallery')),
    body: SingleChildScrollView(
      padding: DesignTokens.spacingLgAll,
      child: _buildFormElementsSection(),
    ),
  );
}

/// Build section wrapper
Widget _buildSection({required String title, required Widget child}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(title, style: AppTypography.h3),
      const SizedBox(height: 16),
      child,
    ],
  );
}

/// Build typography section
Widget _buildTypographySection() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      // Headings
      Text('Display Large', style: AppTypography.displayLarge),
      const SizedBox(height: 8),
      Text('Display Medium', style: AppTypography.displayMedium),
      const SizedBox(height: 8),
      Text('Display Small', style: AppTypography.displaySmall),
      const SizedBox(height: 16),

      Text('Heading 1', style: AppTypography.h1),
      const SizedBox(height: 8),
      Text('Heading 2', style: AppTypography.h2),
      const SizedBox(height: 8),
      Text('Heading 3', style: AppTypography.h3),
      const SizedBox(height: 8),
      Text('Heading 4', style: AppTypography.h4),
      const SizedBox(height: 8),
      Text('Heading 5', style: AppTypography.h5),
      const SizedBox(height: 8),
      Text('Heading 6', style: AppTypography.h6),
      const SizedBox(height: 16),

      // Body text
      Text(
        'Body Large - Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
        style: AppTypography.bodyLarge,
      ),
      const SizedBox(height: 8),
      Text(
        'Body Medium - Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
        style: AppTypography.bodyMedium,
      ),
      const SizedBox(height: 8),
      Text(
        'Body Small - Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
        style: AppTypography.bodySmall,
      ),
      const SizedBox(height: 16),

      // Labels
      Text('Label Large', style: AppTypography.labelLarge),
      const SizedBox(height: 8),
      Text('Label Medium', style: AppTypography.labelMedium),
      const SizedBox(height: 8),
      Text('Label Small', style: AppTypography.labelSmall),
      const SizedBox(height: 16),

      // Specialized
      Text('Caption', style: AppTypography.caption),
      const SizedBox(height: 8),
      Text('OVERLINE', style: AppTypography.overline),
      const SizedBox(height: 8),
      Text('Code: const example = "Hello World";', style: AppTypography.code),
      const SizedBox(height: 8),
      Text(
        'Quote: "The best way to predict the future is to create it."',
        style: AppTypography.quote,
      ),
    ],
  );
}

/// Build button section
Widget _buildButtonSection() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      // Elevated buttons
      Text('Elevated Buttons', style: AppTypography.h5),
      const SizedBox(height: 8),
      Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          ElevatedButton(onPressed: () {}, child: const Text('Primary')),
          ElevatedButton(onPressed: () {}, child: const Text('Secondary')),
          ElevatedButton(onPressed: null, child: const Text('Disabled')),
        ],
      ),
      const SizedBox(height: 16),

      // Filled buttons
      Text('Filled Buttons', style: AppTypography.h5),
      const SizedBox(height: 8),
      Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          FilledButton(onPressed: () {}, child: const Text('Primary')),
          FilledButton(onPressed: () {}, child: const Text('Secondary')),
          FilledButton(onPressed: null, child: const Text('Disabled')),
        ],
      ),
      const SizedBox(height: 16),

      // Outlined buttons
      Text('Outlined Buttons', style: AppTypography.h5),
      const SizedBox(height: 8),
      Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          OutlinedButton(onPressed: () {}, child: const Text('Primary')),
          OutlinedButton(onPressed: () {}, child: const Text('Secondary')),
          OutlinedButton(onPressed: null, child: const Text('Disabled')),
        ],
      ),
      const SizedBox(height: 16),

      // Text buttons
      Text('Text Buttons', style: AppTypography.h5),
      const SizedBox(height: 8),
      Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          TextButton(onPressed: () {}, child: const Text('Primary')),
          TextButton(onPressed: () {}, child: const Text('Secondary')),
          TextButton(onPressed: null, child: const Text('Disabled')),
        ],
      ),
      const SizedBox(height: 16),

      // Icon buttons
      Text('Icon Buttons', style: AppTypography.h5),
      const SizedBox(height: 8),
      Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.favorite)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.share)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert)),
        ],
      ),
    ],
  );
}

/// Build chip section
Widget _buildChipSection() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      // Assist chips
      Text('Assist Chips', style: AppTypography.h5),
      const SizedBox(height: 8),
      Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          Chip(
            label: const Text('Assist'),
            onDeleted: () {},
            deleteIcon: const Icon(Icons.close, size: 18),
          ),
          Chip(
            label: const Text('Filter'),
            onDeleted: () {},
            deleteIcon: const Icon(Icons.close, size: 18),
          ),
          Chip(
            label: const Text('Action'),
            onDeleted: () {},
            deleteIcon: const Icon(Icons.close, size: 18),
          ),
        ],
      ),
      const SizedBox(height: 16),

      // Filter chips
      Text('Filter Chips', style: AppTypography.h5),
      const SizedBox(height: 8),
      Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          FilterChip(
            label: const Text('Filter 1'),
            selected: true,
            onSelected: (bool value) {},
          ),
          FilterChip(
            label: const Text('Filter 2'),
            selected: false,
            onSelected: (bool value) {},
          ),
          FilterChip(
            label: const Text('Filter 3'),
            selected: true,
            onSelected: (bool value) {},
          ),
        ],
      ),
      const SizedBox(height: 16),

      // Input chips
      Text('Input Chips', style: AppTypography.h5),
      const SizedBox(height: 8),
      Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          InputChip(
            label: const Text('Input 1'),
            onDeleted: () {},
            deleteIcon: const Icon(Icons.close, size: 18),
          ),
          InputChip(
            label: const Text('Input 2'),
            onDeleted: () {},
            deleteIcon: const Icon(Icons.close, size: 18),
          ),
          InputChip(
            label: const Text('Input 3'),
            onDeleted: () {},
            deleteIcon: const Icon(Icons.close, size: 18),
          ),
        ],
      ),
      const SizedBox(height: 16),

      // Action chips
      Text('Action Chips', style: AppTypography.h5),
      const SizedBox(height: 8),
      Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          ActionChip(
            label: const Text('Action 1'),
            onPressed: () {},
            avatar: const Icon(Icons.star, size: 18),
          ),
          ActionChip(
            label: const Text('Action 2'),
            onPressed: () {},
            avatar: const Icon(Icons.favorite, size: 18),
          ),
          ActionChip(
            label: const Text('Action 3'),
            onPressed: () {},
            avatar: const Icon(Icons.share, size: 18),
          ),
        ],
      ),
    ],
  );
}

/// Build form elements section
Widget _buildFormElementsSection() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      // Text fields
      Text('Text Fields', style: AppTypography.h5),
      const SizedBox(height: 8),
      Column(
        children: [
          TextField(
            decoration: const InputDecoration(
              labelText: 'Label',
              hintText: 'Hint text',
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            decoration: const InputDecoration(
              labelText: 'Required Field',
              hintText: 'Enter your name',
              prefixIcon: Icon(Icons.person),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            decoration: const InputDecoration(
              labelText: 'Password',
              hintText: 'Enter your password',
              prefixIcon: Icon(Icons.lock),
              suffixIcon: Icon(Icons.visibility),
            ),
            obscureText: true,
          ),
          const SizedBox(height: 16),
          TextField(
            decoration: const InputDecoration(
              labelText: 'Error State',
              hintText: 'This field has an error',
              errorText: 'This field is required',
            ),
          ),
        ],
      ),
      const SizedBox(height: 24),

      // Checkboxes
      Text('Checkboxes', style: AppTypography.h5),
      const SizedBox(height: 8),
      Column(
        children: [
          CheckboxListTile(
            title: const Text('Checkbox 1'),
            subtitle: const Text('This is a checkbox with subtitle'),
            value: true,
            onChanged: (bool? value) {},
          ),
          CheckboxListTile(
            title: const Text('Checkbox 2'),
            subtitle: const Text('This is another checkbox'),
            value: false,
            onChanged: (bool? value) {},
          ),
          CheckboxListTile(
            title: const Text('Disabled Checkbox'),
            subtitle: const Text('This checkbox is disabled'),
            value: false,
            onChanged: null,
          ),
        ],
      ),
      const SizedBox(height: 24),

      // Radio buttons
      Text('Radio Buttons', style: AppTypography.h5),
      const SizedBox(height: 8),
      Column(
        children: [
          RadioListTile<String>(
            title: const Text('Option 1'),
            subtitle: const Text('This is the first option'),
            value: 'option1',
            groupValue: 'option1',
            onChanged: (String? value) {},
          ),
          RadioListTile<String>(
            title: const Text('Option 2'),
            subtitle: const Text('This is the second option'),
            value: 'option2',
            groupValue: 'option1',
            onChanged: (String? value) {},
          ),
          RadioListTile<String>(
            title: const Text('Disabled Option'),
            subtitle: const Text('This option is disabled'),
            value: 'option3',
            groupValue: 'option1',
            onChanged: null,
          ),
        ],
      ),
      const SizedBox(height: 24),

      // Switches
      Text('Switches', style: AppTypography.h5),
      const SizedBox(height: 8),
      Column(
        children: [
          SwitchListTile(
            title: const Text('Switch 1'),
            subtitle: const Text('This is a switch with subtitle'),
            value: true,
            onChanged: (bool value) {},
          ),
          SwitchListTile(
            title: const Text('Switch 2'),
            subtitle: const Text('This is another switch'),
            value: false,
            onChanged: (bool value) {},
          ),
          SwitchListTile(
            title: const Text('Disabled Switch'),
            subtitle: const Text('This switch is disabled'),
            value: false,
            onChanged: null,
          ),
        ],
      ),
    ],
  );
}

/// Build card section
Widget _buildCardSection() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      // Basic cards
      Text('Basic Cards', style: AppTypography.h5),
      const SizedBox(height: 8),
      Card(
        child: Padding(
          padding: DesignTokens.spacingLgAll,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Card Title', style: AppTypography.h6),
              const SizedBox(height: 8),
              Text(
                'This is a basic card with some content.',
                style: AppTypography.bodyMedium,
              ),
            ],
          ),
        ),
      ),
      const SizedBox(height: 16),

      // Elevated cards
      Text('Elevated Cards', style: AppTypography.h5),
      const SizedBox(height: 8),
      Card(
        elevation: 4,
        child: Padding(
          padding: DesignTokens.spacingLgAll,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Elevated Card', style: AppTypography.h6),
              const SizedBox(height: 8),
              Text(
                'This card has elevated shadow.',
                style: AppTypography.bodyMedium,
              ),
            ],
          ),
        ),
      ),
      const SizedBox(height: 16),

      // Outlined cards
      Text('Outlined Cards', style: AppTypography.h5),
      const SizedBox(height: 8),
      Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          side: BorderSide(color: DesignTokens.outline),
          borderRadius: DesignTokens.radiusLgAll,
        ),
        child: Padding(
          padding: DesignTokens.spacingLgAll,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Outlined Card', style: AppTypography.h6),
              const SizedBox(height: 8),
              Text(
                'This card has an outline border.',
                style: AppTypography.bodyMedium,
              ),
            ],
          ),
        ),
      ),
    ],
  );
}

/// Build interactive elements section
Widget _buildInteractiveElementsSection() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      // Progress indicators
      Text('Progress Indicators', style: AppTypography.h5),
      const SizedBox(height: 8),
      Column(
        children: [
          const LinearProgressIndicator(value: 0.3),
          const SizedBox(height: 16),
          const CircularProgressIndicator(),
          const SizedBox(height: 16),
          const CircularProgressIndicator(value: 0.7),
        ],
      ),
      const SizedBox(height: 24),

      // Sliders
      Text('Sliders', style: AppTypography.h5),
      const SizedBox(height: 8),
      Column(
        children: [
          Slider(value: 0.3, onChanged: (double value) {}),
          Slider(value: 0.7, onChanged: (double value) {}),
        ],
      ),
      const SizedBox(height: 24),

      // List tiles
      Text('List Tiles', style: AppTypography.h5),
      const SizedBox(height: 8),
      Card(
        child: Column(
          children: [
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('List Tile 1'),
              subtitle: const Text('This is a list tile with subtitle'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {},
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('List Tile 2'),
              subtitle: const Text('This is another list tile'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {},
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.info),
              title: const Text('List Tile 3'),
              subtitle: const Text('This is a third list tile'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {},
            ),
          ],
        ),
      ),
    ],
  );
}

