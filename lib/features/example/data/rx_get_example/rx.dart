// import 'dart:developer';
// import 'package:dio/dio.dart';
// import 'package:rxdart/rxdart.dart';
// import '../../../../../networks/rx_base.dart';
// import '../../../../common_widgets/custom_toast.dart';
// import 'api.dart';
// import '../../../../helpers/error_message_Handler.dart';

// final class GetExampleRx extends RxResponseInt {
//   final api = GetExampleApi.instance;

//   GetExampleRx({required super.empty, required super.dataFetcher});

//   ValueStream get fileData => dataFetcher.stream;

//   Future<bool> featchExample() async {
//     try {

// Clear previous data before making new API call if needed
// dataFetcher.sink.add(empty);
//       Map data = await api.getExampleData();
//        return await handleSuccessWithReturn(data);
//     } catch (error) {
//       return await handleErrorWithReturn(error);
//     }
//   }

//   @override
//   handleSuccessWithReturn(data) async {
//dataFetcher.sink.add(data);
//     return true;
//   }

// @override
//   handleErrorWithReturn(error) {
//     ErrorMessageHandler.showErrorToast(error); // Just one call!
//     return false;
//   }
// }
