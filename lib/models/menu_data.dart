import 'category.dart';
import 'dish.dart';
import 'dish_variant.dart';

const List<Category> menuCategories = [
  Category(
    name: 'Закуски',
    dishes: [
      Dish(
        id: 'tempura_shrimp',
        name: 'Креветки темпура',
        imageUrl: '',
        description: 'Хрустящие креветки в кляре',
        variants: [
          DishVariant(weight: '5 шт', price: 350),
          DishVariant(weight: '7 шт', price: 460),
          DishVariant(weight: '9 шт', price: 570),
        ],
      ),
      Dish(
        id: 'nuggets',
        name: 'Наггетсы',
        imageUrl: '',
        description: 'Куриные наггетсы в панировке',
        variants: [
          DishVariant(weight: '6 шт', price: 240),
          DishVariant(weight: '9 шт', price: 340),
          DishVariant(weight: '12 шт', price: 440),
        ],
      ),
      Dish(
        id: 'fries',
        name: 'Картофель фри',
        imageUrl: '',
        description: 'Золотистый картофель фри',
        variants: [
          DishVariant(weight: '100 г', price: 120),
          DishVariant(weight: '150 г', price: 170),
        ],
      ),
      Dish(
        id: 'potato_wedges',
        name: 'Картофельные дольки',
        imageUrl: '',
        description: 'Запечённые дольки картофеля',
        variants: [
          DishVariant(weight: '100 г', price: 130),
          DishVariant(weight: '150 г', price: 180),
        ],
      ),
    ],
  ),
];
