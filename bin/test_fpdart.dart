import 'package:fpdart/fpdart.dart';
import 'package:dio/dio.dart';

final dio = Dio();

// ignore: non_constant_identifier_names
final URL_ERROR_404 = 'http://universities.hipolabs.com/sarch';
// ignore: non_constant_identifier_names
final URL_CORRECT = 'http://universities.hipolabs.com/search';

class Dict{
  final u404 = 'http://universities.hipolabs.com/sarch';
  final u200 = 'http://universities.hipolabs.com/search';
}

ReaderTaskEither<Dict, String, List<String>> requestWithReader() => ReaderTaskEither((dict){
  return TaskEither<String, List<String>>.tryCatch(() async {
    final Response response = await dio.get(
      dict.u404,
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
  }).run();
});

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
  final fetch = requestWithReader();

  final task = fetch.getOrElse((v){
    return [];
  });

  final result = await task.run(Dict());

  print(result);
}
