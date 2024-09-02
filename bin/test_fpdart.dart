import 'dart:convert';

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
      dictUrl['200']!,
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

  print(Option
  .fromEither(either)
  .flatMap((list){
    print("head:${list.head.getOrElse(()=>"")}");
    return Option.of(list);
  })
  .flatMap((list){
    print("len : ${list.length}");
    return Option.of(list.length);
  })
  .flatMap((len){
    final check  = (len>100)? "Больше 100!": "Меньше 100!";
    return Option.of(check);
  })
  .getOrElse((){
    return "error";
  })
  );
}
