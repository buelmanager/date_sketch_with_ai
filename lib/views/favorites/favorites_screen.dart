// lib/views/favorites/favorites_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/date_place.dart';
import '../../providers/provider_setup.dart';
import '../../providers/view_model_providers.dart';
import '../../utils/theme.dart';
import '../common/app_bottom_navigation.dart';
import '../place/place_detail_screen.dart';

class FavoritesScreen extends ConsumerWidget {
  const FavoritesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homeState = ref.watch(homeViewModelProvider);
    final favoritesState = ref.watch(favoritesViewModelProvider);

    // 즐겨찾기한 장소 가져오기
    List<DatePlace> favoritePlaces = [];

    // 실제 데이터가 있으면 사용
    if (homeState.popularPlaces != null && homeState.popularPlaces!.isNotEmpty) {
      favoritePlaces = homeState.popularPlaces!
          .where((place) => favoritesState.favoritePlaceIds.contains(place.id))
          .toList();
    }

    // 실제 데이터가 없거나 비어있으면 더미 데이터 사용
    if (favoritePlaces.isEmpty) {
      favoritePlaces = _getDummyFavoritePlaces();
    }

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text(
          '찜한 장소',
          style: TextStyle(
            color: AppTheme.textColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: favoritesState.isLoading
          ? const Center(child: CircularProgressIndicator(color: AppTheme.primaryColor))
          : favoritePlaces.isEmpty
          ? _buildEmptyState()
          : _buildFavoritesList(favoritePlaces, ref, context),
      bottomNavigationBar: const AppBottomNavigation(),
    );
  }

  // 더미 데이터 생성 함수
  List<DatePlace> _getDummyFavoritePlaces() {
    return [
      DatePlace(
        id: 'p1',
        name: '로맨틱 가든 카페',
        category: '카페',
        imageUrl: 'https://picsum.photos/id/225/300/200',
        rating: 4.7,
        address: '서울시 강남구 압구정로 123',
        description: '아름다운 정원이 있는 분위기 좋은 카페입니다. 연인과 함께 방문하기 좋은 장소예요.',
        tags: ['카페', '데이트', '정원'],
        reviewCount: 142,
        latitude: 37.5242,
        longitude: 127.0386,
      ),
      DatePlace(
        id: 'p2',
        name: '스카이뷰 레스토랑',
        category: '레스토랑',
        imageUrl: 'https://picsum.photos/id/429/300/200',
        rating: 4.5,
        address: '서울시 중구 을지로 234',
        description: '도시의 멋진 전망을 즐기며 식사할 수 있는 고급 레스토랑입니다.',
        tags: ['레스토랑', '야경', '고급'],
        reviewCount: 89,
        latitude: 37.5662,
        longitude: 126.9784,
      ),
      DatePlace(
        id: 'p3',
        name: '시네마 파라다이스',
        category: '영화관',
        imageUrl: 'https://picsum.photos/id/335/300/200',
        rating: 4.8,
        address: '서울시 서초구 강남대로 555',
        description: '2인 소파석이 있는 프리미엄 영화관으로 데이트하기 좋은 곳입니다.',
        tags: ['영화관', '데이트', '프라이빗'],
        reviewCount: 215,
        latitude: 37.5037,
        longitude: 127.0246,
      ),
      DatePlace(
        id: 'p4',
        name: '한강 선셋 파크',
        category: '공원',
        imageUrl: 'https://picsum.photos/id/134/300/200',
        rating: 4.6,
        address: '서울시 용산구 이촌로 300',
        description: '한강변에서 아름다운 석양을 볼 수 있는 공원입니다. 산책하기 좋아요.',
        tags: ['공원', '산책', '석양'],
        reviewCount: 176,
        latitude: 37.5171,
        longitude: 126.9369,
      ),
      DatePlace(
        id: 'p5',
        name: '플라워 아트 갤러리',
        category: '전시',
        imageUrl: 'https://picsum.photos/id/106/300/200',
        rating: 4.4,
        address: '서울시 종로구 인사동길 44',
        description: '아름다운 꽃 예술 작품을 감상할 수 있는 갤러리입니다.',
        tags: ['갤러리', '전시', '예술'],
        reviewCount: 64,
        latitude: 37.5743,
        longitude: 126.9873,
      ),
    ];
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.favorite_border, size: 80, color: Colors.grey[300]),
          const SizedBox(height: 24),
          Text(
            '아직 찜한 장소가 없습니다',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '마음에 드는 장소를 찾아 하트를 눌러보세요',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[500],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildFavoritesList(List<DatePlace> places, WidgetRef ref, BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: places.length,
      itemBuilder: (context, index) {
        final place = places[index];
        return GestureDetector(
          onTap: () {
            // 장소 상세 페이지로 이동
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PlaceDetailScreen(place: place.toPlace()),
              ),
            );
          },
          child: Card(
            margin: const EdgeInsets.only(bottom: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 2,
            child: Row(
              children: [
                // 이미지 부분
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    bottomLeft: Radius.circular(16),
                  ),
                  child: Image.network(
                    place.imageUrl,
                    width: 120,
                    height: 120,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: 120,
                        height: 120,
                        color: Colors.grey[300],
                        child: const Icon(
                          Icons.image_not_supported,
                          size: 40,
                          color: Colors.white,
                        ),
                      );
                    },
                  ),
                ),

                // 내용 부분
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // 장소 이름
                            Expanded(
                              child: Text(
                                place.name,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.textColor,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),

                            // 찜 아이콘
                            GestureDetector(
                              onTap: () {
                                ref.read(favoritesViewModelProvider.notifier).toggleFavorite(place.id);
                              },
                              child: const Icon(
                                Icons.favorite,
                                color: AppTheme.primaryColor,
                                size: 24,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),

                        // 카테고리
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppTheme.secondaryColor.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            place.category,
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppTheme.primaryColor,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),

                        // 주소
                        Row(
                          children: [
                            Icon(Icons.location_on, size: 14, color: Colors.grey[600]),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                place.address,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),

                        // 평점
                        Row(
                          children: [
                            const Icon(Icons.star, size: 16, color: Colors.amber),
                            const SizedBox(width: 4),
                            Text(
                              place.rating.toString(),
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              '(${place.reviewCount})',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}