import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../theme/app_colors.dart';
import '../../models/chat_message.dart';
import '../../providers/app_provider.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _ctrl = TextEditingController();
  final _scroll = ScrollController();

  static const _suggestions = [
    'Dark spots help',
    'Oily skin tips',
    'Dry season routine',
    'Best ingredients',
    'Acne treatment',
    'Sensitive skin',
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<AppProvider>();
      if (provider.messages.isEmpty) {
        provider.sendUserMessage('Hello');
      }
    });
  }

  void _send(String text) {
    final trimmed = text.trim();
    if (trimmed.isEmpty) return;
    _ctrl.clear();
    context.read<AppProvider>().sendUserMessage(trimmed);
    Future.delayed(const Duration(milliseconds: 100), _scrollToBottom);
    Future.delayed(const Duration(milliseconds: 1000), _scrollToBottom);
  }

  void _scrollToBottom() {
    if (_scroll.hasClients) {
      _scroll.animateTo(
        _scroll.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    _scroll.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppProvider>();
    final msgs = provider.messages;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: AppColors.gold.withAlpha(50),
                shape: BoxShape.circle,
              ),
              child: const Center(
                  child: Text('🤖', style: TextStyle(fontSize: 18))),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('AfriGlow AI',
                    style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.white)),
                Text('Skincare Assistant',
                    style: GoogleFonts.poppins(
                        fontSize: 11,
                        color: Colors.white.withAlpha(180))),
              ],
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // Messages
          Expanded(
            child: msgs.isEmpty
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text('🤖',
                            style: TextStyle(fontSize: 60)),
                        const SizedBox(height: 12),
                        Text('Ask me anything about\nAfrican skincare!',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                                color: AppColors.warmBrown,
                                fontSize: 16,
                                height: 1.4)),
                      ],
                    ),
                  )
                : ListView.builder(
                    controller: _scroll,
                    padding: const EdgeInsets.all(16),
                    itemCount: msgs.length,
                    itemBuilder: (_, i) =>
                        _Bubble(msg: msgs[i], onQuickReply: _send),
                  ),
          ),

          // Quick suggestions
          if (msgs.length <= 2)
            Container(
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 4),
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _suggestions.map((s) {
                  return GestureDetector(
                    onTap: () => _send(s),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 7),
                      decoration: BoxDecoration(
                        color: AppColors.deepGreen.withAlpha(12),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                            color: AppColors.deepGreen.withAlpha(50)),
                      ),
                      child: Text(s,
                          style: GoogleFonts.poppins(
                              fontSize: 12,
                              color: AppColors.deepGreen,
                              fontWeight: FontWeight.w600)),
                    ),
                  );
                }).toList(),
              ),
            ),

          // Input
          Container(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkSurface : Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(15),
                  blurRadius: 8,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _ctrl,
                    maxLines: null,
                    textInputAction: TextInputAction.send,
                    onSubmitted: _send,
                    decoration: InputDecoration(
                      hintText:
                          'Ask about African skincare...',
                      hintStyle:
                          GoogleFonts.poppins(fontSize: 14),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                    ),
                    style: GoogleFonts.poppins(fontSize: 14),
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: () => _send(_ctrl.text),
                  child: Container(
                    width: 44,
                    height: 44,
                    decoration: const BoxDecoration(
                      color: AppColors.deepGreen,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.send,
                        color: Colors.white, size: 20),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Bubble extends StatelessWidget {
  final ChatMessage msg;
  final void Function(String) onQuickReply;

  const _Bubble({required this.msg, required this.onQuickReply});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Column(
      crossAxisAlignment:
          msg.isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: msg.isUser
              ? MainAxisAlignment.end
              : MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            if (!msg.isUser) ...[
              Container(
                width: 32,
                height: 32,
                margin: const EdgeInsets.only(right: 8, bottom: 4),
                decoration: BoxDecoration(
                  color: AppColors.deepGreen,
                  shape: BoxShape.circle,
                ),
                child: const Center(
                    child:
                        Text('🤖', style: TextStyle(fontSize: 16))),
              ),
            ],
            Flexible(
              child: Container(
                margin: const EdgeInsets.only(bottom: 4),
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 12),
                constraints: BoxConstraints(
                  maxWidth:
                      MediaQuery.of(context).size.width * 0.75,
                ),
                decoration: BoxDecoration(
                  color: msg.isUser
                      ? AppColors.deepGreen
                      : (isDark
                          ? AppColors.darkCard
                          : Colors.white),
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(18),
                    topRight: const Radius.circular(18),
                    bottomLeft: Radius.circular(msg.isUser ? 18 : 4),
                    bottomRight:
                        Radius.circular(msg.isUser ? 4 : 18),
                  ),
                  border: msg.isUser
                      ? null
                      : Border.all(
                          color: const Color(0xFFE8E0D8)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(12),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Text(
                  msg.text,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    height: 1.6,
                    color: msg.isUser
                        ? Colors.white
                        : Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ),
            ),
          ],
        ),

        // Quick replies
        if (!msg.isUser && msg.quickReplies != null)
          Padding(
            padding: const EdgeInsets.only(left: 40, bottom: 8),
            child: Wrap(
              spacing: 8,
              runSpacing: 4,
              children: msg.quickReplies!.map((r) {
                return GestureDetector(
                  onTap: () => onQuickReply(r),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.deepGreen.withAlpha(12),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                          color: AppColors.deepGreen.withAlpha(50)),
                    ),
                    child: Text(r,
                        style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: AppColors.deepGreen,
                            fontWeight: FontWeight.w600)),
                  ),
                );
              }).toList(),
            ),
          ),
        const SizedBox(height: 6),
      ],
    );
  }
}
