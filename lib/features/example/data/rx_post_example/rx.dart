// import 'dart:developer';
// import 'package:dio/dio.dart';
// import 'package:rxdart/rxdart.dart';
// import '../../../../helpers/error_message_Handler.dart';
// import '../../../../common_widgets/custom_toast.dart';
// import '../../../../networks/rx_base.dart';
// import 'api.dart';

// final class PostLoginRx extends RxResponseInt {
//   final api = PostLoginApi.instance;
//   String message = "Something went wrong";
//   PostLoginRx({required super.empty, required super.dataFetcher});

//   ValueStream get getPostLoginRes => dataFetcher.stream;

//   Future<bool> postLogin() async {
//     try {
//       Map<String, dynamic> data = {
//         // "email": email,

//       };
//       Map resdata = await api.postLogIn(data);
//       return await handleSuccessWithReturn(resdata);
//     } catch (error) {
//       return await handleErrorWithReturn(error);
//     }
//   }

// @override
//   handleErrorWithReturn(error) {
//     ErrorMessageHandler.showErrorToast(error); // Just one call!
//     return false;
//   }
// }
