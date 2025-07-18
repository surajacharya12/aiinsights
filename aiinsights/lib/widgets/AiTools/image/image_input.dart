import 'package:flutter/material.dart';

class ImageInput extends StatefulWidget {
  final Function(String, String) onSubmit;
  final bool loading;

  const ImageInput({required this.onSubmit, required this.loading, super.key});

  @override
  State<ImageInput> createState() => _ImageInputState();
}

class _ImageInputState extends State<ImageInput> {
  String _prompt = '';
  String _aspectRatio = '1:1';

  void _handleSubmit() {
    if (_prompt.trim().isNotEmpty) {
      widget.onSubmit(_prompt.trim(), _aspectRatio);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    return Container(
      constraints: const BoxConstraints(minHeight: 500),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        border: Border.all(color: colorScheme.outline.withOpacity(0.08)),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Generate Amazing Images',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: colorScheme.primary,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Transforming Ideas into Visual Reality',
            style: theme.textTheme.titleMedium?.copyWith(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'This section represents the visual tools powered by AI that bring creativity to life.',
            style: theme.textTheme.bodyLarge?.copyWith(
              fontSize: 16,
              color: isDark ? Colors.grey[300] : Colors.grey[700],
            ),
          ),
          const SizedBox(height: 24),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Enter your prompt',
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 8),
              AbsorbPointer(
                absorbing: widget.loading,
                child: TextFormField(
                  maxLines: 5,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: colorScheme.onSurface,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Describe the image you want to generate...',
                    hintStyle: theme.textTheme.bodyLarge?.copyWith(
                      color: isDark ? Colors.grey[400] : Colors.grey[700],
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(
                        color: colorScheme.outline.withOpacity(0.2),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(color: colorScheme.primary),
                    ),
                    filled: true,
                    fillColor: colorScheme.background,
                    contentPadding: const EdgeInsets.all(12),
                  ),
                  onChanged: (value) => _prompt = value,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Aspect Ratio',
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 8),
              AbsorbPointer(
                absorbing: widget.loading,
                child: DropdownButtonFormField<String>(
                  value: _aspectRatio,
                  items: const [
                    DropdownMenuItem(value: '1:1', child: Text('1:1 (Square)')),
                    DropdownMenuItem(
                      value: '16:9',
                      child: Text('16:9 (Widescreen)'),
                    ),
                    DropdownMenuItem(
                      value: '9:16',
                      child: Text('9:16 (Portrait)'),
                    ),
                    DropdownMenuItem(value: '4:3', child: Text('4:3')),
                    DropdownMenuItem(value: '3:2', child: Text('3:2')),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _aspectRatio = value;
                      });
                    }
                  },
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: colorScheme.onSurface,
                  ),
                  dropdownColor: colorScheme.surface,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(
                        color: colorScheme.outline.withOpacity(0.2),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(color: colorScheme.primary),
                    ),
                    filled: true,
                    fillColor: colorScheme.background,
                    contentPadding: const EdgeInsets.all(12),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: widget.loading ? null : _handleSubmit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: widget.loading
                      ? colorScheme.primary.withOpacity(0.7)
                      : colorScheme.primary,
                  foregroundColor: colorScheme.onPrimary,
                  padding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 24,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 4,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (widget.loading)
                      const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    else
                      const Icon(Icons.auto_awesome, size: 20),
                    const SizedBox(width: 8),
                    Text(widget.loading ? 'Generating...' : 'Generate Image'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
