import 'dart:io';
import 'package:sgcap/categoria/cadastrarCategoria.dart';
import 'package:sgcap/pasta/cadastrarPasta.dart';
import 'package:sgcap/categoria/categoria.dart';
import 'package:sgcap/funcoes.dart';
import 'package:sgcap/status/statusPasta.dart';
import 'empresa/cadastrarEmpresas.dart';
import 'package:sgcap/empresa/empresa.dart';

class Menu extends Funcoes{
  Cadastrarempresas empresa = Cadastrarempresas(); 
  Cadastrarcategoria categoria = Cadastrarcategoria();

  Future<void> menuEmpresa() async{
    limparTela();
    int opcao;
    do {
      print("=== Menu Empresa ===");
      print("1- Adicionar Empresa");
      print("2- Deletar empresa");
      print("3- Atualizar empresa");
      print("4- Buscar empresas");
      print("0- Sair");
      stdout.write("Escolha uma opção: ");

      opcao = int.parse(stdin.readLineSync()!);

      switch(opcao){

        case 1: 
          stdout.write("Digite o Nome da Empresa: ");
          String nome = stdin.readLineSync()!;

          stdout.write("Digite o cnpj: ");
          String cnpj = stdin.readLineSync()!;

          Empresa novaEmpresa = Empresa(nome: nome, cnpj: cnpj);

          await empresa.salvar(novaEmpresa);
          break;

        case 2: 
          stdout.write("Digite o ID da empresa a ser deletada: ");
          int idEmpresa = int.parse(stdin.readLineSync()!);

          await empresa.deletar(idEmpresa);
          break;

        case 3:
          stdout.write("Digite o id:");
            int idEmpresa = int.parse(stdin.readLineSync()!);

          stdout.write("Digite o nome:");
            String nome = stdin.readLineSync()!;

          stdout.write("Digite o cnpj:");
            String cnpj = stdin.readLineSync()!;

          Empresa novaEmpresa = Empresa(nome: nome, cnpj: cnpj);

           await empresa.alterar(idEmpresa,novaEmpresa);
           break;

        case 4:
          var empresas = await empresa.buscarTodas();

          if(empresas.isEmpty){
           print("Nenhuma empresa encontrada no banco de dados.");
          }else{
           for (var e in empresas){
            print(e);
           }
          }
          break;
        case 0:
          break;


        default:
         print("Tente outra opção");
      }
    }while(opcao != 0);
  }
  Future<void> menuCategoria() async {
    limparTela();
    int opcao;

    do {
        print("=== Menu Categoria ===");
        print("1- Adicionar Categoria");
        print("2- Excluir Categoria");
        print("3- Atualizar Categoria ");
        print("4- Exibir Categorias cadastradas");
        print("0- Sair");

        opcao = int.parse(stdin.readLineSync()!);

        switch(opcao){
          case 1:
            stdout.write("Digite o nome da categoria: ");
              String nome = stdin.readLineSync()!;    

             Categoria novacategoria = Categoria(nomeCategoria: nome);

              await categoria.salvar(novacategoria);
            break;
          
          case 2:
            stdout.write("Digite o ID da categoria a ser deletada: ");
             int idCategoria = int.parse(stdin.readLineSync()!);

            await categoria.ExcluirCategoria(idCategoria);
             break;

          case 3:
            stdout.write("Digite o id:");
              int idCategoria = int.parse(stdin.readLineSync()!);

            stdout.write("Digite o nome:");
              String nome = stdin.readLineSync()!;

            Categoria novaCategoria = Categoria(nomeCategoria: nome);

            await categoria.AtualizarCategoria(idCategoria,novaCategoria);
              break;

          case 4:
            var categorias = await categoria.buscarTodasCategorias();

              if(categorias.isEmpty){
               print("Nenhuma categoria encontrada no banco de dados.");
                }else{
              for (var e in categorias){
                 print(e);
              }
                }
          break;

          case 0:
          break;

          default:
          print("Tente outra opção");
        }
      }while(opcao != 0);
  }
  Future<void> menuPasta() async{
    limparTela();
    CadastrarPasta novaPasta = CadastrarPasta();
    StatusPasta novoStatus = StatusPasta();
    int opcao;

    do{
        print("=== Menu Pasta ===");
        print("1- Adicionar Pasta");
        print("2- Exibir Pasta cadastradas");
        print("3- Procurar pastas");
        print("4- Alterar Status");
        print("5- Excluir Pasta");
        print("0- Sair");

        opcao = int.parse(stdin.readLineSync()!);
        switch(opcao){
          case 1:
          stdout.write("Digite o nome da empresa:");
          String nome = stdin.readLineSync()!;
          stdout.write("Digite o nome da categoria:");
          String categoria = stdin.readLineSync()!;

          CadastrarPasta novaPasta = CadastrarPasta();

          await novaPasta.SalvarPasta(nome, categoria);
          break;

          case 2:
          var pastas = await novaPasta.buscarPasta();

          if(pastas.isEmpty){
           print("Nenhuma empresa encontrada no banco de dados.");
          }else{
           for (var e in pastas){
            print(e);
           }
          }
          break;   

          case 3:
            stdout.write("Digite o nome da empresa: ");
            String busca = stdin.readLineSync() ?? "";

            var encontradas = await novaPasta.buscarPasta(nomeEmpresa: busca);

            if (encontradas.isEmpty) {
             print("Nenhuma pasta encontrada para \"$busca\".");
            } else {
            for (var e in encontradas) {
            print(e);
            }
            }
          break;
          case 4:
          bool continuar = true;
          while(continuar){
            print("1- Arquivo Morto");
            print("2- Entregar Pasta");
            print("0- Sair");
            stdout.write("Escolha uma opção:");
            String opcaoNumero = stdin.readLineSync()??"";

            if(opcaoNumero == "1"){
              stdout.write("Digite o id da pasta");
              int idPasta = int.parse(stdin.readLineSync() ?? "");

              await novoStatus.ArquivoMorto(idPasta);
            }else if (opcaoNumero == "2"){
              stdout.write("Digite o id da pasta");
              int idPasta = int.parse(stdin.readLineSync() ?? "");

              await novoStatus.EntregarPasta(idPasta);
            }else if (opcaoNumero == "0"){
              continuar = false;
            }else{
              print("Tente outra opção !");
            }
          }
          break;
          case 5:
          stdout.write("Digite o id da Pasta:");
          int idPasta = int.parse(stdin.readLineSync()?? "");

          await novaPasta.DeletarPasta(idPasta);
          break;

          case 0:
          limparTela();
          break;

          default:
          print("Tente outra opção");
        }

      }while(opcao != 0);
  }
}