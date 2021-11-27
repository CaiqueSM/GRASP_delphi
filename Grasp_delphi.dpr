program Grasp_delphi;

{$APPTYPE CONSOLE}
{$R *.res}

uses
  System.Diagnostics,
  System.TimeSpan,
  System.SysUtils,
  System.Generics.Collections,
  untgrasp in 'Units\untgrasp.pas',
  untgrafoutils in 'Utils\untgrafoutils.pas',
  UntGRASPTypes in 'Types\UntGRASPTypes.pas';

var
  caminho: string;
  Grafo: TMatriz;
  CidadeInicial: integer;
  Solucao, NovaSolucao, MelhorSolucao: TVizinhanca;
  Custo, novoCusto, MelhorCusto: real;
  i, j, tamanho: integer;
  // variaveis para medir o tempo gasto.
  Stopwatch: TStopwatch;
  Elapsed: TTimeSpan;

begin
  { TODO -oUser -cConsole Main : Insert code here }
  writeln('Entre com o caminho do arquivo de entrada.');
  readln(caminho);
  LerArquivoParaGrafo(Grafo, caminho);
  tamanho := length(Grafo);
  MelhorCusto := MaxInt;
  randomize;
  Stopwatch := TStopwatch.StartNew;
  try
    try
      { GRASP }

      for i := 0 to tamanho - 1 do
      begin
        for j := 0 to tamanho - 1 do
        begin
          CidadeInicial := i;
          Solucao := AlgoritmoConstrutivo(Grafo, CidadeInicial);
          Custo := CustoSolucao(Grafo, Solucao);
          NovaSolucao := BuscaLocal(Grafo, Solucao);
          novoCusto := CustoSolucao(Grafo, NovaSolucao);

          if novoCusto < Custo then
          begin
            Solucao := NovaSolucao;
            Custo := novoCusto;
          end;

          if Custo <= MelhorCusto then
          begin
            MelhorCusto := Custo;
            MelhorSolucao := Solucao;
          end;
        end;

      end;
    except
      on E: Exception do
        writeln(E.ClassName, ': ', E.Message);
    end;
  finally
    writeln;
    writeln('Lista de cidades visitadas (vétices):');
    ImprimirCiclo(MelhorSolucao);
    writeln;
    writeln('Distância percorrida (custo total):');
    writeln(FloatTOstr(MelhorCusto));
  end;
  Elapsed := Stopwatch.Elapsed;
  writeln;
  writeln('Tempo gasto:' + Elapsed);
  writeln('Pressione ENTER para sair.');
  readln;

end.
