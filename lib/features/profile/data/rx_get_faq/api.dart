import 'package:dio/dio.dart';
import '../../../../networks/dio/dio.dart';
import '../../../../networks/endpoints.dart';
import '../../../../networks/exception_handler/data_source.dart';
import '../../model/faq_model.dart';

final class GetFaqApi {
  static final GetFaqApi _singleton = GetFaqApi._internal();
  GetFaqApi._internal();
  static GetFaqApi get instance => _singleton;

  Future<FaqModel> getFaqData() async {
    try {
      Response response = await getHttp(Endpoints.faqData());
      if (response.statusCode == 200 || response.statusCode == 201) {
        return FaqModel.fromJson(response.data);
      } else {
        throw DataSource.DEFAULT.getFailure();
      }
    } catch (error) {
      rethrow;
    }
  }
}
