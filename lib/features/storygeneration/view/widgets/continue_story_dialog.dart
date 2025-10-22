import 'package:flutter/material.dart';

class ContinueStoryDialog extends StatefulWidget {
  final String locale;

  const ContinueStoryDialog({
    super.key,
    this.locale = 'tr',
  });

  @override
  State<ContinueStoryDialog> createState() => _ContinueStoryDialogState();
}

class _ContinueStoryDialogState extends State<ContinueStoryDialog> {
  final TextEditingController _controller = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color(0xFF1A1A1A),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: Color(0xFF24FF00), width: 1),
      ),
      title: Text(
        widget.locale == 'tr' ? 'Hikayeyi Devam Ettir' : 'Continue Story',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.locale == 'tr' 
                ? 'Hikayenin nasıl devam etmesini istiyorsunuz?'
                : 'How would you like the story to continue?',
            style: TextStyle(
              color: Colors.grey.shade300,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _controller,
            maxLines: 4,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: widget.locale == 'tr' 
                  ? 'Örnek: Ana karakter yeni bir maceraya başlasın...'
                  : 'Example: The main character starts a new adventure...',
              hintStyle: TextStyle(color: Colors.grey.shade500),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey.shade700),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey.shade700),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Color(0xFF24FF00)),
              ),
              filled: true,
              fillColor: Colors.grey.shade900,
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: _isLoading ? null : () => Navigator.of(context).pop(),
          child: Text(
            widget.locale == 'tr' ? 'İptal' : 'Cancel',
            style: TextStyle(color: Colors.grey.shade400),
          ),
        ),
        ElevatedButton(
          onPressed: _isLoading ? null : _continueStory,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF24FF00),
            foregroundColor: Colors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: _isLoading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                  ),
                )
              : Text(
                  widget.locale == 'tr' ? 'Devam Et' : 'Continue',
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
        ),
      ],
    );
  }

  void _continueStory() {
    final prompt = _controller.text.trim();
    if (prompt.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            widget.locale == 'tr' 
                ? 'Lütfen hikayenin nasıl devam etmesini istediğinizi yazın'
                : 'Please write how you want the story to continue',
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    Navigator.of(context).pop(prompt);
  }
}
