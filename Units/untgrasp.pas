unit UntGrasp;

interface

uses
  System.Generics.Collections, SysUtils, UntGRASPTypes;

function AlgoritmoConstrutivo(Grafo: TMatriz; VerticeInicial: integer)
  : TVizinhanca;
procedure ImprimirCiclo(ASolucao: TVizinhanca);
function CustoSolucao(AGrafo: TMatriz; ASolucao: TVizinhanca): real;
function Max(AGrafo: TMatriz; ALista: TVizinhanca;
  AVertice, ADimensaoLista: integer): real;
function Min(AGrafo: TMatriz; ALista: TVizinhanca;
  AVertice, ADimensaoLista: integer): real;
function BuscaLocal(AGrafo: TMatriz; ASolucao: TVizinhanca): TVizinhanca;
function Troca(ASolucao: TVizinhanca; inicio, fim: integer): TVizinhanca;
procedure LimparLista(var ALista: TVizinhanca);

implementation

{ Contrutivo ganancioso e aleatório }
function AlgoritmoConstrutivo(Grafo: TMatriz; VerticeInicial: integer)
  : TVizinhanca;
var
  visitado: Tvisitado;
  solucao: TVizinhanca;
  ListaCandidatos: TVizinhanca;
  LRC: TVizinhanca; // lista restrita de candidatos.
  CMin, CMax: real; // Candidato de menor e maior custo.
  Alfa: real; // variável probabilística: 0 Gananciosa| aleatória 1 .
  Restricao: real;
  i, j, k, l, dimensao, escolha: integer;
  atualPosicaoSolucao, atualPosicaoLC, atualPosicaoLRC: integer;
begin
  randomize;
  dimensao := length(Grafo);
  SetLength(solucao, dimensao);
  SetLength(visitado, dimensao);
  SetLength(ListaCandidatos, dimensao);
  SetLength(LRC, dimensao);
  atualPosicaoSolucao := 0;
  atualPosicaoLC := 0;
  atualPosicaoLRC := 0;

  for i := 0 to dimensao - 1 do
  begin
    if Grafo[VerticeInicial][i] <> 0 then
      if visitado[i] <> 1 then
      begin
        ListaCandidatos[atualPosicaoLC] := i;
        inc(atualPosicaoLC);
      end;
  end;
  visitado[VerticeInicial] := 1;
  solucao[atualPosicaoSolucao] := VerticeInicial;

  for i := 0 to dimensao - 2 do
  begin
    Alfa := 0.5;//random;
    CMin := Min(Grafo, ListaCandidatos, solucao[atualPosicaoSolucao],
      atualPosicaoLC);
    CMax := Max(Grafo, ListaCandidatos, solucao[atualPosicaoSolucao],
      atualPosicaoLC);
    Restricao := CMin + (Alfa * (CMax - CMin));
    for j := 0 to atualPosicaoLC - 1 do
    begin
      if Grafo[ListaCandidatos[j]][solucao[atualPosicaoSolucao]] <= Restricao
      then
        if visitado[j] <> 1 then
        begin
          LRC[atualPosicaoLRC] := ListaCandidatos[j];
          inc(atualPosicaoLRC);
        end;
    end;

    if atualPosicaoLRC = 0 then
      for k := 0 to atualPosicaoLC - 1 do
      begin
        if visitado[ListaCandidatos[k]] <> 1 then
        begin
          LRC[atualPosicaoLRC] := ListaCandidatos[k];
          inc(atualPosicaoLRC);
        end;
      end;

    if atualPosicaoLRC = 1 then
      escolha := 0
    else
      escolha := random(atualPosicaoLRC - 1);

    if visitado[LRC[escolha]] <> 1 then
    begin
      inc(atualPosicaoSolucao);
      solucao[atualPosicaoSolucao] := LRC[escolha];
      visitado[LRC[escolha]] := 1;
    end;

    atualPosicaoLC := 0;
    atualPosicaoLRC := 0;
    LimparLista(ListaCandidatos);
    LimparLista(LRC);

    for l := 0 to dimensao - 1 do
    begin
      if Grafo[solucao[atualPosicaoSolucao]][l] <> 0 then
        if visitado[l] <> 1 then
        begin
          ListaCandidatos[atualPosicaoLC] := l;
          inc(atualPosicaoLC);
        end;
    end;
  end;
  Result := solucao;
end;

function Max(AGrafo: TMatriz; ALista: TVizinhanca;
  AVertice, ADimensaoLista: integer): real;
var
  maior: real;
  i: integer;
begin
  maior := 0;
  for i := 0 to ADimensaoLista - 1 do
    if AGrafo[ALista[i]][AVertice] > maior then
      maior := AGrafo[ALista[i]][AVertice];
  Result := maior;
end;

function Min(AGrafo: TMatriz; ALista: TVizinhanca;
  AVertice, ADimensaoLista: integer): real;
var
  menor: real;
  i: integer;
begin
  menor := MaxInt;
  for i := 0 to ADimensaoLista - 1 do
    if AGrafo[ALista[i]][AVertice] <> 0 then
      if AGrafo[ALista[i]][AVertice] < menor then
        menor := AGrafo[ALista[i]][AVertice];
  Result := menor;
end;

procedure ImprimirCiclo(ASolucao: TVizinhanca);
var
  i: integer;
begin
  for i := 0 to length(ASolucao) - 1 do
  begin
    write(intTOstr(ASolucao[i]) + ' ');
  end;
  writeln;
end;

function CustoSolucao(AGrafo: TMatriz; ASolucao: TVizinhanca): real;
var
  i: integer;
  custo: real;
begin
  custo := 0;
  for i := 1 to length(ASolucao) - 1 do
    custo := custo + AGrafo[ASolucao[i - 1]][ASolucao[i]];
  Result := custo;
end;

{ 2-optSwap }
function Troca(ASolucao: TVizinhanca; inicio, fim: integer): TVizinhanca;
var
  i, j, k: integer;
  indiceResultado: integer;
begin
indiceResultado:= 0;
  SetLength(Result, length(ASolucao));
  for i := 0 to inicio - 1 do
  begin
    Result[indiceResultado] := ASolucao[i];
    inc(indiceResultado);
  end;
  for j := fim downto inicio do
  begin
    Result[indiceResultado] := ASolucao[j];
    inc(indiceResultado);
  end;
  for k := fim + 1 to length(ASolucao) - 1 do
  begin
    Result[indiceResultado] := ASolucao[k];
    inc(indiceResultado);
  end;
end;

{ 2-opt }
function BuscaLocal(AGrafo: TMatriz; ASolucao: TVizinhanca): TVizinhanca;
var
  melhorCusto, novoCusto: real;
  intervaloTroca, j, k: integer;
begin
  melhorCusto := CustoSolucao(AGrafo, ASolucao);
  intervaloTroca := length(ASolucao);
  for j := 1 to intervaloTroca - 1 do
    for k := j + 1 to intervaloTroca - 1 do
    begin
      Result := Troca(ASolucao, j, k);
      novoCusto := CustoSolucao(AGrafo, Result);
      if novoCusto < melhorCusto then
      begin
        ASolucao := Result;
        melhorCusto := novoCusto;
      end;
    end;
  Result := ASolucao;
end;

procedure LimparLista(var ALista: TVizinhanca);
var
  i: integer;
begin
  for i := 0 to length(ALista) - 1 do
    ALista[i] := 0;
end;

end.
