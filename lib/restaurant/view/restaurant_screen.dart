import 'package:actual/common/const/data.dart';
import 'package:actual/common/dio/dio.dart';
import 'package:actual/restaurant/component/restaurant_card.dart';
import 'package:actual/restaurant/model/restaurant_model.dart';
import 'package:actual/restaurant/repository/restaurant_repository.dart';
import 'package:actual/restaurant/view/restaurant_detail_screen.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class RestaurantScreen extends StatelessWidget {
  const RestaurantScreen({super.key});

  Future<List<RestaurantModel>> paginateRestaurant() async {
    final dio = Dio();

    // token 체크를 interceptor 에 위임
    dio.interceptors.add(
      CustomInterceptor(storage: storage),
    );

    // jsonserializable && retrofit 으로 json model binding
    final resp =
        await RestaurantRepository(dio, baseUrl: 'http://$ip/restaurant/')
            .paginate();

    // final accessToken = await storage.read(key: ACCESS_TOKEN_KEY);

    // final resp = await dio.get(
    //   'http://$ip/restaurant',
    //   options: Options(headers: {'authorization': 'Bearer $accessToken'}),
    // );

    return resp.data;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16.0,
          ),
          child: FutureBuilder<List<RestaurantModel>>(
            future: paginateRestaurant(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              return ListView.separated(
                itemCount: snapshot.data!.length,
                itemBuilder: (_, index) {
                  final pItem = snapshot.data![index];
                  // final pItem = RestaurantModel.fromJson(item);

                  return GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (_) => RestaurantDetailScreen(
                                id: pItem.id,
                              )));
                    },
                    child: RestaurantCard.fromModel(
                      model: pItem,
                    ),
                  );
                },
                separatorBuilder: (context, index) {
                  return const SizedBox(height: 16.0);
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
