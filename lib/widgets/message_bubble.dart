import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/message.dart';

class AnimatedMessageBubble extends StatefulWidget {
  final Message message;
  const AnimatedMessageBubble({super.key, required this.message});

  @override
  State<AnimatedMessageBubble> createState() => _AnimatedMessageBubbleState();
}

class _AnimatedMessageBubbleState extends State<AnimatedMessageBubble>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fade;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 500),
      vsync: this,
    );
    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  bool containsDevanagari(String text) {
    // Devanagari Unicode block: \u0900-\u097F
    return RegExp(r'[\u0900-\u097F]').hasMatch(text);
  }

  @override
  Widget build(BuildContext context) {
    final isUser = widget.message.isUser;

    // Gradients
    final krishnaGradient = LinearGradient(
      colors: [
        Color(0xFF232946), // midnight blue
        Color(0xFF00C9A7), // peacock teal
      ],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
    final userGradient = LinearGradient(
      colors: [
        Color(0xFFE3E6FF), // pastel lavender
        Color(0xFFB3E5FC), // sky blue
      ],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );

    // Text colors
    final krishnaTextColor = Color(0xFFFFFDF6); // ivory white
    final userTextColor = Color(0xFF232323); // charcoal

    return FadeTransition(
      opacity: _fade,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 6, horizontal: 12),
        child: Row(
          mainAxisAlignment:
              isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            // For Krishna's avatar
            if (!isUser)
              CircleAvatar(
                radius: 20,
                backgroundColor: Colors.transparent,
                backgroundImage: AssetImage('assets/krishna_avatar.webp'),
              ),
            if (!isUser) const SizedBox(width: 8),
            // User's message: show bubble, then pfp
            if (isUser) ...[
              Flexible(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.6,
                  ),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 16,
                    ),
                    decoration: BoxDecoration(
                      gradient: userGradient,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(22),
                        topRight: Radius.circular(22),
                        bottomLeft: Radius.circular(22),
                        bottomRight: Radius.circular(6),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.18),
                          blurRadius: 8,
                          offset: Offset(0, 2),
                        ),
                      ],
                      border: Border.all(
                        color: Colors.grey.shade300, // silver outline
                        width: 1.2,
                      ),
                    ),
                    child: Text(
                      widget.message.text,
                      style: GoogleFonts.comicNeue(
                        color: userTextColor,
                        fontSize: 21,
                        fontWeight: FontWeight.w600,
                        height: 1.4,
                        letterSpacing: 0.1,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              CircleAvatar(
                radius: 20,
                backgroundColor: Colors.transparent,
                backgroundImage: AssetImage('assets/user_avatar.webp'),
              ),
            ],
            // Krishna's message: show bubble after avatar
            if (!isUser)
              Flexible(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.6,
                  ),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 16,
                    ),
                    decoration: BoxDecoration(
                      gradient: krishnaGradient,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(22),
                        topRight: Radius.circular(22),
                        bottomLeft: Radius.circular(6),
                        bottomRight: Radius.circular(22),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Color(0xFF00C9A7).withOpacity(0.45),
                          blurRadius: 18,
                          spreadRadius: 2,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Text(
                      widget.message.text,
                      style:
                          containsDevanagari(widget.message.text)
                              ? GoogleFonts.yatraOne(
                                color: krishnaTextColor,
                                fontSize: 22,
                                fontWeight: FontWeight.w400,
                                height: 1.4,
                                letterSpacing: 0.1,
                              )
                              : GoogleFonts.merienda(
                                color: krishnaTextColor,
                                fontSize: 19,
                                fontWeight: FontWeight.w500,
                                height: 1.4,
                                letterSpacing: 0.1,
                              ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
