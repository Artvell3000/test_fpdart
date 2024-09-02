import 'dart:convert';

import 'package:fpdart/fpdart.dart';
import 'package:dio/dio.dart';

final dio = Dio();

const Map<String, String> dictUrl = {
  '404':'http://universities.hipolabs.com/sarch',
  '200':'http://universities.hipolabs.com/search'
};

Future<Response<dynamic>> requestUniver() async{
  return dio.get(
      dictUrl['200']!,
        queryParameters: {
          'country':'Canada'
          }
    );
}

TaskOption<Response<dynamic>> request(){
  return TaskOption.tryCatch(requestUniver);
}

Future<Option<List<String>>> parse()async {
  final json = await request().run();

  return json.map((response){
    final List<String> returnList = [];
    final data = response.data as List<dynamic>;

    for(int i=0;i<data.length;i++){
          final univer = data[i] as Map<String,dynamic>;
          returnList.add(univer['name']);
    }

    return returnList;
  });
}

void main() async{
  final option = await parse();

  print(option
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
