import 'package:fpdart/fpdart.dart';
import 'package:dio/dio.dart';

final dio = Dio();

// ignore: non_constant_identifier_names
final URL_ERROR_404 = 'http://universities.hipolabs.com/sarch';
// ignore: non_constant_identifier_names
final URL_CORRECT = 'http://universities.hipolabs.com/search';

TaskEither<String, List<String>> request(){
  return TaskEither.tryCatch(() async {
    final Response response = await dio.get(
      URL_CORRECT,
        queryParameters: {
          'country':'Canada'
          }
    );

    final List<String> returnList = [];
    final data = response.data as List<dynamic>;

    for(int i=0;i<data.length;i++){
          final univer = data[i] as Map<String,dynamic>;
          returnList.add(univer['name']);
    }

    return returnList;
  },
  (e,s){
    return '$e\n$s';
  });
}

void main() async{
  final fetch = await request().run();

  print(fetch.getOrElse((str){
    print(str);
    return [];
  }));
}
