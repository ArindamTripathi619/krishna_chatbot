import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:audioplayers/audioplayers.dart';
import '../models/message.dart';
import '../services/krishna_api.dart';
import '../widgets/message_bubble.dart';
import '../widgets/typing_indicator.dart';

class KrishnaChatPage extends StatefulWidget {
  const KrishnaChatPage({super.key});

  @override
  _KrishnaChatPageState createState() => _KrishnaChatPageState();
}

class _KrishnaChatPageState extends State<KrishnaChatPage>
    with TickerProviderStateMixin {
  final List<Message> _messages = [];
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  bool _isTyping = false;
  bool _isMuted = false; // <-- Add this line
  late final String _uid;
  late final AudioPlayer _audioPlayer;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _playMusic();
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      _uid = user.uid;
      _loadMessages();
    }
  }

  Future<void> _playMusic() async {
    await _audioPlayer.setReleaseMode(ReleaseMode.loop);
    await _audioPlayer.play(
      AssetSource('music/soothing.mp3'),
      volume: _isMuted ? 0 : 1,
    );
  }

  Future<void> _toggleMute() async {
    setState(() {
      _isMuted = !_isMuted;
    });
    await _audioPlayer.setVolume(_isMuted ? 0 : 1);
  }

  Future<void> _loadMessages() async {
    final snapshot =
        await FirebaseFirestore.instance
            .collection('users')
            .doc(_uid)
            .collection('chats')
            .orderBy('timestamp')
            .get();

    setState(() {
      _messages.clear();
      for (var doc in snapshot.docs) {
        _messages.add(Message(text: doc['text'], isUser: doc['isUser']));
      }
    });
    _scrollToBottom();
  }

  Future<void> _saveMessage(String text, bool isUser) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(_uid)
        .collection('chats')
        .add({
          'text': text,
          'isUser': isUser,
          'timestamp': FieldValue.serverTimestamp(),
        });
  }

  void _sendMessage() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _messages.add(Message(text: text, isUser: true));
      _isTyping = true;
    });
    _saveMessage(text, true);

    _controller.clear();
    _scrollToBottom();

    try {
      final krishnaReply = await KrishnaApi.getKrishnaReply(text);
      await _showReplyInChunks(krishnaReply);
    } catch (e) {
      setState(() {
        _messages.add(
          Message(
            text: "I am sorry, my dear friend. Something went wrong...",
            isUser: false,
          ),
        );
      });
      _saveMessage(
        "I am sorry, my dear friend. Something went wrong...",
        false,
      );
    } finally {
      setState(() {
        _isTyping = false;
      });
    }
  }

  Future<void> _showReplyInChunks(String fullMessage) async {
    final parts = _splitMessage(fullMessage);
    for (final part in parts) {
      await Future.delayed(Duration(seconds: 2));
      setState(() {
        _messages.add(Message(text: part, isUser: false));
      });
      await _saveMessage(part, false);
      _scrollToBottom();
    }
  }

  List<String> _splitMessage(String message) {
    final sentences = message.split(RegExp(r'(?<=[.?!])\s+'));
    List<String> chunks = [];
    String buffer = "";

    for (var sentence in sentences) {
      if ((buffer + sentence).length < 80) {
        buffer += "$sentence ";
      } else {
        chunks.add(buffer.trim());
        buffer = "$sentence ";
      }
    }
    if (buffer.isNotEmpty) chunks.add(buffer.trim());
    return chunks;
  }

  void _scrollToBottom() {
    Future.delayed(Duration(milliseconds: 300), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          "Chat with Krishna",
          style: GoogleFonts.greatVibes(
            fontSize: 32,
            color: Colors.white,
            letterSpacing: 3,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(
              _isMuted ? Icons.volume_off : Icons.volume_up,
              color: Colors.white,
            ),
            onPressed: _toggleMute,
            tooltip: _isMuted ? "Unmute Music" : "Mute Music",
          ),
          IconButton(
            icon: Icon(Icons.logout, color: Colors.white),
            onPressed: () => FirebaseAuth.instance.signOut(),
            tooltip: "Logout",
          ),
        ],
      ),
      body: Stack(
        children: [
          // Background with image and gradient
          Container(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF0B0C10), Color(0xFF181C22)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              image: DecorationImage(
                image: AssetImage('assets/krishna_bg.png'),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(0.55),
                  BlendMode.darken,
                ),
              ),
            ),
          ),
          // Translucent overlay
          Container(
            color: Color(0x80000000), // #00000080, 50% opacity black
          ),
          // Chat content
          SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.only(top: 16, bottom: 8),
                    itemCount: _messages.length,
                    itemBuilder: (context, index) {
                      final message = _messages[index];
                      return AnimatedMessageBubble(
                        key: ValueKey(
                          message.text +
                              message.isUser.toString() +
                              index.toString(),
                        ),
                        message: message,
                      );
                    },
                  ),
                ),
                if (_isTyping)
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 8,
                    ),
                    child: Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Color(
                                  0xFF00C9A7,
                                ).withOpacity(0.95), // denser peacock teal
                                blurRadius: 40, // increased blur
                                spreadRadius: 12, // increased spread
                              ),
                              BoxShadow(
                                color: Color(
                                  0xFF232946,
                                ).withOpacity(0.7), // denser midnight blue
                                blurRadius: 60, // increased blur
                                spreadRadius: 18, // increased spread
                              ),
                            ],
                          ),
                          child: CircleAvatar(
                            backgroundColor: Colors.white,
                            child: Image.asset(
                              'assets/krishna_avatar.png',
                              height: 32,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        const TypingIndicator(),
                      ],
                    ),
                  ),
                ChatInput(
                  controller: _controller,
                  onSend: _sendMessage,
                  isLoading: _isTyping,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _audioPlayer.stop();
    _audioPlayer.dispose();
    super.dispose();
  }
}

class ChatInput extends StatefulWidget {
  final TextEditingController controller;
  final VoidCallback onSend;
  final bool isLoading;

  const ChatInput({
    super.key,
    required this.controller,
    required this.onSend,
    this.isLoading = false,
  });

  @override
  State<ChatInput> createState() => _ChatInputState();
}

class _ChatInputState extends State<ChatInput>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fade;
  late TextEditingController _textController;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);

    _textController = widget.controller;
    _textController.addListener(_onTextChanged);
  }

  void _onTextChanged() {
    if (_textController.text.isEmpty) {
      if (!_controller.isAnimating) _controller.repeat(reverse: true);
    } else {
      if (_controller.isAnimating) _controller.stop();
    }
    setState(() {});
  }

  @override
  void dispose() {
    _controller.dispose();
    _textController.removeListener(_onTextChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final showHint = _textController.text.isEmpty;
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, left: 8, right: 8),
      child: Row(
        children: [
          Expanded(
            child: Stack(
              alignment: Alignment.centerLeft,
              children: [
                if (showHint)
                  FadeTransition(
                    opacity: _fade,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 0,
                      ),
                      child: Text(
                        "Open your heart to Krishna...🪈",
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.white70,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                TextField(
                  controller: _textController,
                  textInputAction: TextInputAction.send,
                  onSubmitted: (_) => widget.onSend(),
                  style: GoogleFonts.lato(fontSize: 16, color: Colors.white),
                  decoration: InputDecoration(
                    hintText: "",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(28),
                      borderSide: BorderSide(color: Colors.white24, width: 1.2),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(28),
                      borderSide: BorderSide(color: Colors.white24, width: 1.2),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(28),
                      borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.primary,
                        width: 1.5,
                      ),
                    ),
                    filled: true,
                    fillColor: Colors.transparent,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 14,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          widget.isLoading
              ? RotationTransition(
                turns: _controller,
                child: CircleAvatar(
                  backgroundColor: Colors.teal.shade700,
                  radius: 24,
                  child: Image.asset('assets/feather.png', height: 28),
                ),
              )
              : GestureDetector(
                onTap: widget.onSend,
                child: CircleAvatar(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  radius: 24,
                  child: Icon(Icons.send, color: Colors.white, size: 24),
                ),
              ),
        ],
      ),
    );
  }
}
