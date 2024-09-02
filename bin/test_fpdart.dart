import 'package:fpdart/fpdart.dart';
import 'package:dio/dio.dart';

final dio = Dio();

const Map<String, String> dictUrl = {
  '404':'http://universities.hipolabs.com/sarch',
  '200':'http://universities.hipolabs.com/search'
};

Future<Either<String, List<String>>> request() async {
  Either<String, List<String>> returnEither;

  try{
    final response = await dio.get(
      dictUrl['404']!,
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

  final option = Option.fromEither(either);

  final optionLength = option.flatMap((l){
    return Option.of(l.length);
  });

  final Option<String> optionCheck = optionLength.map((len){
    if(len>100)return "Больше 100!";
    return "Меньше 100!";
  });

  print(optionCheck.getOrElse(()=>"error"));
}
