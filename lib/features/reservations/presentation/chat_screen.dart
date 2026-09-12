import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../common_widgets/app_network_image.dart';
import '../../../constants/text_font_style.dart';
import '../../../gen/assets.gen.dart';
import '../../../gen/colors.gen.dart';
import '../../../helpers/ui_helpers.dart';
import '../../../networks/api_acess.dart';
import '../model/chat_message_model.dart';
import '../../../constants/app_constants.dart';
import '../../../helpers/di.dart';
import '../../../helpers/time_converter.dart';
import '../../../helpers/websocket_service.dart';
import '../../../helpers/notification_service.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _msgController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  
  bool _isInitialized = false;
  String barberName = "Barbier";
  String barberImage = "";
  String receiverId = "";
  String conversationId = "";
  int myId = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized) {
      final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
      barberName = args?['barber_name'] as String? ?? "Barbier";
      barberImage = args?['barber_image'] as String? ?? "";
      
      // Setup chat IDs
      receiverId = args?['receiver_id']?.toString() ?? "";
      myId = appData.read(kKeyUserID) ?? 0;
      
      if (receiverId.isEmpty || myId == 0) {
        // Fallback or error handling
        conversationId = "invalid-conversation";
      } else {
        // Here we build the conversation ID (assuming same logic as backend)
        conversationId = "$myId-$receiverId"; 
      }
      
      getConversationRxObj.fetchConversation(conversationId);
      
      // Connect real-time websocket listener
      WebSocketService.instance.connectAndSubscribe(conversationId);
      
      // Mark this conversation as active to suppress local push notifications
      NotificationService.activeConversationId = conversationId;

      _isInitialized = true;
    }
  }

  @override
  void dispose() {
    _msgController.dispose();
    _scrollController.dispose();
    WebSocketService.instance.disconnect();
    NotificationService.activeConversationId = null;
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  void _sendMessage() async {
    final text = _msgController.text.trim();
    if (text.isEmpty) return;
    
    _msgController.clear();
    
    // Send to server in background and get the real message back
    try {
      final response = await chatSendRxObj.api.sendChatMessage(
        receiverId: receiverId, 
        message: text
      );
      
      // Inject real message to stream instantly
      if (response['data'] != null) {
        final currentRxState = getConversationRxObj.fileData.value;
        if (currentRxState != null && currentRxState['data'] != null) {
          List messages = List.from(currentRxState['data']);
          final newMsg = ChatMessageModel.fromJson(response['data']);
          
          if (!messages.any((m) => m['id'] == newMsg.id)) {
            messages.add(response['data']);
            currentRxState['data'] = messages;
            getConversationRxObj.dataFetcher.sink.add(currentRxState);
            WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
          }
        }
      }
    } catch (e) {
      // Handle error implicitly
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cFFFFFF,
      appBar: _buildAppBar(context),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream: getConversationRxObj.fileData,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting && !snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text("Erreur de chargement", style: TextStyle(color: Colors.red, fontSize: 14.sp)));
                }

                final data = snapshot.data as Map?;
                if (data == null || data['data'] == null) {
                  return Center(child: Text("Aucun message", style: TextStyle(fontSize: 14.sp, color: AppColors.c8A8A8A)));
                }

                final messagesList = data['data'] as List;
                final messages = messagesList.map((m) => ChatMessageModel.fromJson(m)).toList();

                WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());

                return ListView.builder(
                  controller: _scrollController,
                  padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final msg = messages[index];
                    final isMe = msg.senderId == myId;
                    
                    final String timeStr = TimeConverter.formatTo24HourTime(msg.createdAt);
                    
                    return Padding(
                      padding: EdgeInsets.only(bottom: 20.h),
                      child: _buildMessage(
                        message: msg.message ?? "",
                        time: timeStr,
                        isMe: isMe,
                        isRead: msg.isRead == 1,
                      ),
                    );
                  },
                );
              },
            ),
          ),
          _buildInputBar(),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.cFFFFFF,
      elevation: 0,
      centerTitle: true,
      leading: Padding(
        padding: EdgeInsets.only(left: 20.w),
        child: IconButton(
          onPressed: () => Navigator.pop(context),
          padding: EdgeInsets.zero,
          icon: Assets.icons.arrowBackBlack.image(
            width: 24.r,
            height: 24.r,
            fit: BoxFit.contain,
          ),
        ),
      ),
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (barberImage.isNotEmpty)
            AppNetworkImage(
              imageUrl: barberImage,
              width: 40.r,
              height: 40.r,
              isProfilePicture: true,
            )
          else
            Container(
              width: 40.r,
              height: 40.r,
              decoration: const BoxDecoration(
                color: AppColors.cE3E3E3,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.person, color: AppColors.c8A8A8A, size: 24.r),
            ),
          UIHelper.horizontalSpace(12.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                barberName,
                style: TextFontStyle.textStyle16c191919Inter600
                    .copyWith(fontSize: 18.sp),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMessage({
    required String message,
    required String time,
    required bool isMe,
    bool isRead = false,
  }) {
    return Column(
      crossAxisAlignment:
          isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Container(
          constraints: BoxConstraints(maxWidth: 0.7.sw),
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          decoration: BoxDecoration(
            color: isMe ? AppColors.c1B1B1B : AppColors.cF2F2F2,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16.r),
              topRight: Radius.circular(16.r),
              bottomLeft: isMe ? Radius.circular(16.r) : Radius.zero,
              bottomRight: isMe ? Radius.zero : Radius.circular(16.r),
            ),
          ),
          child: Text(
            message,
            style: TextFontStyle.textStyle14c191919Inter500.copyWith(
              color: isMe ? AppColors.cFFFFFF : AppColors.c191919,
              fontSize: 15.sp,
            ),
          ),
        ),
        UIHelper.verticalSpace(6.h),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              time,
              style: TextFontStyle.textStyle12c9B9B9BInter400
                  .copyWith(fontSize: 11.sp),
            ),
            if (isMe) ...[
              UIHelper.horizontalSpace(4.w),
              Icon(
                isRead ? Icons.done_all : Icons.done,
                size: 14.sp,
                color: AppColors.cA5A5A5,
              ),
            ]
          ],
        ),
      ],
    );
  }

  Widget _buildInputBar() {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.cFFFFFF,
        border: Border(top: BorderSide(color: AppColors.cF2F2F2)),
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
          child: Container(
            height: 56.h,
            padding: EdgeInsets.only(left: 16.w, right: 6.w),
            decoration: BoxDecoration(
              color: AppColors.cE3E3E3,
              borderRadius: BorderRadius.circular(28.r),
            ),
            child: Row(
              children: [
                Assets.icons.attachFileGrey.image(width: 24.w, height: 24.w),
                UIHelper.horizontalSpace(12.w),
                Expanded(
                  child: TextField(
                    controller: _msgController,
                    style: TextFontStyle.textStyle14c191919Inter500,
                    decoration: InputDecoration(
                      hintText: "Écrire un message...",
                      hintStyle:
                          TextFontStyle.textStyle14c8A8A8AInter400.copyWith(
                        color: AppColors.c8A8A8A,
                      ),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: _sendMessage,
                  child: Container(
                    width: 44.r,
                    height: 44.r,
                    decoration: const BoxDecoration(
                      color: AppColors.c1B1B1B,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Assets.icons.sendOutlinedWhite
                          .image(width: 20.w, height: 20.w),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
