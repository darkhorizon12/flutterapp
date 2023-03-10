import 'package:actual/common/model/cursor_pagination_model.dart';
import 'package:actual/common/model/pagination_params.dart';
import 'package:actual/restaurant/model/restaurant_model.dart';
import 'package:actual/restaurant/repository/restaurant_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final restaurantDetailProvider =
    Provider.family<RestaurantModel?, String>((ref, id) {
  final state = ref.watch(restaurantProvider);

  if (state is! CursorPagination) {
    return null;
  }

  return state.data.firstWhere((element) => element.id == id);
});

final restaurantProvider =
    StateNotifierProvider<RestaurantStateNotifier, CursorPaginationBase>((ref) {
  final repository = ref.watch(restaurantRepositoryProvider);
  final notifier = RestaurantStateNotifier(repository: repository);

  return notifier;
});

class RestaurantStateNotifier extends StateNotifier<CursorPaginationBase> {
  final RestaurantRepository repository;

  RestaurantStateNotifier({required this.repository})
      : super(CursorPaginationLoading()) {
    paginate();
  }

  // RestaurantStateNotifier({
  //   required this.repository,
  // }) : super([]);

  Future<void> paginate({
    int fetchCount = 20,
    // 추가데이터 페치 여부. true: 추가 데이터 페치, false: 새로고침
    bool fetchMore = false,
    // 강제 재로딩. true: CursorPaginationLoading(),
    bool forceRefetch = false,
  }) async {
    try {
      // final resp = await repository.paginate();
      // state = resp;
      // State의 5가지 가능성
      // 1) CursorPagination: 정상적인 데이터가 있는 상태
      // 2) CursorPaginationLoading: 데이터가 로딩중인 상태(현재 캐시 없음)
      // 3) CursorPaginationError: 에러 발생한 상태
      // 4) CursorPaginationRefetching: 첫번째 페이지부터 재요청 상태
      // 5) CursorPaginationFetchMore: 추가 데이터를 paginagtion 요청한 상태

      // * 바로 반환하는 상태
      // 1) hasMore = false (기존 상태에서 이미 다음 데이터가 없다는 요소)
      // 2) 로딩중: fetchMore == true
      //           fetchMore == false: 새로 고침의 의도가 있을 수 있다.
      if (state is CursorPagination && !forceRefetch) {
        final pState = state as CursorPagination;
        if (!pState.meta.hasMore) {
          return;
        }
      }

      final isLoading = state is CursorPaginationLoading;
      final isRefetching = state is CursorPaginationRefetching;
      final isFetchingMore = state is CursorPaginationFetchingMore;

      if (fetchMore && (isLoading || isRefetching || isFetchingMore)) {
        return;
      }

      // PaginationParams 생성
      PaginationParams paginationParams = PaginationParams(
        count: fetchCount,
      );

      // fetchMore: 데이터를 추가로 가져오는 상황
      if (fetchMore) {
        final pState = state as CursorPagination;

        state = CursorPaginationFetchingMore(
          meta: pState.meta,
          data: pState.data,
        );

        paginationParams = paginationParams.copyWith(
          after: pState.data.last.id,
        );
      } else {
        // 데이터를 처음부터 가져오는 상황
        // 만약에 데이터가 있는 상황이라면 기존 데이터에 Fetch 진행
        if (state is CursorPagination && !forceRefetch) {
          final pState = state as CursorPagination;

          state = CursorPaginationRefetching(
            meta: pState.meta,
            data: pState.data,
          );
          // 기존 데이터를 유지할 필요가 없는 상황
        } else {
          state = CursorPaginationLoading();
        }
      }

      final resp = await repository.paginate(
        paginationParams: paginationParams,
      );

      if (state is CursorPaginationFetchingMore) {
        final pState = state as CursorPaginationFetchingMore;

        // 기존 데이터에 새로운 데이터 추가
        state = resp.copyWith(
          data: [
            ...pState.data,
            ...resp.data,
          ],
        );
      } else {
        state = resp;
      }
    } catch (e) {
      state = CursorPaginationError(message: '데이터를 가져오지 못했습니다.');
    }
  }

  getDetail({
    required String id,
  }) async {
    // 데이터가 없는 상태라면 (CursorPagination이 아니라면), 데이터 조회 시도
    if (state is! CursorPagination) {
      await this.paginate();
    }

    // state가 CursorPagination이 아닐 때 그냥 리턴(위 시도를 했는데도 데이터가 없을 경우)
    if (state is! CursorPagination) {
      return;
    }

    final pState = state as CursorPagination;
    final resp = await repository.getRestaurantDetail(id: id);

    state = pState.copyWith(
      data: pState.data.map<RestaurantModel>((e) => e.id == id ? resp : e).toList(),
    );
  }
}
