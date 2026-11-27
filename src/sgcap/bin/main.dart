import 'dart:io';
import 'package:sgcap/menu.dart';
void limparTela() {
  print('\x1B[2J\x1B[0;0H');
}
void main() async{
  Menu menu = Menu();

  int opcao;
    
    do {
    limparTela();
    print("==================================");
    print("Sistema de Gerenciamento de Pastas");
    print("==================================");

    print("=== MENU PRINCIPAL ===");
    print("1- Empresa");
    print("2- Categoria");
    print("3- Pastas");
    print("0- Sair");
    stdout.write("Escolha uma opção: ");

    opcao = int.tryParse(stdin.readLineSync() ?? "") ?? -1;

    switch(opcao){
      case 1:
        await menu.menuEmpresa();
        break;
      case 2:
        await menu.menuCategoria();
        break;

      case 3:
        await menu.menuPasta();
        break;
      case 0:
      break;
       default:
       print("Tente outra opção");
    }
    }while(opcao != 0 );
}