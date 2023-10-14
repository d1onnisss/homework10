import 'dart:io';
import 'package:translator/translator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() async {
  await catFacts();
}

Future<void> catFacts() async {
  final translator = GoogleTranslator();
  final url = Uri.parse('https://catfact.ninja/fact');
  String choice = "";
  List<String> likedFacts = [];
  String userLanguage = ""; 

  do {
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body); 
      final fact = jsonData['fact']; 

      stdout.write('Выберите Ваш язык: "ru", "eng", "spain", "french": ');
      userLanguage = stdin.readLineSync() ?? "";

      switch (userLanguage) {
        case "ru":
          final russianTranslation = await translator.translate(fact, from: 'en', to: 'ru');
          print('Факт о кошках: ${russianTranslation.toString()}');
          break;
        case "eng":
          print('Cat Fact: $fact');
          break;
        case "spain":
          final spanishTranslation = await translator.translate(fact, from: 'en', to: 'es');
          print('Hecho sobre gatos: ${spanishTranslation.toString()}');
          break;
        case "french":
          final frenchTranslation = await translator.translate(fact, from: 'en', to: 'fr');
          print('Fait sur les chats: ${frenchTranslation.toString()}');
          break;
        default:
          print('Неправильный выбор языка.');
      }

      stdout.write("1) Понравился\n"
                   "2) Далее\n"
                   "3) Показать список понравившихся фактов\n");

      choice = stdin.readLineSync() ?? "";

      switch (choice) {
        case "1":
          final translation = await translator.translate(fact, from: 'en', to: userLanguage);
          likedFacts.add(translation.toString());
          break;
        case "2":
          break;
        case "3":
          if (likedFacts.isNotEmpty) {
            print("Список понравившихся фактов:");
            for (int i = 1; i < likedFacts.length; i++) {
              print("$i) ${likedFacts[i]}");
            }
          } else {
            print("Вы ещё не добавили факты в список понравившихся фактов.");
          }
          break;
        default:
      }
    } else {
      print('Ошибка при выполнении запроса: ${response.statusCode}');
    }
  } while (choice == "2" || choice == "1");
}
