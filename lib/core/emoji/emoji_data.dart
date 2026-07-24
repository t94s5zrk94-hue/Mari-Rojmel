/// ===============================================================
/// Mari-Rojmel
/// Emoji Data
///
/// Central emoji repository used across the application.
///
/// Used by:
/// • Categories
/// • Payment Modes
/// • Accounts
/// • Budgets (Future)
/// • Tags (Future)
///
/// Version : v2.0
/// ===============================================================

import 'emoji_model.dart';

class EmojiData {
  EmojiData._();

  static const List<EmojiModel> emojis = [
    // ===========================================================
    // Finance
    // ===========================================================
    EmojiModel(
      emoji: '💰',
      name: 'Money',
      keywords: ['money', 'cash', 'finance', 'income'],
      group: 'Finance',
    ),

    EmojiModel(
      emoji: '💵',
      name: 'Cash',
      keywords: ['cash', 'payment', 'currency'],
      group: 'Finance',
    ),

    EmojiModel(
      emoji: '💳',
      name: 'Card',
      keywords: ['card', 'credit', 'debit', 'payment'],
      group: 'Finance',
    ),

    EmojiModel(
      emoji: '🏦',
      name: 'Bank',
      keywords: ['bank', 'account', 'finance'],
      group: 'Finance',
    ),

    EmojiModel(
      emoji: '📱',
      name: 'UPI',
      keywords: ['upi', 'phonepe', 'gpay', 'paytm', 'payment'],
      group: 'Finance',
    ),

    EmojiModel(
      emoji: '👛',
      name: 'Wallet',
      keywords: ['wallet', 'purse', 'money'],
      group: 'Finance',
    ),

    EmojiModel(
      emoji: '🪙',
      name: 'Coin',
      keywords: ['coin', 'money', 'currency'],
      group: 'Finance',
    ),

    EmojiModel(
      emoji: '💎',
      name: 'Investment',
      keywords: ['investment', 'gold', 'asset'],
      group: 'Finance',
    ),

    EmojiModel(
      emoji: '📈',
      name: 'Profit',
      keywords: ['profit', 'growth', 'income'],
      group: 'Finance',
    ),

    EmojiModel(
      emoji: '📉',
      name: 'Loss',
      keywords: ['loss', 'expense', 'decline'],
      group: 'Finance',
    ),

    EmojiModel(
      emoji: '🧾',
      name: 'Bill',
      keywords: ['bill', 'invoice', 'receipt'],
      group: 'Finance',
    ),

    EmojiModel(
      emoji: '💸',
      name: 'Expense',
      keywords: ['expense', 'spending', 'payment'],
      group: 'Finance',
    ),

    // ===========================================================
    // General
    // ===========================================================
    EmojiModel(
      emoji: '📁',
      name: 'Folder',
      keywords: ['folder', 'category'],
      group: 'General',
    ),

    EmojiModel(
      emoji: '⭐',
      name: 'Star',
      keywords: ['star', 'favorite'],
      group: 'General',
    ),

    EmojiModel(
      emoji: '❤️',
      name: 'Heart',
      keywords: ['heart', 'love'],
      group: 'General',
    ),

    EmojiModel(
      emoji: '🏷️',
      name: 'Tag',
      keywords: ['tag', 'label'],
      group: 'General',
    ),

    EmojiModel(
      emoji: '📌',
      name: 'Pin',
      keywords: ['pin', 'important'],
      group: 'General',
    ),

    EmojiModel(
      emoji: '📦',
      name: 'Package',
      keywords: ['box', 'package'],
      group: 'General',
    ),

    EmojiModel(
      emoji: '🎁',
      name: 'Gift',
      keywords: ['gift', 'present'],
      group: 'General',
    ),

    EmojiModel(
      emoji: '🛍️',
      name: 'Shopping Bag',
      keywords: ['shopping', 'bag'],
      group: 'General',
    ),

    EmojiModel(
      emoji: '🔖',
      name: 'Bookmark',
      keywords: ['bookmark', 'save'],
      group: 'General',
    ),

    EmojiModel(
      emoji: '⚙️',
      name: 'Settings',
      keywords: ['settings', 'tools'],
      group: 'General',
    ),
    // ===========================================================
    // Food
    // ===========================================================
    EmojiModel(
      emoji: '🍔',
      name: 'Burger',
      keywords: ['burger', 'food', 'fast food'],
      group: 'Food',
    ),

    EmojiModel(
      emoji: '🍕',
      name: 'Pizza',
      keywords: ['pizza', 'food'],
      group: 'Food',
    ),

    EmojiModel(
      emoji: '🌭',
      name: 'Hot Dog',
      keywords: ['hotdog', 'food'],
      group: 'Food',
    ),

    EmojiModel(
      emoji: '🥪',
      name: 'Sandwich',
      keywords: ['sandwich', 'breakfast', 'food'],
      group: 'Food',
    ),

    EmojiModel(
      emoji: '🍟',
      name: 'French Fries',
      keywords: ['fries', 'snack', 'food'],
      group: 'Food',
    ),

    EmojiModel(
      emoji: '🍜',
      name: 'Noodles',
      keywords: ['noodles', 'ramen', 'food'],
      group: 'Food',
    ),

    EmojiModel(
      emoji: '🍛',
      name: 'Rice',
      keywords: ['rice', 'meal', 'food'],
      group: 'Food',
    ),

    EmojiModel(
      emoji: '🍚',
      name: 'Cooked Rice',
      keywords: ['rice', 'food'],
      group: 'Food',
    ),

    EmojiModel(
      emoji: '🥗',
      name: 'Salad',
      keywords: ['salad', 'healthy', 'food'],
      group: 'Food',
    ),

    EmojiModel(
      emoji: '🍞',
      name: 'Bread',
      keywords: ['bread', 'bakery', 'food'],
      group: 'Food',
    ),

    EmojiModel(
      emoji: '🥛',
      name: 'Milk',
      keywords: ['milk', 'dairy'],
      group: 'Food',
    ),

    EmojiModel(
      emoji: '☕',
      name: 'Tea & Coffee',
      keywords: ['tea', 'coffee', 'drink'],
      group: 'Food',
    ),

    EmojiModel(
      emoji: '🧃',
      name: 'Juice',
      keywords: ['juice', 'drink'],
      group: 'Food',
    ),

    EmojiModel(
      emoji: '🥤',
      name: 'Soft Drink',
      keywords: ['cold drink', 'soft drink', 'drink'],
      group: 'Food',
    ),

    EmojiModel(
      emoji: '🍎',
      name: 'Fruits',
      keywords: ['fruit', 'apple', 'healthy'],
      group: 'Food',
    ),

    // ===========================================================
    // Shopping
    // ===========================================================
    EmojiModel(
      emoji: '🛒',
      name: 'Shopping Cart',
      keywords: ['shopping', 'cart', 'grocery'],
      group: 'Shopping',
    ),

    EmojiModel(
      emoji: '🛍️',
      name: 'Shopping Bag',
      keywords: ['shopping', 'bag', 'purchase'],
      group: 'Shopping',
    ),

    EmojiModel(
      emoji: '👕',
      name: 'Clothes',
      keywords: ['clothes', 'shirt', 'fashion'],
      group: 'Shopping',
    ),

    EmojiModel(
      emoji: '👖',
      name: 'Jeans',
      keywords: ['jeans', 'pants', 'clothes'],
      group: 'Shopping',
    ),

    EmojiModel(
      emoji: '👟',
      name: 'Shoes',
      keywords: ['shoes', 'footwear'],
      group: 'Shopping',
    ),

    EmojiModel(
      emoji: '⌚',
      name: 'Watch',
      keywords: ['watch', 'clock'],
      group: 'Shopping',
    ),

    EmojiModel(
      emoji: '💍',
      name: 'Jewellery',
      keywords: ['ring', 'gold', 'jewellery'],
      group: 'Shopping',
    ),

    EmojiModel(
      emoji: '🧴',
      name: 'Personal Care',
      keywords: ['soap', 'shampoo', 'care'],
      group: 'Shopping',
    ),

    EmojiModel(
      emoji: '💄',
      name: 'Cosmetics',
      keywords: ['beauty', 'cosmetics', 'makeup'],
      group: 'Shopping',
    ),

    EmojiModel(
      emoji: '🎒',
      name: 'Bag',
      keywords: ['bag', 'school bag', 'travel'],
      group: 'Shopping',
    ),

    EmojiModel(
      emoji: '📦',
      name: 'Parcel',
      keywords: ['parcel', 'delivery', 'package'],
      group: 'Shopping',
    ),

    EmojiModel(
      emoji: '🎁',
      name: 'Gift',
      keywords: ['gift', 'present'],
      group: 'Shopping',
    ),
    // ===========================================================
    // Transport
    // ===========================================================
    EmojiModel(
      emoji: '🚗',
      name: 'Car',
      keywords: ['car', 'vehicle', 'travel'],
      group: 'Transport',
    ),

    EmojiModel(
      emoji: '🏍️',
      name: 'Motorcycle',
      keywords: ['bike', 'motorcycle', 'scooter'],
      group: 'Transport',
    ),

    EmojiModel(
      emoji: '🚲',
      name: 'Bicycle',
      keywords: ['cycle', 'bicycle'],
      group: 'Transport',
    ),

    EmojiModel(
      emoji: '🛺',
      name: 'Auto Rickshaw',
      keywords: ['auto', 'rickshaw'],
      group: 'Transport',
    ),

    EmojiModel(
      emoji: '🚕',
      name: 'Taxi',
      keywords: ['taxi', 'cab'],
      group: 'Transport',
    ),

    EmojiModel(
      emoji: '🚌',
      name: 'Bus',
      keywords: ['bus', 'public transport'],
      group: 'Transport',
    ),

    EmojiModel(
      emoji: '🚆',
      name: 'Train',
      keywords: ['train', 'railway'],
      group: 'Transport',
    ),

    EmojiModel(
      emoji: '✈️',
      name: 'Flight',
      keywords: ['flight', 'airplane', 'travel'],
      group: 'Transport',
    ),

    EmojiModel(
      emoji: '⛽',
      name: 'Fuel',
      keywords: ['fuel', 'petrol', 'diesel'],
      group: 'Transport',
    ),

    EmojiModel(
      emoji: '🛣️',
      name: 'Road',
      keywords: ['road', 'highway'],
      group: 'Transport',
    ),

    EmojiModel(
      emoji: '🅿️',
      name: 'Parking',
      keywords: ['parking'],
      group: 'Transport',
    ),

    EmojiModel(
      emoji: '🚦',
      name: 'Traffic',
      keywords: ['traffic', 'signal'],
      group: 'Transport',
    ),

    EmojiModel(
      emoji: '🧳',
      name: 'Travel',
      keywords: ['travel', 'trip', 'tour'],
      group: 'Transport',
    ),

    // ===========================================================
    // Home
    // ===========================================================
    EmojiModel(
      emoji: '🏠',
      name: 'Home',
      keywords: ['home', 'house'],
      group: 'Home',
    ),

    EmojiModel(
      emoji: '🏡',
      name: 'House',
      keywords: ['house', 'villa'],
      group: 'Home',
    ),

    EmojiModel(
      emoji: '🏢',
      name: 'Office',
      keywords: ['office', 'building'],
      group: 'Home',
    ),

    EmojiModel(
      emoji: '🛏️',
      name: 'Bedroom',
      keywords: ['bed', 'bedroom'],
      group: 'Home',
    ),

    EmojiModel(
      emoji: '🛋️',
      name: 'Furniture',
      keywords: ['sofa', 'chair', 'furniture'],
      group: 'Home',
    ),

    EmojiModel(emoji: '🚪', name: 'Door', keywords: ['door'], group: 'Home'),

    EmojiModel(
      emoji: '🪟',
      name: 'Window',
      keywords: ['window'],
      group: 'Home',
    ),

    EmojiModel(
      emoji: '💡',
      name: 'Electricity',
      keywords: ['electricity', 'light', 'power'],
      group: 'Home',
    ),

    EmojiModel(
      emoji: '🚿',
      name: 'Bathroom',
      keywords: ['bathroom', 'shower'],
      group: 'Home',
    ),

    EmojiModel(
      emoji: '🧹',
      name: 'Cleaning',
      keywords: ['cleaning', 'broom'],
      group: 'Home',
    ),

    EmojiModel(
      emoji: '🪣',
      name: 'Bucket',
      keywords: ['bucket', 'cleaning'],
      group: 'Home',
    ),

    EmojiModel(
      emoji: '🧺',
      name: 'Laundry',
      keywords: ['laundry', 'washing'],
      group: 'Home',
    ),

    EmojiModel(
      emoji: '🔑',
      name: 'Keys',
      keywords: ['key', 'home'],
      group: 'Home',
    ),
    // ===========================================================
    // Health
    // ===========================================================
    EmojiModel(
      emoji: '💊',
      name: 'Medicine',
      keywords: ['medicine', 'tablet', 'pill'],
      group: 'Health',
    ),

    EmojiModel(
      emoji: '🩺',
      name: 'Stethoscope',
      keywords: ['doctor', 'medical', 'hospital'],
      group: 'Health',
    ),

    EmojiModel(
      emoji: '🩹',
      name: 'Bandage',
      keywords: ['bandage', 'first aid', 'injury'],
      group: 'Health',
    ),

    EmojiModel(
      emoji: '💉',
      name: 'Injection',
      keywords: ['injection', 'vaccine', 'syringe'],
      group: 'Health',
    ),

    EmojiModel(
      emoji: '🌡️',
      name: 'Thermometer',
      keywords: ['fever', 'temperature'],
      group: 'Health',
    ),

    EmojiModel(
      emoji: '🩸',
      name: 'Blood',
      keywords: ['blood', 'test', 'donation'],
      group: 'Health',
    ),

    EmojiModel(
      emoji: '🦷',
      name: 'Dental',
      keywords: ['tooth', 'dentist'],
      group: 'Health',
    ),

    EmojiModel(
      emoji: '👓',
      name: 'Eye Care',
      keywords: ['eye', 'glasses', 'vision'],
      group: 'Health',
    ),

    EmojiModel(
      emoji: '🏥',
      name: 'Hospital',
      keywords: ['hospital', 'clinic'],
      group: 'Health',
    ),

    EmojiModel(
      emoji: '🧘',
      name: 'Yoga',
      keywords: ['yoga', 'fitness', 'exercise'],
      group: 'Health',
    ),

    EmojiModel(
      emoji: '🏃',
      name: 'Running',
      keywords: ['running', 'fitness', 'exercise'],
      group: 'Health',
    ),

    EmojiModel(
      emoji: '🥗',
      name: 'Healthy Food',
      keywords: ['healthy', 'diet', 'nutrition'],
      group: 'Health',
    ),

    // ===========================================================
    // Education
    // ===========================================================
    EmojiModel(
      emoji: '📚',
      name: 'Books',
      keywords: ['book', 'study'],
      group: 'Education',
    ),

    EmojiModel(
      emoji: '📖',
      name: 'Reading',
      keywords: ['reading', 'book'],
      group: 'Education',
    ),

    EmojiModel(
      emoji: '✏️',
      name: 'Writing',
      keywords: ['writing', 'pencil'],
      group: 'Education',
    ),

    EmojiModel(
      emoji: '📝',
      name: 'Notes',
      keywords: ['notes', 'study'],
      group: 'Education',
    ),

    EmojiModel(
      emoji: '🎓',
      name: 'Graduation',
      keywords: ['graduation', 'college'],
      group: 'Education',
    ),

    EmojiModel(
      emoji: '🏫',
      name: 'School',
      keywords: ['school', 'education'],
      group: 'Education',
    ),

    EmojiModel(
      emoji: '🧮',
      name: 'Calculator',
      keywords: ['calculator', 'math'],
      group: 'Education',
    ),

    EmojiModel(
      emoji: '💻',
      name: 'Computer',
      keywords: ['computer', 'coding'],
      group: 'Education',
    ),

    // ===========================================================
    // Work
    // ===========================================================
    EmojiModel(
      emoji: '💼',
      name: 'Office Work',
      keywords: ['office', 'work', 'business'],
      group: 'Work',
    ),

    EmojiModel(
      emoji: '📊',
      name: 'Reports',
      keywords: ['report', 'analytics'],
      group: 'Work',
    ),

    EmojiModel(
      emoji: '📅',
      name: 'Schedule',
      keywords: ['calendar', 'meeting'],
      group: 'Work',
    ),

    EmojiModel(
      emoji: '📋',
      name: 'Tasks',
      keywords: ['tasks', 'checklist'],
      group: 'Work',
    ),

    EmojiModel(
      emoji: '🖨️',
      name: 'Printer',
      keywords: ['printer', 'office'],
      group: 'Work',
    ),

    EmojiModel(
      emoji: '📞',
      name: 'Calls',
      keywords: ['call', 'phone'],
      group: 'Work',
    ),

    EmojiModel(
      emoji: '📧',
      name: 'Email',
      keywords: ['email', 'mail'],
      group: 'Work',
    ),

    EmojiModel(
      emoji: '🗂️',
      name: 'Documents',
      keywords: ['documents', 'files'],
      group: 'Work',
    ),

    // ===========================================================
    // Lifestyle
    // ===========================================================
    EmojiModel(
      emoji: '🎉',
      name: 'Celebration',
      keywords: ['party', 'celebration'],
      group: 'Lifestyle',
    ),

    EmojiModel(
      emoji: '🎂',
      name: 'Birthday',
      keywords: ['birthday', 'cake'],
      group: 'Lifestyle',
    ),

    EmojiModel(
      emoji: '🎵',
      name: 'Music',
      keywords: ['music', 'song'],
      group: 'Lifestyle',
    ),

    EmojiModel(
      emoji: '📷',
      name: 'Photography',
      keywords: ['camera', 'photo'],
      group: 'Lifestyle',
    ),

    EmojiModel(
      emoji: '🎮',
      name: 'Gaming',
      keywords: ['games', 'gaming'],
      group: 'Lifestyle',
    ),

    EmojiModel(
      emoji: '⚽',
      name: 'Sports',
      keywords: ['sports', 'football'],
      group: 'Lifestyle',
    ),

    EmojiModel(
      emoji: '🏏',
      name: 'Cricket',
      keywords: ['cricket', 'sports'],
      group: 'Lifestyle',
    ),

    EmojiModel(
      emoji: '🎬',
      name: 'Movies',
      keywords: ['movie', 'cinema'],
      group: 'Lifestyle',
    ),

    EmojiModel(
      emoji: '🌴',
      name: 'Vacation',
      keywords: ['vacation', 'holiday', 'travel'],
      group: 'Lifestyle',
    ),

    EmojiModel(
      emoji: '🐶',
      name: 'Pets',
      keywords: ['dog', 'cat', 'pets'],
      group: 'Lifestyle',
    ),
  ];
}
