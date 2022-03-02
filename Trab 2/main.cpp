/**
* UNIVERSIDADE DE BRASÍLIA
* ORGANIZAÇÃO E ARQUITETURA DE COMPUTADORES 
* TURMA C - 2021/2
*
* Trabalho 2: Simulador RISCV 
*
* MAIN
*
* Aluno: João Pedro de Oliveira Silva
* Matrícula: 19/0057807
**/

#include <iomanip>
#include <iostream>
#include <map>

using namespace std;

#include "riscv.cpp"

int main() {
  load_mem("code.bin", 0);
  load_mem("data.bin", 0x2000);
  run();

  return 0;
}