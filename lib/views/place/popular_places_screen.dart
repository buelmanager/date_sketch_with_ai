import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/date_place.dart';
import '../../models/place.dart';
import '../../providers/provider_setup.dart';
import '../../providers/view_model_providers.dart';
import '../../utils/theme.dart';
import 'map_view_screen.dart';
import 'place_detail_screen.dart';

enum SortOption { popularity, rating, distance, priceAsc, priceDesc }

class PopularPlacesScreen extends ConsumerStatefulWidget {
  final String title;
  final String? category;

  const PopularPlacesScreen({
    Key? key,
    required this.title,
    this.category,
  }) : super(key: key);

  @override
  ConsumerState<PopularPlacesScreen> createState() => _PopularPlacesScreenState();
}

class _PopularPlacesScreenState extends ConsumerState<PopularPlacesScreen> {
  String? _selectedSubcategory;
  SortOption _currentSortOption = SortOption.popularity;
  RangeValues _priceRange = const RangeValues(0, 100000);
  bool _isMapView = false;

  @override
  Widget build(BuildContext context) {
    final homeState = ref.watch(homeViewModelProvider);

    // 필터링된 장소 목록 (카테고리별 필터링)
    List<DatePlace> filteredPlaces = [];

    if (homeState.popularPlaces != null) {
      filteredPlaces = widget.category != null
          ? homeState.popularPlaces!
          .where((place) => place.category == widget.category)
          .toList()
          : homeState.popularPlaces!;
    }

    // 서브카테고리 필터링
    if (_selectedSubcategory != null && _selectedSubcategory!.isNotEmpty) {
      filteredPlaces = filteredPlaces
          .where((place) => place.tags.contains(_selectedSubcategory))
          .toList();
    }

    // 가격 범위 필터링 (메타데이터에 price가 있다고 가정)
    filteredPlaces = filteredPlaces.where((place) {
      final price = place.metadata?['price'] as int? ?? 0;
      return price >= _priceRange.start && price <= _priceRange.end;
    }).toList();

    // 정렬 적용
    _applySorting(filteredPlaces);

    // 카테고리가 있는데 해당 장소가 없으면 더미 데이터 추가
    if (widget.category != null && filteredPlaces.isEmpty) {
      filteredPlaces = _getDummyPlacesByCategory(widget.category!);
    }

    // 데이터가 없으면 기본 더미 데이터 추가
    if (filteredPlaces.isEmpty) {
      filteredPlaces = _getDummyPlaces();
    }

    // 현재 카테고리에 맞는 서브카테고리 리스트 생성
    final List<String> subcategories = _getSubcategories(widget.category);

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          widget.title,
          style: const TextStyle(
            color: AppTheme.textColor,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 0,
        iconTheme: const IconThemeData(color: AppTheme.textColor),
        actions: [
          // 정렬 버튼
          IconButton(
            icon: const Icon(Icons.sort),
            onPressed: () => _showSortDialog(),
          ),
          // 필터 버튼
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () => _showFilterDialog(subcategories),
          ),
          // 지도/리스트 뷰 전환 버튼
          IconButton(
            icon: Icon(_isMapView ? Icons.view_list : Icons.map),
            onPressed: () {
              setState(() {
                _isMapView = !_isMapView;
              });
            },
          ),
        ],
      ),
      body: homeState.isLoading
          ? const Center(
        child: CircularProgressIndicator(
          color: AppTheme.primaryColor,
        ),
      )
          : Column(
        children: [
          // 카테고리 표시
          if (widget.category != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: AppTheme.primaryColor,
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          widget.category!,
                          style: const TextStyle(
                            fontSize: 14,
                            color: AppTheme.primaryColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Icon(
                          _getCategoryIcon(widget.category!),
                          size: 16,
                          color: AppTheme.primaryColor,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '${filteredPlaces.length}개의 장소',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),

          // 서브카테고리 스크롤 리스트
          if (subcategories.isNotEmpty)
            Container(
              height: 50,
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: subcategories.length,
                itemBuilder: (context, index) {
                  final subcategory = subcategories[index];
                  final isSelected = subcategory == _selectedSubcategory;

                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(subcategory),
                      selected: isSelected,
                      onSelected: (selected) {
                        setState(() {
                          _selectedSubcategory = selected ? subcategory : null;
                        });
                      },
                      backgroundColor: Colors.white,
                      selectedColor: AppTheme.primaryColor.withOpacity(0.2),
                      labelStyle: TextStyle(
                        color: isSelected ? AppTheme.primaryColor : Colors.grey[700],
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  );
                },
              ),
            ),

          // 적용된 정렬/필터 표시
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Row(
              children: [
                Text(
                  '정렬: ${_getSortName(_currentSortOption)}',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
                if (_selectedSubcategory != null) ...[
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          _selectedSubcategory!,
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppTheme.primaryColor,
                          ),
                        ),
                        const SizedBox(width: 4),
                        InkWell(
                          onTap: () {
                            setState(() {
                              _selectedSubcategory = null;
                            });
                          },
                          child: const Icon(
                            Icons.close,
                            size: 12,
                            color: AppTheme.primaryColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),

          // 지도 또는 리스트 뷰
          Expanded(
            child: _isMapView
                ? MapViewScreen(places: filteredPlaces)
                : _buildPlacesList(filteredPlaces),
          ),
        ],
      ),
    );
  }

  Widget _buildPlacesList(List<DatePlace> places) {
    return RefreshIndicator(
      onRefresh: () {
        return ref.read(homeViewModelProvider.notifier).refreshData();
      },
      color: AppTheme.primaryColor,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: places.length,
        itemBuilder: (context, index) {
          final place = places[index];
          return _buildPlaceCard(context, place, ref);
        },
      ),
    );
  }

  Widget _buildPlaceCard(BuildContext context, DatePlace place, WidgetRef ref) {
    final favoritesState = ref.watch(favoritesViewModelProvider);
    final isFavorite = favoritesState.favoritePlaceIds.contains(place.id);
    final priceLevel = place.metadata?['priceLevel'] as int? ?? 2;

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 2,
      child: InkWell(
        onTap: () {
          // 장소 상세 페이지로 이동 - 기존 Place 모델로 변환하여 전달
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PlaceDetailScreen(
                place: Place(
                  id: place.id,
                  name: place.name,
                  category: place.category,
                  address: place.address,
                  description: place.description,
                  imageUrl: place.imageUrl,
                  rating: place.rating,
                  reviews: place.reviewCount,
                  latitude: place.latitude,
                  longitude: place.longitude,
                  isFavorite: isFavorite,
                ),
              ),
            ),
          );
        },
        borderRadius: BorderRadius.circular(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 이미지 영역
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                  child: Image.network(
                    place.imageUrl,
                    width: double.infinity,
                    height: 180,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: double.infinity,
                        height: 180,
                        color: Colors.grey[300],
                        child: const Icon(
                          Icons.image_not_supported,
                          size: 50,
                          color: Colors.white,
                        ),
                      );
                    },
                  ),
                ),

                // 카테고리 태그
                Positioned(
                  top: 12,
                  left: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryColor.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      place.category,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                // 좋아요 버튼
                Positioned(
                  top: 10,
                  right: 10,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: IconButton(
                      icon: Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: isFavorite ? AppTheme.primaryColor : Colors.grey,
                      ),
                      onPressed: () {
                        ref.read(favoritesViewModelProvider.notifier).toggleFavorite(place.id);
                      },
                      constraints: const BoxConstraints(
                        minWidth: 36,
                        minHeight: 36,
                      ),
                      iconSize: 20,
                      padding: EdgeInsets.zero,
                    ),
                  ),
                ),
              ],
            ),

            // 텍스트 영역
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          place.name,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.textColor,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      // 가격대 표시
                      Row(
                        children: List.generate(
                          5,
                              (index) => Icon(
                            Icons.attach_money,
                            size: 14,
                            color: index < priceLevel
                                ? AppTheme.primaryColor
                                : Colors.grey[300],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.star, size: 18, color: Colors.amber),
                          const SizedBox(width: 4),
                          Text(
                            place.rating.toString(),
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '(${place.reviewCount})',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Row(
                          children: [
                            const Icon(Icons.location_on, size: 16, color: Colors.grey),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                place.address,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    place.description,
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppTheme.textColor,
                      height: 1.4,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 12),

                  // 태그 목록
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: place.tags.map((tag) {
                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          '#$tag',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[700],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 정렬 대화상자
  void _showSortDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('정렬 방식'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildSortOption(SortOption.popularity, '인기순'),
              _buildSortOption(SortOption.rating, '평점 높은 순'),
              _buildSortOption(SortOption.distance, '거리순'),
              _buildSortOption(SortOption.priceAsc, '가격 낮은 순'),
              _buildSortOption(SortOption.priceDesc, '가격 높은 순'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('취소'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildSortOption(SortOption option, String label) {
    return ListTile(
      title: Text(label),
      leading: Radio<SortOption>(
        value: option,
        groupValue: _currentSortOption,
        activeColor: AppTheme.primaryColor,
        onChanged: (value) {
          setState(() {
            _currentSortOption = value!;
          });
          Navigator.pop(context);
        },
      ),
      onTap: () {
        setState(() {
          _currentSortOption = option;
        });
        Navigator.pop(context);
      },
      dense: true,
    );
  }

  // 필터 대화상자
  void _showFilterDialog(List<String> subcategories) {
    showDialog(
      context: context,
      builder: (context) {
        RangeValues tempPriceRange = _priceRange;
        String? tempSubcategory = _selectedSubcategory;

        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('필터'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '세부 카테고리',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: subcategories.map((subcat) {
                      final isSelected = tempSubcategory == subcat;
                      return FilterChip(
                        label: Text(subcat),
                        selected: isSelected,
                        onSelected: (selected) {
                          setState(() {
                            tempSubcategory = selected ? subcat : null;
                          });
                        },
                        selectedColor: AppTheme.primaryColor.withOpacity(0.2),
                        checkmarkColor: AppTheme.primaryColor,
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    '가격대',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  RangeSlider(
                    values: tempPriceRange,
                    min: 0,
                    max: 100000,
                    divisions: 5,
                    labels: RangeLabels(
                      '${tempPriceRange.start.toInt()}원',
                      '${tempPriceRange.end.toInt()}원',
                    ),
                    activeColor: AppTheme.primaryColor,
                    inactiveColor: AppTheme.primaryColor.withOpacity(0.2),
                    onChanged: (values) {
                      setState(() {
                        tempPriceRange = values;
                      });
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('${tempPriceRange.start.toInt()}원'),
                      Text('${tempPriceRange.end.toInt()}원'),
                    ],
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('취소'),
                ),
                TextButton(
                  onPressed: () {
                    this.setState(() {
                      _selectedSubcategory = tempSubcategory;
                      _priceRange = tempPriceRange;
                    });
                    Navigator.pop(context);
                  },
                  child: const Text('적용'),
                ),
                TextButton(
                  onPressed: () {
                    this.setState(() {
                      _selectedSubcategory = null;
                      _priceRange = const RangeValues(0, 100000);
                    });
                    Navigator.pop(context);
                  },
                  child: const Text('초기화'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _applySorting(List<DatePlace> places) {
    switch (_currentSortOption) {
      case SortOption.popularity:
        places.sort((a, b) => b.reviewCount.compareTo(a.reviewCount));
        break;
      case SortOption.rating:
        places.sort((a, b) => b.rating.compareTo(a.rating));
        break;
      case SortOption.distance:
      // 실제로는 현재 위치 기반으로 계산해야 함
        places.sort((a, b) => a.address.compareTo(b.address));
        break;
      case SortOption.priceAsc:
        places.sort((a, b) =>
            (a.metadata?['price'] as int? ?? 0).compareTo(b.metadata?['price'] as int? ?? 0)
        );
        break;
      case SortOption.priceDesc:
        places.sort((a, b) =>
            (b.metadata?['price'] as int? ?? 0).compareTo(a.metadata?['price'] as int? ?? 0)
        );
        break;
    }
  }

  String _getSortName(SortOption option) {
    switch (option) {
      case SortOption.popularity:
        return '인기순';
      case SortOption.rating:
        return '평점 높은 순';
      case SortOption.distance:
        return '거리순';
      case SortOption.priceAsc:
        return '가격 낮은 순';
      case SortOption.priceDesc:
        return '가격 높은 순';
    }
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case '맛집':
        return Icons.restaurant;
      case '카페':
        return Icons.local_cafe;
      case '영화':
        return Icons.movie;
      case '공원':
        return Icons.park;
      case '액티비티':
        return Icons.attractions;
      default:
        return Icons.place;
    }
  }

  List<String> _getSubcategories(String? category) {
    if (category == null) return [];

    switch (category) {
      case '맛집':
        return ['한식', '양식', '일식', '중식', '아시안', '분식', '패스트푸드'];
      case '카페':
        return ['디저트', '브런치', '베이커리', '커피', '차', '와인'];
      case '영화':
        return ['액션', '로맨스', '코미디', '스릴러', '공포', '드라마'];
      case '공원':
        return ['산책로', '꽃구경', '피크닉', '야경', '자전거', '호수'];
      case '액티비티':
        return ['실내', '실외', '스포츠', '문화', '예술', '체험'];
      default:
        return [];
    }
  }

  // 카테고리별 더미 데이터
  List<DatePlace> _getDummyPlacesByCategory(String category) {
    final allDummy = _getDummyPlaces();
    // 카테고리와 일치하는 장소만 반환
    final categoryPlaces = allDummy.where((place) => place.category == category).toList();

    // 해당 카테고리의 장소가 없으면 새로 생성
    if (categoryPlaces.isEmpty) {
      // 실제 구현 시 적절한 더미 데이터를 반환
      return [
        DatePlace(
          id: '${category.toLowerCase()}1',
          name: '$category 추천 장소',
          category: category,
          imageUrl: 'https://picsum.photos/id/292/300/200',
          rating: 4.5,
          address: '서울시 강남구 역삼동 123',
          description: '$category을(를) 즐길 수 있는 추천 장소입니다.',
          tags: ['추천', category, '데이트'],
          reviewCount: 120,
          latitude: 37.5012,
          longitude: 127.0396,
          metadata: {
            'price': 25000,
            'priceLevel': 2,
          },
        ),
      ];
    }

    return categoryPlaces;
  }

  // 일반 더미 데이터
  List<DatePlace> _getDummyPlaces() {
    return [
    DatePlace(
      id: 'p1',
      name: '로맨틱 가든 카페',
      category: '카페',
      imageUrl: 'https://picsum.photos/id/225/300/200',
      rating: 4.7,
      address: '서울시 강남구 압구정로 123',
      description: '아름다운 정원이 있는 분위기 좋은 카페입니다. 연인과 함께 방문하기 좋은 장소예요.',
      tags: ['카페', '데이트', '정원', '디저트', '브런치'],
      reviewCount: 142,
      latitude: 37.5242,
      longitude: 127.0386,
      metadata: {
        'price': 15000,
        'priceLevel': 2,
      },
    ),
    DatePlace(
    id: 'p2',
    name: '스카이뷰 레스토랑',
    category: '맛집',
    imageUrl: 'https://picsum.photos/id/429/300/200',
    rating: 4.5,
    address: '서울시 중구 을지로 234',
    description: '도시의 멋진 전망을 즐기며 식사할 수 있는 고급 레스토랑입니다.',
    tags: ['레스토랑', '야경', '고급', '양식', '와인'],
    reviewCount: 89,
    latitude: 37.5662,
    longitude: 126.9784,
    metadata: {
    'price': 50000,
    'priceLevel': 4,
    },
    ),
    DatePlace(
    id: 'p3',
    name: '시네마 파라다이스',
    category: '영화',
    imageUrl: 'https://picsum.photos/id/335/300/200',
    rating: 4.8,
    address: '서울시 서초구 강남대로 555',
    description: '2인 소파석이 있는 프리미엄 영화관으로 데이트하기 좋은 곳입니다.',
    tags: ['영화관', '데이트', '프라이빗', '로맨스', '액션'],
    reviewCount: 215,
    latitude: 37.5037,
    longitude: 127.0246,
    metadata: {
    'price': 30000,
    'priceLevel': 3,
    },
    ),
    DatePlace(
    id: 'p4',
    name: '한강 선셋 파크',
    category: '공원',
    imageUrl: 'https://picsum.photos/id/134/300/200',
    rating: 4.6,
    address: '서울시 용산구 이촌로 300',
    description: '한강변에서 아름다운 석양을 볼 수 있는 공원입니다. 산책하기 좋아요.',
      tags: ['공원', '산책로', '야경', '피크닉', '한강'],
      reviewCount: 176,
      latitude: 37.5171,
      longitude: 126.9369,
      metadata: {
        'price': 5000,
        'priceLevel': 1,
      },
    ),
      DatePlace(
        id: 'p5',
        name: '플라워 아트 갤러리',
        category: '전시',
        imageUrl: 'https://picsum.photos/id/106/300/200',
        rating: 4.4,
        address: '서울시 종로구 인사동길 44',
        description: '아름다운 꽃 예술 작품을 감상할 수 있는 갤러리입니다.',
        tags: ['갤러리', '전시', '예술', '꽃', '데이트'],
        reviewCount: 64,
        latitude: 37.5743,
        longitude: 126.9873,
        metadata: {
          'price': 12000,
          'priceLevel': 2,
        },
      ),
      DatePlace(
        id: 'p6',
        name: '어반 클라이밍 센터',
        category: '액티비티',
        imageUrl: 'https://picsum.photos/id/448/300/200',
        rating: 4.5,
        address: '서울시 마포구 와우산로 94',
        description: '실내 클라이밍을 즐길 수 있는 센터로, 다양한 난이도의 코스가 있습니다.',
        tags: ['클라이밍', '스포츠', '액티비티', '실내', '체험'],
        reviewCount: 107,
        latitude: 37.5545,
        longitude: 126.9218,
        metadata: {
          'price': 20000,
          'priceLevel': 2,
        },
      ),
    ];
  }
}