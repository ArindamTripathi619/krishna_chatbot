import 'package:flutter/material.dart';
import 'models/message.dart';
import 'services/krishna_api.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';


// void main() {
//   runApp(KrishnaChatApp());
// }

Future<void> main() async {
  await dotenv.load(fileName: ".env");
  runApp(KrishnaChatApp());
}

class KrishnaChatApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chat with Krishna',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Color(0xFFE3F2FD),
      ),
      home: KrishnaChatPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class KrishnaChatPage extends StatefulWidget {
  @override
  _KrishnaChatPageState createState() => _KrishnaChatPageState();
}

class _KrishnaChatPageState extends State<KrishnaChatPage> {
  final List<Message> _messages = [];
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  bool _isTyping = false;

  void _sendMessage() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _messages.add(Message(text: text, isUser: true));
      _isTyping = true;
    });

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
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  Widget _buildMessage(Message message) {
    return Align(
      alignment: message.isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 4, horizontal: 12),
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: message.isUser ? Colors.blueAccent : Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          message.text,
          style: TextStyle(
            color: message.isUser ? Colors.white : Colors.black87,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  Widget _buildChatInput() {
    return SafeArea(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _controller,
                textInputAction: TextInputAction.send,
                onSubmitted: (_) => _sendMessage(),
                decoration: InputDecoration(
                  hintText: "Open your heart to Krishna...",
                  fillColor: Colors.white,
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  contentPadding: EdgeInsets.symmetric(horizontal: 16),
                ),
              ),
            ),
            SizedBox(width: 8),
            IconButton(
              icon: Icon(Icons.send),
              color: Colors.blueAccent,
              onPressed: _sendMessage,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Chat with Krishna"),
        backgroundColor: Colors.blue.shade800,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              itemCount: _messages.length,
              itemBuilder: (context, index) => _buildMessage(_messages[index]),
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
                  CircleAvatar(
                    backgroundColor: Colors.blue.shade100,
                    child: Text("K"),
                  ),
                  SizedBox(width: 12),
                  Text(
                    "Krishna is typing...",
                    style: TextStyle(fontStyle: FontStyle.italic),
                  ),
                ],
              ),
            ),

          _buildChatInput(),
        ],
      ),
    );
  }
}
