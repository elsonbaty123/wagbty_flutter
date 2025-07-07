/// Sample in-memory data models used for early UI development.
/// Replace with API-backed models once backend integration is ready.

class Chef {
  final String id;
  final String name;
  final String avatar;
  final String cuisine;
  final double rating;
  final int reviewCount;

  const Chef({
    required this.id, 
    required this.name, 
    required this.avatar,
    this.cuisine = 'مطبخ عربي',
    this.rating = 4.5,
    this.reviewCount = 128,
  });
}

class Dish {
  final String id;
  final String name;
  final String image;
  final double price;
  final String cuisine;
  final double rating;
  final String description;

  const Dish({
    required this.id, 
    required this.name, 
    required this.image, 
    required this.price,
    this.cuisine = 'مطبخ عربي',
    this.rating = 4.5,
    this.description = 'وصف الطبق يظهر هنا',
  });
}

const List<Chef> sampleChefs = [
  Chef(
    id: 'c1', 
    name: 'الشيف أحمد', 
    avatar: 'https://i.pravatar.cc/150?img=1',
    cuisine: 'مطبخ مصري',
    rating: 4.8,
    reviewCount: 245,
  ),
  Chef(
    id: 'c2',
    name: 'الشيف سارة',
    avatar: 'https://i.pravatar.cc/150?img=2',
    cuisine: 'مطبخ سوري',
    rating: 4.9,
    reviewCount: 312,
  ),
  Chef(
    id: 'c3',
    name: 'الشيف محمد',
    avatar: 'https://i.pravatar.cc/150?img=3',
    cuisine: 'مشويات',
    rating: 4.7,
    reviewCount: 198,
  ),
  Chef(
    id: 'c4',
    name: 'الشيف نورة',
    avatar: 'https://i.pravatar.cc/150?img=4',
    cuisine: 'حلويات',
    rating: 4.6,
    reviewCount: 276,
  ),
  Chef(
    id: 'c5',
    name: 'الشيف خالد',
    avatar: 'https://i.pravatar.cc/150?img=5',
    cuisine: 'مطبخ بحري',
    rating: 4.5,
    reviewCount: 154,
  ),
  Chef(
    id: 'c6',
    name: 'الشيف فاطمة',
    avatar: 'https://i.pravatar.cc/150?img=6',
    cuisine: 'مطبخ سعودي',
    rating: 4.9,
    reviewCount: 321,
  ),
  Chef(
    id: 'c2', 
    name: 'الشيف محمد', 
    avatar: 'https://i.pravatar.cc/150?img=2',
    cuisine: 'مطبخ آسيوي',
    rating: 4.6,
    reviewCount: 189,
  ),
  Chef(
    id: 'c3', 
    name: 'الشيف سارة', 
    avatar: 'https://i.pravatar.cc/150?img=3',
    cuisine: 'مطبخ إيطالي',
    rating: 4.9,
    reviewCount: 312,
  ),
  Chef(
    id: 'c4', 
    name: 'الشيف علي', 
    avatar: 'https://i.pravatar.cc/150?img=4',
    cuisine: 'مشويات',
    rating: 4.7,
    reviewCount: 201,
  ),
  Chef(
    id: 'c5', 
    name: 'الشيف نور', 
    avatar: 'https://i.pravatar.cc/150?img=5',
    cuisine: 'حلويات',
    rating: 4.9,
    reviewCount: 278,
  ),
  Chef(
    id: 'c6', 
    name: 'الشيف خالد', 
    avatar: 'https://i.pravatar.cc/150?img=6',
    cuisine: 'مأكولات بحرية',
    rating: 4.5,
    reviewCount: 156,
  ),
];

const List<Dish> sampleDishes = [
  Dish(
    id: 'd1', 
    name: 'باستا بالدجاج', 
    image: 'https://images.unsplash.com/photo-1551183053-bf91a1d81111?w=500&auto=format&fit=crop&q=80', 
    price: 35.0,
    cuisine: 'إيطالي',
    rating: 4.7,
    description: 'باستا كريمية مع صدر دجاج مشوي وفطر طازج',
  ),
  Dish(
    id: 'd2', 
    name: 'برجر لحم', 
    image: 'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=500&auto=format&fit=crop&q=80', 
    price: 28.0,
    cuisine: 'أمريكي',
    rating: 4.5,
    description: 'برجر لحم بقري مع جبنة شيدر وخضار طازجة',
  ),
  Dish(
    id: 'd3', 
    name: 'سوشي سالمون', 
    image: 'https://images.unsplash.com/photo-1579871494447-9811cf80d66c?w=500&auto=format&fit=crop&q=80', 
    price: 45.0,
    cuisine: 'ياباني',
    rating: 4.9,
    description: 'سوشي سالمون طازج مع أرز الخل والأفوكادو',
  ),
  Dish(
    id: 'd4', 
    name: 'سلطة سيزر', 
    image: 'https://images.unsplash.com/photo-1546793665-c74683f339c1?w=500&auto=format&fit=crop&q=80', 
    price: 22.0,
    cuisine: 'صحي',
    rating: 4.3,
    description: 'خس روماني مع كروتونات وجبنة بارميزان',
  ),
  Dish(
    id: 'd5', 
    name: 'ستيك لحم', 
    image: 'https://images.unsplash.com/photo-1432139509613-5c4255815697?w=500&auto=format&fit=crop&q=80', 
    price: 75.0,
    cuisine: 'مشويات',
    rating: 4.8,
    description: 'ستيك ريب آي مشوي مع صلصة الفطر',
  ),
  Dish(
    id: 'd6', 
    name: 'بيتزا مارغريتا', 
    image: 'https://images.unsplash.com/photo-1604382355076-af4b0eb60143?w=500&auto=format&fit=crop&q=80', 
    price: 40.0,
    cuisine: 'إيطالي',
    rating: 4.6,
    description: 'عجينة رقيقة مع صلصة طماطم وجبنة موزاريلا طازجة',
  ),
];
