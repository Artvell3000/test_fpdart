import 'package:fpdart/fpdart.dart';
import 'package:dio/dio.dart';

final dio = Dio();

// ignore: non_constant_identifier_names
final URL_ERROR_404 = 'http://universities.hipolabs.com/sarch';
// ignore: non_constant_identifier_names
final URL_CORRECT = 'http://universities.hipolabs.com/search';

Future<Either<String, List<String>>> request() async {
  Either<String, List<String>> returnEither;

  try{
    final response = await dio.get(
      URL_ERROR_404,
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

    returnEither = Right(returnList);
  } catch(e,s){
    returnEither = Left('$e\n$s');
  }

  return returnEither;
}

void main() async{
  final either = await request();
  
  print(
    either.getOrElse((s){
      print(s);
      return [];
    })
  );
}
