# vibe-ui ✨

Лёгкое Android-приложение на Flutter: выбираешь «вайб» — и весь интерфейс
перестраивается под настроение. Анимированные градиенты, дрейфующие блобы,
летающие частицы, стеклянные карточки и цитата под каждый вайб.

Никакой логики «про работу» — чистая эстетика и настроение.

## Вайбы

| Вайб | Настроение |
|------|-----------|
| 🌙 Midnight Chill | глубокая ночь, спокойствие |
| 🌇 Sunset Drive | закат, окна вниз |
| ☔ Lo-fi Rain | дождь, кофе, лоу-фай биты |
| 🌆 Neon City | неон, город после полуночи |
| 🌲 Forest Calm | тишина и хвоя |
| 🍬 Cotton Candy | пастельные мечты |

Выбранный вайб сохраняется (shared_preferences) и восстанавливается
при следующем запуске.

## Запуск

Нужен Flutter 3.24+ (Dart 3.5+).

```bash
git clone https://github.com/kingston12612-hue/vibe-ui.git
cd vibe-ui
flutter create . --project-name vibe_ui --platforms android,ios
flutter pub get
flutter run
```

`flutter create .` генерирует платформенные папки (`android/`, `ios/`) —
они не хранятся в репозитории, чтобы проект оставался лёгким.

## Структура

```
lib/
├── main.dart                     # точка входа приложения
├── models/vibe.dart              # модель вайба (градиент, цитата, акцент)
├── data/vibes.dart               # список вайбов — добавь свой сюда
├── screens/
│   ├── home_screen.dart          # сетка карточек + текущий вайб
│   └── vibe_ambient_screen.dart  # полноэкранный ambient-режим
└── widgets/
    ├── animated_background.dart  # CustomPainter: блобы + частицы
    └── vibe_card.dart            # стеклянная карточка вайба
```

## Как добавить свой вайб

Один объект в `lib/data/vibes.dart`:

```dart
Vibe(
  id: 'space',
  name: 'Deep Space',
  emoji: '🚀',
  tagline: 'far from home',
  quote: 'The silence out here is huge.',
  gradient: [Color(0xFF000428), Color(0xFF004E92)],
  accent: Color(0xFF92D5FF),
),
```

Сетка на главном экране и ambient-режим подхватят его автоматически.

## Идеи для развития

- Ambient-звуки под каждый вайб (дождь, lo-fi, synthwave)
- Дыхательная практика с таймером в ambient-режиме
- Виджет на рабочий стол с текущим вайбом
- Экспорт вайба как обоев для телефона
